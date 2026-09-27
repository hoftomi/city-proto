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
  rivers: ['M168 36C176 60 206 70 216 90C224 104 238 100 257 98'],
  mountains: [[106, 42, 0.8], [122, 32, 1], [142, 24, 1.2], [164, 32, 1], [186, 26, 0.9]],
  forests: [[56, 152, 7], [176, 152, 6], [270, 236, 4]],
  fields: [[30, 36, 34, 18, -6], [92, 86, 28, 16, 8]],
  marsh: [[198, 228, 6], [226, 238, 4]],
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
