// A Krónika IV design system rajzainak exportja a Flutter apphoz.
//
// Forrás: ../../../prototype-kronika4/src (a design system ES-modul változata, tokenek, CSS, a Délkelet domborzata)
// és a backend térképei (MapRegistry.java). Kimenet: ../../assets/k4/
//   icons/<név>.svg        játékikonok (GameIcon), a tokenek beégetve
//   login.svg              a belépőkép
//   map/<térkép>.webp      a világtérkép domborzata iránytűvel és kartussal, városok és utak nélkül (360 × 260, 8×)
//   cities/<város>_on.webp / _off.webp   a térkép vára felirattal, elérhető és nem elérhető állapotban (8×)
//   estates/<tinktúra>.webp, <tinktúra>_npc.webp   birtok (8×)
//   cityview/<város>.webp  az izometrikus városkép (720 × 540, 3×), kijelölés nélkül
//   k4.json                méretek, a várak és birtokok horgonypontja, a negyedek koppintható sokszögei
//
// Futtatás: npm install && npm run export   (Google Chrome és cwebp kell; a betűk a Google Fontsról töltődnek)
// Csak egyes részek: ONLY=icons,login,maps,cities,estates,cityview npm run export (a többi kimenet megmarad)
import { build } from 'esbuild';
import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const PROTO = path.resolve(here, '../../../prototype-kronika4/src');
const REGISTRY = path.resolve(here, '../../../tron-nelkul/backend/src/main/java/com/hof/tronnelkul/game/world/MapRegistry.java');
const OUT = path.resolve(here, '../../assets/k4');
const CHROME = process.env.CHROME || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const TMP = fs.mkdtempSync(path.join(os.tmpdir(), 'k4-'));

// ---------- A prototípus moduljai (JSX nélkül is: esbuild köti össze) ----------
try { fs.symlinkSync(path.join(here, 'node_modules'), path.join(TMP, 'node_modules'), 'dir'); } catch { /* már megvan */ }
const load = async (entry) => {
  const file = path.join(TMP, path.basename(entry).replace(/\W/g, '_') + '.mjs');
  await build({ entryPoints: [entry], bundle: true, format: 'esm', platform: 'node', outfile: file, jsx: 'automatic', loader: { '.js': 'jsx' },
    external: ['react', 'react-dom', 'react/jsx-runtime'], logLevel: 'error' });
  return import(file);
};
const React = (await import('react')).default;
const { renderToStaticMarkup } = await import('react-dom/server');
const h = React.createElement;
const T = (await load(path.join(PROTO, 'ds/index.js'))).default;
const { TERRAIN: DELKELET_TERRAIN } = await load(path.join(PROTO, 'game/world.js'));
const { default: LoginScreen } = await load(path.join(PROTO, 'lobby/LoginScreen.jsx'));
const render = (el) => renderToStaticMarkup(el);

// ---------- Tokenek: a var(--x) értékek beégetése a statikus SVG-kbe ----------
const tokensCss = fs.readFileSync(path.join(PROTO, 'ds/tokens.css'), 'utf8');
const componentsCss = fs.readFileSync(path.join(PROTO, 'ds/components.css'), 'utf8');
const TOK = {};
for (const m of tokensCss.matchAll(/--([\w-]+):\s*([^;]+);/g)) TOK[m[1]] = m[2].trim();
function resolveVars(s) {
  for (let i = 0; i < 5 && s.includes('var(--'); i++) s = s.replace(/var\(--([\w-]+)(?:,\s*([^()]+))?\)/g, (_, n, fb) => TOK[n] ?? fb ?? '#000');
  return s;
}

