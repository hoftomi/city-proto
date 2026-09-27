import { useState } from 'react';
import T from '../ds/index.js';
import { fmtClock } from '../game/engine.js';

export default function ReportsScreen({ state }) {
  const [filter, setFilter] = useState('mind');
  const list = state.reports.filter((r) => filter === 'mind' || (filter === 'nyilvanos' ? r.public : !r.public));
  return (
    <>
      <div className="tn-row" role="radiogroup" aria-label="Szűrés" style={{ gap: 6 }}>
        {[['mind', 'Mind'], ['sajat', 'Saját'], ['nyilvanos', 'Nyilvános']].map(([id, l]) => (
          <button key={id} type="button" role="radio" aria-checked={filter === id} className={'margin-btn' + (filter === id ? ' on' : '')} onClick={() => setFilter(id)}>{l}</button>
        ))}
      </div>
      {!list.length ? <section className="tn-card"><span className="tn-muted">Még nincs jelentés. Tekerd előre az időt a következő elszámolásig.</span></section> : null}
      {list.map((r) => (
        <T.ReportCard key={r.id} kind={r.kind || 'esemeny'} tick={fmtClock(r.at) + (r.public ? ' · nyilvános' : '')} title={r.title}>{r.text}</T.ReportCard>
      ))}
    </>
  );
}
