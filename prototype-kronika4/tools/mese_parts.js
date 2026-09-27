/*@@HouseCrest*/
  function HouseCrest(p) {
    var size = p.size || 28, fill = tint(p.tincture);
    return h('svg', { className: 'tn-crest', width: size, height: size * 1.12, viewBox: '0 0 26 29', role: 'img', 'aria-label': (p.name || 'Ház') + (p.npc ? ' (NPC)' : '') },
      h('path', { d: 'M2 2.5h22v10.2c0 7-5.3 11.4-11 14.3C7.3 24.1 2 19.7 2 12.7z', fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 1.8, strokeLinejoin: 'round' }),
      h('path', { d: 'M5 5.3h16v7.3c0 5.2-3.8 8.6-8 10.9-4.2-2.3-8-5.7-8-10.9z', fill: fill, stroke: 'var(--outline)', strokeWidth: 1, strokeDasharray: p.npc ? '2 1.6' : undefined }),
      h('path', { d: 'M6.8 7.2h5.2c-.6 3.6-2.4 6.2-5.2 7.6z', fill: '#ffffff', opacity: 0.35 }),
      p.initial ? h('text', { className: 'tn-crest-initial', x: 13, y: 17, textAnchor: 'middle', fontSize: 10.5 }, p.initial) : null);
  }
/*@@MapCanvas*/
  function MapCanvas(p) {
    var w = p.width || 360, hh = p.height || 240, gid = useUid('g'), r = rng('mc' + (p.title || '')), blobs = [];
    for (var i = 0; i < 9; i++) blobs.push([r() * w, r() * hh, 18 + r() * 34, 8 + r() * 14]);
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h('defs', null, h('radialGradient', { id: gid, cx: '45%', cy: '40%', r: '75%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' }))),
      h('rect', { width: w, height: hh, fill: 'url(#' + gid + ')' }),
      h('g', { 'aria-hidden': true }, blobs.map(function (b, i) { return h('ellipse', { key: i, cx: b[0], cy: b[1], rx: b[2], ry: b[3], fill: i % 3 ? 'var(--map-grass-hi)' : 'var(--map-grass-lo)', opacity: i % 3 ? 0.55 : 0.22 }); })),
      p.children);
  }
/*@@MapRoute*/
  function MapRoute(p) {
    var a = p.from, b = p.to, st = p.state || 'base', mx = (a[0] + b[0]) / 2, my = (a[1] + b[1]) / 2;
    var ang = Math.atan2(b[1] - a[1], b[0] - a[0]) + Math.PI / 2, dx = Math.cos(ang) * 8, dy = Math.sin(ang) * 8;
    var L = { x1: a[0], y1: a[1], x2: b[0], y2: b[1] };
    function ln(cls, style) { return h('line', Object.assign({ className: 'tn-route ' + cls, style: style }, L)); }
    return h('g', { className: 'tn-route-g tn-route-g-' + st },
      ln('tn-route-edge'),
      ln('tn-route-' + st, st === 'rival' ? { stroke: tint(p.tincture) } : undefined),
      st === 'own' ? ln('tn-route-dash') : null,
      st === 'blocked' ? h('g', null, h('circle', { className: 'tn-block-mark', cx: mx, cy: my, r: 8 }), h('line', { x1: mx - dx * .6, y1: my - dy * .6, x2: mx + dx * .6, y2: my + dy * .6, stroke: '#ffffff', strokeWidth: 3, strokeLinecap: 'round' })) : null);
  }
