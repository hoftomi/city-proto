import { useEffect, useState } from 'react';
import T from './ds/index.js';
import { HOUSES } from './game/world.js';
import { useGame } from './store.js';
import { nextTick } from './view.js';
import MapScreen from './screens/MapScreen.jsx';
import CityScreen from './screens/CityScreen.jsx';
import OrdersScreen from './screens/OrdersScreen.jsx';
import ReportsScreen from './screens/ReportsScreen.jsx';
import RankingScreen from './screens/RankingScreen.jsx';

export default function App({ onExit }) {
  const [state, dispatch] = useGame();
  const [tab, setTab] = useState('terkep');
  const [city, setCity] = useState('feketerev');
  const [faction, setFaction] = useState('kereskedok');
  const [seenReports, setSeenReports] = useState(state.reports.length);
  const [toast, setToast] = useState(null);
  const [tick, setTick] = useState(nextTick());

  useEffect(() => { const t = setInterval(() => setTick(nextTick()), 30000); return () => clearInterval(t); }, []);
  useEffect(() => { if (state.lastError) { setToast({ tone: 'danger', title: 'Nem került a parancslapra', body: state.lastError }); dispatch({ type: 'clearError' }); } }, [state.lastError]);
  const ordersLen = state.orders.length;
  const [prevOrders, setPrevOrders] = useState(ordersLen);
  useEffect(() => {
    if (ordersLen > prevOrders) { const o = state.orders[ordersLen - 1]; setToast({ tone: 'info', title: 'Parancslapra került: ' + o.label, body: o.cityLabel + ' · ' + o.cost.pp + ' PP' }); }
    setPrevOrders(ordersLen);
  }, [ordersLen]);
  useEffect(() => { if (!toast) return; const t = setTimeout(() => setToast(null), 3200); return () => clearTimeout(t); }, [toast]);
  useEffect(() => { if (tab === 'jel') setSeenReports(state.reports.length); }, [tab, state.reports.length]);
  useEffect(() => { window.scrollTo(0, 0); }, [tab]);

  const unread = Math.max(0, state.reports.length - seenReports);
  const nav = [
    { id: 'terkep', label: 'Térkép', icon: 'terkep' },
    { id: 'varos', label: 'Város', icon: 'varos' },
    { id: 'jel', label: 'Jelentések', icon: 'kem', badge: unread || undefined },
    { id: 'par', label: 'Parancslap', icon: 'pp', badge: ordersLen || undefined },
    { id: 'rang', label: 'Rangsor', icon: 'legit' },
  ];
  const r = state.resources;

  return (
    <div className="tn-screen app">
      <div className="app-top">
        {onExit ? <div className="app-exit"><button type="button" onClick={onExit}>← Játékok</button><span>Délkelet · 1. szezon</span></div> : null}
        <T.AppBar house={HOUSES.te} timer={tick}
          resources={[{ kind: 'arany', value: r.arany }, { kind: 'bp', value: r.bp }, { kind: 'ke', value: r.ke }, { kind: 'legit', value: r.legit }]} />
      </div>
      <main className="tn-screen-body">
        {tab === 'terkep' && <MapScreen state={state} dispatch={dispatch} selected={city} onSelect={setCity} onOpenCity={(c) => { setCity(c); setTab('varos'); }} />}
        {tab === 'varos' && <CityScreen state={state} dispatch={dispatch} city={city} faction={faction} onFaction={setFaction} onBack={() => setTab('terkep')} />}
        {tab === 'par' && <OrdersScreen state={state} dispatch={dispatch} onDone={() => { setTab('jel'); setToast({ tone: 'ok', title: `A ${state.round}. kör lezárult`, body: 'Megérkeztek az új jelentések.' }); }} />}
        {tab === 'jel' && <ReportsScreen state={state} />}
        {tab === 'rang' && <RankingScreen state={state} dispatch={dispatch} onExit={onExit} />}
      </main>
      {toast ? <div className="app-toast" key={toast.title + toast.body}><T.Toast tone={toast.tone} title={toast.title}>{toast.body}</T.Toast></div> : null}
      <div className="app-nav"><T.NavBar active={tab} onChange={setTab} items={nav} /></div>
    </div>
  );
}