// ---------- A backend térképei ----------
function parseRegistry(src) {
  const maps = [];
  for (const part of src.split('new MapDefinition(').slice(1)) {
    const [, id, name] = part.match(/^"(\w+)", "([^"]+)"/);
    const cities = [...part.matchAll(/new CityDef\("(\w+)", "([^"]+)", (\d+), (\d+), (true|false), (true|false), "([^"]+)"/g)]
      .map(([, cid, cname, x, y, key, coast, profile]) => ({ id: cid, name: cname, x: +x, y: +y, key: key === 'true', coast: coast === 'true', profile }));
    const edgePart = part.slice(part.indexOf('List.of(List.of('), part.indexOf('new StartSlot'));
    const edges = [...edgePart.matchAll(/List\.of\("(\w+)", "(\w+)"\)/g)].map(([, a, b]) => [a, b]);
    const starts = [...part.matchAll(/new StartSlot\("(\w+)", "([^"]+)", (\d+), (\d+), List\.of\(([^)]*)\)/g)]
      .map(([, sid, sname, x, y, nb]) => ({ id: sid, name: sname, x: +x, y: +y, neighbors: [...nb.matchAll(/"(\w+)"/g)].map((m) => m[1]) }));
    const t = part.slice(part.indexOf('new TerrainDef(') + 'new TerrainDef('.length);
    const sea = t.startsWith('null') ? undefined : t.match(/^"([^"]*)"/)[1];
    const lists = []; let depth = 0, cur = null;
    for (let i = t.indexOf(','); i < t.length; i++) {
      if (t.startsWith('List.of(', i) && depth === 0) { cur = ''; depth = 1; i += 7; continue; }
      if (depth > 0) { const c = t[i]; if (c === '(') depth++; if (c === ')') depth--; if (depth === 0) { lists.push(cur); cur = null; if (lists.length === 5) break; } else cur += c; }
    }
    const nums = (s) => [...s.matchAll(/p\(([^)]*)\)/g)].map((m) => m[1].split(',').map(Number));
    const terrain = { sea, rivers: [...lists[0].matchAll(/"([^"]+)"/g)].map((m) => m[1]), mountains: nums(lists[1]), forests: nums(lists[2]), fields: nums(lists[3]), marsh: nums(lists[4]) };
    maps.push({ id, name, cities, edges, starts, terrain: id === 'delkelet' ? DELKELET_TERRAIN : terrain });
  }
  return maps;
}
const MAPS = parseRegistry(fs.readFileSync(REGISTRY, 'utf8'));

// ---------- Képkészítés headless Chrome-mal ----------
const FONTS = componentsCss.match(/@import[^;]+;/g)?.join('\n') || '';
function page(svg, w, h, bg = 'transparent') {
  return `<!doctype html><html><head><meta charset="utf-8"><style>${FONTS}\n${tokensCss}\n${componentsCss.replace(/@import[^;]+;/g, '')}
    html,body{margin:0;padding:0;background:${bg};width:${w}px;height:${h}px;overflow:hidden}
    svg.tn-map,svg.tn-city-view,svg.k4{display:block;width:${w}px;height:${h}px;border:0!important;border-radius:0!important;box-shadow:none!important;background:transparent}
  </style></head><body>${svg}</body></html>`;
}
function shoot(svg, w, h, scale, out, { bg, quality = 82 } = {}) {
  const html = path.join(TMP, 'p.html'), png = path.join(TMP, 'p.png');
  fs.writeFileSync(html, page(svg, w, h, bg));
  execFileSync(CHROME, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--default-background-color=00000000', `--force-device-scale-factor=${scale}`,
    `--window-size=${w},${h}`, '--virtual-time-budget=6000', `--screenshot=${png}`, 'file://' + html], { stdio: 'ignore' });
  fs.mkdirSync(path.dirname(out), { recursive: true });
  execFileSync('cwebp', ['-quiet', '-q', String(quality), '-alpha_q', '90', png, '-o', out]);
}

// A térképvászon <defs> része (színátmenetek, elmosás), hogy a különálló várak és birtokok is ugyanúgy nézzenek ki
const canvasDefs = (render(h(T.MapCanvas, { width: 360, height: 260 })).match(/<defs>[\s\S]*?<\/defs>/g) || []).join('');
const sprite = (inner, box) => `<svg class="k4 tn-map" xmlns="http://www.w3.org/2000/svg" viewBox="${box.join(' ')}">${canvasDefs}${inner}</svg>`;

const ONLY = process.env.ONLY ? new Set(process.env.ONLY.split(',')) : null;
const want = (part) => !ONLY || ONLY.has(part);
if (!ONLY) fs.rmSync(OUT, { recursive: true, force: true });
fs.mkdirSync(OUT, { recursive: true });
const metaFile = path.join(OUT, 'k4.json');
const meta = Object.assign({ version: 1, maps: {}, districts: null }, ONLY && fs.existsSync(metaFile) ? JSON.parse(fs.readFileSync(metaFile, 'utf8')) : {},
  { map: { width: 360, height: 260, scale: 8 }, cityBox: [-46, -58, 92, 90], estateBox: [-16, -24, 32, 34], cityView: { width: 720, height: 540, scale: 3 } });