/*@@STAB_MARK*/
  var STAB_MARK = { stabil: '', ingatag: '!', lazongo: '!!' };
  function castle(s, roof, key) {
    var o = [], W = 'var(--stone)', D = 'var(--outline)';
    function el(t, a) { o.push(h(t, Object.assign({ key: o.length, stroke: D, strokeWidth: 1.4 / s, strokeLinejoin: 'round' }, a))); }
    el('ellipse', { cx: 0, cy: 7, rx: 15, ry: 4, fill: '#00000033', stroke: 'none' });
    el('rect', { x: -12, y: -7, width: 7, height: 14, fill: W });
    el('rect', { x: 5, y: -7, width: 7, height: 14, fill: W });
    el('path', { d: 'M-13.2-7L-8.5-17L-3.8-7z', fill: roof });
    el('path', { d: 'M3.8-7L8.5-17L13.2-7z', fill: roof });
    el('path', { d: 'M-6-3h12v10H-6z', fill: 'var(--paper-raised)' });
    el('path', { d: 'M-6-3v-3h2.4v2h2.4v-2h2.4v2h2.4v-2H6v3z', fill: 'var(--paper-raised)' });
    el('path', { d: 'M-2.2 7v-4a2.2 2.2 0 0 1 4.4 0v4z', fill: 'var(--ic-brown)' });
    if (key) {
      el('rect', { x: -3.5, y: -16, width: 7, height: 10, fill: W });
      el('path', { d: 'M-4.6-16L0-25.5L4.6-16z', fill: 'var(--frame)' });
      el('path', { d: 'M0-25.5v-5', fill: 'none' });
      el('path', { d: 'M0-30.5h6l-1.6 1.6L6-27.3H0z', fill: 'var(--roof-red)', strokeWidth: 0.9 / s });
    }
    el('path', { d: 'M-10.5-4.5h2.5M6.5-4.5H9', fill: 'none', stroke: '#ffffff', strokeWidth: 1 / s, opacity: 0.8 });
    return o;
  }
/*@@MapCity*/
  function MapCity(p) {
    var st = p.state || 'reachable', s = p.keyCity ? 1.05 : 0.85, ly = p.keyCity ? 20 : 17;
    var roof = st === 'cut' ? 'var(--danger)' : st === 'unreachable' ? 'var(--stone-lo)' : 'var(--roof-blue)';
    return h('g', { className: cx('tn-city', 'tn-city-' + st, p.keyCity && 'tn-city-key'), transform: 'translate(' + p.x + ' ' + p.y + ')' },
      st === 'reachable' ? h('ellipse', { className: 'tn-city-halo', cx: 0, cy: 5, rx: 22, ry: 9 }) : null,
      st === 'cut' ? h('ellipse', { cx: 0, cy: 5, rx: 22, ry: 9, fill: 'none', stroke: 'var(--danger)', strokeWidth: 2.5, strokeDasharray: '4 3' }) : null,
      h('g', { transform: 'scale(' + s + ')', className: 'tn-city-art' }, castle(s, roof, p.keyCity)),
      h('text', { className: 'tn-city-label', x: 0, y: ly, textAnchor: 'middle' }, p.name),
      p.stability && STAB_MARK[p.stability] ? h('g', { transform: 'translate(12 ' + (p.keyCity ? -30 : -22) + ')' }, h('circle', { r: 7, className: 'tn-stab-bubble tn-stab-' + p.stability }), h('text', { className: 'tn-city-stab', y: 4, textAnchor: 'middle' }, STAB_MARK[p.stability])) : null);
  }
/*@@MapEstate*/
  function MapEstate(p) {
    return h('g', { className: 'tn-estate-g', transform: 'translate(' + p.x + ' ' + p.y + ')' },
      h('ellipse', { cx: 0, cy: 6, rx: 11, ry: 3.4, fill: '#00000030' }),
      h('path', { d: 'M-9 6l9-13 9 13z', fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }),
      h('path', { d: 'M0-7L-3 6h6z', fill: tint(p.tincture), stroke: 'var(--outline)', strokeWidth: 1.1, strokeLinejoin: 'round' }),
      h('path', { d: 'M0-7v-10', stroke: 'var(--outline)', strokeWidth: 1.5, strokeLinecap: 'round' }),
      h('path', { d: 'M0-17h9l-2.5 2.6L9-11.8H0z', fill: tint(p.tincture), stroke: 'var(--outline)', strokeWidth: 1.1, strokeLinejoin: 'round', strokeDasharray: p.npc ? '2 1.4' : undefined }),
      p.name ? h('text', { className: 'tn-city-label', x: 0, y: 19, textAnchor: 'middle', style: { fontSize: 11 } }, p.name) : null);
  }
