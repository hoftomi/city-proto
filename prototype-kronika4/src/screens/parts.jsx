import T from '../ds/index.js';
import { HOUSES } from '../game/world.js';
import { RULES } from '../game/rules.js';
import { name } from '../game/engine.js';

/** A városi tanács 9 helye, a pártok tinktúrájával. */
export function SeatsBar({ council }) {
  const seats = [];
  Object.entries(council || {}).sort((a, b) => b[1] - a[1]).forEach(([p, n]) => { for (let i = 0; i < n; i++) seats.push(p); });
  while (seats.length < RULES.councilSeats) seats.push(null);
  const legend = Object.entries(council || {}).filter(([, n]) => n > 0).sort((a, b) => b[1] - a[1]);
  return (
    <div className="seats" aria-label={'Tanács: ' + (legend.map(([p, n]) => `${name(p)} ${n}`).join(', ') || 'még nincs választás')}>
      <div className="seats-row" aria-hidden="true">
        {seats.map((p, i) => <span key={i} className={'seat' + (p ? '' : ' empty') + (p === 'te' ? ' self' : '')} style={p ? { background: `var(--house-${HOUSES[p].tincture})` } : undefined} />)}
      </div>
      <span className="tn-field-hint">{legend.length ? 'Tanács: ' + legend.map(([p, n]) => `${name(p)} ${n}`).join(' · ') : 'A tanácsot még nem választották meg.'}</span>
    </div>
  );
}

/** Részesedés-sáv egy árucikkhez: a befolyássáv komponens újrahasznosítva (Város = Semleges). */
export function ShareBar({ good }) {
  const segments = Object.entries(good.shares).filter(([, v]) => v > 0).map(([p, v]) => ({ name: name(p), tincture: HOUSES[p].tincture, value: v, self: p === 'te' }));
  return <T.InfluenceBar segments={segments} precision="exact" thresholds={false} legend={false} />;
}

export function Cost({ pp, gold }) {
  return (
    <span className="tn-row" style={{ gap: 6 }}>
      {pp ? <T.ResourceChip kind="pp" value={pp} /> : null}
      {gold ? <T.ResourceChip kind="arany" value={gold} /> : null}
    </span>
  );
}
