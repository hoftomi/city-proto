// Szabálykönyv v0.2 – hangolandó paraméterek (11. fejezet). Minden szám innen jön.
export const RULES = {
  ppPerSettlement: 10,
  ppMax: 20,
  startGold: 30,
  maturationMin: 120, // érlelési idő percben (Polgár)
  settlementHours: [8, 20],
  basePrice: 3, // arany / egység
  popBase: 10,
  popDrift: 2,
  popSoftCap: 60,
  cityShareCost: 3, // arany / pont a Várostól
  maxSharesPerOrder: 10,
  buyoutPremium: 1.5,
  buyoutProtection: 3, // elszámolás
  partyCost: 40,
  councilSeats: 9,
  electionThreshold: 0.05,
  electionEvery: 6, // elszámolásonként
  festivalGold: 15,
  festivalPop: 6,
  festivalCooldown: 3,
  newsGold: 5,
  debunkPenalty: 10,
  debunkReward: { pop: 3, gold: 10, legit: 3 },
  spyCost: 20,
  spyUpkeep: 2,
  spiesPerCity: 3,
  guardChance: 0.25,
  guardMax: 0.75,
  routeCost: 3,
  routeUpkeep: 1,
  infoPrice: 10,
};

export const MARGINS = [
  { id: 'nagyonolcso', label: 'Nagyon olcsó', m: 0.05, pop: 3 },
  { id: 'olcso', label: 'Olcsó', m: 0.15, pop: 1 },
  { id: 'piaci', label: 'Piaci', m: 0.3, pop: 0 },
  { id: 'draga', label: 'Drága', m: 0.5, pop: -1 },
  { id: 'uzsora', label: 'Uzsora', m: 0.8, pop: -3 },
];
export const margin = (id) => MARGINS.find((x) => x.id === id) || MARGINS[2];

export const PROGRAMS = [
  { id: 'alacsony', label: 'Alacsony adó', rate: 0.1, pop: 1 },
  { id: 'kozepes', label: 'Közepes adó', rate: 0.2, pop: 0 },
  { id: 'magas', label: 'Magas adó', rate: 0.3, pop: -1 },
];
export const program = (id) => PROGRAMS.find((x) => x.id === id) || PROGRAMS[1];

// Hírsablonok (6.5). A `check` a játékállapotból dönti el, igaz-e.
export const NEWS = {
  uzsora: { label: '„{t} uzsoraáron árulja: {g}.”', effect: -5, needsGood: true },
  kivasarolt: { label: '„{t} kivásárolt egy rivális kereskedőt.”', effect: -4 },
  adoemeles: { label: '„{t} pártja adóemelést akar.”', effect: -5 },
  kemek: { label: '„{t} kémeket tart a városban.”', effect: -4 },
  barat: { label: '„{t} a városlakók barátja.”', effect: 4 },
};

// Akciók: PP és arany (10. fejezet). A kivásárlás és a védekezés ára számolt.
export const ACTIONS = {
  route: { label: 'Útvonal kiépítése', pp: 1, gold: RULES.routeCost, branch: 'kozos' },
  margin: { label: 'Fokozatváltás', pp: 1, gold: 0, branch: 'keresk' },
  buyShares: { label: 'Részesedés vásárlása', pp: 1, gold: null, branch: 'keresk' },
  buyout: { label: 'Kivásárlási ajánlat', pp: 2, gold: null, branch: 'keresk' },
  defend: { label: 'Védekező vétel', pp: 1, gold: null, branch: 'keresk' },
  foundParty: { label: 'Pártalapítás', pp: 2, gold: RULES.partyCost, branch: 'polit' },
  program: { label: 'Programváltás', pp: 1, gold: 0, branch: 'polit' },
  festival: { label: 'Fesztivál', pp: 2, gold: RULES.festivalGold, branch: 'polit' },
  news: { label: 'Hír terjesztése', pp: 2, gold: RULES.newsGold, branch: 'polit' },
  hireSpy: { label: 'Kém felfogadása', pp: 1, gold: RULES.spyCost, branch: 'kem' },
  guard: { label: 'Őr beállítása', pp: 1, gold: 0, branch: 'kem' },
  spy: { label: 'Kifürkészés', pp: 1, gold: 0, branch: 'kem' },
  verify: { label: 'Hír ellenőrzése', pp: 1, gold: 0, branch: 'kem' },
  debunk: { label: 'Leleplezés', pp: 1, gold: 0, branch: 'kem' },
};
