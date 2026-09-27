/*@@town*/
  function town(s, rc, key, seed) {
    var r = rng('town' + seed), RK = rc === 'blue' ? 'slate' : rc === 'grey' ? 'dark' : 'red', WM = rc === 'grey' ? 'grey' : 'stone', L = 20;
    var HR = rc === 'grey' ? ['dark', 'dark', 'moss'] : rc === 'blue' ? ['slate', 'red', 'slate', 'teal', 'brown'] : ['red', 'brown', 'red', 'teal', 'red'];
    return iWith(1.5, 0, -17, function () {
      var o = [], mid = [];
      o.push(h('polygon', { key: 'gs', points: iPts([[-1, -1, 0], [L + 3, 0, 0], [L + 3, L + 3, 0], [0, L + 3, 0]]), fill: '#2c1f13', opacity: 0.28, filter: 'url(#kg-blur)' }));
      o.push(h('polygon', { key: 'gd', points: iPts([[0, 0], [L, 0], [L, L], [0, L]]), fill: rc === 'grey' ? '#b9ae98' : '#cdb88d' }));
      o.push(h('path', { key: 'st', d: iLn([10, 10], [10, L]) + iLn([10, 10], [L, 10]), stroke: '#e0d2b0', strokeWidth: 2.4 }));
      var wopt = { H: 3.4, t: 1.3, mat: WM };
      o.push(iWallPiece([0, 0], [L, 0], [0, -1], 'w1', wopt).el); o.push(iWallPiece([0, 0], [0, L], [-1, 0], 'w2', wopt).el);
      o.push(h('g', { key: 't0' }, iRTower(0, 0, 1.6, 5.4, { roof: 'cone', rk: RK, mat: WM, coneH: 3.6 })));
      var HS = [[2.2, 2.4, 4, 3, 2], [13.5, 2.2, 4.2, 3.2, 2], [2.4, 13.6, 3.6, 3.6, 1], [14.6, 13, 3.4, 4, 2], [7.4, 14.2, 3.6, 3, 1], [15, 7.6, 3, 3.4, 1]];
      HS.forEach(function (q, n) { mid.push(iHouse([q[0], q[1], q[2], q[3], q[4], ['plaster', 'white', 'ochre', 'rose'][n % 4], HR[n % HR.length], 'c'], r, 'h' + n)); });
      mid.push((function () { var e = [], M = MAT[WM]; iShadowBox(e, 6.5, 5, 12.5, 11, 7); iBox(e, 6.5, 5, 12.5, 11, 0, 7, M, { noTop: true }); var B = iBoxF(6.5, 5, 12.5, 11, 0, 7); iWin(e, B.L, 0.3, 0.5, 0.4, 0.7, { lit: true, sill: false }); iWin(e, B.L, 0.6, 0.5, 0.7, 0.7, { lit: rc !== 'grey', sill: false }); iWin(e, B.R, 0.45, 0.5, 0.55, 0.7, { sill: false }); iRoof(e, 6.5, 5, 12.5, 11, 7, 3.4, 'hip', ROOF[RK], M, { kind: RK === 'slate' ? 'slate' : 'tile', ov: 0.3 }); var tt = iRTower(12, 6, 1.4, 11.5, { roof: 'cone', rk: RK, mat: WM, coneH: 4.4, flag: rc === 'grey' ? null : key ? 'var(--house-kek)' : 'var(--house-voros)' }); e.push(h('g', { key: e.length }, tt)); return { el: h('g', { key: 'keep' }, e), depth: 23.5 }; })());
      mid.push({ el: h('g', { key: 't1' }, iRTower(L, 0, 1.6, 5.4, { roof: 'cone', rk: RK, mat: WM, coneH: 3.6 })), depth: 21.6 });
      mid.push({ el: h('g', { key: 't2' }, iRTower(0, L, 1.6, 5.4, { roof: 'cone', rk: RK, mat: WM, coneH: 3.6 })), depth: 21.6 });
      mid.sort(function (a, b) { return a.depth - b.depth; }).forEach(function (x) { o.push(x.el); });
      o.push(iWallPiece([L, 0], [L, L], [1, 0], 'w3', wopt).el);
      o.push(iWallPiece([0, L], [8, L], [0, 1], 'w4', wopt).el); o.push(iWallPiece([12, L], [L, L], [0, 1], 'w5', wopt).el);
      var g = []; iBox(g, 7.6, L - 1, 12.4, L + 1, 0, 4.6, MAT[WM], { top: '#a89a80' }); var GF = iBoxF(7.6, L - 1, 12.4, L + 1, 0, 4.6).L; iPoly(g, [iM(GF, 0.3, 0), iM(GF, 0.7, 0), iM(GF, 0.7, 0.4), iM(GF, 0.5, 0.55), iM(GF, 0.3, 0.4)], '#171214', { strokeWidth: 0.25 }); o.push(h('g', { key: 'gate' }, g));
      o.push(h('g', { key: 't3' }, iRTower(L, L, key ? 2.2 : 1.9, key ? 7.5 : 6.4, { roof: key ? 'cren' : 'cone', rk: RK, mat: WM, coneH: 4.2, flag: key ? 'var(--house-kek)' : null })));
      return h('g', null, o);
    });
  }
