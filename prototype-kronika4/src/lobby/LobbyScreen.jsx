import { useState } from 'react';
import T from '../ds/index.js';
import { GAMES, dayLabel } from './data.js';

const STATUS = {
  fut: { label: 'Fut', cls: 'st-fut' },
  nyitott: { label: 'Jelentkezés nyitva', cls: 'st-nyitott' },
  hamarosan: { label: 'Hamarosan', cls: 'st-hamarosan' },
  lezarult: { label: 'Lezárult', cls: 'st-lezarult' },
};

export function StatusChip({ game, joined }) {
  const s = STATUS[game.status];
  const full = game.status === 'nyitott' && game.players / game.max >= 0.9;
  if (joined && game.status === 'nyitott') return <span className="tn-chip st-joined"><T.Icon name="check" size={14} />Jelentkeztél</span>;
  return <span className={'tn-chip ' + (full ? 'st-full' : s.cls)}>{full ? 'Majdnem tele' : s.label}</span>;
}

export function whenText(g) {
  if (g.status === 'fut') return `${g.day}. nap / ${g.days}`;
  if (g.status === 'nyitott') return `Kezdés ${dayLabel(g.startsIn)}`;
  if (g.status === 'hamarosan') return `Jelentkezés ${dayLabel(g.opensIn)} nyílik`;
  return 'Lezárult';
}

function GameCard({ g, joined, onOpen }) {
  const pct = Math.round((g.players / g.max) * 100);
  return (
    <button type="button" className="game-card" onClick={() => onOpen(g.id)} aria-label={`${g.name}, ${g.season}. ${whenText(g)}.`}>
      <div className="game-card-head">
        <div>
          <span className="tn-eyebrow">{g.season}</span>
          <div className="game-card-name">{g.name}</div>
        </div>
        <StatusChip game={g} joined={joined} />
      </div>
      <div className="game-facts">
        <span><T.Icon name="clock" size={15} />{whenText(g)}</span>
        <span><T.Icon name="terkep" size={15} />{g.days} nap · {g.speed}</span>
      </div>
      {g.status !== 'lezarult' ? (
        <div className="game-seats">
          <div className="game-seats-bar" aria-hidden="true"><span style={{ width: pct + '%' }} /></div>
          <span className="tn-num" style={{ fontSize: 13 }}>{g.players} / {g.max} ház</span>
        </div>
      ) : (
        <span className="tn-muted" style={{ fontSize: 13 }}>Győztes: {g.winner} · a te helyezésed: {g.place}.</span>
      )}
      {joined ? <span className="game-house"><T.HouseCrest tincture={joined.tincture} size={16} name={joined.house} />{joined.house}</span> : null}
      {g.tags.length ? <div className="tn-row" style={{ gap: 6 }}>{g.tags.map((t) => <span key={t} className="game-tag">{t}</span>)}</div> : null}
    </button>
  );
}

export default function LobbyScreen({ user, joins, onOpen, onLogout }) {
  const [tab, setTab] = useState('nyitott');
  const mine = GAMES.filter((g) => joins[g.id] && g.status !== 'lezarult');
  const list = tab === 'sajat' ? mine : tab === 'lezarult' ? GAMES.filter((g) => g.status === 'lezarult') : GAMES.filter((g) => (g.status === 'nyitott' || g.status === 'hamarosan') && !joins[g.id]);

  return (
    <div className="tn-screen">
      <header className="tn-appbar">
        <div className="tn-appbar-top">
          <span className="tn-appbar-name" style={{ fontSize: 18 }}>Trón nélkül</span>
          <span className="tn-row" style={{ gap: 8 }}>
            <span className="tn-muted" style={{ fontSize: 13 }}>{user.name} · {{ google: 'Google', apple: 'Apple', discord: 'Discord' }[user.provider]}</span>
            <T.Button size="sm" variant="quiet" onClick={onLogout}>Kilépés</T.Button>
          </span>
        </div>
      </header>
      <main className="tn-screen-body">
        {mine.length ? (
          <section className="tn-stack" aria-label="Folyamatban">
            <span className="tn-eyebrow">Folytasd, ahol abbahagytad</span>
            {mine.filter((g) => g.status === 'fut').map((g) => (
              <div key={g.id} className="tn-card continue-card">
                <div className="tn-fac-meta">
                  <span className="tn-row" style={{ gap: 8 }}><T.HouseCrest tincture="kek" initial="K" size={26} name="Kékholló" /><b>{g.name}</b></span>
                  <span className="tn-muted" style={{ fontSize: 13 }}>{g.day}. nap / {g.days}</span>
                </div>
                <T.Button variant="primary" icon="terkep" onClick={() => onOpen(g.id, true)}>Belépés a játékba</T.Button>
              </div>
            ))}
          </section>
        ) : null}
        <T.Tabs active={tab} onChange={setTab} tabs={[{ id: 'nyitott', label: 'Új játékok' }, { id: 'sajat', label: 'Saját', badge: mine.length || undefined }, { id: 'lezarult', label: 'Lezárult' }]} />
        {list.length ? list.map((g) => <GameCard key={g.id} g={g} joined={joins[g.id]} onOpen={onOpen} />) : (
          <p className="tn-muted" style={{ margin: 0 }}>{tab === 'sajat' ? 'Még nem jelentkeztél játékra. Válassz egyet az Új játékok közül.' : 'Nincs itt játék.'}</p>
        )}
      </main>
    </div>
  );
}
