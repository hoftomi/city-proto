import T from '../ds/index.js';

export default function ReportsScreen({ state }) {
  const s = state.lastSummary;
  return (
    <>
      {s ? (
        <section className="tn-card" aria-label="A kör összegzése">
          <span className="tn-eyebrow">{s.round}. kör lezárult</span>
          <div className="tn-row" style={{ gap: 6 }}>
            <T.ResourceChip kind="arany" value={state.resources.arany} delta={s.income.arany - s.upkeep + s.routeGold} />
            <T.ResourceChip kind="bp" value={state.resources.bp} delta={s.income.bp} />
            <T.ResourceChip kind="ke" value={state.resources.ke} delta={s.income.ke} />
            <T.ResourceChip kind="legit" value={state.resources.legit} delta={s.income.legit} />
          </div>
          <span className="tn-field-hint">Útvonal-fenntartás: −{s.upkeep} A · kereskedelmi hozam: +{s.routeGold} A</span>
        </section>
      ) : null}
      {state.reports.map((r) => (
        <T.ReportCard key={r.id} kind={r.kind} confidence={r.confidence} tick={r.tick} title={r.title}>{r.text}</T.ReportCard>
      ))}
    </>
  );
}