/*@@Mountain*/
  function Mountain(p) { var s = p.s || 1; return iWith(1.45 * s, p.x, p.y, function () { return h('g', null, iRock(0, 0, 6, 10.5, 'mt' + p.x + p.y, 'm', { snow: true }).el); }); }
/*@@Tree*/
  function Tree(t, k) { return iTree(t.x, t.y + t.r * 1.15, t.r * 1.05, t.pine ? 'pine' : t.fruit ? 'fruit' : 'oak', k, rng('tr' + t.x.toFixed(1) + t.y.toFixed(1))); }
/*@@MiniHouse*/
  var RMAP = { 'var(--roof-red)': 'red', 'var(--roof-brown)': 'brown', 'var(--roof-blue)': 'slate', 'var(--roof-teal)': 'teal' };
  function MiniHouse(x, y, roof, k, w) { w = w || 4; var sc = w / 4, r = rng('mh' + x + y); return iWith(1.1 * sc, x + w / 2, y + w * 0.4, function () { return h('g', { key: k }, iHouse([-1.8, -1.5, 3.6, 3, 1, r() < 0.5 ? 'plaster' : 'white', RMAP[roof] || 'red', r() < 0.5 ? 'c' : ''], r, 'h').el); }); }
/*@@Farm*/
  function Farm(p) {
    var r = rng('farm' + p.x + p.y), cw = p.cw || 9, ch = p.ch || 6, c = p.cols * cw / ((p.cols + p.rows) * 0.866), X = p.x + p.rows * c * 0.866, fs = [];
    return iWith(1, X, p.y, function () {
      for (var i = 0; i < p.cols; i++) for (var j = 0; j < p.rows; j++) fs.push(iField(i * c, j * c, (i + 1) * c - 0.2, (j + 1) * c - 0.2, Math.floor(r() * CROP4.length), r() < 0.5, 'f' + i + '-' + j, r));
      var hb = []; for (var e = 0; e < p.cols + p.rows; e++) { var edge = r() < 0.5, t = r(), q = edge ? iP(t * p.cols * c, Math.floor(r() * (p.rows + 1)) * c) : iP(Math.floor(r() * (p.cols + 1)) * c, t * p.rows * c); hb.push(h('circle', { key: e, cx: iF(q[0]), cy: iF(q[1]), r: 1.2, fill: 'url(#i4-tree2)', stroke: '#1f3319', strokeWidth: 0.2 })); }
      return h('g', null, fs, hb, p.house ? MiniHouse(p.x - 4, p.y - 6, 'var(--roof-red)', 'fh', 4) : null);
    });
  }
/*@@Field*/
  function Field(p) { return Farm({ x: p.x, y: p.y, cols: 2, rows: 1, cw: p.w / 2, ch: p.h }); }
/*@@Hill*/
  function Hill(x, y, s, k) {
    var w = 10 * s, t = 6.5 * s, r = rng('hl' + x + y), tf = [];
    for (var i = 0; i < 9; i++) { var tx = x - w * 0.7 + r() * w * 1.4, ty = y - t * (0.15 + r() * 0.55); tf.push('M' + iF(tx) + ' ' + iF(ty) + 'l.4-1.3M' + iF(tx + 0.8) + ' ' + iF(ty) + 'l.2-1.1'); }
    return h('g', { key: k },
      h('ellipse', { cx: x + w * 0.35, cy: y + 0.6, rx: w * 1.15, ry: t * 0.35, fill: '#2c3f1c', opacity: 0.25, filter: 'url(#kg-blur)' }),
      h('path', { d: 'M' + (x - w) + ' ' + y + 'C' + (x - w * 0.6) + ' ' + (y - t) + ' ' + (x + w * 0.5) + ' ' + (y - t * 1.05) + ' ' + (x + w) + ' ' + y + 'Q' + x + ' ' + (y + t * 0.18) + ' ' + (x - w) + ' ' + y + 'z', fill: 'url(#i4-hill)' }),
      h('path', { d: tf.join(''), stroke: '#5f7d3a', strokeWidth: 0.4, opacity: 0.6, strokeLinecap: 'round' }));
  }
