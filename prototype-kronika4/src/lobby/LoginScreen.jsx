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
        <svg viewBox="0 0 390 340" preserveAspectRatio="xMidYMid slice">
          <defs>
            <linearGradient id="kSky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="#6f9fc0" /><stop offset=".55" stopColor="#bcd3d6" /><stop offset="1" stopColor="#efdcae" /></linearGradient>
            <radialGradient id="kSun" cx="72%" cy="34%" r="40%"><stop offset="0" stopColor="#fff4cf" stopOpacity=".95" /><stop offset=".35" stopColor="#f7dc9a" stopOpacity=".5" /><stop offset="1" stopColor="#f7dc9a" stopOpacity="0" /></radialGradient>
            <linearGradient id="kFar" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="#8aa3ad" /><stop offset="1" stopColor="#a9b9b3" /></linearGradient>
            <linearGradient id="kHill1" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="#a9ba78" /><stop offset="1" stopColor="#7d9651" /></linearGradient>
            <linearGradient id="kHill2" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="#93ab5f" /><stop offset="1" stopColor="#5f7c3c" /></linearGradient>
            <linearGradient id="kRiver" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stopColor="#9cc4c9" /><stop offset="1" stopColor="#5d98ab" /></linearGradient>
            <radialGradient id="kVig" cx="50%" cy="45%" r="75%"><stop offset=".65" stopColor="#000" stopOpacity="0" /><stop offset="1" stopColor="#2c1f13" stopOpacity=".45" /></radialGradient>
          </defs>
          <rect width="390" height="340" fill="url(#kSky)" />
          <rect width="390" height="340" fill="url(#kSun)" />
          {[[70, 58, 1], [210, 40, 0.8], [330, 92, 0.65], [140, 110, 0.55]].map(([x, y, k], i) => (
            <g key={i} transform={`translate(${x} ${y}) scale(${k})`}>
              <path d="M-52 10c0-9 9-14 18-12c4-12 20-17 31-8c7-9 24-7 27 5c12-2 22 6 20 15z" fill="#f5efe2" opacity=".9" />
              <path d="M-52 10h96c-2 6-8 8-14 7h-70c-6 1-11-2-12-7z" fill="#c9cfcf" opacity=".85" />
            </g>
          ))}
          <path d="M-10 196L28 150L52 170L90 128L120 158L150 136L184 176L214 148L250 184L290 142L322 166L352 138L400 180V230H-10Z" fill="url(#kFar)" />
          <path d="M90 128l-12 16l8-3l6 5l5-9l6 4zM290 142l-10 12l7-2l5 4l4-7l6 3zM352 138l-9 11l6-2l4 3l4-6l5 3z" fill="#eef1ee" opacity=".9" />
          <path d="M-10 214C40 188 96 196 140 206C190 184 250 186 300 200C336 190 370 194 400 204V260H-10Z" fill="#9fb07a" opacity=".85" />
          <path d="M-10 238C50 206 120 212 170 226C214 204 290 206 400 232V340H-10Z" fill="url(#kHill1)" />
          <path d="M150 340C170 300 196 286 214 270C230 258 250 254 274 256C300 258 318 272 330 290C340 306 344 324 346 340Z" fill="url(#kHill2)" stroke="#3a2a1c" strokeWidth=".8" />
          <path d="M-10 300C40 282 100 286 150 300C170 306 180 322 186 340H-10Z" fill="url(#kHill2)" />
          <path d="M0 262C40 256 70 270 100 282C130 294 150 312 158 340H118C112 318 96 304 74 294C52 284 26 280 0 280Z" fill="url(#kRiver)" stroke="#3a2a1c" strokeWidth=".8" />
          <path d="M20 272c14 2 26 7 38 13M70 290c12 5 22 12 30 22M110 306c6 6 10 14 12 24" fill="none" stroke="#eef4ef" strokeWidth="1" strokeDasharray="6 5" opacity=".8" />
          <path d="M80 283c10-9 26-9 36 1" fill="none" stroke="#3a2a1c" strokeWidth="6" />
          <path d="M80 283c10-9 26-9 36 1" fill="none" stroke="#cbbfa7" strokeWidth="4" />
          <path d="M92 280v6M104 279v7" stroke="#3a2a1c" strokeWidth="1" />
          <path d="M30 340C60 320 110 316 150 298C180 284 212 278 236 268" fill="none" stroke="#a8895a" strokeWidth="9" strokeLinecap="round" />
          <path d="M30 340C60 320 110 316 150 298C180 284 212 278 236 268" fill="none" stroke="#d9c08a" strokeWidth="6.5" strokeLinecap="round" />
          <g stroke="#3a2a1c" strokeWidth=".9" strokeLinejoin="round">
            <ellipse cx="272" cy="258" rx="66" ry="8" fill="#2c1f13" opacity=".3" stroke="none" />
            <path d="M208 258V214h128v44z" fill="#cbbfa7" />
            <path d="M208 214v-5h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h6v4h6v-4h8v5z" fill="#cbbfa7" />
            <path d="M208 226h128M208 240h128" stroke="#958770" strokeWidth=".6" fill="none" />
            <rect x="290" y="214" width="46" height="44" fill="#000" opacity=".1" stroke="none" />
            {[[196, 186, 24, 72, '#a9503a', '#7d3627'], [320, 186, 24, 72, '#a9503a', '#7d3627'], [240, 170, 22, 44, '#4d6e8c', '#354f66'], [282, 170, 22, 44, '#4d6e8c', '#354f66']].map(([x, y, w, hh, r, rl], i) => (
              <g key={i}>
                <rect x={x} y={y} width={w} height={hh} fill="#e1d7c2" />
                <rect x={x + w * .58} y={y} width={w * .42} height={hh} fill="#000" opacity=".14" stroke="none" />
                <path d={`M${x} ${y + 16}h${w}M${x} ${y + 32}h${w}`} stroke="#958770" strokeWidth=".6" fill="none" />
                <path d={`M${x + w / 2 - 2} ${y + 10}v-3a2 2 0 0 1 4 0v3zM${x + w / 2 - 2} ${y + 26}v-3a2 2 0 0 1 4 0v3z`} fill="#f2cf6e" />
                <path d={`M${x - 4} ${y}L${x + w / 2} ${y - 30}L${x + w + 4} ${y}z`} fill={r} />
                <path d={`M${x + w / 2} ${y - 30}L${x + w + 4} ${y}H${x + w / 2}z`} fill={rl} opacity=".85" stroke="none" />
                <path d={`M${x + 2} ${y - 7}h${w - 4}M${x + 6} ${y - 15}h${w - 12}`} stroke={rl} strokeWidth=".7" fill="none" />
                <path d={`M${x - 4} ${y}L${x + w / 2} ${y - 30}L${x + w + 4} ${y}z`} fill="none" />
                <path d={`M${x + w / 2} ${y - 30}v-12`} fill="none" strokeWidth="1.1" />
                <path d={`M${x + w / 2} ${y - 42}c4-1.5 7 1.5 11 0l-2.4 3 2.4 3c-4 1.5-7-1.5-11 0z`} fill={['#b23a2e', '#2f5f9e', '#c99a2a', '#3d7b3a'][i]} />
              </g>
            ))}
            <rect x="258" y="132" width="28" height="84" fill="#e1d7c2" />
            <rect x="274" y="132" width="12" height="84" fill="#000" opacity=".14" stroke="none" />
            <path d="M262 150v-5a3 3 0 0 1 6 0v5zM276 150v-5a3 3 0 0 1 6 0v5zM262 172v-5a3 3 0 0 1 6 0v5zM276 172v-5a3 3 0 0 1 6 0v5z" fill="#f2cf6e" />
            <path d="M252 132L272 90L292 132z" fill="#a9503a" />
            <path d="M272 90L292 132H272z" fill="#7d3627" opacity=".85" stroke="none" />
            <path d="M258 122h28M263 110h18M267 100h10" stroke="#7d3627" strokeWidth=".7" fill="none" />
            <path d="M252 132L272 90L292 132z" fill="none" />
            <path d="M272 90V70" fill="none" strokeWidth="1.2" />
            <path d="M272 70c6-2.5 11 2.5 17 0l-3.4 4.4 3.4 4.4c-6 2.5-11-2.5-17 0z" fill="#b23a2e" />
            <path d="M262 258v-20a10 10 0 0 1 20 0v20z" fill="#3b3026" />
            <path d="M266 240v18M272 236v22M278 240v18M263 246h18" stroke="#958770" strokeWidth=".7" fill="none" />
          </g>
          {[[172, 300, 0], [186, 296, 1], [200, 302, 2], [340, 300, 1], [354, 294, 0], [364, 306, 2]].map(([x, y, k], i) => {
            const roof = ['#a9503a', '#4d6e8c', '#8a6242'][k];
            return (
              <g key={i} stroke="#3a2a1c" strokeWidth=".7" strokeLinejoin="round">
                <rect x={x - 7} y={y - 6} width="14" height="11" fill="#ecdfbf" />
                <path d={`M${x - 3} ${y - 6}v11M${x + 3} ${y - 6}v11M${x - 7} ${y}h14`} stroke="#5b3d27" strokeWidth=".5" />
                <rect x={x - 5.5} y={y - 4} width="2.2" height="2.2" fill="#f2cf6e" strokeWidth=".3" />
                <path d={`M${x - 9} ${y - 5.5}L${x} ${y - 15}L${x + 9} ${y - 5.5}z`} fill={roof} />
                <path d={`M${x} ${y - 15}L${x + 9} ${y - 5.5}H${x}z`} fill="#000" opacity=".22" stroke="none" />
              </g>
            );
          })}
          {[[24, 300, 9, 1], [48, 292, 8, 0], [70, 304, 10, 1], [350, 250, 8, 0], [372, 262, 9, 1], [196, 248, 7, 0], [12, 250, 8, 1], [150, 262, 7, 1]].map(([x, y, r, pine], i) => pine ? (
            <g key={i} stroke="#3a2a1c" strokeWidth=".7" strokeLinejoin="round">
              <ellipse cx={x + 2} cy={y + r + 3} rx={r * .8} ry="1.8" fill="#2c1f13" opacity=".3" stroke="none" />
              <rect x={x - 1} y={y + r * .4} width="2" height={r * .8} fill="#7d5230" />
              {[0, -0.8, -1.55].map((t, j) => <g key={j}><path d={`M${x - r * (1 - j * .22)} ${y + t * r + r * .45}L${x} ${y + t * r - r * .7}L${x + r * (1 - j * .22)} ${y + t * r + r * .45}z`} fill="#3d6634" /><path d={`M${x} ${y + t * r - r * .7}L${x + r * (1 - j * .22)} ${y + t * r + r * .45}H${x}z`} fill="#34552a" stroke="none" /></g>)}
            </g>
          ) : (
            <g key={i} stroke="#3a2a1c" strokeWidth=".7">
              <ellipse cx={x + 2} cy={y + r + 3} rx={r} ry="2" fill="#2c1f13" opacity=".3" stroke="none" />
              <rect x={x - 1.2} y={y} width="2.4" height={r + 2} fill="#7d5230" />
              <circle cx={x - r * .35} cy={y + r * .1} r={r * .72} fill="#34552a" />
              <circle cx={x + r * .4} cy={y + r * .15} r={r * .7} fill="#34552a" />
              <circle cx={x} cy={y - r * .35} r={r * .8} fill="#4d7535" />
              <circle cx={x - r * .3} cy={y - r * .6} r={r * .32} fill="#6f9448" stroke="none" />
            </g>
          ))}
          <path d="M120 70q4-4 8 0q4-4 8 0M150 84q3-3 6 0q3-3 6 0M104 90q3-3 6 0q3-3 6 0" fill="none" stroke="#3a2a1c" strokeWidth="1.1" strokeLinecap="round" />
          <rect width="390" height="340" fill="url(#kVig)" />
        </svg>
      </div>
      <main className="tn-screen-body login-body">
        <div className="tn-stack" style={{ gap: 8 }}>
          <h1 className="login-title tn-hero">Trón nélkül</h1>
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
