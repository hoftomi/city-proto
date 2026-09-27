// Szabálykönyv v0.2 szabálymotor: parancslapok érleléssel, elszámolás 8:00 / 20:00, választás, kémek, hírek.
import { RULES, MARGINS, margin, program, NEWS, ACTIONS } from './rules.js';
import { HOUSES, NODES, EDGES } from './world.js';

const clone = (x) => JSON.parse(JSON.stringify(x));
const r1 = (n) => Math.round(n * 10) / 10;
export const edgeKey = (a, b) => [a, b].sort().join('|');
export const CITIES = Object.keys(NODES).filter((n) => NODES[n].city);
export const name = (p) => (p === 'te' ? 'Te' : HOUSES[p]?.name || p);
const rngOf = (seed) => { let s = seed >>> 0 || 7; return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296); };

/* ---------- Idő ---------- */
export function fmtClock(t) {
  const d = Math.floor(t / 1440) + 1, m = ((t % 1440) + 1440) % 1440;
  return `${d}. nap ${String(Math.floor(m / 60)).padStart(2, '0')}:${String(m % 60).padStart(2, '0')}`;
}
export function fmtDur(min) { const h = Math.floor(min / 60), m = Math.round(min % 60); return h ? `${h} ó ${m} p` : `${m} p`; }
export function nextSettlement(t) {
  for (let k = 0; k < 3; k++) {
    for (const h of RULES.settlementHours) { const c = (Math.floor(t / 1440) + k) * 1440 + h * 60; if (c > t) return c; }
  }
  return t + 720;
}

/* ---------- Hálózat (4. fejezet) ---------- */
export function network(state, player = 'te') {
  if (player !== 'te') return Object.fromEntries(CITIES.map((c) => [c, 1]));
  const adj = {};
  state.routes.forEach(([a, b]) => { (adj[a] ||= []).push(b); (adj[b] ||= []).push(a); });
  const dist = { birtok: 0 }, q = ['birtok'];
  while (q.length) { const n = q.shift(); (adj[n] || []).forEach((m) => { if (dist[m] == null) { dist[m] = dist[n] + 1; q.push(m); } }); }
  return dist;
}
export const reaches = (state, player, city) => network(state, player)[city] != null;
export const hasRoute = (state, a, b) => state.routes.some(([x, y]) => edgeKey(x, y) === edgeKey(a, b));
export function buildableRoutesTo(state, city) {
  const net = network(state);
  return EDGES.filter(([a, b]) => (a === city || b === city) && !hasRoute(state, a, b))
    .map(([a, b]) => (a === city ? [b, a] : [a, b]))
    .filter(([from]) => net[from] != null && (!NODES[from].estate || NODES[from].estate === 'te'));
}

/* ---------- Segédek ---------- */
export const popOf = (state, city, p) => state.cities[city].pop[p] ?? RULES.popBase;
function addPop(state, city, p, delta) {
  const cur = popOf(state, city, p);
  let d = delta;
  if (d > 0 && cur >= RULES.popSoftCap) d /= 2;
  state.cities[city].pop[p] = Math.max(0, Math.min(100, r1(cur + d)));
}
export function cityShare(g) { return Math.max(0, 100 - Object.values(g.shares).reduce((a, b) => a + b, 0)); }
export function marketValue(g) {
  const h = g.history.slice(-3);
  const avg = h.length ? h.reduce((a, b) => a + b, 0) / h.length : 0.3;
  return Math.max(2, r1(avg * 10));
}
export function taxRate(state, city) {
  const c = state.cities[city], seats = Object.entries(c.council).filter(([, s]) => s > 0);
  const total = seats.reduce((a, [, s]) => a + s, 0);
  if (!total) return 0.2;
  return seats.reduce((a, [p, s]) => a + program(c.parties[p]).rate * s, 0) / total;
}
export function newsTruth(state, n) {
  const c = state.cities[n.city];
  switch (n.template) {
    case 'uzsora': { const m = c.goods[n.good]?.margins[n.target]; return m === 'draga' || m === 'uzsora'; }
    case 'kivasarolt': return state.events.some((e) => e.type === 'buyout' && e.by === n.target && e.city === n.city && state.settlements - e.settlement <= 3);
    case 'adoemeles': return c.parties[n.target] === 'magas';
    case 'kemek': return (c.spies[n.target] || 0) > 0;
    case 'barat': {
      const vals = Object.values(c.pop); const avg = vals.reduce((a, b) => a + b, 0) / Math.max(1, vals.length);
      return popOf(state, n.city, n.target) > avg;
    }
    default: return false;
  }
}
export function newsText(n) {
  const t = NEWS[n.template].label.replace('{t}', name(n.target)).replace('{g}', n.goodName || '');
  return t;
}

