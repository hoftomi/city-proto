import T from '../ds/index.js';
import { HOUSES, NODES } from '../game/world.js';
import { CITIES, popOf, nextElectionIn } from '../game/engine.js';

export default function RankingScreen({ state, dispatch, onExit }) {
  const seatsOf = (h) => CITIES.reduce((a, c) => a + (state.cities[c].council?.[h] || 0), 0);
  const sharesOf = (h) => CITIES.reduce((a, c) => a + Object.values(state.cities[c].goods).reduce((b, g) => b + (g.shares[h] || 0), 0), 0);
  const rows = Object.entries(state.players).sort((a, b) => b[1].legit - a[1].legit).map(([h, p], i) => ({
    id: h, rank: i + 1, name: h === 'te' ? HOUSES[h].name + ' (te)' : HOUSES[h].name, t: HOUSES[h].tincture, npc: h !== 'te',
    l: p.legit, seats: seatsOf(h), shares: sharesOf(h), self: h === 'te',
  }));
  const popRows = CITIES.map((c) => ({ id: c, city: NODES[c].name, pop: Math.round(popOf(state, c, 'te')), seats: state.cities[c].council?.te || 0 }));
  const ne = nextElectionIn(state);

  return (
    <>
      <div className="tn-stack" style={{ gap: 4 }}>
        <span className="tn-eyebrow">{state.settlements}. elszámolás után · választás {ne === 1 ? 'a következő elszámoláskor' : `${ne} elszámolás múlva`}</span>
        <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Legitimitás</h1>
      </div>
      <T.DataTable columns={[
        { key: 'rank', label: '#', align: 'right' },
        { key: 'name', label: 'Ház', render: (r) => <span className="tn-row" style={{ gap: 8, flexWrap: 'nowrap' }}><T.HouseCrest tincture={r.t} size={18} npc={r.npc} name={r.name} />{r.name}</span> },
        { key: 'shares', label: 'Rész.', align: 'right' },
        { key: 'seats', label: 'Hely', align: 'right' },
        { key: 'l', label: 'L', align: 'right' },
      ]} rows={rows} />

      <section className="tn-card" aria-label="Népszerűséged városonként">
        <span className="tn-eyebrow">Népszerűséged</span>
        <T.DataTable columns={[
          { key: 'city', label: 'Város' },
          { key: 'pop', label: 'Népszerűség', align: 'right' },
          { key: 'seats', label: 'Tanácshely', align: 'right' },
        ]} rows={popRows} />
        <span className="tn-field-hint">Legitimitás elszámolásonként: tanácshelyenként +1, többség +3, legtöbb eladás +2, legnépszerűbb +2 városonként.</span>
      </section>

      <section className="tn-card proto-note">
        <span className="tn-eyebrow">Prototípus</span>
        <span className="tn-muted">Szabálykönyv v0.2 · Polgár mód. Katonaság és diplomácia a későbbi nehézségi modulokban.</span>
        <div className="tn-row">{onExit ? <T.Button size="sm" onClick={onExit}>← Vissza a játékokhoz</T.Button> : null}<T.Button variant="danger" size="sm" onClick={() => dispatch({ type: 'reset' })}>Prototípus újraindítása</T.Button></div>
      </section>
    </>
  );
}
