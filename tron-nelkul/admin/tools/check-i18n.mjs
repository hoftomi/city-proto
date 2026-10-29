// Checks that every translation key used in src/app (outside the generated api/) exists in the backend's
// admin namespace (../backend/src/main/resources/i18n/hu/admin.json), and lists unused keys.
// Keys are found as: 'k' | t, (c ? 'a' : 'b') | t, t('k'), key('k'), info('k'), title/message/confirm: 'k'.
// Exit code 1 on missing keys.
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { dirname, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const jsonPath = join(root, '../backend/src/main/resources/i18n/hu/admin.json');
const srcDir = join(root, 'src/app');

const K = String.raw`'([A-Za-z0-9_]+(?:\.[A-Za-z0-9_]+)+)'`;
const patterns = [
  new RegExp(`${K}\\s*\\|\\s*t\\b`, 'g'),
  new RegExp(`\\?\\s*${K}\\s*:\\s*${K}\\s*\\)\\s*\\|\\s*t\\b`, 'g'),
  new RegExp(`\\b(?:t|key|info)\\(\\s*${K}`, 'g'),
  new RegExp(`\\b(?:title|message|confirm):\\s*${K}`, 'g'),
];

function files(dir) {
  return readdirSync(dir).flatMap((name) => {
    const p = join(dir, name);
    if (statSync(p).isDirectory()) return p === join(srcDir, 'api') ? [] : files(p);
    return /\.(ts|html)$/.test(name) && !name.endsWith('.spec.ts') ? [p] : [];
  });
}

function leaves(obj, prefix = '') {
  return Object.entries(obj).flatMap(([k, v]) =>
    v && typeof v === 'object' ? leaves(v, `${prefix}${k}.`) : [`${prefix}${k}`],
  );
}

const defined = new Set(leaves(JSON.parse(readFileSync(jsonPath, 'utf8'))));
const used = new Map();
for (const file of files(srcDir)) {
  const text = readFileSync(file, 'utf8');
  for (const re of patterns) {
    for (const m of text.matchAll(re)) {
      for (const k of m.slice(1).filter(Boolean)) {
        if (!used.has(k)) used.set(k, relative(root, file));
      }
    }
  }
}

const missing = [...used].filter(([k]) => !defined.has(k));
const unused = [...defined].filter((k) => !used.has(k));
console.log(`admin.json: ${defined.size} keys, ${used.size} used in src/app`);
if (unused.length) console.log(`unused: ${unused.join(', ')}`);
if (missing.length) {
  console.error('MISSING:');
  for (const [k, f] of missing) console.error(`  ${k}  (${f})`);
  process.exit(1);
}
console.log('OK: every used key exists');