/* ---------- Költség ---------- */
export function orderCost(state, o) {
  const a = ACTIONS[o.type];
  let gold = a.gold ?? 0;
  if (o.type === 'buyShares') gold = RULES.cityShareCost * o.pts;
  if (o.type === 'buyout') gold = Math.ceil(marketValue(state.cities[o.city].goods[o.good]) * o.pts * RULES.buyoutPremium);
  if (o.type === 'defend') gold = Math.ceil(marketValue(state.cities[o.city].goods[o.good]) * o.pts);
  if (o.type === 'festival' && isCampaign(state)) gold *= 2;
  return { pp: a.pp, gold };
}
export const isCampaign = (state) => (state.settlements + 1) % RULES.electionEvery === 0;
export function draftCost(state) { return state.draft.reduce((a, o) => ({ pp: a.pp + ACTIONS[o.type].pp, gold: a.gold + (o.gold ?? orderCost(state, o).gold) }), { pp: 0, gold: 0 }); }

export function orderLabel(state, o) {
  const a = ACTIONS[o.type], c = o.city ? NODES[o.city].name : '';
  const g = o.good ? state.cities[o.city].goods[o.good].name : '';
  switch (o.type) {
    case 'route': return `${a.label}: ${NODES[o.from].name} → ${NODES[o.to].name}`;
    case 'margin': return `${g} ára: ${margin(o.level).label} · ${c}`;
    case 'buyShares': return `${o.pts} részesedés (${g}) a Várostól · ${c}`;
    case 'buyout': return `Kivásárlás: ${o.pts} pont ${name(o.target)} részéből (${g}) · ${c}`;
    case 'defend': return `Védekező vétel (${g}) · ${c}`;
    case 'program': return `Program: ${program(o.level).label} · ${c}`;
    case 'news': return `Hír: ${newsText({ ...o, goodName: g })} · ${c}`;
    case 'spy': return `Kifürkészés: ${name(o.target)} parancslapja · ${c}`;
    case 'verify': case 'debunk': return `${a.label} · ${c}`;
    default: return `${a.label} · ${c}`;
  }
}

/* ---------- Érvényesség a parancslapra kerüléskor ---------- */
export function validate(state, player, o) {
  const cs = o.city && state.cities[o.city];
  if (o.type === 'route') {
    if (!EDGES.some(([a, b]) => edgeKey(a, b) === edgeKey(o.from, o.to))) return 'Ezen a két helyen között nincs út.';
    if (!reaches(state, player, o.from)) return 'Útvonalat csak a hálózatodból indíthatsz.';
    if (hasRoute(state, o.from, o.to)) return 'Ez az útvonal már a tiéd.';
    return null;
  }
  if (!reaches(state, player, o.city)) return 'Akciót csak a hálózatodban lévő városban indíthatsz (4.3). Építs előbb útvonalat.';
  const g = o.good && cs.goods[o.good];
  switch (o.type) {
    case 'margin': if (!(g.shares[player] > 0)) return 'Ehhez részesedés kell ebből az árucikkből.'; break;
    case 'buyShares': if (cityShare(g) < o.pts) return `A Várostól már csak ${cityShare(g)} pont vehető.`; break;
    case 'buyout': {
      if (!(g.shares[o.target] >= o.pts)) return 'A célpontnak nincs ennyi részesedése.';
      if ((state.protection[`${o.city}|${o.good}|${o.target}`] ?? -1) > state.settlements) return 'Ezt a kereskedőt nemrég vásárolták ki, most védett.';
      break;
    }
    case 'foundParty': if (cs.parties[player]) return 'Ebben a városban már van pártod.'; break;
    case 'program': case 'festival': if (!cs.parties[player]) return 'Ehhez párt kell ebben a városban.'; break;
    case 'hireSpy': if ((cs.spies[player] || 0) >= RULES.spiesPerCity) return `Városonként legfeljebb ${RULES.spiesPerCity} kém lehet.`; break;
    case 'guard': if ((cs.spies[player] || 0) - (cs.guards[player] || 0) < 1) return 'Nincs szabad kémed ebben a városban.'; break;
    case 'spy': if ((cs.spies[player] || 0) - (cs.guards[player] || 0) < 1) return 'Ehhez legalább egy szabad kém kell a városban.'; break;
    case 'verify': case 'debunk': {
      if ((cs.spies[player] || 0) < 1) return 'Ehhez kém kell a városban.';
      const n = state.news.find((x) => x.id === o.newsId);
      if (!n || n.debunked) return 'Nincs ilyen hír.';
      if (o.type === 'debunk' && state.knowledge.verified[n.id] !== false) return 'Előbb ellenőrizd, hogy hamis-e.';
      break;
    }
    default: break;
  }
  return null;
}

