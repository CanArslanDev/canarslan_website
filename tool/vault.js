#!/usr/bin/env node
// Encrypts the private pages into web/vault.json.
//
//   node tool/vault.js private/pages.json <passcode>
//
// The input is a file you keep locally and never commit; `private/` is in
// .gitignore. It looks like this:
//
//   { "pages": [ { "title": "…", "body": ["paragraph", "paragraph"] } ] }
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

const plaintext = fs.readFileSync(input, 'utf8');
JSON.parse(plaintext); // fail here rather than in the browser

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

const pages = JSON.parse(plaintext).pages?.length ?? 0;
console.log(`${out}  ${pages} page(s)  ${data.length} bytes of ciphertext`);
