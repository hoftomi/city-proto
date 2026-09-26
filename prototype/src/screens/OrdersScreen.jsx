import T from '../ds/index.js';
import { pendingPP } from '../game/engine.js';

export default function OrdersScreen({ state, dispatch, onDone }) {
  const orders = state.orders.map((o) => ({ label: o.label, city: o.cityLabel, faction: o.faction, note: o.note, hidden: o.hidden, cost: o.cost }));
  return (
    <>
      <T.CommandPoints available={state.resources.pp} pending={pendingPP(state)} />
      {orders.length ? (
        <T.OrderSheet round={state.round} available={state.resources.pp} orders={orders} sealed={state.sealed}
          onRemove={(i) => dispatch({ type: 'removeOrder', index: i })} onSeal={() => dispatch({ type: 'seal' })} />
      ) : (
        <section className="tn-card">
          <strong>Üres a parancslap</strong>
          <span className="tn-muted">Válassz egy várost a térképen, majd egy negyedet, és adj hozzá akciót.</span>
        </section>
      )}
      {state.sealed ? (
        <section className="tn-card proto-note">
          <span className="tn-eyebrow">Csak a prototípusban</span>
          <span>Az éles játékban a parancsok a következő feldolgozáskor futnak le. Itt most azonnal lefuttathatod a kört.</span>
          <div className="tn-row">
            <T.Button variant="primary" icon="clock" onClick={() => { dispatch({ type: 'resolve' }); onDone(); }}>Feldolgozás most</T.Button>
            <T.Button variant="quiet" onClick={() => dispatch({ type: 'unseal' })}>Pecsét feltörése</T.Button>
          </div>
        </section>
      ) : null}
    </>
  );
}