/* ---------- Játékos-műveletek ---------- */
export function addDraft(state, o) {
  const s = clone(state);
  const err = validate(s, 'te', o);
  if (err) return { ...s, lastError: err };
  const c = draftCost(s), add = orderCost(s, o);
  if (c.pp + add.pp > s.players.te.pp) return { ...s, lastError: `Nincs elég parancspont: ${c.pp + add.pp} kellene, ${s.players.te.pp} van.` };
  if (c.gold + add.gold > s.players.te.gold) return { ...s, lastError: `Nincs elég arany: ${c.gold + add.gold} kellene, ${s.players.te.gold} van.` };
  s.draft.push({ ...o, gold: add.gold, id: 'o' + s.seq++ });
  s.lastError = null;
  return s;
}

export function seal(state) {
  const s = clone(state);
  if (!s.draft.length) return { ...s, lastError: 'Üres parancslapot nem lehet lepecsételni.' };
  if (s.laps.some((l) => l.player === 'te')) return { ...s, lastError: 'Már van érlelő parancslapod. A következőt a végrehajtás után pecsételheted le.' };
  const cost = draftCost(s);
  s.players.te.pp -= cost.pp; s.players.te.gold -= cost.gold;
  s.laps.push({ id: 'L' + s.seq++, player: 'te', orders: s.draft, sealedAt: s.clock, executeAt: s.clock + RULES.maturationMin, cost });
  s.draft = [];
  s.lastError = null;
  return s;
}

export function sellInfo(state, intelId) {
  const s = clone(state);
  const it = s.knowledge.intel.find((x) => x.id === intelId);
  if (!it || it.sold) return s;
  const lap = s.laps.find((l) => l.id === it.lapId);
  if (!lap) return { ...s, lastError: 'Ez a parancslap már lefutott, az információ értéktelen.' };
  const buyer = Object.keys(HOUSES).find((h) => h !== 'te' && h !== lap.player && s.players[h].gold >= RULES.infoPrice);
  if (!buyer) return { ...s, lastError: 'Most senki sem venné meg.' };
  s.players[buyer].gold -= RULES.infoPrice; s.players.te.gold += RULES.infoPrice; it.sold = buyer;
  if (s.settlements - s.lastInfoSale >= 3) { s.players.te.legit += 1; s.lastInfoSale = s.settlements; }
  report(s, 'te', { kind: 'kem', title: `Információ eladva: ${name(buyer)}`, text: `${name(buyer)} ${RULES.infoPrice} aranyat fizetett ${name(lap.player)} terveiért. A letét lezárult.`, tone: 'ok' });
  return s;
}

/* ---------- Idő előretekerése ---------- */
export function advance(state, minutes) {
  let s = clone(state);
  const until = s.clock + minutes;
  for (let guard = 0; guard < 200; guard++) {
    const nextLap = s.laps.reduce((m, l) => Math.min(m, l.executeAt), Infinity);
    const nextSet = nextSettlement(s.clock);
    const t = Math.min(nextLap, nextSet);
    if (t > until) break;
    s.clock = t;
    if (nextLap <= nextSet) {
      const lap = s.laps.filter((l) => l.executeAt === t).sort((a, b) => a.sealedAt - b.sealedAt)[0];
      s.laps = s.laps.filter((l) => l !== lap);
      executeLap(s, lap);
    } else {
      settle(s);
      npcPlan(s);
    }
  }
  s.clock = until;
  return s;
}
export function nextEventIn(state) {
  const nextLap = state.laps.reduce((m, l) => Math.min(m, l.executeAt), Infinity);
  return Math.min(nextLap, nextSettlement(state.clock)) - state.clock;
}

function report(s, player, r) { if (player === 'te') s.reports.unshift({ id: 'r' + s.seq++, at: s.clock, ...r }); }
function publicReport(s, r) { s.reports.unshift({ id: 'r' + s.seq++, at: s.clock, public: true, ...r }); }

