import { useState } from 'react';
import T from '../ds/index.js';
import { NODES, EDGES, TERRAIN, HOUSES } from '../game/world.js';
import { network, hasRoute, edgeKey, buildableRoutesTo, draftCost, popOf, cityShare, name } from '../game/engine.js';
import { margin } from '../game/rules.js';
import { SeatsBar } from './parts.jsx';

function routeState(state, a, b) {
  if (hasRoute(state, a, b)) return { state: 'own' };
  const pending = [...state.draft, ...state.laps.filter((l) => l.player === 'te').flatMap((l) => l.orders)];
  if (pending.some((o) => o.type === 'route' && edgeKey(o.from, o.to) === edgeKey(a, b))) return { state: 'pending' };
  const est = [a, b].map((n) => NODES[n].estate).find((e) => e && e !== 'te');
  if (est) return { state: 'rival', tincture: HOUSES[est].tincture };
  return { state: 'base' };
}

export default function MapScreen({ state, dispatch, selected, onSelect, onOpenCity }) {
  const net = network(state);
  const cities = Object.values(NODES).filter((n) => n.city);
  const sel = selected && NODES[selected];
  const reachable = sel && net[selected] != null;
  const cs = sel && state.cities[selected];
  const cost = draftCost(state);
  const [zoom, setZoom] = useState(2);
  const focus = sel ? [sel.x / 360, sel.y / 260] : [0.35, 0.5];

  return (
    <>
      <T.CommandPoints available={state.players.te.pp} pending={cost.pp} />
      <T.MapViewport zoom={zoom} onZoom={setZoom} max={3.2} focus={focus} aspect="360 / 260">
      <T.MapCanvas width={360} height={260} title="Délkeleti tartományok térképe">
        <T.MapTerrain {...TERRAIN} />
        {EDGES.map(([a, b]) => { const rs = routeState(state, a, b); return <T.MapRoute key={a + b} from={[NODES[a].x, NODES[a].y]} to={[NODES[b].x, NODES[b].y]} state={rs.state} tincture={rs.tincture} />; })}
        {Object.values(NODES).filter((n) => n.estate).map((n) => <T.MapEstate key={n.id} x={n.x} y={n.y} tincture={HOUSES[n.estate].tincture} npc={n.estate !== 'te'} name={n.estate === 'te' ? n.name : undefined} />)}
        {sel ? <circle cx={sel.x} cy={sel.y} r={sel.key ? 16 : 14} fill="none" stroke="var(--verdigris)" strokeWidth="2" strokeDasharray="4 3" /> : null}
        {cities.map((c) => <T.MapCity key={c.id} x={c.x} y={c.y} name={c.name} keyCity={c.key} state={net[c.id] != null ? 'reachable' : 'unreachable'} />)}
        {cities.map((c) => (
          <circle className="map-hit" key={'hit' + c.id} cx={c.x} cy={c.y} r="22" fill="transparent" style={{ cursor: 'pointer' }} role="button" tabIndex={0}
            aria-label={c.name + (net[c.id] != null ? ', elérhető' : ', nem elérhető')}
            onClick={() => onSelect(c.id)} onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onSelect(c.id); } }} />
        ))}
        <T.MapCompass x={320} y={44} size={20} />
        <T.MapCartouche x={8} y={212} width={120} title="DÉLKELET" />
      </T.MapCanvas>
      </T.MapViewport>

      {!sel ? <p className="tn-muted" style={{ margin: 0 }}>Koppints egy városra a térképen.</p> : (
        <section className="tn-card" aria-label={'Kiválasztott város: ' + sel.name}>
          <div className="tn-fac-meta">
            <span className="tn-eyebrow">{sel.profile}{sel.key ? ' · kulcsváros' : ''}{reachable ? ` · ${net[selected]} lépés` : ''}</span>
            <span className="pop-chip"><T.GameIcon name="nep" size={16} />Népszerűséged <b className="tn-num">{Math.round(popOf(state, selected, 'te'))}</b></span>
          </div>
          <h2 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>{sel.name}</h2>
          {!reachable ? <T.Toast tone="warn" title="Nem vezet ide útvonalad">Akciót csak a hálózatodban lévő városban indíthatsz. Építs útvonalat egy szomszédos városból.</T.Toast> : null}
          <div className="mini-goods">
            {Object.entries(cs.goods).map(([gid, g]) => (
              <div key={gid} className="mini-good">
                <span className="good-title"><T.GameIcon name={gid} size={24} /><span className="tn-report-title" style={{ fontSize: 15 }}>{g.name}</span></span>
                <span className="tn-muted tn-num" style={{ fontSize: 12 }}>{g.supply} / {g.demand}</span>
                <span style={{ fontSize: 13 }}>{g.shares.te ? <>Részesedésed <b className="tn-num">{g.shares.te}</b> · {margin(g.margins.te).label}</> : <span className="tn-muted">Nincs részesedésed · Város: {cityShare(g)}</span>}</span>
              </div>
            ))}
          </div>
          <SeatsBar council={cs.council} />
          <div className="tn-row" style={{ justifyContent: 'flex-end' }}>
            {buildableRoutesTo(state, selected).map(([from, to]) => (
              <T.Button key={from} art="route" onClick={() => dispatch({ type: 'addDraft', order: { type: 'route', from, to } })}>Útvonal innen: {NODES[from].name}</T.Button>
            ))}
            <T.Button variant="primary" icon="varos" onClick={() => onOpenCity(selected)}>Város megnyitása</T.Button>
          </div>
        </section>
      )}
    </>
  );
}
