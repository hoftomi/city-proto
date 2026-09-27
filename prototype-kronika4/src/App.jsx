import { useEffect, useRef, useState } from 'react';
import T from './ds/index.js';
import { HOUSES } from './game/world.js';
import { useGame } from './store.js';
import { fmtClock, fmtDur, nextSettlement, nextEventIn, orderLabel } from './game/engine.js';
import MapScreen from './screens/MapScreen.jsx';
import CityScreen from './screens/CityScreen.jsx';
import OrdersScreen from './screens/OrdersScreen.jsx';
import ReportsScreen from './screens/ReportsScreen.jsx';
import RankingScreen from './screens/RankingScreen.jsx';

const hhmm = (t) => fmtClock(t).split(' ').pop();

export default function App({ onExit }) {
  const [state, dispatch] = useGame();
  const [tab, setTab] = useState('terkep');
  const [city, setCity] = useState('feketerev');
  const [district, setDistrict] = useState('kereskedok');
  const [seenReports, setSeenReports] = useState(state.reports.length);
  const [toast, setToast] = useState(null);

  useEffect(() => { if (state.lastError) { setToast({ tone: 'danger', title: 'Nem sikerült', body: state.lastError }); dispatch({ type: 'clearError' }); } }, [state.lastError]);

  const draftLen = state.draft.length;
  const prevDraft = useRef(draftLen);
  useEffect(() => {
    if (draftLen > prevDraft.current) { const o = state.draft[draftLen - 1]; setToast({ tone: 'info', title: 'Parancslapra került', body: orderLabel(state, o) }); }
    prevDraft.current = draftLen;
  }, [draftLen]);

  const repLen = state.reports.length;
  const prevRep = useRef(repLen);
  useEffect(() => {
    const n = repLen - prevRep.current;
    if (n > 0 && tab !== 'jel') { const r = state.reports[0]; setToast({ tone: r.tone === 'danger' ? 'danger' : 'ok', title: n === 1 ? r.title : `${n} új jelentés`, body: n === 1 ? r.text : r.title }); }
    prevRep.current = repLen;
  }, [repLen]);

  useEffect(() => { if (!toast) return; const t = setTimeout(() => setToast(null), 3400); return () => clearTimeout(t); }, [toast]);
  useEffect(() => { if (tab === 'jel') setSeenReports(state.reports.length); }, [tab, state.reports.length]);
  useEffect(() => { window.scrollTo(0, 0); }, [tab]);

  const unread = Math.max(0, state.reports.length - seenReports);
  const myLap = state.laps.find((l) => l.player === 'te');
  const threats = state.reports.filter((r) => r.buyout && state.laps.some((l) => l.id === r.buyout.lapId)).length;
  const nav = [
    { id: 'terkep', label: 'Térkép', icon: 'terkep' },
    { id: 'varos', label: 'Város', icon: 'varos' },
    { id: 'jel', label: 'Jelentések', icon: 'kem', badge: unread ? (unread > 9 ? '9+' : unread) : undefined },
    { id: 'par', label: 'Parancslap', icon: 'pp', badge: (draftLen + threats) || undefined },
    { id: 'rang', label: 'Rangsor', icon: 'legit' },
  ];
  const me = state.players.te;
  const nextSet = nextSettlement(state.clock);
  const toSet = nextSet - state.clock;
  const nextEv = nextEventIn(state);

  return (
    <div className="tn-screen app">
      <div className="app-top">
        {onExit ? <div className="app-exit"><button type="button" onClick={onExit}>← Játékok</button><span>Délkelet · Polgár mód</span></div> : null}
        <T.AppBar house={HOUSES.te} timer={{ at: hhmm(nextSet), remaining: fmtDur(toSet), soon: toSet <= 60 }}
          resources={[{ kind: 'arany', value: Math.floor(me.gold) }, { kind: 'pp', value: me.pp }, { kind: 'legit', value: me.legit }]} />
        <div className="clock-bar" role="group" aria-label="Szimulált idő">
          <span className="clock-now"><T.Icon name="clock" size={14} /> <b className="tn-num">{fmtClock(state.clock)}</b>{myLap ? <span className="tn-muted"> · lapod {fmtDur(myLap.executeAt - state.clock)} múlva él</span> : null}</span>
          <span className="clock-btns">
            <button type="button" onClick={() => dispatch({ type: 'advance', minutes: 30 })}>+30 p</button>
            <button type="button" onClick={() => dispatch({ type: 'advance', minutes: 120 })}>+2 ó</button>
            <button type="button" className="on" onClick={() => dispatch({ type: 'advance', minutes: nextEv })} title={'Előre ' + fmtDur(nextEv)}>Következő esemény ›</button>
          </span>
        </div>
      </div>
      <main className="tn-screen-body">
        {tab === 'terkep' && <MapScreen state={state} dispatch={dispatch} selected={city} onSelect={setCity} onOpenCity={(c) => { setCity(c); setTab('varos'); }} />}
        {tab === 'varos' && <CityScreen state={state} dispatch={dispatch} city={city} district={district} onDistrict={setDistrict} onBack={() => setTab('terkep')} />}
        {tab === 'par' && <OrdersScreen state={state} dispatch={dispatch} onOpenCity={(c, d) => { setCity(c); if (d) setDistrict(d); setTab('varos'); }} />}
        {tab === 'jel' && <ReportsScreen state={state} />}
        {tab === 'rang' && <RankingScreen state={state} dispatch={dispatch} onExit={onExit} />}
      </main>
      {toast ? <div className="app-toast" key={toast.title + toast.body} onClick={() => setToast(null)}><T.Toast tone={toast.tone} title={toast.title}>{toast.body}</T.Toast></div> : null}
      <div className="app-nav"><T.NavBar active={tab} onChange={setTab} items={nav} /></div>
    </div>
  );
}
