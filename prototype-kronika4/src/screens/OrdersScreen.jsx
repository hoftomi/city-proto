import T from '../ds/index.js';
import { NODES } from '../game/world.js';
import { RULES, ACTIONS } from '../game/rules.js';
import { draftCost, orderLabel, fmtClock, fmtDur } from '../game/engine.js';

const BRANCH = { kozos: 'Közös', keresk: 'Vásártér', polit: 'Városháza', kem: 'Alvilág' };
const toSheet = (state, o) => ({ art: o.type, label: orderLabel(state, o), city: o.city ? NODES[o.city].name : '', faction: BRANCH[ACTIONS[o.type].branch], cost: { pp: ACTIONS[o.type].pp, arany: o.gold } });

export default function OrdersScreen({ state, dispatch, onOpenCity }) {
  const me = state.players.te;
  const cost = draftCost(state);
  const myLap = state.laps.find((l) => l.player === 'te');
  const threats = state.reports.filter((r) => r.buyout && state.laps.some((l) => l.id === r.buyout.lapId));
  const orders = state.draft.map((o) => toSheet(state, o));

  return (
    <>
      <T.CommandPoints available={me.pp} pending={cost.pp} max={RULES.ppMax} daily={RULES.ppPerSettlement} />

      {threats.map((r) => {
        const lap = state.laps.find((l) => l.id === r.buyout.lapId);
        return (
          <section key={r.id} className="tn-card threat" aria-label="Kivásárlási fenyegetés">
            <span className="tn-eyebrow">Kivásárlási ajánlat · lefut {fmtClock(lap.executeAt)} ({fmtDur(lap.executeAt - state.clock)})</span>
            <strong>{r.title}</strong>
            <span className="tn-muted">{r.text}</span>
            <div className="tn-row"><T.Button size="sm" icon="kereskedok" onClick={() => onOpenCity(r.buyout.city, 'kereskedok')}>Védekezés a Vásártéren</T.Button></div>
          </section>
        );
      })}

      {myLap ? (
        <section className="tn-card lap-pending" aria-label="Érlelő parancslap">
          <span className="tn-eyebrow">Lepecsételve {fmtClock(myLap.sealedAt)}</span>
          <strong>Érlelődik: {fmtDur(myLap.executeAt - state.clock)} múlva lép érvénybe ({fmtClock(myLap.executeAt)})</strong>
          <div className="lap-progress" aria-hidden="true"><i style={{ width: `${Math.min(100, (100 * (state.clock - myLap.sealedAt)) / (myLap.executeAt - myLap.sealedAt))}%` }} /></div>
          <ul className="lap-list">{myLap.orders.map((o) => <li key={o.id}><T.GameIcon name={o.type} size={16} tile />{orderLabel(state, o)}</li>)}</ul>
          <span className="tn-field-hint">Ez idő alatt a rivális kémek kifürkészhetik. Őrökkel védekezhetsz az Alvilágban. Új lapot a végrehajtás után pecsételhetsz.</span>
        </section>
      ) : null}

      {orders.length ? (
        <>
          <T.OrderSheet round={null} available={me.pp} orders={orders} sealed={false}
            onRemove={(i) => dispatch({ type: 'removeDraft', id: state.draft[i].id })}
            onSeal={() => dispatch({ type: 'seal' })} />
          <div className="tn-row" style={{ justifyContent: 'space-between' }}>
            <span className="tn-muted" style={{ fontSize: 13 }}>Lefoglalt arany: <b className="tn-num">{cost.gold}</b> / {Math.floor(me.gold)} A</span>
            <span className="tn-muted" style={{ fontSize: 13 }}>Érlelés: {fmtDur(RULES.maturationMin)}</span>
          </div>
          {myLap ? <T.Toast tone="warn" title="Még érlelődik az előző lapod">A vázlatot megtarthatod, és lepecsételheted, amint az előző lap lefutott.</T.Toast> : null}
        </>
      ) : (
        <section className="tn-card">
          <strong>Üres a parancslap</strong>
          <span className="tn-muted">Nyiss meg egy várost, és a Vásártéren, a Városházán vagy az Alvilágban adj hozzá parancsot. A lepecsételt lap {fmtDur(RULES.maturationMin)} érlelés után lép érvénybe.</span>
        </section>
      )}

      <section className="tn-card proto-note">
        <span className="tn-eyebrow">Csak a prototípusban</span>
        <span>Az idő szimulált. A felső sávban tekerheted előre: az elszámolás {RULES.settlementHours.map((h) => h + ':00').join(' és ')} órakor fut, az NPC-k utána pecsételnek.</span>
      </section>
    </>
  );
}