/* ---------- Parancslap végrehajtása (3.1) ---------- */
function executeLap(s, lap) {
  const p = lap.player, rng = rngOf(s.seq * 31 + s.clock);
  for (const o of lap.orders) {
    const cs = o.city && s.cities[o.city];
    const err = validate(s, p, o);
    if (err && o.type !== 'defend') {
      s.players[p].gold += o.gold ?? orderCost(s, o).gold; // az arany visszajár, a PP nem
      report(s, p, { kind: 'frakcio', title: 'Elmaradt: ' + ACTIONS[o.type].label, text: err + ' Az aranyat visszakaptad.', tone: 'warn' });
      continue;
    }
    const g = o.good && cs.goods[o.good];
    switch (o.type) {
      case 'route':
        s.routes.push([o.from, o.to]);
        report(s, p, { kind: 'diplomacia', title: `Új útvonal: ${NODES[o.to].name}`, text: `A karavánút megnyílt. ${NODES[o.to].name} mostantól a hálózatod része.`, tone: 'ok' });
        break;
      case 'margin':
        g.margins[p] = o.level;
        report(s, p, { kind: 'frakcio', title: `${g.name} ára: ${margin(o.level).label}`, text: `${NODES[o.city].name} üzleteiben az új árak kikerültek a pultra.`, tone: 'info' });
        break;
      case 'buyShares':
        g.shares[p] = (g.shares[p] || 0) + o.pts; g.margins[p] ||= 'piaci';
        report(s, p, { kind: 'frakcio', title: `+${o.pts} részesedés: ${g.name}`, text: `A városi tanács jóváhagyta az adásvételt. ${NODES[o.city].name} ${g.name.toLowerCase()}kínálatának ${g.shares[p]}%-a a tiéd.`, tone: 'ok' });
        break;
      case 'buyout': {
        const defended = s.events.some((e) => e.type === 'defend' && e.lapId === lap.id);
        const price = o.gold ?? orderCost(s, o).gold;
        if (defended) {
          s.players[p].gold += price;
          report(s, p, { kind: 'frakcio', title: 'Kivásárlás meghiúsult', text: `${name(o.target)} kiváltotta a részesedését. Az ajánlat árát visszakaptad.`, tone: 'warn' });
          report(s, o.target, { kind: 'frakcio', title: 'Megvédted a részesedésedet', text: `${name(p)} kivásárlási ajánlata elbukott.`, tone: 'ok' });
          break;
        }
        g.shares[o.target] -= o.pts; if (g.shares[o.target] <= 0) { delete g.shares[o.target]; delete g.margins[o.target]; }
        g.shares[p] = (g.shares[p] || 0) + o.pts; g.margins[p] ||= 'piaci';
        s.players[o.target].gold += price;
        s.protection[`${o.city}|${o.good}|${o.target}`] = s.settlements + RULES.buyoutProtection;
        s.events.push({ type: 'buyout', city: o.city, by: p, settlement: s.settlements });
        report(s, p, { kind: 'frakcio', title: `Kivásároltad ${name(o.target)}-t`, text: `${o.pts} pont ${g.name} ${price} aranyért. ${name(o.target)} 3 elszámolásig védett.`, tone: 'ok' });
        report(s, o.target, { kind: 'frakcio', title: `${name(p)} kivásárolt`, text: `${o.pts} pontot veszítettél a(z) ${g.name} árucikkből, ${price} aranyat kaptál érte.`, tone: 'danger' });
        break;
      }
      case 'defend':
        s.events.push({ type: 'defend', lapId: o.lapId });
        report(s, p, { kind: 'frakcio', title: 'Védekező vétel', text: `Kifizetted a Városnak a részesedésed árát. Ha a kivásárlás még nem futott le, meghiúsul.`, tone: 'info' });
        break;
      case 'foundParty':
        cs.parties[p] = 'kozepes'; cs.council[p] ||= 0;
        report(s, p, { kind: 'diplomacia', title: `Pártot alapítottál: ${NODES[o.city].name}`, text: 'A párt a következő választáson indul. Programja: közepes adó.', tone: 'ok' });
        break;
      case 'program':
        cs.parties[p] = o.level;
        report(s, p, { kind: 'diplomacia', title: `Új program: ${program(o.level).label}`, text: `A pártod ${NODES[o.city].name}ban meghirdette az új adóprogramot.`, tone: 'info' });
        break;
      case 'festival': {
        const key = `${o.city}|${p}`, recent = s.festivals[key] != null && s.settlements - s.festivals[key] < RULES.festivalCooldown;
        const gain = (recent ? RULES.festivalPop / 2 : RULES.festivalPop) * (isCampaign(s) ? 2 : 1);
        addPop(s, o.city, p, gain); s.festivals[key] = s.settlements;
        report(s, p, { kind: 'esemeny', title: `Fesztivál: +${gain} népszerűség`, text: recent ? 'A nép mulatott, de a legutóbbi ünnep még túl friss az emlékezetében.' : 'Zászlók, zene, sült ökör a főtéren. A városlakók a nevedet éltetik.', tone: 'ok' });
        break;
      }
      case 'news': {
        const n = { id: 'n' + s.seq++, city: o.city, author: p, target: o.target, template: o.template, good: o.good, goodName: g?.name, effect: NEWS[o.template].effect, createdAt: s.clock, debunked: false };
        n.trueAtCreation = newsTruth(s, n);
        addPop(s, o.city, o.target, n.effect);
        s.news.unshift(n);
        publicReport(s, { kind: 'frakcio', title: `Hír terjed ${NODES[o.city].name}ban`, text: newsText(n), tone: n.effect < 0 ? 'warn' : 'ok' });
        break;
      }
      case 'hireSpy':
        cs.spies[p] = (cs.spies[p] || 0) + 1;
        report(s, p, { kind: 'kem', title: `Új kém: ${NODES[o.city].name}`, text: `Egy megbízható ember az alvilágban. Kémeid itt: ${cs.spies[p]}.`, tone: 'ok' });
        break;
      case 'guard':
        cs.guards[p] = (cs.guards[p] || 0) + 1;
        report(s, p, { kind: 'kem', title: 'Őr beállítva', text: `${NODES[o.city].name}ban ${cs.guards[p]} kémed figyeli az idegen ügynököket.`, tone: 'info' });
        break;
      case 'spy': {
        if (caught(s, o.city, p, o.target, rng)) break;
        const target = s.laps.find((l) => l.player === o.target);
        if (!target) { report(s, p, { kind: 'kem', title: 'Nincs mit kifürkészni', text: `${name(o.target)} parancslapja már lefutott, vagy nincs érlelő parancslapja.`, tone: 'warn' }); break; }
        const free = (cs.spies[p] || 0) - (cs.guards[p] || 0);
        const lines = target.orders.map((x) => free >= 3 ? `${orderLabel(s, x)} (${orderCost(s, x).gold} A)` : free >= 2 ? orderLabel(s, x) : ACTIONS[x.type].label);
        const intel = { id: 'i' + s.seq++, lapId: target.id, of: o.target, executeAt: target.executeAt, lines, depth: Math.min(3, free) };
        if (p === 'te') s.knowledge.intel.unshift(intel);
        report(s, p, { kind: 'kem', confidence: free >= 3 ? 'eros' : free >= 2 ? 'kozepes' : 'gyenge', title: `${name(o.target)} tervei (lejár: ${fmtClock(target.executeAt)})`, text: lines.join(' · '), tone: 'info' });
        if (o.target === 'te' || p !== 'te') npcReactToIntel(s, p, target);
        break;
      }
      case 'verify': {
        const n = s.news.find((x) => x.id === o.newsId);
        if (p === 'te') s.knowledge.verified[n.id] = n.trueAtCreation;
        report(s, p, { kind: 'kem', confidence: 'eros', title: n.trueAtCreation ? 'A hír igaz volt' : 'A hír hamis!', text: `${newsText(n)} ${n.trueAtCreation ? 'A terjesztő nem hazudott.' : `${name(n.author)} tudatosan hazudott. Leleplezheted.`}`, tone: n.trueAtCreation ? 'info' : 'warn' });
        break;
      }
      case 'debunk': {
        const n = s.news.find((x) => x.id === o.newsId);
        n.debunked = true;
        addPop(s, n.city, n.target, -n.effect);
        addPop(s, n.city, n.author, -RULES.debunkPenalty);
        addPop(s, n.city, p, RULES.debunkReward.pop);
        s.players[p].gold += RULES.debunkReward.gold; s.players[p].legit += RULES.debunkReward.legit;
        publicReport(s, { kind: 'kem', title: `Leleplezve: ${name(n.author)} hazudott`, text: `${newsText(n)} A hír hamis volt. ${name(n.author)} −${RULES.debunkPenalty} népszerűség, ${name(p)} jutalma +${RULES.debunkReward.gold} arany és +${RULES.debunkReward.legit} Legitimitás.`, tone: 'ok' });
        break;
      }
      default: break;
    }
  }
}

