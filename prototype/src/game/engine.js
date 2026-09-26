import { RULES, ACTIONS, FACTIONS, FACTION_NAMES, actionCost, gainFor } from './rules.js';
import { HOUSES, NODES, EDGES } from './world.js';

/* ---------- Segédfüggvények ---------- */
export const edgeKey = (a, b) => [a, b].sort().join('|');
const clone = (x) => JSON.parse(JSON.stringify(x));
function rng(seed) { let s = seed >>> 0 || 7; return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296); }
const d6 = (r) => 1 + Math.floor(r() * 6);
const round1 = (n) => Math.round(n * 10) / 10;

export function total(share) { return share ? share.open + share.hidden : 0; }
export function neutralOf(fac) { return Math.max(0, 100 - Object.values(fac).reduce((a, x) => a + total(x), 0)); }
export function unknownOf(fac, viewer) { return Object.entries(fac).reduce((a, [h, x]) => a + (h === viewer ? 0 : x.hidden), 0); }

/* ---------- Hálózat és elérhetőség (4. fejezet) ---------- */
export function isBlocked(state, a, b) { return state.blocked.some(([x, y, until]) => edgeKey(x, y) === edgeKey(a, b) && until >= state.round); }

export function network(state) {
  const adj = {};
  state.routes.forEach(([a, b]) => { if (isBlocked(state, a, b)) return; (adj[a] ||= []).push(b); (adj[b] ||= []).push(a); });
  const dist = { birtok: 0 }, q = ['birtok'];
  while (q.length) { const n = q.shift(); (adj[n] || []).forEach((m) => { if (dist[m] == null) { dist[m] = dist[n] + 1; q.push(m); } }); }
  return dist; // node -> távolság
}

export function hasRoute(state, a, b) { return state.routes.some(([x, y]) => edgeKey(x, y) === edgeKey(a, b)); }

// Kiépíthető útvonalak egy városhoz: olyan él, amelynek egyik vége a hálózatban van
export function buildableRoutesTo(state, cityId) {
  const net = network(state);
  return EDGES.filter(([a, b]) => (a === cityId || b === cityId) && !hasRoute(state, a, b) && !isBlocked(state, a, b))
    .filter(([a, b]) => { const other = NODES[a === cityId ? b : a]; return !other.estate || other.estate === 'te'; })
    .filter(([a, b]) => net[a === cityId ? b : a] != null)
    .map(([a, b]) => (a === cityId ? [b, a] : [a, b]));
}

export function cityState(state, cityId) {
  const net = network(state);
  if (net[cityId] != null) return 'reachable';
  const hadRoute = state.routes.some(([a, b]) => a === cityId || b === cityId);
  return hadRoute ? 'cut' : 'unreachable';
}

/* ---------- Kontrollszintek (6. fejezet) ---------- */
export function ranking(fac) {
  return Object.entries(fac).map(([h, x]) => ({ house: h, open: x.open, hidden: x.hidden })).sort((a, b) => b.open - a.open);
}
export function dominantOf(fac) {
  const r = ranking(fac), t = RULES.thresholds;
  if (!r.length) return null;
  const first = r[0], second = r[1]?.open || 0;
  return first.open >= t.dominans && first.open - second >= t.lead ? first.house : null;
}
export function levelOf(state, cityId, faction, house = 'te') {
  const fac = state.influence[cityId][faction], mine = fac[house]?.open || 0, t = RULES.thresholds;
  const doms = FACTIONS.filter((f) => dominantOf(state.influence[cityId][f]) === house).length;
  if (doms === 3) return 'protektoratus';
  if (doms === 2 && dominantOf(fac) === house) return 'varoskontroll';
  if (dominantOf(fac) === house) return 'dominans';
  if (mine >= t.partner) return 'partner';
  if (mine >= t.jelenlet) return 'jelenlet';
  return null;
}
export function precisionFor(level) {
  if (level === 'dominans' || level === 'varoskontroll' || level === 'protektoratus') return 'exact';
  if (level === 'partner') return 'band5';
  return 'band10';
}

export function suspicionOf(state, cityId, faction) { return state.suspicion[cityId + '.' + faction]?.value || 0; }

