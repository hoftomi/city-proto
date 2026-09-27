/*@@HouseCrest*/
  function HouseCrest(p) {
    var size = p.size || 28, fill = tint(p.tincture), cid = useUid('cr');
    var shield = 'M5 5h16v7.4c0 5.2-3.8 8.6-8 10.9-4.2-2.3-8-5.7-8-10.9z';
    return h('svg', { className: 'tn-crest', width: size, height: size * 1.12, viewBox: '0 0 26 29', role: 'img', 'aria-label': (p.name || 'Ház') + (p.npc ? ' (NPC)' : '') },
      h('defs', null, h('clipPath', { id: cid }, h('path', { d: shield }))),
      h('path', { d: 'M2 2.5h22v10.2c0 7-5.3 11.4-11 14.3C7.3 24.1 2 19.7 2 12.7z', fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 1.2, strokeLinejoin: 'round' }),
      h('path', { d: 'M3.6 4h18.8', stroke: 'var(--frame-hi)', strokeWidth: 1 }),
      h('path', { d: shield, fill: fill }),
      h('g', { clipPath: 'url(#' + cid + ')' },
        h('path', { d: 'M13 4L22 4V14C22 19 18 22 13 25z', fill: '#000', opacity: 0.18 }),
        h('path', { d: 'M5 5h6c-.5 4-2.5 7-6 9z', fill: '#fff', opacity: 0.22 })),
      h('path', { d: shield, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.9, strokeDasharray: p.npc ? '2 1.6' : undefined }),
      p.initial ? h('text', { className: 'tn-crest-initial', x: 13, y: 17, textAnchor: 'middle', fontSize: 10 }, p.initial) : null);
  }
/*@@MapCanvas*/
  function tufts(seed, w, hh, n) {
    var r = rng(seed), d = [];
    for (var i = 0; i < n; i++) { var x = r() * w, y = r() * hh; d.push('M' + x.toFixed(1) + ' ' + y.toFixed(1) + 'l.9-2.6l.9 2.6l.8-1.8'); }
    return d.join('');
  }
  function MapCanvas(p) {
    var w = p.width || 360, hh = p.height || 240, gid = useUid('g'), vid = useUid('v'), r = rng('mc' + (p.title || '')), blobs = [];
    for (var i = 0; i < 12; i++) blobs.push([r() * w, r() * hh, 16 + r() * 36, 7 + r() * 14]);
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h('defs', null,
        h('radialGradient', { id: gid, cx: '42%', cy: '38%', r: '80%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '70%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.28 }))),
      h('rect', { width: w, height: hh, fill: 'url(#' + gid + ')' }),
      h('g', { 'aria-hidden': true }, blobs.map(function (b, i) { return h('ellipse', { key: i, cx: b[0], cy: b[1], rx: b[2], ry: b[3], fill: i % 3 ? 'var(--map-grass-hi)' : 'var(--map-grass-lo)', opacity: i % 3 ? 0.45 : 0.25 }); }),
        h('path', { d: tufts('t' + w + hh, w, hh, 90), stroke: 'var(--map-tuft)', strokeWidth: 0.7, fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round', opacity: 0.8 })),
      p.children,
      h('rect', { width: w, height: hh, fill: 'url(#' + vid + ')', pointerEvents: 'none' }));
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
      ln('tn-route-dash'),
      st === 'blocked' ? h('g', null, h('circle', { className: 'tn-block-mark', cx: mx, cy: my, r: 7.5 }), h('line', { x1: mx - dx * .55, y1: my - dy * .55, x2: mx + dx * .55, y2: my + dy * .55, stroke: '#fff9ec', strokeWidth: 2.6, strokeLinecap: 'round' })) : null);
  }
/*@@STAB_MARK*/
  var STAB_MARK = { stabil: '', ingatag: '!', lazongo: '!!' };
  function roofPair(c) { return c === 'blue' ? ['var(--roof-blue)', 'var(--roof-blue-lo)'] : c === 'grey' ? ['var(--stone-lo)', 'var(--map-rock-lo)'] : c === 'danger' ? ['var(--btn-red)', 'var(--btn-red-lo)'] : ['var(--roof-red)', 'var(--roof-red-lo)']; }
  function castle(s, rc, key) {
    var o = [], D = 'var(--outline)', sw = 0.8 / s, R = roofPair(rc);
    function el(t, a) { o.push(h(t, Object.assign({ key: o.length, stroke: D, strokeWidth: sw, strokeLinejoin: 'round' }, a))); }
    function nos(t, a) { o.push(h(t, Object.assign({ key: o.length, stroke: 'none' }, a))); }
    function tower(x, lit) {
      el('rect', { x: x, y: -11, width: 7, height: 18, fill: lit ? 'var(--stone-hi)' : 'var(--stone)' });
      nos('rect', { x: x + 4, y: -11, width: 3, height: 18, fill: '#000', opacity: 0.14 });
      nos('path', { d: 'M' + x + ' -4h7M' + x + ' 1h7', stroke: 'var(--stone-lo)', strokeWidth: 0.4 / s });
      el('rect', { x: x + 2.9, y: -7.5, width: 1.2, height: 2.8, fill: 'var(--window-dark)', strokeWidth: 0.3 / s });
      el('path', { d: 'M' + (x - 1.2) + ' -11L' + (x + 3.5) + ' -22L' + (x + 8.2) + ' -11z', fill: R[0] });
      nos('path', { d: 'M' + (x + 3.5) + ' -22L' + (x + 8.2) + ' -11H' + (x + 3.5) + 'z', fill: R[1], opacity: 0.85 });
      nos('path', { d: 'M' + (x + 1) + ' -15.5h5M' + (x + 0.2) + ' -13.2h6.6', stroke: R[1], strokeWidth: 0.5 / s });
      el('path', { d: 'M' + (x - 1.2) + ' -11L' + (x + 3.5) + ' -22L' + (x + 8.2) + ' -11z', fill: 'none' });
    }
    nos('ellipse', { cx: 1.5, cy: 7.4, rx: 18, ry: 4.4, fill: '#2c1f13', opacity: 0.28 });
    el('rect', { x: -12, y: -3, width: 24, height: 10, fill: 'var(--stone)' });
    for (var i = 0; i < 7; i++) el('rect', { x: -12 + i * 3.6, y: -5.2, width: 2.2, height: 2.2, fill: 'var(--stone)', strokeWidth: 0.5 / s });
    nos('path', { d: 'M-12 .4h24M-12 3.8h24M-6 -3v3.4M3 .4v3.4M-2 3.8V7', stroke: 'var(--stone-lo)', strokeWidth: 0.4 / s });
    nos('rect', { x: 4, y: -3, width: 8, height: 10, fill: '#000', opacity: 0.12 });
    el('path', { d: 'M-2.6 7v-4.4a2.6 2.6 0 0 1 5.2 0V7z', fill: 'var(--window-dark)' });
    nos('path', { d: 'M-1.3 2v5M0 1.2V7M1.3 2v5M-2.4 4h4.8', stroke: 'var(--stone-lo)', strokeWidth: 0.35 / s });
    tower(-16, true); tower(9, false);
    var top = key ? -21 : -17;
    if (key) {
      el('rect', { x: -11, y: -9, width: 7, height: 6, fill: 'var(--stone-hi)' });
      el('path', { d: 'M-12-9l3.5-3h4l1.5 3z', fill: R[0] });
    }
    el('rect', { x: -5, y: top, width: 10, height: top * -1 - 3, fill: 'var(--stone-hi)' });
    nos('rect', { x: 1.5, y: top, width: 3.5, height: top * -1 - 3, fill: '#000', opacity: 0.12 });
    el('path', { d: 'M-3 ' + (top + 7) + 'v-2.4a1.2 1.2 0 0 1 2.4 0V' + (top + 7) + 'zM.6 ' + (top + 7) + 'v-2.4a1.2 1.2 0 0 1 2.4 0V' + (top + 7) + 'z', fill: 'var(--window)', strokeWidth: 0.35 / s });
    el('path', { d: 'M-6.6 ' + top + 'L0 ' + (top - 11) + 'L6.6 ' + top + 'z', fill: R[0] });
    nos('path', { d: 'M0 ' + (top - 11) + 'L6.6 ' + top + 'H0z', fill: R[1], opacity: 0.85 });
    nos('path', { d: 'M-3.6 ' + (top - 4.5) + 'h7.2M-5 ' + (top - 2) + 'h10', stroke: R[1], strokeWidth: 0.5 / s });
    el('path', { d: 'M-6.6 ' + top + 'L0 ' + (top - 11) + 'L6.6 ' + top + 'z', fill: 'none' });
    el('path', { d: 'M0 ' + (top - 11) + 'v-6', fill: 'none', strokeWidth: 0.7 / s });
    el('path', { d: 'M0 ' + (top - 17) + 'c2.4-.8 4.4.8 6.6 0l-1.4 1.8 1.4 1.8c-2.2.8-4.2-.8-6.6 0z', fill: 'var(--house-voros)', strokeWidth: 0.5 / s });
    return o;
  }
