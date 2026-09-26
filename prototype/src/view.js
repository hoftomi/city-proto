// A játékállapotból a design system komponenseinek propjait állítja elő.
import { HOUSES, NODES } from './game/world.js';
import { FACTIONS } from './game/rules.js';
import { neutralOf, unknownOf, ranking, dominantOf, levelOf, precisionFor, suspicionOf } from './game/engine.js';

export function factionView(state, city, faction) {
  const fac = state.influence[city][faction];
  const level = levelOf(state, city, faction);
  const segments = Object.entries(fac)
    .filter(([, x]) => x.open > 0.05)
    .map(([h, x]) => ({ name: h === 'te' ? 'Te' : HOUSES[h].name, tincture: HOUSES[h].tincture, value: Math.round(x.open * 10) / 10, self: h === 'te', house: h }));
  return {
    faction, level, segments,
    unknown: Math.round(unknownOf(fac, 'te') * 10) / 10,
    ownHidden: Math.round((fac.te?.hidden || 0) * 10) / 10,
    neutral: neutralOf(fac),
    precision: precisionFor(level),
    suspicion: suspicionOf(state, city, faction),
    rivals: Object.entries(fac).filter(([h, x]) => h !== 'te' && x.open > 0.5).map(([h]) => h),
  };
}

export function districtsView(state, city) {
  const out = {};
  FACTIONS.forEach((f) => {
    const fac = state.influence[city][f], dom = dominantOf(fac), rk = ranking(fac);
    out[f] = { dominant: dom ? HOUSES[dom].tincture : null, contested: dom && rk[1] && rk[1].open >= 25 ? HOUSES[rk[1].house].tincture : null };
  });
  return out;
}

export function bestLevel(state, city) {
  const order = ['protektoratus', 'varoskontroll', 'dominans', 'partner', 'jelenlet'];
  const levels = FACTIONS.map((f) => levelOf(state, city, f));
  return order.find((l) => levels.includes(l)) || null;
}

export function cityName(id) { return NODES[id].name; }

// Idő a következő feldolgozásig (08:00 és 20:00, helyi idő)
export function nextTick(now = new Date()) {
  const t = new Date(now);
  const h = now.getHours();
  if (h < 8) t.setHours(8, 0, 0, 0); else if (h < 20) t.setHours(20, 0, 0, 0); else { t.setDate(t.getDate() + 1); t.setHours(8, 0, 0, 0); }
  const mins = Math.max(0, Math.round((t - now) / 60000));
  const hh = Math.floor(mins / 60), mm = mins % 60;
  return { at: String(t.getHours()).padStart(2, '0') + ':00', remaining: hh ? `${hh} ó ${mm} p` : `${mm} p`, soon: mins <= 60 };
}