/* ---------- Parancsok ---------- */
export function pendingPP(state) { return state.orders.reduce((a, o) => a + o.cost.pp, 0); }
export function pendingCost(state) {
  const c = { arany: 0, bp: 0, ke: 0 };
  state.orders.forEach((o) => Object.entries(o.cost).forEach(([k, v]) => { if (k !== 'pp') c[k] += v; }));
  return c;
}
// Visszaad: null (rendben) vagy a hiba szövege
export function canAfford(state, cost) {
  const pp = pendingPP(state) + (cost.pp || 0);
  if (pp > state.resources.pp) return `Nincs elég parancspont: ${pp} kellene, ${state.resources.pp} van.`;
  const pend = pendingCost(state);
  const names = { arany: 'arany', bp: 'befolyáspont', ke: 'katonai erő' };
  for (const k of ['arany', 'bp', 'ke']) {
    const need = pend[k] + (cost[k] || 0);
    if (need > state.resources[k]) return `Nincs elég ${names[k]}: ${need} kellene, ${state.resources[k]} van.`;
  }
  return null;
}

export function makeOrder(state, { type, city, faction, hidden, target }) {
  if (type === 'route') {
    return { id: Math.random().toString(36).slice(2), type, from: city[0], to: city[1], label: 'Útvonal kiépítése', cityLabel: `${NODES[city[0]].name} → ${NODES[city[1]].name}`, cost: { pp: RULES.route.pp, arany: RULES.route.arany } };
  }
  const a = ACTIONS[type];
  return {
    id: Math.random().toString(36).slice(2), type, city, faction, hidden: !!hidden, target,
    label: a.label, cityLabel: NODES[city].name, cost: actionCost(type, hidden),
    note: target ? 'célpont: ' + HOUSES[target].name : undefined,
  };
}

