import { useState } from 'react';
import { PROVIDERS } from './data.js';

// Csak közösségi bejelentkezés. A prototípusban a hitelesítés színlelt: 0,8 mp várakozás után belép.
export default function LoginScreen({ onLogin }) {
  const [busy, setBusy] = useState(null);

  function login(p) {
    setBusy(p.id);
    setTimeout(() => onLogin({ provider: p.id, name: 'Vándor', since: new Date().toISOString() }), 800);
  }

  return (
    <div className="tn-screen login">
      <div className="login-art" aria-hidden="true">
        <svg viewBox="0 0 390 300" preserveAspectRatio="xMidYMid slice">
          <defs><clipPath id="loginSea"><path d="M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300H390V0Z" /></clipPath></defs>
          <rect width="390" height="300" fill="var(--paper)" />
          <path d="M40 170C70 138 130 134 170 154C206 172 214 210 184 228C148 250 76 242 50 218C32 202 28 184 40 170Z" fill="none" stroke="var(--map-relief)" />
          <path d="M76 180C98 166 138 166 160 180C178 192 172 212 150 218C122 226 90 220 78 206C70 196 68 186 76 180Z" fill="none" stroke="var(--map-relief)" />
          <path d="M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300H390V0Z" fill="var(--ink)" />
          <g clipPath="url(#loginSea)" fill="none" stroke="var(--paper)" strokeWidth="1.2">
            <path transform="translate(12 0)" opacity=".9" d="M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300" />
            <path transform="translate(26 0)" opacity=".6" d="M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300" />
            <path transform="translate(44 0)" opacity=".35" d="M250 0C230 40 262 80 244 118C226 156 270 184 262 224C256 256 236 276 242 300" />
          </g>
          <path d="M20 270C70 262 96 230 126 196" fill="none" stroke="var(--verdigris)" strokeWidth="4" strokeLinecap="round" strokeDasharray="1 10" />
          <path d="M126 196C166 152 202 142 238 136" fill="none" stroke="var(--verdigris)" strokeWidth="4" strokeLinecap="round" />
          <circle cx="126" cy="196" r="7" fill="var(--paper-raised)" stroke="var(--verdigris)" strokeWidth="3" />
          <circle cx="243" cy="135" r="10" fill="var(--paper-raised)" stroke="var(--ink)" strokeWidth="3" />
          <line x1="28" y1="0" x2="28" y2="120" stroke="var(--ink)" strokeWidth="2" /><path d="M28 0H62V104L45 92L28 104Z" fill="var(--house-voros)" />
          <line x1="74" y1="0" x2="74" y2="84" stroke="var(--ink)" strokeWidth="2" /><path d="M74 0H108V70L91 58L74 70Z" fill="var(--house-kek)" />
          <line x1="120" y1="0" x2="120" y2="56" stroke="var(--ink)" strokeWidth="2" /><path d="M120 0H154V42L137 30L120 42Z" fill="var(--house-arany)" />
          <g transform="translate(330 64)"><circle r="26" fill="none" stroke="var(--paper)" opacity=".6" /><polygon points="0,-34 4,-4 34,0 4,4 0,34 -4,4 -34,0 -4,-4" fill="var(--paper)" /></g>
          <g transform="translate(318 262)"><circle r="50" fill="var(--seal)" /><circle r="37" fill="none" stroke="var(--on-seal)" strokeWidth="1.5" opacity=".6" /><path d="M-20 9H20L24 -14L11 -3L0 -22L-11 -3L-24 -14Z" fill="var(--on-seal)" opacity=".85" /></g>
        </svg>
      </div>
      <main className="tn-screen-body login-body">
        <div className="tn-stack" style={{ gap: 8 }}>
          <h1 className="login-title">Trón nélkül</h1>
          <p className="login-tag">Nem városokat foglalsz. Befolyást építesz bennük.</p>
        </div>
        <div className="tn-stack" role="group" aria-label="Bejelentkezés">
          {PROVIDERS.map((p) => (
            <button key={p.id} type="button" className="tn-btn social-btn" disabled={!!busy} onClick={() => login(p)} aria-busy={busy === p.id}>
              <span className={'social-mark social-' + p.id} aria-hidden="true">{p.mark}</span>
              <span>{busy === p.id ? 'Belépés…' : p.label}</span>
            </button>
          ))}
        </div>
        <p className="tn-field-hint login-legal">
          Nincs külön jelszó: a fiókodat a választott szolgáltatón keresztül azonosítjuk. A folytatással elfogadod a Felhasználási feltételeket és az Adatvédelmi tájékoztatót.
        </p>
      </main>
    </div>
  );
}