/*@@MapCity*/
  function MapCity(p) {
    var st = p.state || 'reachable', s = p.keyCity ? 1.12 : 0.95, ly = p.keyCity ? 22 : 19;
    var rc = st === 'cut' ? 'danger' : st === 'unreachable' ? 'grey' : p.keyCity ? 'blue' : 'red';
    return h('g', { className: cx('tn-city', 'tn-city-' + st, p.keyCity && 'tn-city-key'), transform: 'translate(' + p.x + ' ' + p.y + ')' },
      st === 'reachable' ? h('ellipse', { className: 'tn-city-halo', cx: 0, cy: 6, rx: 23, ry: 8.5 }) : null,
      st === 'cut' ? h('ellipse', { cx: 0, cy: 6, rx: 23, ry: 8.5, fill: 'none', stroke: 'var(--danger)', strokeWidth: 2, strokeDasharray: '4 3' }) : null,
      h('g', { transform: 'scale(' + s + ')', className: 'tn-city-art' }, castle(s, rc, p.keyCity)),
      h('text', { className: 'tn-city-label', x: 0, y: ly, textAnchor: 'middle' }, p.name),
      p.stability && STAB_MARK[p.stability] ? h('g', { transform: 'translate(13 ' + (p.keyCity ? -30 : -24) + ')' }, h('path', { d: 'M0-8l7.5 13h-15z', className: 'tn-stab-bubble tn-stab-' + p.stability }), h('text', { className: 'tn-city-stab', y: 3.5, textAnchor: 'middle' }, STAB_MARK[p.stability])) : null);
  }
/*@@MapEstate*/
  function Tent(x, y, c, k) {
    return h('g', { key: k },
      h('path', { d: 'M' + (x - 7) + ' ' + y + 'L' + x + ' ' + (y - 10) + 'L' + (x + 7) + ' ' + y + 'z', fill: c, stroke: 'var(--outline)', strokeWidth: 0.8, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + x + ' ' + (y - 10) + 'L' + (x + 7) + ' ' + y + 'H' + x + 'z', fill: '#000', opacity: 0.16 }),
      h('path', { d: 'M' + x + ' ' + (y - 10) + 'L' + (x - 1.8) + ' ' + y + 'h3.6z', fill: 'var(--window-dark)' }));
  }
  function MapEstate(p) {
    var c = tint(p.tincture);
    return h('g', { className: 'tn-estate-g', transform: 'translate(' + p.x + ' ' + p.y + ')' },
      h('ellipse', { cx: 1, cy: 6.5, rx: 13, ry: 3.4, fill: '#2c1f13', opacity: 0.26 }),
      Tent(-4, 6, 'var(--paper-raised)', 'a'), Tent(5, 7, 'var(--map-sand)', 'b'),
      h('path', { d: 'M-1 7v-22', stroke: 'var(--outline)', strokeWidth: 1.1, strokeLinecap: 'round' }),
      h('path', { d: 'M-1-15c3.5-1.4 6.5 1.4 10 0v6c-3.5 1.4-6.5-1.4-10 0z', fill: c, stroke: 'var(--outline)', strokeWidth: 0.8, strokeLinejoin: 'round', strokeDasharray: p.npc ? '2 1.3' : undefined }),
      h('path', { d: 'M4-14.5c1.6.4 3.2.4 5-.5v6c-1.8.9-3.4.9-5 .5z', fill: '#000', opacity: 0.18 }),
      h('circle', { cx: -1, cy: -15.6, r: 1.1, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      p.name ? h('text', { className: 'tn-city-label', x: 0, y: 19, textAnchor: 'middle', style: { fontSize: 10 } }, p.name) : null);
  }
/*@@Ripples*/
  function Ripples(p) {
    var cid = useUid('sea'), r = rng('w' + p.d.length), waves = [];
    for (var y = 6; y < 300; y += 13) for (var x = 4 + (y % 26 ? 9 : 0); x < 380; x += 20) waves.push([x + (r() - 0.5) * 8, y + (r() - 0.5) * 5, 3 + r() * 3]);
    return h('g', null,
      h('clipPath', { id: cid }, h('path', { d: p.d })),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--map-road-lo)', strokeWidth: 15, strokeLinejoin: 'round', opacity: 0.4 }),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sand)', strokeWidth: 12, strokeLinejoin: 'round' }),
      h('path', { d: p.d, fill: 'var(--map-sea-deep)' }),
      h('g', { clipPath: 'url(#' + cid + ')' },
        h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 40 }),
        h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea-hi)', strokeWidth: 14, opacity: 0.9 }),
        h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 2.2, strokeDasharray: '12 5 3 5', opacity: 0.85 }),
        h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 1, strokeDasharray: '6 9', opacity: 0.6, transform: 'translate(5 0)' }),
        waves.map(function (q, i) { return h('path', { key: i, d: 'M' + q[0].toFixed(1) + ' ' + q[1].toFixed(1) + 'q' + (q[2] / 2) + '-2 ' + q[2] + ' 0', fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.8, strokeLinecap: 'round', opacity: 0.55 }); })),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.9, opacity: 0.55 }));
  }
