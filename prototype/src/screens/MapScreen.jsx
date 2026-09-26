import T from '../ds/index.js';
import { NODES, EDGES, TERRAIN, HOUSES } from '../game/world.js';
import { FACTIONS } from '../game/rules.js';
import { network, cityState, hasRoute, isBlocked, edgeKey, buildableRoutesTo, pendingPP } from '../game/engine.js';
import { factionView, bestLevel } from '../view.js';

function routeState(state, a, b) {
  if (isBlocked(state, a, b)) return { state: 'closed' };
  if (hasRoute(state, a, b)) return { state: 'own' };
  if (state.orders.some((o) => o.type === 'route' && edgeKey(o.from, o.to) === edgeKey(a, b))) return { state: 'pending' };
  const est = [a, b].map((n) => NODES[n].estate).find((e) => e && e !== 'te');
  if (est) return { state: 'rival', tincture: HOUSES[est].tincture };
  return { state: 'base' };
}

export default function MapScreen({ state, dispatch, selected, onSelect, onOpenCity }) {
  const net = network(state);
  const cities = Object.values(NODES).filter((n) => n.city);
  const sel = selected && NODES[selected];
  const reach = sel ? cityState(state, selected) : null;
  const buildable = sel && reach !== 'reachable' ? buildableRoutesTo(state, selected) : [];

  return (
    <>
      <T.CommandPoints available={state.resources.pp} pending={pendingPP(state)} />
      <T.MapCanvas width={360} height={260} title="Délkeleti tartományok térképe">
        <T.MapTerrain {...TERRAIN} />
        {EDGES.map(([a, b]) => { const rs = routeState(state, a, b); return <T.MapRoute key={a + b} from={[NODES[a].x, NODES[a].y]} to={[NODES[b].x, NODES[b].y]} state={rs.state} tincture={rs.tincture} />; })}
        {Object.values(NODES).filter((n) => n.estate).map((n) => <T.MapEstate key={n.id} x={n.x} y={n.y} tincture={HOUSES[n.estate].tincture} npc={n.estate !== 'te'} name={n.estate === 'te' ? n.name : undefined} />)}
        {sel ? <circle cx={sel.x} cy={sel.y} r={sel.key ? 16 : 14} fill="none" stroke="var(--verdigris)" strokeWidth="2" strokeDasharray="4 3" /> : null}
        {cities.map((c) => (
          <T.MapCity key={c.id} x={c.x} y={c.y} name={c.name} keyCity={c.key} state={cityState(state, c.id)} stability={state.stability[c.id]} labelSide={c.labelSide} />
        ))}
        {cities.map((c) => (
          <circle className="map-hit" key={"hit" + c.id} cx={c.x} cy={c.y} r="18" fill="transparent" style={{ cursor: 'pointer' }} role="button" tabIndex={0}
            aria-label={c.name + (net[c.id] != null ? ', elérhető' : ', nem elérhető')}
            onClick={() => onSelect(c.id)} onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onSelect(c.id); } }} />
        ))}
        <T.MapCompass x={326} y={44} size={20} />
        <T.MapCartouche x={8} y={212} width={138} title="DÉLKELET" />
      </T.MapCanvas>

      {!sel ? (
        <p className="tn-muted" style={{ margin: 0 }}>Koppints egy városra a térképen.</p>
      ) : (
        <section className="tn-card" aria-label={'Kiválasztott város: ' + sel.name}>
          <div className="tn-fac-meta">
            <span className="tn-eyebrow">{sel.profile}{sel.key ? ' · kulcsváros' : ''}{net[selected] != null ? ` · ${net[selected]} lépés` : ''}</span>
            <T.StabilityChip level={state.stability[selected]} />
          </div>
          <h2 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>{sel.name}</h2>
          {reach !== 'reachable' ? (
            <T.Toast tone={reach === 'cut' ? 'danger' : 'warn'} title={reach === 'cut' ? 'Elvágott város' : 'Nem vezet ide útvonalad'}>
              {reach === 'cut' ? 'A befolyásod megmaradt, de új akciót nem indíthatsz, és a romlás kétszeres.' : 'Akciót csak a hálózatodban lévő városban indíthatsz. Építs útvonalat egy szomszédos városból.'}
            </T.Toast>
          ) : null}
          {FACTIONS.map((f) => { const v = factionView(state, selected, f); return (
            <T.InfluenceBar key={f} faction={f} legend={false} aside={<T.ControlBadge level={v.level} />} segments={v.segments} unknown={v.unknown} precision={v.precision} />
          ); })}
          <div className="tn-row" style={{ justifyContent: 'flex-end' }}>
            {buildable.map(([from, to]) => (
              <T.Button key={from} icon="route" onClick={() => dispatch({ type: 'addOrder', order: { type: 'route', city: [from, to] } })}>
                Útvonal innen: {NODES[from].name}
              </T.Button>
            ))}
            <T.Button variant="primary" icon="varos" onClick={() => onOpenCity(selected)}>Város megnyitása</T.Button>
          </div>
          {bestLevel(state, selected) ? null : <span className="tn-field-hint">Itt még nincs jelenléted, ezért a riválisok értékeit csak 10 pontos sávokban látod.</span>}
        </section>
      )}
    </>
  );
}
