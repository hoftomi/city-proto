// Szabálykönyv v0.1 – hangolandó paraméterek (14. fejezet). Minden szám innen jön.
export const RULES = {
  ppPerRound: 10,
  ppMax: 20,
  income: { arany: 10, bp: 3, ke: 1 },
  keMax: 6,
  diminishingDivisor: 150,
  rivalEfficiency: 0.5,
  decay: { open: 0.05, hidden: 0.08, perDistance: 0.01, ingatag: 0.02, lazongo: 0.04, suspicion2: 0.02, cap: 0.12 },
  thresholds: { jelenlet: 10, partner: 25, dominans: 35, lead: 5 },
  hiddenExtraPP: 1,
  hiddenCostMultiplier: 1.5,
  route: { pp: 1, arany: 3, upkeep: 1, max: 4 },
  smear: -8,
  suspicionGainThreshold: 15,
  backgroundBonus: 1.25,
  npcPP: 8,
  seasonRounds: 12,
};

// Akciók (5.1 és 12.1)
export const ACTIONS = {
  patron: { label: 'Pártfogás', pp: 1, cost: { arany: 3 }, power: 4, factions: 'any' },
  grant: { label: 'Nagy adomány', pp: 2, cost: { arany: 8 }, power: 10, factions: 'any' },
  council: { label: 'Tanácstag megnyerése', pp: 2, cost: { bp: 3 }, power: 8, factions: ['nemesseg'], needsPresence: true },
  guard: { label: 'Városőrség támogatása', pp: 1, cost: { ke: 1 }, power: 6, factions: ['katonasag'] },
  smear: { label: 'Lejáratás', pp: 2, cost: { bp: 2 }, power: 0, factions: 'any', hostile: true },
  consolidate: { label: 'Megszilárdítás', pp: 1, cost: {}, power: 0, factions: 'any' },
};

export const FACTION_NAMES = { nemesseg: 'Nemesség', kereskedok: 'Kereskedők', katonasag: 'Katonaság' };
export const FACTIONS = ['nemesseg', 'kereskedok', 'katonasag'];

// Egy akció tényleges költsége (rejtett: +1 PP és +50%, felfelé kerekítve – 8.1)
export function actionCost(type, hidden) {
  const a = ACTIONS[type];
  const cost = { pp: a.pp + (hidden ? RULES.hiddenExtraPP : 0) };
  for (const [k, v] of Object.entries(a.cost)) cost[k] = hidden ? Math.ceil(v * RULES.hiddenCostMultiplier) : v;
  return cost;
}

export function gainFor(base, total, mods = 1) {
  return base * (1 - total / RULES.diminishingDivisor) * mods;
}