// 1. Játékikonok
if (want('icons')) for (const name of T.GameIcon.names) {
  const svg = resolveVars(render(h(T.GameIcon, { name, size: 48 }))).replace(' class="tn-gicon"', ' xmlns="http://www.w3.org/2000/svg"').replace(/ aria-hidden="true"/, '');
  fs.mkdirSync(path.join(OUT, 'icons'), { recursive: true });
  fs.writeFileSync(path.join(OUT, 'icons', name + '.svg'), svg);
}
meta.icons = T.GameIcon.names;
meta.branchOf = T.GameIcon.branchOf;

// 2. Belépőkép
if (want('login')) fs.writeFileSync(path.join(OUT, 'login.svg'), resolveVars(render(h(LoginScreen, { onLogin() {} })).match(/<svg[\s\S]*?<\/svg>/)[0]
  .replace('<svg', '<svg xmlns="http://www.w3.org/2000/svg"')));

// 3. Térképek, várak, birtokok
for (const m of MAPS) {
  const base = render(h(T.MapCanvas, { width: 360, height: 260, title: m.name }, h(T.MapTerrain, m.terrain), h(T.MapCompass, { x: 320, y: 44, size: 20 }),
    h(T.MapCartouche, { x: 8, y: 212, width: 120, title: m.name.toUpperCase() })));
  if (want('maps')) shoot(base, 360, 260, meta.map.scale, path.join(OUT, 'map', m.id + '.webp'), { quality: 80 });
  if (want('cities')) for (const c of m.cities) {
    for (const [suffix, state] of [['on', 'reachable'], ['off', 'unreachable']]) {
      const box = [c.x + meta.cityBox[0], c.y + meta.cityBox[1], meta.cityBox[2], meta.cityBox[3]];
      shoot(sprite(render(h(T.MapCity, { x: c.x, y: c.y, name: c.name, keyCity: c.key, state })), box), meta.cityBox[2], meta.cityBox[3], meta.map.scale,
        path.join(OUT, 'cities', `${c.id}_${suffix}.webp`));
    }
  }
  meta.maps[m.id] = { name: m.name, cities: m.cities.map(({ id, name, x, y, key, coast }) => ({ id, name, x, y, key, coast })), edges: m.edges, starts: m.starts };
  console.log('térkép kész:', m.id);
}
if (want('estates')) for (const t of ['voros', 'kek', 'zold', 'arany', 'bibor', 'fekete', 'narancs', 'szeder']) {
  for (const npc of [false, true]) {
    shoot(sprite(render(h(T.MapEstate, { x: 0, y: 0, tincture: t, npc })), meta.estateBox), meta.estateBox[2], meta.estateBox[3], meta.map.scale,
      path.join(OUT, 'estates', `${t}${npc ? '_npc' : ''}.webp`));
  }
}

// 4. Városképek és a negyedek sokszögei
if (want('cityview')) for (const m of MAPS) for (const c of m.cities) {
  const svg = render(h(T.CityView, { name: c.name, coast: c.coast, stability: 'stabil', districts: {}, onSelect() {} }));
  shoot(svg, 720, 540, meta.cityView.scale, path.join(OUT, 'cityview', c.id + '.webp'), { quality: 78 });
  const districts = {};
  for (const hit of svg.matchAll(/<polygon points="([^"]+)" class="tn-cv-hit"[^>]*aria-label="([^"]+)"/g)) {
    const pts = hit[1].trim().split(/\s+/).map((p) => p.split(',').map(Number));
    districts[hit[2]] = pts;
  }
  const labels = Object.fromEntries([...svg.matchAll(/<text x="([\d.]+)" y="([\d.]+)"[^>]*class="tn-cv-label">([^<]+)</g)].map(([, x, y, n]) => [n, [+x, +y]]));
  const d = { polygons: districts, labels };
  if (c === MAPS[0].cities[0]) { meta.districts = null; delete meta.cityDistricts; }
  if (meta.districts && JSON.stringify(meta.districts) !== JSON.stringify(d)) (meta.cityDistricts ||= {})[c.id] = d;
  meta.districts ||= d;
  console.log('városkép kész:', c.id);
}

fs.writeFileSync(path.join(OUT, 'k4.json'), JSON.stringify(meta, null, 1));
fs.rmSync(TMP, { recursive: true, force: true });
console.log('Kész:', OUT);