/*@@Ripples*/
  function Ripples(p) {
    var cid = useUid('sea'), r = rng('w' + p.d.length), waves = [];
    for (var y = 8; y < 300; y += 16) for (var x = 6 + (y % 32 ? 10 : 0); x < 380; x += 26) waves.push([x + (r() - 0.5) * 8, y + (r() - 0.5) * 5]);
    return h('g', null,
      h('clipPath', { id: cid }, h('path', { d: p.d })),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sand)', strokeWidth: 12, strokeLinejoin: 'round' }),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--outline)', strokeWidth: 14.5, strokeLinejoin: 'round', opacity: 0.25 }),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sand)', strokeWidth: 12, strokeLinejoin: 'round' }),
      h('path', { className: 'tn-sea', d: p.d }),
      h('g', { clipPath: 'url(#' + cid + ')' },
        h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea-hi)', strokeWidth: 18, opacity: 0.9 }),
        h('path', { d: p.d, fill: 'none', stroke: '#ffffff', strokeWidth: 4, opacity: 0.85 }),
        waves.map(function (q, i) { return h('path', { key: i, d: 'M' + q[0].toFixed(1) + ' ' + q[1].toFixed(1) + 'q3-3 6 0t6 0', fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 1.4, strokeLinecap: 'round', opacity: 0.75 }); })),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--outline)', strokeWidth: 1.6, opacity: 0.55 }));
  }
/*@@Mountain*/
  function Mountain(p) {
    var s = p.s || 1, x = p.x, y = p.y, w = 12 * s, ht = 15 * s;
    var peak = 'M' + (x - w) + ' ' + y + 'L' + (x - 1.5 * s) + ' ' + (y - ht + 1.2 * s) + 'Q' + x + ' ' + (y - ht - 0.8 * s) + ' ' + (x + 1.5 * s) + ' ' + (y - ht + 1.2 * s) + 'L' + (x + w) + ' ' + y + 'Z';
    var shade = 'M' + x + ' ' + (y - ht + 0.4 * s) + 'L' + (x + w) + ' ' + y + 'H' + (x + 2 * s) + 'Z';
    var snow = 'M' + (x - 4.6 * s) + ' ' + (y - ht * 0.58) + 'L' + (x - 1.5 * s) + ' ' + (y - ht + 1.2 * s) + 'Q' + x + ' ' + (y - ht - 0.8 * s) + ' ' + (x + 1.5 * s) + ' ' + (y - ht + 1.2 * s) + 'L' + (x + 4.8 * s) + ' ' + (y - ht * 0.58) + 'l' + (-2.2 * s) + ' ' + (1.6 * s) + 'l' + (-1.6 * s) + ' ' + (-1.4 * s) + 'l' + (-1.8 * s) + ' ' + (1.8 * s) + 'l' + (-1.4 * s) + ' ' + (-1.6 * s) + 'z';
    return h('g', null,
      h('ellipse', { cx: x + 1, cy: y + 1, rx: w + 1, ry: 2.6 * s, fill: '#00000026' }),
      h('path', { d: peak, fill: 'var(--map-rock)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }),
      h('path', { d: shade, fill: 'var(--map-rock-lo)', opacity: 0.8 }),
      h('path', { d: snow, fill: 'var(--map-snow)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('path', { d: peak, fill: 'none', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }));
  }
/*@@Forest*/
  function Forest(p) {
    var r = rng('f' + p.x + p.y), n = p.n || 5, trees = [];
    for (var i = 0; i < n; i++) {
      var tx = p.x + (r() - 0.5) * n * 5.4, ty = p.y + (r() - 0.5) * n * 2.8, rr = 3.6 + r() * 1.8;
      trees.push({ x: tx, y: ty, r: rr });
    }
    trees.sort(function (a, b) { return a.y - b.y; });
    return h('g', null, trees.map(function (t, i) {
      return h('g', { key: i },
        h('ellipse', { cx: t.x + 0.6, cy: t.y + t.r + 2.4, rx: t.r * 0.9, ry: 1.4, fill: '#00000030' }),
        h('rect', { x: t.x - 0.9, y: t.y, width: 1.8, height: t.r + 2.2, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('circle', { cx: t.x, cy: t.y, r: t.r, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: 1.1 }),
        h('circle', { cx: t.x - t.r * 0.35, cy: t.y - t.r * 0.35, r: t.r * 0.42, fill: 'var(--map-forest-hi)' }));
    }));
  }
/*@@Field*/
  function Field(p) {
    var lines = [], gap = 4;
    for (var i = gap; i < p.h - 1; i += gap) lines.push('M' + (p.x + 2) + ' ' + (p.y + i) + 'h' + (p.w - 4));
    return h('g', { transform: p.rot ? 'rotate(' + p.rot + ' ' + (p.x + p.w / 2) + ' ' + (p.y + p.h / 2) + ')' : undefined },
      h('rect', { x: p.x, y: p.y, width: p.w, height: p.h, rx: 4, fill: 'var(--map-field)', stroke: 'var(--outline)', strokeWidth: 1.1, opacity: 0.95 }),
      h('path', { d: lines.join(''), stroke: 'var(--map-field-lo)', strokeWidth: 1.2, strokeLinecap: 'round' }));
  }
/*@@Marsh*/
  function Marsh(p) {
    var r = rng('m' + p.x), out = [], pools = [];
    for (var i = 0; i < (p.n || 5); i++) {
      var x = p.x + (r() - 0.5) * 30, y = p.y + (r() - 0.5) * 14;
      if (i % 2 === 0) pools.push(h('ellipse', { key: 'p' + i, cx: x + 3, cy: y + 1, rx: 5 + r() * 3, ry: 2.2, fill: 'var(--map-sea)', stroke: 'var(--outline)', strokeWidth: 0.8, opacity: 0.9 }));
      out.push('M' + x + ' ' + y + 'l-2-5M' + x + ' ' + y + 'v-6M' + x + ' ' + y + 'l2-5');
    }
    return h('g', null, pools, h('path', { d: out.join(''), stroke: 'var(--map-forest)', strokeWidth: 1.4, strokeLinecap: 'round', fill: 'none' }));
  }
/*@@MapTerrain*/
  function MapTerrain(p) {
    return h('g', { className: 'tn-terrain', 'aria-hidden': true },
      (p.fields || []).map(function (f, i) { return h(Field, { key: 'fd' + i, x: f[0], y: f[1], w: f[2], h: f[3], rot: f[4] }); }),
      p.sea ? h(Ripples, { d: p.sea }) : null,
      (p.rivers || []).map(function (d, i) { return h('g', { key: 'r' + i }, h('path', { d: d, fill: 'none', stroke: 'var(--outline)', strokeWidth: 7, strokeLinecap: 'round', opacity: 0.35 }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 5, strokeLinecap: 'round' }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea-hi)', strokeWidth: 1.6, strokeLinecap: 'round', strokeDasharray: '6 8' })); }),
      (p.marsh || []).map(function (m, i) { return h(Marsh, { key: 'ms' + i, x: m[0], y: m[1], n: m[2] }); }),
      (p.mountains || []).slice().sort(function (a, b) { return a[1] - b[1]; }).map(function (m, i) { return h(Mountain, { key: 'mt' + i, x: m[0], y: m[1], s: m[2] }); }),
      (p.forests || []).map(function (f, i) { return h(Forest, { key: 'fo' + i, x: f[0], y: f[1], n: f[2] }); }));
  }
/*@@MapCompass*/
  function MapCompass(p) {
    var R = p.size || 22;
    return h('g', { className: 'tn-compass', transform: 'translate(' + p.x + ' ' + p.y + ')', 'aria-hidden': true },
      h('circle', { r: R * 0.8, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 1.6 }),
      h('circle', { r: R * 0.62, fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('path', { d: 'M0 ' + (-R * 0.95) + 'L' + (R * 0.2) + ' 0H' + (-R * 0.2) + 'z', fill: 'var(--roof-red)', stroke: 'var(--outline)', strokeWidth: 1.1, strokeLinejoin: 'round' }),
      h('path', { d: 'M0 ' + (R * 0.95) + 'L' + (R * 0.2) + ' 0H' + (-R * 0.2) + 'z', fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1.1, strokeLinejoin: 'round' }),
      h('circle', { r: R * 0.13, fill: 'var(--frame-hi)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('text', { y: -R - 3, textAnchor: 'middle', className: 'tn-compass-n' }, 'É'));
  }
/*@@MapCartouche*/
  function MapCartouche(p) {
    var w = p.width || 150, x = p.x, y = p.y, hh = 26;
    return h('g', { className: 'tn-cartouche', transform: 'translate(' + x + ' ' + y + ')' },
      h('path', { d: 'M-8 8h14v' + hh + 'H-8l5-' + (hh / 2) + 'z', fill: 'var(--btn-blue-lo)', stroke: 'var(--outline)', strokeWidth: 1.5, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (w + 8) + ' 8h-14v' + hh + 'H' + (w + 8) + 'l-5-' + (hh / 2) + 'z', fill: 'var(--btn-blue-lo)', stroke: 'var(--outline)', strokeWidth: 1.5, strokeLinejoin: 'round' }),
      h('rect', { x: 0, y: 2, width: w, height: hh, rx: 5, fill: 'var(--btn-blue)', stroke: 'var(--outline)', strokeWidth: 1.8 }),
      h('rect', { x: 3, y: 4.5, width: w - 6, height: 5, rx: 2.5, fill: '#ffffff', opacity: 0.3 }),
      h('text', { x: w / 2, y: 20.5, textAnchor: 'middle', className: 'tn-cart-title' }, p.title),
      h('text', { x: w / 2, y: hh + 14, textAnchor: 'middle', className: 'tn-cart-scale' }, p.scale || '1 napi járóföld'));
  }
/*@@Pennant*/
  function Pennant(p) {
    var x = p.x, y = p.y;
    return h('g', null, h('path', { d: 'M' + x + ' ' + (y + 22) + 'V' + (y - 6), stroke: 'var(--outline)', strokeWidth: 1.8, strokeLinecap: 'round' }),
      h('circle', { cx: x, cy: y - 7, r: 1.8, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('path', { d: 'M' + x + ' ' + (y - 4) + 'h15l-4.5 4.5 4.5 4.5h-15z', fill: tint(p.tincture), stroke: 'var(--outline)', strokeWidth: 1.3, strokeLinejoin: 'round' }));
  }
/*@@Flame*/
  function Flame(p) { return h('g', null, h('path', { d: 'M' + p.x + ' ' + p.y + 'c-6-3-5-9 0-15c0 4 3 4 3 8c1-2 2-3 1.5-6c5 5 3.5 11-4.5 13z', fill: 'var(--ic-orange)', stroke: 'var(--outline)', strokeWidth: 1.1 }), h('path', { d: 'M' + (p.x + 0.5) + ' ' + (p.y - 1) + 'c-2.5-1.5-2-4 0-6c1 2 3 3 0 6z', fill: 'var(--ic-gold-hi)' })); }
/*@@Ship*/
  function Ship(p) {
    return h('g', { transform: 'translate(' + p.x + ' ' + p.y + ')' },
      h('path', { d: 'M-11 0h22l-5 6h-12z', fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 1.3, strokeLinejoin: 'round' }),
      h('path', { d: 'M0 0v-16', stroke: 'var(--outline)', strokeWidth: 1.4 }),
      h('path', { d: 'M1-15c7 3 7 9 0 12z', fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1.1 }),
      h('path', { d: 'M0-16h5l-1.5 1.5L5-13H0z', fill: 'var(--roof-red)', stroke: 'var(--outline)', strokeWidth: 0.8 }),
      h('path', { d: 'M-14 9q3-2.5 6 0t6 0t6 0t6 0', fill: 'none', stroke: '#ffffff', strokeWidth: 1.4, strokeLinecap: 'round' }));
  }
/*@@CityView*/
  var ROOFS = ['var(--roof-red)', 'var(--roof-blue)', 'var(--roof-teal)', 'var(--roof-red)', 'var(--frame)', 'var(--roof-purple)'];
  function House(p) {
    var x = +p.b[0], y = +p.b[1], w = +p.b[2], hh = +p.b[3], rf = p.roof;
    return h('g', null,
      h('rect', { x: x, y: y + hh * 0.35, width: w, height: hh * 0.75, fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
      h('path', { d: 'M' + (x - 1) + ' ' + (y + hh * 0.4) + 'L' + (x + w / 2) + ' ' + (y - hh * 0.25) + 'L' + (x + w + 1) + ' ' + (y + hh * 0.4) + 'z', fill: rf, stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('rect', { x: x + w / 2 - 1, y: y + hh * 0.65, width: 2, height: hh * 0.45, fill: 'var(--ic-brown)' }));
  }
  function Tent(p) {
    var x = p.x, y = p.y, c = p.c;
    return h('g', null,
      h('rect', { x: x, y: y + 4, width: 14, height: 7, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
      h('path', { d: 'M' + (x - 2) + ' ' + (y + 5) + 'L' + (x + 7) + ' ' + (y - 4) + 'L' + (x + 16) + ' ' + (y + 5) + 'z', fill: '#ffffff', stroke: 'var(--outline)', strokeWidth: 1, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x + 1) + ' ' + (y + 5) + 'L' + (x + 5) + ' ' + (y - 2) + 'L' + (x + 7) + ' ' + (y - 4) + 'L' + (x + 7) + ' ' + (y + 5) + 'zM' + (x + 10) + ' ' + (y + 5) + 'L' + (x + 7) + ' ' + (y - 4) + 'L' + (x + 13) + ' ' + (y + 5) + 'z', fill: c }));
  }
  function CityView(p) {
    var d = p.districts || {}, blocks = cityBlocks(p.name || 'varos'), wallPts = WALL.map(function (q) { return q.join(','); }).join(' ');
    var sel = p.selected, stab = p.stability, gid = useUid('cvg'), r = rng('roof' + (p.name || '')), trees = [];
    var tr = rng('trees' + (p.name || ''));
    for (var i = 0; i < 26; i++) { var tx = tr() * 360, ty = tr() * 280; if (!inPoly(tx, ty, WALL) && !nearWall(tx, ty) && !(p.coast && tx > 300)) trees.push([tx, ty, 1 + tr() * 2]); }
    var houses = blocks.map(function (b) { return { b: b, roof: ROOFS[Math.floor(r() * ROOFS.length)] }; }).sort(function (a, b) { return a.b[1] - b.b[1]; });
    function dom(k) { return d[k] || {}; }
    return h('svg', { className: 'tn-city-view', viewBox: '0 0 360 280', role: 'img', 'aria-label': (p.name || 'Város') + ' látképe' },
      h('defs', null, h('radialGradient', { id: gid, cx: '50%', cy: '45%', r: '70%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' }))),
      h('rect', { width: 360, height: 280, fill: 'url(#' + gid + ')' }),
      h(MapTerrain, { fields: [[6, 8, 46, 26, -8], [8, 200, 34, 22, 10]].concat(p.coast ? [] : [[300, 232, 48, 24, -6]]),
        sea: p.coast ? 'M336 84C318 140 352 176 310 222C284 250 262 266 252 280H360V84Z' : null, mountains: p.coast ? [] : [[326, 168, 1.1], [344, 186, 0.9]] }),
      GATES.map(function (g, i) { var dx = g[0] - 180, dy = g[1] - 140, L = Math.hypot(dx, dy); return h('path', { key: 'rd' + i, d: 'M' + g[0] + ' ' + g[1] + 'l' + (dx / L * 46) + ' ' + (dy / L * 46), stroke: 'var(--map-road)', strokeWidth: 7, strokeLinecap: 'round' }); }),
      h(Forest, { x: 30, y: 262, n: 5 }), h(Forest, { x: 336, y: 60, n: 4 }),
      trees.map(function (t, i) { return h(Forest, { key: 'ft' + i, x: t[0], y: t[1], n: 1 }); }),
      h('polygon', { points: wallPts, fill: 'var(--map-sand)' }),
      STREETS.map(function (s, i) { return h('path', { key: 'st' + i, d: 'M' + s[0][0] + ' ' + s[0][1] + 'L' + s[1][0] + ' ' + s[1][1], stroke: 'var(--map-road)', strokeWidth: 9, strokeLinecap: 'round', opacity: 0.9 }); }),
      sel && DISTRICTS[sel] ? h('polygon', { points: DISTRICTS[sel].poly.map(function (q) { return q.join(','); }).join(' '), className: 'tn-cv-sel' }) : null,
      h('g', { className: 'tn-cv-blocks' }, houses.map(function (x, i) { return h(House, { key: i, b: x.b, roof: x.roof }); })),
      // Városháza: palota kupolával
      h('g', { className: 'tn-cv-landmark' },
        h('ellipse', { cx: 116, cy: 116, rx: 30, ry: 5, fill: '#00000030' }),
        h('rect', { x: 92, y: 86, width: 48, height: 28, fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1.4 }),
        [97, 105, 113, 121, 129].map(function (x, i) { return h('rect', { key: i, x: x, y: 94, width: 4, height: 20, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.8 }); }),
        h('path', { d: 'M88 88L116 72L144 88z', fill: 'var(--roof-blue)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }),
        h('path', { d: 'M106 72a10 10 0 0 1 20 0z', fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 1.3 }),
        h('path', { d: 'M116 62v-8', stroke: 'var(--outline)', strokeWidth: 1.4 }),
        h('circle', { cx: 116, cy: 53, r: 2, fill: 'var(--frame-hi)', stroke: 'var(--outline)', strokeWidth: 1 }),
        h('path', { d: 'M111 114v-9a5 5 0 0 1 10 0v9z', fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 1 })),
      // Alvilág: ferde rejtekház lámpással
      h('g', { className: 'tn-cv-landmark' },
        h('ellipse', { cx: 244, cy: 108, rx: 28, ry: 5, fill: '#00000030' }),
        h('path', { d: 'M222 106V76l4-2v32zM226 106V74h34v32z', fill: 'var(--ic-stone-lo)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }),
        h('path', { d: 'M218 78L240 54L264 76z', fill: 'var(--roof-purple)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' }),
        h('path', { d: 'M250 64v-10h6v14', fill: 'var(--ic-stone-lo)', stroke: 'var(--outline)', strokeWidth: 1.2 }),
        h('circle', { cx: 253, cy: 48, r: 2.5, fill: '#dcd6e8', opacity: 0.9 }), h('circle', { cx: 256, cy: 42, r: 3.2, fill: '#dcd6e8', opacity: 0.7 }),
        h('path', { d: 'M236 106v-12a6 6 0 0 1 12 0v12z', fill: 'var(--ic-black)', stroke: 'var(--outline)', strokeWidth: 1 }),
        h('rect', { x: 230, y: 82, width: 7, height: 7, fill: 'var(--ic-gold-hi)', stroke: 'var(--outline)', strokeWidth: 1 }),
        h('rect', { x: 248, y: 82, width: 7, height: 7, fill: 'var(--ic-black)', stroke: 'var(--outline)', strokeWidth: 1 }),
        h('path', { d: 'M262 92h6v-4', fill: 'none', stroke: 'var(--outline)', strokeWidth: 1.2 }),
        h('rect', { x: 265.5, y: 88, width: 5, height: 7, rx: 1, fill: 'var(--ic-gold)', stroke: 'var(--outline)', strokeWidth: 1 })),
      // Vásártér: csíkos sátrak és kút
      h('g', null,
        h('rect', { x: 148, y: 158, width: 76, height: 46, rx: 8, className: 'tn-cv-square' }),
        [[154, 164, 'var(--roof-red)'], [174, 164, 'var(--roof-blue)'], [196, 164, 'var(--frame)'], [154, 188, 'var(--roof-teal)'], [204, 188, 'var(--roof-red)']].map(function (q, i) { return h(Tent, { key: i, x: q[0], y: q[1], c: q[2] }); }),
        h('circle', { cx: 186, cy: 191, r: 6.5, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 1.3 }),
        h('circle', { cx: 186, cy: 191, r: 3.8, fill: 'var(--map-sea)', stroke: 'var(--outline)', strokeWidth: 0.8 })),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--outline)', strokeWidth: 9, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone)', strokeWidth: 6, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone-lo)', strokeWidth: 1.2, strokeDasharray: '3 3', strokeLinejoin: 'round' }),
      WALL.map(function (q, i) { return h('g', { key: 'tw' + i },
        h('rect', { x: q[0] - 6, y: q[1] - 6, width: 12, height: 11, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 1.4 }),
        h('path', { d: 'M' + (q[0] - 7.5) + ' ' + (q[1] - 6) + 'L' + q[0] + ' ' + (q[1] - 17) + 'L' + (q[0] + 7.5) + ' ' + (q[1] - 6) + 'z', fill: 'var(--roof-red)', stroke: 'var(--outline)', strokeWidth: 1.4, strokeLinejoin: 'round' })); }),
      GATES.map(function (g, i) { return h('path', { key: 'g' + i, d: 'M' + (g[0] - 4.5) + ' ' + (g[1] + 5) + 'v-5a4.5 4.5 0 0 1 9 0v5z', fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 1.2 }); }),
      p.coast ? h('g', null, h('path', { d: 'M300 200l24 16M284 214l20 18', stroke: 'var(--outline)', strokeWidth: 6, strokeLinecap: 'round' }), h('path', { d: 'M300 200l24 16M284 214l20 18', stroke: 'var(--ic-brown-hi)', strokeWidth: 3.5, strokeLinecap: 'round' }), h(Ship, { x: 332, y: 244 }), h(Ship, { x: 344, y: 190 })) : null,
      Object.keys(DISTRICTS).map(function (k) {
        var D = DISTRICTS[k], v = dom(k), f = D.flag;
        return h('g', { key: 'fl' + k },
          v.contested ? h(Pennant, { x: f[0] + 12, y: f[1] + 4, tincture: v.contested }) : null,
          v.dominant ? h(Pennant, { x: f[0], y: f[1], tincture: v.dominant }) : null,
          h('text', { x: D.label[0], y: D.label[1], textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, D.name));
      }),
      stab === 'lazongo' ? [[86, 196], [270, 150], [120, 60]].map(function (q, i) { return h(Flame, { key: 'fx' + i, x: q[0], y: q[1] }); }) : null,
      stab === 'ingatag' ? h('g', { fill: '#ffffff', stroke: 'var(--outline)', strokeWidth: 1, opacity: 0.85 }, [[290, 150, 4], [293, 141, 5], [289, 130, 6.5]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2] }); })) : null,
      p.onSelect ? Object.keys(DISTRICTS).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: DISTRICTS[k].poly.map(function (q) { return q.join(','); }).join(' '), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': DISTRICTS[k].name, 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }
/*@@TickTimer*/
  function TickTimer(p) {
    return h('span', { className: cx('tn-tick', p.soon && 'tn-tick-soon') }, h(GameIcon, { name: 'homokora', size: 20 }),
      h('span', null, 'Elszámolás ', p.at ? h('b', null, p.at) : null), p.remaining ? h('span', { className: 'tn-tick-rem' }, p.remaining) : null);
  }
/*@@NavBar*/
  var NAV_ART = { terkep: 'navTerkep', varos: 'navVaros', kem: 'navJel', pp: 'pp', legit: 'navRang', diplomacia: 'program' };
  function NavBar(p) {
    return h('nav', { className: 'tn-nav', 'aria-label': 'Fő navigáció' }, (p.items || []).map(function (it) {
      var on = it.id === p.active, art = it.art || NAV_ART[it.icon];
      return h('button', { key: it.id, className: cx('tn-nav-item', on && 'tn-on'), 'aria-current': on ? 'page' : undefined, onClick: p.onChange ? function () { p.onChange(it.id); } : undefined },
        h('span', { className: 'tn-nav-icon' }, art ? h(GameIcon, { name: art, size: on ? 34 : 30 }) : h(Icon, { name: it.icon, size: 22 }), it.badge ? h('span', { className: 'tn-nav-badge' }, it.badge) : null), h('span', { className: 'tn-nav-label' }, it.label));
    }));
  }
