// Példavilág a v0.2 prototípushoz: a „Délkelet” régió öt városa, árucikkekkel.

export const HOUSES = {
  te: { id: 'te', name: 'Kékholló', tincture: 'kek', initial: 'K', npc: false, background: 'kereskedo' },
  ezust: { id: 'ezust', name: 'Ezüstpart-ház', tincture: 'arany', initial: 'E', npc: true, persona: 'kalmar' },
  tolgy: { id: 'tolgy', name: 'Ősi Tölgy', tincture: 'zold', initial: 'Ö', npc: true, persona: 'politikus' },
  arny: { id: 'arny', name: 'Bíbor Kéz', tincture: 'bibor', initial: 'B', npc: true, persona: 'kem' },
  varju: { id: 'varju', name: 'Varjúvár', tincture: 'fekete', initial: 'V', npc: true, persona: 'felvasarlo' },
};

export const NODES = {
  birtok: { id: 'birtok', name: 'Birtokod', x: 28, y: 125, estate: 'te' },
  ezustbirtok: { id: 'ezustbirtok', name: 'Ezüstpart', x: 160, y: 238, estate: 'ezust' },
  szelmezo: { id: 'szelmezo', name: 'Szélmező', x: 70, y: 72, city: true, profile: 'Gabonavidék' },
  vaskapu: { id: 'vaskapu', name: 'Vaskapu', x: 205, y: 56, city: true, profile: 'Bányaváros' },
  feketerev: { id: 'feketerev', name: 'Feketerév', x: 238, y: 122, city: true, profile: 'Kikötőváros', key: true, coast: true },
  holtag: { id: 'holtag', name: 'Holtág', x: 205, y: 208, city: true, profile: 'Csempészváros' },
  delkapu: { id: 'delkapu', name: 'Délkapu', x: 95, y: 190, city: true, profile: 'Határváros' },
};

export const EDGES = [
  ['birtok', 'szelmezo'], ['birtok', 'delkapu'], ['szelmezo', 'feketerev'], ['szelmezo', 'vaskapu'],
  ['vaskapu', 'feketerev'], ['feketerev', 'holtag'], ['delkapu', 'holtag'], ['ezustbirtok', 'holtag'], ['ezustbirtok', 'delkapu'],
];

export const TERRAIN = {
  sea: 'M252 0C240 40 268 72 254 110C240 148 282 172 300 204C316 232 292 248 298 260H360V0Z',
  rivers: [
    { d: 'M168 36C176 60 206 70 216 90C224 104 238 100 257 98', w: 3.6 },
    { d: 'M132 44C128 70 150 96 146 124C142 152 150 178 170 200C182 214 184 232 200 244C220 258 262 256 296 250', w: 3.2 },
    { d: 'M74 154C92 160 116 158 132 150C140 146 144 140 146 132', w: 2 },
  ],
  bridges: [[184.2, 58.5, -7], [226.5, 98.9, 63], [142.4, 93.5, 17], [133.3, 64.5, -7], [172.1, 202.6, 9], [183.3, 222.4, -34]],
  lakes: [[124, 228, 11, 5.5]],
  islands: [[300, 40, 7], [318, 150, 5], [322, 100, 4]],
  mountains: [[100, 40, 0.7], [112, 30, 0.9], [126, 22, 1.1], [142, 16, 1.2], [158, 24, 1.05], [174, 18, 0.95], [188, 28, 0.85], [118, 46, 0.6], [150, 40, 0.7], [134, 40, 0.65], [222, 24, 0.8], [236, 14, 0.7], [166, 38, 0.6]],
  hills: [[44, 98, 1], [120, 110, 0.9], [160, 104, 1.1], [18, 172, 1], [128, 168, 0.8], [252, 198, 0.9], [60, 244, 1.1], [104, 252, 0.9], [184, 124, 0.8], [80, 130, 0.7], [226, 150, 0.8]],
  mines: [[230, 40]],
  forests: [[36, 152, 5, 0.5], [172, 146, 6, 0.4], [272, 234, 3, 0.8], [18, 58, 3, 0.9], [134, 194, 4, 0.3], [112, 72, 3, 0.5], [60, 222, 3, 0.6], [232, 172, 4, 0.5], [206, 90, 2, 0.7], [90, 236, 2, 0.4]],
  farms: [[12, 22, 4, 3, -6, true], [98, 84, 4, 3, 8, false], [28, 100, 3, 2, -4, true], [108, 124, 3, 3, 5, true], [38, 204, 3, 2, 6, true]],
  villages: [[146, 70, 4], [124, 140, 4], [258, 180, 3], [52, 178, 3], [176, 90, 3]],
  windmills: [[38, 42, 20], [58, 110, 60], [124, 100, 10]],
  marsh: [[190, 248, 5], [232, 252, 4]],
  lighthouses: [[272, 108]],
  ships: [[292, 72, 0.55], [308, 184, 0.6], [314, 124, 0.5]],
  whales: [[296, 142]],
  labels: [[146, 7, 'KÖDÖS-HEGYSÉG'], [348, 122, 'SZÜRKE-TENGER', 'sea', 90], [172, 170, 'TÖLGYERDŐ', 'region'], [60, 166, 'DÉLI MEZSGYE', 'region']],
};

