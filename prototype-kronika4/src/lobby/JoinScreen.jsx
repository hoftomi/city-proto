import { useState } from 'react';
import T from '../ds/index.js';
import { GAMES, MAPS, BACKGROUNDS, TINCTURES, dateIn } from './data.js';
import { MiniMap } from './GameDetailScreen.jsx';

const STEPS = ['Ház', 'Háttér', 'Kezdőhely', 'Összegzés'];
const TAKEN_NAMES = ['ezüstpart-ház', 'ősi tölgy', 'varjúvár', 'bíbor kéz'];

function nameError(n) {
  const v = n.trim();
  if (v.length < 3) return 'Legalább 3 betű kell.';
  if (v.length > 24) return 'Legfeljebb 24 betű lehet.';
  if (TAKEN_NAMES.includes(v.toLowerCase())) return 'Ez a név ebben a játékban már foglalt.';
  return null;
}

export default function JoinScreen({ gameId, onCancel, onDone }) {
  const g = GAMES.find((x) => x.id === gameId);
  const starts = MAPS[g.map].starts;
  const [step, setStep] = useState(0);
  const [name, setName] = useState('');
  const [touched, setTouched] = useState(false);
  const [tincture, setTincture] = useState(TINCTURES.find((t) => !(g.taken || []).includes(t.id)).id);
  const [bg, setBg] = useState('kereskedo');
  const [start, setStart] = useState(starts[0]?.id);
  const err = nameError(name);
  const background = BACKGROUNDS.find((b) => b.id === bg);
  const startSlot = starts.find((s) => s.id === start);
  const canNext = step === 0 ? !err : step === 2 ? !!start : true;

  function next() { if (step === 0) setTouched(true); if (!canNext) return; if (step < 3) setStep(step + 1); else onDone({ house: name.trim(), tincture, background: bg, backgroundName: background.name, start }); }

  return (
    <div className="tn-screen">
      <header className="tn-appbar">
        <div className="tn-appbar-top">
          <T.Button size="sm" variant="quiet" onClick={step ? () => setStep(step - 1) : onCancel}>{step ? '← Vissza' : '← Mégse'}</T.Button>
          <span className="tn-muted" style={{ fontSize: 13 }}>{g.name}</span>
        </div>
        <ol className="stepper" aria-label="Jelentkezés lépései">
          {STEPS.map((s, i) => <li key={s} className={i === step ? 'on' : i < step ? 'done' : ''} aria-current={i === step ? 'step' : undefined}><span className="tn-num">{i + 1}</span>{s}</li>)}
        </ol>
      </header>
      <main className="tn-screen-body">
        {step === 0 ? (
          <>
            <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Alapítsd meg a házad</h1>
            <div className="crest-preview">
              <T.HouseCrest tincture={tincture} initial={(name.trim()[0] || '?').toUpperCase()} size={64} name={name || 'Új ház'} />
              <div className="crest-name">{name.trim() || 'Házad neve'}</div>
            </div>
            <T.TextField id="house-name" label="A ház neve" value={name} maxLength={30} placeholder="például Kékholló" autoComplete="off"
              onChange={(e) => setName(e.target.value)} onBlur={() => setTouched(true)}
              error={touched && err ? err : undefined} hint={!touched || !err ? 'Így látnak a többiek a térképen és a ranglistán.' : undefined} />
            <fieldset className="tincture-pick">
              <legend className="tn-field-label">Tinktúra (a házad színe)</legend>
              <div className="tincture-grid">
                {TINCTURES.map((t) => {
                  const taken = (g.taken || []).includes(t.id);
                  return (
                    <label key={t.id} className={'tincture' + (t.id === tincture ? ' on' : '') + (taken ? ' taken' : '')}>
                      <input type="radio" name="tincture" value={t.id} checked={t.id === tincture} disabled={taken} onChange={() => setTincture(t.id)} />
                      <span className="tincture-sw" style={{ background: `var(--house-${t.id})` }} />
                      <span>{t.name}</span>
                      {taken ? <span className="tincture-taken">foglalt</span> : null}
                    </label>
                  );
                })}
              </div>
            </fieldset>
          </>
        ) : null}

        {step === 1 ? (
          <>
            <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Honnan jön a házad?</h1>
            <p className="tn-muted" style={{ margin: 0 }}>A háttér előnyt ad, de nem zár be egyetlen útra. Bármelyik frakcióért versenyezhetsz.</p>
            <div className="choice-list" role="radiogroup" aria-label="Háttér">
              {BACKGROUNDS.map((b) => (
                <button key={b.id} type="button" role="radio" aria-checked={b.id === bg} className={'choice' + (b.id === bg ? ' on' : '')} onClick={() => setBg(b.id)}>
                  <span className="choice-icon"><T.Icon name={b.icon} size={22} /></span>
                  <span className="choice-body">
                    <span className="choice-title">{b.name}</span>
                    {b.perks.map((p) => <span key={p} className="choice-perk">{p}</span>)}
                  </span>
                  <span className="choice-check" aria-hidden="true">{b.id === bg ? <T.Icon name="check" size={18} /> : null}</span>
                </button>
              ))}
            </div>
          </>
        ) : null}

        {step === 2 ? (
          <>
            <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Hol áll a birtokod?</h1>
            <p className="tn-muted" style={{ margin: 0 }}>A birtokodból két szomszédos városba indulsz ingyenes útvonallal. Akciót csak a hálózatodban lévő városban indíthatsz.</p>
            <MiniMap mapId={g.map} starts selected={start} onSelect={setStart} />
            <div className="choice-list" role="radiogroup" aria-label="Kezdőhely">
              {starts.map((s) => (
                <button key={s.id} type="button" role="radio" aria-checked={s.id === start} className={'choice' + (s.id === start ? ' on' : '')} onClick={() => setStart(s.id)}>
                  <span className="choice-icon"><T.Icon name="route" size={22} /></span>
                  <span className="choice-body">
                    <span className="choice-title">{s.name}</span>
                    <span className="choice-perk">Szomszédos: {s.near.join(', ')}</span>
                    <span className="choice-perk tn-muted">{s.note}</span>
                  </span>
                  <span className="choice-check" aria-hidden="true">{s.id === start ? <T.Icon name="check" size={18} /> : null}</span>
                </button>
              ))}
            </div>
          </>
        ) : null}

        {step === 3 ? (
          <>
            <h1 className="tn-city-title" style={{ fontSize: 26, lineHeight: '30px' }}>Minden készen áll</h1>
            <section className="tn-card summary">
              <div className="crest-preview" style={{ padding: 0 }}>
                <T.HouseCrest tincture={tincture} initial={name.trim()[0].toUpperCase()} size={56} name={name} />
                <div>
                  <div className="crest-name">{name.trim()}</div>
                  <div className="tn-muted">{background.name} · {TINCTURES.find((t) => t.id === tincture).name}</div>
                </div>
              </div>
              <dl className="facts">
                <div><dt>Játék</dt><dd>{g.name} · {g.season}</dd></div>
                <div><dt>Kezdés</dt><dd>{dateIn(g.startsIn)}</dd></div>
                <div><dt>Kezdőhely</dt><dd>{startSlot.name} ({startSlot.near.join(', ')})</dd></div>
                <div><dt>Induló készlet</dt><dd>10 PP · 30 arany · 20 népszerűség a kezdővárosban · 2 útvonal</dd></div>
              </dl>
            </section>
            <span className="tn-field-hint">A kezdésig bármikor visszavonhatod a jelentkezést. A ház neve és tinktúrája a kezdés után már nem változtatható.</span>
          </>
        ) : null}

        <div className="sticky-cta">
          <T.Button variant="primary" onClick={next} disabled={step === 0 && touched && !!err}>{step === 3 ? 'Jelentkezés megerősítése' : 'Tovább'}</T.Button>
        </div>
      </main>
    </div>
  );
}
