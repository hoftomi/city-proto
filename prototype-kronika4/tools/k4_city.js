  /* ---------- különleges épületek ---------- */
  function iShadowBox(o, u0, v0, u1, v1, H) { o.push(h('polygon', { key: o.length, points: iPts([[u1, v0, 0], [u1 + H * 0.75, v0 + H * 0.12, 0], [u1 + H * 0.75, v1 + H * 0.2, 0], [u0 + H * 0.3, v1 + H * 0.2, 0], [u0, v1, 0]]), fill: '#24190f', opacity: 0.3, filter: 'url(#kg-blur)' })); }
  function iRoundOnFace(F, sc, tc, rs, rt, n) { var a = []; for (var i = 0; i < n; i++) { var th = i / n * Math.PI * 2; a.push(iM(F, sc + rs * Math.cos(th), tc + rt * Math.sin(th))); } return a; }
  function iPalace(r, flagCol) {
    var items = [];
    items.push(iHouse([26, 31, 6, 15, 3, 'white', 'slate', 'nvc', 3.4], r, 'pwW'));
    items.push(iHouse([48, 31, 6, 15, 3, 'white', 'slate', 'nvc', 3.4], r, 'pwE'));
    var o = [], u0 = 32, v0 = 28, u1 = 48, v1 = 40, H = 9, M = MAT.white, S = MAT.stone;
    iShadowBox(o, u0, v0, u1, v1, H);
    var B = iBox(o, u0, v0, u1, v1, 0, H, M, { noTop: true });
    iPoly(o, iQ(B.L, 0, 0, 1, 0.12), S.lit, { strokeWidth: 0.25 }); iPoly(o, iQ(B.R, 0, 0, 1, 0.12), S.shade, { strokeWidth: 0.25 });
    iStone(o, iQ(B.L, 0, 0, 1, 0.12), S, 2, 12); iStone(o, iQ(B.R, 0, 0, 1, 0.12), S, 2, 9);
    var bands = []; [0.12, 0.42, 0.72, 0.985].forEach(function (t) { bands.push(iLn(iM(B.L, 0, t), iM(B.L, 1, t)) + iLn(iM(B.R, 0, t), iM(B.R, 1, t))); });
    iPathEl(o, bands.join(''), '#fffaf0', 0.9, { opacity: 0.8, strokeLinecap: 'butt' }); iPathEl(o, bands.join(''), '#a69b83', 0.3, { transform: 'translate(0 0.7)', opacity: 0.8 });
    var pil = []; for (var s = 0; s <= 8; s++) pil.push(iLn(iM(B.L, s / 8, 0.12), iM(B.L, s / 8, 0.98))); for (s = 0; s <= 6; s++) pil.push(iLn(iM(B.R, s / 6, 0.12), iM(B.R, s / 6, 0.98)));
    iPathEl(o, pil.join(''), '#d9cfb8', 0.9, { opacity: 0.7, strokeLinecap: 'butt' });
    for (var f = 0; f < 3; f++) {
      var t0 = [0.19, 0.49, 0.77][f], t1 = t0 + 0.15;
      for (var i = 0; i < 8; i++) { var sc = (i + 0.5) / 8; if (f === 0 && sc > 0.3 && sc < 0.7) continue; iWin(o, B.L, sc - 0.028, t0, sc + 0.028, t1, { arch: true, frame: '#f3ecdc', lit: r() < 0.25 }); }
      for (i = 0; i < 6; i++) { var sr = (i + 0.5) / 6; iWin(o, B.R, sr - 0.036, t0, sr + 0.036, t1, { arch: true, frame: '#f3ecdc', lit: r() < 0.2 }); }
    }
    iDoor(o, B.L, 0.46, 0.54, 0.34, '#5a3a24', true);
    iRoof(o, u0, v0, u1, v1, H, 3.6, 'hip', ROOF.slate, M, { kind: 'slate', ov: 0.5 });
    var dz = H + 2.2, drum = iCyl(o, 40, 34, 3, dz, dz + 3.2, 'white', { top: false });
    [28, 60, 90, 120, 152].forEach(function (a) { var th = a * Math.PI / 180, c = iP(40, 34, dz + 1.2), x = c[0] + drum.rx * Math.cos(th) * 0.92, y = c[1] + drum.ry * Math.sin(th); o.push(h('path', { key: o.length, d: 'M' + iF(x - 1.1) + ' ' + iF(y) + 'v-3.4a1.1 1.1 0 0 1 2.2 0v3.4z', fill: a === 90 || a === 28 ? '#f7d074' : '#35414b', stroke: '#f3ecdc', strokeWidth: 0.45 })); });
    var dc = iP(40, 34, dz + 3.2), rx = 3.2 * 1.2247 * I4.S, ry = 3.2 * 0.7071 * I4.S, hr = 3.6 * I4.S;
    o.push(h('ellipse', { key: o.length, cx: iF(dc[0]), cy: iF(dc[1]), rx: iF(rx), ry: iF(ry), fill: '#e6dcc4', stroke: I4O, strokeWidth: 0.4 }));
    o.push(h('path', { key: o.length, d: 'M' + iF(dc[0] - rx) + ' ' + iF(dc[1]) + 'A' + iF(rx) + ' ' + iF(hr) + ' 0 0 1 ' + iF(dc[0] + rx) + ' ' + iF(dc[1]) + 'A' + iF(rx) + ' ' + iF(ry) + ' 0 0 1 ' + iF(dc[0] - rx) + ' ' + iF(dc[1]) + 'Z', fill: 'url(#i4-dome)', stroke: I4O, strokeWidth: 0.5 }));
    var rib = []; [25, 55, 90, 125, 155].forEach(function (a) { var th = a * Math.PI / 180, x = dc[0] + rx * Math.cos(th), y = dc[1] + ry * Math.sin(th); rib.push('M' + iF(x) + ' ' + iF(y) + 'Q' + iF(dc[0] + rx * Math.cos(th) * 0.95) + ' ' + iF(dc[1] - hr * 0.95) + ' ' + iF(dc[0]) + ' ' + iF(dc[1] - hr)); });
    iPathEl(o, rib.join(''), '#3b6453', 0.45, { opacity: 0.7 });
    o.push(h('path', { key: o.length, d: 'M' + iF(dc[0] - rx * 0.7) + ' ' + iF(dc[1] - hr * 0.35) + 'Q' + iF(dc[0] - rx * 0.55) + ' ' + iF(dc[1] - hr * 0.85) + ' ' + iF(dc[0] - rx * 0.1) + ' ' + iF(dc[1] - hr * 0.95), stroke: '#effaf2', strokeWidth: 1, fill: 'none', opacity: 0.55 }));
    var lz = dz + 3.2 + 3.5; iCyl(o, 40, 34, 0.75, lz, lz + 1.5, 'white', {});
    var ap = iCone(o, 40, 34, 0.95, lz + 1.5, 1.6, 'copper');
    iFlag(o, ap[0], ap[1], 8, flagCol || 'var(--house-kek)');
    // oszlopcsarnok timpanonnal
    iBox(o, 34.5, 40, 45.5, 42.6, 0, 0.6, S, { top: '#e8dfca' });
    iBox(o, 34, 42.6, 46, 43.4, 0, 0.4, S, { top: '#e0d6bf' }); iBox(o, 33.5, 43.4, 46.5, 44.2, 0, 0.2, S, { top: '#d8cdb4' });
    [['var(--house-kek)', 0.33], ['var(--house-kek)', 0.64]].forEach(function (q) { iPoly(o, iQ(B.L, q[1], 0.18, q[1] + 0.03, 0.38), q[0], { strokeWidth: 0.25 }); });
    for (i = 0; i < 6; i++) iCyl(o, 35.4 + i * 1.84, 42.1, 0.34, 0.6, 6.4, 'white', { top: false });
    iBox(o, 34.5, 40, 45.5, 42.6, 6.4, 7.2, M, { noTop: true });
    iRoof(o, 34.5, 40, 45.5, 42.6, 7.2, 2.5, 'gv', ROOF.slate, M, { kind: 'slate', ov: 0.3 });
    var ped = [[34.5, 42.6, 7.2], [45.5, 42.6, 7.2], [40, 42.6, 9.7], [40, 42.6, 9.7]];
    iPathEl(o, iPath([iM(ped, 0.08, 0.1), iM(ped, 0.92, 0.1), iM(ped, 0.5, 0.82)], true), '#a69b83', 0.5);
    var cr = iP(40, 42.6, 8.1); o.push(h('circle', { key: o.length, cx: iF(cr[0]), cy: iF(cr[1]), r: 1.5, fill: 'var(--frame)', stroke: I4O, strokeWidth: 0.3 }));
    items.push({ el: h('g', { key: 'pal' }, o), depth: u1 + v1 + 3 });
    return items;
  }
  function iClock(u0, v0, key) {
    var o = [], w = 4, H = 19, M = MAT.stone;
    iShadowBox(o, u0, v0, u0 + w, v0 + w, H * 0.8);
    var B = iBox(o, u0, v0, u0 + w, v0 + w, 0, H, M, { noTop: true });
    iStone(o, B.L, M, 26, 4, 0.45); iStone(o, B.R, M, 26, 4, 0.45);
    iPathEl(o, [6.5, 12.6, 18.8].map(function (z) { return iLn([u0, v0 + w, z], [u0 + w, v0 + w, z]) + iLn([u0 + w, v0 + w, z], [u0 + w, v0, z]); }).join(''), '#fff8e8', 0.9, { opacity: 0.7 });
    [B.L, B.R].forEach(function (F) {
      iWin(o, F, 0.42, 0.14, 0.58, 0.24, { arch: true, sill: false }); iWin(o, F, 0.42, 0.42, 0.58, 0.54, { arch: true, sill: false });
      iPoly(o, iRoundOnFace(F, 0.5, 0.76, 0.34, 0.075, 18), '#f6f0e2', { strokeWidth: 0.4 });
      iPoly(o, iRoundOnFace(F, 0.5, 0.76, 0.28, 0.062, 18), 'none', { stroke: '#8c7d66', strokeWidth: 0.3 });
      iPathEl(o, iLn(iM(F, 0.5, 0.76), iM(F, 0.5, 0.815)) + iLn(iM(F, 0.5, 0.76), iM(F, 0.66, 0.765)), '#2a1e14', 0.5);
      iPoly(o, [iM(F, 0.22, 0.86), iM(F, 0.44, 0.86), iM(F, 0.44, 0.94), iM(F, 0.33, 0.97), iM(F, 0.22, 0.94)], '#1c1718', { strokeWidth: 0.25 });
      iPoly(o, [iM(F, 0.56, 0.86), iM(F, 0.78, 0.86), iM(F, 0.78, 0.94), iM(F, 0.67, 0.97), iM(F, 0.56, 0.94)], '#1c1718', { strokeWidth: 0.25 });
    });
    var bell = iP.apply(null, iM(B.L, 0.33, 0.9)); o.push(h('path', { key: o.length, d: 'M' + iF(bell[0] - 1.1) + ' ' + iF(bell[1] + 1) + 'q0-2.4 1.1-2.4t1.1 2.4z', fill: '#d8b55c' }));
    iRoof(o, u0, v0, u0 + w, v0 + w, H, 6.5, 'pyr', ROOF.slate, M, { kind: 'slate', ov: 0.45 });
    var tp = iP(u0 + w / 2, v0 + w / 2, H + 6.5); iFlag(o, tp[0], tp[1], 9, 'var(--house-kek)');
    return { el: h('g', { key: key }, o), depth: u0 + v0 + 2 * w };
  }
  function iChapel(r) {
    var o = [], u0 = 70, v0 = 72, u1 = 82, v1 = 79, H = 7.4, M = MAT.stone;
    iShadowBox(o, u0, v0, u1, v1, H);
    var B = iBox(o, u0, v0, u1, v1, 0, H, M, { noTop: true });
    iStone(o, B.L, M, 10, 12, 0.45); iStone(o, B.R, M, 10, 6, 0.45);
    for (var i = 0; i < 4; i++) { var s = (i + 0.5) / 4; iWin(o, B.L, s - 0.03, 0.2, s + 0.03, 0.66, { arch: true, frame: '#d8ccb0', sill: false }); var g = iQ(B.L, s - 0.022, 0.26, s + 0.022, 0.62); iPoly(o, g, '#5a6f9a', { strokeWidth: 0.2 }); iPoly(o, iQ(B.L, s - 0.022, 0.4, s + 0.022, 0.5), '#b5503c', { strokeWidth: 0.15 }); iPoly(o, iQ(B.L, s - 0.022, 0.52, s + 0.022, 0.6), '#d8b55c', { strokeWidth: 0.15 }); }
    for (i = 0; i < 5; i++) { var bu = u0 + 0.2 + i * 2.8; iBox(o, bu, v1, bu + 0.7, v1 + 0.9, 0, 5.4, M, {}); iRoof(o, bu, v1, bu + 0.7, v1 + 0.9, 5.4, 0.8, 'gu', ROOF.slate, M, { ov: 0.05, kind: 'slate' }); }
    iRoof(o, u0, v0, u1, v1, H, 6, 'gu', ROOF.red, M, { kind: 'tile', ov: 0.5 });
    var items = [{ el: h('g', { key: 'nave' }, o), depth: u1 + v1 }];
    var t = [], tu = 82, tv = 72, tw = 4.2, TH = 15.5;
    iShadowBox(t, tu, tv, tu + tw, tv + tw, TH * 0.8);
    var T = iBox(t, tu, tv, tu + tw, tv + tw, 0, TH, M, { noTop: true });
    iStone(t, T.L, M, 22, 4, 0.45); iStone(t, T.R, M, 22, 4, 0.45);
    iDoor(t, T.L, 0.32, 0.68, 0.17, '#5a3a24', true);
    iPoly(t, iRoundOnFace(T.L, 0.5, 0.36, 0.26, 0.06, 16), '#5a6f9a'); iPoly(t, iRoundOnFace(T.L, 0.5, 0.36, 0.13, 0.03, 12), '#d8b55c', { strokeWidth: 0.2 });
    [T.L, T.R].forEach(function (F) { iWin(t, F, 0.4, 0.55, 0.6, 0.66, { arch: true, sill: false }); iPoly(t, [iM(F, 0.28, 0.8), iM(F, 0.72, 0.8), iM(F, 0.72, 0.92), iM(F, 0.5, 0.97), iM(F, 0.28, 0.92)], '#1c1718', { strokeWidth: 0.25 }); });
    iRoof(t, tu, tv, tu + tw, tv + tw, TH, 8.5, 'pyr', ROOF.slate, M, { kind: 'slate', ov: 0.4 });
    var ap = iP(tu + tw / 2, tv + tw / 2, TH + 8.5);
    t.push(h('path', { key: t.length, d: 'M' + iF(ap[0]) + ' ' + iF(ap[1]) + 'v-6M' + iF(ap[0] - 1.6) + ' ' + iF(ap[1] - 4.2) + 'h3.2', stroke: '#d8b55c', strokeWidth: 0.8 }));
    items.push({ el: h('g', { key: 'ctw' }, t), depth: tu + tv + 2 * tw + 0.5 });
    return items;
  }
  function iMarketHall(u0, v0, u1, v1, key, r) {
    var o = [], H = 3.4, W = MAT.wood;
    iShadowBox(o, u0, v0, u1, v1, 4);
    iBox(o, u0, v0, u1, v1, 0, 0.3, MAT.stone, { top: '#d8ccb0' });
    var posts = [];
    for (var u = u0; u <= u1 + 0.01; u += (u1 - u0) / 4) { posts.push([u, v0]); posts.push([u, v1]); }
    for (var v = v0 + (v1 - v0) / 3; v < v1 - 0.01; v += (v1 - v0) / 3) { posts.push([u0, v]); posts.push([u1, v]); }
    posts.sort(function (a, b) { return (a[0] + a[1]) - (b[0] + b[1]); });
    var back = posts.filter(function (p) { return p[1] === v0 || p[0] === u0; }), front = posts.filter(function (p) { return !(p[1] === v0 || p[0] === u0); });
    back.forEach(function (p) { iBox(o, p[0] - 0.25, p[1] - 0.25, p[0] + 0.25, p[1] + 0.25, 0.3, H, W, { noTop: true }); });
    for (var i = 0; i < 7; i++) { var gp = iP(u0 + 1.2 + (i % 4) * 2.2, v0 + 1.6 + Math.floor(i / 4) * 3, 0.3); o.push(h('g', { key: o.length }, i % 3 ? kCrate(gp[0] - 1.7, gp[1], 'c') : kBarrel(gp[0] - 1.5, gp[1], 'b'))); }
    for (i = 0; i < 5; i++) { var sp = iP(u0 + 2 + i * 1.6, v1 - 1, 0.3); o.push(h('ellipse', { key: o.length, cx: iF(sp[0]), cy: iF(sp[1] - 1.2), rx: 1.5, ry: 1.3, fill: '#d8c8a0', stroke: I4O, strokeWidth: 0.3 })); }
    front.forEach(function (p) { iBox(o, p[0] - 0.25, p[1] - 0.25, p[0] + 0.25, p[1] + 0.25, 0.3, H, W, { noTop: true }); });
    iBox(o, u0 - 0.25, v1 - 0.3, u1 + 0.25, v1 + 0.25, H - 0.5, H, W, { noTop: true }); iBox(o, u1 - 0.3, v0 - 0.25, u1 + 0.25, v1 + 0.25, H - 0.5, H, W, { noTop: true });
    iRoof(o, u0, v0, u1, v1, H, 3.6, 'gu', ROOF.red, W, { kind: 'tile', ov: 0.8 });
    return { el: h('g', { key: key }, o), depth: u1 + v1 + 1 };
  }
  function iBarn(u0, v0, w, d, key, r) {
    var o = [], H = 4.2, M = MAT.barn, u1 = u0 + w, v1 = v0 + d;
    iShadowBox(o, u0, v0, u1, v1, H);
    var B = iBox(o, u0, v0, u1, v1, 0, H, M, { noTop: true });
    iPlanks(o, B.L, Math.round(w / 0.45), M.line); iPlanks(o, B.R, Math.round(d / 0.45), M.line);
    iPoly(o, iQ(B.L, 0, 0, 1, 0.1), MAT.stone.lit, { strokeWidth: 0.2 }); iPoly(o, iQ(B.R, 0, 0, 1, 0.1), MAT.stone.shade, { strokeWidth: 0.2 });
    var DF = iQ(B.L, 0.3, 0, 0.7, 0.72); iPoly(o, DF, '#6e2c1e', { strokeWidth: 0.3 });
    iPathEl(o, iPath([DF[0], DF[2]]) + iPath([DF[1], DF[3]]) + iLn(iM(DF, 0.5, 0), iM(DF, 0.5, 1)) + iPath([DF[0], DF[1], DF[2], DF[3]], true), '#f1e8d4', 0.55, { strokeLinecap: 'butt' });
    iWin(o, B.R, 0.3, 0.45, 0.42, 0.7, { shutter: '#6e4a2c' }); iWin(o, B.R, 0.62, 0.45, 0.74, 0.7, { shutter: '#6e4a2c' });
    iRoof(o, u0, v0, u1, v1, H, 4.4, 'gv', ROOF.thatch, M, { kind: 'thatch', ov: 0.6 });
    var G = [[u0, v1, H], [u1, v1, H], [u0 + w / 2, v1, H + 4.4], [u0 + w / 2, v1, H + 4.4]];
    iPoly(o, iQ(G, 0.4, 0.15, 0.6, 0.5), '#3a2a1c', { strokeWidth: 0.3 });
    iPathEl(o, iLn(iM(G, 0.4, 0.3), iM(G, 0.6, 0.3)), '#d8bd78', 1.2, { opacity: 0.9 });
    return { el: h('g', { key: key }, o), depth: u1 + v1 };
  }
  function iWindmill(u, v, key, r) {
    var o = [];
    o.push(h('ellipse', { key: o.length, cx: iF(iP(u, v)[0] + 12), cy: iF(iP(u, v)[1] + 3), rx: 16, ry: 5, fill: '#1f2a14', opacity: 0.3, filter: 'url(#kg-blur)' }));
    iCyl(o, u, v, 2.3, 0, 1.2, 'stone', { courses: true, top: false });
    iCyl(o, u, v, 1.9, 1.2, 8.2, 'white', { top: false });
    var c = iP(u, v, 1.2); o.push(h('path', { key: o.length, d: 'M' + iF(c[0] - 1.2) + ' ' + iF(c[1] + 4.6) + 'v-4.2a1.2 1.2 0 0 1 2.4 0v4.2z', fill: '#5b3d27', stroke: I4O, strokeWidth: 0.3 }));
    var c2 = iP(u, v, 5.2); o.push(h('rect', { key: o.length, x: iF(c2[0] + 1.4), y: iF(c2[1] + 3), width: 1.6, height: 2.2, fill: '#35414b', stroke: '#e6dac0', strokeWidth: 0.4 }));
    iCyl(o, u, v, 2.05, 8.1, 8.6, 'wood', { top: false });
    iCone(o, u, v, 2.3, 8.6, 3.2, 'brown');
    var hub = iP(u + 1.6, v + 1.6, 9.2), bl = [];
    for (var i = 0; i < 4; i++) bl.push(h('g', { key: i, transform: 'rotate(' + (18 + i * 90) + ')' }, h('path', { d: 'M0 0v-19', stroke: '#5b3d27', strokeWidth: 0.9 }), h('rect', { x: 0.4, y: -19, width: 4, height: 14, fill: '#f3ead3', stroke: I4O, strokeWidth: 0.35 }), h('path', { d: 'M.4-15.5h4M.4-12h4M.4-8.5h4M2.4-19v14', stroke: '#a88a5a', strokeWidth: 0.35 })));
    o.push(h('g', { key: o.length, transform: 'translate(' + iF(hub[0]) + ' ' + iF(hub[1]) + ') scale(1 0.92)' }, bl, h('circle', { r: 1.3, fill: '#5b3d27', stroke: I4O, strokeWidth: 0.3 })));
    return { el: h('g', { key: key }, o), depth: u + v + 2 };
  }
  function iRock(u, v, rad, hgt, seed, key, opt) {
    opt = opt || {};
    var r = rng(seed), n = 9, base = [], top = [], o = [], M = MAT.rock, i, z0 = opt.z0 || 0;
    for (i = 0; i < n; i++) { var a = i / n * Math.PI * 2 + r() * 0.35, rr = rad * (0.62 + r() * 0.6), k = 0.45 + r() * 0.35; base.push([u + Math.cos(a) * rr, v + Math.sin(a) * rr, z0]); top.push([u + Math.cos(a) * rr * k + (r() - 0.5) * rad * 0.2, v + Math.sin(a) * rr * k + (r() - 0.5) * rad * 0.2, z0 + hgt * (0.55 + r() * 0.6)]); }
    o.push(h('polygon', { key: o.length, points: iPts(base.map(function (q) { return [q[0] + hgt * 0.55, q[1] + hgt * 0.18, z0]; })), fill: '#24190f', opacity: 0.32, filter: 'url(#kg-blur)' }));
    var faces = [];
    for (i = 0; i < n; i++) { var j = (i + 1) % n, q = [base[i], base[j], top[j], top[i]], nn = iNorm(base[i], base[j], top[i]); if ((base[i][0] - u) * nn[0] + (base[i][1] - v) * nn[1] < 0) nn = [-nn[0], -nn[1], -nn[2]]; faces.push({ q: q, n: nn, d: base[i][0] + base[i][1] + base[j][0] + base[j][1] }); }
    faces.sort(function (a, b) { return a.d - b.d; });
    faces.forEach(function (f) {
      if (f.n[0] + f.n[1] + f.n[2] <= 0) return;
      var fc = iLight(f.n, opt.warm ? '#e6d0a8' : '#dccfb4', '#6a5a48'); iPoly(o, f.q, fc, { stroke: fc, strokeWidth: 0.4 }); iPathEl(o, iLn(f.q[0], f.q[3]), '#3a2e22', 0.35, { opacity: 0.35 });
      var st = []; for (var t = 0.18; t < 0.95; t += 0.16 + r() * 0.08) st.push(iLn(iM(f.q, 0, t + (r() - 0.5) * 0.05), iM(f.q, 1, t + (r() - 0.5) * 0.05)));
      iPathEl(o, st.join(''), '#5a4a38', 0.35, { opacity: 0.45 });
      if (r() < 0.6) iPathEl(o, iLn(iM(f.q, 0.3 + r() * 0.4, 0.05), iM(f.q, 0.3 + r() * 0.4, 0.6 + r() * 0.3)), '#4a3c2e', 0.5, { opacity: 0.6 });
      iAo(o, f.q);
      if (opt.snow) { var j1 = 0.62 + r() * 0.12, j2 = 0.5 + r() * 0.14, j3 = 0.6 + r() * 0.12; iPoly(o, [iM(f.q, 0, j1), iM(f.q, 0.35, j2), iM(f.q, 0.6, j3 - 0.06), iM(f.q, 1, j3), f.q[2], f.q[3]], iLight(f.n, '#ffffff', '#aebfcc'), { strokeWidth: 0.3, strokeOpacity: 0.5 }); }
    });
    var cz = [u + (r() - 0.5) * rad * 0.3, v + (r() - 0.5) * rad * 0.3, z0 + hgt * (0.95 + r() * 0.25)];
    for (i = 0; i < n; i++) { var jj = (i + 1) % n, tri = [top[i], top[jj], cz], tn = iNorm(top[i], top[jj], cz); if (tn[2] < 0) tn = [-tn[0], -tn[1], -tn[2]]; var g = opt.grass && r() < 0.75, tc0 = opt.snow ? iLight(tn, '#ffffff', '#b8c8d6') : g ? iMix(iLight(tn, '#b0c674', '#5f7a3a'), '#8fa65c', 0.4) : iMix(iLight(tn, '#eadcbc', '#8a7760'), '#c2b294', 0.45); iPoly(o, tri, tc0, { stroke: tc0, strokeWidth: 0.4 }); }
    iPathEl(o, iPath(top, true), '#3a2e22', 0.4, { opacity: 0.4 });
    if (opt.grass) for (i = 0; i < 4; i++) { var bp = iP(cz[0] + (r() - 0.5) * rad * 0.8, cz[1] + (r() - 0.5) * rad * 0.8, cz[2] - hgt * 0.1); o.push(h('circle', { key: o.length, cx: iF(bp[0]), cy: iF(bp[1]), r: iF(1.4 + r()), fill: 'url(#i4-tree2)', stroke: '#1f3319', strokeWidth: 0.25 })); }
    if (!z0) for (i = 0; i < 6; i++) { var ang = Math.PI * (0.1 + r() * 0.5), rp = rad * (1 + r() * 0.35), bu = u + Math.cos(ang) * rp, bv = v + Math.sin(ang) * rp, s = 0.35 + r() * 0.5; iPoly(o, [[bu - s, bv, 0], [bu, bv - s, 0], [bu + s * 0.3, bv - s * 0.2, s * 1.1], [bu - s * 0.4, bv + s * 0.1, s]], '#b7a384', { strokeWidth: 0.3 }); iPoly(o, [[bu + s, bv, 0], [bu, bv + s, 0], [bu - s * 0.4, bv + s * 0.1, s], [bu + s * 0.3, bv - s * 0.2, s * 1.1]], '#7c6a53', { strokeWidth: 0.3 }); }
    return { el: h('g', { key: key }, o), depth: u + v + rad * 0.7 + z0 * 0.1, top: iP(u, v, hgt) };
  }
  /* városfal elemei */
  function iWallPiece(P0, P1, n, key, opt) {
    opt = opt || {};
    var o = [], M = MAT[opt.mat || 'stone'], H = opt.H || 6.4, t = opt.t || 2.2, k = t / 2.2;
    var F = iOBox(o, P0, P1, n, t, 0, H, M, { noAo: false, top: '#b9ab8f' });
    if (F) { iStone(o, F, M, 9, 3, 0.5); }
    var dx = P1[0] - P0[0], dy = P1[1] - P0[1], L = Math.hypot(dx, dy), d = [dx / L, dy / L];
    for (var s = 0.35 * k; s < L - 0.5 * k; s += 1.55 * k) {
      var a = [P0[0] + d[0] * s + n[0] * 0.8 * k, P0[1] + d[1] * s + n[1] * 0.8 * k], b = [a[0] + d[0] * 0.85 * k, a[1] + d[1] * 0.85 * k];
      iOBox(o, a, b, n, 0.6 * k, H, H + 1.1 * k, M, { ends: true, noAo: true, top: '#cfc2a6' });
    }
    return { el: h('g', { key: key }, o), depth: (P0[0] + P1[0] + P0[1] + P1[1]) / 2 + (n[0] + n[1]) * 1.1 };
  }
  function iGate(u, v, alongU, outer, key, flagCol) {
    var o = [], M = MAT.stone, H = 10.5, a = alongU ? 5 : 2.8, b = alongU ? 2.8 : 5, u0 = u - a, u1 = u + a, v0 = v - b, v1 = v + b;
    iShadowBox(o, u0, v0, u1, v1, H * 0.7);
    var B = iBox(o, u0, v0, u1, v1, 0, H, M, { noTop: true });
    iStone(o, B.L, M, 14, alongU ? 8 : 5, 0.5); iStone(o, B.R, M, 14, alongU ? 5 : 8, 0.5);
    var F = alongU ? B.L : B.R;
    var ar = [iM(F, 0.33, 0), iM(F, 0.67, 0), iM(F, 0.67, 0.36), iM(F, 0.6, 0.45), iM(F, 0.5, 0.48), iM(F, 0.4, 0.45), iM(F, 0.33, 0.36)];
    iPoly(o, [iM(F, 0.29, 0), iM(F, 0.71, 0), iM(F, 0.71, 0.38), iM(F, 0.62, 0.5), iM(F, 0.5, 0.53), iM(F, 0.38, 0.5), iM(F, 0.29, 0.38)], '#cfc2a6', { strokeWidth: 0.3 });
    iPoly(o, ar, '#171214', { strokeWidth: 0.3 });
    var pc = []; for (var i = 1; i < 6; i++) pc.push(iLn(iM(F, 0.33 + i * 0.057, 0.12), iM(F, 0.33 + i * 0.057, 0.44))); for (i = 1; i < 4; i++) pc.push(iLn(iM(F, 0.33, 0.12 + i * 0.09), iM(F, 0.67, 0.12 + i * 0.09)));
    iPathEl(o, pc.join(''), '#5e5a54', 0.45, { strokeLinecap: 'butt' });
    iPoly(o, iQ(F, 0.44, 0.6, 0.56, 0.72), 'var(--house-voros)', { strokeWidth: 0.3 });
    [0.15, 0.85].forEach(function (s) { iWin(o, F, s - 0.03, 0.64, s + 0.03, 0.8, { dark: true, sill: false, frame: '#b9ab8f' }); });
    iPoly(o, [[u0, v0, H], [u1, v0, H], [u1, v1, H], [u0, v1, H]], '#a89a80');
    for (var q = u0 + 0.3; q < u1 - 0.3; q += 1.5) { iBox(o, q, v0, q + 0.8, v0 + 0.55, H, H + 1.1, M, { noAo: true }); }
    for (q = v0 + 0.3; q < v1 - 0.3; q += 1.5) { iBox(o, u0, q, u0 + 0.55, q + 0.8, H, H + 1.1, M, { noAo: true }); }
    for (q = u0 + 0.3; q < u1 - 0.3; q += 1.5) { iBox(o, q, v1 - 0.55, q + 0.8, v1, H, H + 1.1, M, { noAo: true }); }
    for (q = v0 + 0.3; q < v1 - 0.3; q += 1.5) { iBox(o, u1 - 0.55, q, u1, q + 0.8, H, H + 1.1, M, { noAo: true }); }
    var turrets = alongU ? [[u0, v1], [u1, v1]] : [[u1, v0], [u1, v1]];
    if (!outer) turrets = alongU ? [[u0, v1], [u1, v1]] : [[u1, v0], [u1, v1]];
    turrets.forEach(function (tq) { var tt = iRTower(tq[0], tq[1], 1.4, H + 2.6, { roof: 'cone', rk: 'red', coneH: 4.2 }); o.push(h('g', { key: o.length }, tt)); });
    var tp = iP(u, v, H + 1.1); iFlag(o, tp[0], tp[1], 10, flagCol || 'var(--house-voros)');
    return { el: h('g', { key: key }, o), depth: u + v + a + b };
  }
  /* ---------- városkép ---------- */
  var I4D = { nemesseg: { poly: [[22, 22], [60, 22], [60, 60], [22, 60]], name: 'Városháza', label: [40, 57], flag: [40, 34, 22] },
    kereskedok: { poly: [[60, 22], [98, 22], [98, 98], [60, 98], [60, 60]], name: 'Vásártér', label: [80, 47], flag: [73, 41, 9] },
    katonasag: { poly: [[22, 60], [60, 60], [60, 98], [22, 98]], name: 'Alvilág', label: [39, 83], flag: [36, 69, 11] } };
  var I4H = {
    nemesseg: [[25, 48, 6, 7, 3, 'white', 'slate', 'nbdc'], [25, 24.5, 5, 5, 2, 'stone', 'slate', 'hc']],
    kereskedok: [[65, 25, 12, 7, 3, 'ochre', 'red', 'dcgn'], [79, 25, 6, 6, 3, 'rose', 'red', 'jtdc'], [87, 25, 7, 6, 2, 'plaster', 'brown', 'tcf'],
      [64, 51, 6, 5, 3, 'rose', 'red', 'jsgc'], [71, 51, 5, 5, 2, 'ochre', 'brown', 'tscf'], [77, 51, 6, 5, 3, 'white', 'teal', 'jsdc'], [84, 51, 5, 5, 2, 'plaster', 'red', 'tsgc'], [90, 51, 5.5, 5, 3, 'ochre', 'red', 'jdcf'],
      [64, 63, 6, 5, 2, 'plaster', 'red', 'tcf'], [72, 63, 7, 5, 2, 'rose', 'teal', 'jtdc'], [80, 63, 6, 5, 2, 'ochre', 'red', 'tsc'], [88, 63, 7, 6, 2, 'stone', 'brown', 'cg'],
      [64, 82, 6, 6, 2, 'rose', 'red', 'jsc'], [64, 90, 6, 5.5, 3, 'white', 'brown', 'jdcf'], [73, 84, 6, 6, 2, 'plaster', 'teal', 'tcf'], [81, 84, 6, 6, 2, 'ochre', 'red', 'jc'],
      [89, 72, 6, 6, 2, 'plaster', 'red', 'tc'], [89, 82, 6, 6, 2, 'rose', 'brown', 'tsc'], [74, 91, 7, 4.5, 2, 'ochre', 'thatch', 'tc']],
    katonasag: [[30, 65, 12, 8, 2, 'plaster', 'dark', 'jtglcd'], [24.5, 75, 6, 6, 2, 'dark', 'moss', 'tkc'], [44, 64, 6, 6, 2, 'grey', 'dark', 'kcl'], [44, 74, 6, 6, 2, 'wood', 'dark', 'tk'],
      [32, 77, 6, 6, 2, 'grey', 'moss', 'kbcl'], [26, 85, 6, 6, 1, 'dark', 'thatch', 'k'], [38, 86, 6, 6, 2, 'dark', 'dark', 'tkl'], [47, 85, 6, 6, 2, 'grey', 'brown', 'kc'], [51, 75, 5, 5, 1, 'wood', 'dark', 'k']]
  };
  function CityView(p) {
    var d = p.districts || {}, sel = p.selected, stab = p.stability, name = p.name || 'varos', coast = !!p.coast;
    var r = rng('k4' + name), pr = rng('k4p' + name), tr = rng('k4t' + name), i, j;
    var gid = useUid('g'), vid = useUid('v'), G = [], Dl = [];
    function add(x) { Dl.push([x.depth, x.el]); }
    function tree(u, v, s, kind) { var q = iP(u, v); Dl.push([u + v, iTree(q[0], q[1], s, kind, 't' + Dl.length, tr)]); }
    function fig(u, v, c, hood) { var q = iP(u, v); Dl.push([u + v, iFig(q[0], q[1], c, 'f' + Dl.length, hood, pr)]); }
    function strip(u0, v0, u1, v1, fill, k) { return h('polygon', { key: k, points: iPts([[u0, v0], [u1, v0], [u1, v1], [u0, v1]]), fill: fill }); }
    function dom(k) { return d[k] || {}; }
    // --- talaj ---
    G.push(h('rect', { key: 'bg', width: 720, height: 540, fill: 'url(#' + gid + ')' }));
    G.push(h('g', { key: 'patch', filter: 'url(#kg-blur-lg)', opacity: 0.7 }, groundPatches('k4g' + name, 720, 540, 80),
      [[140, 120, 90, 40, '#6f8f3e'], [560, 420, 110, 50, '#6f8f3e'], [120, 420, 80, 40, '#b7c77a'], [470, 90, 70, 30, '#b7c77a'], [300, 480, 120, 40, '#7d9a48']].map(function (q, n) { return h('ellipse', { key: 'e' + n, cx: q[0], cy: q[1], rx: q[2], ry: q[3], fill: q[4], opacity: 0.45 }); })));
    G.push(h('path', { key: 'hills', d: 'M0 70C60 40 110 58 170 36C230 16 280 44 340 28C400 12 450 40 520 22C590 6 650 30 720 18V0H0Z', fill: '#9fb49a', opacity: 0.85 }));
    G.push(h('path', { key: 'hills2', d: 'M0 86C70 66 120 80 190 60C250 44 300 66 360 52C430 36 480 60 540 46C610 32 660 52 720 40V0H0Z', fill: '#86a36c', opacity: 0.6 }));
    G.push(h('g', { key: 'farf', filter: 'url(#kg-blur)', opacity: 0.8 }, Array.from({ length: 70 }, function (_, n) { var x = n * 10.5 + tr() * 6, y = 52 + Math.sin(n * 0.7) * 10 + tr() * 8; return h('circle', { key: n, cx: iF(x), cy: iF(y), r: iF(5 + tr() * 4), fill: n % 3 ? '#5f7d44' : '#4d6a38' }); })));
    G.push(h('rect', { key: 'haze', width: 720, height: 110, fill: 'url(#i4-haze)' }));
    G.push(h('path', { key: 'tuft', d: tufts('k4t' + name, 720, 540, 650), stroke: 'var(--map-tuft)', strokeWidth: 0.5, fill: 'none', strokeLinecap: 'round', opacity: 0.35 }));
    G.push(h('g', { key: 'fl' }, flowers('k4f' + name, 720, 540, 110)));
    (function () { var a = [], b = [], c = []; for (var q = 0; q < 2400; q++) { var x = tr() * 720, y = 60 + tr() * 480, l = 1 + tr() * 1.6, dx = (tr() - 0.5) * 1.2; (q % 3 === 0 ? a : q % 3 === 1 ? b : c).push('M' + iF(x) + ' ' + iF(y) + 'l' + iF(dx) + ' -' + iF(l)); }
      G.push(h('path', { key: 'gr1', d: a.join(''), stroke: '#5f7d3a', strokeWidth: 0.45, opacity: 0.5, strokeLinecap: 'round' }));
      G.push(h('path', { key: 'gr2', d: b.join(''), stroke: '#c9d98f', strokeWidth: 0.45, opacity: 0.45, strokeLinecap: 'round' }));
      G.push(h('path', { key: 'gr3', d: c.join(''), stroke: '#7f9c4a', strokeWidth: 0.5, opacity: 0.45, strokeLinecap: 'round' })); })();
    // mezők
    var FIELDS = [[-34, 4, -22, 18, 0, 1], [-20, 4, -8, 18, 1, 0], [-6, 6, 6, 18, 3, 1], [-34, 20, -22, 34, 2, 0], [-20, 20, -8, 34, 0, 1], [-6, 20, 6, 34, 4, 0], [-34, 36, -22, 52, 1, 1], [-20, 36, -8, 52, 5, 0],
      [22, 112, 34, 124, 0, 1], [36, 112, 48, 124, 2, 0], [22, 126, 34, 140, 4, 1], [36, 126, 48, 140, 0, 0], [8, 112, 20, 126, 1, 1],
      [112, 72, 124, 84, 0, 1], [112, 86, 124, 98, 3, 0], [126, 72, 138, 86, 1, 1], [70, 112, 80, 122, 4, 1], [82, 112, 92, 122, 1, 0], [104, 30, 114, 42, 0, 0], [-30, 70, -18, 82, 3, 1], [96, 108, 108, 118, 5, 1]];
    FIELDS.forEach(function (f, n) { G.push(iField(f[0], f[1], f[2], f[3], f[4], !!f[5], 'fd' + n, tr)); });
    G.push(h('polygon', { key: 'past', points: iPts([[-2, 68], [13, 68], [13, 90], [-2, 90]]), fill: '#a6c070', opacity: 0.9 }));
    G.push(h('ellipse', { key: 'pond', cx: iF(iP(6, 84)[0]), cy: iF(iP(6, 84)[1]), rx: 14, ry: 6, fill: 'url(#kg-water)', stroke: '#6b8a5a', strokeWidth: 1.2 }));
    G.push(iFence([[-2, 68], [13, 68], [13, 90], [-2, 90], [-2, 68]], 'pf'));
    G.push(iFence([[-34, 4], [6, 4]], 'f2'));
    // utak
    var ROADS = [[57.8, 98, 62.2, 170], [98, 57.8, 175, 62.2], [57.8, -40, 62.2, 22], [-60, 57.8, 22, 62.2], [-6, 62.2, -2, 84]];
    ROADS.forEach(function (q, n) { G.push(h('polygon', { key: 'rde' + n, points: iPts([[q[0] - 0.6, q[1] - 0.6], [q[2] + 0.6, q[1] - 0.6], [q[2] + 0.6, q[3] + 0.6], [q[0] - 0.6, q[3] + 0.6]]), fill: '#8f7a52', opacity: 0.5, filter: 'url(#kg-blur)' })); G.push(strip(q[0], q[1], q[2], q[3], 'url(#i4-road)', 'rd' + n));
      var rut = q[2] - q[0] > q[3] - q[1] ? iLn([q[0], q[1] + 1.4], [q[2], q[1] + 1.4]) + iLn([q[0], q[3] - 1.4], [q[2], q[3] - 1.4]) : iLn([q[0] + 1.4, q[1]], [q[0] + 1.4, q[3]]) + iLn([q[2] - 1.4, q[1]], [q[2] - 1.4, q[3]]);
      G.push(h('path', { key: 'rt' + n, d: rut, stroke: '#a08a5e', strokeWidth: 0.9, opacity: 0.6 })); });
    // folyó vagy tenger
    var river = coast ? 'M735 170C690 200 650 230 655 290C658 318 672 336 700 352' : 'M735 170C690 200 650 230 655 290C660 350 638 410 625 449C614 485 600 515 590 560';
    G.push(h('path', { key: 'rv0', d: river, stroke: '#8f7a52', strokeWidth: 34, fill: 'none', opacity: 0.45, filter: 'url(#kg-blur)' }));
    G.push(h('path', { key: 'rv1', d: river, stroke: '#c9b88a', strokeWidth: 28, fill: 'none', strokeLinecap: 'round' }));
    G.push(h('path', { key: 'rv2', d: river, stroke: '#4f8a9c', strokeWidth: 22, fill: 'none' }));
    G.push(h('path', { key: 'rv3', d: river, stroke: '#78aebd', strokeWidth: 15, fill: 'none' }));
    G.push(h('path', { key: 'rv4', d: river, stroke: '#a9d0d6', strokeWidth: 5, fill: 'none', opacity: 0.6, transform: 'translate(-3 0)' }));
    G.push(h('path', { key: 'rv5', d: river, stroke: '#e8f4f2', strokeWidth: 0.9, fill: 'none', strokeDasharray: '6 11', opacity: 0.9 }));
    if (coast) {
      var sea = 'M720 318C672 360 640 420 622 468C610 500 602 522 596 540H720Z';
      G.push(h('path', { key: 'sb', d: sea, fill: 'none', stroke: '#d8c89a', strokeWidth: 16 }));
      G.push(h('path', { key: 'sea', d: sea, fill: '#3f7488' }));
      G.push(h('path', { key: 'sea2', d: 'M720 330C680 368 652 424 636 470C626 500 618 522 614 540', fill: 'none', stroke: '#6fa3b3', strokeWidth: 22, opacity: 0.8 }));
      G.push(h('path', { key: 'sea3', d: sea, fill: 'none', stroke: '#e8f4f2', strokeWidth: 1.2, strokeDasharray: '10 6', opacity: 0.8 }));
      var wv = []; for (i = 0; i < 40; i++) { var wx = 640 + tr() * 80, wy = 380 + tr() * 160; if (wx > 660 - (wy - 380) * -0.1) wv.push('M' + iF(wx) + ' ' + iF(wy) + 'q2-1.6 4 0'); }
      G.push(h('path', { key: 'wv', d: wv.join(''), stroke: '#cfe6ea', strokeWidth: 0.6, fill: 'none', opacity: 0.6 }));
    }
    // vizesárok és városi talaj
    var ring = iPath([[15.5, 15.5], [104.5, 15.5], [104.5, 104.5], [15.5, 104.5]], true) + iPath([[20, 20], [20, 100], [100, 100], [100, 20]], true);
    G.push(h('path', { key: 'mb', d: ring, fill: '#8f7a52', fillRule: 'evenodd', opacity: 0.55, filter: 'url(#kg-blur)' }));
    G.push(h('path', { key: 'mo', d: iPath([[16.2, 16.2], [103.8, 16.2], [103.8, 103.8], [16.2, 103.8]], true) + iPath([[20, 20], [20, 100], [100, 100], [100, 20]], true), fill: 'url(#kg-water)', fillRule: 'evenodd' }));
    G.push(h('path', { key: 'mol', d: iPath([[17.4, 102.6], [102.6, 102.6], [102.6, 17.4]]), stroke: '#e8f4f2', strokeWidth: 0.8, fill: 'none', strokeDasharray: '7 9', opacity: 0.7 }));
    G.push(h('polygon', { key: 'cg', points: iPts([[20, 20], [100, 20], [100, 100], [20, 100]]), fill: '#c9b48a' }));
    G.push(h('g', { key: 'cgp', filter: 'url(#kg-blur)', opacity: 0.5 }, Array.from({ length: 40 }, function (_, n) { var q = iP(24 + tr() * 72, 24 + tr() * 72); return h('ellipse', { key: n, cx: iF(q[0]), cy: iF(q[1]), rx: iF(8 + tr() * 14), ry: iF(4 + tr() * 6), fill: n % 2 ? '#b39d74' : '#d8c59c' }); })));
    // utcák, terek
    function cobble(u0, v0, u1, v1, k, col) {
      var c = []; for (var a = Math.ceil(u0); a < u1; a += 0.9) c.push(iLn([a, v0], [a, v1])); for (var b = Math.ceil(v0); b < v1; b += 0.9) c.push(iLn([u0, b], [u1, b]));
      return h('g', { key: k }, strip(u0, v0, u1, v1, col || '#d6c7a4', 'a'), h('path', { d: c.join(''), stroke: '#a8966e', strokeWidth: 0.3, opacity: 0.55 }), strip(u0, v0, u1, v1, 'url(#i4-ao)', 'b'));
    }
    G.push(cobble(57, 20, 63, 100, 'st1')); G.push(cobble(20, 57, 100, 63, 'st2'));
    G.push(cobble(52, 52, 68, 68, 'plz', '#dccfae'));
    G.push(cobble(32, 40, 48, 56.5, 'fc', '#e2d7bb'));
    G.push(cobble(64, 33, 94, 50, 'mk', '#d9cba8'));
    G.push(h('g', { key: 'alv' }, strip(42.5, 63, 44, 96, '#9d8a6a', 'a1'), strip(24, 73.5, 57, 75, '#9d8a6a', 'a2'), strip(30, 83.5, 57, 85, '#9d8a6a', 'a3'), strip(36.5, 73, 38, 96, '#9d8a6a', 'a4')));
    G.push(h('g', { key: 'lanes' }, strip(63, 69.5, 96, 71, '#cdbb95', 'l1'), strip(70, 80, 96, 83.5, '#cdbb95', 'l2'), strip(86.5, 63, 88, 96, '#cdbb95', 'l3')));
    // díszkert a palota előtt
    [[33, 45, 38.8, 54.5], [41.2, 45, 47, 54.5]].forEach(function (q, n) {
      G.push(strip(q[0], q[1], q[2], q[3], '#86a656', 'pt' + n));
      G.push(h('path', { key: 'ph' + n, d: iPath([[q[0] + 0.4, q[1] + 0.4], [q[2] - 0.4, q[1] + 0.4], [q[2] - 0.4, q[3] - 0.4], [q[0] + 0.4, q[3] - 0.4]], true) + iLn([(q[0] + q[2]) / 2, q[1] + 0.4], [(q[0] + q[2]) / 2, q[3] - 0.4]) + iLn([q[0] + 0.4, (q[1] + q[3]) / 2], [q[2] - 0.4, (q[1] + q[3]) / 2]), stroke: '#3d5e2c', strokeWidth: 1.6, fill: 'none', strokeLinejoin: 'round' }));
      for (var fl = 0; fl < 14; fl++) { var fq = iP(q[0] + 0.8 + tr() * (q[2] - q[0] - 1.6), q[1] + 0.8 + tr() * (q[3] - q[1] - 1.6)); G.push(h('circle', { key: 'pf' + n + fl, cx: iF(fq[0]), cy: iF(fq[1]), r: 0.7, fill: ['#c0503a', '#e8dcc0', '#d9a441'][fl % 3] })); }
    });
    // kertek
    [[74, 79.5, 80, 83.5], [82, 79.5, 88, 83.5], [26, 92, 34, 96], [90, 90, 96, 96], [70, 74, 70, 74]].forEach(function (q, n) { if (q[2] > q[0]) G.push(iField(q[0], q[1], q[2], q[3], 4, n % 2 === 0, 'gd' + n, tr)); });
    G.push(h('ellipse', { key: 'quarry', cx: iF(iP(60, -16)[0]), cy: iF(iP(60, -16)[1]), rx: 70, ry: 30, fill: '#b9a27a', opacity: 0.55, filter: 'url(#kg-blur-lg)' }));
    G.push(h('polygon', { key: 'alvg', points: iPts([[20, 60], [57, 60], [57, 100], [20, 100]]), fill: '#2a2230', opacity: 0.42 }));
    // kijelölés a talajon
    if (sel && I4D[sel]) G.push(h('polygon', { key: 'sel', points: iPts(I4D[sel].poly), className: 'tn-cv-sel' }));
    // --- épületek és tárgyak ---
    Object.keys(I4H).forEach(function (k) { I4H[k].forEach(function (sp, n) { var hs = iHouse(sp, r, k + n); if (k === 'katonasag') hs.el = h('g', { key: 'nt' + n, filter: 'url(#i4-night)' }, hs.el); add(hs); }); });
    iPalace(r, dom('nemesseg').dominant ? tint(dom('nemesseg').dominant) : null).forEach(add);
    add(iClock(50, 25, 'clk'));
    iChapel(r).forEach(add);
    add(iMarketHall(67, 36, 77, 44, 'mh', r));
    var STALLS = [[80, 34.5, 'fruit'], [84, 34.5, 'cloth'], [88, 34.5, 'fish'], [80, 39.5, 'bread'], [84, 39.5, 'pots'], [88, 39.5, 'meat'], [80, 44.5, 'herbs'], [88, 44.5, 'spice'], [67, 46, 'fruit'], [71, 46, 'cloth']];
    STALLS.forEach(function (s, n) { add(iStall(s[0], s[1], s[2], 'stl' + n, r)); });
    add(iWell(92, 46, 'well'));
    add(iFountain(60, 60, 2.6, 'fnt', true));
    add(iFountain(40, 50.2, 1.4, 'pfnt', false));
    add(iCart(74, 47.5, 'cart1', '#d8b55c')); add(iCart(59, 72, 'cart2', '#f1e8d4')); add(iCart(100, 58.2, 'cart3', '#c9914e'));
    var tbx = iBarrels(43, 72.5, 5, 'tb'); tbx.el = h('g', { key: 'tbn', filter: 'url(#i4-night)' }, tbx.el); add(tbx); add(iBarrels(92, 69, 4, 'sb'));
    // kovácsműhely izzás
    var fg0 = iP(92, 69, 1); Dl.push([161.5, h('g', { key: 'forge' }, h('circle', { cx: iF(fg0[0]), cy: iF(fg0[1]), r: 9, fill: 'url(#i4-fire)' }), h('rect', { x: iF(fg0[0] - 2), y: iF(fg0[1] + 1), width: 4, height: 2, fill: '#3a3130' }))]);
    // fogadó lámpásai
    [[31, 73.6], [36, 73.6], [41.5, 73.6]].forEach(function (q, n) { var lp = iP(q[0], q[1], 2.3); Dl.push([q[0] + q[1] + 0.9, h('g', { key: 'lan' + n }, h('circle', { cx: iF(lp[0]), cy: iF(lp[1]), r: 7, fill: 'url(#kg-glow)', opacity: 0.9 }), h('path', { d: 'M' + iF(lp[0]) + ' ' + iF(lp[1] - 3) + 'v1.4', stroke: '#2e2a28', strokeWidth: 0.4 }), h('rect', { x: iF(lp[0] - 0.8), y: iF(lp[1] - 1.6), width: 1.6, height: 2, fill: '#f6cf6e', stroke: '#2e2a28', strokeWidth: 0.3 }))]); });
    // romos torony
    Dl.push([28 + 93 + 2.2, h('g', { key: 'ruin', filter: 'url(#i4-night)' }, iRTower(28, 93, 2.2, 9, { roof: 'broken', mat: 'dark' }))]);
    // városfal
    var WALLS = [[[22, 98], [98, 98], [0, 1]], [[98, 22], [98, 98], [1, 0]], [[22, 22], [98, 22], [0, -1]], [[22, 22], [22, 98], [-1, 0]]];
    WALLS.forEach(function (w, wi) {
      var A = w[0], B = w[1], n = w[2], L = Math.hypot(B[0] - A[0], B[1] - A[1]), dx = (B[0] - A[0]) / L, dy = (B[1] - A[1]) / L;
      for (var s = 3.4; s < L - 3.4; s += 3) {
        var e = Math.min(s + 3, L - 3.2), mid = (s + e) / 2;
        if (Math.abs(mid - L / 2) < 5.6) continue;
        add(iWallPiece([A[0] + dx * s, A[1] + dy * s], [A[0] + dx * e, A[1] + dy * e], n, 'w' + wi + '-' + s.toFixed(0)));
      }
      [0.25, 0.75].forEach(function (f, fi) { var tu = A[0] + dx * L * f + n[0] * 0.4, tv = A[1] + dy * L * f + n[1] * 0.4; Dl.push([tu + tv + 2.6, h('g', { key: 'mt' + wi + fi }, iRTower(tu, tv, 2.3, 9, { roof: wi < 2 ? 'cone' : 'cone', rk: wi % 2 ? 'red' : 'red', window: true, lit: tr() < 0.4 }))]); });
    });
    [[22, 22, 3.2, 12, 'cren'], [98, 22, 3.2, 12, 'cone'], [22, 98, 3.2, 12, 'cone'], [98, 98, 3.8, 14, 'cren']].forEach(function (q, n) {
      Dl.push([q[0] + q[1] + q[2] + 0.5, h('g', { key: 'ct' + n }, iRTower(q[0], q[1], q[2], q[3], { roof: q[4], rk: 'slate', flag: n === 3 || n === 1 ? 'var(--house-voros)' : null, window: true, lit: true, coneH: 8 }))]);
    });
    add(iGate(60, 98, true, true, 'g1')); add(iGate(98, 60, false, true, 'g2')); add(iGate(60, 22, true, false, 'g3')); add(iGate(22, 60, false, false, 'g4'));
    // hidak a vizesárok fölött
    [[57.5, 100, 62.5, 104.5], [100, 57.5, 104.5, 62.5], [57.5, 15.5, 62.5, 20], [15.5, 57.5, 20, 62.5]].forEach(function (q, n) {
      var o = []; iBox(o, q[0], q[1], q[2], q[3], 0.5, 1.1, MAT.stone, { top: '#a0845a' });
      var rail = n % 2 ? [iLn([q[0], q[1], 1.1], [q[2], q[1], 1.1]) + iLn([q[0], q[3], 1.1], [q[2], q[3], 1.1])] : [iLn([q[0], q[1], 1.1], [q[0], q[3], 1.1]) + iLn([q[2], q[1], 1.1], [q[2], q[3], 1.1])];
      iPathEl(o, rail.join(''), '#6f6352', 0.8);
      Dl.push([q[2] + q[3] - 1, h('g', { key: 'br' + n }, o)]);
    });
    // külső kőhíd a folyón
    if (!coast) { var ob = []; iBox(ob, 136, 57.5, 145, 62.5, 1.2, 2.2, MAT.stone, { top: '#b8a47c' }); var OF = iBoxF(136, 57.5, 145, 62.5, 1.2, 2.2).L; iPoly(ob, iQ(OF, 0, -1.2, 1, 0), MAT.stone.lit); [0.18, 0.5, 0.82].forEach(function (s) { iPoly(ob, [iM(OF, s - 0.12, -1.2), iM(OF, s + 0.12, -1.2), iM(OF, s + 0.12, -0.6), iM(OF, s, -0.3), iM(OF, s - 0.12, -0.6)], '#2d4650'); }); iPathEl(ob, iLn([136, 62.5, 2.8], [145, 62.5, 2.8]) + iLn([136, 57.5, 2.8], [145, 57.5, 2.8]), '#8c7d66', 1); Dl.push([205, h('g', { key: 'obr' }, ob)]); }
    else {
      [[146, 55.5, 160, 57.5], [146, 62.5, 160, 64.5]].forEach(function (q, n) { var o = []; iBox(o, q[0], q[1], q[2], q[3], 0.2, 0.8, MAT.wood, { top: '#b8834f' }); for (var pz = q[0] + 1; pz < q[2]; pz += 2.4) iBox(o, pz, q[3] - 0.3, pz + 0.3, q[3], -1.5, 1.2, MAT.wood, { noTop: true }); Dl.push([q[2] + q[3], h('g', { key: 'pier' + n }, o)]); });
      var sp1 = iP(152, 54), sp2 = iP(150, 68), sp3 = iP(158, 62);
      Dl.push([217, h('g', { key: 'ships' }, h('g', { transform: 'translate(' + iF(sp1[0]) + ' ' + iF(sp1[1]) + ') scale(2)' }, h(Ship, { x: 0, y: 0 })), h('g', { transform: 'translate(' + iF(sp2[0]) + ' ' + iF(sp2[1]) + ') scale(1.8)' }, h(Ship, { x: 0, y: 0 })), h('g', { transform: 'translate(' + iF(sp3[0]) + ' ' + iF(sp3[1]) + ') scale(1.5)' }, h(Ship, { x: 0, y: 0 }))) ]);
      add(iBarrels(141, 58, 5, 'hbar')); add(iHouse([136, 64, 6, 5, 2, 'wood', 'brown', 'c'], r, 'hwh'));
    }
    // tanya, szélmalom, pajta
    add(iBarn(-16, 64, 9, 8, 'barn', r));
    add(iHouse([-26, 64, 6, 6, 2, 'plaster', 'thatch', 'tcf'], r, 'fh1'));
    add(iHouse([24, 110, 5, 5, 1, 'plaster', 'thatch', 'c'], r, 'fh2'));
    add(iHouse([114, 100, 6, 5, 2, 'plaster', 'thatch', 'tc'], r, 'fh3'));
    add(iWindmill(-2, 40, 'wm', r));
    [[-30, 54], [-27, 55.5], [-32, 56], [8, 36], [42, 126], [118, 70]].forEach(function (q, n) { add(iHay(q[0], q[1], 2.2, 'hay' + n)); });
    [[1, 72, 'cow', 0], [5, 76, 'sheep', 1], [9, 71, 'cow', 1], [1, 80, 'sheep', 0], [10, 86, 'sheep', 1], [2, 87, 'cow', 0], [8, 79, 'sheep', 0], [11, 77, 'pig', 1]].forEach(function (q, n) { var ap = iP(q[0], q[1]); Dl.push([q[0] + q[1], h('g', { key: 'an' + n, transform: 'translate(' + iF(ap[0]) + ' ' + iF(ap[1]) + ') scale(1.5)' }, kAnimal(0, 0, q[2], 'a', !!q[3]))]); });
    [[-5, 70], [-4, 71.5], [-6, 72.5]].forEach(function (q, n) { var ap = iP(q[0], q[1]); Dl.push([q[0] + q[1], h('g', { key: 'ck' + n, transform: 'translate(' + iF(ap[0]) + ' ' + iF(ap[1]) + ') scale(1.5)' }, kAnimal(0, 0, 'chicken', 'c'))]); });
    // bánya
    [[52, -40, 10, 8, 'r1'], [64, -44, 9, 10, 'r2'], [38, -38, 8, 6, 'r3'], [28, -46, 9, 9, 'r4'], [74, -34, 7, 6, 'r5'], [46, -54, 9, 11, 'r6'], [34, -58, 8, 10, 'r7'], [60, -58, 9, 12, 'r8'], [80, -46, 8, 8, 'r9']].forEach(function (q) { add(iRock(q[0], q[1], q[2], q[3], q[4] + name, q[4], { grass: q[3] > 10 })); if (q[3] >= 8) add(iRock(q[0] - q[2] * 0.2, q[1] - q[2] * 0.25, q[2] * 0.55, q[3] * 0.7, q[4] + 'b' + name, q[4] + 'b', { z0: q[3] * 0.8, grass: q[3] > 10, warm: true })); });
    (function () {
      var o = []; iPoly(o, [[57.6, -27.2, 0], [62.4, -27.2, 0], [62.4, -27.2, 3.6], [57.6, -27.2, 3.6]], '#1a1412');
      iBox(o, 57.2, -27.6, 57.8, -27, 0, 3.8, MAT.wood, {}); iBox(o, 62.2, -27.6, 62.8, -27, 0, 3.8, MAT.wood, {}); iBox(o, 56.8, -27.6, 63.2, -27, 3.6, 4.3, MAT.wood, {});
      var lp = iP(63.4, -26.8, 3); o.push(h('circle', { key: o.length, cx: iF(lp[0]), cy: iF(lp[1]), r: 6, fill: 'url(#kg-glow)' })); o.push(h('rect', { key: o.length, x: iF(lp[0] - 0.8), y: iF(lp[1] - 1), width: 1.6, height: 2, fill: '#f6cf6e' }));
      var rl = [], ti = []; for (var v = -27; v < -4; v += 1) ti.push(iLn([58.6, v], [61.4, v])); rl.push(iLn([59.3, -27], [59.3, -4]) + iLn([60.7, -27], [60.7, -4]));
      iPathEl(o, ti.join(''), '#6b4a30', 0.9, { strokeLinecap: 'butt' }); iPathEl(o, rl.join(''), '#5e6b72', 0.6);
      Dl.push([33.5, h('g', { key: 'mine' }, o)]);
      var c = []; iBox(c, 58.9, -20, 61.1, -17.6, 0.5, 1.8, MAT.grey, { top: '#4a4448' }); var ct = iP(60, -18.8, 1.8); c.push(h('ellipse', { key: c.length, cx: iF(ct[0]), cy: iF(ct[1] - 0.6), rx: 3, ry: 1.6, fill: '#3e3a3e', stroke: I4O, strokeWidth: 0.3 })); c.push(h('path', { key: c.length, d: 'M' + iF(ct[0] - 1) + ' ' + iF(ct[1] - 1) + 'l.6-.4M' + iF(ct[0] + 0.8) + ' ' + iF(ct[1] - 0.6) + 'l.5-.5', stroke: '#e8cf6a', strokeWidth: 0.7 }));
      Dl.push([42.5, h('g', { key: 'ocart' }, c)]);
      var pile = iP(68, -12); Dl.push([56.5, h('g', { key: 'ore' }, h('path', { d: 'M' + iF(pile[0] - 10) + ' ' + iF(pile[1]) + 'C' + iF(pile[0] - 8) + ' ' + iF(pile[1] - 9) + ' ' + iF(pile[0] + 8) + ' ' + iF(pile[1] - 9) + ' ' + iF(pile[0] + 10) + ' ' + iF(pile[1]) + 'Q' + iF(pile[0]) + ' ' + iF(pile[1] + 3) + ' ' + iF(pile[0] - 10) + ' ' + iF(pile[1]) + 'z', fill: '#57515a', stroke: I4O, strokeWidth: 0.4 }), h('path', { d: 'M' + iF(pile[0] - 4) + ' ' + iF(pile[1] - 4) + 'l.8-.6M' + iF(pile[0] + 2) + ' ' + iF(pile[1] - 5) + 'l.8.4M' + iF(pile[0] + 5) + ' ' + iF(pile[1] - 2) + 'l.6-.6M' + iF(pile[0] - 1) + ' ' + iF(pile[1] - 1.5) + 'l.6.3', stroke: '#e8cf6a', strokeWidth: 0.9 }))]);
      var cr = []; iPathEl(cr, iLn([50, -14, 0], [50, -14, 8]) + iLn([50, -14, 8], [55, -14, 7]) + iLn([48.5, -14, 0], [50, -14, 5]) + iLn([51.5, -14, 0], [50, -14, 5]) + iLn([55, -14, 7], [55, -14, 3.5]), '#5b3d27', 1); iBox(cr, 54.4, -14.6, 55.6, -13.4, 2.4, 3.4, MAT.rock, {}); Dl.push([36, h('g', { key: 'crane' }, cr)]);
      for (var b = 0; b < 5; b++) { var bo = []; var bu = 46 + (b % 3) * 1.8, bv = -9 + Math.floor(b / 3) * 1.8, bz = b > 2 ? 0 : 0; iBox(bo, bu, bv, bu + 1.6, bv + 1.6, bz, bz + 1.2, MAT.stone, {}); Dl.push([bu + bv + 3.2, h('g', { key: 'blk' + b }, bo)]); }
    })();
    add(iHouse([66, -24, 5, 4, 1, 'wood', 'thatch', 'c'], r, 'shed'));
    [[62, -14, '#6b5a4a'], [57, -22, '#6b5a4a'], [52, -10, '#8c3a2c'], [66, -9, '#6b5a4a']].forEach(function (q) { fig(q[0], q[1], q[2]); });
    // fák és erdők
    for (i = 0; i < 30; i++) tree(-20 + tr() * 40, -24 + tr() * 24, 5 + tr() * 2.5, tr() < 0.55 ? 'pine' : 'oak');
    for (i = 0; i < 18; i++) tree(-60 + tr() * 30, 10 + tr() * 50, 5 + tr() * 2, tr() < 0.4 ? 'pine' : 'oak');
    for (i = 0; i < 26; i++) tree(92 + tr() * 50, 104 + tr() * 36, 5 + tr() * 2.5, tr() < 0.3 ? 'pine' : 'oak');
    for (i = 0; i < 12; i++) tree(64 + (i % 4) * 3.4, 126 + Math.floor(i / 4) * 3.4, 3.8, 'fruit');
    for (i = 0; i < 16; i++) tree(40 + tr() * 30, 140 + tr() * 25, 5 + tr() * 2, tr() < 0.3 ? 'pine' : 'oak');
        for (i = 0; i < 8; i++) tree(108 + tr() * 8, 64 + tr() * 6, 4.5, 'oak');
    [[26.5, 27.5, 'oak'], [31, 25.5, 'cypress'], [55.5, 30, 'cypress'], [55.5, 52, 'cypress'], [32.5, 55.6, 'cypress'], [47.5, 55.6, 'cypress'], [25.5, 57, 'oak'], [94, 30, 'oak'], [95, 45, 'oak'],
      [70, 77.5, 'fruit'], [86, 79, 'oak'], [95, 79, 'fruit'], [80, 95, 'oak'], [26, 70.5, 'oak'], [53, 94.5, 'oak'], [95.5, 94, 'oak'], [66, 70.5, 'fruit']].forEach(function (q) { tree(q[0], q[1], q[2] === 'cypress' ? 3.6 : 4.3, q[2]); });
    [[10, 60.5], [8, 57], [-12, 56.5], [110, 66], [128, 60]].forEach(function (q, n) { tree(q[0], q[1], 3.4, 'bush'); });
    // emberek
    function crowd(u0, v0, u1, v1, n, hood) { for (var c = 0; c < n; c++) fig(u0 + pr() * (u1 - u0), v0 + pr() * (v1 - v0), CLOTH[Math.floor(pr() * CLOTH.length)], hood && pr() < 0.6); }
    crowd(57.5, 24, 62.5, 96, 26); crowd(24, 57.5, 96, 62.5, 26); crowd(52.5, 52.5, 67.5, 67.5, 12); crowd(65, 34, 93, 49.5, 34); crowd(33, 41, 47, 44.5, 8);
    crowd(24, 73.5, 57, 75, 6, true); crowd(42.5, 63, 44, 96, 5, true); crowd(30, 83.5, 57, 85, 4, true);
    crowd(60, 104, 62, 150, 6); crowd(104, 58, 150, 62, 6); crowd(-40, 58, 16, 62, 5); crowd(58, -24, 62, 14, 4);
    [[-30, 10, '#6b7a3a'], [-14, 26, '#9a7a3a'], [28, 118, '#6b7a3a'], [116, 78, '#9a7a3a'], [-10, 96, '#6b7a3a']].forEach(function (q) { fig(q[0], q[1], q[2]); });
    [[56, 97.5], [64, 97.5], [97.5, 56], [97.5, 64]].forEach(function (q) { fig(q[0] + 0.5, q[1] + 2.2, 'var(--btn-red)'); });
    Dl.sort(function (a, b) { return a[0] - b[0]; });
    // --- rátétek ---
    var alvPoly = iPts([[20, 60], [60, 60], [60, 100], [20, 100]]), fx = [];
    [[40, 80, 26, 10], [30, 90, 16, 7], [52, 70, 14, 6]].forEach(function (q, n) { var c = iP(q[0], q[1], 1); fx.push(h('ellipse', { key: 'fog' + n, cx: iF(c[0]), cy: iF(c[1]), rx: q[2] * 2.4, ry: q[3] * 2.4, fill: '#7d7690', opacity: 0.2, filter: 'url(#kg-fog)' })); });
    [[43.2, 76, 0.4], [37.2, 84.2, 0.4], [43.2, 92, 0.4], [30, 74.2, 0.4], [50, 84.2, 0.4]].forEach(function (q, n) { var c = iP(q[0], q[1], q[2]); fx.push(h('ellipse', { key: 'lg' + n, cx: iF(c[0]), cy: iF(c[1]), rx: 9, ry: 5, fill: 'url(#kg-glow)', opacity: 0.7 })); });
    [[43.2, 76], [37.2, 84.2], [43.2, 92], [50, 84.2]].forEach(function (q, n) { var b = iP(q[0], q[1], 0), t = iP(q[0], q[1], 3); Dl.push([q[0] + q[1], h('g', { key: 'lamp' + n }, h('path', { d: 'M' + iF(b[0]) + ' ' + iF(b[1]) + 'L' + iF(t[0]) + ' ' + iF(t[1]), stroke: '#2e2a28', strokeWidth: 0.7 }), h('circle', { cx: iF(t[0]), cy: iF(t[1]), r: 5, fill: 'url(#kg-glow)' }), h('rect', { x: iF(t[0] - 0.9), y: iF(t[1] - 1.2), width: 1.8, height: 2.2, fill: '#f6cf6e', stroke: '#2e2a28', strokeWidth: 0.3 }))]); });
    Dl.sort(function (a, b) { return a[0] - b[0]; });
    var labels = Object.keys(I4D).map(function (k) {
      var D0 = I4D[k], v0 = dom(k), lp = iP(D0.label[0], D0.label[1], 0), fp = iP(D0.flag[0], D0.flag[1], D0.flag[2]);
      return h('g', { key: 'lab' + k },
        v0.contested ? h(Pennant, { x: fp[0] + 14, y: fp[1] + 4, tincture: v0.contested }) : null,
        v0.dominant ? h(Pennant, { x: fp[0], y: fp[1], tincture: v0.dominant }) : null,
        h('text', { x: iF(lp[0]), y: iF(lp[1]), textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, D0.name));
    });
    return h('svg', { className: 'tn-city-view tn-city-iso', viewBox: '0 0 720 540', role: 'img', 'aria-label': name + ' látképe' },
      h(PaintDefs, null), h(I4Defs, null),
      h('defs', null, h('radialGradient', { id: gid, cx: '50%', cy: '48%', r: '75%' }, h('stop', { offset: '0%', stopColor: '#b3c77e' }), h('stop', { offset: '100%', stopColor: '#8aa55c' })),
        h('radialGradient', { id: vid, cx: '50%', cy: '52%', r: '72%' }, h('stop', { offset: '66%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.38 }))),
      G,
      Dl.map(function (x, n) { return h('g', { key: 'd' + n }, x[1]); }),
      h('g', { pointerEvents: 'none' }, fx),
      labels,
      stab === 'lazongo' ? [[40, 84], [80, 70], [70, 30]].map(function (q, n) { var fp2 = iP(q[0], q[1], 6); return h(Flame, { key: 'fx' + n, x: fp2[0], y: fp2[1] }); }) : null,
      h('rect', { width: 720, height: 540, filter: 'url(#kg-grain)', opacity: 0.32, pointerEvents: 'none' }),
      h('rect', { width: 720, height: 540, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      p.onSelect ? Object.keys(I4D).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: iPts(I4D[k].poly), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': I4D[k].name, 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }
