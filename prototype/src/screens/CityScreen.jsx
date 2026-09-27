import { useState } from 'react';
import T from '../ds/index.js';
import { NODES, HOUSES } from '../game/world.js';
import { MARGINS, PROGRAMS, NEWS, RULES, margin, program } from '../game/rules.js';
import { network, buildableRoutesTo, popOf, cityShare, marketValue, taxRate, newsTruth, newsText, nextElectionIn, isCampaign, fmtClock, fmtDur, name } from '../game/engine.js';
import { SeatsBar, ShareBar, Cost } from './parts.jsx';

// A városnézet negyedkulcsai (a CityView komponensben) → a v0.2 intézményei
const TABS = [
  { id: 'kereskedok', label: 'Vásártér', sub: 'Kereskedők', art: 'vasarter' },
  { id: 'nemesseg', label: 'Városháza', sub: 'Politika', art: 'varoshaza' },
  { id: 'katonasag', label: 'Alvilág', sub: 'Kémhálózat', art: 'alvilag' },
];

export default function CityScreen({ state, dispatch, city, district, onDistrict, onBack }) {
  const node = NODES[city], cs = state.cities[city];
  const net = network(state), reachable = net[city] != null;
  const add = (order) => dispatch({ type: 'addDraft', order: { city, ...order } });

  const topSeller = Object.values(cs.goods).flatMap((g) => Object.entries(g.shares)).reduce((m, [p, v]) => { m[p] = (m[p] || 0) + v; return m; }, {});
  const topS = Object.entries(topSeller).sort((a, b) => b[1] - a[1])[0];
  const topP = Object.entries(cs.council).sort((a, b) => b[1] - a[1])[0];
  const districts = {
    kereskedok: { dominant: topS ? HOUSES[topS[0]].tincture : null },
    nemesseg: { dominant: topP && topP[1] > 0 ? HOUSES[topP[0]].tincture : null },
    katonasag: {},
  };

  return (
    <>
      <div className="tn-stack" style={{ gap: 6 }}>
        <button type="button" className="tn-btn tn-btn-quiet tn-btn-sm" style={{ alignSelf: 'flex-start', marginLeft: -12 }} onClick={onBack}>← Térkép</button>
        <span className="tn-eyebrow">{node.profile}{node.key ? ' · kulcsváros' : ''}{reachable ? ` · ${net[city]} lépés` : ' · nem elérhető'}</span>
        <h1 className="tn-city-title">{node.name}</h1>
        <div className="tn-row" style={{ gap: 8 }}>
          <span className="pop-chip"><T.GameIcon name="nep" size={16} />Népszerűséged <b className="tn-num">{Math.round(popOf(state, city, 'te'))}</b></span>
          <span className="pop-chip"><T.GameIcon name="ado" size={16} />Adó <b className="tn-num">{Math.round(taxRate(state, city) * 100)}%</b></span>
          <span className="pop-chip"><T.GameIcon name="foundParty" size={16} />Választás <b className="tn-num">{nextElectionIn(state)}</b> elszámolás múlva</span>
        </div>
      </div>

      <T.CityView name={node.name} coast={node.coast} stability="stabil" selected={district} onSelect={onDistrict} districts={districts} />
      <T.Tabs active={district} onChange={onDistrict} tabs={TABS.map((t) => ({ id: t.id, label: t.label, art: t.art, tone: t.art }))} />

      {!reachable ? (
        <section className="tn-card">
          <T.Toast tone="warn" title="Nem vezet ide útvonalad">Akciót csak a hálózatodban lévő városban indíthatsz (4.3). Nézni lehet, cselekedni nem.</T.Toast>
          <div className="tn-row">
            {buildableRoutesTo(state, city).map(([from, to]) => (
              <T.Button key={from} art="route" onClick={() => dispatch({ type: 'addDraft', order: { type: 'route', from, to } })}>Útvonal innen: {NODES[from].name} · 1 PP · 3 A</T.Button>
            ))}
          </div>
        </section>
      ) : null}

      {district === 'kereskedok' && <Market state={state} city={city} add={add} can={reachable} />}
      {district === 'nemesseg' && <TownHall state={state} city={city} add={add} can={reachable} />}
      {district === 'katonasag' && <Underworld state={state} city={city} add={add} can={reachable} dispatch={dispatch} />}
    </>
  );
}

/* ------------------------------------------------------------------ Vásártér */
function Market({ state, city, add, can }) {
  const cs = state.cities[city];
  const threats = state.laps.filter((l) => l.player !== 'te').flatMap((l) => l.orders.filter((o) => o.type === 'buyout' && o.target === 'te' && o.city === city).map((o) => ({ ...o, lapId: l.id, by: l.player, at: l.executeAt })));
  return (
    <>
      {threats.map((t) => (
        <section key={t.lapId + t.good} className="tn-card threat">
          <T.Toast tone="danger" title={`${name(t.by)} ki akar vásárolni`}>{t.pts} pont {cs.goods[t.good].name} · lefut: {fmtClock(t.at)} ({fmtDur(t.at - state.clock)} múlva)</T.Toast>
          {can ? <div><T.Button variant="danger" art="defend" onClick={() => add({ type: 'defend', good: t.good, pts: t.pts, lapId: t.lapId })}>Védekező vétel · {Math.ceil(marketValue(cs.goods[t.good]) * t.pts)} A</T.Button></div> : null}
          <span className="tn-field-hint">A védekező vétel csak akkor hat, ha a parancslapod előbb fut le, mint az ajánlat (érlelés: {fmtDur(RULES.maturationMin)}).</span>
        </section>
      ))}
      {Object.entries(cs.goods).map(([gid, g]) => <GoodCard key={gid} state={state} city={city} gid={gid} g={g} add={add} can={can} />)}
      <p className="tn-field-hint" style={{ margin: 0 }}>Haszon = eladott egység × {RULES.basePrice} A alapár × haszonkulcs. Az olcsóbb és népszerűbb eladó többet ad el; az olcsóság népszerűséget hoz, a drágaság aranyat.</p>
    </>
  );
}

function GoodCard({ state, city, gid, g, add, can }) {
  const [buyPts, setBuyPts] = useState(5);
  const [target, setTarget] = useState('');
  const [boPts, setBoPts] = useState(5);
  const mine = g.shares.te || 0, cityPts = cityShare(g), value = marketValue(g);
  const rivals = Object.entries(g.shares).filter(([p, v]) => p !== 'te' && v > 0 && !((state.protection[`${city}|${gid}|${p}`] ?? -1) > state.settlements));
  const tgt = target && rivals.some(([p]) => p === target) ? target : rivals[0]?.[0];
  const tgtMax = tgt ? Math.min(RULES.maxSharesPerOrder, g.shares[tgt]) : 0;
  const sellers = [...Object.entries(g.shares).filter(([, v]) => v > 0).sort((a, b) => b[1] - a[1]).map(([p, v]) => ({ p, v, m: g.margins[p], sold: g.sold[p] })),
    ...(cityPts > 0 ? [{ p: '_varos', v: cityPts, m: 'piaci', sold: g.sold._varos }] : [])];
  const cheapest = Math.min(...sellers.filter((x) => x.p !== '_varos').map((x) => margin(x.m).m));

  return (
    <section className="tn-card" aria-label={g.name}>
      <div className="tn-fac-meta">
        <span className="good-title"><T.GameIcon name={gid} size={30} /><span className="tn-report-title" style={{ fontSize: 18 }}>{g.name}</span></span>
        <span className="tn-muted tn-num" style={{ fontSize: 12 }}>kínálat {g.supply} · kereslet {g.demand} · érték {value} A/pont</span>
      </div>
      <ShareBar good={g} />
      <div className="tn-table-wrap">
        <table className="tn-table">
          <thead><tr><th>Eladó</th><th className="tn-r" style={{ fontFamily: 'var(--font-sans)' }}>Rész.</th><th>Fokozat</th><th className="tn-r" style={{ fontFamily: 'var(--font-sans)' }}>Eladott</th></tr></thead>
          <tbody>
            {sellers.map((x) => (
              <tr key={x.p} className={x.p === 'te' ? 'tn-self' : undefined}>
                <td>{x.p === '_varos' ? <span className="tn-muted">Város</span> : <span className="tn-row" style={{ gap: 6, flexWrap: 'nowrap' }}><T.HouseCrest tincture={HOUSES[x.p].tincture} size={14} name={name(x.p)} />{name(x.p)}</span>}</td>
                <td className="tn-r">{x.v}</td>
                <td>{margin(x.m).label}{x.p !== '_varos' && margin(x.m).m === cheapest ? <span className="cheap-tag">legolcsóbb</span> : null}</td>
                <td className="tn-r">{x.sold ?? '–'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {can && mine > 0 ? (
        <div className="tn-stack" style={{ gap: 6 }}>
          <span className="tn-field-label label-art"><T.GameIcon name="margin" size={16} />Haszonkulcsod · 1 PP</span>
          <div className="margin-row" role="radiogroup" aria-label={g.name + ' haszonkulcs'}>
            {MARGINS.map((m) => (
              <button key={m.id} type="button" role="radio" aria-checked={g.margins.te === m.id} className={'margin-btn' + (g.margins.te === m.id ? ' on' : '')}
                disabled={g.margins.te === m.id} onClick={() => add({ type: 'margin', good: gid, level: m.id })}>
                <b>{Math.round(m.m * 100)}%</b><span>{m.label}</span><span className="tn-muted">{m.pop > 0 ? '+' : ''}{m.pop} N</span>
              </button>
            ))}
          </div>
        </div>
      ) : null}
      {can ? (
        <div className="trade-row">
          <div className="trade">
            <T.Select id={`buy-${city}-${gid}`} label={`Vétel a Várostól (${cityPts} szabad)`} value={String(Math.min(buyPts, Math.max(1, cityPts)))} onChange={(e) => setBuyPts(Number(e.target.value))}
              options={Array.from({ length: Math.max(1, Math.min(RULES.maxSharesPerOrder, cityPts)) }, (_, i) => String(i + 1))} />
            <T.Button size="sm" art="buyShares" disabled={cityPts < 1} onClick={() => add({ type: 'buyShares', good: gid, pts: Math.min(buyPts, cityPts) })}>Vétel · {RULES.cityShareCost * Math.min(buyPts, cityPts)} A</T.Button>
          </div>
          {rivals.length ? (
            <div className="trade">
              <T.Select id={`bo-${city}-${gid}`} label="Kivásárlás" value={tgt} onChange={(e) => setTarget(e.target.value)} options={rivals.map(([p, v]) => ({ value: p, label: `${name(p)} (${v})` }))} />
              <T.Select id={`bop-${city}-${gid}`} label="Pont" value={String(Math.min(boPts, tgtMax))} onChange={(e) => setBoPts(Number(e.target.value))}
                options={Array.from({ length: Math.max(1, tgtMax) }, (_, i) => String(i + 1))} />
              <T.Button size="sm" variant="danger" art="buyout" onClick={() => add({ type: 'buyout', good: gid, target: tgt, pts: Math.min(boPts, tgtMax) })}>Ajánlat · {Math.ceil(value * Math.min(boPts, tgtMax) * RULES.buyoutPremium)} A</T.Button>
            </div>
          ) : null}
        </div>
      ) : null}
    </section>
  );
}

/* ------------------------------------------------------------------ Városháza */
function TownHall({ state, city, add, can }) {
  const cs = state.cities[city];
  const present = Array.from(new Set([...Object.keys(cs.pop), ...Object.keys(cs.parties), ...Object.values(cs.goods).flatMap((g) => Object.keys(g.shares))])).filter((p) => p !== 'te');
  const [tpl, setTpl] = useState('uzsora');
  const [target, setTarget] = useState('');
  const tgt = present.includes(target) ? target : present[0];
  const tgtGoods = Object.entries(cs.goods).filter(([, g]) => g.shares[tgt]);
  const [goodSel, setGood] = useState('');
  const gsel = tgtGoods.some(([id]) => id === goodSel) ? goodSel : tgtGoods[0]?.[0];
  const draftNews = { city, template: tpl, target: tgt, good: NEWS[tpl].needsGood ? gsel : undefined };
  const truth = tgt && (!NEWS[tpl].needsGood || gsel) ? newsTruth(state, draftNews) : null;
  const parties = Object.entries(cs.parties).map(([p, prog]) => ({ p, prog, votes: Math.round(popOf(state, city, p)), seats: cs.council[p] || 0 })).sort((a, b) => b.votes - a.votes);
  const myParty = cs.parties.te;
  const news = state.news.filter((n) => n.city === city).slice(0, 6);

  return (
    <>
      <section className="tn-card" aria-label="Tanács">
        <div className="tn-fac-meta">
          <span className="good-title"><T.GameIcon name="varoshaza" size={26} /><span className="tn-report-title" style={{ fontSize: 18 }}>Városi tanács</span></span>
          <span className="tn-muted" style={{ fontSize: 13 }}>Választás {nextElectionIn(state)} elszámolás múlva{isCampaign(state) ? ' · kampányidőszak' : ''}</span>
        </div>
        <SeatsBar council={cs.council} />
        <span className="tn-muted" style={{ fontSize: 13 }}>Adókulcs: {Math.round(taxRate(state, city) * 100)}%{cs.lastTax ? ` · legutóbb ${cs.lastTax.pool} A jutott a pártoknak` : ''}</span>
        <div className="tn-table-wrap">
          <table className="tn-table">
            <thead><tr><th>Párt</th><th>Program</th><th className="tn-r" style={{ fontFamily: 'var(--font-sans)' }}>Szavazat</th><th className="tn-r" style={{ fontFamily: 'var(--font-sans)' }}>Hely</th></tr></thead>
            <tbody>
              {parties.length ? parties.map((x) => (
                <tr key={x.p} className={x.p === 'te' ? 'tn-self' : undefined}>
                  <td><span className="tn-row" style={{ gap: 6, flexWrap: 'nowrap' }}><T.HouseCrest tincture={HOUSES[x.p].tincture} size={14} name={name(x.p)} />{name(x.p)}</span></td>
                  <td>{program(x.prog).label}</td><td className="tn-r">{x.votes}</td><td className="tn-r">{x.seats}</td>
                </tr>
              )) : <tr><td colSpan={4} className="tn-muted">Még nincs párt a városban.</td></tr>}
            </tbody>
          </table>
        </div>
      </section>

      {can ? (
        <section className="tn-card" aria-label="A pártod">
          <span className="tn-eyebrow">A pártod</span>
          {!myParty ? (
            <>
              <span>Párt nélkül nem jutsz be a tanácsba, és nem kapsz adót. A szavazataid a népszerűségeddel egyenlők.</span>
              <div><T.Button art="foundParty" onClick={() => add({ type: 'foundParty' })}>Pártalapítás · 2 PP · {RULES.partyCost} A</T.Button></div>
            </>
          ) : (
            <>
              <span className="tn-field-label label-art"><T.GameIcon name="program" size={16} />Program · 1 PP</span>
              <div className="margin-row" role="radiogroup" aria-label="Adóprogram">
                {PROGRAMS.map((pr) => (
                  <button key={pr.id} type="button" role="radio" aria-checked={myParty === pr.id} className={'margin-btn' + (myParty === pr.id ? ' on' : '')}
                    disabled={myParty === pr.id} onClick={() => add({ type: 'program', level: pr.id })}>
                    <b>{Math.round(pr.rate * 100)}%</b><span>{pr.label}</span><span className="tn-muted">{pr.pop > 0 ? '+' : ''}{pr.pop} N</span>
                  </button>
                ))}
              </div>
              <div><T.Button art="festival" onClick={() => add({ type: 'festival' })}>Fesztivál · 2 PP · {RULES.festivalGold * (isCampaign(state) ? 2 : 1)} A · +{RULES.festivalPop * (isCampaign(state) ? 2 : 1)} N</T.Button></div>
            </>
          )}
        </section>
      ) : null}

      {can && present.length ? (
        <section className="tn-card" aria-label="Hír terjesztése">
          <span className="tn-eyebrow label-art"><T.GameIcon name="news" size={16} />Hír terjesztése · 2 PP · {RULES.newsGold} A</span>
          <div className="trade-row">
            <T.Select id="news-tpl" label="Állítás" value={tpl} onChange={(e) => setTpl(e.target.value)} options={Object.entries(NEWS).map(([id, n]) => ({ value: id, label: n.label.replace('{t}', 'X').replace('{g}', '…') }))} />
            <T.Select id="news-tgt" label="Kiről" value={tgt} onChange={(e) => setTarget(e.target.value)} options={present.map((p) => ({ value: p, label: name(p) }))} />
            {NEWS[tpl].needsGood ? <T.Select id="news-good" label="Árucikk" value={gsel || ''} onChange={(e) => setGood(e.target.value)} options={tgtGoods.length ? tgtGoods.map(([id, g]) => ({ value: id, label: g.name })) : [{ value: '', label: 'nincs árucikke' }]} /> : null}
          </div>
          {truth != null ? <T.Toast tone={truth ? 'ok' : 'warn'} title={truth ? 'Ez az állítás jelenleg igaz.' : 'Ez az állítás jelenleg nem igaz.'}>{truth ? 'Nyugodtan terjesztheted.' : 'Ha egy kém ellenőrzi és leleplezi, −10 népszerűséget kapsz, a célpont pedig visszanyeri a veszteségét.'}</T.Toast> : null}
          <div><T.Button art="news" variant={NEWS[tpl].effect < 0 ? 'danger' : 'default'} disabled={!tgt || (NEWS[tpl].needsGood && !gsel)} onClick={() => add({ type: 'news', ...draftNews })}>Parancslapra · {NEWS[tpl].effect > 0 ? '+' : ''}{NEWS[tpl].effect} N {name(tgt || '')}</T.Button></div>
        </section>
      ) : null}

      {news.length ? (
        <section className="tn-card" aria-label="Hírek">
          <span className="tn-eyebrow">A városban terjedő hírek</span>
          {news.map((n) => <NewsRow key={n.id} n={n} state={state} />)}
        </section>
      ) : null}
    </>
  );
}

function NewsRow({ n, state, actions }) {
  const known = state.knowledge.verified[n.id];
  return (
    <div className="news-row">
      <div>
        <p className="tn-report-text" style={{ margin: 0 }}>{newsText(n)}</p>
        <span className="tn-field-hint">Terjesztette: {name(n.author)} · {fmtClock(n.createdAt)}{n.debunked ? ' · LELEPLEZVE' : ''}{known === true ? ' · ellenőrizve: igaz' : known === false ? ' · ellenőrizve: hamis' : ''}</span>
      </div>
      {actions}
    </div>
  );
}

/* ------------------------------------------------------------------ Alvilág */
function Underworld({ state, city, add, can, dispatch }) {
  const cs = state.cities[city];
  const mine = cs.spies.te || 0, guards = cs.guards.te || 0, free = mine - guards;
  const others = state.laps.filter((l) => l.player !== 'te');
  const checkable = state.news.filter((n) => n.city === city && n.author !== 'te' && !n.debunked).slice(0, 6);
  const intel = state.knowledge.intel.slice(0, 5);
  const foreign = Object.entries(cs.spies).filter(([p, n]) => p !== 'te' && n > 0);

  return (
    <>
      <section className="tn-card" aria-label="Kémeid">
        <div className="tn-fac-meta">
          <span className="good-title"><T.GameIcon name="hireSpy" size={26} /><span className="tn-report-title" style={{ fontSize: 18 }}>Kémeid itt</span></span>
          <span className="tn-num">{mine} / {RULES.spiesPerCity}</span>
        </div>
        <span className="tn-muted" style={{ fontSize: 13 }}>{free} szabad ügynök, {guards} őr · fenntartás {RULES.spyUpkeep} A kémenként elszámolásonként</span>
        <span className="tn-muted" style={{ fontSize: 13 }}>Pletykák szerint idegen kémek is vannak itt: {foreign.length ? foreign.map(([p]) => name(p)).join(', ') : 'senkiről sem tudni'}.</span>
        {can ? (
          <div className="tn-row">
            <T.Button art="hireSpy" disabled={mine >= RULES.spiesPerCity} onClick={() => add({ type: 'hireSpy' })}>Kém felfogadása · 1 PP · {RULES.spyCost} A</T.Button>
            <T.Button art="guard" disabled={free < 1} onClick={() => add({ type: 'guard' })}>Őr beállítása · 1 PP</T.Button>
          </div>
        ) : null}
        <span className="tn-field-hint">Egy szabad kém az akciók típusát, kettő a célpontot is, három a költséget is kifürkészi. Minden őr 25% eséllyel buktatja le az ellened indított kémakciót.</span>
      </section>

      <section className="tn-card" aria-label="Érlelő parancslapok">
        <span className="tn-eyebrow label-art"><T.GameIcon name="spy" size={16} />Érlelő parancslapok</span>
        {others.length ? others.map((l) => (
          <div key={l.id} className="news-row">
            <div className="tn-row" style={{ gap: 8 }}>
              <T.HouseCrest tincture={HOUSES[l.player].tincture} size={18} name={name(l.player)} />
              <span><b>{name(l.player)}</b> · lefut {fmtClock(l.executeAt)} <span className="tn-muted">({fmtDur(l.executeAt - state.clock)} múlva)</span></span>
            </div>
            {can ? <T.Button size="sm" art="spy" disabled={free < 1} onClick={() => add({ type: 'spy', target: l.player })}>Kifürkészés · 1 PP</T.Button> : null}
          </div>
        )) : <span className="tn-muted">Most senkinek sincs érlelő parancslapja.</span>}
        <span className="tn-field-hint">A jelentés a saját parancslapod lefutásakor érkezik ({fmtDur(RULES.maturationMin)} érlelés). Csak akkor ér valamit, ha a célpont később fut le, mint a tiéd.</span>
      </section>

      {intel.length ? (
        <section className="tn-card" aria-label="Kifürkészett tervek">
          <span className="tn-eyebrow">Kifürkészett tervek</span>
          {intel.map((it) => {
            const live = state.laps.some((l) => l.id === it.lapId);
            return (
              <div key={it.id} className="news-row">
                <div>
                  <b>{name(it.of)}</b> · lefut {fmtClock(it.executeAt)}{live ? '' : ' · már lefutott'}
                  <div className="tn-muted" style={{ fontSize: 13 }}>{it.lines.join(' · ')}</div>
                </div>
                {live && !it.sold ? <T.Button size="sm" art="arany" onClick={() => dispatch({ type: 'sellInfo', id: it.id })}>Eladás · {RULES.infoPrice} A</T.Button> : it.sold ? <span className="tn-muted" style={{ fontSize: 12 }}>eladva: {name(it.sold)}</span> : null}
              </div>
            );
          })}
        </section>
      ) : null}

      <section className="tn-card" aria-label="Hírek ellenőrzése">
        <span className="tn-eyebrow label-art"><T.GameIcon name="verify" size={16} />Hírek ellenőrzése</span>
        {checkable.length ? checkable.map((n) => {
          const known = state.knowledge.verified[n.id];
          return (
            <NewsRow key={n.id} n={n} state={state} actions={can && mine > 0 ? (
              known === false
                ? <T.Button size="sm" variant="danger" art="debunk" onClick={() => add({ type: 'debunk', newsId: n.id })}>Leleplezés · 1 PP</T.Button>
                : known === undefined ? <T.Button size="sm" art="verify" onClick={() => add({ type: 'verify', newsId: n.id })}>Ellenőrzés · 1 PP</T.Button> : null
            ) : null} />
          );
        }) : <span className="tn-muted">Nincs ellenőrizhető hír a városban.</span>}
        <span className="tn-field-hint">Hamis hír leleplezéséért: +{RULES.debunkReward.pop} N, +{RULES.debunkReward.gold} A, +{RULES.debunkReward.legit} Legitimitás.</span>
      </section>
    </>
  );
}