function caught(s, city, attacker, victim, rng) {
  const guards = s.cities[city].guards[victim] || 0;
  const chance = Math.min(RULES.guardMax, guards * RULES.guardChance);
  if (!guards || rng() >= chance) return false;
  const cs = s.cities[city];
  cs.spies[attacker] = Math.max(0, (cs.spies[attacker] || 0) - 1);
  addPop(s, city, attacker, -3);
  report(s, attacker, { kind: 'kem', title: 'Lebukott a kémed', text: `${name(victim)} őrei elfogták az ügynöködet ${NODES[city].name}ban. A kém elveszett, és −3 népszerűséget kaptál.`, tone: 'danger' });
  report(s, victim, { kind: 'kem', confidence: 'eros', title: `Elfogtuk ${name(attacker)} kémjét`, text: `Az őreid ${NODES[city].name}ban lefülelték az ügynököt.`, tone: 'ok' });
  return true;
}

/* ---------- Elszámolás (3.2) ---------- */
function settle(s) {
  const inc = {}; Object.keys(s.players).forEach((p) => { inc[p] = { gold: 0, legit: 0 }; });
  for (const city of CITIES) {
    const cs = s.cities[city];
    const profits = {};
    // 5.3 Kereslet és értékesítés
    for (const [gid, g] of Object.entries(cs.goods)) {
      const sellers = Object.entries(g.shares).filter(([, v]) => v > 0).map(([p, v]) => ({ p, cap: g.supply * v / 100, m: margin(g.margins[p]).m, pop: popOf(s, city, p) }));
      const cityPts = cityShare(g);
      if (cityPts > 0) sellers.push({ p: '_varos', cap: g.supply * cityPts / 100, m: 0.3, pop: 20 });
      sellers.forEach((x) => { x.w = x.cap * (1 + x.pop / 100) / (1 + x.m); x.sold = 0; });
      let rem = g.demand, active = sellers.filter((x) => x.cap > 0);
      for (let k = 0; k < 10 && rem > 1e-6 && active.length; k++) {
        const W = active.reduce((a, x) => a + x.w, 0); let left = 0;
        active.forEach((x) => { const want = rem * x.w / W, give = Math.min(want, x.cap - x.sold); x.sold += give; left += want - give; });
        rem = left; active = active.filter((x) => x.cap - x.sold > 1e-6);
      }
      g.sold = {};
      let totalProfit = 0, totalPts = 0;
      sellers.forEach((x) => {
        const profit = x.sold * RULES.basePrice * x.m;
        g.sold[x.p] = r1(x.sold);
        if (x.p !== '_varos') { profits[x.p] = (profits[x.p] || 0) + profit; addPop(s, city, x.p, margin(g.margins[x.p]).pop); totalProfit += profit; totalPts += g.shares[x.p]; }
      });
      g.history.push(totalPts ? totalProfit / totalPts : 0.3); g.history = g.history.slice(-3);
      // legolcsóbb eladó bónusz
      const players = sellers.filter((x) => x.p !== '_varos');
      if (players.length > 1) {
        const min = Math.min(...players.map((x) => x.m)), cheapest = players.filter((x) => x.m === min);
        if (cheapest.length === 1) addPop(s, city, cheapest[0].p, 1);
      }
      // Legitimitás: az árucikk legnagyobb eladója
      const top = players.slice().sort((a, b) => b.sold - a.sold)[0];
      if (top && top.sold > 0) inc[top.p].legit += 2;
    }
    // 6.2 Adó
    const rate = taxRate(s, city), base = Object.values(profits).reduce((a, b) => a + b, 0);
    const pool = base * rate, seats = Object.entries(cs.council).filter(([, v]) => v > 0), totalSeats = seats.reduce((a, [, v]) => a + v, 0);
    Object.entries(profits).forEach(([p, v]) => { inc[p].gold += v * (totalSeats ? 1 - rate : 1); });
    if (totalSeats) seats.forEach(([p, v]) => { inc[p].gold += pool * v / totalSeats; });
    cs.lastTax = { rate, pool: r1(totalSeats ? pool : 0) };
    // Program hatása a népszerűségre
    Object.entries(cs.parties).forEach(([p, prog]) => addPop(s, city, p, program(prog).pop));
    // Legitimitás: mandátum, többség, legnépszerűbb
    seats.forEach(([p, v]) => { inc[p].legit += v + (v >= 5 ? 3 : 0); });
    const popTop = Object.entries(cs.pop).sort((a, b) => b[1] - a[1]);
    if (popTop.length && (popTop.length === 1 || popTop[0][1] > popTop[1][1])) inc[popTop[0][0]].legit += 2;
    // Kémek fenntartása
    Object.entries(cs.spies).forEach(([p, n]) => { inc[p].gold -= n * RULES.spyUpkeep; });
    // Visszahúzás az alapértékhez
    Object.keys(cs.pop).forEach((p) => { const v = cs.pop[p]; cs.pop[p] = r1(v > RULES.popBase ? Math.max(RULES.popBase, v - RULES.popDrift) : Math.min(RULES.popBase, v + RULES.popDrift)); });
  }
  // Útvonalak fenntartása, bevétel, PP
  inc.te.gold -= s.routes.length * RULES.routeUpkeep;
  Object.entries(inc).forEach(([p, v]) => {
    const pl = s.players[p];
    pl.gold = Math.max(0, Math.round((pl.gold + v.gold) * 10) / 10);
    pl.legit += v.legit;
    pl.pp = Math.min(RULES.ppMax, pl.pp + RULES.ppPerSettlement);
  });
  s.settlements += 1;
  const t = inc.te;
  report(s, 'te', { kind: 'esemeny', title: `Elszámolás · ${fmtClock(s.clock)}`, text: `Bevétel: ${t.gold >= 0 ? '+' : ''}${r1(t.gold)} arany (haszon, adó, fenntartás), +${t.legit} Legitimitás, +${RULES.ppPerSettlement} PP.`, tone: 'info' });
  if (s.settlements % RULES.electionEvery === 0) elections(s);
}

