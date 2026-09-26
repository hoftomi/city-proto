// Példavilág a prototípushoz: a „Délkelet” régió. Hamis, de szabálykönyv-konform adatok.

export const HOUSES = {
  te: { id: 'te', name: 'Kékholló', tincture: 'kek', initial: 'K', npc: false, background: 'kereskedok' },
  ezust: { id: 'ezust', name: 'Ezüstpart-ház', tincture: 'arany', initial: 'E', npc: true, persona: 'kalmar', favorite: 'kereskedok' },
  tolgy: { id: 'tolgy', name: 'Ősi Tölgy', tincture: 'zold', initial: 'Ö', npc: true, persona: 'nemzetseg', favorite: 'nemesseg' },
  varju: { id: 'varju', name: 'Varjúvár', tincture: 'fekete', initial: 'V', npc: true, persona: 'zsoldos', favorite: 'katonasag' },
  arny: { id: 'arny', name: 'Bíbor Kéz', tincture: 'bibor', initial: 'B', npc: true, persona: 'arnyek', favorite: 'kereskedok' },
};

export const NODES = {
  birtok: { id: 'birtok', name: 'Birtokod', x: 28, y: 125, estate: 'te' },
  ezustbirtok: { id: 'ezustbirtok', name: 'Ezüstpart', x: 160, y: 238, estate: 'ezust' },
  szelmezo: { id: 'szelmezo', name: 'Szélmező', x: 70, y: 72, city: true, profile: 'Gabonavidék' },
  vaskapu: { id: 'vaskapu', name: 'Vaskapu', x: 205, y: 56, city: true, profile: 'Erődváros' },
  feketerev: { id: 'feketerev', name: 'Feketerév', x: 238, y: 122, city: true, profile: 'Kikötőváros', key: true, coast: true },
  holtag: { id: 'holtag', name: 'Holtág', x: 205, y: 208, city: true, profile: 'Mocsári csempészváros' },
  delkapu: { id: 'delkapu', name: 'Délkapu', x: 95, y: 190, city: true, profile: 'Határváros', labelSide: 'right' },
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

// share(open, hidden)
const s = (open, hidden = 0) => ({ open, hidden });

export function initialState() {
  return {
    round: 3,
    sealed: false,
    resources: { pp: 13, arany: 23, bp: 7, ke: 3, legit: 41 },
    routes: [['birtok', 'szelmezo'], ['birtok', 'delkapu'], ['szelmezo', 'feketerev']],
    orders: [],
    legit: { te: 41, ezust: 52, tolgy: 37, varju: 22, arny: 9 },
    suspicion: {}, // "city.faction" -> { value, last }
    stability: { szelmezo: 'ingatag', vaskapu: 'stabil', feketerev: 'stabil', holtag: 'lazongo', delkapu: 'ingatag' },
    npcCooldown: { ezust: 5, tolgy: 5, varju: 5, arny: 5 }, // az NPC-k az 5. körtől intrikálnak
    blocked: [], // lezárt élek eseményből: [a, b, untilRound]
    influence: {
      szelmezo: { nemesseg: { tolgy: s(30) }, kereskedok: { te: s(22), ezust: s(18) }, katonasag: { varju: s(15) } },
      vaskapu: { nemesseg: { tolgy: s(12) }, kereskedok: { ezust: s(14) }, katonasag: { varju: s(46), te: s(6) } },
      feketerev: { nemesseg: { te: s(42), tolgy: s(25), arny: s(0, 8) }, kereskedok: { ezust: s(55), te: s(19.3), varju: s(12) }, katonasag: { varju: s(38), ezust: s(14) } },
      holtag: { nemesseg: { tolgy: s(9) }, kereskedok: { arny: s(6, 18), ezust: s(20) }, katonasag: { varju: s(24) } },
      delkapu: { nemesseg: { te: s(14), tolgy: s(20) }, kereskedok: { ezust: s(26) }, katonasag: { varju: s(18), te: s(11) } },
    },
    reports: [
      { id: 'r0', kind: 'kem', confidence: 'gyenge', tick: '2. kör', title: 'Feketerév, Kereskedők', text: 'Feketerévben valószínűleg rivális befolyásépítés zajlik.' },
      { id: 'r1', kind: 'esemeny', tick: '2. kör', title: 'Lázongás Holtágban', text: 'A mocsári csempészek felgyújtották a vámházat. A város lázong.' },
    ],
    lastSummary: null,
  };
}
