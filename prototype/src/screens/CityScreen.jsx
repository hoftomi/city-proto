import { useState } from 'react';
import T from '../ds/index.js';
import { NODES, HOUSES } from '../game/world.js';
import { ACTIONS, FACTION_NAMES, RULES, actionCost } from '../game/rules.js';
import { network, cityState, buildableRoutesTo } from '../game/engine.js';
import { factionView, districtsView, bestLevel } from '../view.js';

const DISTRICT = { nemesseg: 'Felsőváros', kereskedok: 'Vásártér', katonasag: 'Citadella' };
const COST_KEYS = { arany: 'arany', bp: 'bp', ke: 'ke', pp: 'pp' };

function actionsFor(faction) {
  return Object.entries(ACTIONS).filter(([, a]) => a.factions === 'any' || a.factions.includes(faction)).map(([k]) => k);
}

export default function CityScreen({ state, dispatch, city, faction, onFaction, onBack }) {
  const [hidden, setHidden] = useState(false);
  const [target, setTarget] = useState('');
  const node = NODES[city];
  const net = network(state);
  const reach = cityState(state, city);
  const v = factionView(state, city, faction);
  const lvl = bestLevel(state, city);
  const decay = Math.round((RULES.decay.open + RULES.decay.perDistance * Math.max(0, (net[city] ?? 3) - 1) + (RULES.decay[state.stability[city]] || 0)) * 100);
  const smearTarget = target && v.rivals.includes(target) ? target : v.rivals[0];

  function order(type) {
    dispatch({ type: 'addOrder', order: { type, city, faction, hidden: ACTIONS[type].power ? hidden : false, target: type === 'smear' ? smearTarget : undefined } });
  }

  return (
    <>
      <div className="tn-stack" style={{ gap: 6 }}>
        <button type="button" className="tn-btn tn-btn-quiet tn-btn-sm" style={{ alignSelf: 'flex-start', marginLeft: -12 }} onClick={onBack}>← Térkép</button>
        <span className="tn-eyebrow">{node.profile}{node.key ? ' · kulcsváros' : ''}{net[city] != null ? ` · ${net[city]} lépés` : ''}</span>
        <h1 className="tn-city-title">{node.name}</h1>
        <div className="tn-row" style={{ gap: 8 }}>
          <T.StabilityChip level={state.stability[city]} />
          <T.ControlBadge level={lvl} />
        </div>
      </div>

      <T.CityView name={node.name} coast={node.coast} stability={state.stability[city]} selected={faction} onSelect={onFaction} districts={districtsView(state, city)} />
      <T.Tabs active={faction} onChange={onFaction} tabs={['nemesseg', 'kereskedok', 'katonasag'].map((f) => ({ id: f, label: DISTRICT[f] }))} />

      <section className="tn-card" aria-label={DISTRICT[faction]}>
        <T.InfluenceBar faction={faction} aside={<T.ControlBadge level={v.level} />} segments={v.segments} unknown={v.unknown} precision={v.precision} />
        <div className="tn-fac-meta">
          <T.SuspicionMeter value={v.suspicion} />
          <span className="tn-muted" style={{ fontSize: 13 }}>Romlás: {decay}% / kör</span>
        </div>
        {v.ownHidden ? <span className="tn-field-hint">Saját rejtett befolyásod itt: <b className="tn-num">{String(v.ownHidden).replace('.', ',')}</b>. Ez az „Ismeretlen” sorban nem szerepel a te nézetedben.</span> : null}
      </section>

      {reach !== 'reachable' ? (
        <section className="tn-card">
          <T.Toast tone={reach === 'cut' ? 'danger' : 'warn'} title={reach === 'cut' ? 'Elvágott város' : 'Nem vezet ide útvonalad'}>
            Akciót csak a hálózatodban lévő városban indíthatsz (szabálykönyv 4.3).
          </T.Toast>
          <div className="tn-row">
            {buildableRoutesTo(state, city).map(([from, to]) => (
              <T.Button key={from} icon="route" onClick={() => dispatch({ type: 'addOrder', order: { type: 'route', city: [from, to] } })}>Útvonal innen: {NODES[from].name} · 1 PP · 3 A</T.Button>
            ))}
          </div>
        </section>
      ) : (
        <section className="tn-card" aria-label="Akciók">
          <div className="tn-fac-meta">
            <span className="tn-eyebrow">Akciók: {DISTRICT[faction]} · {FACTION_NAMES[faction]}</span>
            <label className="tn-row" style={{ gap: 6, fontSize: 14 }}>
              <input id="hidden-toggle" type="checkbox" checked={hidden} onChange={(e) => setHidden(e.target.checked)} />
              Rejtve (+1 PP, +50%)
            </label>
          </div>
          <ul className="tn-action-list">
            {actionsFor(faction).map((type) => {
              const a = ACTIONS[type], cost = actionCost(type, a.power ? hidden : false);
              const needsPresence = a.needsPresence && !(state.influence[city][faction].te?.open >= 10);
              const noTarget = type === 'smear' && !v.rivals.length;
              return (
                <li key={type} className="tn-action">
                  <div>
                    <div className="tn-action-name">{a.label}{a.power ? <span className="tn-muted"> · alaperő +{a.power}</span> : null}</div>
                    <div className="tn-row" style={{ gap: 6, marginTop: 4 }}>
                      {Object.entries(cost).map(([k, val]) => <T.ResourceChip key={k} kind={COST_KEYS[k]} value={val} />)}
                    </div>
                    {type === 'smear' && v.rivals.length ? (
                      <div style={{ marginTop: 8, maxWidth: 260 }}>
                        <T.Select id="smear-target" label="Célpont" value={smearTarget} onChange={(e) => setTarget(e.target.value)} options={v.rivals.map((h) => ({ value: h, label: HOUSES[h].name }))} />
                      </div>
                    ) : null}
                    {needsPresence ? <div className="tn-field-hint">Legalább Jelenlét (10) kell hozzá.</div> : null}
                  </div>
                  <T.Button size="sm" variant={type === 'smear' ? 'danger' : 'default'} disabled={needsPresence || noTarget || state.sealed} onClick={() => order(type)}>Parancslapra</T.Button>
                </li>
              );
            })}
          </ul>
        </section>
      )}
    </>
  );
}
