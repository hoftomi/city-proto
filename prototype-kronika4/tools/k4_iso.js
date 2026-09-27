  /* ---------- Krónika IV: izometrikus eszközkészlet ---------- */
  var I4 = { S: 3.8, X: 360, Y: 70 };
  var I4O = '#3a2a1c';
  function iP(u, v, z) { return [I4.X + (u - v) * 0.866 * I4.S, I4.Y + (u + v) * 0.5 * I4.S - (z || 0) * I4.S]; }
  function iWith(S, X, Y, fn) { var o = [I4.S, I4.X, I4.Y]; I4.S = S; I4.X = X; I4.Y = Y; try { return fn(); } finally { I4.S = o[0]; I4.X = o[1]; I4.Y = o[2]; } }
  function iF(n) { return Math.round(n * 10) / 10; }
  function iPts(a) { return a.map(function (q) { var p = iP(q[0], q[1], q[2]); return iF(p[0]) + ',' + iF(p[1]); }).join(' '); }
  function iLn(a, b) { var p = iP(a[0], a[1], a[2]), q = iP(b[0], b[1], b[2]); return 'M' + iF(p[0]) + ' ' + iF(p[1]) + 'L' + iF(q[0]) + ' ' + iF(q[1]); }
  function iPath(a, close) { return a.map(function (q, i) { var p = iP(q[0], q[1], q[2]); return (i ? 'L' : 'M') + iF(p[0]) + ' ' + iF(p[1]); }).join('') + (close ? 'Z' : ''); }
  function iL(a, b, t) { return [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, (a[2] || 0) + ((b[2] || 0) - (a[2] || 0)) * t]; }
  function iM(F, s, t) { return iL(iL(F[0], F[1], s), iL(F[3], F[2], s), t); }
  function iQ(F, s0, t0, s1, t1) { return [iM(F, s0, t0), iM(F, s1, t0), iM(F, s1, t1), iM(F, s0, t1)]; }
  function iHex(c) { c = c.replace('#', ''); return [parseInt(c.slice(0, 2), 16), parseInt(c.slice(2, 4), 16), parseInt(c.slice(4, 6), 16)]; }
  function iMix(a, b, t) { var x = iHex(a), y = iHex(b); return '#' + x.map(function (v, i) { var n = Math.max(0, Math.min(255, Math.round(v + (y[i] - v) * t))); return (n < 16 ? '0' : '') + n.toString(16); }).join(''); }
  function iPoly(o, pts, fill, ex) { o.push(h('polygon', Object.assign({ key: o.length, points: iPts(pts), fill: fill, stroke: I4O, strokeWidth: 0.35, strokeLinejoin: 'round' }, ex || {}))); }
  function iAo(o, pts) { o.push(h('polygon', { key: o.length, points: iPts(pts), fill: 'url(#i4-ao)' })); }
  function iPathEl(o, d, stroke, w, ex) { o.push(h('path', Object.assign({ key: o.length, d: d, stroke: stroke, strokeWidth: w, fill: 'none', strokeLinecap: 'round' }, ex || {}))); }
  var MAT = {
    stone: { lit: '#e3d7bf', shade: '#a5967c', line: '#86775f' },
    plaster: { lit: '#efe3c8', shade: '#bca985', line: '#9c8a68' },
    ochre: { lit: '#e8cc8a', shade: '#b39554', line: '#937840' },
    rose: { lit: '#e9c3ab', shade: '#b08670', line: '#8e6b58' },
    white: { lit: '#f5efe0', shade: '#c7bca3', line: '#a69b83' },
    brick: { lit: '#c47c5c', shade: '#8a4f39', line: '#6a3a28' },
    wood: { lit: '#a0714a', shade: '#6a4629', line: '#48301c' },
    barn: { lit: '#b25a40', shade: '#7a3727', line: '#55251a' },
    dark: { lit: '#8f8170', shade: '#5a4e42', line: '#3e342b' },
    grey: { lit: '#a8a094', shade: '#6d665d', line: '#514a42' },
    rock: { lit: '#cbb899', shade: '#7c6a53', line: '#5f503e' }
  };
  var ROOF = {
    red: { a: '#c8694b', b: '#8c3d29', c: '#a14b33', line: '#5a2418' },
    brown: { a: '#a67a51', b: '#6c4a2e', c: '#825b39', line: '#43291a' },
    slate: { a: '#7c92a7', b: '#495c6f', c: '#5a6e82', line: '#2c3946' },
    teal: { a: '#78a295', b: '#476b60', c: '#567d71', line: '#2c443c' },
    thatch: { a: '#d6bb77', b: '#9f803d', c: '#b8984f', line: '#6e5424' },
    dark: { a: '#6d5f68', b: '#3c323d', c: '#4c404b', line: '#221c22' },
    moss: { a: '#808c5a', b: '#4d5832', c: '#5f6b3e', line: '#2f361e' },
    copper: { a: '#9ac8ae', b: '#5a8871', c: '#6f9a83', line: '#3a5a4c' }
  };
  function I4Defs() {
    var g = [];
    function lin(id, stops, horiz) { g.push(h('linearGradient', { key: id, id: id, x1: 0, y1: 0, x2: horiz ? 1 : 0, y2: horiz ? 0 : 1 }, stops.map(function (s, i) { return h('stop', { key: i, offset: s[0], stopColor: s[1], stopOpacity: s[2] == null ? 1 : s[2] }); }))); }
    lin('i4-ao', [['0%', '#fff8e8', 0.1], ['50%', '#000000', 0], ['100%', '#1e140c', 0.32]]);
    lin('i4-haze', [['0%', '#c9d6c4', 0.85], ['100%', '#c9d6c4', 0]]);
    lin('i4-road', [['0%', '#d6bf92'], ['100%', '#bfa576']]);
    Object.keys(MAT).forEach(function (k) { var m = MAT[k]; lin('i4c-' + k, [['0%', iMix(m.lit, '#ffffff', 0.1)], ['30%', m.lit], ['68%', iMix(m.lit, m.shade, 0.7)], ['100%', iMix(m.shade, '#000000', 0.18)]], true); });
    Object.keys(ROOF).forEach(function (k) { var R = ROOF[k]; lin('i4r-' + k, [['0%', iMix(R.a, '#ffffff', 0.16)], ['40%', R.a], ['100%', iMix(R.b, '#000000', 0.1)]], true); });
    g.push(h('radialGradient', { key: 'dome', id: 'i4-dome', cx: '34%', cy: '28%', r: '80%' }, h('stop', { offset: '0%', stopColor: '#d2ecdc' }), h('stop', { offset: '40%', stopColor: '#86b59f' }), h('stop', { offset: '100%', stopColor: '#3b6453' })));
    g.push(h('radialGradient', { key: 'fire', id: 'i4-fire', cx: '50%', cy: '50%', r: '50%' }, h('stop', { offset: '0%', stopColor: '#ffd98a', stopOpacity: 0.95 }), h('stop', { offset: '40%', stopColor: '#f39a3c', stopOpacity: 0.5 }), h('stop', { offset: '100%', stopColor: '#f39a3c', stopOpacity: 0 })));
    [['i4-tree1', '#a6c46a', '#5f8a3a', '#2f4f22'], ['i4-tree2', '#86b05a', '#44702e', '#22401c'], ['i4-tree3', '#b4b862', '#6f7c38', '#3a4420'], ['i4-autumn', '#e0b058', '#b0702e', '#6a3e1c']].forEach(function (q) { g.push(h('radialGradient', { key: q[0], id: q[0], cx: '36%', cy: '30%', r: '72%' }, h('stop', { offset: '0%', stopColor: q[1] }), h('stop', { offset: '55%', stopColor: q[2] }), h('stop', { offset: '100%', stopColor: q[3] }))); });
    g.push(h('radialGradient', { key: 'hill', id: 'i4-hill', cx: '38%', cy: '30%', r: '75%' }, h('stop', { offset: '0%', stopColor: '#c3d48a' }), h('stop', { offset: '60%', stopColor: '#93ae5e' }), h('stop', { offset: '100%', stopColor: '#6f8f42' })));
    g.push(h('filter', { key: 'night', id: 'i4-night', x: '-5%', y: '-5%', width: '110%', height: '110%' }, h('feColorMatrix', { type: 'matrix', values: '0.42 0.1 0.04 0 0.01  0.08 0.44 0.05 0 0.01  0.07 0.12 0.44 0 0.03  0 0 0 1 0' })));
    return h('defs', null, g);
  }
  var I4V = [0.577, 0.577, 0.577], I4Lt = [-0.5, 0.18, 0.85];
  function iNorm(a, b, c) { var x1 = b[0] - a[0], y1 = b[1] - a[1], z1 = (b[2] || 0) - (a[2] || 0), x2 = c[0] - a[0], y2 = c[1] - a[1], z2 = (c[2] || 0) - (a[2] || 0), n = [y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2], L = Math.hypot(n[0], n[1], n[2]) || 1; return [n[0] / L, n[1] / L, n[2] / L]; }
  function iLight(n, lit, shade) { var b = n[0] * I4Lt[0] + n[1] * I4Lt[1] + n[2] * I4Lt[2]; return iMix(shade, lit, Math.max(0, Math.min(1, (b + 0.2) / 1.1))); }
  /* doboz: bal (+v) fal világos, jobb (+u) fal árnyékos */
  function iBoxF(u0, v0, u1, v1, z0, z1) {
    return { L: [[u0, v1, z0], [u1, v1, z0], [u1, v1, z1], [u0, v1, z1]], R: [[u1, v1, z0], [u1, v0, z0], [u1, v0, z1], [u1, v1, z1]], T: [[u0, v0, z1], [u1, v0, z1], [u1, v1, z1], [u0, v1, z1]] };
  }
  function iBox(o, u0, v0, u1, v1, z0, z1, m, opt) {
    opt = opt || {}; var B = iBoxF(u0, v0, u1, v1, z0, z1);
    iPoly(o, B.L, opt.litFill || m.lit); iPoly(o, B.R, opt.shadeFill || m.shade);
    if (!opt.noAo) { iAo(o, B.L); iAo(o, B.R); }
    if (!opt.noTop) iPoly(o, B.T, opt.top || iMix(m.lit, '#ffffff', 0.12));
    return B;
  }
  function iStone(o, F, m, rows, cols, op) {
    if (I4.S < 1.6) return;
    var d = [];
    for (var i = 1; i < rows; i++) d.push(iLn(iM(F, 0, i / rows), iM(F, 1, i / rows)));
    for (i = 0; i < rows; i++) for (var j = 0; j < cols; j++) { var s = (j + (i % 2 ? 0.5 : 0.15)) / cols; if (s > 0.02 && s < 0.98) d.push(iLn(iM(F, s, i / rows), iM(F, s, (i + 1) / rows))); }
    iPathEl(o, d.join(''), m.line, 0.3, { opacity: op || 0.55, strokeLinecap: 'butt' });
  }
  function iTimber(o, F, len, floors) {
    if (I4.S < 1.6) return;
    var d = [], n = Math.max(2, Math.round(len / 1.7));
    for (var i = 0; i <= n; i++) d.push(iLn(iM(F, i / n, 0), iM(F, i / n, 1)));
    for (var f = 0; f <= floors; f++) { var t = Math.min(1, f / floors); d.push(iLn(iM(F, 0, t), iM(F, 1, t))); }
    for (i = 0; i < n; i++) for (f = 0; f < floors; f++) { if ((i + f) % 2) d.push(iLn(iM(F, i / n, f / floors), iM(F, (i + 1) / n, (f + 0.6) / floors))); else d.push(iLn(iM(F, (i + 1) / n, f / floors), iM(F, i / n, (f + 0.6) / floors))); }
    iPathEl(o, d.join(''), '#5a3a24', 0.7, { strokeLinecap: 'square', opacity: 0.92 });
  }
  function iPlanks(o, F, n, col) { var d = []; for (var i = 1; i < n; i++) d.push(iLn(iM(F, i / n, 0), iM(F, i / n, 1))); iPathEl(o, d.join(''), col, 0.3, { opacity: 0.6 }); }
  var SHUT = ['#5f7d52', '#4f6a86', '#7a3e2a', '#6e5a3a', '#3f5a4a', '#8a6a3a'];
  function iWin(o, F, s0, t0, s1, t1, opt) {
    opt = opt || {};
    var ds = s1 - s0, dt = t1 - t0, fr = iQ(F, s0 - ds * 0.12, t0 - dt * 0.08, s1 + ds * 0.12, t1 + dt * 0.06);
    if (opt.arch) fr = [fr[0], fr[1], fr[2], iM(F, (s0 + s1) / 2, t1 + dt * 0.4), fr[3]];
    if (opt.shutter) { iPoly(o, iQ(F, s0 - ds * 0.62, t0, s0 - ds * 0.1, t1), opt.shutter, { strokeWidth: 0.2 }); iPoly(o, iQ(F, s1 + ds * 0.1, t0, s1 + ds * 0.62, t1), opt.shutter, { strokeWidth: 0.2 }); }
    iPoly(o, fr, opt.frame || '#e6dac0', { strokeWidth: 0.22 });
    var gl = iQ(F, s0, t0, s1, t1);
    if (opt.arch) gl = [gl[0], gl[1], gl[2], iM(F, (s0 + s1) / 2, t1 + dt * 0.28), gl[3]];
    iPoly(o, gl, opt.lit ? '#f7d074' : (opt.dark ? '#1c1718' : '#35414b'), { strokeWidth: 0.2 });
    if (!opt.lit && !opt.dark) iPathEl(o, iLn(iM(F, s0 + ds * 0.2, t1 - dt * 0.1), iM(F, s0 + ds * 0.62, t0 + dt * 0.35)), '#9fb3bf', 0.35, { opacity: 0.55 });
    var mid = (s0 + s1) / 2, tm = t0 + dt * 0.55;
    iPathEl(o, iLn(iM(F, mid, t0), iM(F, mid, t1)) + iLn(iM(F, s0, tm), iM(F, s1, tm)), opt.frame || '#e6dac0', 0.3, { strokeLinecap: 'butt' });
    if (opt.board) iPathEl(o, iLn(iM(F, s0 - ds * 0.1, t0 + dt * 0.3), iM(F, s1 + ds * 0.1, t0 + dt * 0.45)) + iLn(iM(F, s0 - ds * 0.1, t0 + dt * 0.75), iM(F, s1 + ds * 0.1, t0 + dt * 0.62)), '#6b4a30', 0.8, { strokeLinecap: 'butt' });
    if (opt.sill !== false) iPoly(o, iQ(F, s0 - ds * 0.2, t0 - dt * 0.2, s1 + ds * 0.2, t0 - dt * 0.08), opt.flower ? '#7a5a3a' : '#d4c7aa', { strokeWidth: 0.2 });
    if (opt.flower) { var p = iP.apply(null, iM(F, mid, t0 - dt * 0.05)); ['#c0503a', '#e08aa0', '#d9a441'].forEach(function (c, i) { o.push(h('circle', { key: o.length, cx: iF(p[0] + (i - 1) * 1.1), cy: iF(p[1] - 0.8), r: 0.65, fill: c })); }); o.push(h('circle', { key: o.length, cx: iF(p[0] + 1.6), cy: iF(p[1] - 0.4), r: 0.5, fill: '#5f8a45' })); }
    if (opt.lit) { var q = iP.apply(null, iM(F, mid, (t0 + t1) / 2)); o.push(h('circle', { key: o.length, cx: iF(q[0]), cy: iF(q[1]), r: 5, fill: 'url(#kg-glow)', opacity: 0.55 })); }
  }
  function iDoor(o, F, s0, s1, t1, col, arch) {
    var q = iQ(F, s0, 0, s1, t1), top = iM(F, (s0 + s1) / 2, t1 * (arch ? 1.22 : 1.08));
    iPoly(o, [q[0], q[1], q[2], top, q[3]], '#3a2a1c', { strokeWidth: 0.2 });
    var inner = iQ(F, s0 + (s1 - s0) * 0.1, 0, s1 - (s1 - s0) * 0.1, t1 * 0.96), it = iM(F, (s0 + s1) / 2, t1 * (arch ? 1.15 : 1.03));
    iPoly(o, [inner[0], inner[1], inner[2], it, inner[3]], col || '#6e4a2c', { strokeWidth: 0.2 });
    var d = []; for (var i = 1; i < 4; i++) d.push(iLn(iM(F, s0 + (s1 - s0) * i / 4, 0.02), iM(F, s0 + (s1 - s0) * i / 4, t1 * 0.94))); iPathEl(o, d.join(''), '#3e2a18', 0.25, { opacity: 0.7 });
    var hd = iP.apply(null, iM(F, s0 + (s1 - s0) * 0.78, t1 * 0.5)); o.push(h('circle', { key: o.length, cx: iF(hd[0]), cy: iF(hd[1]), r: 0.35, fill: '#d8b55c' }));
    iPoly(o, iQ(F, s0 - (s1 - s0) * 0.1, -0.02, s1 + (s1 - s0) * 0.1, 0.03), '#a89a80', { strokeWidth: 0.2 });
  }
  function iTiles(o, F, R, kind, len) {
    if (I4.S < 1.6) { iPathEl(o, iLn(iM(F, 0, 0.5), iM(F, 1, 0.5)), R.line, 0.25, { opacity: 0.4 }); return; }
    var d = [], n = Math.max(3, Math.round(len / (kind === 'slate' ? 0.75 : 0.62)));
    if (kind === 'thatch') {
      for (var i = 0; i < n * 3; i++) { var s = (i + 0.5) / (n * 3), t = ((i * 7) % 5) / 9; d.push(iLn(iM(F, s, t), iM(F, s, t + 0.3))); }
      iPathEl(o, d.join(''), R.line, 0.3, { opacity: 0.45 });
      iPathEl(o, iLn(iM(F, 0, 0.02), iM(F, 1, 0.02)), R.b, 1.2, { opacity: 0.8 });
      return;
    }
    var rows = kind === 'slate' ? 8 : 6;
    for (var r = 1; r <= rows; r++) { var t0 = r / (rows + 0.5), tp = (r - 1) / (rows + 0.5); d.push(iLn(iM(F, 0, t0), iM(F, 1, t0))); for (var j = 0; j <= n; j++) { var s2 = (j + (r % 2 ? 0.5 : 0)) / n; if (s2 > 0.01 && s2 < 0.99) d.push(iLn(iM(F, s2, tp), iM(F, s2, t0))); } }
    iPathEl(o, d.join(''), R.line, 0.28, { opacity: 0.5, strokeLinecap: 'butt' });
    iPathEl(o, iLn(iM(F, 0, 0.012), iM(F, 1, 0.012)), R.line, 0.6, { opacity: 0.55 });
  }
  function iSlope(o, F, fill, R, kind, len) { iPoly(o, F, fill, { strokeWidth: 0.4 }); iTiles(o, F, R, kind, len); iAo(o, [F[3], F[2], F[1], F[0]]); }
  /* tetők: gu = gerinc u irányban, gv = gerinc v irányban, hip = kontyolt, pyr = gúla */
  function iRoof(o, u0, v0, u1, v1, z, rh, type, R, m, opt) {
    opt = opt || {};
    var ov = opt.ov == null ? 0.55 : opt.ov, kind = opt.kind || 'tile', um = (u0 + u1) / 2, vm = (v0 + v1) / 2, z2 = z + rh;
    var half = type === 'gv' ? (u1 - u0) / 2 : type === 'gu' ? (v1 - v0) / 2 : Math.min(u1 - u0, v1 - v0) / 2, ze = z - ov * rh / half;
    var a0 = u0 - ov, a1 = u1 + ov, b0 = v0 - ov, b1 = v1 + ov, lit = iMix(R.a, '#ffffff', 0.1), mid = opt.mid || function () {};
    if (type === 'gu') {
      iSlope(o, [[a0, b0, ze], [a1, b0, ze], [a1, vm, z2], [a0, vm, z2]], R.c, R, kind, u1 - u0);
      mid(o);
      var G = [[u1, v1, z], [u1, v0, z], [u1, vm, z2], [u1, vm, z2]];
      iPoly(o, G, m.shade); iAo(o, G);
      if (opt.gableWin) iWin(o, G, 0.42, 0.25, 0.58, 0.55, { dark: opt.dark });
      iSlope(o, [[a0, b1, ze], [a1, b1, ze], [a1, vm, z2], [a0, vm, z2]], R.a, R, kind, u1 - u0);
      iPathEl(o, iPath([[a1, b1, ze], [a1, vm, z2], [a1, b0, ze]]), R.line, 0.9);
      iPathEl(o, iLn([a0, vm, z2], [a1, vm, z2]), R.line, 1.2); iPathEl(o, iLn([a0, vm, z2 + 0.12], [a1, vm, z2 + 0.12]), iMix(R.a, '#ffffff', 0.3), 0.4, { opacity: 0.7 });
    } else if (type === 'gv') {
      iSlope(o, [[a0, b1, ze], [a0, b0, ze], [um, b0, z2], [um, b1, z2]], lit, R, kind, v1 - v0);
      mid(o);
      var G2 = [[u0, v1, z], [u1, v1, z], [um, v1, z2], [um, v1, z2]];
      iPoly(o, G2, m.lit); iAo(o, G2);
      if (opt.gableWin) iWin(o, G2, 0.42, 0.25, 0.58, 0.55, { dark: opt.dark });
      iSlope(o, [[a1, b1, ze], [a1, b0, ze], [um, b0, z2], [um, b1, z2]], R.b, R, kind, v1 - v0);
      iPathEl(o, iPath([[a0, b1, ze], [um, b1, z2], [a1, b1, ze]]), R.line, 0.9);
      iPathEl(o, iLn([um, b0, z2], [um, b1, z2]), R.line, 1.2);
    } else {
      var ru = (u1 - u0) >= (v1 - v0), p0, p1;
      if (type === 'pyr') { p0 = [um, vm, z2]; p1 = p0; }
      else if (ru) { p0 = [u0 + half, vm, z2]; p1 = [u1 - half, vm, z2]; }
      else { p0 = [um, v0 + half, z2]; p1 = [um, v1 - half, z2]; }
      if (ru) {
        iSlope(o, [[a0, b0, ze], [a1, b0, ze], p1, p0], R.c, R, kind, u1 - u0);
        iSlope(o, [[a0, b1, ze], [a0, b0, ze], p0, p0], lit, R, kind, v1 - v0);
        mid(o);
        iSlope(o, [[a1, b1, ze], [a1, b0, ze], p1, p1], R.b, R, kind, v1 - v0);
        iSlope(o, [[a0, b1, ze], [a1, b1, ze], p1, p0], R.a, R, kind, u1 - u0);
      } else {
        iSlope(o, [[a0, b0, ze], [a1, b0, ze], p0, p0], R.c, R, kind, u1 - u0);
        iSlope(o, [[a0, b1, ze], [a0, b0, ze], p0, p1], lit, R, kind, v1 - v0);
        mid(o);
        iSlope(o, [[a1, b1, ze], [a1, b0, ze], p0, p1], R.b, R, kind, v1 - v0);
        iSlope(o, [[a0, b1, ze], [a1, b1, ze], p1, p1], R.a, R, kind, u1 - u0);
      }
      iPathEl(o, iPath([[a0, b1, ze], p0]) + iPath([[a1, b1, ze], p1]) + iPath([[a1, b0, ze], ru ? p1 : p0]) + (p0 !== p1 ? iLn(p0, p1) : ''), R.line, 0.9, { opacity: 0.85 });
    }
  }
  function iChimney(o, u, v, z0, z1) {
    iBox(o, u, v, u + 0.9, v + 0.9, z0, z1, MAT.stone, { top: '#6f6352' });
    iBox(o, u - 0.12, v - 0.12, u + 1.02, v + 1.02, z1, z1 + 0.25, MAT.stone, { noAo: true });
    iStone(o, iBoxF(u, v, u + 0.9, v + 0.9, z0, z1).L, MAT.stone, 3, 1, 0.4);
  }
  function iSmoke(o, u, v, z, r) {
    var p = iP(u, v, z);
    for (var i = 0; i < 4; i++) o.push(h('circle', { key: o.length, cx: iF(p[0] + i * 1.8 + r() * 1.5), cy: iF(p[1] - 2 - i * 3.2), r: iF(1.3 + i * 0.7), fill: '#ece6da', opacity: 0.5 - i * 0.1, filter: 'url(#kg-blur)' }));
  }
  /* henger és kúp (kerek tornyok) */
  function iCyl(o, u, v, r, z0, z1, mk, opt) {
    opt = opt || {};
    var c0 = iP(u, v, z0), c1 = iP(u, v, z1), rx = r * 1.2247 * I4.S, ry = r * 0.7071 * I4.S, m = MAT[mk];
    var d = 'M' + iF(c1[0] - rx) + ' ' + iF(c1[1]) + 'L' + iF(c0[0] - rx) + ' ' + iF(c0[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 0 ' + iF(c0[0] + rx) + ' ' + iF(c0[1]) + 'L' + iF(c1[0] + rx) + ' ' + iF(c1[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 1 ' + iF(c1[0] - rx) + ' ' + iF(c1[1]) + 'Z';
    o.push(h('path', { key: o.length, d: d, fill: 'url(#i4c-' + mk + ')', stroke: I4O, strokeWidth: 0.4 }));
    o.push(h('path', { key: o.length, d: d, fill: 'url(#i4-ao)' }));
    if (opt.courses && I4.S >= 1.6) {
      var cs = [], k = 0;
      for (var z = z0 + 0.75; z < z1 - 0.2; z += 0.75, k++) {
        var c = iP(u, v, z); cs.push('M' + iF(c[0] - rx) + ' ' + iF(c[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 0 ' + iF(c[0] + rx) + ' ' + iF(c[1]));
        for (var a = (k % 2 ? 22 : 8); a < 180; a += 30) { var th = a * Math.PI / 180, x = c[0] + rx * Math.cos(th), y = c[1] + ry * Math.sin(th); cs.push('M' + iF(x) + ' ' + iF(y) + 'v' + iF(0.75 * I4.S)); }
      }
      iPathEl(o, cs.join(''), m.line, 0.28, { opacity: 0.5, strokeLinecap: 'butt' });
    }
    if (opt.top !== false) o.push(h('ellipse', { key: o.length, cx: iF(c1[0]), cy: iF(c1[1]), rx: iF(rx), ry: iF(ry), fill: opt.topFill || iMix(m.lit, '#ffffff', 0.12), stroke: I4O, strokeWidth: 0.35 }));
    return { c0: c0, c1: c1, rx: rx, ry: ry };
  }
  function iCone(o, u, v, r, z, hh, rk) {
    var c = iP(u, v, z), rx = r * 1.2247 * I4.S, ry = r * 0.7071 * I4.S, ap = iP(u, v, z + hh), R = ROOF[rk];
    var d = 'M' + iF(c[0] - rx) + ' ' + iF(c[1]) + 'L' + iF(ap[0]) + ' ' + iF(ap[1]) + 'L' + iF(c[0] + rx) + ' ' + iF(c[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 1 ' + iF(c[0] - rx) + ' ' + iF(c[1]) + 'Z';
    o.push(h('path', { key: o.length, d: d, fill: 'url(#i4r-' + rk + ')', stroke: I4O, strokeWidth: 0.45, strokeLinejoin: 'round' }));
    var t = [];
    if (I4.S >= 1.6) for (var f = 0.25; f < 1; f += 0.15) { var cy = ap[1] + (c[1] - ap[1]) * f, fx = rx * f, fy = ry * f; t.push('M' + iF(ap[0] - fx) + ' ' + iF(cy) + 'A' + iF(fx) + ' ' + iF(fy) + ' 0 0 0 ' + iF(ap[0] + fx) + ' ' + iF(cy)); }
    if (I4.S >= 1.6) for (var a = 15; a < 180; a += 22) { var th = a * Math.PI / 180; t.push('M' + iF(ap[0]) + ' ' + iF(ap[1]) + 'L' + iF(c[0] + rx * Math.cos(th)) + ' ' + iF(c[1] + ry * Math.sin(th))); }
    iPathEl(o, t.join(''), R.line, 0.28, { opacity: 0.45 });
    o.push(h('path', { key: o.length, d: 'M' + iF(c[0] - rx) + ' ' + iF(c[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 0 ' + iF(c[0] + rx) + ' ' + iF(c[1]), stroke: R.line, strokeWidth: 0.7, fill: 'none', opacity: 0.8 }));
    return ap;
  }
  function iFlag(o, x, y, len, col) {
    o.push(h('path', { key: o.length, d: 'M' + iF(x) + ' ' + iF(y) + 'v-' + len, stroke: '#3a2a1c', strokeWidth: 0.6 }));
    o.push(h('path', { key: o.length, d: 'M' + iF(x) + ' ' + iF(y - len) + 'c3-1.4 5.6 1.4 9 0l-1.6 2.4 1.6 2.4c-3.4 1.4-6-1.4-9 0z', fill: col, stroke: '#3a2a1c', strokeWidth: 0.35 }));
    o.push(h('path', { key: o.length, d: 'M' + iF(x + 1) + ' ' + iF(y - len + 1.6) + 'c2.4-.8 4-.1 6 .2', stroke: '#ffffff', strokeWidth: 0.4, opacity: 0.35, fill: 'none' }));
  }
  function iMerlonsRing(o, c, rx, ry, back, m) {
    for (var a = back ? 195 : 15; a < (back ? 345 : 170); a += 24) {
      var th = a * Math.PI / 180, x = c[0] + rx * Math.cos(th), y = c[1] + ry * Math.sin(th), w = rx * 0.2;
      o.push(h('rect', { key: o.length, x: iF(x - w / 2), y: iF(y - 1.1 * I4.S), width: iF(w), height: iF(1.1 * I4.S), fill: Math.cos(th) > 0.2 ? m.shade : m.lit, stroke: I4O, strokeWidth: 0.3 }));
    }
  }
  /* kerek torony: kúpos vagy pártázatos */
  function iRTower(u, v, r, hh, opt) {
    opt = opt || {}; var o = [], mk = opt.mat || 'stone', m = MAT[mk];
    var sp = iP(u + r * 0.6, v + r * 0.2, 0);
    o.push(h('ellipse', { key: o.length, cx: iF(sp[0] + r * 2.2), cy: iF(sp[1] + 1), rx: iF(r * 1.2247 * I4.S * 1.5), ry: iF(r * 0.7071 * I4.S * 1.1), fill: '#2c1f13', opacity: 0.3, filter: 'url(#kg-blur)' }));
    iCyl(o, u, v, r * 1.08, 0, 1, mk, { top: false });
    var cy = iCyl(o, u, v, r, 0.8, hh, mk, { courses: true, top: false });
    var slits = [[90, 0.35], [55, 0.62], [125, 0.62]];
    slits.forEach(function (q) { var th = q[0] * Math.PI / 180, c = iP(u, v, hh * q[1]), x = c[0] + cy.rx * Math.cos(th) * 0.9, y = c[1] + cy.ry * Math.sin(th); o.push(h('rect', { key: o.length, x: iF(x - 0.55), y: iF(y - 3.2), width: 1.1, height: 3.2, rx: 0.5, fill: '#1c1718' })); });
    if (opt.window) { var cw = iP(u, v, hh * 0.72), wx = cw[0] - cy.rx * 0.2, wy = cw[1] + cy.ry * 0.95; o.push(h('path', { key: o.length, d: 'M' + iF(wx - 1.3) + ' ' + iF(wy) + 'v-3a1.3 1.3 0 0 1 2.6 0v3z', fill: opt.lit ? '#f7d074' : '#2d2a2c', stroke: '#e6dac0', strokeWidth: 0.4 })); }
    if (opt.roof === 'cren') {
      var cr = iCyl(o, u, v, r * 1.14, hh - 0.2, hh + 0.5, mk, { top: false });
      var cc = iP(u, v, hh + 0.5);
      o.push(h('ellipse', { key: o.length, cx: iF(cc[0]), cy: iF(cc[1]), rx: iF(cr.rx), ry: iF(cr.ry), fill: '#8a7d68', stroke: I4O, strokeWidth: 0.35 }));
      iMerlonsRing(o, cc, cr.rx * 0.97, cr.ry * 0.97, true, m);
      o.push(h('ellipse', { key: o.length, cx: iF(cc[0]), cy: iF(cc[1]), rx: iF(cr.rx * 0.78), ry: iF(cr.ry * 0.78), fill: '#6f6352', opacity: 0.6 }));
      iMerlonsRing(o, cc, cr.rx * 0.97, cr.ry * 0.97, false, m);
      if (opt.flag) iFlag(o, cc[0], cc[1] - 2, 12, opt.flag);
    } else if (opt.roof === 'broken') {
      var bt = iP(u, v, hh);
      o.push(h('path', { key: o.length, d: 'M' + iF(bt[0] - cy.rx) + ' ' + iF(bt[1]) + 'l2 -2.4 1.6 1.8 2.2-3.4 2 2.6 1.8-1.6 2.4 2.2 2-1.4 1.6 2.2', fill: 'none', stroke: I4O, strokeWidth: 0.6 }));
      o.push(h('ellipse', { key: o.length, cx: iF(bt[0]), cy: iF(bt[1]), rx: iF(cy.rx * 0.8), ry: iF(cy.ry * 0.8), fill: '#2a2224' }));
      o.push(h('path', { key: o.length, d: 'M' + iF(bt[0] + cy.rx * 0.5) + ' ' + iF(bt[1] + 3) + 'c1.5 4 -.6 8 1.2 13', stroke: '#4d6a34', strokeWidth: 1.4, fill: 'none', opacity: 0.9 }));
    } else {
      var ring = iCyl(o, u, v, r * 1.1, hh - 0.1, hh + 0.35, mk, { top: false });
      var ap = iCone(o, u, v, r * 1.32, hh + 0.35, opt.coneH || r * 2.6, opt.rk || 'red');
      if (opt.flag) iFlag(o, ap[0], ap[1], 10, opt.flag); else o.push(h('path', { key: o.length, d: 'M' + iF(ap[0]) + ' ' + iF(ap[1]) + 'v-3', stroke: '#3a2a1c', strokeWidth: 0.6 }));
    }
    return o;
  }
  /* ferde doboz falakhoz és pártázathoz */
  function iOBox(o, P0, P1, n, t, z0, z1, m, opt) {
    opt = opt || {};
    var hx = n[0] * t / 2, hy = n[1] * t / 2, A0 = [P0[0] + hx, P0[1] + hy], A1 = [P1[0] + hx, P1[1] + hy], B0 = [P0[0] - hx, P0[1] - hy], B1 = [P1[0] - hx, P1[1] - hy];
    var dx = P1[0] - P0[0], dy = P1[1] - P0[1], L = Math.hypot(dx, dy), d = [dx / L, dy / L];
    var faces = [[A0, A1, n], [B1, B0, [-n[0], -n[1]]]];
    if (opt.ends) { faces.push([B0, A0, [-d[0], -d[1]]]); faces.push([A1, B1, d]); }
    var out = null;
    faces.forEach(function (f) {
      var nn = f[2]; if (nn[0] + nn[1] <= 0.01) return;
      var a = f[0], b = f[1], x0 = iP(a[0], a[1], 0)[0], x1 = iP(b[0], b[1], 0)[0], l = x0 < x1 ? a : b, r = x0 < x1 ? b : a;
      var F = [[l[0], l[1], z0], [r[0], r[1], z0], [r[0], r[1], z1], [l[0], l[1], z1]], fk = Math.max(0, Math.min(1, (nn[0] - nn[1] + 1) / 2));
      iPoly(o, F, iMix(m.lit, m.shade, fk)); if (!opt.noAo) iAo(o, F);
      if (f === faces[0]) out = F; else if (!out) out = F;
    });
    if (!opt.noTop) iPoly(o, [[A0[0], A0[1], z1], [A1[0], A1[1], z1], [B1[0], B1[1], z1], [B0[0], B0[1], z1]], opt.top || iMix(m.lit, '#ffffff', 0.08));
    return out;
  }
