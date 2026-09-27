/*@@CityView*/
  /* ---------- Krónika III: festett eszközkészlet ---------- */
  function PaintDefs() {
    function lg(id, a, b) { return h('linearGradient', { key: id, id: id, x1: 0, y1: 0, x2: 0, y2: 1 }, h('stop', { offset: '0%', stopColor: a }), h('stop', { offset: '100%', stopColor: b })); }
    function rg(id, stops, cx0, cy0) { return h('radialGradient', { key: id, id: id, cx: cx0 || '38%', cy: cy0 || '32%', r: '70%' }, stops.map(function (s, i) { return h('stop', { key: i, offset: s[0], stopColor: s[1], stopOpacity: s[2] == null ? 1 : s[2] }); })); }
    return h('defs', null,
      lg('kg-roof-red', '#c8745a', '#8a3c2a'), lg('kg-roof-brown', '#a98058', '#6b472c'), lg('kg-roof-slate', '#7a93aa', '#3e546a'),
      lg('kg-roof-blue', '#6a8db0', '#324e6c'), lg('kg-roof-teal', '#80a99e', '#446c62'), lg('kg-roof-thatch', '#dcc27f', '#9a7a3a'),
      lg('kg-roof-dark', '#62545f', '#2a222c'), lg('kg-roof-darkbrown', '#6e5242', '#35261d'), lg('kg-roof-moss', '#7d8a5a', '#46512f'),
      lg('kg-wall-cream', '#f5eacf', '#d8c59d'), lg('kg-wall-ochre', '#ebd297', '#c4a061'), lg('kg-wall-rose', '#eecbb5', '#c99c84'),
      lg('kg-wall-white', '#f8f2e4', '#d9cfb8'), lg('kg-wall-dark', '#8c7c69', '#54473a'), lg('kg-wall-grey', '#9b948a', '#645e56'),
      lg('kg-wall-timber', '#e9dcc0', '#c7b28a'), lg('kg-stone', '#e4dac6', '#ad9f86'), lg('kg-stone-dark', '#a89b85', '#6f6352'),
      lg('kg-copper', '#94c4ac', '#4a7664'), lg('kg-water', '#86b8c6', '#447d92'), lg('kg-rock', '#d0c0a2', '#8a765c'), lg('kg-rock-dark', '#9d8b72', '#5a4b3b'),
      lg('kg-cloth-red', '#c85a48', '#8c3325'), lg('kg-cloth-blue', '#5f86b0', '#2f4f73'), lg('kg-cloth-gold', '#e8c46a', '#b08a2e'), lg('kg-cloth-green', '#7fa05a', '#4b6a30'),
      lg('kg-barn', '#b5503c', '#7a2e22'), lg('kg-plaza', '#e6d7b3', '#cdb98f'), lg('kg-plaza-dark', '#7a6f66', '#4d453f'),
      rg('kg-tree', [['0%', '#93b862'], ['55%', '#557d38'], ['100%', '#2e4c24']]), rg('kg-pine', [['0%', '#6a9352'], ['100%', '#2c4a28']]),
      rg('kg-bush', [['0%', '#8aad5c'], ['100%', '#3d5e2c']]),
      rg('kg-glow', [['0%', '#ffe7a3', 0.95], ['45%', '#f6c65e', 0.45], ['100%', '#f6c65e', 0]], '50%', '50%'),
      rg('kg-dusk', [['0%', '#1c1218', 0.05], ['60%', '#1c1218', 0.38], ['100%', '#140c12', 0.62]], '50%', '55%'),
      h('linearGradient', { key: 'kg-fade', id: 'kg-fade', x1: 0, y1: 0, x2: 0, y2: 1 }, h('stop', { offset: '0%', stopColor: '#fff8e0', stopOpacity: 0.25 }), h('stop', { offset: '50%', stopColor: '#fff8e0', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.3 })),
      h('filter', { id: 'kg-grain', x: 0, y: 0, width: '100%', height: '100%', filterUnits: 'objectBoundingBox' },
        h('feTurbulence', { type: 'fractalNoise', baseFrequency: 0.9, numOctaves: 2, seed: 7 }),
        h('feColorMatrix', { type: 'matrix', values: '0 0 0 0 0.2  0 0 0 0 0.14  0 0 0 0 0.08  0 0 0 -1.6 1.02' })),
      h('filter', { id: 'kg-blur', x: '-20%', y: '-20%', width: '140%', height: '140%' }, h('feGaussianBlur', { stdDeviation: 1.1 })),
      h('filter', { id: 'kg-blur-lg', x: '-50%', y: '-50%', width: '200%', height: '200%' }, h('feGaussianBlur', { stdDeviation: 7 })),
      h('filter', { id: 'kg-fog', x: '-20%', y: '-20%', width: '140%', height: '140%' }, h('feGaussianBlur', { stdDeviation: 4 })));
  }
  var K = { o: '#3d2b1c' };
  function E() { return h.apply(null, arguments); }
  function kShadow(x, g, w, d, k) { return E('path', { key: k, d: 'M' + (x + 2) + ' ' + g + 'h' + (w + d) + 'l' + (d * 0.9 + 4) + ' ' + 3.5 + 'h-' + (w + d) + 'z', fill: '#2c1f13', opacity: 0.3, filter: 'url(#kg-blur)' }); }
  function kWindows(o, x, y, w, fh, fl, r, st) {
    var cols = Math.max(1, Math.floor((w - 2) / 4.6)), gap = (w - cols * 1.9) / (cols + 1);
    for (var f = 0; f < fl; f++) {
      var wy = y - fh + 2.2 + f * 6.2;
      for (var c = 0; c < cols; c++) {
        var wx = x + gap + c * (1.9 + gap), lit = r() < (st === 'slum' ? 0.12 : 0.22), board = st === 'slum' && r() < 0.28;
        if (f === fl - 1 && c === Math.floor(cols / 2) && st !== 'noble') continue;
        if (st === 'noble') o.push(E('path', { key: 'w' + f + c, d: 'M' + wx + ' ' + (wy + 3.2) + 'v-2.2a.95.95 0 0 1 1.9 0v2.2z', fill: lit ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.25 }));
        else {
          o.push(E('rect', { key: 'w' + f + c, x: wx, y: wy, width: 1.9, height: 2.6, fill: lit ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.25 }));
          if (board) o.push(E('path', { key: 'b' + f + c, d: 'M' + (wx - 0.2) + ' ' + (wy + 0.7) + 'l2.3 .4M' + (wx - 0.2) + ' ' + (wy + 1.8) + 'l2.3-.3', stroke: '#6b4a30', strokeWidth: 0.55 }));
          else if (st === 'market' && r() < 0.6) { o.push(E('rect', { key: 'sl' + f + c, x: wx - 0.7, y: wy, width: 0.6, height: 2.6, fill: '#5f7d52' })); o.push(E('rect', { key: 'sr' + f + c, x: wx + 2, y: wy, width: 0.6, height: 2.6, fill: '#5f7d52' })); }
          if (st === 'market' && r() < 0.25) o.push(E('rect', { key: 'fb' + f + c, x: wx - 0.4, y: wy + 2.6, width: 2.7, height: 0.8, fill: '#c0503a' }));
        }
      }
    }
  }
  var STY = {
    noble: { walls: ['kg-stone', 'kg-wall-white', 'kg-wall-cream'], roofs: ['kg-roof-slate', 'kg-roof-blue', 'kg-roof-slate'], fl: [2, 3], hip: 0.6, timber: 0 },
    market: { walls: ['kg-wall-cream', 'kg-wall-ochre', 'kg-wall-rose', 'kg-wall-white', 'kg-wall-timber'], roofs: ['kg-roof-red', 'kg-roof-red', 'kg-roof-brown', 'kg-roof-teal', 'kg-roof-thatch'], fl: [1, 3], hip: 0.15, timber: 0.5 },
    slum: { walls: ['kg-wall-dark', 'kg-wall-grey', 'kg-wall-timber'], roofs: ['kg-roof-dark', 'kg-roof-darkbrown', 'kg-roof-moss', 'kg-roof-thatch'], fl: [1, 2], hip: 0, timber: 0.4 },
    farm: { walls: ['kg-wall-cream', 'kg-wall-white'], roofs: ['kg-roof-thatch', 'kg-roof-thatch', 'kg-roof-brown'], fl: [1, 1], hip: 0, timber: 0.6 }
  };
  function kBuilding(x, g, w, st, r, k, opt) {
    opt = opt || {};
    var S = STY[st], fl = opt.fl || (S.fl[0] + Math.floor(r() * (S.fl[1] - S.fl[0] + 1))), fh = fl * 6.2 + 1, d = Math.min(8, w * 0.38), o = [];
    var wall = 'url(#' + (opt.wall || S.walls[Math.floor(r() * S.walls.length)]) + ')', roof = 'url(#' + (opt.roof || S.roofs[Math.floor(r() * S.roofs.length)]) + ')';
    var hip = r() < S.hip, rh = Math.min(12, w * (hip ? 0.3 : 0.48)), top = g - fh, broken = st === 'slum' && r() < 0.3, tilt = st === 'slum' ? (r() - 0.5) * 5 : 0;
    o.push(kShadow(x, g, w, d, 'sh'));
    o.push(E('path', { key: 'side', d: 'M' + (x + w) + ' ' + top + 'l' + d + ' ' + (-d * 0.5) + 'v' + fh + 'l' + (-d) + ' ' + (d * 0.5) + 'z', fill: wall, stroke: K.o, strokeWidth: 0.4 }));
    o.push(E('path', { key: 'sideS', d: 'M' + (x + w) + ' ' + top + 'l' + d + ' ' + (-d * 0.5) + 'v' + fh + 'l' + (-d) + ' ' + (d * 0.5) + 'z', fill: '#2c1f13', opacity: 0.28 }));
    o.push(E('rect', { key: 'front', x: x, y: top, width: w, height: fh, fill: wall, stroke: K.o, strokeWidth: 0.45 }));
    o.push(E('rect', { key: 'plinth', x: x, y: g - 1.4, width: w, height: 1.4, fill: '#8a7a62', opacity: 0.6 }));
    if (r() < S.timber) { var tl = []; for (var f = 1; f < fl; f++) tl.push('M' + x + ' ' + (top + f * 6.2) + 'h' + w); tl.push('M' + (x + 0.6) + ' ' + top + 'v' + fh + 'M' + (x + w - 0.6) + ' ' + top + 'v' + fh); for (var q = x + 5; q < x + w - 2; q += 6) tl.push('M' + q + ' ' + top + 'l' + 2.4 + ' ' + 6.2); o.push(E('path', { key: 'tim', d: tl.join(''), stroke: '#5b3d27', strokeWidth: 0.45, opacity: 0.9 })); }
    kWindows(o, x, g, w, fh, fl, r, st);
    var dx = x + w * (0.3 + r() * 0.35);
    o.push(E('path', { key: 'door', d: 'M' + dx + ' ' + g + 'v-4a1.3 1.3 0 0 1 2.6 0v4z', fill: st === 'slum' ? '#2e2320' : '#5b3d27', stroke: K.o, strokeWidth: 0.3 }));
    if (d > 3 && fl > 1) o.push(E('rect', { key: 'sw', x: x + w + d * 0.35, y: top + 2.6 - d * 0.17, width: 1.4, height: 2.4, fill: '#3a3130', transform: 'skewY(-26.6)', style: { transformOrigin: (x + w + d * 0.35) + 'px ' + (top + 2.6) + 'px' } }));
    if (opt.shop || (st === 'market' && r() < 0.35)) {
      var cl = ['kg-cloth-red', 'kg-cloth-blue', 'kg-cloth-gold', 'kg-cloth-green'][Math.floor(r() * 4)], aw = [];
      for (var s = 0; s < w; s += 2.4) aw.push(E('path', { key: 'aw' + s, d: 'M' + (x + s) + ' ' + (g - 6.4) + 'h' + Math.min(1.2, w - s) + 'l.3 2.6h-' + Math.min(1.2, w - s) + 'z', fill: '#f4ecd8' }));
      o.push(E('path', { key: 'awn', d: 'M' + (x - 0.6) + ' ' + (g - 6.6) + 'h' + (w + 1.2) + 'l1 2.8h-' + (w + 3.2) + 'z', fill: 'url(#' + cl + ')', stroke: K.o, strokeWidth: 0.35 }));
      o.push(E('g', { key: 'aws', opacity: 0.8 }, aw));
      o.push(E('path', { key: 'goods', d: 'M' + (x + 1) + ' ' + g + 'h3.2v-1.8h-3.2zM' + (x + w - 4.5) + ' ' + g + 'h3.2v-1.6h-3.2z', fill: '#a77a4a', stroke: K.o, strokeWidth: 0.25 }));
      o.push(E('circle', { key: 'g1', cx: x + 2, cy: g - 2.2, r: 0.7, fill: '#c0503a' })); o.push(E('circle', { key: 'g2', cx: x + 3, cy: g - 2.2, r: 0.7, fill: '#d9a441' }));
    }
    if (opt.sign || r() < 0.15) { o.push(E('path', { key: 'sgb', d: 'M' + (x + w - 1) + ' ' + (g - 9) + 'h3', stroke: K.o, strokeWidth: 0.4 })); o.push(E('rect', { key: 'sg', x: x + w + 0.6, y: g - 8.8, width: 2.6, height: 2, fill: st === 'slum' ? '#4a3a2a' : '#b98a4e', stroke: K.o, strokeWidth: 0.3 })); }
    var rg = [];
    if (hip) {
      rg.push(E('path', { key: 'rs', d: 'M' + (x + w * 0.8) + ' ' + (top - rh) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + d + 0.8) + ' ' + (top - d * 0.5) + 'L' + (x + w + 0.8) + ' ' + top + 'z', fill: roof, stroke: K.o, strokeWidth: 0.4 }));
      rg.push(E('path', { key: 'rsS', d: 'M' + (x + w * 0.8) + ' ' + (top - rh) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + d + 0.8) + ' ' + (top - d * 0.5) + 'L' + (x + w + 0.8) + ' ' + top + 'z', fill: '#000', opacity: 0.2 }));
      rg.push(E('path', { key: 'rf', d: 'M' + (x - 0.8) + ' ' + top + 'L' + (x + w * 0.2) + ' ' + (top - rh) + 'H' + (x + w * 0.8) + 'L' + (x + w + 0.8) + ' ' + top + 'z', fill: roof, stroke: K.o, strokeWidth: 0.45 }));
      var tl2 = []; for (var t = 1; t < 4; t++) tl2.push('M' + (x - 0.8 + t * w * 0.05) + ' ' + (top - t * rh / 4) + 'H' + (x + w + 0.8 - t * w * 0.05)); rg.push(E('path', { key: 'rt', d: tl2.join(''), stroke: '#000', strokeOpacity: 0.18, strokeWidth: 0.35 }));
      if (fl > 1) rg.push(E('path', { key: 'dorm', d: 'M' + (x + w * 0.45) + ' ' + (top - rh * 0.25) + 'v-2.6l1.2-1.4 1.2 1.4v2.6z', fill: 'url(#kg-wall-white)', stroke: K.o, strokeWidth: 0.3 }));
    } else {
      rg.push(E('path', { key: 'rs', d: 'M' + (x + w / 2) + ' ' + (top - rh) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + d + 0.8) + ' ' + (top - d * 0.5 + 0.3) + 'L' + (x + w + 0.8) + ' ' + (top + 0.3) + 'z', fill: roof, stroke: K.o, strokeWidth: 0.4 }));
      var tl3 = []; for (var u = 1; u < 5; u++) { var fr = u / 5; tl3.push('M' + (x + w / 2 + (w / 2 + 0.8) * fr) + ' ' + (top - rh + rh * fr + 0.3 * fr) + 'l' + d + ' ' + (-d * 0.5)); } rg.push(E('path', { key: 'rt', d: tl3.join(''), stroke: '#000', strokeOpacity: 0.22, strokeWidth: 0.35 }));
      rg.push(E('path', { key: 'gab', d: 'M' + x + ' ' + top + 'L' + (x + w / 2) + ' ' + (top - rh) + 'L' + (x + w) + ' ' + top + 'z', fill: wall, stroke: K.o, strokeWidth: 0.4 }));
      rg.push(E('path', { key: 'gabS', d: 'M' + x + ' ' + top + 'L' + (x + w / 2) + ' ' + (top - rh) + 'L' + (x + w) + ' ' + top + 'z', fill: '#000', opacity: 0.08 }));
      rg.push(E('path', { key: 'barge', d: 'M' + (x - 0.9) + ' ' + (top + 0.4) + 'L' + (x + w / 2) + ' ' + (top - rh - 0.4) + 'L' + (x + w + 0.9) + ' ' + (top + 0.4), fill: 'none', stroke: roof, strokeWidth: 1.4, strokeLinejoin: 'round' }));
      rg.push(E('path', { key: 'barge2', d: 'M' + (x - 0.9) + ' ' + (top + 0.4) + 'L' + (x + w / 2) + ' ' + (top - rh - 0.4) + 'L' + (x + w + 0.9) + ' ' + (top + 0.4), fill: 'none', stroke: K.o, strokeWidth: 0.35, strokeOpacity: 0.6 }));
      if (w > 9) rg.push(E('rect', { key: 'gw', x: x + w / 2 - 0.9, y: top - rh * 0.5, width: 1.8, height: 2.2, fill: r() < 0.3 ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.25 }));
      if (broken) rg.push(E('path', { key: 'hole', d: 'M' + (x + w * 0.7) + ' ' + (top - rh * 0.4) + 'l2 -1.2l1.2 1.6l-1 1.4z', fill: '#1d1614' }));
    }
    var chim = r() < (st === 'noble' ? 0.8 : 0.5);
    if (chim) { var cx0 = x + w * 0.62 + d * 0.3; rg.push(E('path', { key: 'ch', d: 'M' + cx0 + ' ' + (top - rh * 0.55) + 'v-5h2.2v4', fill: 'url(#kg-stone-dark)', stroke: K.o, strokeWidth: 0.3 })); if (r() < 0.45) { rg.push(E('circle', { key: 'sm1', cx: cx0 + 1.4, cy: top - rh * 0.55 - 7, r: 1.6, fill: '#e8e2d6', opacity: 0.55, filter: 'url(#kg-blur)' })); rg.push(E('circle', { key: 'sm2', cx: cx0 + 3, cy: top - rh * 0.55 - 11, r: 2.2, fill: '#e8e2d6', opacity: 0.35, filter: 'url(#kg-blur)' })); } }
    if (st === 'noble' && r() < 0.35) o.push(E('path', { key: 'bal', d: 'M' + (x + w * 0.3) + ' ' + (top + 6) + 'h' + (w * 0.4) + 'v1.2h-' + (w * 0.4) + 'zM' + (x + w * 0.32) + ' ' + (top + 6) + 'v-1.8M' + (x + w * 0.5) + ' ' + (top + 6) + 'v-1.8M' + (x + w * 0.68) + ' ' + (top + 6) + 'v-1.8', fill: '#8a7a62', stroke: K.o, strokeWidth: 0.3 }));
    if (r() < 0.12 && st !== 'slum') o.push(E('path', { key: 'ivy', d: 'M' + (x + 0.5) + ' ' + g + 'c1-3 -1-6 1-9c1.4 2 .2 5 1 9z', fill: '#5f8a45', opacity: 0.85 }));
    return E('g', { key: k, transform: tilt ? 'rotate(' + tilt.toFixed(1) + ' ' + (x + w / 2) + ' ' + g + ')' : undefined }, o, rg);
  }
  function kFig(x, y, c, k, s, hood) {
    s = s || 1;
    return E('g', { key: k, transform: 'translate(' + x.toFixed(1) + ' ' + y.toFixed(1) + ') scale(' + s + ')' },
      E('ellipse', { cx: 0.6, cy: 0.2, rx: 1.3, ry: 0.4, fill: '#2c1f13', opacity: 0.3 }),
      E('path', { d: 'M-1 0l.3-3a.8.8 0 0 1 1.4 0l.3 3z', fill: c, stroke: K.o, strokeWidth: 0.2 }),
      hood ? E('path', { d: 'M-.8-3.2a.9.9 0 0 1 1.6 0l.1 1h-1.8z', fill: '#241c22', stroke: K.o, strokeWidth: 0.18 }) : E('circle', { cx: 0, cy: -3.9, r: 0.7, fill: '#e2c09a', stroke: K.o, strokeWidth: 0.18 }));
  }
  function kTree(x, y, rr, k, pine) {
    if (pine) return E('g', { key: k }, E('ellipse', { cx: x + rr * 0.5, cy: y + 0.5, rx: rr * 0.9, ry: rr * 0.3, fill: '#2c1f13', opacity: 0.25, filter: 'url(#kg-blur)' }), E('rect', { x: x - 0.4, y: y - rr * 0.6, width: 0.8, height: rr * 0.6, fill: '#6b4a30' }),
      E('path', { d: 'M' + (x - rr * 0.8) + ' ' + (y - rr * 0.5) + 'L' + x + ' ' + (y - rr * 2.6) + 'L' + (x + rr * 0.8) + ' ' + (y - rr * 0.5) + 'z', fill: 'url(#kg-pine)', stroke: K.o, strokeWidth: 0.35 }),
      E('path', { d: 'M' + (x - rr * 0.6) + ' ' + (y - rr * 1.3) + 'L' + x + ' ' + (y - rr * 2.6) + 'L' + (x + rr * 0.6) + ' ' + (y - rr * 1.3), fill: 'none', stroke: K.o, strokeWidth: 0.3, strokeOpacity: 0.5 }));
    return E('g', { key: k }, E('ellipse', { cx: x + rr * 0.6, cy: y + 0.4, rx: rr * 1.1, ry: rr * 0.35, fill: '#2c1f13', opacity: 0.28, filter: 'url(#kg-blur)' }), E('rect', { x: x - 0.45, y: y - rr * 0.9, width: 0.9, height: rr * 0.9, fill: '#6b4a30' }),
      E('circle', { cx: x - rr * 0.4, cy: y - rr * 1.05, r: rr * 0.7, fill: 'url(#kg-tree)', stroke: K.o, strokeWidth: 0.3 }), E('circle', { cx: x + rr * 0.45, cy: y - rr * 1.0, r: rr * 0.66, fill: 'url(#kg-tree)', stroke: K.o, strokeWidth: 0.3 }),
      E('circle', { cx: x, cy: y - rr * 1.55, r: rr * 0.8, fill: 'url(#kg-tree)', stroke: K.o, strokeWidth: 0.3 }));
  }
  function kStall(x, g, type, k) {
    var cl = { fruit: 'kg-cloth-red', cloth: 'kg-cloth-blue', fish: 'kg-cloth-blue', pots: 'kg-cloth-gold', bread: 'kg-cloth-gold', herbs: 'kg-cloth-green', meat: 'kg-cloth-red', spice: 'kg-cloth-green' }[type] || 'kg-cloth-red', o = [], w = 14;
    o.push(kShadow(x, g, w, 3, 's'));
    o.push(E('rect', { key: 't', x: x, y: g - 4.2, width: w, height: 4.2, fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.35 }));
    o.push(E('path', { key: 'tt', d: 'M' + x + ' ' + (g - 4.2) + 'l1.6-1.2h' + w + 'l-1.6 1.2z', fill: '#c9a26a', stroke: K.o, strokeWidth: 0.3 }));
    var gy = g - 5.2;
    if (type === 'fruit' || type === 'spice') for (var i = 0; i < 8; i++) o.push(E('circle', { key: 'f' + i, cx: x + 1.8 + i * 1.6, cy: gy + (i % 2) * 0.4, r: 0.8, fill: type === 'spice' ? ['#c96d2a', '#d8b55c', '#8c3a2c'][i % 3] : ['#c0503a', '#d9a441', '#6b9a3a', '#c0503a'][i % 4], stroke: K.o, strokeWidth: 0.15 }));
    if (type === 'cloth') for (var j = 0; j < 5; j++) o.push(E('rect', { key: 'c' + j, x: x + 1.2 + j * 2.5, y: gy - 1, width: 2.2, height: 1.8, rx: 0.6, fill: ['#8c3a2c', '#3b5f82', '#d8b55c', '#5a4466', '#6b7a3a'][j], stroke: K.o, strokeWidth: 0.2 }));
    if (type === 'fish') { o.push(E('rect', { key: 'ice', x: x + 1, y: gy - 0.6, width: w - 2, height: 1.2, fill: '#dfeef0' })); for (var q = 0; q < 4; q++) o.push(E('path', { key: 'fi' + q, d: 'M' + (x + 1.6 + q * 3) + ' ' + gy + 'q1.2-1 2.4 0l.8-.6v1.2l-.8-.6q-1.2 1-2.4 0z', fill: '#9fb3c2', stroke: K.o, strokeWidth: 0.15 })); }
    if (type === 'pots') for (var t = 0; t < 4; t++) o.push(E('path', { key: 'p' + t, d: 'M' + (x + 2 + t * 3.2) + ' ' + (gy + 0.8) + 'c-1-1-1-2.4 0-2.8h1.6c1 .4 1 1.8 0 2.8z', fill: t % 2 ? '#b7643a' : '#c98a55', stroke: K.o, strokeWidth: 0.2 }));
    if (type === 'bread') for (var b = 0; b < 5; b++) o.push(E('ellipse', { key: 'b' + b, cx: x + 2.2 + b * 2.4, cy: gy, rx: 1.1, ry: 0.7, fill: '#c9914e', stroke: K.o, strokeWidth: 0.15 }));
    if (type === 'herbs') for (var e = 0; e < 6; e++) o.push(E('path', { key: 'h' + e, d: 'M' + (x + 2 + e * 2) + ' ' + (gy + 0.6) + 'l-.6-2M' + (x + 2 + e * 2) + ' ' + (gy + 0.6) + 'v-2.2M' + (x + 2 + e * 2) + ' ' + (gy + 0.6) + 'l.6-2', stroke: '#5f8a45', strokeWidth: 0.5 }));
    if (type === 'meat') { o.push(E('path', { key: 'mh', d: 'M' + (x + 1) + ' ' + (g - 11) + 'h' + (w - 2), stroke: K.o, strokeWidth: 0.3 })); for (var m = 0; m < 4; m++) o.push(E('path', { key: 'm' + m, d: 'M' + (x + 3 + m * 3) + ' ' + (g - 11) + 'v1c-1 .6-1 2.6 0 3c1-.4 1-2.4 0-3', fill: '#b5503c', stroke: K.o, strokeWidth: 0.15 })); }
    o.push(E('path', { key: 'po', d: 'M' + (x + 0.5) + ' ' + g + 'v-12M' + (x + w - 0.5) + ' ' + g + 'v-12', stroke: '#5b3d27', strokeWidth: 0.6 }));
    var st = [];
    for (var s = 0; s < 5; s++) st.push(E('path', { key: 'st' + s, d: 'M' + (x - 1 + s * 3.2) + ' ' + (g - 12) + 'h1.6l-.2 3.6h-1.6z', fill: '#f4ecd8', opacity: 0.85 }));
    o.push(E('path', { key: 'awn', d: 'M' + (x - 1.4) + ' ' + (g - 12.4) + 'h' + (w + 2.8) + 'l.6 4h-' + (w + 4) + 'z', fill: 'url(#' + cl + ')', stroke: K.o, strokeWidth: 0.4 }));
    o.push(E('g', { key: 'stg' }, st));
    o.push(E('path', { key: 'val', d: 'M' + (x - 2) + ' ' + (g - 8.4) + 'q1.2 1 2.4 0t2.4 0t2.4 0t2.4 0t2.4 0t2.4 0t2.2 0', fill: 'none', stroke: K.o, strokeWidth: 0.3 }));
    return E('g', { key: k }, o);
  }
  function kCrate(x, y, k) { return E('g', { key: k }, E('rect', { x: x, y: y - 3, width: 3.4, height: 3, fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.3 }), E('path', { d: 'M' + x + ' ' + (y - 3) + 'l3.4 3M' + (x + 3.4) + ' ' + (y - 3) + 'l-3.4 3', stroke: '#4a321f', strokeWidth: 0.25 })); }
  function kBarrel(x, y, k) { return E('g', { key: k }, E('rect', { x: x, y: y - 3.8, width: 3, height: 3.8, rx: 1, fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.3 }), E('path', { d: 'M' + x + ' ' + (y - 2.8) + 'h3M' + x + ' ' + (y - 1) + 'h3', stroke: '#5e6b72', strokeWidth: 0.35 })); }
  function kCart(x, y, k, load) {
    return E('g', { key: k }, E('ellipse', { cx: x + 7, cy: y + 0.8, rx: 9, ry: 1.4, fill: '#2c1f13', opacity: 0.25, filter: 'url(#kg-blur)' }),
      E('rect', { x: x, y: y - 5, width: 10, height: 3.4, fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.35 }),
      load ? E('ellipse', { cx: x + 5, cy: y - 5.2, rx: 4.4, ry: 1.6, fill: load, stroke: K.o, strokeWidth: 0.25 }) : null,
      E('path', { d: 'M' + (x + 10) + ' ' + (y - 3) + 'l5 1.6', stroke: '#5b3d27', strokeWidth: 0.6 }),
      [x + 2.4, x + 7.6].map(function (c, i) { return E('g', { key: i }, E('circle', { cx: c, cy: y - 1.4, r: 1.8, fill: '#6b4a30', stroke: K.o, strokeWidth: 0.35 }), E('path', { d: 'M' + (c - 1.8) + ' ' + (y - 1.4) + 'h3.6M' + c + ' ' + (y - 3.2) + 'v3.6', stroke: '#a8895a', strokeWidth: 0.25 })); }),
      E('ellipse', { cx: x + 17.5, cy: y - 2.6, rx: 2.8, ry: 1.6, fill: '#7d5230', stroke: K.o, strokeWidth: 0.3 }), E('path', { d: 'M' + (x + 19.4) + ' ' + (y - 3.4) + 'l1.4-2.4', stroke: '#7d5230', strokeWidth: 1.1, strokeLinecap: 'round' }),
      E('path', { d: 'M' + (x + 16) + ' ' + (y - 1.2) + 'v1.2M' + (x + 19) + ' ' + (y - 1.2) + 'v1.2', stroke: '#5b3d27', strokeWidth: 0.5 }));
  }
  function kAnimal(x, y, kind, k, flip) {
    var sx = flip ? -1 : 1;
    if (kind === 'sheep') return E('g', { key: k, transform: 'translate(' + x + ' ' + y + ') scale(' + sx + ' 1)' }, E('ellipse', { cx: 0, cy: -1.4, rx: 2, ry: 1.3, fill: '#f3eee2', stroke: K.o, strokeWidth: 0.25 }), E('circle', { cx: 2, cy: -1.8, r: 0.7, fill: '#3a3130' }), E('path', { d: 'M-1 -.2v.9M1-.2v.9', stroke: '#3a3130', strokeWidth: 0.4 }));
    if (kind === 'pig') return E('g', { key: k, transform: 'translate(' + x + ' ' + y + ') scale(' + sx + ' 1)' }, E('ellipse', { cx: 0, cy: -1.2, rx: 1.8, ry: 1.1, fill: '#e9b3a2', stroke: K.o, strokeWidth: 0.25 }), E('circle', { cx: 1.9, cy: -1.2, r: 0.5, fill: '#d99a88' }));
    if (kind === 'chicken') return E('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' }, E('circle', { cx: 0, cy: -0.8, r: 0.7, fill: '#f6f0e2', stroke: K.o, strokeWidth: 0.15 }), E('circle', { cx: 0.5, cy: -1.4, r: 0.3, fill: '#c0503a' }));
    return E('g', { key: k, transform: 'translate(' + x + ' ' + y + ') scale(' + sx + ' 1)' }, E('rect', { x: -2.6, y: -3.4, width: 5, height: 2.4, rx: 1, fill: '#f3eee2', stroke: K.o, strokeWidth: 0.25 }), E('path', { d: 'M-1.6-3.4h1.4v1.4h-1.8zM.8-2.4h1.2v1.4H.6z', fill: '#3a3130' }), E('path', { d: 'M2.4-3.6h1.4v1.6h-1.4z', fill: '#e6dccb', stroke: K.o, strokeWidth: 0.2 }), E('path', { d: 'M-2-1v1.2M-.6-1v1.2M1-1v1.2M2-1v1.2', stroke: '#3a3130', strokeWidth: 0.45 }));
  }
  var FCROP = [['#d9bf6a', '#b99a45'], ['#c9a95a', '#a4863c'], ['#a9bf6a', '#7f9a48'], ['#8fae5c', '#6b8a42'], ['#b98a5a', '#8e6640'], ['#d6c889', '#b2a061'], ['#9cb870', '#76944c']];
  function kFields(x0, y0, cols, rows, cw, ch, seed, k) {
    var r = rng('kf' + seed), o = [], hed = [], j = function () { return (r() - 0.5) * 3; }, P = [];
    for (var i = 0; i <= cols; i++) { P.push([]); for (var jj = 0; jj <= rows; jj++) P[i].push([x0 + i * cw + (i && i < cols ? j() : 0), y0 + jj * ch + (jj && jj < rows ? j() : 0)]); }
    for (i = 0; i < cols; i++) for (var q = 0; q < rows; q++) {
      var a = P[i][q], b = P[i + 1][q], c = P[i + 1][q + 1], d = P[i][q + 1], cr = FCROP[Math.floor(r() * FCROP.length)], pts = [a, b, c, d].map(function (z) { return z[0].toFixed(1) + ',' + z[1].toFixed(1); }).join(' ');
      o.push(E('polygon', { key: 'p' + i + q, points: pts, fill: cr[0] }));
      var ln = [], vert = r() < 0.5, n = 0;
      if (vert) for (var t = 0.08; t < 1; t += 1.6 / cw) { ln.push('M' + (a[0] + (b[0] - a[0]) * t).toFixed(1) + ' ' + (a[1] + (b[1] - a[1]) * t + 0.6).toFixed(1) + 'L' + (d[0] + (c[0] - d[0]) * t).toFixed(1) + ' ' + (d[1] + (c[1] - d[1]) * t - 0.6).toFixed(1)); n++; }
      else for (var u = 0.1; u < 1; u += 1.5 / ch) { ln.push('M' + (a[0] + (d[0] - a[0]) * u + 0.6).toFixed(1) + ' ' + (a[1] + (d[1] - a[1]) * u).toFixed(1) + 'L' + (b[0] + (c[0] - b[0]) * u - 0.6).toFixed(1) + ' ' + (b[1] + (c[1] - b[1]) * u).toFixed(1)); n++; }
      o.push(E('path', { key: 'l' + i + q, d: ln.join(''), stroke: cr[1], strokeWidth: 0.55, opacity: 0.85 }));
      if (r() < 0.25) o.push(E('path', { key: 'hb' + i + q, d: 'M' + (a[0] + cw * 0.5) + ' ' + (a[1] + ch * 0.6) + 'q2.4-5 4.8 0z', fill: 'url(#kg-roof-thatch)', stroke: K.o, strokeWidth: 0.3 }));
    }
    for (i = 0; i <= cols; i++) for (q = 0; q < rows; q++) if (r() < 0.55) { var A = P[i][q], B = P[i][q + 1]; for (var s2 = 0; s2 < 1; s2 += 0.22) hed.push(E('circle', { key: 'hv' + i + q + s2, cx: A[0] + (B[0] - A[0]) * s2, cy: A[1] + (B[1] - A[1]) * s2, r: 1.3 + r() * 0.5, fill: 'url(#kg-bush)', stroke: K.o, strokeWidth: 0.2 })); }
    for (q = 0; q <= rows; q++) for (i = 0; i < cols; i++) if (r() < 0.4) { var C = P[i][q], D = P[i + 1][q]; for (var s3 = 0; s3 < 1; s3 += 0.16) hed.push(E('circle', { key: 'hh' + i + q + s3, cx: C[0] + (D[0] - C[0]) * s3, cy: C[1] + (D[1] - C[1]) * s3, r: 1.2 + r() * 0.5, fill: 'url(#kg-bush)', stroke: K.o, strokeWidth: 0.2 })); }
    return E('g', { key: k }, E('rect', { x: x0 - 1, y: y0 - 1, width: cols * cw + 2, height: rows * ch + 2, fill: '#2c1f13', opacity: 0.18, filter: 'url(#kg-blur)' }), o, E('rect', { x: x0, y: y0, width: cols * cw, height: rows * ch, fill: 'url(#kg-dusk)', opacity: 0.18 }), hed);
  }
  var D3 = {
    nemesseg: { poly: [[150, 110], [260, 72], [400, 60], [402, 150], [362, 252], [250, 298], [120, 280]], name: 'Városháza', label: [262, 296], flag: [238, 108] },
    katonasag: { poly: [[400, 60], [520, 80], [608, 140], [640, 250], [556, 262], [470, 252], [402, 150]], name: 'Alvilág', label: [520, 272], flag: [498, 156] },
    kereskedok: { poly: [[120, 280], [250, 298], [362, 252], [470, 252], [556, 262], [640, 250], [612, 380], [520, 458], [380, 490], [240, 470], [160, 400]], name: 'Vásártér', label: [385, 432], flag: [452, 262] }
  };
  var W3 = [[150, 110], [260, 72], [400, 60], [520, 80], [608, 140], [640, 250], [612, 380], [520, 458], [380, 490], [240, 470], [160, 400], [120, 280]];
  var G3 = [[120, 280], [400, 60], [640, 250], [380, 490]];
  var ST3 = [[[120, 280], [210, 292], [300, 338]], [[400, 60], [398, 150], [390, 318]], [[640, 250], [560, 262], [470, 318]], [[380, 490], [382, 404]]];
  var LN3 = [[[210, 292], [214, 238]], [[398, 150], [352, 150]], [[560, 262], [538, 196], [486, 150], [440, 108]], [[470, 176], [590, 196]], [[440, 246], [420, 196], [436, 140]], [[240, 414], [530, 414]], [[300, 338], [252, 440]], [[470, 376], [570, 376]], [[168, 300], [168, 392]]];
  var EX3 = [[180, 92, 352, 290], [290, 292, 488, 414], [468, 196, 548, 248], [566, 142, 598, 190], [446, 128, 484, 150]];
  function k3SegD(x, y, a, b) { var dx = b[0] - a[0], dy = b[1] - a[1], t = ((x - a[0]) * dx + (y - a[1]) * dy) / (dx * dx + dy * dy); t = Math.max(0, Math.min(1, t)); return Math.hypot(x - a[0] - t * dx, y - a[1] - t * dy); }
  function k3LineD(x, y, L) { var m = 1e9; for (var i = 0; i < L.length - 1; i++) m = Math.min(m, k3SegD(x, y, L[i], L[i + 1])); return m; }
  function k3WallD(x, y) { var m = 1e9; for (var i = 0; i < W3.length; i++) m = Math.min(m, k3SegD(x, y, W3[i], W3[(i + 1) % W3.length])); return m; }
  function k3Free(x, y) {
    if (!inPoly(x, y, W3) || k3WallD(x, y) < 13) return false;
    for (var i = 0; i < EX3.length; i++) { var e = EX3[i]; if (x > e[0] && x < e[2] && y > e[1] && y < e[3]) return false; }
    for (i = 0; i < ST3.length; i++) if (k3LineD(x, y, ST3[i]) < 9) return false;
    for (i = 0; i < LN3.length; i++) if (k3LineD(x, y, LN3[i]) < 5.5) return false;
    for (i = 0; i < G3.length; i++) if (Math.hypot(x - G3[i][0], y - G3[i][1]) < 26) return false;
    return true;
  }
  function k3Style(x, y) { return inPoly(x, y, D3.katonasag.poly) ? 'slum' : inPoly(x, y, D3.nemesseg.poly) ? 'noble' : 'market'; }
  function k3Lots(r) {
    var out = [], trees = [];
    for (var g = 84; g < 486; g += 17) {
      var x = 128 + r() * 6;
      while (x < 634) {
        var st = k3Style(x, g), w = (st === 'noble' ? 12 : st === 'slum' ? 7 : 9) + r() * (st === 'noble' ? 10 : 7), d = Math.min(8, w * 0.38);
        var pts = [[x, g], [x + w + d, g - 1], [x + w * 0.5, g - 3], [x, g - 9], [x + w + d, g - 9], [x + w * 0.5, g - 9]];
        if (pts.every(function (q) { return k3Free(q[0], q[1]); }) && k3Style(x + w, g) === st) {
          if (r() < (st === 'noble' ? 0.14 : st === 'slum' ? 0.03 : 0.07)) { trees.push([x + w / 2, g - 1, st]); x += w * 0.8; continue; }
          out.push([x, g, w, st]); x += w + d * 0.35 + (st === 'slum' ? 0.2 + r() * 1 : 1 + r() * 2.4);
        } else x += 3;
      }
    }
    return { lots: out, trees: trees };
  }
  function k3Jag(pts, amp, r) { var o = []; for (var i = 0; i < pts.length - 1; i++) { var a = pts[i], b = pts[i + 1]; o.push(a); for (var t = 1; t < 4; t++) o.push([a[0] + (b[0] - a[0]) * t / 4 + (r() - 0.5) * amp, a[1] + (b[1] - a[1]) * t / 4 + (r() - 0.5) * amp]); } o.push(pts[pts.length - 1]); return o; }
  function k3Poly(pts) { return pts.map(function (q) { return q.join(','); }).join(' '); }
  function k3Line(pts) { return 'M' + pts.map(function (q) { return q.join(' '); }).join('L'); }
  function CityView(p) {
    var d = p.districts || {}, sel = p.selected, stab = p.stability, name = p.name || 'varos';
    var r = rng('k3' + name), pr = rng('k3p' + name), draw = [], people = [], i;
    var gid = useUid('g'), vid = useUid('v');
    var LT = k3Lots(r); LT.lots.forEach(function (l, n) { draw.push([l[1], kBuilding(l[0], l[1], l[2], l[3], r, 'b' + n)]); });
    LT.trees.forEach(function (q, n) { draw.push([q[1], kTree(q[0], q[1], q[2] === 'slum' ? 2.6 : 3.4, 'lt' + n, q[2] === 'noble' && n % 3 === 0)]); });
    // Városháza (parlament): főépület, kupola, óratorony, szárnyak, díszkert, tér
    var P = [];
    P.push(E('rect', { key: 'pl', x: 196, y: 232, width: 140, height: 52, rx: 2, fill: 'url(#kg-plaza)', stroke: K.o, strokeWidth: 0.4 }));
    (function () { var pp = []; for (var x = 200; x < 334; x += 6) pp.push('M' + x + ' 234v48'); for (var y = 238; y < 282; y += 6) pp.push('M198 ' + y + 'h136'); P.push(E('path', { key: 'plp', d: pp.join(''), stroke: '#b8a47c', strokeWidth: 0.35, opacity: 0.7 })); })();
    P.push(E('circle', { key: 'fnt0', cx: 266, cy: 262, r: 12, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }));
    P.push(E('circle', { key: 'fnt1', cx: 266, cy: 262, r: 9.5, fill: 'url(#kg-water)' }));
    P.push(E('path', { key: 'fnt2', d: 'M259 262q3.5-2 7 0t7 0M261 266q2.5-1.4 5 0t5 0', stroke: '#e8f1ec', strokeWidth: 0.5, fill: 'none' }));
    P.push(E('rect', { key: 'fnt3', x: 264, y: 250, width: 4, height: 11, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.35 }));
    P.push(E('path', { key: 'fnt4', d: 'M264.6 250l.6-5.6a.9.9 0 0 1 1.6 0l.6 5.6z', fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.3 }));
    P.push(E('circle', { key: 'fnt5', cx: 266, cy: 243.6, r: 1.1, fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.25 }));
    [[212, 250], [320, 250], [212, 276], [320, 276]].forEach(function (q, n) { P.push(kTree(q[0], q[1], 3.2, 'pt' + n)); });
    [[236, 238], [296, 238]].forEach(function (q, n) { P.push(E('g', { key: 'stat' + n }, E('rect', { x: q[0] - 2.4, y: q[1] - 4, width: 4.8, height: 4, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.3 }), E('path', { d: 'M' + (q[0] - 1) + ' ' + (q[1] - 4) + 'l.3-4.6a.7.7 0 0 1 1.4 0l.3 4.6z', fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.25 }), E('circle', { cx: q[0], cy: q[1] - 9.4, r: 0.9, fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.2 }))); });
    draw.push([236, E('g', { key: 'plaza' }, P)]);
    var H = [];
    H.push(E('path', { key: 'gard', d: 'M200 102h130v14h-130z', fill: '#8fa865', stroke: '#4d6a34', strokeWidth: 0.5 }));
    for (i = 0; i < 6; i++) H.push(E('path', { key: 'gp' + i, d: 'M' + (204 + i * 21) + ' 104h17v10h-17zM' + (208 + i * 21) + ' 107h9v4h-9z', fill: 'none', stroke: '#3d5e2c', strokeWidth: 0.8 }));
    for (i = 0; i < 6; i++) H.push(kTree(208 + i * 22, 101, 2.4, 'gt' + i, i % 2 === 0));
    [[196, 124, 50, 40], [286, 124, 40, 22]].forEach(function (q, n) {
      var X = q[0], Y = q[1], Wd = q[2], Hh = q[3];
      H.push(E('rect', { key: 'pt' + n, x: X, y: Y, width: Wd, height: Hh, fill: '#9cb56e', stroke: '#4d6a34', strokeWidth: 0.6 }));
      H.push(E('path', { key: 'pp' + n, d: 'M' + (X + Wd / 2) + ' ' + Y + 'v' + Hh + 'M' + X + ' ' + (Y + Hh / 2) + 'h' + Wd, stroke: '#e6d7b3', strokeWidth: 2.2 }));
      H.push(E('circle', { key: 'pc' + n, cx: X + Wd / 2, cy: Y + Hh / 2, r: 3.4, fill: 'url(#kg-water)', stroke: '#e6d7b3', strokeWidth: 1.2 }));
      H.push(E('path', { key: 'ph' + n, d: 'M' + (X + 3) + ' ' + (Y + 3) + 'h' + (Wd / 2 - 6) + 'v' + (Hh / 2 - 6) + 'h-' + (Wd / 2 - 6) + 'zM' + (X + Wd / 2 + 3) + ' ' + (Y + Hh / 2 + 3) + 'h' + (Wd / 2 - 6) + 'v' + (Hh / 2 - 6) + 'h-' + (Wd / 2 - 6) + 'z', fill: 'none', stroke: '#3d5e2c', strokeWidth: 0.9 }));
      [[X + 1.5, Y + 2], [X + Wd - 1.5, Y + 2], [X + 1.5, Y + Hh], [X + Wd - 1.5, Y + Hh]].forEach(function (z, m) { H.push(kTree(z[0], z[1], 2.2, 'pk' + n + m, true)); });
      if (Hh > 30) for (var m = 0; m < 4; m++) H.push(kTree(X + 8 + m * 11, Y + Hh / 2 - 1, 2.6, 'pr' + n + m));
    });
    H.push(E('path', { key: 'gar2', d: 'M188 170h-2M226 100v-6', stroke: 'none' }));
    H.push(kShadow(186, 232, 160, 10, 'psh'));
    [[186, 198, 28], [318, 198, 28]].forEach(function (q, n) {
      H.push(E('rect', { key: 'wg' + n, x: q[0], y: q[1], width: q[2], height: 34, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }));
      for (var f = 0; f < 3; f++) for (var c = 0; c < 4; c++) H.push(E('path', { key: 'ww' + n + f + c, d: 'M' + (q[0] + 3 + c * 6.4) + ' ' + (q[1] + 8 + f * 9) + 'v-3.4a1.1 1.1 0 0 1 2.2 0v3.4z', fill: (f + c + n) % 3 === 0 ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.25 }));
      H.push(E('path', { key: 'wr' + n, d: 'M' + (q[0] - 1.5) + ' ' + q[1] + 'L' + (q[0] + 6) + ' ' + (q[1] - 9) + 'H' + (q[0] + q[2] - 6) + 'L' + (q[0] + q[2] + 1.5) + ' ' + q[1] + 'z', fill: 'url(#kg-roof-slate)', stroke: K.o, strokeWidth: 0.55 }));
    });
    H.push(E('rect', { key: 'main', x: 214, y: 184, width: 104, height: 48, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.7 }));
    H.push(E('path', { key: 'mainL', d: 'M214 199h104M214 214h104', stroke: '#9d8e74', strokeWidth: 0.5 }));
    for (var fr = 0; fr < 3; fr++) for (var cc = 0; cc < 13; cc++) { if (cc > 3 && cc < 9 && fr > 0) continue; H.push(E('path', { key: 'mw' + fr + cc, d: 'M' + (217 + cc * 7.6) + ' ' + (195 + fr * 15) + 'v-5a1.3 1.3 0 0 1 2.6 0v5z', fill: (fr * 13 + cc) % 4 === 0 ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.3 })); }
    H.push(E('path', { key: 'mroof', d: 'M211 184L222 172H310L321 184z', fill: 'url(#kg-roof-slate)', stroke: K.o, strokeWidth: 0.6 }));
    H.push(E('path', { key: 'balu', d: 'M222 172h88', stroke: '#e4dac6', strokeWidth: 1.4, strokeDasharray: '1 1' }));
    H.push(E('rect', { key: 'drum', x: 252, y: 150, width: 28, height: 22, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }));
    for (i = 0; i < 5; i++) H.push(E('path', { key: 'dw' + i, d: 'M' + (255 + i * 5.2) + ' 166v-7a1.1 1.1 0 0 1 2.2 0v7z', fill: i % 2 ? '#f4d27a' : '#3a3130', stroke: K.o, strokeWidth: 0.3 }));
    H.push(E('path', { key: 'dome', d: 'M250 150a16 16 0 0 1 32 0z', fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.7 }));
    H.push(E('path', { key: 'domer', d: 'M256 150c0-8 4-13 10-15M261 150c0-7 2-11 5-15M271 150c0-7-2-11-5-15M276 150c0-8-4-13-10-15', stroke: '#3f6655', strokeWidth: 0.4, fill: 'none', opacity: 0.7 }));
    H.push(E('path', { key: 'domel', d: 'M254 146c1-5 4-8 8-10', stroke: '#e0f0e6', strokeWidth: 0.8, fill: 'none', opacity: 0.6 }));
    H.push(E('rect', { key: 'lant', x: 263, y: 128, width: 6, height: 7, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.4 }));
    H.push(E('path', { key: 'lantr', d: 'M262 128l4-4 4 4z', fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.4 }));
    H.push(E('path', { key: 'fp', d: 'M266 124v-10', stroke: K.o, strokeWidth: 0.6 }));
    H.push(E('path', { key: 'fl', d: 'M266 114c3-1.2 5.6 1.2 8.6 0l-1.8 2.3 1.8 2.3c-3 1.2-5.6-1.2-8.6 0z', fill: 'var(--house-kek)', stroke: K.o, strokeWidth: 0.35 }));
    H.push(E('path', { key: 'ped', d: 'M236 204L266 190L296 204z', fill: 'url(#kg-wall-white)', stroke: K.o, strokeWidth: 0.6 }));
    H.push(E('circle', { key: 'pedc', cx: 266, cy: 199, r: 2.6, fill: 'var(--frame)', stroke: K.o, strokeWidth: 0.35 }));
    H.push(E('rect', { key: 'ent', x: 236, y: 204, width: 60, height: 2.4, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.4 }));
    for (i = 0; i < 8; i++) H.push(E('g', { key: 'col' + i }, E('rect', { x: 238.5 + i * 7.6, y: 206.4, width: 2.8, height: 22, fill: 'url(#kg-wall-white)', stroke: K.o, strokeWidth: 0.35 }), E('path', { d: 'M' + (239.9 + i * 7.6) + ' 207v21', stroke: '#c9bea6', strokeWidth: 0.5 })));
    H.push(E('path', { key: 'door', d: 'M262 228.4v-9a4 4 0 0 1 8 0v9z', fill: '#5b3d27', stroke: K.o, strokeWidth: 0.4 }));
    H.push(E('path', { key: 'stairs', d: 'M232 228.4h68l2 1.8h-72zM230 230.2h72l2 1.8h-76z', fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.35 }));
    H.push(E('rect', { key: 'banner1', x: 222, y: 202, width: 4, height: 10, fill: 'var(--house-kek)', stroke: K.o, strokeWidth: 0.3 }), E('rect', { key: 'banner2', x: 306, y: 202, width: 4, height: 10, fill: 'var(--house-kek)', stroke: K.o, strokeWidth: 0.3 }));
    // óratorony
    H.push(E('rect', { key: 'ct', x: 330, y: 150, width: 16, height: 82, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }));
    H.push(E('rect', { key: 'cts', x: 339, y: 150, width: 7, height: 82, fill: '#000', opacity: 0.12 }));
    H.push(E('circle', { key: 'clock', cx: 338, cy: 162, r: 5, fill: '#f6f0e2', stroke: K.o, strokeWidth: 0.5 }));
    H.push(E('path', { key: 'hands', d: 'M338 162v-3.4M338 162l2.4 1.2', stroke: K.o, strokeWidth: 0.5 }));
    for (i = 0; i < 3; i++) H.push(E('path', { key: 'ctw' + i, d: 'M336.8 ' + (182 + i * 14) + 'v-4a1.2 1.2 0 0 1 2.4 0v4z', fill: '#3a3130', stroke: K.o, strokeWidth: 0.3 }));
    H.push(E('path', { key: 'ctr', d: 'M328 150L338 124L348 150z', fill: 'url(#kg-roof-slate)', stroke: K.o, strokeWidth: 0.6 }));
    H.push(E('path', { key: 'ctf', d: 'M338 124v-7', stroke: K.o, strokeWidth: 0.5 }));
    draw.push([232.5, E('g', { key: 'parl' }, H)]);
    // őrök
    [[228, 231, 'var(--btn-red)'], [304, 231, 'var(--btn-red)'], [214, 290, '#3b5f82'], [330, 286, '#5a4466']].forEach(function (q, n) { people.push([q[0], q[1], q[2], false]); });
    // Vásártér: burkolt tér, standok, céhház, mérlegház, kút, szekerek, állatkarám
    var M = [];
    M.push(E('path', { key: 'mp', d: 'M298 320h176l8 88h-190z', fill: 'url(#kg-plaza)', stroke: K.o, strokeWidth: 0.45 }));
    (function () { var pp = []; for (var y = 326; y < 408; y += 5) pp.push('M' + (298 - (y - 320) * 0.07) + ' ' + y + 'h' + (176 + (y - 320) * 0.16)); M.push(E('path', { key: 'mpp', d: pp.join(''), stroke: '#b8a47c', strokeWidth: 0.35, opacity: 0.55 })); })();
    draw.push([319, E('g', { key: 'mplaza' }, M)]);
    var stalls = [['fruit', 306, 342], ['cloth', 326, 342], ['fish', 346, 342], ['bread', 420, 342], ['pots', 440, 342], ['meat', 460, 342], ['herbs', 306, 372], ['spice', 326, 372], ['fruit', 440, 372], ['cloth', 460, 372], ['fish', 306, 400], ['pots', 440, 400], ['bread', 460, 400]];
    stalls.forEach(function (s, n) { draw.push([s[2], kStall(s[1], s[2], s[0], 'stall' + n)]); });
    draw.push([382, E('g', { key: 'mfount' },
      E('path', { d: 'M372 372l5-6h14l5 6-5 6h-14z', fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }),
      E('path', { d: 'M375 372l3.5-4h12l3.5 4-3.5 4h-12z', fill: 'url(#kg-water)' }),
      E('path', { d: 'M378 373q3-1.6 6 0t6 0', stroke: '#e8f1ec', strokeWidth: 0.45, fill: 'none' }),
      E('rect', { x: 382, y: 358, width: 4, height: 14, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.35 }),
      E('path', { d: 'M382.4 358l.8-6a.9.9 0 0 1 1.6 0l.8 6z', fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.3 }),
      E('circle', { cx: 384, cy: 350.6, r: 1.1, fill: 'url(#kg-copper)', stroke: K.o, strokeWidth: 0.25 }),
      E('path', { d: 'M385 352l3-2.4', stroke: 'url(#kg-copper)', strokeWidth: 0.8 }))]);
    draw.push([318, kBuilding(402, 318, 58, 'market', r, 'guild', { fl: 3, wall: 'kg-wall-ochre', roof: 'kg-roof-red', sign: true })]);
    draw.push([318.2, E('g', { key: 'guildx' },
      [0, 1, 2, 3, 4].map(function (n) { return E('path', { key: n, d: 'M' + (404 + n * 11) + ' 318v-5a3 3 0 0 1 6 0v5z', fill: '#4a3a2a', stroke: K.o, strokeWidth: 0.3 }); }),
      E('path', { d: 'M428 298h8v9l-4 2-4-2z', fill: 'var(--house-arany)', stroke: K.o, strokeWidth: 0.35 }),
      E('path', { d: 'M430 302l2 2 2-2', stroke: '#5b3d27', strokeWidth: 0.5, fill: 'none' }))]);
    draw.push([318, kBuilding(352, 318, 26, 'market', r, 'weigh', { fl: 2, wall: 'kg-wall-white', roof: 'kg-roof-teal' })]);
    draw.push([318.2, E('g', { key: 'scale' }, E('path', { d: 'M358 304h14M365 304v-3M359 304l-1.4 3h2.8zM371 304l-1.4 3h2.8z', stroke: '#5b3d27', strokeWidth: 0.5, fill: '#d8b55c' }))]);
    [[316, 406, '#d8b55c'], [455, 416, '#f3eee2'], [500, 300, null]].forEach(function (q, n) { draw.push([q[1], kCart(q[0], q[1], 'mc' + n, q[2])]); });
    for (i = 0; i < 9; i++) { var cx1 = 360 + (i % 3) * 3.6, cy1 = 402 - Math.floor(i / 3) * 3.2; draw.push([cy1, kCrate(cx1, cy1, 'kc' + i)]); }
    [[410, 404], [413.4, 405], [416.8, 404]].forEach(function (q, n) { draw.push([q[1], kBarrel(q[0], q[1], 'kb' + n)]); });
    // Alvilág: fogadó, sikátorok, rejtekhely, romos torony, lámpások
    var A = [];
    A.push(kShadow(474, 238, 62, 9, 'tsh'));
    A.push(kBuilding(474, 238, 62, 'slum', r, 'tavern', { fl: 3, wall: 'kg-wall-timber', roof: 'kg-roof-dark', sign: true }));
    A.push(E('rect', { key: 'tsign', x: 537, y: 216, width: 7, height: 5, fill: '#4a3a2a', stroke: K.o, strokeWidth: 0.35 }));
    A.push(E('path', { key: 'tsc', d: 'M539 219.8q1.6-2.6 3.2 0l-.6-2 .6-.8', stroke: '#d8b55c', strokeWidth: 0.5, fill: 'none' }));
    [[478, 222], [492, 222], [506, 216], [520, 222]].forEach(function (q, n) { A.push(E('circle', { key: 'tg' + n, cx: q[0] + 1, cy: q[1] + 1, r: 6, fill: 'url(#kg-glow)', opacity: 0.8 })); A.push(E('rect', { key: 'tw' + n, x: q[0], y: q[1], width: 2.4, height: 3, fill: '#f6cf6e', stroke: K.o, strokeWidth: 0.3 })); });
    draw.push([238, E('g', { key: 'tav' }, A)]);
    draw.push([241, E('g', { key: 'tavx' }, kBarrel(478, 242, 'tb1'), kBarrel(481.6, 243, 'tb2'), kBarrel(479.6, 239, 'tb3'), kCrate(530, 243, 'tc1'), kCrate(533.8, 244, 'tc2'))]);
    draw.push([180, E('g', { key: 'ruin' },
      kShadow(572, 184, 18, 6, 'rsh'),
      E('path', { d: 'M572 184v-30l4-4h10l4 5v29z', fill: 'url(#kg-stone-dark)', stroke: K.o, strokeWidth: 0.6 }),
      E('path', { d: 'M572 154l3 3 3-4 4 5 3-6 5 5', fill: 'none', stroke: K.o, strokeWidth: 0.5 }),
      E('path', { d: 'M579 170v-5a2 2 0 0 1 4 0v5zM579 182v-6a2 2 0 0 1 4 0v6z', fill: '#1a1416' }),
      E('path', { d: 'M586 160c2 4 1 10 3 14', stroke: '#4d6a34', strokeWidth: 1.2, fill: 'none', opacity: 0.8 }))]);
    draw.push([146, E('g', { key: 'hide' },
      E('path', { d: 'M452 146h26v-8h-26z', fill: '#3a2e2a', stroke: K.o, strokeWidth: 0.4 }),
      E('path', { d: 'M450 138c6-4 22-4 30 0l-2 3c-8-2-18-2-26 0z', fill: '#4a5a4a', stroke: K.o, strokeWidth: 0.35 }),
      kCrate(456, 146, 'hc1'), kCrate(460, 146, 'hc2'), kBarrel(468, 146, 'hb1'))]);
    // Farmok (nyugat), bánya (északnyugat), gyümölcsös (dél)
    var F = [];
    F.push(kFields(4, 150, 5, 4, 20, 14, 'a', 'farm1'));
    F.push(kFields(4, 360, 5, 4, 20, 12, 'b', 'farm2'));
    F.push(E('path', { key: 'past', d: 'M4 214h100v62H4z', fill: '#a9c173', stroke: '#6b4a30', strokeWidth: 0.8, strokeDasharray: '2 1' }));
    F.push(E('ellipse', { key: 'pond', cx: 24, cy: 262, rx: 10, ry: 4.5, fill: 'url(#kg-water)', stroke: '#6b8a5a', strokeWidth: 1 }));
    draw.push([150, E('g', { key: 'farms' }, F)]);
    draw.push([2, kFields(170, 4, 5, 3, 20, 12, 'n1', 'fn1')]);
    draw.push([2, kFields(440, 2, 6, 2, 22, 13, 'n2', 'fn2')]);
    draw.push([496, kFields(196, 498, 5, 3, 22, 13, 'sw', 'fs1')]);
    draw.push([496, kFields(432, 500, 5, 3, 22, 12, 'se', 'fs2')]);
    draw.push([420, kFields(4, 440, 4, 3, 22, 13, 'w3', 'fw3')]);
    [[16, 232], [34, 240, 1], [52, 228], [70, 250, 1], [44, 256], [88, 236]].forEach(function (q, n) { draw.push([q[1], kAnimal(q[0], q[1], n % 3 === 1 ? 'sheep' : 'cow', 'an' + n, q[2])]); });
    [[62, 268], [66, 270], [70, 267], [58, 272]].forEach(function (q, n) { draw.push([q[1], kAnimal(q[0], q[1], 'sheep', 'sh' + n, n % 2)]); });
    draw.push([214, E('g', { key: 'barn' },
      kShadow(56, 214, 34, 8, 'bsh'),
      E('path', { d: 'M90 214l8-4v-16l-8 4z', fill: 'url(#kg-barn)', stroke: K.o, strokeWidth: 0.4 }), E('path', { d: 'M90 214l8-4v-16l-8 4z', fill: '#000', opacity: 0.25 }),
      E('rect', { x: 56, y: 196, width: 34, height: 18, fill: 'url(#kg-barn)', stroke: K.o, strokeWidth: 0.5 }),
      E('path', { d: 'M56 196L73 184L90 196z', fill: 'url(#kg-barn)', stroke: K.o, strokeWidth: 0.5 }),
      E('path', { d: 'M73 184l8-4 17 14-8 4z', fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.4 }),
      E('path', { d: 'M66 214v-11h14v11zM66 203l14 11M80 203l-14 11', fill: '#7a2e22', stroke: '#f3eee2', strokeWidth: 0.7 }),
      E('path', { d: 'M70 194h6v-4h-6z', fill: '#3a3130', stroke: '#f3eee2', strokeWidth: 0.5 }),
      E('path', { d: 'M56 196L73 184L90 196', fill: 'none', stroke: '#f3eee2', strokeWidth: 0.7 }))]);
    draw.push([214, E('g', { key: 'silo' }, E('rect', { x: 100, y: 188, width: 9, height: 26, rx: 1, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.45 }), E('path', { d: 'M99.5 188a5 4 0 0 1 10 0z', fill: 'url(#kg-roof-slate)', stroke: K.o, strokeWidth: 0.4 }), E('path', { d: 'M100 196h9M100 204h9', stroke: '#9d8e74', strokeWidth: 0.4 }))]);
    draw.push([300, kBuilding(20, 300, 26, 'farm', r, 'fh1', { fl: 1 })]);
    draw.push([352, kBuilding(60, 352, 22, 'farm', r, 'fh2', { fl: 1 })]);
    [[40, 330], [48, 334], [90, 330]].forEach(function (q, n) { draw.push([q[1], E('g', { key: 'hay' + n }, E('path', { d: 'M' + (q[0] - 4) + ' ' + q[1] + 'q4-9 8 0z', fill: 'url(#kg-roof-thatch)', stroke: K.o, strokeWidth: 0.35 }))]); });
    draw.push([318, E('g', { key: 'scare' }, E('path', { d: 'M84 318v-9M80 312h8', stroke: '#6b4a30', strokeWidth: 0.7 }), E('circle', { cx: 84, cy: 308, r: 1.3, fill: '#d8b55c', stroke: K.o, strokeWidth: 0.25 }), E('path', { d: 'M82 311h4v4h-4z', fill: '#8c3a2c' }))]);
    [[30, 288], [36, 290], [42, 287]].forEach(function (q, n) { draw.push([q[1], kAnimal(q[0], q[1], 'chicken', 'ck' + n)]); });
    // Bánya: sziklateraszok, akna, sín, csille, daru, érckupac
    var Q = [];
    (function () {
      var qr = rng('k3q' + name), lv = [[[0, 104], [40, 98], [86, 86], [128, 64], [164, 34], [186, 0]], [[0, 76], [44, 70], [84, 58], [116, 40], [142, 16], [152, 0]], [[0, 48], [38, 42], [72, 32], [100, 16], [114, 0]], [[0, 22], [30, 18], [56, 8], [66, 0]]];
      lv.forEach(function (L, n) {
        var J = k3Jag(L, 5, qr), top = 'M0 0' + J.map(function (q) { return 'L' + q[0].toFixed(1) + ' ' + q[1].toFixed(1); }).join('') + 'Z', face = 'M0 0' + J.map(function (q) { return 'L' + q[0].toFixed(1) + ' ' + (q[1] + 9).toFixed(1); }).join('') + 'L' + J[J.length - 1][0] + ' 0Z';
        Q.push(E('path', { key: 'qs' + n, d: face, fill: '#2c1f13', opacity: 0.35, filter: 'url(#kg-blur)', transform: 'translate(3 3)' }));
        Q.push(E('path', { key: 'qf' + n, d: face, fill: 'url(#kg-rock-dark)', stroke: K.o, strokeWidth: 0.5 }));
        Q.push(E('path', { key: 'qc' + n, d: J.filter(function (q, i) { return i % 2; }).map(function (q) { return 'M' + q[0].toFixed(1) + ' ' + (q[1] + 1).toFixed(1) + 'l' + ((qr() - 0.5) * 2).toFixed(1) + ' ' + (5 + qr() * 3).toFixed(1); }).join(''), stroke: '#4a3d30', strokeWidth: 0.5, opacity: 0.8 }));
        Q.push(E('path', { key: 'qt' + n, d: top, fill: 'url(#kg-rock)', stroke: K.o, strokeWidth: 0.5 }));
        Q.push(E('path', { key: 'ql' + n, d: 'M' + J.map(function (q) { return q[0].toFixed(1) + ' ' + (q[1] - 1.2).toFixed(1); }).join('L'), stroke: '#efe4cc', strokeWidth: 0.8, fill: 'none', opacity: 0.6 }));
        for (var b = 0; b < 5; b++) { var q0 = J[Math.floor(qr() * J.length)], bx = q0[0] - 6 - qr() * 14, by = q0[1] - 3 - qr() * 6; if (bx > 2 && by > 2) Q.push(E('path', { key: 'bo' + n + b, d: 'M' + bx.toFixed(1) + ' ' + by.toFixed(1) + 'l1.4-2.4h3l1.4 2.4z', fill: 'url(#kg-rock-dark)', stroke: K.o, strokeWidth: 0.3 })); }
      });
      [[10, 12], [22, 8], [34, 12], [8, 30], [44, 4]].forEach(function (q, n) { Q.push(kTree(q[0], q[1], 3.2, 'qp' + n, true)); });
      Q.push(E('path', { key: 'dust', d: 'M92 100c6-4 14-4 20 0', stroke: '#e8dcc4', strokeWidth: 4, opacity: 0.35, filter: 'url(#kg-fog)', fill: 'none' }));
    })();
    Q.push(E('path', { key: 'mine', d: 'M58 104v-9a6 6 0 0 1 12 0v9z', fill: '#150f0c', stroke: K.o, strokeWidth: 0.4 }));
    Q.push(E('path', { key: 'mfr', d: 'M56.8 104V93h14.4v11M56 93.4h16', fill: 'none', stroke: '#6b4a30', strokeWidth: 1.4 }));
    Q.push(E('circle', { key: 'mlg', cx: 74, cy: 94, r: 5, fill: 'url(#kg-glow)' }));
    Q.push(E('path', { key: 'mll', d: 'M73 94h2v2.4h-2z', fill: '#f4d27a', stroke: K.o, strokeWidth: 0.25 }));
    Q.push(E('path', { key: 'rails', d: 'M62 104C74 112 88 118 104 126M67 104C80 110 92 115 108 123', stroke: '#5e6b72', strokeWidth: 0.7, fill: 'none' }));
    (function () { var tt = []; for (var t = 0; t < 8; t++) { var x = 66 + t * 5, y = 107 + t * 2.3; tt.push('M' + (x - 2) + ' ' + (y + 1) + 'l5 -2.4'); } Q.push(E('path', { key: 'ties', d: tt.join(''), stroke: '#6b4a30', strokeWidth: 0.8 })); })();
    Q.push(E('g', { key: 'cart', transform: 'translate(88 118) rotate(24)' }, E('path', { d: 'M-4-4h8l-1 4h-6z', fill: 'url(#kg-stone-dark)', stroke: K.o, strokeWidth: 0.4 }), E('path', { d: 'M-3.4-4.6c1-1.4 5.8-1.4 6.8 0z', fill: '#4a4040' }), E('circle', { cx: -2, cy: 0.4, r: 1, fill: '#3a3130' }), E('circle', { cx: 2, cy: 0.4, r: 1, fill: '#3a3130' })));
    Q.push(E('path', { key: 'ore1', d: 'M100 132c2-8 16-10 22-2 2 2 2 4 0 5h-22z', fill: '#4a4448', stroke: K.o, strokeWidth: 0.4 }));
    Q.push(E('path', { key: 'ore2', d: 'M104 128l1-1M110 126l1 .6M116 128l.8-.8', stroke: '#d8c070', strokeWidth: 0.7 }));
    Q.push(E('path', { key: 'crane', d: 'M98 84L108 50L118 84M102 72h12M108 50l20 8M128 58v16', fill: 'none', stroke: '#6b4a30', strokeWidth: 1.2 }));
    Q.push(E('rect', { key: 'crl', x: 125.5, y: 74, width: 5, height: 4, fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.3 }));
    draw.push([60, E('g', { key: 'quarry' }, Q)]);
    draw.push([132, kBuilding(20, 132, 20, 'farm', r, 'mshed', { fl: 1, roof: 'kg-roof-brown', wall: 'kg-wall-timber' })]);
    [[80, 110, '#6b5a4a'], [110, 118, '#6b5a4a'], [128, 126, '#8c3a2c'], [48, 112, '#6b5a4a'], [52, 70, '#6b5a4a'], [96, 50, '#6b5a4a']].forEach(function (q, n) { people.push([q[0], q[1], q[2], false]); });
    for (i = 0; i < 4; i++) for (var j = 0; j < 3; j++) draw.push([492 + j * 12, kTree(108 + i * 16 + (j % 2) * 6, 492 + j * 12, 3.4, 'or' + i + j)]);
    draw.push([36, Windmill3(292, 36, 'wm1')]);
    [[588, 22, 0], [600, 40, 1], [620, 26, 0], [636, 44, 1], [650, 70, 0], [160, 56, 1], [300, 58, 0], [96, 476, 1], [180, 470, 0], [590, 510, 0], [604, 526, 1], [620, 496, 0], [640, 470, 1], [654, 430, 0], [660, 400, 1], [600, 440, 0], [612, 452, 1], [590, 460, 0], [626, 420, 0], [560, 478, 1], [634, 486, 0], [648, 456, 1], [120, 420, 0], [136, 434, 1], [150, 530, 0], [312, 536, 1], [572, 482, 1]].forEach(function (q, n) { draw.push([q[1], kTree(q[0], q[1], 4 + (n % 3), 'ft' + n, q[2])]); });
    draw.push([520, E('g', { key: 'pen' }, E('path', { d: 'M328 500h40v24h-40z', fill: '#b6c27a', stroke: '#6b4a30', strokeWidth: 0.8, strokeDasharray: '1.6 1' }))]);
    [[334, 510, 'sheep'], [342, 516, 'sheep'], [352, 508, 'pig'], [360, 518, 'sheep'], [346, 506, 'pig']].forEach(function (q, n) { draw.push([q[1], kAnimal(q[0], q[1], q[2], 'pen' + n, n % 2)]); });
    // Tömeg
    ST3.concat(LN3).forEach(function (s, si) { for (var k2 = 0; k2 < 14; k2++) { var seg = Math.floor(pr() * (s.length - 1)), t = pr(), a = s[seg], b = s[seg + 1]; people.push([a[0] + (b[0] - a[0]) * t + (pr() - 0.5) * 6, a[1] + (b[1] - a[1]) * t + (pr() - 0.5) * 5, CLOTH[Math.floor(pr() * CLOTH.length)], inPoly(a[0], a[1], D3.katonasag.poly) && pr() < 0.6]); } });
    for (i = 0; i < 50; i++) people.push([304 + pr() * 170, 348 + pr() * 58, CLOTH[Math.floor(pr() * CLOTH.length)], false]);
    people.forEach(function (q, n) { draw.push([q[1], kFig(q[0], q[1], q[2], 'pp' + n, 1, q[3])]); });
    // Falak és tornyok a festő-rendezésbe
    W3.forEach(function (q, n) { if (G3.some(function (g) { return g[0] === q[0] && g[1] === q[1]; })) return; draw.push([q[1] + 6, Tower3(q[0], q[1], n % 3 === 0, 'tw' + n)]); });
    G3.forEach(function (g, n) { draw.push([g[1] + 7, Gate3(g[0], g[1], 'gt' + n)]); });
    draw.sort(function (a, b) { return a[0] - b[0]; });
    var wallPts = k3Poly(W3), sea = 'M668 0C650 90 690 150 668 230C652 300 690 380 672 450C664 490 676 520 670 540H720V0Z';
    function dom(k) { return d[k] || {}; }
    return h('svg', { className: 'tn-city-view', viewBox: '0 0 720 540', role: 'img', 'aria-label': name + ' látképe' },
      h(PaintDefs, null),
      h('defs', null, h('radialGradient', { id: gid, cx: '48%', cy: '42%', r: '75%' }, h('stop', { offset: '0%', stopColor: '#bccd8e' }), h('stop', { offset: '100%', stopColor: '#93ab66' })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '70%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.34 }))),
      h('rect', { width: 720, height: 540, fill: 'url(#' + gid + ')' }),
      h('g', { filter: 'url(#kg-blur-lg)', opacity: 0.55 }, groundPatches('k3g' + name, 720, 540, 60)),
      h('path', { d: tufts('k3t' + name, 720, 540, 700), stroke: 'var(--map-tuft)', strokeWidth: 0.5, fill: 'none', strokeLinecap: 'round', opacity: 0.6 }),
      flowers('k3f' + name, 720, 540, 120),
      p.coast ? h(Ripples, { d: sea }) : h('g', null, h('path', { d: 'M696 0C676 100 706 180 686 270C671 340 706 430 696 540', fill: 'none', stroke: 'var(--map-sand)', strokeWidth: 20, strokeLinecap: 'round' }), h('path', { d: 'M696 0C676 100 706 180 686 270C671 340 706 430 696 540', fill: 'none', stroke: 'url(#kg-water)', strokeWidth: 14 }), h('path', { d: 'M696 0C676 100 706 180 686 270C671 340 706 430 696 540', fill: 'none', stroke: '#e8f1ec', strokeWidth: 0.7, strokeDasharray: '6 9', opacity: 0.8 })),
      G3.map(function (g, n) { var dx = g[0] - 380, dy = g[1] - 280, L = Math.hypot(dx, dy), ex = g[0] + dx / L * 140, ey = g[1] + dy / L * 140, dd = 'M' + g[0] + ' ' + g[1] + 'L' + ex.toFixed(0) + ' ' + ey.toFixed(0); return h('g', { key: 'or' + n }, h('path', { d: dd, stroke: '#a8895a', strokeWidth: 13, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--map-road)', strokeWidth: 10.5, strokeLinecap: 'round' }), h('path', { d: dd, stroke: '#a8895a', strokeWidth: 0.5, strokeDasharray: '1 3', transform: 'translate(2 0)' })); }),
      h('polygon', { points: wallPts, fill: 'none', stroke: '#3f7d92', strokeWidth: 34, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'url(#kg-water)', strokeWidth: 30, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: '#e8f1ec', strokeWidth: 0.7, strokeDasharray: '8 10', strokeLinejoin: 'round', transform: 'translate(0 9)', opacity: 0.6 }),
      h('polygon', { points: wallPts, fill: '#d9c9a2' }),
      h('polygon', { points: k3Poly(D3.katonasag.poly), fill: '#8f8272', opacity: 0.55 }),
      h('path', { d: tufts('k3c' + name, 720, 540, 900).replace(/l\.7-2\.1l\.7 2\.1l\.6-1\.5/g, 'h1.2'), stroke: '#a8957a', strokeWidth: 0.9, strokeLinecap: 'round', opacity: 0.35, clipPath: undefined }),
      ST3.map(function (s, n) { return h('g', { key: 'st' + n }, h('path', { d: k3Line(s), stroke: '#a8895a', strokeWidth: 15, strokeLinecap: 'round', strokeLinejoin: 'round', fill: 'none', opacity: 0.7 }), h('path', { d: k3Line(s), stroke: '#dcc79a', strokeWidth: 13, strokeLinecap: 'round', strokeLinejoin: 'round', fill: 'none' }), h('path', { d: k3Line(s), stroke: '#b8a47c', strokeWidth: 11, strokeDasharray: '1.2 2', strokeLinejoin: 'round', fill: 'none', opacity: 0.6 })); }),
      LN3.map(function (s, n) { return h('path', { key: 'ln' + n, d: k3Line(s), stroke: n > 1 && n < 5 ? '#6f6258' : '#cdb98f', strokeWidth: 7, strokeLinecap: 'round', strokeLinejoin: 'round', fill: 'none', opacity: 0.9 }); }),
      sel && D3[sel] ? h('polygon', { points: k3Poly(D3[sel].poly), className: 'tn-cv-sel' }) : null,
      h('polygon', { points: wallPts, fill: 'none', stroke: '#3d2b1c', strokeWidth: 11, strokeLinejoin: 'round', strokeOpacity: 0.7 }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'url(#kg-stone)', strokeWidth: 9.5, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: '#9d8e74', strokeWidth: 2.4, strokeLinejoin: 'round', transform: 'translate(0 3)', opacity: 0.6 }),
      h('path', { d: crenels(W3), fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.3, transform: 'translate(0 -1)' }),
      draw.map(function (x) { return x[1]; }),
      // Alvilág sötét hangulata
      h('g', { pointerEvents: 'none' },
        h('polygon', { points: k3Poly(D3.katonasag.poly), fill: 'url(#kg-dusk)' }),
        h('ellipse', { cx: 520, cy: 190, rx: 90, ry: 40, fill: '#6f6878', opacity: 0.22, filter: 'url(#kg-fog)' }),
        [[478, 222], [506, 216], [466, 150], [540, 186], [596, 230], [420, 120]].map(function (q, n) { return h('circle', { key: 'lg' + n, cx: q[0], cy: q[1], r: 10, fill: 'url(#kg-glow)', opacity: 0.75 }); })),
      p.coast ? h('g', null,
        [[640, 196, 700, 200], [640, 262, 704, 272], [632, 330, 694, 344]].map(function (q, n) { var dd = 'M' + q[0] + ' ' + q[1] + 'L' + q[2] + ' ' + q[3]; return h('g', { key: 'pier' + n }, h('path', { d: dd, stroke: '#2c1f13', strokeWidth: 9, opacity: 0.3, transform: 'translate(2 2)' }), h('path', { d: dd, stroke: '#4a321f', strokeWidth: 8 }), h('path', { d: dd, stroke: '#b8834f', strokeWidth: 6.4 }), h('path', { d: dd, stroke: '#7d5230', strokeWidth: 6.4, strokeDasharray: '0.6 2' })); }),
        h('g', { transform: 'translate(700 236) scale(1.6)' }, h(Ship, { x: 0, y: 0 })), h('g', { transform: 'translate(690 310) scale(1.3)' }, h(Ship, { x: 0, y: 0 })), h('g', { transform: 'translate(706 150) scale(1.1)' }, h(Ship, { x: 0, y: 0 })),
        kCrate(656, 262, 'hk1'), kCrate(660, 262, 'hk2'), kBarrel(666, 264, 'hb1'), kFig(672, 268, CLOTH[1], 'hp1'), kFig(650, 334, CLOTH[3], 'hp2')) : null,
      Object.keys(D3).map(function (k) {
        var Dd = D3[k], v = dom(k), f = Dd.flag;
        return h('g', { key: 'fl' + k },
          v.contested ? h(Pennant, { x: f[0] + 14, y: f[1] + 4, tincture: v.contested }) : null,
          v.dominant ? h(Pennant, { x: f[0], y: f[1], tincture: v.dominant }) : null,
          h('text', { x: Dd.label[0], y: Dd.label[1], textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, Dd.name));
      }),
      stab === 'lazongo' ? [[172, 392], [540, 300], [240, 150]].map(function (q, n) { return h(Flame, { key: 'fx' + n, x: q[0], y: q[1] }); }) : null,
      h('rect', { width: 720, height: 540, filter: 'url(#kg-grain)', opacity: 0.4, pointerEvents: 'none' }),
      h('rect', { width: 720, height: 540, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      p.onSelect ? Object.keys(D3).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: k3Poly(D3[k].poly), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': D3[k].name, 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }
  function Tower3(x, y, big, k) {
    var w = big ? 20 : 16, hh = big ? 26 : 20;
    return E('g', { key: k },
      kShadow(x - w / 2, y + 6, w, 4, 's'),
      E('rect', { x: x - w / 2, y: y + 6 - hh, width: w, height: hh, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }),
      E('rect', { x: x + w * 0.1, y: y + 6 - hh, width: w * 0.4, height: hh, fill: '#000', opacity: 0.14 }),
      E('path', { d: 'M' + (x - w / 2) + ' ' + (y + 6 - hh * 0.5) + 'h' + w + 'M' + (x - w / 2) + ' ' + (y + 1) + 'h' + w, stroke: '#9d8e74', strokeWidth: 0.4 }),
      E('path', { d: 'M' + (x - 1) + ' ' + (y + 6 - hh * 0.62) + 'v-3.6a1 1 0 0 1 2 0v3.6z', fill: '#f4d27a', stroke: K.o, strokeWidth: 0.3 }),
      E('path', { d: 'M' + (x - w / 2 - 2) + ' ' + (y + 6 - hh) + 'L' + x + ' ' + (y + 6 - hh - w * 1.05) + 'L' + (x + w / 2 + 2) + ' ' + (y + 6 - hh) + 'z', fill: 'url(#kg-roof-red)', stroke: K.o, strokeWidth: 0.6 }),
      E('path', { d: 'M' + x + ' ' + (y + 6 - hh - w * 1.05) + 'L' + (x + w / 2 + 2) + ' ' + (y + 6 - hh) + 'H' + x + 'z', fill: '#000', opacity: 0.2 }),
      E('path', { d: 'M' + (x - w * 0.36) + ' ' + (y + 6 - hh - w * 0.3) + 'h' + (w * 0.72) + 'M' + (x - w * 0.2) + ' ' + (y + 6 - hh - w * 0.6) + 'h' + (w * 0.4), stroke: '#000', strokeOpacity: 0.22, strokeWidth: 0.4 }),
      big ? E('g', null, E('path', { d: 'M' + x + ' ' + (y + 6 - hh - w * 1.05) + 'v-7', stroke: K.o, strokeWidth: 0.6 }), E('path', { d: 'M' + x + ' ' + (y - hh - w * 1.05 - 1) + 'c2.6-1 4.8 1 7.4 0l-1.6 2 1.6 2c-2.6 1-4.8-1-7.4 0z', fill: 'var(--house-voros)', stroke: K.o, strokeWidth: 0.3 })) : null);
  }
  function Gate3(x, y, k) {
    return E('g', { key: k },
      kShadow(x - 14, y + 8, 28, 6, 's'),
      E('rect', { x: x - 14, y: y - 12, width: 28, height: 20, fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.6 }),
      E('path', { d: 'M' + (x - 14) + ' ' + (y - 12) + 'v-3h3v3h3v-3h3v3h3v-3h3v3h3v-3h3v3h3v-3h3v3h2v-3', fill: 'url(#kg-stone)', stroke: K.o, strokeWidth: 0.45 }),
      E('path', { d: 'M' + (x - 5.5) + ' ' + (y + 8) + 'v-8a5.5 5.5 0 0 1 11 0v8z', fill: '#1d1614' }),
      E('path', { d: 'M' + (x - 3) + ' ' + (y - 3) + 'v11M' + x + ' ' + (y - 5) + 'v13M' + (x + 3) + ' ' + (y - 3) + 'v11M' + (x - 5.2) + ' ' + y + 'h10.4M' + (x - 5.4) + ' ' + (y + 4) + 'h10.8', stroke: '#6f6352', strokeWidth: 0.55 }),
      E('rect', { x: x - 11, y: y - 8, width: 2.2, height: 3.4, fill: '#3a3130' }), E('rect', { x: x + 8.8, y: y - 8, width: 2.2, height: 3.4, fill: '#3a3130' }),
      E('rect', { x: x - 3, y: y - 11, width: 6, height: 4, fill: 'var(--house-voros)', stroke: K.o, strokeWidth: 0.3 }),
      kFig(x - 8, y + 10, 'var(--btn-red)', 'g1'), kFig(x + 8, y + 10, 'var(--btn-red)', 'g2'));
  }
  function Windmill3(x, y, k) {
    var bl = [];
    for (var i = 0; i < 4; i++) bl.push(E('g', { key: i, transform: 'rotate(' + (24 + i * 90) + ')' }, E('path', { d: 'M0 0v-15', stroke: '#5b3d27', strokeWidth: 0.7 }), E('rect', { x: 0.2, y: -15, width: 3, height: 11, fill: '#f3ead3', stroke: K.o, strokeWidth: 0.3 }), E('path', { d: 'M.2-12h3M.2-9h3M.2-6h3', stroke: '#b89a66', strokeWidth: 0.3 })));
    return E('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' },
      kShadow(-5, 0, 10, 4, 's'),
      E('path', { d: 'M-5 0l1.6-16h6.8L5 0z', fill: 'url(#kg-wall-white)', stroke: K.o, strokeWidth: 0.5 }),
      E('path', { d: 'M1.5-16L5 0H2.6z', fill: '#000', opacity: 0.14 }),
      E('path', { d: 'M-4-16l4-5 4 5z', fill: 'url(#kg-roof-brown)', stroke: K.o, strokeWidth: 0.45 }),
      E('path', { d: 'M-1 0v-4a1 1 0 0 1 2 0v4z', fill: '#5b3d27' }),
      E('g', { transform: 'translate(0 -17)' }, bl, E('circle', { r: 1, fill: '#5b3d27' })));
  }
