#!/usr/bin/env node
// Encrypts the private pages into web/vault.json.
//
//   node tool/vault.js private/pages.json <passcode>
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
// The output is a single AES-256-GCM blob with a PBKDF2 salt beside it, which
// the build copies to the site root and the passcode page fetches. Node's own
// crypto module does all of it, so there is nothing to install.
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

const [input, passcode] = process.argv.slice(2);
if (!input || !passcode) {
  console.error('usage: node tool/vault.js <pages.json> <passcode>');
  process.exit(1);
}

const source = JSON.parse(fs.readFileSync(input, 'utf8'));

// Photographs are named by path in the source and carried as base64 in the
// blob, so they are encrypted alongside the words. A file in web/ would be
// served to anyone who guessed its name, which is the one thing this is for.
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

const plaintext = JSON.stringify(source);

const salt = crypto.randomBytes(16);
const iv = crypto.randomBytes(12);
const key = crypto.pbkdf2Sync(passcode, salt, ITERATIONS, 32, 'sha256');

const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
const body = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);

// Web Crypto expects the tag appended to the ciphertext; Node keeps it apart.
const data = Buffer.concat([body, cipher.getAuthTag()]);

const out = path.join(__dirname, '..', 'web', 'vault.json');
fs.writeFileSync(
  out,
  JSON.stringify({
    v: 1,
    iterations: ITERATIONS,
    salt: salt.toString('base64'),
    iv: iv.toString('base64'),
    data: data.toString('base64'),
  }),
);

const pages = source.pages?.length ?? 0;
const kb = (n) => `${(n / 1024).toFixed(0)} KB`;
console.log(
  `${out}  ${pages} page(s)  ${kb(data.length)} of ciphertext` +
    (embedded ? `  (${kb(embedded)} of it photographs)` : ''),
);