/*@@Mountain*/
  function Mountain(p) {
    var s = p.s || 1, x = p.x, y = p.y, w = 13 * s, t = 17 * s;
    function P(a) { return a.map(function (q, i) { return (i ? 'L' : 'M') + (x + q[0] * w).toFixed(1) + ' ' + (y - q[1] * t).toFixed(1); }).join('') + 'Z'; }
    var sil = P([[-1, 0], [-0.45, 0.55], [-0.15, 0.8], [0, 1], [0.25, 0.7], [0.55, 0.45], [1, 0]]);
    var lit = P([[0, 1], [-0.15, 0.8], [-0.45, 0.55], [-1, 0], [-0.1, 0], [0.05, 0.5]]);
    var shade = P([[0, 1], [0.25, 0.7], [0.55, 0.45], [1, 0], [0.2, 0], [0.05, 0.5]]);
    var snow = P([[-0.28, 0.66], [-0.15, 0.8], [0, 1], [0.25, 0.7], [0.33, 0.62], [0.18, 0.57], [0.08, 0.66], [-0.02, 0.55], [-0.12, 0.63]]);
    var snowS = P([[0, 1], [0.25, 0.7], [0.33, 0.62], [0.18, 0.57], [0.08, 0.66], [0.02, 0.8]]);
    var ridges = 'M' + (x - 0.45 * w) + ' ' + (y - 0.55 * t) + 'l' + (0.12 * w) + ' ' + (0.3 * t) + 'M' + (x + 0.55 * w) + ' ' + (y - 0.45 * t) + 'l' + (-0.1 * w) + ' ' + (0.28 * t) + 'M' + (x + 0.05 * w) + ' ' + (y - 0.5 * t) + 'l' + (0.05 * w) + ' ' + (0.3 * t);
    return h('g', null,
      h('ellipse', { cx: x + 2, cy: y + 1, rx: w + 2, ry: 2.6 * s, fill: '#2c1f13', opacity: 0.22 }),
      h('path', { d: sil, fill: 'var(--map-rock)' }),
      h('path', { d: lit, fill: 'var(--map-rock-hi)' }),
      h('path', { d: shade, fill: 'var(--map-rock-lo)' }),
      h('path', { d: ridges, stroke: 'var(--map-relief)', strokeWidth: 0.6, strokeLinecap: 'round', opacity: 0.7 }),
      h('path', { d: snow, fill: 'var(--map-snow)' }),
      h('path', { d: snowS, fill: 'var(--map-snow-lo)' }),
      h('path', { d: sil, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('ellipse', { cx: x + w * 0.7, cy: y - 0.6, rx: 2.2 * s, ry: 1.3 * s, fill: 'var(--map-rock-lo)', stroke: 'var(--outline)', strokeWidth: 0.5 }));
  }
/*@@Forest*/
  function Tree(t, k) {
    var x = t.x, y = t.y, r = t.r;
    if (t.pine) {
      var tiers = [[0, 1.6], [-0.9, 1.25], [-1.75, 0.9]];
      return h('g', { key: k },
        h('ellipse', { cx: x + 1, cy: y + r * 0.9 + 1, rx: r * 0.8, ry: 1.2, fill: '#2c1f13', opacity: 0.25 }),
        h('rect', { x: x - 0.7, y: y + r * 0.2, width: 1.4, height: r * 0.8, fill: 'var(--ic-brown)' }),
        tiers.map(function (q, i) {
          var ty = y + q[0] * r, ww = q[1] * r * 0.62;
          return h('g', { key: i }, h('path', { d: 'M' + (x - ww) + ' ' + (ty + r * 0.35) + 'L' + x + ' ' + (ty - r * 0.75) + 'L' + (x + ww) + ' ' + (ty + r * 0.35) + 'z', fill: 'var(--map-pine)', stroke: 'var(--outline)', strokeWidth: 0.55, strokeLinejoin: 'round' }),
            h('path', { d: 'M' + x + ' ' + (ty - r * 0.75) + 'L' + (x + ww) + ' ' + (ty + r * 0.35) + 'H' + x + 'z', fill: 'var(--map-forest-lo)', opacity: 0.8 }));
        }));
    }
    return h('g', { key: k },
      h('ellipse', { cx: x + 1.2, cy: y + r + 1.6, rx: r * 0.95, ry: 1.3, fill: '#2c1f13', opacity: 0.25 }),
      h('rect', { x: x - 0.8, y: y, width: 1.6, height: r + 1.6, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('circle', { cx: x - r * 0.35, cy: y + r * 0.1, r: r * 0.72, fill: 'var(--map-forest-lo)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('circle', { cx: x + r * 0.4, cy: y + r * 0.15, r: r * 0.7, fill: 'var(--map-forest-lo)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('circle', { cx: x, cy: y - r * 0.35, r: r * 0.8, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('circle', { cx: x - r * 0.35, cy: y + r * 0.05, r: r * 0.5, fill: 'var(--map-forest)' }),
      h('circle', { cx: x - r * 0.3, cy: y - r * 0.6, r: r * 0.32, fill: 'var(--map-forest-hi)' }));
  }
  function Forest(p) {
    var r = rng('f' + p.x + p.y), n = p.n || 5, trees = [];
    for (var i = 0; i < n; i++) trees.push({ x: p.x + (r() - 0.5) * n * 5.2, y: p.y + (r() - 0.5) * n * 2.7, r: 3.3 + r() * 1.7, pine: r() < 0.45 });
    trees.sort(function (a, b) { return a.y - b.y; });
    return h('g', null, trees.map(function (t, i) { return Tree(t, i); }));
  }
/*@@Field*/
  function Field(p) {
    var a = [], b = [], gap = 2.6, split = p.x + p.w * 0.55;
    for (var i = gap; i < p.h - 0.5; i += gap) a.push('M' + (p.x + 1.5) + ' ' + (p.y + i) + 'H' + (split - 1));
    for (var j = p.x + 2 + gap; j < p.x + p.w - 1; j += gap) if (j > split + 1) b.push('M' + j + ' ' + (p.y + 1.5) + 'v' + (p.h - 3));
    return h('g', { transform: p.rot ? 'rotate(' + p.rot + ' ' + (p.x + p.w / 2) + ' ' + (p.y + p.h / 2) + ')' : undefined },
      h('rect', { x: p.x, y: p.y, width: split - p.x, height: p.h, fill: 'var(--map-field)' }),
      h('rect', { x: split, y: p.y, width: p.x + p.w - split, height: p.h, fill: 'var(--map-field-2)' }),
      h('path', { d: a.join(''), stroke: 'var(--map-field-lo)', strokeWidth: 0.7 }),
      h('path', { d: b.join(''), stroke: 'var(--map-grass-lo)', strokeWidth: 0.7 }),
      h('rect', { x: p.x, y: p.y, width: p.w, height: p.h, rx: 1.5, fill: 'none', stroke: 'var(--map-forest-lo)', strokeWidth: 1.4, opacity: 0.8 }),
      h('circle', { cx: p.x + p.w * 0.25, cy: p.y + p.h * 0.55, r: 1.5, fill: 'var(--map-field-lo)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('circle', { cx: p.x + p.w * 0.38, cy: p.y + p.h * 0.35, r: 1.5, fill: 'var(--map-field-lo)', stroke: 'var(--outline)', strokeWidth: 0.4 }));
  }
/*@@Marsh*/
  function Marsh(p) {
    var r = rng('m' + p.x), reeds = [], heads = [], pools = [];
    for (var i = 0; i < (p.n || 5); i++) {
      var x = p.x + (r() - 0.5) * 30, y = p.y + (r() - 0.5) * 14;
      if (i % 2 === 0) pools.push(h('ellipse', { key: 'p' + i, cx: x + 3, cy: y + 1, rx: 5 + r() * 3, ry: 2.1, fill: 'var(--map-sea)', stroke: 'var(--map-sea-deep)', strokeWidth: 0.8 }));
      reeds.push('M' + x + ' ' + y + 'l-1.6-5M' + x + ' ' + y + 'v-6M' + x + ' ' + y + 'l1.8-4.6');
      heads.push(h('ellipse', { key: 'h' + i, cx: x, cy: y - 6.2, rx: 0.8, ry: 1.6, fill: 'var(--ic-brown)' }));
    }
    return h('g', null, pools, h('path', { d: reeds.join(''), stroke: 'var(--map-forest-lo)', strokeWidth: 0.9, strokeLinecap: 'round', fill: 'none' }), heads);
  }
/*@@MapTerrain*/
  function MapTerrain(p) {
    return h('g', { className: 'tn-terrain', 'aria-hidden': true },
      (p.fields || []).map(function (f, i) { return h(Field, { key: 'fd' + i, x: f[0], y: f[1], w: f[2], h: f[3], rot: f[4] }); }),
      p.sea ? h(Ripples, { d: p.sea }) : null,
      (p.rivers || []).map(function (d, i) { return h('g', { key: 'r' + i }, h('path', { d: d, fill: 'none', stroke: 'var(--map-grass-lo)', strokeWidth: 8, strokeLinecap: 'round' }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea-deep)', strokeWidth: 5.2, strokeLinecap: 'round' }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 3.4, strokeLinecap: 'round' }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.8, strokeLinecap: 'round', strokeDasharray: '5 7', opacity: 0.8 })); }),
      (p.marsh || []).map(function (m, i) { return h(Marsh, { key: 'ms' + i, x: m[0], y: m[1], n: m[2] }); }),
      (p.mountains || []).slice().sort(function (a, b) { return a[1] - b[1]; }).map(function (m, i) { return h(Mountain, { key: 'mt' + i, x: m[0], y: m[1], s: m[2] }); }),
      (p.forests || []).map(function (f, i) { return h(Forest, { key: 'fo' + i, x: f[0], y: f[1], n: f[2] }); }));
  }
/*@@MapCompass*/
  function MapCompass(p) {
    var R = p.size || 22, pts = [], ticks = [];
    for (var i = 0; i < 8; i++) {
      var a = i * Math.PI / 4 - Math.PI / 2, L = i % 2 ? R * 0.58 : R, wv = R * (i % 2 ? 0.11 : 0.16);
      var tx = Math.cos(a) * L, ty = Math.sin(a) * L, lx = Math.cos(a - Math.PI / 2) * wv, ly = Math.sin(a - Math.PI / 2) * wv;
      pts.push(h('path', { key: 'l' + i, d: 'M0 0L' + tx.toFixed(1) + ' ' + ty.toFixed(1) + 'L' + lx.toFixed(1) + ' ' + ly.toFixed(1) + 'z', fill: i === 0 ? 'var(--btn-red)' : 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 0.6, strokeLinejoin: 'round' }));
      pts.push(h('path', { key: 'd' + i, d: 'M0 0L' + tx.toFixed(1) + ' ' + ty.toFixed(1) + 'L' + (-lx).toFixed(1) + ' ' + (-ly).toFixed(1) + 'z', fill: i === 0 ? 'var(--btn-red-lo)' : 'var(--wood)', stroke: 'var(--outline)', strokeWidth: 0.6, strokeLinejoin: 'round' }));
    }
    for (var j = 0; j < 32; j++) { var b = j * Math.PI / 16, r1 = R * 0.72, r2 = R * (j % 4 ? 0.78 : 0.84); ticks.push('M' + (Math.cos(b) * r1).toFixed(1) + ' ' + (Math.sin(b) * r1).toFixed(1) + 'L' + (Math.cos(b) * r2).toFixed(1) + ' ' + (Math.sin(b) * r2).toFixed(1)); }
    return h('g', { className: 'tn-compass', transform: 'translate(' + p.x + ' ' + p.y + ')', 'aria-hidden': true },
      h('circle', { r: R * 0.86, fill: 'var(--paper-raised)', fillOpacity: 0.75, stroke: 'var(--frame-lo)', strokeWidth: 1.2 }),
      h('circle', { r: R * 0.7, fill: 'none', stroke: 'var(--frame-lo)', strokeWidth: 0.6 }),
      h('path', { d: ticks.join(''), stroke: 'var(--frame-lo)', strokeWidth: 0.6 }),
      pts,
      h('circle', { r: R * 0.1, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('text', { y: -R - 2.5, textAnchor: 'middle', className: 'tn-compass-n' }, 'É'));
  }
/*@@MapCartouche*/
  function MapCartouche(p) {
    var w = p.width || 150, x = p.x, y = p.y, hh = 22;
    return h('g', { className: 'tn-cartouche', transform: 'translate(' + x + ' ' + y + ')' },
      h('path', { d: 'M4 4h' + (w - 8) + 'c3 0 3 ' + hh + ' 0 ' + hh + 'H4c-3 0-3-' + hh + ' 0-' + hh + 'z', fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('ellipse', { cx: 4, cy: 4 + hh / 2, rx: 4, ry: hh / 2 + 1.5, fill: 'var(--paper-sunk)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('ellipse', { cx: w - 4, cy: 4 + hh / 2, rx: 4, ry: hh / 2 + 1.5, fill: 'var(--paper-sunk)', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('ellipse', { cx: 4.8, cy: 4 + hh / 2, rx: 1.6, ry: hh / 2 - 2, fill: 'var(--line-strong)', opacity: 0.6 }),
      h('ellipse', { cx: w - 3.2, cy: 4 + hh / 2, rx: 1.6, ry: hh / 2 - 2, fill: 'var(--line-strong)', opacity: 0.6 }),
      h('path', { d: 'M12 8h' + (w - 24) + 'M12 ' + (hh) + 'h' + (w - 24), stroke: 'var(--frame-lo)', strokeWidth: 0.5 }),
      h('text', { x: w / 2, y: 19.5, textAnchor: 'middle', className: 'tn-cart-title' }, p.title),
      h('g', { transform: 'translate(' + (w / 2 - 24) + ' ' + (hh + 9) + ')' },
        [0, 1, 2, 3].map(function (i) { return h('rect', { key: i, x: i * 12, width: 12, height: 3, fill: i % 2 ? 'var(--paper-raised)' : 'var(--outline)', stroke: 'var(--outline)', strokeWidth: 0.5 }); }),
        h('text', { x: 24, y: 11, textAnchor: 'middle', className: 'tn-cart-scale' }, p.scale || '1 napi járóföld')));
  }
/*@@Pennant*/
  function Pennant(p) {
    var x = p.x, y = p.y, c = tint(p.tincture);
    return h('g', null, h('path', { d: 'M' + x + ' ' + (y + 22) + 'V' + (y - 6), stroke: 'var(--outline)', strokeWidth: 1.3, strokeLinecap: 'round' }),
      h('circle', { cx: x, cy: y - 6.8, r: 1.4, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M' + x + ' ' + (y - 5) + 'c5-2 9 2 15 0l-3.5 4.5 3.5 4.5c-6 2-10-2-15 0z', fill: c, stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x + 7) + ' ' + (y - 4.8) + 'c2 .6 4 .6 8-.2l-3.5 4.5 3.5 4.5c-4 .8-6 .8-8 .2z', fill: '#000', opacity: 0.18 }));
  }
/*@@Flame*/
  function Flame(p) { return h('g', null, h('circle', { cx: p.x + 1, cy: p.y - 6, r: 11, fill: 'var(--ic-orange-hi)', opacity: 0.3 }), h('path', { d: 'M' + p.x + ' ' + p.y + 'c-6-3-5-9 0-15c0 4 3 4 3 8c1-2 2-3 1.5-6c5 5 3.5 11-4.5 13z', fill: 'var(--ic-orange)', stroke: 'var(--outline)', strokeWidth: 0.8 }), h('path', { d: 'M' + (p.x + 0.5) + ' ' + (p.y - 1) + 'c-2.5-1.5-2-4 0-6c1 2 3 3 0 6z', fill: 'var(--ic-gold-hi)' })); }
/*@@Ship*/
  function Ship(p) {
    return h('g', { transform: 'translate(' + p.x + ' ' + p.y + ')' },
      h('path', { d: 'M-13 9q3-2.5 6 0t6 0t6 0t6 0t6 0', fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 1, strokeLinecap: 'round', opacity: 0.8 }),
      h('path', { d: 'M-12 0h24l-5 6.5h-15z', fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('path', { d: 'M-10.8 2.2h21.6M-9 4.4h18', stroke: 'var(--ic-peat)', strokeWidth: 0.5 }),
      h('path', { d: 'M9 0h4l-1-3h-3z', fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M0 0v-18M-6 0v-11', stroke: 'var(--outline)', strokeWidth: 1 }),
      h('path', { d: 'M.8-17c6 2.5 7 8 1 13.5H.8z', fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
      h('path', { d: 'M3.5-15c2.5 2.5 2.8 6-.5 10', fill: 'none', stroke: 'var(--line-strong)', strokeWidth: 0.6 }),
      h('path', { d: 'M-5.4-10c4 1.6 4.5 5 .6 8.4h-.6z', fill: 'var(--paper)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M0-18h5l-1.4 1.4L5-15.2H0z', fill: 'var(--house-voros)', stroke: 'var(--outline)', strokeWidth: 0.5 }));
  }
/*@@CityView*/
  var ROOFS = [['var(--roof-red)', 'var(--roof-red-lo)'], ['var(--roof-blue)', 'var(--roof-blue-lo)'], ['var(--roof-brown)', 'var(--timber)'], ['var(--roof-red)', 'var(--roof-red-lo)'], ['var(--roof-teal)', 'var(--copper-lo)'], ['var(--roof-purple)', 'var(--ic-black)']];
  function House(p) {
    var x = +p.b[0], y = +p.b[1], w = +p.b[2], hh = +p.b[3], R = p.roof, top = y - hh * 0.3, eave = y + hh * 0.38, base = y + hh * 1.1, mid = x + w / 2, o = [];
    function el(t, a) { o.push(h(t, Object.assign({ key: o.length }, a))); }
    el('rect', { x: x, y: eave, width: w, height: base - eave, fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.6 });
    el('rect', { x: mid + w * 0.18, y: eave, width: w * 0.32, height: base - eave, fill: '#000', opacity: 0.1 });
    if (p.timber) el('path', { d: 'M' + (x + w * 0.3) + ' ' + eave + 'V' + base + 'M' + (x + w * 0.7) + ' ' + eave + 'V' + base + 'M' + x + ' ' + (eave + (base - eave) * 0.45) + 'H' + (x + w) + 'M' + (x + w * 0.3) + ' ' + eave + 'L' + (x + w * 0.7) + ' ' + (eave + (base - eave) * 0.45), stroke: 'var(--timber)', strokeWidth: 0.45 });
    if (w > 8) el('rect', { x: x + w * 0.14, y: eave + 1.1, width: 1.6, height: 1.6, fill: p.lit ? 'var(--window)' : 'var(--window-dark)' });
    el('rect', { x: mid - 0.8, y: base - 2.6, width: 1.6, height: 2.6, fill: 'var(--timber)' });
    if (p.chimney) el('rect', { x: x + w * 0.66, y: top + 0.6, width: 1.6, height: 3, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.4 });
    el('path', { d: 'M' + (x - 1) + ' ' + (eave + 0.4) + 'L' + mid + ' ' + top + 'L' + (x + w + 1) + ' ' + (eave + 0.4) + 'z', fill: R[0], stroke: 'var(--outline)', strokeWidth: 0.6, strokeLinejoin: 'round' });
    el('path', { d: 'M' + mid + ' ' + top + 'L' + (x + w + 1) + ' ' + (eave + 0.4) + 'H' + mid + 'z', fill: R[1], opacity: 0.7 });
    el('path', { d: 'M' + (x + 1) + ' ' + (eave - 1.4) + 'H' + (x + w - 1) + 'M' + (mid - w * 0.22) + ' ' + (eave - 3) + 'H' + (mid + w * 0.22), stroke: R[1], strokeWidth: 0.4 });
    return h('g', null, o);
  }
  function Stall(x, y, c, k) {
    var s = [];
    for (var i = 0; i < 4; i++) s.push(h('path', { key: i, d: 'M' + (x + i * 4 - 1) + ' ' + (y + 4) + 'L' + (x + i * 4 + 1) + ' ' + (y - 2) + 'h2L' + (x + i * 4 + 3) + ' ' + (y + 4) + 'z', fill: i % 2 ? '#fff9ec' : c }));
    return h('g', { key: k },
      h('rect', { x: x, y: y + 4, width: 15, height: 6, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M' + (x + 1) + ' ' + (y + 6.5) + 'h13', stroke: 'var(--ic-brown)', strokeWidth: 0.5 }),
      h('circle', { cx: x + 3.5, cy: y + 5.5, r: 1.1, fill: 'var(--ic-red)' }), h('circle', { cx: x + 6.5, cy: y + 5.5, r: 1.1, fill: 'var(--ic-gold)' }), h('circle', { cx: x + 9.5, cy: y + 5.5, r: 1.1, fill: 'var(--ic-green)' }),
      h('path', { d: 'M' + (x + 0.5) + ' ' + (y + 4) + 'v6M' + (x + 14.5) + ' ' + (y + 4) + 'v6', stroke: 'var(--timber)', strokeWidth: 0.8 }),
      s,
      h('path', { d: 'M' + (x - 1) + ' ' + (y + 4) + 'L' + (x + 1) + ' ' + (y - 2) + 'H' + (x + 15) + 'L' + (x + 16) + ' ' + (y + 4) + 'z', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.7, strokeLinejoin: 'round' }));
  }
  function Crate(x, y, k) { return h('g', { key: k }, h('rect', { x: x, y: y, width: 4.5, height: 4, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.5 }), h('path', { d: 'M' + x + ' ' + y + 'l4.5 4M' + (x + 4.5) + ' ' + y + 'l-4.5 4', stroke: 'var(--ic-brown)', strokeWidth: 0.4 })); }
  function Barrel(x, y, k) { return h('g', { key: k }, h('rect', { x: x, y: y, width: 4, height: 5, rx: 1.4, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.5 }), h('path', { d: 'M' + x + ' ' + (y + 1.4) + 'h4M' + x + ' ' + (y + 3.6) + 'h4', stroke: 'var(--ic-steel-lo)', strokeWidth: 0.5 })); }
  function Cart(x, y) {
    return h('g', null, h('rect', { x: x, y: y, width: 12, height: 5, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M' + (x + 12) + ' ' + (y + 3) + 'l6 2', stroke: 'var(--timber)', strokeWidth: 0.9 }),
      h('ellipse', { cx: x + 4, cy: y - 0.6, rx: 3.5, ry: 1.6, fill: 'var(--map-field)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('ellipse', { cx: x + 8.5, cy: y - 0.4, rx: 3, ry: 1.4, fill: 'var(--ic-cream)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      [x + 2.5, x + 9.5].map(function (cx2, i) { return h('g', { key: i }, h('circle', { cx: cx2, cy: y + 5.5, r: 2.3, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.5 }), h('path', { d: 'M' + (cx2 - 2.3) + ' ' + (y + 5.5) + 'h4.6M' + cx2 + ' ' + (y + 3.2) + 'v4.6', stroke: 'var(--ic-brown-hi)', strokeWidth: 0.4 })); }));
  }
  function CityView(p) {
    var d = p.districts || {}, blocks = cityBlocks(p.name || 'varos'), wallPts = WALL.map(function (q) { return q.join(','); }).join(' ');
    var sel = p.selected, stab = p.stability, gid = useUid('cvg'), vid = useUid('cvv'), lid = useUid('lamp'), r = rng('roof' + (p.name || '')), tr = rng('trees' + (p.name || '')), cr = rng('cob' + (p.name || ''));
    var trees = [], cobbles = [];
    for (var i = 0; i < 34; i++) { var tx = tr() * 360, ty = tr() * 280; if (!inPoly(tx, ty, WALL) && !nearWall(tx, ty) && !(p.coast && tx > 296) && !(tx < 60 && ty < 40)) trees.push({ x: tx, y: ty, r: 3 + tr() * 2, pine: tr() < 0.45 }); }
    trees.sort(function (a, b) { return a.y - b.y; });
    for (var c = 0; c < 260; c++) { var qx = 40 + cr() * 280, qy = 30 + cr() * 220; if (inPoly(qx, qy, WALL)) cobbles.push('M' + qx.toFixed(1) + ' ' + qy.toFixed(1) + 'h1.6'); }
    var houses = blocks.map(function (b) { return { b: b, roof: ROOFS[Math.floor(r() * ROOFS.length)], timber: r() < 0.55, chimney: r() < 0.35, lit: r() < 0.3 }; }).sort(function (a, b) { return a.b[1] - b.b[1]; });
    function dom(k) { return d[k] || {}; }
    var WC = function (q) { return q.join(','); };
    return h('svg', { className: 'tn-city-view', viewBox: '0 0 360 280', role: 'img', 'aria-label': (p.name || 'Város') + ' látképe' },
      h('defs', null,
        h('radialGradient', { id: gid, cx: '50%', cy: '45%', r: '72%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '72%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.3 })),
        h('radialGradient', { id: lid }, h('stop', { offset: '0%', stopColor: 'var(--window)', stopOpacity: 0.85 }), h('stop', { offset: '100%', stopColor: 'var(--window)', stopOpacity: 0 }))),
      h('rect', { width: 360, height: 280, fill: 'url(#' + gid + ')' }),
      h('path', { d: tufts('cv' + (p.name || ''), 360, 280, 110), stroke: 'var(--map-tuft)', strokeWidth: 0.7, fill: 'none', strokeLinecap: 'round', opacity: 0.75 }),
      h(MapTerrain, { fields: [[6, 8, 46, 26, -8], [8, 200, 34, 22, 10], [300, 8, 40, 20, 6]].concat(p.coast ? [] : [[300, 232, 48, 24, -6]]),
        sea: p.coast ? 'M336 84C318 140 352 176 310 222C284 250 262 266 252 280H360V84Z' : null, mountains: p.coast ? [] : [[326, 168, 1.1], [346, 188, 0.9], [338, 150, 0.7]] }),
      GATES.map(function (g, i) { var dx = g[0] - 180, dy = g[1] - 140, L = Math.hypot(dx, dy); var dd = 'M' + g[0] + ' ' + g[1] + 'l' + (dx / L * 48) + ' ' + (dy / L * 48); return h('g', { key: 'rd' + i }, h('path', { d: dd, stroke: 'var(--map-road-lo)', strokeWidth: 8, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--map-road)', strokeWidth: 6, strokeLinecap: 'round' })); }),
      trees.map(function (t, i) { return Tree(t, 'ft' + i); }),
      h('polygon', { points: wallPts, fill: '#d8c59b' }),
      h('path', { d: cobbles.join(''), stroke: 'var(--stone-lo)', strokeWidth: 1.1, strokeLinecap: 'round', opacity: 0.45 }),
      STREETS.map(function (s, i) { var dd = 'M' + s[0][0] + ' ' + s[0][1] + 'L' + s[1][0] + ' ' + s[1][1]; return h('g', { key: 'st' + i }, h('path', { d: dd, stroke: 'var(--map-road-lo)', strokeWidth: 10, strokeLinecap: 'round', opacity: 0.6 }), h('path', { d: dd, stroke: 'var(--map-road)', strokeWidth: 8, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--stone-lo)', strokeWidth: 5, strokeDasharray: '1.2 2.4', opacity: 0.5 })); }),
      sel && DISTRICTS[sel] ? h('polygon', { points: DISTRICTS[sel].poly.map(WC).join(' '), className: 'tn-cv-sel' }) : null,
      h('g', { className: 'tn-cv-blocks' }, houses.map(function (x, i) { return h(House, { key: i, b: x.b, roof: x.roof, timber: x.timber, chimney: x.chimney, lit: x.lit }); })),
      // Városháza: palota rézkupolával
      h('g', { className: 'tn-cv-landmark' },
        h('ellipse', { cx: 118, cy: 117, rx: 32, ry: 5, fill: '#2c1f13', opacity: 0.25 }),
        h('rect', { x: 90, y: 88, width: 52, height: 27, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
        h('rect', { x: 122, y: 88, width: 20, height: 27, fill: '#000', opacity: 0.1 }),
        [94, 100, 106, 126, 132].map(function (x, i) { return h('rect', { key: 'w' + i, x: x + 0.5, y: 91.5, width: 3, height: 4, rx: 1.5, fill: i % 2 ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.4 }); }),
        [106, 111, 116, 121, 126].map(function (x, i) { return h('g', { key: 'c' + i }, h('rect', { x: x, y: 99, width: 3, height: 15, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.5 }), h('rect', { x: x - 0.5, y: 98, width: 4, height: 1.4, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.4 })); }),
        h('path', { d: 'M104 99L116 91.5L130 99z', fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M103 115h26l2 3h-30z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M86 88.5L116 74L146 88.5z', fill: 'var(--roof-blue)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
        h('path', { d: 'M116 74L146 88.5H116z', fill: 'var(--roof-blue-lo)', opacity: 0.8 }),
        h('path', { d: 'M96 84h40M106 79.5h20', stroke: 'var(--roof-blue-lo)', strokeWidth: 0.5 }),
        h('rect', { x: 108, y: 66, width: 16, height: 9, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M106 66a10 10 0 0 1 20 0z', fill: 'var(--copper)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
        h('path', { d: 'M116 56a10 10 0 0 1 10 10h-10z', fill: 'var(--copper-lo)', opacity: 0.8 }),
        h('path', { d: 'M110 62.5c2-3 4.5-4.5 6-4.8M112 66v-3', stroke: 'var(--map-sea-line)', strokeWidth: 0.6, fill: 'none', opacity: 0.7 }),
        h('path', { d: 'M116 56v-8', stroke: 'var(--outline)', strokeWidth: 1 }),
        h('circle', { cx: 116, cy: 55.5, r: 1.4, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('path', { d: 'M113.6 115v-7a2.4 2.4 0 0 1 4.8 0v7z', fill: 'var(--timber)', stroke: 'var(--outline)', strokeWidth: 0.5 })),
      // Alvilág: ferde fogadó, hordók, lámpás
      h('g', { className: 'tn-cv-landmark' },
        h('ellipse', { cx: 244, cy: 109, rx: 30, ry: 5, fill: '#2c1f13', opacity: 0.25 }),
        h('circle', { cx: 268, cy: 92, r: 12, fill: 'url(#' + lid + ')' }),
        h('path', { d: 'M222 107V78l3-1.5V107zM225 107V76h34v31z', fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
        h('path', { d: 'M225 91h34M236 76v31M248 76v31M225 76l11 15M248 91l11-15', stroke: 'var(--timber)', strokeWidth: 0.8 }),
        h('rect', { x: 248, y: 76, width: 11, height: 31, fill: '#000', opacity: 0.14 }),
        h('path', { d: 'M217 79L239 55L265 77z', fill: 'var(--roof-purple)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
        h('path', { d: 'M239 55L265 77H239z', fill: 'var(--ic-black)', opacity: 0.45 }),
        h('path', { d: 'M226 71h28M232 64.5h16', stroke: 'var(--ic-black)', strokeWidth: 0.5, opacity: 0.7 }),
        h('path', { d: 'M250 65v-11h5v15', fill: 'var(--stone-lo)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        [[253, 48, 2.6, 0.75], [256, 42, 3.4, 0.55], [260, 35, 4.2, 0.35]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2], fill: 'var(--stone-hi)', opacity: q[3] }); }),
        h('path', { d: 'M236 107v-11a5 5 0 0 1 10 0v11z', fill: 'var(--ic-peat)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('rect', { x: 228, y: 80, width: 5.5, height: 6, fill: 'var(--window)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('rect', { x: 250, y: 80, width: 5.5, height: 6, fill: 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M228 83h5.5M230.7 80v6', stroke: 'var(--timber)', strokeWidth: 0.5 }),
        h('path', { d: 'M259 90h7v-3', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.9 }),
        h('rect', { x: 264, y: 87, width: 4.5, height: 6, rx: 1, fill: 'var(--ic-gold)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M226 97h8v5h-8z', fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        Barrel(260, 101, 'b1'), Barrel(264.5, 102, 'b2'), Barrel(262, 96.5, 'b3')),
      // Vásártér: standok, ládák, szekér, kút
      h('g', null,
        h('rect', { x: 146, y: 156, width: 80, height: 50, rx: 3, className: 'tn-cv-square' }),
        Stall(151, 162, 'var(--roof-red)', 's1'), Stall(172, 162, 'var(--roof-blue)', 's2'), Stall(196, 162, 'var(--map-field)', 's3'), Stall(151, 186, 'var(--roof-teal)', 's4'), Stall(203, 186, 'var(--roof-red)', 's5'),
        Crate(170, 196, 'k1'), Crate(174.5, 196, 'k2'), Crate(172, 192, 'k3'),
        h('ellipse', { cx: 196, cy: 199, rx: 2.4, ry: 2, fill: 'var(--ic-cream)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('path', { d: 'M180 184.5l3-2.5h6l3 2.5v6l-3 2.5h-6l-3-2.5z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.8 }),
        h('path', { d: 'M181.8 185.4l2-1.6h4.4l2 1.6v4.2l-2 1.6h-4.4l-2-1.6z', fill: 'var(--map-sea)' }),
        h('path', { d: 'M186 187.5v-6', stroke: 'var(--stone-lo)', strokeWidth: 1.4 }), h('circle', { cx: 186, cy: 181, r: 1.2, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('path', { d: 'M183.6 186.5q2.4-2 4.8 0', stroke: 'var(--map-sea-line)', strokeWidth: 0.6, fill: 'none' }),
        h('g', { transform: 'translate(222 204)' }, Cart(0, 0))),
      // Fal, bástyák, kapuk
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--outline)', strokeWidth: 9, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone)', strokeWidth: 7, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone-hi)', strokeWidth: 2.2, strokeDasharray: '2.2 2.6', strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone-lo)', strokeWidth: 0.6, strokeLinejoin: 'round', transform: 'translate(0 2)' }),
      WALL.map(function (q, i) { var x = q[0], y = q[1]; return h('g', { key: 'tw' + i },
        h('ellipse', { cx: x + 1.5, cy: y + 6.5, rx: 8, ry: 2.4, fill: '#2c1f13', opacity: 0.25 }),
        h('rect', { x: x - 6, y: y - 7, width: 12, height: 13, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
        h('rect', { x: x + 1, y: y - 7, width: 5, height: 13, fill: '#000', opacity: 0.14 }),
        h('path', { d: 'M' + (x - 6) + ' ' + (y - 2.5) + 'h12M' + (x - 6) + ' ' + (y + 1.8) + 'h12', stroke: 'var(--stone-lo)', strokeWidth: 0.4 }),
        h('rect', { x: x - 0.7, y: y - 4.5, width: 1.4, height: 3, fill: 'var(--window-dark)' }),
        h('path', { d: 'M' + (x - 7.5) + ' ' + (y - 7) + 'L' + x + ' ' + (y - 18) + 'L' + (x + 7.5) + ' ' + (y - 7) + 'z', fill: 'var(--roof-red)', stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
        h('path', { d: 'M' + x + ' ' + (y - 18) + 'L' + (x + 7.5) + ' ' + (y - 7) + 'H' + x + 'z', fill: 'var(--roof-red-lo)', opacity: 0.8 }),
        h('path', { d: 'M' + (x - 4.4) + ' ' + (y - 11.5) + 'h8.8M' + (x - 2.4) + ' ' + (y - 14.5) + 'h4.8', stroke: 'var(--roof-red-lo)', strokeWidth: 0.5 })); }),
      GATES.map(function (g, i) { var x = g[0], y = g[1]; return h('g', { key: 'g' + i },
        h('rect', { x: x - 7, y: y - 5, width: 14, height: 10, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.9 }),
        h('path', { d: 'M' + (x - 7) + ' ' + (y - 5) + 'v-2h2.4v2h2.4v-2h2.4v2h2.4v-2h2.4v2h2v-2', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M' + (x - 3.4) + ' ' + (y + 5) + 'v-4.4a3.4 3.4 0 0 1 6.8 0V' + (y + 5) + 'z', fill: 'var(--window-dark)' }),
        h('path', { d: 'M' + (x - 1.7) + ' ' + (y - 1) + 'v6M' + x + ' ' + (y - 2.2) + 'v7.2M' + (x + 1.7) + ' ' + (y - 1) + 'v6M' + (x - 3.2) + ' ' + (y + 1.5) + 'h6.4', stroke: 'var(--stone-lo)', strokeWidth: 0.45 })); }),
      p.coast ? h('g', null,
        [[300, 200, 324, 216], [284, 214, 304, 232]].map(function (q, i) { return h('g', { key: 'pier' + i }, h('path', { d: 'M' + q[0] + ' ' + q[1] + 'L' + q[2] + ' ' + q[3], stroke: 'var(--outline)', strokeWidth: 6.5, strokeLinecap: 'butt' }), h('path', { d: 'M' + q[0] + ' ' + q[1] + 'L' + q[2] + ' ' + q[3], stroke: 'var(--ic-brown-hi)', strokeWidth: 4.8, strokeLinecap: 'butt' }), h('path', { d: 'M' + q[0] + ' ' + q[1] + 'L' + q[2] + ' ' + q[3], stroke: 'var(--ic-brown)', strokeWidth: 4.8, strokeDasharray: '0.6 2.2' })); }),
        h(Ship, { x: 332, y: 244 }), h(Ship, { x: 344, y: 190 })) : null,
      Object.keys(DISTRICTS).map(function (k) {
        var D = DISTRICTS[k], v = dom(k), f = D.flag;
        return h('g', { key: 'fl' + k },
          v.contested ? h(Pennant, { x: f[0] + 12, y: f[1] + 4, tincture: v.contested }) : null,
          v.dominant ? h(Pennant, { x: f[0], y: f[1], tincture: v.dominant }) : null,
          h('text', { x: D.label[0], y: D.label[1], textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, D.name));
      }),
      stab === 'lazongo' ? [[86, 196], [270, 150], [120, 60]].map(function (q, i) { return h(Flame, { key: 'fx' + i, x: q[0], y: q[1] }); }) : null,
      stab === 'ingatag' ? h('g', { fill: 'var(--stone-hi)', stroke: 'var(--stone-lo)', strokeWidth: 0.7, opacity: 0.8 }, [[290, 150, 4], [293, 141, 5], [289, 130, 6.5], [284, 120, 5]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2] }); })) : null,
      h('rect', { width: 360, height: 280, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      p.onSelect ? Object.keys(DISTRICTS).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: DISTRICTS[k].poly.map(WC).join(' '), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': DISTRICTS[k].name, 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }
/*@@TickTimer*/
  function TickTimer(p) {
    return h('span', { className: cx('tn-tick', p.soon && 'tn-tick-soon') }, h(GameIcon, { name: 'homokora', size: 18 }),
      h('span', null, 'Elszámolás ', p.at ? h('b', null, p.at) : null), p.remaining ? h('span', { className: 'tn-tick-rem' }, p.remaining) : null);
  }
/*@@NavBar*/
  var NAV_ART = { terkep: 'navTerkep', varos: 'navVaros', kem: 'navJel', pp: 'pp', legit: 'navRang', diplomacia: 'program' };
  function NavBar(p) {
    return h('nav', { className: 'tn-nav', 'aria-label': 'Fő navigáció' }, (p.items || []).map(function (it) {
      var on = it.id === p.active, art = it.art || NAV_ART[it.icon];
      return h('button', { key: it.id, className: cx('tn-nav-item', on && 'tn-on'), 'aria-current': on ? 'page' : undefined, onClick: p.onChange ? function () { p.onChange(it.id); } : undefined },
        h('span', { className: 'tn-nav-icon' }, art ? h(GameIcon, { name: art, size: 28 }) : h(Icon, { name: it.icon, size: 22 }), it.badge ? h('span', { className: 'tn-nav-badge' }, it.badge) : null), h('span', { className: 'tn-nav-label' }, it.label));
    }));
  }
