// Hamis lobbi-adatok a prototípushoz.
import { TERRAIN } from '../game/world.js';

export const PROVIDERS = [
  { id: 'google', label: 'Folytatás Google-fiókkal', mark: 'G' },
  { id: 'apple', label: 'Folytatás Apple-fiókkal', mark: 'A' },
  { id: 'discord', label: 'Folytatás Discord-fiókkal', mark: 'D' },
];

// Háttértípusok (szabálykönyv v0.2, 2.2). Csak induló bónuszt adnak, egyik ágba sem zárnak be.
export const BACKGROUNDS = [
  { id: 'kereskedo', name: 'Kereskedőház', icon: 'kereskedok', perks: ['20 részesedés a kezdőváros egyik árucikkéből', 'Azonnal van eladható árud'] },
  { id: 'nemesi', name: 'Nemesi ház', icon: 'nemesseg', perks: ['Megalapított párt a kezdővárosban', '+10 népszerűség a kezdővárosban'] },
  { id: 'arnyek', name: 'Árnyékrend', icon: 'hidden', perks: ['2 felfogadott kém a kezdővárosban', 'Az első naptól látsz a rivális parancslapokba'] },
];

export const TINCTURES = [
  { id: 'voros', name: 'Vörös' }, { id: 'kek', name: 'Kék' }, { id: 'zold', name: 'Zöld' }, { id: 'arany', name: 'Arany' },
  { id: 'bibor', name: 'Bíbor' }, { id: 'fekete', name: 'Fekete' }, { id: 'narancs', name: 'Narancs' }, { id: 'szeder', name: 'Szeder' },
];

const HILLS = {
  sea: null,
  rivers: ['M40 200C90 170 120 190 160 150C190 120 230 130 300 90C320 80 340 60 360 50'],
  mountains: [[60, 50, 1.1], [84, 40, 1.3], [110, 52, 1], [230, 40, 1.2], [254, 30, 1.4], [280, 46, 1], [300, 200, 1.1], [322, 214, 0.9], [140, 230, 0.9]],
  forests: [[40, 120, 8], [200, 190, 7], [310, 130, 5]],
  fields: [[120, 90, 30, 16, 6]],
  marsh: [],
};
const SALT = {
  sea: 'M0 190C60 180 90 210 140 200C200 188 240 220 300 206C330 200 350 214 360 210V260H0Z',
  rivers: ['M200 20C196 60 220 90 210 130C204 160 220 180 230 205'],
  mountains: [[300, 40, 1], [322, 52, 0.8]],
  forests: [[70, 80, 6], [260, 110, 6]],
  fields: [[120, 40, 34, 18, -4], [40, 140, 30, 16, 6], [280, 150, 30, 16, -8]],
  marsh: [[110, 170, 5]],
};

export const MAPS = {
  delkelet: { terrain: TERRAIN, cities: [[70, 72, 'Szélmező'], [205, 56, 'Vaskapu'], [238, 122, 'Feketerév', true], [205, 208, 'Holtág'], [95, 190, 'Délkapu']], starts: [] },
  kodos: {
    terrain: HILLS,
    cities: [[70, 90, 'Ködvár', true], [170, 70, 'Sziklaszirt'], [290, 100, 'Farkasrév'], [110, 170, 'Ezüstpatak'], [240, 170, 'Hármaskút'], [180, 230, 'Mélyvölgy']],
    starts: [
      { id: 'nyugat', name: 'Nyugati erdőség', x: 24, y: 150, near: ['Ködvár', 'Ezüstpatak'], note: 'Két gyenge, Ingatag város. Csendes kezdés.' },
      { id: 'hago', name: 'Hágó alatt', x: 180, y: 130, near: ['Sziklaszirt', 'Hármaskút'], note: 'A térkép közepe: sok lehetőség, sok rivális.' },
      { id: 'kelet', name: 'Keleti fennsík', x: 330, y: 160, near: ['Farkasrév', 'Hármaskút'], note: 'Erős katonai városok a közelben.' },
    ],
  },
  so: {
    terrain: SALT,
    cities: [[60, 50, 'Sóhegy'], [170, 110, 'Kalmárrév', true], [300, 70, 'Tornyos'], [90, 150, 'Sósvíz'], [250, 170, 'Délirév']],
    starts: [
      { id: 'bany', name: 'Bányavidék', x: 120, y: 30, near: ['Sóhegy', 'Kalmárrév'], note: 'Közel a kulcsvároshoz. Erős Kereskedők.' },
      { id: 'part', name: 'Nyugati part', x: 30, y: 110, near: ['Sóhegy', 'Sósvíz'], note: 'Két kisváros, nyugodt partvidék.' },
      { id: 'torony', name: 'Tornyos-völgy', x: 330, y: 130, near: ['Tornyos', 'Délirév'], note: 'Távol a központtól, de védett.' },
    ],
  },
};

// A kezdés relatív napokban van megadva, hogy a prototípus mindig „friss” legyen.
export const GAMES = [
  { id: 'delkelet', name: 'Délkelet', season: '1. szezon', status: 'fut', map: 'delkelet', day: 3, days: 14, players: 24, max: 30, cities: 5, npc: 4, speed: '2 kör / nap', tags: ['Kezdőbarát'], joined: true, house: 'Kékholló' },
  { id: 'kodos', name: 'Ködös Hegyvidék', season: 'Őszi szezon', status: 'nyitott', map: 'kodos', startsIn: 2, days: 14, players: 18, max: 30, cities: 6, npc: 3, speed: '2 kör / nap', tags: ['Kezdőbarát', 'Erős NPC-k'], taken: ['kek', 'zold', 'arany'] },
  { id: 'so', name: 'Sóvidék ligája', season: 'Liga · 1. forduló', status: 'nyitott', map: 'so', startsIn: 5, days: 30, players: 9, max: 40, cities: 5, npc: 2, speed: '2 kör / nap', tags: ['Szövetségek', 'Rejtett befolyás'], taken: ['fekete'] },
  { id: 'villam', name: 'Villámszezon', season: 'Gyors játék', status: 'nyitott', map: 'kodos', startsIn: 1, days: 7, players: 28, max: 30, cities: 6, npc: 1, speed: '3 kör / nap', tags: ['Gyors', 'Tapasztaltaknak'], taken: ['voros', 'kek', 'zold', 'arany', 'bibor', 'fekete'] },
  { id: 'tavasz', name: 'Tavaszi bajnokság', season: 'Bajnokság', status: 'hamarosan', map: 'so', opensIn: 12, days: 45, players: 0, max: 60, cities: 5, npc: 2, speed: '2 kör / nap', tags: ['Rangsorolt'] },
  { id: 'nyar', name: 'Nyári szezon', season: '0. szezon (teszt)', status: 'lezarult', map: 'delkelet', days: 14, players: 30, max: 30, cities: 5, npc: 4, speed: '2 kör / nap', tags: [], winner: 'Ezüstpart-ház (NPC)', place: 7 },
];

export function dayLabel(n) { return n === 0 ? 'ma' : n === 1 ? 'holnap' : `${n} nap múlva`; }
export function dateIn(n) {
  const d = new Date(); d.setDate(d.getDate() + n); d.setHours(20, 0, 0, 0);
  return d.toLocaleDateString('hu-HU', { month: 'long', day: 'numeric', weekday: 'long' }) + ', 20:00';
}
