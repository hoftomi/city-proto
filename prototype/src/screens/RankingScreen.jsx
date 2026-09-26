import T from '../ds/index.js';
import { HOUSES } from '../game/world.js';
import { RULES } from '../game/rules.js';

export default function RankingScreen({ state, dispatch, onExit }) {
  const rows = Object.entries(state.legit).sort((a, b) => b[1] - a[1]).map(([h, l], i) => ({ id: h, rank: i + 1, name: HOUSES[h].name, t: HOUSES[h].tincture, npc: HOUSES[h].npc, l, self: h === 'te' }));
  return (
    <>
      <div className="tn-stack" style={{ gap: 4 }}>
        <span className="tn-eyebrow">Szezon · {Math.min(state.round, RULES.seasonRounds)}. / {RULES.seasonRounds}. kör</span>
        <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Legitimitás</h1>
      </div>
      <T.DataTable columns={[
        { key: 'rank', label: '#', align: 'right' },
        { key: 'name', label: 'Ház', render: (r) => <span className="tn-row" style={{ gap: 8, flexWrap: 'nowrap' }}><T.HouseCrest tincture={r.t} size={18} npc={r.npc} name={r.name} />{r.name}{r.npc ? <span className="tn-muted" style={{ fontSize: 12 }}>NPC</span> : null}</span> },
        { key: 'l', label: 'Legitimitás', align: 'right' },
      ]} rows={rows} />
      <section className="tn-card proto-note">
        <span className="tn-eyebrow">Diplomácia</span>
        <span className="tn-muted">A szerződések (megnemtámadás, áthaladási jog, befolyásmegosztás) a következő prototípus-lépésben jönnek.</span>
        <div className="tn-row">{onExit ? <T.Button size="sm" onClick={onExit}>← Vissza a játékokhoz</T.Button> : null}<T.Button variant="danger" size="sm" onClick={() => dispatch({ type: 'reset' })}>Prototípus újraindítása</T.Button></div>
      </section>
    </>
  );
}