/* ---------- Kör feldolgozása (3. fejezet, 4. lépés) ---------- */
export function resolveRound(prev) {
  const st = clone(prev), r = rng(prev.round * 7919 + 17), reports = [], tick = `${st.round}. kör`;
  const rep = (x) => reports.push({ id: 'r' + st.round + '-' + reports.length, tick, ...x });
  const net = network(st);
  const before = snapshotLevels(st);

  // Erőforrások levonása
  st.orders.forEach((o) => Object.entries(o.cost).forEach(([k, v]) => { st.resources[k] -= v; }));

  // NPC-parancsok (9.2, egyszerűsítve)
  const npcOrders = npcTurn(st, r);
  const all = [...st.orders.map((o) => ({ ...o, house: 'te' })), ...npcOrders];

  // 4.1 Megszilárdítás
  const consolidated = new Set(all.filter((o) => o.type === 'consolidate').map((o) => o.house + '@' + o.city + '.' + o.faction));

  // 4.3 Támadó akciók: Lejáratás
  all.filter((o) => o.type === 'smear').forEach((o) => {
    const fac = st.influence[o.city][o.faction], tgt = fac[o.target];
    if (!tgt) return;
    const stabMul = { stabil: 1, ingatag: 1.25, lazongo: 1.5 }[st.stability[o.city]];
    let loss = -RULES.smear * stabMul;
    const guarded = consolidated.has(o.target + '@' + o.city + '.' + o.faction);
    if (guarded) loss /= 2;
    tgt.open = Math.max(0, tgt.open - loss);
    const roll = d6(r), exposed = roll === 1 || (guarded && roll <= 2);
    if (o.house === 'te') {
      rep({ kind: 'frakcio', title: `Lejáratás: ${NODES[o.city].name}, ${FACTION_NAMES[o.faction]}`, text: `${HOUSES[o.target].name} ${round1(loss)} pontot veszített. ${exposed ? 'Ügynökeid lebuktak: a sértett fél megtudta, ki állt a háttérben.' : 'Senki sem sejti, honnan jött a pletyka.'}`, tone: exposed ? 'danger' : 'ok' });
      if (exposed) bumpSuspicion(st, o.city, o.faction);
    } else if (o.target === 'te') {
      rep({ kind: 'kem', confidence: exposed ? 'eros' : 'gyenge', title: `Rágalmak: ${NODES[o.city].name}`, text: exposed ? `A ${HOUSES[o.house].name} emberei rágalmakat terjesztettek rólad a ${FACTION_NAMES[o.faction]} körében. Tetten érték őket.` : `Valaki rossz hírét kelti a házadnak a ${FACTION_NAMES[o.faction]} körében.` });
    }
  });

  // 4.4 Nyereség-akciók (5.2 és 5.3)
  const claims = {}; // city.faction -> [{house, gain, hidden, order}]
  all.filter((o) => ACTIONS[o.type]?.power).forEach((o) => {
    const fac = st.influence[o.city][o.faction];
    let mods = 1;
    if (HOUSES[o.house].background === o.faction) mods *= RULES.backgroundBonus;
    const sus = suspicionOf(st, o.city, o.faction);
    if (o.house === 'te') mods *= sus === 1 ? 0.75 : sus >= 2 ? 0.5 : 1;
    if (st.stability[o.city] === 'lazongo') mods *= 0.75;
    const g = gainFor(ACTIONS[o.type].power, total(fac[o.house]), mods);
    (claims[o.city + '.' + o.faction] ||= []).push({ house: o.house, gain: g, hidden: !!o.hidden, order: o });
  });
  // Kereskedelmi útvonal passzív hozama (4.7)
  st.routes.forEach(([a, b]) => [a, b].forEach((n) => { if (NODES[n].city && net[n] != null) (claims[n + '.kereskedok'] ||= []).push({ house: 'te', gain: 1, hidden: false, passive: true }); }));

  const myGains = {};
  Object.entries(claims).forEach(([key, list]) => {
    const [city, faction] = key.split('.'), fac = st.influence[city][faction];
    const want = list.reduce((a, c) => a + c.gain, 0), neutral = neutralOf(fac);
    const fromNeutral = Math.min(neutral, want);
    list.forEach((c) => {
      const share = want ? c.gain / want : 0;
      let got = fromNeutral * share;
      const rest = c.gain - got;
      if (rest > 0.01) {
        const rivals = Object.entries(fac).filter(([h]) => h !== c.house), rivalTotal = rivals.reduce((a, [, x]) => a + total(x), 0);
        const take = Math.min(rivalTotal, rest * RULES.rivalEfficiency);
        rivals.forEach(([, x]) => {
          const t = total(x); if (!t) return;
          const part = take * (t / rivalTotal), fromHidden = Math.min(x.hidden, part * (x.hidden / t));
          x.hidden -= fromHidden; x.open = Math.max(0, x.open - (part - fromHidden));
        });
        got += take;
      }
      const mine = (fac[c.house] ||= { open: 0, hidden: 0 });
      if (c.hidden) mine.hidden += got; else mine.open += got;
      if (c.house === 'te') { myGains[key] = (myGains[key] || 0) + got; if (!c.passive) c.order.result = got; }
    });
  });
  st.orders.filter((o) => o.result != null).forEach((o) => {
    rep({ kind: 'frakcio', title: `${NODES[o.city].name}, ${FACTION_NAMES[o.faction]}: +${round1(o.result).toString().replace('.', ',')}${o.hidden ? ' rejtett' : ''}`, text: flavor(o, r) });
  });

  // Útvonalak kiépítése (4.9: a kör végén aktiválódik)
  st.orders.filter((o) => o.type === 'route').forEach((o) => {
    st.routes.push([o.from, o.to]);
    rep({ kind: 'diplomacia', title: `Új útvonal: ${o.cityLabel}`, text: `A karavánút megnyílt. ${NODES[o.to].name} mostantól a hálózatod része.` });
  });

  // 4.6 Romlás (7.1)
  const net2 = network(st);
  Object.entries(st.influence).forEach(([city, facs]) => Object.entries(facs).forEach(([faction, fac]) => Object.entries(fac).forEach(([h, x]) => {
    const dist = h === 'te' ? (net2[city] ?? 3) : 1;
    let base = RULES.decay.perDistance * Math.max(0, dist - 1) + (RULES.decay[st.stability[city]] || 0);
    if (h === 'te' && suspicionOf(st, city, faction) >= 2) base += RULES.decay.suspicion2;
    const cut = h === 'te' && net2[city] == null && x.open > 0;
    const dOpen = Math.min(RULES.decay.cap, RULES.decay.open + base) * (cut ? 2 : 1);
    const dHidden = Math.min(RULES.decay.cap, RULES.decay.hidden + base) * (cut ? 2 : 1);
    x.open = Math.round(x.open * (1 - dOpen) * 100) / 100; x.hidden = Math.round(x.hidden * (1 - dHidden) * 100) / 100;
  })));

  // 4.7 Gyanú (9.3): egy körben ≥ 15 nyílt nyereség
  Object.entries(myGains).forEach(([key, g]) => { if (g >= RULES.suspicionGainThreshold) { const [c, f] = key.split('.'); bumpSuspicion(st, c, f); rep({ kind: 'frakcio', title: `Gyanakodnak rád: ${NODES[c].name}, ${FACTION_NAMES[f]}`, text: 'Túl gyorsan nőtt a befolyásod. A frakció óvatosabban fogadja a közeledésedet.', tone: 'warn' }); } });
  Object.entries(st.suspicion).forEach(([, v]) => { if (v.value > 0 && st.round - v.last >= 2) { v.value -= 1; v.last = st.round; } });

  // Szintváltozások jelentése
  const after = snapshotLevels(st);
  Object.keys(after).forEach((k) => {
    if (after[k] === before[k]) return;
    const [c, f] = k.split('.');
    const up = rankLevel(after[k]) > rankLevel(before[k]);
    rep({ kind: 'frakcio', title: `${up ? 'Előreléptél' : 'Visszaestél'}: ${NODES[c].name}, ${FACTION_NAMES[f]}`, text: `Új szinted: ${LEVEL_NAMES[after[k]] || 'nincs jelenlét'}.`, tone: up ? 'ok' : 'warn' });
  });

  // 4.8 Jutalmak és bevétel (10. fejezet)
  const inc = { arany: RULES.income.arany, bp: RULES.income.bp, ke: RULES.income.ke, legit: 0 };
  Object.keys(HOUSES).forEach((h) => { let l = 0; Object.entries(st.influence).forEach(([city, facs]) => {
    const doms = FACTIONS.filter((f) => dominantOf(facs[f]) === h);
    doms.forEach((f) => { l += f === 'nemesseg' ? 3 : 1; if (h === 'te') { if (f === 'nemesseg') inc.bp += 2; if (f === 'kereskedok') inc.arany += 4; if (f === 'katonasag') inc.ke += 1; } });
    if (doms.length >= 2) l += Math.ceil((doms.length === 3 ? 8 : 5) * (NODES[city].key ? 1.5 : 1));
    if (h === 'te') FACTIONS.forEach((f) => { if (levelOf(st, city, f) === 'partner') { if (f === 'nemesseg') inc.bp += 1; if (f === 'kereskedok') inc.arany += 2; } });
  }); st.legit[h] = (st.legit[h] || 0) + l; if (h === 'te') inc.legit = l; });
  const upkeep = st.routes.length * RULES.route.upkeep;
  const routeGold = st.routes.length;
  st.resources.arany += inc.arany - upkeep + routeGold;
  st.resources.bp += inc.bp;
  st.resources.ke = Math.min(RULES.keMax, st.resources.ke + inc.ke);
  st.resources.legit = st.legit.te;
  st.resources.pp = Math.min(RULES.ppMax, st.resources.pp + RULES.ppPerRound);

  // 4.10 Városi esemény (9.6)
  if (d6(r) >= 5) {
    const cities = Object.keys(NODES).filter((n) => NODES[n].city), city = cities[Math.floor(r() * cities.length)], ev = d6(r);
    const order = ['stabil', 'ingatag', 'lazongo'];
    const idx = order.indexOf(st.stability[city]);
    if (ev <= 2 && idx < 2) { st.stability[city] = order[idx + 1]; rep({ kind: 'esemeny', title: `Zavargás: ${NODES[city].name}`, text: 'Az utcákon elégedetlen tömeg gyűlt össze. A város stabilitása romlott.', tone: 'warn' }); }
    else if (ev >= 5 && idx > 0) { st.stability[city] = order[idx - 1]; rep({ kind: 'esemeny', title: `Nyugalom: ${NODES[city].name}`, text: 'A piacok újra megteltek, a város lecsillapodott.', tone: 'ok' }); }
    else if (ev === 3) { const e = cityEdges(city)[0]; if (e) { st.blocked.push([e[0], e[1], st.round + 2]); rep({ kind: 'esemeny', title: 'Járhatatlan utak', text: `Az őszi esőzések elmosták az utat ${NODES[e[0]].name} és ${NODES[e[1]].name} között. Két körig nem járható.`, tone: 'warn' }); } }
  }

  // Összegzés
  st.lastSummary = { round: st.round, income: inc, upkeep, routeGold };
  st.reports = [...reports.reverse(), ...st.reports].slice(0, 40);
  st.orders = []; st.sealed = false; st.round += 1;
  return st;
}

