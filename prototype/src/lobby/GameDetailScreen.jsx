import T from '../ds/index.js';
import { GAMES, MAPS, dateIn } from './data.js';
import { StatusChip, whenText } from './LobbyScreen.jsx';

export function MiniMap({ mapId, starts, selected, onSelect }) {
  const m = MAPS[mapId];
  const near = selected ? (m.starts.find((s) => s.id === selected)?.near || []) : [];
  return (
    <T.MapCanvas width={360} height={260} title="A játék térképe">
      <T.MapTerrain {...m.terrain} />
      {starts ? m.starts.flatMap((s) => m.cities.filter((c) => s.near.includes(c[2])).map((c) => (
        <T.MapRoute key={s.id + c[2]} from={[s.x, s.y]} to={[c[0], c[1]]} state={s.id === selected ? 'pending' : 'base'} />
      ))) : null}
      {m.cities.map(([x, y, name, key]) => <T.MapCity key={name} x={x} y={y} name={name} keyCity={key} state={near.includes(name) ? 'reachable' : 'plain'} labelSide={x > 290 ? 'left' : 'right'} />)}
      {starts ? m.starts.map((s) => (
        <g key={s.id} role="button" tabIndex={0} aria-label={'Kezdőhely: ' + s.name} aria-pressed={s.id === selected} className="start-slot"
          onClick={() => onSelect(s.id)} onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onSelect(s.id); } }}>
          <circle cx={s.x} cy={s.y} r="16" className={s.id === selected ? 'start-ring on' : 'start-ring'} />
          <T.MapEstate x={s.x} y={s.y} tincture={s.id === selected ? 'kek' : 'fekete'} npc={s.id !== selected} />
        </g>
      )) : null}
      <T.MapCompass x={330} y={30} size={16} />
    </T.MapCanvas>
  );
}

export default function GameDetailScreen({ gameId, joined, onBack, onJoin, onEnter, onWithdraw }) {
  const g = GAMES.find((x) => x.id === gameId);
  const facts = [
    ['Kezdés', g.status === 'nyitott' ? dateIn(g.startsIn) : whenText(g)],
    ['Hossz', `${g.days} nap · ${g.speed}`],
    ['Házak', `${g.players} / ${g.max} játékos + ${g.npc} NPC-ház`],
    ['Városállamok', `${g.cities} · frakciók: Nemesség, Kereskedők, Katonaság`],
    ['Győzelem', 'A legtöbb Legitimitás a Koronázási Tanácson'],
  ];
  return (
    <div className="tn-screen">
      <header className="tn-appbar">
        <div className="tn-appbar-top">
          <T.Button size="sm" variant="quiet" onClick={onBack}>← Játékok</T.Button>
          <StatusChip game={g} joined={joined} />
        </div>
      </header>
      <main className="tn-screen-body">
        <div className="tn-stack" style={{ gap: 4 }}>
          <span className="tn-eyebrow">{g.season}</span>
          <h1 className="tn-city-title">{g.name}</h1>
        </div>
        <MiniMap mapId={g.map} />
        <section className="tn-card" aria-label="A játék adatai">
          <dl className="facts">
            {facts.map(([k, v]) => <div key={k}><dt>{k}</dt><dd>{v}</dd></div>)}
          </dl>
          {g.tags.length ? <div className="tn-row" style={{ gap: 6 }}>{g.tags.map((t) => <span key={t} className="game-tag">{t}</span>)}</div> : null}
        </section>
        {joined && g.status === 'nyitott' ? (
          <section className="tn-card">
            <span className="tn-row" style={{ gap: 8 }}><T.HouseCrest tincture={joined.tincture} initial={joined.house[0]} size={26} name={joined.house} /><b>{joined.house}</b><span className="tn-muted">· {joined.backgroundName}</span></span>
            <span className="tn-muted">Jelentkeztél. A játék {dateIn(g.startsIn)} indul, addig a jelentkezésed visszavonható.</span>
            <div><T.Button variant="danger" size="sm" onClick={onWithdraw}>Jelentkezés visszavonása</T.Button></div>
          </section>
        ) : null}
        {g.status === 'fut' && joined ? <T.Button variant="primary" icon="terkep" onClick={onEnter}>Belépés a játékba</T.Button> : null}
        {g.status === 'nyitott' && !joined ? (
          <div className="sticky-cta"><T.Button variant="primary" onClick={onJoin} disabled={g.players >= g.max}>{g.players >= g.max ? 'A játék betelt' : 'Jelentkezés'}</T.Button></div>
        ) : null}
        {g.status === 'hamarosan' ? <T.Toast tone="info" title="Még nem lehet jelentkezni">{whenText(g)}. Előtte értesítést küldünk.</T.Toast> : null}
        {g.status === 'lezarult' ? <T.Toast tone="info" title={'Győztes: ' + g.winner}>A te helyezésed: {g.place}.</T.Toast> : null}
      </main>
    </div>
  );
}
