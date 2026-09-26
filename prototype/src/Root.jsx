import { useEffect, useState } from 'react';
import App from './App.jsx';
import LoginScreen from './lobby/LoginScreen.jsx';
import LobbyScreen from './lobby/LobbyScreen.jsx';
import GameDetailScreen from './lobby/GameDetailScreen.jsx';
import JoinScreen from './lobby/JoinScreen.jsx';
import T from './ds/index.js';

const KEY = 'tron-nelkul-session-v1';
const DEFAULT_JOINS = { delkelet: { house: 'Kékholló', tincture: 'kek', background: 'kereskedo', backgroundName: 'Kereskedőház' } };

function load() {
  try { const raw = localStorage.getItem(KEY); if (raw) return JSON.parse(raw); } catch (e) { /* nincs tárhely */ }
  return { user: null, joins: DEFAULT_JOINS };
}

// Útvonalak: login → lobby → detail → join → (lobby) ; lobby/detail → game
export default function Root() {
  const [sess, setSess] = useState(load);
  const [route, setRoute] = useState(() => (sess.user ? { name: 'lobby' } : { name: 'login' }));
  const [toast, setToast] = useState(null);

  useEffect(() => { try { localStorage.setItem(KEY, JSON.stringify(sess)); } catch (e) { /* nincs tárhely */ } }, [sess]);
  useEffect(() => { window.scrollTo(0, 0); }, [route]);
  useEffect(() => { if (!toast) return; const t = setTimeout(() => setToast(null), 3500); return () => clearTimeout(t); }, [toast]);

  const go = (name, extra = {}) => setRoute({ name, ...extra });
  let screen;
  if (route.name === 'login' || !sess.user) {
    screen = <LoginScreen onLogin={(user) => { setSess({ ...sess, user }); go('lobby'); }} />;
  } else if (route.name === 'lobby') {
    screen = <LobbyScreen user={sess.user} joins={sess.joins} onLogout={() => { setSess({ ...sess, user: null }); go('login'); }}
      onOpen={(id, enter) => (enter ? go('game', { id }) : go('detail', { id }))} />;
  } else if (route.name === 'detail') {
    screen = <GameDetailScreen gameId={route.id} joined={sess.joins[route.id]} onBack={() => go('lobby')} onJoin={() => go('join', { id: route.id })}
      onEnter={() => go('game', { id: route.id })}
      onWithdraw={() => { const j = { ...sess.joins }; delete j[route.id]; setSess({ ...sess, joins: j }); setToast({ tone: 'info', title: 'Jelentkezés visszavonva' }); }} />;
  } else if (route.name === 'join') {
    screen = <JoinScreen gameId={route.id} onCancel={() => go('detail', { id: route.id })}
      onDone={(j) => { setSess({ ...sess, joins: { ...sess.joins, [route.id]: j } }); go('detail', { id: route.id }); setToast({ tone: 'ok', title: 'Jelentkeztél', body: `${j.house} háza bekerült a játékba. Értesítünk, amikor indul.` }); }} />;
  } else {
    screen = <App onExit={() => go('lobby')} />;
  }
  return (
    <>
      {screen}
      {toast ? <div className="app-toast" style={{ top: 72 }}><T.Toast tone={toast.tone} title={toast.title}>{toast.body}</T.Toast></div> : null}
    </>
  );
}