/* ---------- NPC-házak (9.1–9.2, egyszerűsítve) ---------- */
function npcTurn(st, r) {
  const out = [];
  Object.values(HOUSES).filter((h) => h.npc).forEach((h) => {
    let pp = RULES.npcPP;
    const push = (o) => { const c = o.type === 'grant' ? 2 : o.type === 'smear' ? 2 : 1; if (pp >= c) { pp -= c; out.push({ ...o, house: h.id, hidden: h.persona === 'arnyek' && o.type !== 'smear' && o.type !== 'consolidate' }); } };
    // 1. Védekezés
    Object.entries(st.influence).forEach(([city, facs]) => FACTIONS.forEach((f) => {
      if (dominantOf(facs[f]) !== h.id) return;
      const rk = ranking(facs[f]);
      if (rk[1] && rk[0].open - rk[1].open < 8) { push({ type: 'consolidate', city, faction: f }); push({ type: 'patron', city, faction: f }); }
    }));
    // 3. Terjeszkedés a kedvenc frakcióban, ahol a legtöbb Semleges van
    const cities = Object.keys(st.influence).sort((a, b) => neutralOf(st.influence[b][h.favorite]) - neutralOf(st.influence[a][h.favorite]));
    push({ type: 'grant', city: cities[0], faction: h.favorite });
    if (h.persona !== 'nemzetseg') push({ type: 'patron', city: cities[1], faction: h.favorite });
    // 5. Intrika
    const roll = d6(r), threshold = h.persona === 'zsoldos' || h.persona === 'arnyek' ? 4 : 5;
    st.npcCooldown ||= {};
    if (roll >= threshold && (st.npcCooldown[h.id] || 0) <= st.round) {
      st.npcCooldown[h.id] = st.round + 3;
      const spots = [];
      Object.entries(st.influence).forEach(([city, facs]) => FACTIONS.forEach((f) => { if ((facs[f].te?.open || 0) > 10 && facs[f][h.id]) spots.push({ city, f, v: facs[f].te.open }); }));
      spots.sort((a, b) => b.v - a.v);
      if (spots[0]) push({ type: 'smear', city: spots[0].city, faction: spots[0].f, target: 'te' });
    }
    if (r() < 0.5) push({ type: 'patron', city: cities[Math.floor(r() * cities.length)], faction: h.favorite });
  });
  return out;
}