const good = (name, supply, demand, shares = {}, margins = {}) => ({ name, supply, demand, shares, margins, sold: {}, history: [] });

export function initialState() {
  return {
    clock: 9 * 60 + 30, // 1. nap 09:30 (szimulált idő, percben)
    settlements: 0,
    routes: [['birtok', 'szelmezo'], ['birtok', 'delkapu'], ['szelmezo', 'feketerev']],
    players: {
      te: { gold: 30, pp: 10, legit: 0 },
      ezust: { gold: 80, pp: 10, legit: 0 },
      tolgy: { gold: 80, pp: 10, legit: 0 },
      arny: { gold: 80, pp: 10, legit: 0 },
      varju: { gold: 80, pp: 10, legit: 0 },
    },
    cities: {
      szelmezo: {
        goods: { gabona: good('Gabona', 150, 120, { te: 20, tolgy: 15 }, { te: 'piaci', tolgy: 'draga' }), bor: good('Bor', 60, 50, { ezust: 25 }, { ezust: 'draga' }) },
        pop: { te: 20, tolgy: 16, ezust: 12 }, parties: { tolgy: 'kozepes' }, council: {}, spies: {}, guards: {},
      },
      vaskapu: {
        goods: { vas: good('Vas', 80, 60, { varju: 35 }, { varju: 'uzsora' }), ko: good('Kő', 100, 70, { ezust: 15 }, { ezust: 'piaci' }) },
        pop: { varju: 18, ezust: 12 }, parties: { varju: 'magas' }, council: {}, spies: {}, guards: {},
      },
      feketerev: {
        goods: {
          so: good('Só', 100, 80, { ezust: 30, te: 10 }, { ezust: 'draga', te: 'piaci' }),
          hal: good('Hal', 120, 100, { varju: 25, ezust: 15 }, { varju: 'piaci', ezust: 'piaci' }),
          fuszer: good('Fűszer', 40, 35, { arny: 10 }, { arny: 'uzsora' }),
        },
        pop: { te: 14, ezust: 22, tolgy: 25, arny: 12, varju: 15 }, parties: { tolgy: 'alacsony', ezust: 'kozepes' }, council: {},
        spies: { arny: 2 }, guards: { arny: 0 },
      },
      holtag: {
        goods: { tozeg: good('Tőzeg', 60, 50, { arny: 20 }, { arny: 'piaci' }), csempesz: good('Csempészáru', 30, 30, { arny: 15 }, { arny: 'draga' }) },
        pop: { arny: 20 }, parties: {}, council: {}, spies: { arny: 1 }, guards: {},
      },
      delkapu: {
        goods: { gyapju: good('Gyapjú', 80, 70, { ezust: 20 }, { ezust: 'olcso' }), lo: good('Ló', 30, 25, {}, {}) },
        pop: { te: 12, ezust: 14, tolgy: 10 }, parties: {}, council: {}, spies: {}, guards: {},
      },
    },
    news: [], // {id, city, author, target, template, good, effect, trueAtCreation, debunked, createdAt}
    draft: [], // a játékos lepecsételetlen parancsai
    laps: [], // érlelő parancslapok: {id, player, orders, sealedAt, executeAt, cost}
    knowledge: { verified: {}, intel: [] }, // a játékos tudása: ellenőrzött hírek, kifürkészett parancslapok
    events: [], // {type:'buyout', city, by, at}
    festivals: {}, // "city|player" -> utolsó elszámolás
    protection: {}, // "city|good|player" -> eddig védett (elszámolás)
    lastInfoSale: -99,
    reports: [
      { id: 'r0', at: 9 * 60, kind: 'esemeny', title: 'Elkezdődött a szezon', text: 'A Délkelet városai várják a házakat. Az első elszámolás ma 20:00-kor lesz.', tone: 'info' },
    ],
    lastError: null,
    seq: 1,
  };
}
