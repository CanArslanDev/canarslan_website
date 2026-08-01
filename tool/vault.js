#!/usr/bin/env node
// Encrypts the private pages into web/vault.json.
//
//   node tool/vault.js private/pages.json <passcode>
//   node tool/vault.js private/a.json <code> private/b.json <other code>
//
// Arguments come in pairs: a document, and the passcode that opens it. Each
// pair becomes a compartment, and the gate opens whichever one the code
// belongs to. **Every pair has to be on the one command line** — the file is
// written whole each time, so a run that names one document leaves the site
// with one page.
//
// The input is a file you keep locally and never commit; `private/` is in
// .gitignore. It looks like this:
//
//   {
//     "pages": [{
//       "title": "…",              // only shown if there are several pages
//       "field": "ripple",         // vortex | wave | scan | ripple | omit
//       "blocks": [
//         { "type": "eyebrow", "text": "…" },
//         { "type": "heading", "text": "…", "weight": "mass" },
//         { "type": "text",    "text": "…" },
//         { "type": "rule" },
//         { "type": "spec",    "entries": [["label", "value"]] },
//         { "type": "image",   "file": "photo.jpg" },
//         { "type": "gallery", "files": ["a.jpg", "b.jpg"] },
//         { "type": "gap",     "size": 48 }
//       ]
//     }]
//   }
//
// Image paths are relative to the source file and get read in and encrypted
// with everything else.
//
// The output is one AES-256-GCM blob per pair, sharing a single PBKDF2 salt,
// which the build copies to the site root and the passcode page fetches. Node's
// own crypto module does all of it, so there is nothing to install.
//
// One salt for the file rather than one per compartment, so the gate derives a
// key once however many pages there are. Two passcodes over one salt derive two
// unrelated keys, and the salt still does its real job of making this file's
// work useless against any other.
//
// What this protects, and what it does not: the blob is served to anyone who
// asks for it, so the only thing standing between a reader and the contents is
// the passcode. The iteration count below makes each guess cost real time, but
// a six-digit code is a million guesses and dedicated hardware will get there.
// Keep nothing here that would genuinely hurt to lose, and prefer a longer
// code to a shorter one — the page reads its length from one constant.

const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

// OWASP's floor for PBKDF2-HMAC-SHA256. Native in both Node and the browser,
// so unlocking stays well under a second for the person who knows the code.
const ITERATIONS = 600000;

const args = process.argv.slice(2);
if (args.length === 0 || args.length % 2 !== 0) {
  console.error(
    'usage: node tool/vault.js <pages.json> <passcode> [<pages.json> <passcode> ...]',
  );
  process.exit(1);
}

const pairs = [];
for (let i = 0; i < args.length; i += 2) {
  pairs.push({ input: args[i], passcode: args[i + 1] });
}

// Two documents behind one passcode would mean the gate could open either and
// no way to say which, so the codes have to be distinct. Catching it here
// beats finding out when the wrong page opens.
const codes = new Set(pairs.map((p) => p.passcode));
if (codes.size !== pairs.length) {
  console.error('two compartments share a passcode; each one needs its own');
  process.exit(1);
}

// One salt for the whole file: the gate derives its key once and then tries
// each compartment, so adding a page costs the person entering a code nothing.
const salt = crypto.randomBytes(16);

const kb = (n) => `${(n / 1024).toFixed(0)} KB`;

const seal = ({ input, passcode }) => {
  const source = JSON.parse(fs.readFileSync(input, 'utf8'));

  // Files are named by path in the source and carried as base64 in the blob,
  // so they are encrypted alongside the words. A file in web/ would be served
  // to anyone who guessed its name, which is the one thing this is for.
  let embedded = 0;
  const inline = (file) => {
    const bytes = fs.readFileSync(path.resolve(path.dirname(input), file));
    embedded += bytes.length;
    return bytes.toString('base64');
  };

  // Anywhere in the document: { "file": "x.png" } becomes { "data": "<b64>" },
  // and { "files": [...] } becomes { "images": [...] }.
  const walk = (node) => {
    if (Array.isArray(node)) return node.forEach(walk);
    if (!node || typeof node !== 'object') return;
    if (typeof node.file === 'string') {
      node.data = inline(node.file);
      delete node.file;
    }
    if (Array.isArray(node.files)) {
      node.images = node.files.map(inline);
      delete node.files;
    }
    Object.values(node).forEach(walk);
  };
  walk(source);

  const iv = crypto.randomBytes(12);
  const key = crypto.pbkdf2Sync(passcode, salt, ITERATIONS, 32, 'sha256');

  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
  const body = Buffer.concat([
    cipher.update(JSON.stringify(source), 'utf8'),
    cipher.final(),
  ]);

  // Web Crypto expects the tag appended to the ciphertext; Node keeps it apart.
  const data = Buffer.concat([body, cipher.getAuthTag()]);

  return { iv, data, embedded, pages: source.pages?.length ?? 0 };
};

const compartments = pairs.map(seal);

const out = path.join(__dirname, '..', 'web', 'vault.json');
fs.writeFileSync(
  out,
  JSON.stringify({
    v: 2,
    iterations: ITERATIONS,
    salt: salt.toString('base64'),
    vaults: compartments.map((c) => ({
      iv: c.iv.toString('base64'),
      data: c.data.toString('base64'),
    })),
  }),
);

const total = compartments.reduce((sum, c) => sum + c.data.length, 0);
console.log(`${out}  ${compartments.length} compartment(s)  ${kb(total)}`);
compartments.forEach((c, i) => {
  console.log(
    `  ${i + 1}. ${pairs[i].input}  ${kb(c.data.length)}` +
      (c.embedded ? `  (${kb(c.embedded)} embedded)` : ''),
  );
});