/* ---------- Választás (6.3), D'Hondt ---------- */
export function dhondt(votes, seats, threshold) {
  const total = Object.values(votes).reduce((a, b) => a + b, 0);
  const ok = Object.entries(votes).filter(([, v]) => total && v / total >= threshold);
  const out = Object.fromEntries(ok.map(([p]) => [p, 0]));
  for (let i = 0; i < seats; i++) {
    const best = ok.map(([p, v]) => [p, v / (out[p] + 1)]).sort((a, b) => b[1] - a[1])[0];
    if (!best) break; out[best[0]] += 1;
  }
  return out;
}
function elections(s) {
  for (const city of CITIES) {
    const cs = s.cities[city];
    const votes = Object.fromEntries(Object.keys(cs.parties).map((p) => [p, popOf(s, city, p)]));
    if (!Object.keys(votes).length) continue;
    const before = { ...cs.council };
    cs.council = dhondt(votes, RULES.councilSeats, RULES.electionThreshold);
    const list = Object.entries(cs.council).filter(([, v]) => v > 0).sort((a, b) => b[1] - a[1]).map(([p, v]) => `${name(p)} ${v}`).join(', ');
    publicReport(s, { kind: 'diplomacia', title: `Választás: ${NODES[city].name}`, text: `Az új tanács: ${list || 'senki sem jutott be'}.`, tone: 'info' });
    if (cs.parties.te) {
      const now = cs.council.te || 0, was = before.te || 0;
      if (now !== was) report(s, 'te', { kind: 'diplomacia', title: now > was ? `+${now - was} mandátum: ${NODES[city].name}` : `−${was - now} mandátum: ${NODES[city].name}`, text: now ? `A pártodnak ${now} helye van a tanácsban.` : 'A pártod kiesett a tanácsból.', tone: now > was ? 'ok' : 'warn' });
    }
  }
}