/* ---------- Belső segédek ---------- */
const LEVEL_ORDER = [null, 'jelenlet', 'partner', 'dominans', 'varoskontroll', 'protektoratus'];
export const LEVEL_NAMES = { jelenlet: 'Jelenlét', partner: 'Helyi partner', dominans: 'Domináns', varoskontroll: 'Városkontroll', protektoratus: 'Protektorátus' };
const rankLevel = (l) => LEVEL_ORDER.indexOf(l ?? null);
function snapshotLevels(st) { const o = {}; Object.keys(st.influence).forEach((c) => FACTIONS.forEach((f) => { o[c + '.' + f] = levelOf(st, c, f); })); return o; }
function bumpSuspicion(st, city, faction) {
  const k = city + '.' + faction, cur = st.suspicion[k] || { value: 0, last: st.round };
  cur.value += 1; cur.last = st.round;
  if (cur.value >= 3) { const x = st.influence[city][faction].te; if (x) { x.open /= 2; x.hidden /= 2; } cur.value = 1; }
  st.suspicion[k] = cur;
}
function cityEdges(city) { return EDGES.filter(([a, b]) => a === city || b === city); }
const FLAVOR = {
  patron: ['A céhmesterek elfogadták az ajándékot, és elismerően bólintottak.', 'Egy csendes vacsora, egy jó bor: a támogatók köre bővült.'],
  grant: ['A nagy adomány híre bejárta a várost. Az emberek a nevedet emlegetik.', 'A tanácsterem új faliszőnyegét a te házad címere díszíti.'],
  council: ['Egy tanácstag mostantól a te szavadra figyel.', 'A tanácsülésen először szólalt fel valaki a házad nevében.'],
  guard: ['A városőrség új vértezetet kapott. A kapitány nem felejt.', 'Zsoldot fizettél a helyőrségnek. A katonák tudják, kinek köszönhetik.'],
};
function flavor(o, r) { const list = FLAVOR[o.type] || ['Az akció lezárult.']; return (o.hidden ? 'Álnéven, közvetítőkön át. ' : '') + list[Math.floor(r() * list.length)]; }
