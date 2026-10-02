#!/usr/bin/env node
// Encrypts the private pages into web/vault.json.
//
//   node tool/vault.js private/a.json private/b.json
//
// One argument per document, and the tool asks for each document's passcode
// with the typing hidden. Press Enter on an empty prompt and it draws a random
// code instead and shows it once — write it down, it is not stored anywhere.
// Piped input works too, one code per line in document order:
//
//   printf '%s\n' "$CODE_A" "$CODE_B" | node tool/vault.js a.json b.json
//
// **Codes are never arguments.** They used to be, and an argument lands in
// shell history, in `ps`, and in any transcript of the terminal it was typed
// into. Run this in a terminal of your own rather than through an assistant's
// shell, for the same reason.
//
// Every document has to be named on the one command line — the file is
// written whole each time, so a run that names one document leaves the site
// with one page. Each becomes a compartment, and the gate opens whichever one
// the code belongs to.
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
// the length of the code is what turns that into protection. Six digits fell
// to a laptop in about an hour, which is why LENGTH is twelve. Keep nothing
// here that would genuinely hurt to lose.

const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

// OWASP's floor for PBKDF2-HMAC-SHA256. Native in both Node and the browser,
// so unlocking stays well under a second for the person who knows the code.
const ITERATIONS = 600000;

// Digits only, because the gate is a keypad. Must match `PasscodePage.length`;
// test/vault_tool_test.dart reads this line to make sure it does.
const LENGTH = 12;

const inputs = process.argv.slice(2);
if (inputs.length === 0) {
  console.error('usage: node tool/vault.js <pages.json> [<pages.json> ...]');
  process.exit(1);
}
for (const input of inputs) {
  if (!fs.existsSync(input)) {
    console.error(
      `${input}: no such file. Passcodes are not arguments any more — ` +
        'the tool asks for them.',
    );
    process.exit(1);
  }
}

const valid = (code) => new RegExp(`^\\d{${LENGTH}}$`).test(code);

// Reads a line from the terminal without echoing it.
const askHidden = (question) =>
  new Promise((resolve) => {
    const stdin = process.stdin;
    process.stderr.write(question);
    stdin.setRawMode(true);
    stdin.setEncoding('utf8');
    stdin.resume();
    let value = '';
    const finish = () => {
      stdin.removeListener('data', onData);
      stdin.setRawMode(false);
      stdin.pause();
      process.stderr.write('\n');
      resolve(value);
    };
    const onData = (chunk) => {
      for (const ch of chunk) {
        if (ch === '\r' || ch === '\n') return finish();
        if (ch === '\u0003') {
          stdin.setRawMode(false);
          process.stderr.write('\n');
          process.exit(130);
        }
        if (ch === '\u007f' || ch === '\b') value = value.slice(0, -1);
        else value += ch;
      }
    };
    stdin.on('data', onData);
  });

const generate = () =>
  Array.from({ length: LENGTH }, () => crypto.randomInt(10)).join('');

const askCode = async (input) => {
  for (;;) {
    const code = await askHidden(
      `${input}  code (${LENGTH} digits, Enter to generate): `,
    );
    if (code === '') {
      const drawn = generate();
      process.stderr.write(`  generated: ${drawn}\n`);
      return drawn;
    }
    if (!valid(code)) {
      process.stderr.write(`  needs exactly ${LENGTH} digits\n`);
      continue;
    }
    if ((await askHidden('  again: ')) === code) return code;
    process.stderr.write('  they did not match\n');
  }
};

const readCodes = async () => {
  if (!process.stdin.isTTY) {
    const lines = fs
      .readFileSync(0, 'utf8')
      .split(/\r?\n/)
      .filter((line) => line !== '');
    if (lines.length !== inputs.length) {
      console.error(
        `expected ${inputs.length} code(s) on stdin, got ${lines.length}`,
      );
      process.exit(1);
    }
    return lines;
  }
  const codes = [];
  for (const input of inputs) codes.push(await askCode(input));
  return codes;
};

const main = async () => {
  const codes = await readCodes();
  const bad = codes.findIndex((code) => !valid(code));
  if (bad !== -1) {
    console.error(`${inputs[bad]}: the code needs exactly ${LENGTH} digits`);
    process.exit(1);
  }

  const pairs = inputs.map((input, i) => ({ input, passcode: codes[i] }));

  // Two documents behind one passcode would mean the gate could open either
  // and no way to say which, so the codes have to be distinct. Catching it
  // here beats finding out when the wrong page opens.
  if (new Set(codes).size !== codes.length) {
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
};

main();