/* ---------- NPC-házak ---------- */
function npcPlan(s) {
  const rng = rngOf(s.settlements * 7919 + 13);
  for (const h of Object.keys(HOUSES).filter((x) => HOUSES[x].npc)) {
    if (s.laps.some((l) => l.player === h)) continue;
    const pl = s.players[h], persona = HOUSES[h].persona, orders = [];
    let pp = pl.pp, gold = pl.gold;
    const push = (o) => { if (validate(s, h, o)) return; const c = orderCost(s, o); if (c.pp <= pp && c.gold <= gold) { pp -= c.pp; gold -= c.gold; orders.push({ ...o, gold: c.gold, id: 'o' + s.seq++ }); } };
    const cities = CITIES.slice().sort(() => rng() - 0.5);
    if (persona === 'kalmar') {
      for (const c of cities) for (const [gid, g] of Object.entries(s.cities[c].goods)) {
        if (g.shares[h] && popOf(s, c, h) < 15 && g.margins[h] !== 'olcso') push({ type: 'margin', city: c, good: gid, level: 'olcso' });
        else if (g.shares[h] && popOf(s, c, h) > 30 && g.margins[h] !== 'draga') push({ type: 'margin', city: c, good: gid, level: 'draga' });
        if (cityShare(g) >= 5 && rng() < 0.3) push({ type: 'buyShares', city: c, good: gid, pts: 5 });
      }
    } else if (persona === 'felvasarlo') {
      const recent = s.events.some((e) => e.type === 'buyout' && e.by === h && s.settlements - e.settlement < 3);
      if (!recent) for (const c of cities) for (const [gid, g] of Object.entries(s.cities[c].goods)) {
        if (g.shares.te >= 5 && rng() < 0.35 && !orders.some((x) => x.type === 'buyout')) push({ type: 'buyout', city: c, good: gid, target: 'te', pts: Math.min(5, g.shares.te) });
      }
      push({ type: 'buyShares', city: cities[0], good: Object.keys(s.cities[cities[0]].goods)[0], pts: 5 });
    } else if (persona === 'politikus') {
      for (const c of cities) {
        const cs = s.cities[c];
        if (!cs.parties[h] && gold > 60) push({ type: 'foundParty', city: c });
        if (cs.parties[h] && (isCampaign(s) || rng() < 0.3)) push({ type: 'festival', city: c });
        if (cs.parties.te && rng() < 0.4) push({ type: 'news', city: c, target: 'te', template: 'adoemeles' });
      }
    } else if (persona === 'kem') {
      for (const c of cities) {
        const cs = s.cities[c];
        if ((cs.spies[h] || 0) < 2 && rng() < 0.4) push({ type: 'hireSpy', city: c });
        const myLap = s.laps.find((l) => l.player === 'te');
        if (myLap && (cs.spies[h] || 0) > 0) push({ type: 'spy', city: c, target: 'te' });
        const g = Object.entries(cs.goods).find(([, gg]) => gg.shares.te);
        if (g && rng() < 0.35) push({ type: 'news', city: c, target: 'te', template: 'uzsora', good: g[0] }); // gyakran hamis
      }
    }
    if (!orders.length) continue;
    const cost = orders.reduce((a, o) => ({ pp: a.pp + ACTIONS[o.type].pp, gold: a.gold + o.gold }), { pp: 0, gold: 0 });
    pl.pp -= cost.pp; pl.gold -= cost.gold;
    const offset = RULES.maturationMin + 30 + Math.floor(rng() * 180); // az NPC-k nem egyszerre végeznek; a kivásárlás ellen így van idő védekezni
    s.laps.push({ id: 'L' + s.seq++, player: h, orders, sealedAt: s.clock, executeAt: s.clock + offset, cost });
    // A kivásárlási ajánlat nyilvános a célpont számára (5.4)
    orders.filter((o) => o.type === 'buyout' && o.target === 'te').forEach((o) => {
      report(s, 'te', { kind: 'frakcio', title: `${name(h)} ki akar vásárolni`, text: `${o.pts} pontot akar a(z) ${s.cities[o.city].goods[o.good].name} részesedésedből (${NODES[o.city].name}). Az ajánlat ${fmtClock(s.clock + offset)}-kor fut le. Védekező vétellel kiválthatod.`, tone: 'danger', buyout: { city: o.city, good: o.good, pts: o.pts, lapId: s.laps[s.laps.length - 1].id } });
    });
  }
}
function npcReactToIntel() { /* 0.0.2: az NPC-k még nem reagálnak a kémjelentésekre */ }

/* ---------- Nézet-segédek ---------- */
export function cityOverview(s, city) {
  const cs = s.cities[city];
  const goods = Object.entries(cs.goods).map(([id, g]) => ({ id, ...g, cityPts: cityShare(g), value: marketValue(g) }));
  return { goods, pop: cs.pop, parties: cs.parties, council: cs.council, spies: cs.spies, guards: cs.guards, tax: taxRate(s, city), lastTax: cs.lastTax };
}
export function nextElectionIn(s) { return RULES.electionEvery - (s.settlements % RULES.electionEvery); }
export { MARGINS };
