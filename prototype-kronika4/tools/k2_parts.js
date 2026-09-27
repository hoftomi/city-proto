/*@@MapCanvas*/
  function tufts(seed, w, hh, n) {
    var r = rng(seed), d = [];
    for (var i = 0; i < n; i++) { var x = r() * w, y = r() * hh; d.push('M' + x.toFixed(1) + ' ' + y.toFixed(1) + 'l.7-2.1l.7 2.1l.6-1.5'); }
    return d.join('');
  }
  function groundPatches(seed, w, hh, n) {
    var r = rng(seed), o = [], cols = ['var(--map-grass-hi)', 'var(--map-grass-lo)', 'var(--map-tuft)', 'var(--map-field-2)'];
    for (var i = 0; i < n; i++) { var rx = 3 + r() * 13, k = Math.floor(r() * 10); o.push(h('ellipse', { key: i, cx: (r() * w).toFixed(1), cy: (r() * hh).toFixed(1), rx: rx.toFixed(1), ry: (rx * (0.35 + r() * 0.3)).toFixed(1), fill: cols[k < 5 ? 0 : k < 8 ? 1 : k < 9 ? 2 : 3], opacity: (0.18 + r() * 0.3).toFixed(2) })); }
    return o;
  }
  function flowers(seed, w, hh, n) {
    var r = rng(seed), o = [];
    for (var i = 0; i < n; i++) o.push(h('circle', { key: i, cx: (r() * w).toFixed(1), cy: (r() * hh).toFixed(1), r: 0.45, fill: r() < 0.5 ? '#f3ead0' : '#e2bf5e', opacity: 0.85 }));
    return o;
  }
  function MapCanvas(p) {
    var w = p.width || 360, hh = p.height || 240, gid = useUid('g'), vid = useUid('v'), lid = useUid('l'), seed = 'mc' + (p.title || '') + w, ticks = [];
    for (var x = 10; x < w; x += 10) ticks.push('M' + x + ' 0v' + (x % 50 ? 1.6 : 3.2) + 'M' + x + ' ' + hh + 'v-' + (x % 50 ? 1.6 : 3.2));
    for (var y = 10; y < hh; y += 10) ticks.push('M0 ' + y + 'h' + (y % 50 ? 1.6 : 3.2) + 'M' + w + ' ' + y + 'h-' + (y % 50 ? 1.6 : 3.2));
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h('defs', null,
        h('radialGradient', { id: gid, cx: '42%', cy: '38%', r: '85%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' })),
        h('radialGradient', { id: lid, cx: '25%', cy: '15%', r: '70%' }, h('stop', { offset: '0%', stopColor: '#fff4cf', stopOpacity: 0.22 }), h('stop', { offset: '100%', stopColor: '#fff4cf', stopOpacity: 0 })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '68%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.32 }))),
      h('rect', { width: w, height: hh, fill: 'url(#' + gid + ')' }),
      h('g', { 'aria-hidden': true }, groundPatches(seed, w, hh, 170),
        h('path', { d: tufts(seed, w, hh, 420), stroke: 'var(--map-tuft)', strokeWidth: 0.45, fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round', opacity: 0.75 }),
        flowers(seed, w, hh, 90)),
      p.children,
      h('rect', { width: w, height: hh, fill: 'url(#' + lid + ')', pointerEvents: 'none' }),
      h('rect', { width: w, height: hh, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      h('g', { pointerEvents: 'none', 'aria-hidden': true },
        h('rect', { x: 2.5, y: 2.5, width: w - 5, height: hh - 5, fill: 'none', stroke: 'var(--frame-lo)', strokeWidth: 0.5, opacity: 0.7 }),
        h('path', { d: ticks.join(''), stroke: 'var(--outline)', strokeWidth: 0.45, opacity: 0.55 })));
  }
/*@@Ripples*/
  function Ripples(p) {
    var cid = useUid('sea'), r = rng('w' + p.d.length), waves = [], coast = p.d.split(/[HV]/)[0], rocks = [];
    for (var y = 5; y < 300; y += 9) for (var x = 3 + (y % 18 ? 6 : 0); x < 380; x += 13) waves.push([x + (r() - 0.5) * 6, y + (r() - 0.5) * 4, 2 + r() * 2.6]);
    return h('g', null,
      h('clipPath', { id: cid }, h('path', { d: p.d })),
      h('path', { d: coast, fill: 'none', stroke: 'var(--map-road-lo)', strokeWidth: 13, strokeLinejoin: 'round', opacity: 0.45 }),
      h('path', { d: coast, fill: 'none', stroke: 'var(--map-sand)', strokeWidth: 10, strokeLinejoin: 'round' }),
      h('path', { d: coast, fill: 'none', stroke: '#eadbb0', strokeWidth: 5, strokeLinejoin: 'round', strokeDasharray: '1 2.2', opacity: 0.8 }),
      h('path', { d: p.d, fill: 'var(--map-sea-deep)' }),
      h('g', { clipPath: 'url(#' + cid + ')' },
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 60, opacity: 0.8 }),
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 34 }),
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea-hi)', strokeWidth: 15, opacity: 0.9 }),
        h('path', { d: coast, fill: 'none', stroke: '#c3dcd9', strokeWidth: 5, opacity: 0.8 }),
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 1.6, strokeDasharray: '9 4 2 4', opacity: 0.95 }),
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.7, strokeDasharray: '5 7', opacity: 0.7, transform: 'translate(4 0)' }),
        h('path', { d: coast, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.5, strokeDasharray: '3 9', opacity: 0.55, transform: 'translate(9 0)' }),
        waves.map(function (q, i) { return h('path', { key: i, d: 'M' + q[0].toFixed(1) + ' ' + q[1].toFixed(1) + 'q' + (q[2] / 2).toFixed(1) + '-1.5 ' + q[2].toFixed(1) + ' 0', fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.55, strokeLinecap: 'round', opacity: 0.45 }); })),
      h('path', { d: coast, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.7, opacity: 0.6 }));
  }
/*@@Mountain*/
  function Mountain(p) {
    var s = p.s || 1, x = p.x, y = p.y, w = 13 * s, t = 17 * s, r = rng('mt' + x + y);
    function P(a) { return a.map(function (q, i) { return (i ? 'L' : 'M') + (x + q[0] * w).toFixed(1) + ' ' + (y - q[1] * t).toFixed(1); }).join('') + 'Z'; }
    var j1 = 0.5 + r() * 0.1, j2 = 0.42 + r() * 0.1;
    var sil = P([[-1, 0], [-0.62, 0.3], [-0.45, j1], [-0.15, 0.8], [0, 1], [0.25, 0.72], [0.4, 0.6], [0.55, j2], [0.8, 0.2], [1, 0]]);
    var lit = P([[0, 1], [-0.15, 0.8], [-0.45, j1], [-0.62, 0.3], [-1, 0], [-0.15, 0], [0.04, 0.45]]);
    var shade = P([[0, 1], [0.25, 0.72], [0.4, 0.6], [0.55, j2], [0.8, 0.2], [1, 0], [0.18, 0], [0.04, 0.45]]);
    var snow = P([[-0.3, 0.66], [-0.15, 0.8], [0, 1], [0.25, 0.72], [0.35, 0.63], [0.2, 0.58], [0.1, 0.66], [-0.02, 0.55], [-0.14, 0.63]]);
    var snowS = P([[0, 1], [0.25, 0.72], [0.35, 0.63], [0.2, 0.58], [0.1, 0.66], [0.02, 0.8]]);
    var hatch = [];
    for (var i = 0; i < 6; i++) { var f = 0.12 + i * 0.13; hatch.push('M' + (x + f * w).toFixed(1) + ' ' + (y - (1 - f) * t * 0.92).toFixed(1) + 'l' + (0.1 * w).toFixed(1) + ' ' + (0.22 * t).toFixed(1)); }
    var ridges = 'M' + (x - 0.45 * w) + ' ' + (y - j1 * t) + 'l' + (0.14 * w) + ' ' + (0.32 * t) + 'M' + (x - 0.15 * w) + ' ' + (y - 0.8 * t) + 'l' + (0.08 * w) + ' ' + (0.4 * t) + 'M' + (x + 0.04 * w) + ' ' + (y - 0.45 * t) + 'l' + (0.04 * w) + ' ' + (0.3 * t);
    return h('g', null,
      h('ellipse', { cx: x + 2.5, cy: y + 1, rx: w + 3, ry: 2.8 * s, fill: '#2c1f13', opacity: 0.2 }),
      h('path', { d: sil, fill: 'var(--map-rock)' }),
      h('path', { d: lit, fill: 'var(--map-rock-hi)' }),
      h('path', { d: shade, fill: 'var(--map-rock-lo)' }),
      h('path', { d: hatch.join(''), stroke: 'var(--map-relief)', strokeWidth: 0.4, strokeLinecap: 'round', opacity: 0.6 }),
      h('path', { d: ridges, stroke: 'var(--map-relief)', strokeWidth: 0.45, strokeLinecap: 'round', opacity: 0.7 }),
      h('path', { d: snow, fill: 'var(--map-snow)' }),
      h('path', { d: snowS, fill: 'var(--map-snow-lo)' }),
      h('path', { d: 'M' + (x - 0.3 * w) + ' ' + (y - 0.66 * t) + 'l' + (0.08 * w) + ' ' + (0.1 * t), stroke: 'var(--map-snow)', strokeWidth: 0.8, strokeLinecap: 'round' }),
      h('path', { d: sil, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.7, strokeLinejoin: 'round' }),
      h('ellipse', { cx: x + w * 0.72, cy: y - 0.6, rx: 2 * s, ry: 1.1 * s, fill: 'var(--map-rock-lo)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('ellipse', { cx: x - w * 0.55, cy: y - 0.3, rx: 1.4 * s, ry: 0.8 * s, fill: 'var(--map-rock)', stroke: 'var(--outline)', strokeWidth: 0.35 }));
  }
/*@@Forest*/
  function Tree(t, k) {
    var x = t.x, y = t.y, r = t.r, sw = Math.max(0.35, r * 0.13);
    if (t.pine) {
      var tiers = [[0, 1.6], [-0.85, 1.25], [-1.7, 0.9]];
      return h('g', { key: k },
        h('ellipse', { cx: x + r * 0.35, cy: y + r * 0.95, rx: r * 0.85, ry: r * 0.28, fill: '#2c1f13', opacity: 0.25 }),
        h('rect', { x: x - r * 0.16, y: y + r * 0.2, width: r * 0.32, height: r * 0.8, fill: 'var(--ic-brown)' }),
        tiers.map(function (q, i) {
          var ty = y + q[0] * r, ww = q[1] * r * 0.62;
          return h('g', { key: i }, h('path', { d: 'M' + (x - ww) + ' ' + (ty + r * 0.35) + 'L' + x + ' ' + (ty - r * 0.75) + 'L' + (x + ww) + ' ' + (ty + r * 0.35) + 'z', fill: 'var(--map-pine)', stroke: 'var(--outline)', strokeWidth: sw, strokeLinejoin: 'round' }),
            h('path', { d: 'M' + x + ' ' + (ty - r * 0.75) + 'L' + (x + ww) + ' ' + (ty + r * 0.35) + 'H' + x + 'z', fill: 'var(--map-forest-lo)', opacity: 0.8 }),
            h('path', { d: 'M' + (x - ww * 0.4) + ' ' + (ty) + 'l' + (ww * 0.25) + ' ' + (-r * 0.35), stroke: 'var(--map-forest-hi)', strokeWidth: sw * 0.9, strokeLinecap: 'round', opacity: 0.8 }));
        }));
    }
    return h('g', { key: k },
      h('ellipse', { cx: x + r * 0.4, cy: y + r + r * 0.35, rx: r * 0.95, ry: r * 0.3, fill: '#2c1f13', opacity: 0.25 }),
      h('rect', { x: x - r * 0.18, y: y, width: r * 0.36, height: r * 1.3, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: sw * 0.7 }),
      h('circle', { cx: x - r * 0.35, cy: y + r * 0.1, r: r * 0.72, fill: 'var(--map-forest-lo)', stroke: 'var(--outline)', strokeWidth: sw }),
      h('circle', { cx: x + r * 0.4, cy: y + r * 0.15, r: r * 0.7, fill: 'var(--map-forest-lo)', stroke: 'var(--outline)', strokeWidth: sw }),
      h('circle', { cx: x, cy: y - r * 0.35, r: r * 0.8, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: sw }),
      h('circle', { cx: x - r * 0.35, cy: y + r * 0.05, r: r * 0.5, fill: 'var(--map-forest)' }),
      h('circle', { cx: x - r * 0.3, cy: y - r * 0.6, r: r * 0.32, fill: 'var(--map-forest-hi)' }),
      t.fruit ? h('g', null, h('circle', { cx: x + r * 0.2, cy: y - r * 0.2, r: r * 0.12, fill: 'var(--ic-red)' }), h('circle', { cx: x - r * 0.4, cy: y + r * 0.2, r: r * 0.12, fill: 'var(--ic-red)' })) : null);
  }
  function Forest(p) {
    var r = rng('f' + p.x + p.y), n = p.n || 5, trees = [], cnt = Math.round(n * 2.4), sx = n * 3.4, sy = n * 1.7;
    for (var i = 0; i < cnt; i++) { var a = r() * Math.PI * 2, d = Math.sqrt(r()); trees.push({ x: p.x + Math.cos(a) * d * sx, y: p.y + Math.sin(a) * d * sy, r: (p.small ? 1.8 : 2.6) + r() * 1.5, pine: r() < (p.pine == null ? 0.45 : p.pine) }); }
    trees.sort(function (a, b) { return a.y - b.y; });
    return h('g', null,
      n > 2 ? h('ellipse', { cx: p.x + 1, cy: p.y + 2, rx: sx + 3, ry: sy + 2.5, fill: 'var(--map-forest-lo)', opacity: 0.35 }) : null,
      trees.map(function (t, i) { return Tree(t, i); }));
  }
/*@@Field*/
  var CROPS = ['var(--map-field)', 'var(--map-field-2)', 'var(--map-grass-hi)', '#b9b56a', '#c8a45a', 'var(--map-field)'];
  function Field(p) {
    var a = [], b = [], gap = 1.8, split = p.x + p.w * 0.55;
    for (var i = gap; i < p.h - 0.5; i += gap) a.push('M' + (p.x + 1) + ' ' + (p.y + i) + 'H' + (split - 0.6));
    for (var j = split + gap; j < p.x + p.w - 0.6; j += gap) b.push('M' + j + ' ' + (p.y + 1) + 'v' + (p.h - 2));
    return h('g', { transform: p.rot ? 'rotate(' + p.rot + ' ' + (p.x + p.w / 2) + ' ' + (p.y + p.h / 2) + ')' : undefined },
      h('rect', { x: p.x, y: p.y, width: split - p.x, height: p.h, fill: 'var(--map-field)' }),
      h('rect', { x: split, y: p.y, width: p.x + p.w - split, height: p.h, fill: 'var(--map-field-2)' }),
      h('path', { d: a.join(''), stroke: 'var(--map-field-lo)', strokeWidth: 0.45 }),
      h('path', { d: b.join(''), stroke: 'var(--map-grass-lo)', strokeWidth: 0.45 }),
      h('rect', { x: p.x, y: p.y, width: p.w, height: p.h, rx: 1, fill: 'none', stroke: 'var(--map-forest-lo)', strokeWidth: 1, opacity: 0.85 }),
      h('circle', { cx: p.x + p.w * 0.25, cy: p.y + p.h * 0.55, r: 1.1, fill: 'var(--map-field-lo)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('circle', { cx: p.x + p.w * 0.38, cy: p.y + p.h * 0.35, r: 1.1, fill: 'var(--map-field-lo)', stroke: 'var(--outline)', strokeWidth: 0.3 }));
  }
  function Farm(p) {
    var r = rng('farm' + p.x + p.y), cw = p.cw || 9, ch = p.ch || 6, o = [], hedges = [], bushes = [];
    for (var i = 0; i < p.cols; i++) for (var j = 0; j < p.rows; j++) {
      var x = p.x + i * cw, y = p.y + j * ch, c = CROPS[Math.floor(r() * CROPS.length)], vert = r() < 0.5, lines = [];
      o.push(h('rect', { key: 'c' + i + '-' + j, x: x, y: y, width: cw, height: ch, fill: c }));
      if (c !== 'var(--map-grass-hi)') { if (vert) for (var k = x + 1.4; k < x + cw - 0.6; k += 1.4) lines.push('M' + k.toFixed(1) + ' ' + (y + 0.6) + 'v' + (ch - 1.2)); else for (var q = y + 1.3; q < y + ch - 0.5; q += 1.3) lines.push('M' + (x + 0.6) + ' ' + q.toFixed(1) + 'h' + (cw - 1.2)); }
      else if (r() < 0.6) { o.push(h('circle', { key: 's' + i + j, cx: x + cw * 0.3, cy: y + ch * 0.5, r: 0.6, fill: '#f3ead0' })); o.push(h('circle', { key: 't' + i + j, cx: x + cw * 0.6, cy: y + ch * 0.4, r: 0.6, fill: '#f3ead0' })); }
      o.push(h('path', { key: 'l' + i + '-' + j, d: lines.join(''), stroke: '#00000030', strokeWidth: 0.35 }));
      if (r() < 0.55) hedges.push('M' + x + ' ' + (y + ch) + 'h' + cw); if (r() < 0.5) hedges.push('M' + (x + cw) + ' ' + y + 'v' + ch);
      if (r() < 0.3) bushes.push([x + cw * r(), y + ch]);
    }
    return h('g', { transform: p.rot ? 'rotate(' + p.rot + ' ' + p.x + ' ' + p.y + ')' : undefined },
      o,
      h('rect', { x: p.x, y: p.y, width: p.cols * cw, height: p.rows * ch, fill: 'none', stroke: 'var(--map-forest-lo)', strokeWidth: 1.1, opacity: 0.9 }),
      h('path', { d: hedges.join(''), stroke: 'var(--map-forest-lo)', strokeWidth: 0.8, opacity: 0.85 }),
      bushes.map(function (b, i) { return h('circle', { key: 'b' + i, cx: b[0], cy: b[1], r: 1.1, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: 0.3 }); }),
      p.house ? h('g', { transform: 'translate(' + (p.x - 4) + ' ' + (p.y - 2) + ')' }, MiniHouse(0, 0, 'var(--roof-red)', 'fh'), h('circle', { cx: 6, cy: 1.5, r: 1.3, fill: 'var(--map-field-lo)', stroke: 'var(--outline)', strokeWidth: 0.3 })) : null);
  }
  function MiniHouse(x, y, roof, k, w) {
    w = w || 4;
    return h('g', { key: k },
      h('ellipse', { cx: x + w * 0.6, cy: y + w * 0.78, rx: w * 0.7, ry: w * 0.18, fill: '#2c1f13', opacity: 0.25 }),
      h('rect', { x: x, y: y, width: w, height: w * 0.62, fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('path', { d: 'M' + (x + w) + ' ' + y + 'l' + (w * 0.3) + ' ' + (-w * 0.14) + 'v' + (w * 0.6) + 'l' + (-w * 0.3) + ' ' + (w * 0.16) + 'z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.25 }),
      h('path', { d: 'M' + (x - 0.4) + ' ' + (y + 0.2) + 'L' + (x + w / 2) + ' ' + (y - w * 0.5) + 'L' + (x + w + 0.4) + ' ' + (y + 0.2) + 'z', fill: roof, stroke: 'var(--outline)', strokeWidth: 0.3, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x + w / 2) + ' ' + (y - w * 0.5) + 'l' + (w * 0.3) + ' ' + (-w * 0.14) + 'L' + (x + w + 0.4 + w * 0.3) + ' ' + (y + 0.2 - w * 0.14) + 'L' + (x + w + 0.4) + ' ' + (y + 0.2) + 'z', fill: roof, stroke: 'var(--outline)', strokeWidth: 0.25, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x + w / 2) + ' ' + (y - w * 0.5) + 'l' + (w * 0.3) + ' ' + (-w * 0.14) + 'L' + (x + w + 0.4 + w * 0.3) + ' ' + (y + 0.2 - w * 0.14) + 'L' + (x + w + 0.4) + ' ' + (y + 0.2) + 'z', fill: '#000', opacity: 0.22 }),
      h('rect', { x: x + w * 0.4, y: y + w * 0.3, width: w * 0.2, height: w * 0.32, fill: 'var(--timber)' }),
      h('rect', { x: x + w * 0.12, y: y + w * 0.14, width: w * 0.16, height: w * 0.16, fill: 'var(--window)' }));
  }
/*@@Marsh*/
  function Marsh(p) {
    var r = rng('m' + p.x), reeds = [], heads = [], pools = [];
    for (var i = 0; i < (p.n || 5) * 2; i++) {
      var x = p.x + (r() - 0.5) * 34, y = p.y + (r() - 0.5) * 16;
      if (i % 3 === 0) pools.push(h('g', { key: 'p' + i }, h('ellipse', { cx: x + 3, cy: y + 1, rx: 4 + r() * 3, ry: 1.7, fill: 'var(--map-sea)', stroke: 'var(--map-sea-deep)', strokeWidth: 0.6 }), h('path', { d: 'M' + (x + 1) + ' ' + (y + 0.6) + 'h3', stroke: 'var(--map-sea-line)', strokeWidth: 0.4, opacity: 0.8 })));
      reeds.push('M' + x + ' ' + y + 'l-1.2-3.8M' + x + ' ' + y + 'v-4.6M' + x + ' ' + y + 'l1.3-3.5');
      heads.push(h('ellipse', { key: 'h' + i, cx: x, cy: y - 4.8, rx: 0.55, ry: 1.2, fill: 'var(--ic-brown)' }));
    }
    return h('g', null, h('ellipse', { cx: p.x, cy: p.y, rx: 19, ry: 9, fill: '#7f9660', opacity: 0.35 }), pools, h('path', { d: reeds.join(''), stroke: 'var(--map-forest-lo)', strokeWidth: 0.6, strokeLinecap: 'round', fill: 'none' }), heads);
  }
/*@@MapTerrain*/
  function Hill(x, y, s, k) {
    var w = 10 * s, t = 6 * s;
    return h('g', { key: k },
      h('path', { d: 'M' + (x - w) + ' ' + y + 'C' + (x - w * 0.55) + ' ' + (y - t) + ' ' + (x + w * 0.55) + ' ' + (y - t) + ' ' + (x + w) + ' ' + y + 'z', fill: 'var(--map-grass-hi)' }),
      h('path', { d: 'M' + (x + w * 0.05) + ' ' + (y - t * 0.74) + 'C' + (x + w * 0.5) + ' ' + (y - t * 0.7) + ' ' + (x + w * 0.8) + ' ' + (y - t * 0.3) + ' ' + (x + w) + ' ' + y + 'H' + (x + w * 0.1) + 'z', fill: 'var(--map-grass-lo)', opacity: 0.55 }),
      h('path', { d: 'M' + (x + w * 0.3) + ' ' + (y - t * 0.55) + 'l.8 2M' + (x + w * 0.5) + ' ' + (y - t * 0.45) + 'l.8 2M' + (x + w * 0.68) + ' ' + (y - t * 0.3) + 'l.7 1.8', stroke: 'var(--map-tuft)', strokeWidth: 0.4, strokeLinecap: 'round' }),
      h('path', { d: 'M' + (x - w) + ' ' + y + 'C' + (x - w * 0.55) + ' ' + (y - t) + ' ' + (x + w * 0.55) + ' ' + (y - t) + ' ' + (x + w) + ' ' + y, fill: 'none', stroke: 'var(--map-tuft)', strokeWidth: 0.55 }));
  }
  function Village(x, y, n, k) {
    var r = rng('v' + x + y), hs = [], roofs = ['var(--roof-red)', 'var(--roof-brown)', 'var(--roof-red)', 'var(--roof-blue)'];
    for (var i = 0; i < n; i++) hs.push([x + (r() - 0.5) * n * 3.2, y + (r() - 0.5) * n * 1.6, roofs[Math.floor(r() * 4)]]);
    hs.sort(function (a, b) { return a[1] - b[1]; });
    return h('g', { key: k },
      h('ellipse', { cx: x + 1, cy: y + 1.5, rx: n * 2.4, ry: n * 1.2, fill: 'var(--map-road)', opacity: 0.55 }),
      h('path', { d: 'M' + (x - n * 2.6) + ' ' + (y + 1) + 'q' + (n * 2.6) + ' 2 ' + (n * 5.2) + ' -1', stroke: 'var(--map-road-lo)', strokeWidth: 0.6, fill: 'none', opacity: 0.8 }),
      hs.map(function (q, i) { return MiniHouse(q[0], q[1], q[2], i, 3.4); }),
      h('g', { transform: 'translate(' + (x + 1) + ' ' + (y - 3) + ')' },
        h('rect', { x: -1, y: -5, width: 2.4, height: 6, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
        h('path', { d: 'M-1.4-5l1.6-3 1.6 3z', fill: 'var(--roof-blue)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
        h('rect', { x: -0.3, y: -3.8, width: 0.9, height: 1.2, fill: 'var(--window-dark)' })));
  }
  function Windmill(x, y, k, rot) {
    var a = rot == null ? 18 : rot, blades = [];
    for (var i = 0; i < 4; i++) blades.push(h('g', { key: i, transform: 'rotate(' + (a + i * 90) + ')' }, h('path', { d: 'M0 0v-7', stroke: 'var(--timber)', strokeWidth: 0.4 }), h('rect', { x: 0, y: -7, width: 1.6, height: 5.2, fill: 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 0.25 }), h('path', { d: 'M0-6h1.6M0-4.6h1.6M0-3.2h1.6', stroke: 'var(--line-strong)', strokeWidth: 0.2 })));
    return h('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' },
      h('ellipse', { cx: 1.2, cy: 0.4, rx: 3.4, ry: 0.9, fill: '#2c1f13', opacity: 0.25 }),
      h('path', { d: 'M-2.2 0l.8-7h2.8l.8 7z', fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
      h('path', { d: 'M.7-7l.8 7h.7l-.8-7z', fill: '#000', opacity: 0.15 }),
      h('path', { d: 'M-1.8-7l1.8-2.2 1.8 2.2z', fill: 'var(--roof-brown)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('rect', { x: -0.5, y: -2, width: 1, height: 2, fill: 'var(--timber)' }),
      h('g', { transform: 'translate(0 -7.4)' }, blades, h('circle', { r: 0.6, fill: 'var(--timber)' })));
  }
  function Mine(x, y, k) {
    return h('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' },
      h('path', { d: 'M-7 2C-6-4-2-6 1-6S7-3 8 2z', fill: 'var(--map-rock)', stroke: 'var(--outline)', strokeWidth: 0.45 }),
      h('path', { d: 'M1-6C4-6 7-3 8 2H2z', fill: 'var(--map-rock-lo)', opacity: 0.7 }),
      h('path', { d: 'M-2.2 2v-3.2a2.2 2.2 0 0 1 4.4 0V2z', fill: 'var(--window-dark)' }),
      h('path', { d: 'M-2.6 2v-3.6h5.2V2M-2.8-1.6h5.6', fill: 'none', stroke: 'var(--timber)', strokeWidth: 0.6 }),
      h('path', { d: 'M0 2l-4 5M1 2l-2 5.4M-3.2 4h2.6M-4.4 5.6h2.4', stroke: 'var(--ic-steel-lo)', strokeWidth: 0.35 }),
      h('rect', { x: -5.6, y: 3.6, width: 3, height: 1.8, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.25 }),
      h('path', { d: 'M-5.3 3.6h2.4', stroke: 'var(--ic-black)', strokeWidth: 0.8 }));
  }
  function Lighthouse(x, y, k) {
    var gid = 'lh' + x + y;
    return h('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' },
      h('defs', null, h('radialGradient', { id: gid }, h('stop', { offset: '0%', stopColor: '#fff2c4', stopOpacity: 0.9 }), h('stop', { offset: '100%', stopColor: '#fff2c4', stopOpacity: 0 }))),
      h('ellipse', { cx: 0, cy: 1, rx: 6, ry: 2.4, fill: 'var(--map-rock-lo)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('path', { d: 'M-4 1c1-2 3-2.6 5-2.4s3 .8 3 2.4', fill: 'var(--map-rock)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
      h('path', { d: 'M-1.8 0l.6-9h2.4l.6 9z', fill: '#f3ecdc', stroke: 'var(--outline)', strokeWidth: 0.35 }),
      h('path', { d: 'M-1.62-2.7h3.24l.14 1.8h-3.52zM-1.34-6.8h2.68l.12 1.8h-2.92z', fill: 'var(--btn-red)' }),
      h('circle', { cx: 0, cy: -10.4, r: 7, fill: 'url(#' + gid + ')' }),
      h('rect', { x: -1.5, y: -11.4, width: 3, height: 2.4, fill: 'var(--window)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('path', { d: 'M-1.9-11.4L0-13l1.9 1.6z', fill: 'var(--btn-red)', stroke: 'var(--outline)', strokeWidth: 0.3 }));
  }
  function Whale(x, y, k) {
    return h('g', { key: k, transform: 'translate(' + x + ' ' + y + ')' },
      h('path', { d: 'M-5 1q5-3 10 0', stroke: 'var(--map-sea-line)', strokeWidth: 0.6, fill: 'none', opacity: 0.8 }),
      h('path', { d: 'M0 0c-.4-2-.2-3.4.6-4.6c-1.2.2-3 -.4-3.8-1.6c1.8 0 3.4.4 4 1.2c.6-.8 2.2-1.2 4-1.2c-.8 1.2-2.6 1.8-3.8 1.6c.8 1.2 1 2.6.6 4.6z', fill: 'var(--roof-blue-lo)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
      h('path', { d: 'M-3.6 1.4q1-.8 2 0M1.6 1.4q1-.8 2 0', stroke: 'var(--map-sea-line)', strokeWidth: 0.5, fill: 'none' }));
  }
  function Island(p, k) {
    var r = rng('is' + p[0]), trees = [];
    for (var i = 0; i < 3; i++) trees.push({ x: p[0] + (r() - 0.5) * p[2] * 0.9, y: p[1] + (r() - 0.6) * p[2] * 0.3, r: 1.8 + r(), pine: r() < 0.5 });
    return h('g', { key: k },
      h('ellipse', { cx: p[0], cy: p[1] + 1.2, rx: p[2] + 3, ry: p[2] * 0.45 + 2, fill: 'var(--map-sea-hi)', opacity: 0.9 }),
      h('ellipse', { cx: p[0], cy: p[1], rx: p[2] + 1.2, ry: p[2] * 0.45 + 0.8, fill: 'var(--map-sand)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
      h('ellipse', { cx: p[0] - 0.6, cy: p[1] - 0.6, rx: p[2] - 0.6, ry: p[2] * 0.4 - 0.4, fill: 'var(--map-grass)' }),
      trees.map(function (t, i) { return Tree(t, i); }));
  }
  function Lake(p, k) {
    var cid = 'lk' + k + p[0];
    var d = 'M' + (p[0] - p[2]) + ' ' + p[1] + 'C' + (p[0] - p[2]) + ' ' + (p[1] - p[3] * 1.1) + ' ' + (p[0] + p[2] * 0.8) + ' ' + (p[1] - p[3] * 1.2) + ' ' + (p[0] + p[2]) + ' ' + (p[1] - p[3] * 0.1) + 'C' + (p[0] + p[2] * 1.1) + ' ' + (p[1] + p[3]) + ' ' + (p[0] - p[2] * 0.6) + ' ' + (p[1] + p[3] * 1.2) + ' ' + (p[0] - p[2]) + ' ' + p[1] + 'Z';
    return h('g', { key: k },
      h('clipPath', { id: cid }, h('path', { d: d })),
      h('path', { d: d, fill: 'none', stroke: 'var(--map-grass-lo)', strokeWidth: 4 }),
      h('path', { d: d, fill: 'var(--map-sea-deep)' }),
      h('g', { clipPath: 'url(#' + cid + ')' }, h('path', { d: d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 10 }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea-hi)', strokeWidth: 3.5 }),
        h('path', { d: 'M' + (p[0] - p[2] * 0.4) + ' ' + p[1] + 'h' + (p[2] * 0.5) + 'M' + (p[0] - p[2] * 0.1) + ' ' + (p[1] + 2) + 'h' + (p[2] * 0.4), stroke: 'var(--map-sea-line)', strokeWidth: 0.5, opacity: 0.7 })),
      h('path', { d: d, fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.5, opacity: 0.6 }));
  }
  function Bridge(b, k) {
    return h('g', { key: k, transform: 'translate(' + b[0] + ' ' + b[1] + ') rotate(' + (b[2] || 0) + ')' },
      h('rect', { x: -4.5, y: -1.8, width: 9, height: 3.6, rx: 0.6, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.45 }),
      h('path', { d: 'M-4.5-1.8h9M-4.5 1.8h9', stroke: 'var(--stone-lo)', strokeWidth: 0.7 }),
      h('path', { d: 'M-2.4 1.8a1.4 1.2 0 0 1 2.8 0M.8 1.8a1.4 1.2 0 0 1 2.8 0', fill: 'var(--map-sea-deep)', stroke: 'var(--outline)', strokeWidth: 0.3 }));
  }
  function MapTerrain(p) {
    var rivers = (p.rivers || []).map(function (r) { return typeof r === 'string' ? { d: r, w: 3.4 } : r; });
    return h('g', { className: 'tn-terrain', 'aria-hidden': true },
      (p.farms || []).map(function (f, i) { return h(Farm, { key: 'fa' + i, x: f[0], y: f[1], cols: f[2], rows: f[3], rot: f[4], house: f[5] }); }),
      (p.fields || []).map(function (f, i) { return h(Field, { key: 'fd' + i, x: f[0], y: f[1], w: f[2], h: f[3], rot: f[4] }); }),
      (p.lakes || []).map(function (l, i) { return Lake(l, 'lk' + i); }),
      p.sea ? h(Ripples, { d: p.sea }) : null,
      (p.islands || []).map(function (l, i) { return Island(l, 'is' + i); }),
      rivers.map(function (r, i) { return h('g', { key: 'r' + i },
        h('path', { d: r.d, fill: 'none', stroke: 'var(--map-grass-lo)', strokeWidth: r.w + 4, strokeLinecap: 'round', opacity: 0.8 }),
        h('path', { d: r.d, fill: 'none', stroke: 'var(--map-sand)', strokeWidth: r.w + 1.8, strokeLinecap: 'round', opacity: 0.8 }),
        h('path', { d: r.d, fill: 'none', stroke: 'var(--map-sea-deep)', strokeWidth: r.w + 0.6, strokeLinecap: 'round' }),
        h('path', { d: r.d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: r.w - 0.6, strokeLinecap: 'round' }),
        h('path', { d: r.d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.5, strokeLinecap: 'round', strokeDasharray: '4 6', opacity: 0.85 })); }),
      (p.bridges || []).map(function (b, i) { return Bridge(b, 'br' + i); }),
      (p.marsh || []).map(function (m, i) { return h(Marsh, { key: 'ms' + i, x: m[0], y: m[1], n: m[2] }); }),
      (p.hills || []).slice().sort(function (a, b) { return a[1] - b[1]; }).map(function (m, i) { return Hill(m[0], m[1], m[2] || 1, 'hl' + i); }),
      (p.mountains || []).slice().sort(function (a, b) { return a[1] - b[1]; }).map(function (m, i) { return h(Mountain, { key: 'mt' + i, x: m[0], y: m[1], s: m[2] }); }),
      (p.mines || []).map(function (m, i) { return Mine(m[0], m[1], 'mn' + i); }),
      (p.forests || []).map(function (f, i) { return h(Forest, { key: 'fo' + i, x: f[0], y: f[1], n: f[2], pine: f[3] }); }),
      (p.villages || []).map(function (v, i) { return Village(v[0], v[1], v[2] || 4, 'vl' + i); }),
      (p.windmills || []).map(function (v, i) { return Windmill(v[0], v[1], 'wm' + i, v[2]); }),
      (p.lighthouses || []).map(function (v, i) { return Lighthouse(v[0], v[1], 'lh' + i); }),
      (p.ships || []).map(function (v, i) { return h('g', { key: 'sh' + i, transform: 'translate(' + v[0] + ' ' + v[1] + ') scale(' + (v[2] || 0.55) + ')' }, h(Ship, { x: 0, y: 0 })); }),
      (p.whales || []).map(function (v, i) { return Whale(v[0], v[1], 'wh' + i); }),
      (p.labels || []).map(function (l, i) { return h('text', { key: 'lb' + i, x: l[0], y: l[1], textAnchor: 'middle', className: 'tn-map-label' + (l[3] ? ' tn-map-label-' + l[3] : ''), transform: l[4] ? 'rotate(' + l[4] + ' ' + l[0] + ' ' + l[1] + ')' : undefined }, l[2]); }));
  }
/*@@MapCity*/
  function MapCity(p) {
    var st = p.state || 'reachable', s = p.keyCity ? 1.2 : 1, ly = p.keyCity ? 24 : 20;
    var rc = st === 'cut' ? 'danger' : st === 'unreachable' ? 'grey' : p.keyCity ? 'blue' : 'red', len = String(p.name).length * (p.keyCity ? 6.4 : 5.6) + 10;
    return h('g', { className: cx('tn-city', 'tn-city-' + st, p.keyCity && 'tn-city-key'), transform: 'translate(' + p.x + ' ' + p.y + ')' },
      st === 'reachable' ? h('ellipse', { className: 'tn-city-halo', cx: 0, cy: 6, rx: 25 * s, ry: 11 * s }) : null,
      st === 'cut' ? h('ellipse', { cx: 0, cy: 6, rx: 25 * s, ry: 11 * s, fill: 'none', stroke: 'var(--danger)', strokeWidth: 1.6, strokeDasharray: '4 3' }) : null,
      h('g', { transform: 'scale(' + s + ')', className: 'tn-city-art' }, town(s, rc, p.keyCity, p.name)),
      h('g', { className: 'tn-city-banner' },
        h('path', { d: 'M' + (-len / 2 - 3) + ' ' + (ly - 6.5) + 'h3v8h-3l1.6-4z', fill: 'var(--paper-sunk)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('path', { d: 'M' + (len / 2 + 3) + ' ' + (ly - 6.5) + 'h-3v8h3l-1.6-4z', fill: 'var(--paper-sunk)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('rect', { x: -len / 2, y: ly - 8, width: len, height: 10, rx: 1.4, fill: st === 'unreachable' ? '#e6dcc6' : 'var(--paper-raised)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M' + (-len / 2 + 2) + ' ' + (ly - 6.6) + 'h' + (len - 4), stroke: 'var(--frame)', strokeWidth: 0.5 })),
      h('text', { className: 'tn-city-label', x: 0, y: ly, textAnchor: 'middle' }, p.name),
      p.stability && STAB_MARK[p.stability] ? h('g', { transform: 'translate(' + (17 * s) + ' ' + (p.keyCity ? -32 : -26) + ')' }, h('path', { d: 'M0-7l6.5 11.5h-13z', className: 'tn-stab-bubble tn-stab-' + p.stability }), h('text', { className: 'tn-city-stab', y: 3.2, textAnchor: 'middle' }, STAB_MARK[p.stability])) : null);
  }
  function town(s, rc, key, seed) {
    var o = [], R = roofPair(rc), r = rng('town' + seed), sw = 0.5 / s;
    function el(t, a) { o.push(h(t, Object.assign({ key: o.length, stroke: 'var(--outline)', strokeWidth: sw, strokeLinejoin: 'round' }, a))); }
    function nos(t, a) { o.push(h(t, Object.assign({ key: o.length, stroke: 'none' }, a))); }
    function tw(x, y, big) {
      var w = big ? 4.4 : 3.4, hh = big ? 7 : 5.2;
      el('rect', { x: x - w / 2, y: y - hh, width: w, height: hh, fill: 'var(--stone-hi)' });
      nos('rect', { x: x + w * 0.1, y: y - hh, width: w * 0.4, height: hh, fill: '#000', opacity: 0.15 });
      el('rect', { x: x - 0.35, y: y - hh * 0.7, width: 0.7, height: 1.4, fill: 'var(--window-dark)', strokeWidth: 0.2 / s });
      el('path', { d: 'M' + (x - w / 2 - 0.7) + ' ' + (y - hh) + 'L' + x + ' ' + (y - hh - w * 1.1) + 'L' + (x + w / 2 + 0.7) + ' ' + (y - hh) + 'z', fill: R[0] });
      nos('path', { d: 'M' + x + ' ' + (y - hh - w * 1.1) + 'L' + (x + w / 2 + 0.7) + ' ' + (y - hh) + 'H' + x + 'z', fill: R[1], opacity: 0.8 });
    }
    var roofs = [R[0], 'var(--roof-red)', 'var(--roof-brown)', 'var(--roof-red)', 'var(--roof-teal)'];
    function house(x, y, w) {
      var rf = roofs[Math.floor(r() * roofs.length)], d = w * 0.3, hh = w * 0.6;
      el('rect', { x: x, y: y, width: w, height: hh, fill: 'var(--map-block)' });
      el('path', { d: 'M' + (x + w) + ' ' + y + 'l' + d + ' ' + (-d * 0.5) + 'v' + hh + 'l' + (-d) + ' ' + (d * 0.5) + 'z', fill: 'var(--stone)' });
      el('path', { d: 'M' + (x - 0.3) + ' ' + y + 'L' + (x + w / 2) + ' ' + (y - w * 0.5) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + 0.3 + d) + ' ' + (y - d * 0.5) + 'L' + (x + w + 0.3) + ' ' + y + 'z', fill: rf });
      nos('path', { d: 'M' + (x + w / 2) + ' ' + (y - w * 0.5) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + 0.3 + d) + ' ' + (y - d * 0.5) + 'L' + (x + w + 0.3) + ' ' + y + 'z', fill: '#000', opacity: 0.2 });
      if (r() < 0.6) nos('rect', { x: x + w * 0.2, y: y + hh * 0.25, width: w * 0.2, height: w * 0.2, fill: r() < 0.5 ? 'var(--window)' : 'var(--window-dark)' });
      nos('rect', { x: x + w * 0.55, y: y + hh * 0.45, width: w * 0.2, height: hh * 0.55, fill: 'var(--timber)' });
    }
    nos('ellipse', { cx: 2, cy: 9, rx: 23, ry: 6.5, fill: '#2c1f13', opacity: 0.26 });
    if (key) { house(-27, 2, 4); house(22, 3, 4); house(-24, 7, 3.6); house(19, 8, 3.4); }
    el('ellipse', { cx: 0, cy: 1.5, rx: 18, ry: 9.5, fill: '#d8c59b' });
    nos('path', { d: 'M-12 2h24M0-6v16', stroke: 'var(--map-road)', strokeWidth: 1.6 });
    o.push(h('path', { key: o.length, d: 'M-18 1.5A18 9.5 0 0 1 18 1.5', fill: 'none', stroke: 'var(--outline)', strokeWidth: 2.8 }));
    o.push(h('path', { key: o.length, d: 'M-18 1.5A18 9.5 0 0 1 18 1.5', fill: 'none', stroke: 'var(--stone)', strokeWidth: 1.9 }));
    tw(-11, -5.4); tw(11, -5.4);
    [[-14, -2, 4], [-9, -4, 4.2], [7, -4, 4], [11, -2, 4.4], [-15, 3, 4], [11, 3, 4.2], [-9, 1, 3.8], [6, 1, 3.8]].forEach(function (q) { house(q[0], q[1], q[2]); });
    o.push(h('g', { key: o.length, transform: 'translate(0 ' + (key ? 1.5 : 2.5) + ') scale(' + (key ? 0.66 : 0.58) + ')' }, castle(s * (key ? 0.66 : 0.58), rc, key)));
    [[-13, 6.2, 3.6], [-7, 7.4, 3.8], [4, 7.4, 3.8], [9, 6.2, 3.6]].forEach(function (q) { house(q[0], q[1], q[2]); });
    o.push(h('path', { key: o.length, d: 'M-18 1.5A18 9.5 0 0 0 18 1.5', fill: 'none', stroke: 'var(--outline)', strokeWidth: 3 }));
    o.push(h('path', { key: o.length, d: 'M-18 1.5A18 9.5 0 0 0 18 1.5', fill: 'none', stroke: 'var(--stone)', strokeWidth: 2.1 }));
    o.push(h('path', { key: o.length, d: 'M-18 1.5A18 9.5 0 0 0 18 1.5', fill: 'none', stroke: 'var(--stone-hi)', strokeWidth: 0.8, strokeDasharray: '0.9 0.9', transform: 'translate(0 -0.7)' }));
    tw(-18, 3.2, true); tw(18, 3.2, true); tw(-9.5, 10.2); tw(9.5, 10.2);
    el('rect', { x: -3.2, y: 6.8, width: 6.4, height: 5, fill: 'var(--stone-hi)' });
    el('path', { d: 'M-1.4 11.8v-2.2a1.4 1.4 0 0 1 2.8 0v2.2z', fill: 'var(--window-dark)', strokeWidth: 0.2 / s });
    el('path', { d: 'M-3.6 6.8h7.2l-.6-1.2h-6z', fill: R[0] });
    return o;
  }
/*@@CityView*/
  var ROOFS = [['var(--roof-red)', 'var(--roof-red-lo)'], ['var(--roof-blue)', 'var(--roof-blue-lo)'], ['var(--roof-brown)', 'var(--timber)'], ['var(--roof-red)', 'var(--roof-red-lo)'], ['var(--roof-teal)', 'var(--copper-lo)'], ['var(--roof-purple)', 'var(--ic-black)'], ['var(--roof-red)', 'var(--roof-red-lo)']];
  var CLOTH = ['#8c3a2c', '#3b5f82', '#6b7a3a', '#9a7a3a', '#5a4466', '#a0522d', '#e8dcc0', '#40525e'];
  function House(p) {
    var x = +p.b[0], y = +p.b[1], w = +p.b[2], hh = +p.b[3], R = p.roof, d = Math.min(3.2, w * 0.34), rise = w * 0.5, fh = hh * (p.tall ? 0.95 : 0.7), top = y + hh * 0.2, o = [];
    function el(t, a) { o.push(h(t, Object.assign({ key: o.length }, a))); }
    var baseY = top + fh;
    el('path', { d: 'M' + (x + 1) + ' ' + baseY + 'h' + (w + d) + 'l2.2 1.8h-' + (w + d) + 'z', fill: '#2c1f13', opacity: 0.22 });
    el('rect', { x: x, y: top, width: w, height: fh, fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.45 });
    el('path', { d: 'M' + (x + w) + ' ' + top + 'l' + d + ' ' + (-d * 0.5) + 'v' + fh + 'l' + (-d) + ' ' + (d * 0.5) + 'z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.4 });
    if (p.timber) el('path', { d: 'M' + x + ' ' + (top + fh * 0.5) + 'h' + w + 'M' + (x + w * 0.33) + ' ' + top + 'v' + fh + 'M' + (x + w * 0.66) + ' ' + top + 'v' + fh + 'M' + x + ' ' + top + 'l' + (w * 0.33) + ' ' + (fh * 0.5), stroke: 'var(--timber)', strokeWidth: 0.35 });
    var wy = top + fh * 0.16, ws = Math.max(1.1, w * 0.15);
    el('rect', { x: x + w * 0.12, y: wy, width: ws, height: ws * 1.2, fill: p.lit ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--timber)', strokeWidth: 0.25 });
    if (w > 7.5) el('rect', { x: x + w * 0.74, y: wy, width: ws, height: ws * 1.2, fill: p.lit2 ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--timber)', strokeWidth: 0.25 });
    if (p.tall) el('rect', { x: x + w * 0.12, y: top + fh * 0.56, width: ws, height: ws * 1.2, fill: 'var(--window-dark)', stroke: 'var(--timber)', strokeWidth: 0.25 });
    el('path', { d: 'M' + (x + w * 0.42) + ' ' + baseY + 'v-' + (fh * 0.38) + 'a' + (w * 0.09) + ' ' + (w * 0.09) + ' 0 0 1 ' + (w * 0.18) + ' 0v' + (fh * 0.38) + 'z', fill: 'var(--timber)' });
    el('path', { d: 'M' + (x + w * 0.5) + ' ' + (top - rise) + 'l' + d + ' ' + (-d * 0.5) + 'L' + (x + w + d + 0.4) + ' ' + (top - d * 0.5) + 'L' + (x + w + 0.4) + ' ' + top + 'z', fill: R[1], stroke: 'var(--outline)', strokeWidth: 0.4, strokeLinejoin: 'round' });
    el('path', { d: 'M' + (x - 0.5) + ' ' + (top + 0.3) + 'L' + (x + w * 0.5) + ' ' + (top - rise) + 'L' + (x + w + 0.5) + ' ' + (top + 0.3) + 'z', fill: R[0], stroke: 'var(--outline)', strokeWidth: 0.45, strokeLinejoin: 'round' });
    el('path', { d: 'M' + (x + w * 0.18) + ' ' + (top - rise * 0.3) + 'h' + (w * 0.64) + 'M' + (x + w * 0.33) + ' ' + (top - rise * 0.62) + 'h' + (w * 0.34), stroke: R[1], strokeWidth: 0.35 });
    if (p.chimney) { el('rect', { x: x + w * 0.72, y: top - rise * 0.9, width: 1.3, height: rise * 0.55, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.3 }); if (p.smoke) { el('circle', { cx: x + w * 0.78, cy: top - rise * 1.25, r: 1.2, fill: 'var(--stone-hi)', opacity: 0.7 }); el('circle', { cx: x + w * 0.95, cy: top - rise * 1.7, r: 1.6, fill: 'var(--stone-hi)', opacity: 0.45 }); } }
    return h('g', null, o);
  }
  function Garden(b, k) {
    var x = +b[0], y = +b[1], w = +b[2], hh = +b[3], rows = [];
    for (var i = x + 1.2; i < x + w - 0.5; i += 1.6) rows.push('M' + i.toFixed(1) + ' ' + (y + 1) + 'v' + (hh - 2));
    return h('g', { key: k }, h('rect', { x: x, y: y, width: w, height: hh, fill: '#9fb46a', stroke: 'var(--timber)', strokeWidth: 0.4, strokeDasharray: '1 0.6' }),
      h('path', { d: rows.join(''), stroke: 'var(--map-forest)', strokeWidth: 0.7, strokeDasharray: '0.8 0.6' }),
      Tree({ x: x + w * 0.75, y: y + hh * 0.2, r: 2.1, fruit: true }, 't'));
  }
  function Person(x, y, c, k, sc) {
    sc = sc || 1;
    return h('g', { key: k, transform: 'translate(' + x.toFixed(1) + ' ' + y.toFixed(1) + ') scale(' + sc + ')' },
      h('ellipse', { cx: 0.5, cy: 1.6, rx: 1, ry: 0.35, fill: '#2c1f13', opacity: 0.3 }),
      h('path', { d: 'M-.8 1.5l.2-2.2a.6.6 0 0 1 1.2 0l.2 2.2z', fill: c, stroke: 'var(--outline)', strokeWidth: 0.2 }),
      h('circle', { cx: 0, cy: -1.3, r: 0.55, fill: '#e3c29a', stroke: 'var(--outline)', strokeWidth: 0.18 }));
  }
  function Stall(x, y, c, k) {
    var s = [];
    for (var i = 0; i < 4; i++) s.push(h('path', { key: i, d: 'M' + (x + i * 3.2 - 0.6) + ' ' + (y + 3.4) + 'L' + (x + i * 3.2 + 0.8) + ' ' + (y - 1.6) + 'h1.6L' + (x + i * 3.2 + 2.6) + ' ' + (y + 3.4) + 'z', fill: i % 2 ? '#fff9ec' : c }));
    return h('g', { key: k },
      h('path', { d: 'M' + (x + 1) + ' ' + (y + 8.6) + 'h12.5l1.6 1.2h-12.5z', fill: '#2c1f13', opacity: 0.22 }),
      h('rect', { x: x, y: y + 3.4, width: 12.5, height: 5.2, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.45 }),
      h('path', { d: 'M' + (x + 0.8) + ' ' + (y + 5.4) + 'h11', stroke: 'var(--ic-brown)', strokeWidth: 0.4 }),
      [['var(--ic-red)', 2.5], ['var(--ic-gold)', 5], ['var(--ic-green)', 7.5], ['var(--ic-orange)', 10]].map(function (q, i) { return h('g', { key: 'g' + i }, h('circle', { cx: x + q[1], cy: y + 4.6, r: 0.8, fill: q[0] }), h('circle', { cx: x + q[1] + 0.8, cy: y + 4.4, r: 0.7, fill: q[0] })); }),
      h('path', { d: 'M' + (x + 0.4) + ' ' + (y + 3.4) + 'v5.2M' + (x + 12.1) + ' ' + (y + 3.4) + 'v5.2', stroke: 'var(--timber)', strokeWidth: 0.7 }),
      s,
      h('path', { d: 'M' + (x - 0.8) + ' ' + (y + 3.4) + 'L' + (x + 0.8) + ' ' + (y - 1.6) + 'H' + (x + 12.4) + 'L' + (x + 13.4) + ' ' + (y + 3.4) + 'z', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.55, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x - 0.8) + ' ' + (y + 3.4) + 'q1 1 2 0q1 1 2 0q1 1 2 0q1 1 2 0q1 1 2 0q1 1 2 0q1 1 2.2 0', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.35 }));
  }
  function Crate(x, y, k) { return h('g', { key: k }, h('rect', { x: x, y: y, width: 3.4, height: 3, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.4 }), h('path', { d: 'M' + x + ' ' + y + 'l3.4 3M' + (x + 3.4) + ' ' + y + 'l-3.4 3', stroke: 'var(--ic-brown)', strokeWidth: 0.3 })); }
  function Barrel(x, y, k) { return h('g', { key: k }, h('rect', { x: x, y: y, width: 3, height: 3.8, rx: 1, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.4 }), h('path', { d: 'M' + x + ' ' + (y + 1) + 'h3M' + x + ' ' + (y + 2.8) + 'h3', stroke: 'var(--ic-steel-lo)', strokeWidth: 0.4 })); }
  function Cart(x, y, k) {
    return h('g', { key: k }, h('rect', { x: x, y: y, width: 9, height: 3.6, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.45 }),
      h('path', { d: 'M' + (x + 9) + ' ' + (y + 2.2) + 'l4.4 1.4', stroke: 'var(--timber)', strokeWidth: 0.7 }),
      h('ellipse', { cx: x + 3, cy: y - 0.4, rx: 2.6, ry: 1.2, fill: 'var(--map-field)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('ellipse', { cx: x + 6.4, cy: y - 0.3, rx: 2.2, ry: 1, fill: 'var(--ic-cream)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      [x + 2, x + 7].map(function (c, i) { return h('g', { key: i }, h('circle', { cx: c, cy: y + 4, r: 1.7, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.4 }), h('path', { d: 'M' + (c - 1.7) + ' ' + (y + 4) + 'h3.4M' + c + ' ' + (y + 2.3) + 'v3.4', stroke: 'var(--ic-brown-hi)', strokeWidth: 0.3 })); }),
      h('ellipse', { cx: x + 16, cy: y + 3, rx: 2.6, ry: 1.4, fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
      h('path', { d: 'M' + (x + 17.8) + ' ' + (y + 2.4) + 'l1.6-2.2', stroke: 'var(--ic-brown)', strokeWidth: 1.2, strokeLinecap: 'round' }));
  }
  function Tower(x, y, big, flag, k) {
    var w = big ? 14 : 11, hh = big ? 15 : 12;
    return h('g', { key: k },
      h('ellipse', { cx: x + 2, cy: y + 6.5, rx: w * 0.7, ry: 2.4, fill: '#2c1f13', opacity: 0.25 }),
      h('rect', { x: x - w / 2, y: y - hh + 6, width: w, height: hh, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
      h('rect', { x: x + w * 0.08, y: y - hh + 6, width: w * 0.42, height: hh, fill: '#000', opacity: 0.14 }),
      h('path', { d: 'M' + (x - w / 2) + ' ' + (y - hh * 0.35 + 6) + 'h' + w + 'M' + (x - w / 2) + ' ' + (y + 1.5) + 'h' + w + 'M' + (x - w * 0.15) + ' ' + (y - hh * 0.35 + 6) + 'v' + (hh * 0.35 - 4.5) + 'M' + (x + w * 0.2) + ' ' + (y + 1.5) + 'v4.5', stroke: 'var(--stone-lo)', strokeWidth: 0.35 }),
      h('path', { d: 'M' + (x - 0.8) + ' ' + (y - hh * 0.55 + 6) + 'v-2.4a.8.8 0 0 1 1.6 0v2.4z', fill: 'var(--window)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      h('path', { d: 'M' + (x - w / 2 - 1.5) + ' ' + (y - hh + 6) + 'L' + x + ' ' + (y - hh - w * 0.9 + 6) + 'L' + (x + w / 2 + 1.5) + ' ' + (y - hh + 6) + 'z', fill: 'var(--roof-red)', stroke: 'var(--outline)', strokeWidth: 0.7, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + x + ' ' + (y - hh - w * 0.9 + 6) + 'L' + (x + w / 2 + 1.5) + ' ' + (y - hh + 6) + 'H' + x + 'z', fill: 'var(--roof-red-lo)', opacity: 0.8 }),
      h('path', { d: 'M' + (x - w * 0.36) + ' ' + (y - hh + 6 - w * 0.25) + 'h' + (w * 0.72) + 'M' + (x - w * 0.2) + ' ' + (y - hh + 6 - w * 0.5) + 'h' + (w * 0.4), stroke: 'var(--roof-red-lo)', strokeWidth: 0.4 }),
      flag ? h('g', null, h('path', { d: 'M' + x + ' ' + (y - hh - w * 0.9 + 6) + 'v-6', stroke: 'var(--outline)', strokeWidth: 0.6 }), h('path', { d: 'M' + x + ' ' + (y - hh - w * 0.9) + 'c2-.8 3.6.8 5.6 0l-1.2 1.6 1.2 1.6c-2 .8-3.6-.8-5.6 0z', fill: 'var(--house-voros)', stroke: 'var(--outline)', strokeWidth: 0.35 })) : null);
  }
  function crenels(pts) {
    var d = [];
    for (var i = 0; i < pts.length; i++) {
      var a = pts[i], b = pts[(i + 1) % pts.length], L = Math.hypot(b[0] - a[0], b[1] - a[1]), n = Math.floor(L / 3.2), nx = -(b[1] - a[1]) / L, ny = (b[0] - a[0]) / L;
      for (var j = 1; j < n; j++) { var t = j / n, x = a[0] + (b[0] - a[0]) * t, y = a[1] + (b[1] - a[1]) * t; d.push('M' + (x - nx * 2.4).toFixed(1) + ' ' + (y - ny * 2.4 - 1.6).toFixed(1) + 'h1.4v1.2h-1.4z'); }
    }
    return d.join('');
  }
  function CityView(p) {
    var d = p.districts || {}, blocks = cityBlocks(p.name || 'varos'), WC = function (q) { return q.join(','); }, wallPts = WALL.map(WC).join(' ');
    var sel = p.selected, stab = p.stability, gid = useUid('cvg'), vid = useUid('cvv'), lid = useUid('lamp'), sun = useUid('sun');
    var r = rng('roof' + (p.name || '')), tr = rng('trees' + (p.name || '')), cr = rng('cob' + (p.name || '')), pr = rng('ppl' + (p.name || ''));
    var trees = [], cobbles = [], people = [];
    for (var i = 0; i < 60; i++) { var tx = tr() * 360, ty = tr() * 280; if (!inPoly(tx, ty, WALL) && !nearWall(tx, ty) && !(p.coast && tx > 290) && !(tx < 64 && ty < 44) && !(tx < 50 && ty > 190 && ty < 232)) trees.push({ x: tx, y: ty, r: 2.2 + tr() * 1.8, pine: tr() < 0.45 }); }
    trees.sort(function (a, b) { return a.y - b.y; });
    for (var c = 0; c < 520; c++) { var qx = 40 + cr() * 280, qy = 30 + cr() * 220; if (inPoly(qx, qy, WALL)) cobbles.push('M' + qx.toFixed(1) + ' ' + qy.toFixed(1) + 'h1.1'); }
    STREETS.forEach(function (s) { for (var k = 0; k < 9; k++) { var t = pr(); people.push([s[0][0] + (s[1][0] - s[0][0]) * t + (pr() - 0.5) * 5, s[0][1] + (s[1][1] - s[0][1]) * t + (pr() - 0.5) * 5, CLOTH[Math.floor(pr() * CLOTH.length)]]); } });
    for (var m = 0; m < 16; m++) people.push([152 + pr() * 68, 176 + pr() * 10, CLOTH[Math.floor(pr() * CLOTH.length)]]);
    people.push([266, 104, 'var(--ic-black)'], [220, 100, '#5a4466'], [128, 121, '#3b5f82'], [104, 121, '#8c3a2c']);
    people.sort(function (a, b) { return a[1] - b[1]; });
    var houses = blocks.map(function (b) { var g = r(); return { b: b, garden: g < 0.1, roof: ROOFS[Math.floor(r() * ROOFS.length)], timber: r() < 0.55, chimney: r() < 0.4, smoke: r() < 0.3, lit: r() < 0.3, lit2: r() < 0.3, tall: r() < 0.3 }; }).sort(function (a, b) { return a.b[1] - b.b[1] || a.b[0] - b.b[0]; });
    function dom(k) { return d[k] || {}; }
    var farms = p.coast ? [[4, 8, 6, 4, -6, true], [6, 196, 4, 5, 4, true]] : [[4, 8, 6, 4, -6, true], [6, 196, 4, 5, 4, true], [296, 226, 6, 4, -8, true]];
    return h('svg', { className: 'tn-city-view', viewBox: '0 0 360 280', role: 'img', 'aria-label': (p.name || 'Város') + ' látképe' },
      h('defs', null,
        h('radialGradient', { id: gid, cx: '50%', cy: '45%', r: '72%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' })),
        h('radialGradient', { id: sun, cx: '22%', cy: '10%', r: '75%' }, h('stop', { offset: '0%', stopColor: '#fff4cf', stopOpacity: 0.25 }), h('stop', { offset: '100%', stopColor: '#fff4cf', stopOpacity: 0 })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '72%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.34 })),
        h('radialGradient', { id: lid }, h('stop', { offset: '0%', stopColor: 'var(--window)', stopOpacity: 0.85 }), h('stop', { offset: '100%', stopColor: 'var(--window)', stopOpacity: 0 }))),
      h('rect', { width: 360, height: 280, fill: 'url(#' + gid + ')' }),
      groundPatches('cvp' + (p.name || ''), 360, 280, 120),
      h('path', { d: tufts('cv' + (p.name || ''), 360, 280, 260), stroke: 'var(--map-tuft)', strokeWidth: 0.45, fill: 'none', strokeLinecap: 'round', opacity: 0.75 }),
      flowers('cvf' + (p.name || ''), 360, 280, 60),
      h(MapTerrain, { farms: farms, sea: p.coast ? 'M336 84C318 140 352 176 310 222C284 250 262 266 252 280H360V84Z' : null,
        rivers: p.coast ? [] : [{ d: 'M330 0C322 40 344 70 334 110C326 140 348 170 340 200C334 226 348 256 344 280', w: 5 }],
        mountains: p.coast ? [[330, 40, 0.9], [348, 58, 0.7]] : [[352, 120, 0.8], [312, 40, 0.8]], windmills: [[38, 52, 20], [24, 186, 50]],
        ships: [], lighthouses: p.coast ? [[346, 110]] : [], bridges: p.coast ? [] : [[337, 138, 90]] }),
      h('g', null, [0, 1, 2, 3, 4, 5].map(function (i) { return h('g', { key: i }, [0, 1, 2].map(function (j) { return Tree({ x: 14 + i * 7, y: 238 + j * 7 + (i % 2) * 2, r: 2.2, fruit: (i + j) % 2 === 0 }, 'o' + i + j); })); })),
      h('ellipse', { cx: 180, cy: 142, rx: 150, ry: 120, fill: 'none', stroke: '#2c1f13', strokeOpacity: 0.12, strokeWidth: 10 }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--map-sea-deep)', strokeWidth: 21, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 18, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.6, strokeDasharray: '5 7', strokeLinejoin: 'round', transform: 'translate(0 6)', opacity: 0.7 }),
      GATES.map(function (g, i) { var dx = g[0] - 180, dy = g[1] - 140, L = Math.hypot(dx, dy), ex = g[0] + dx / L * 56, ey = g[1] + dy / L * 56, dd = 'M' + g[0] + ' ' + g[1] + 'L' + ex.toFixed(1) + ' ' + ey.toFixed(1); return h('g', { key: 'rd' + i }, h('path', { d: dd, stroke: 'var(--map-road-lo)', strokeWidth: 8.5, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--map-road)', strokeWidth: 6.5, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--map-road-lo)', strokeWidth: 0.4, strokeDasharray: '0.6 2', transform: 'translate(1.2 0)' }),
        h('g', { transform: 'translate(' + (g[0] + dx / L * 12) + ' ' + (g[1] + dy / L * 12) + ') rotate(' + (Math.atan2(dy, dx) * 180 / Math.PI) + ')' }, h('rect', { x: -6, y: -4.5, width: 12, height: 9, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }), h('path', { d: 'M-4 -4.5v9M-2 -4.5v9M0 -4.5v9M2 -4.5v9M4 -4.5v9', stroke: 'var(--ic-brown)', strokeWidth: 0.4 }))); }),
      Cart(18, 164, 'c1'), Cart(248, 250, 'c2'), Person(52, 170, CLOTH[1], 'tp1'), Person(56, 172, CLOTH[3], 'tp2'), Person(206, 262, CLOTH[0], 'tp3'), Person(176, 20, CLOTH[2], 'tp4'),
      h('g', null, [[30, 120], [36, 126], [24, 128]].map(function (q, i) { return h('g', { key: i, transform: 'translate(' + q[0] + ' ' + q[1] + ')' }, h('path', { d: 'M-5 3L0-4L5 3z', fill: i % 2 ? 'var(--paper-raised)' : 'var(--map-sand)', stroke: 'var(--outline)', strokeWidth: 0.45 }), h('path', { d: 'M0-4L5 3H0z', fill: '#000', opacity: 0.16 }), h('path', { d: 'M0-4L-1.2 3h2.4z', fill: 'var(--window-dark)' })); }),
        h('circle', { cx: 30, cy: 132, r: 1.6, fill: 'var(--ic-orange)', stroke: 'var(--outline)', strokeWidth: 0.3 })),
      trees.map(function (t, i) { return Tree(t, 'ft' + i); }),
      h('polygon', { points: wallPts, fill: '#d8c59b' }),
      h('path', { d: cobbles.join(''), stroke: 'var(--stone-lo)', strokeWidth: 0.9, strokeLinecap: 'round', opacity: 0.4 }),
      STREETS.map(function (s, i) { var dd = 'M' + s[0][0] + ' ' + s[0][1] + 'L' + s[1][0] + ' ' + s[1][1]; return h('g', { key: 'st' + i }, h('path', { d: dd, stroke: 'var(--map-road-lo)', strokeWidth: 10, strokeLinecap: 'round', opacity: 0.55 }), h('path', { d: dd, stroke: 'var(--map-road)', strokeWidth: 8.4, strokeLinecap: 'round' }), h('path', { d: dd, stroke: 'var(--stone-lo)', strokeWidth: 6, strokeDasharray: '0.9 1.8', opacity: 0.45 }), h('path', { d: dd, stroke: 'var(--stone-lo)', strokeWidth: 6, strokeDasharray: '0.9 1.8', opacity: 0.3, transform: 'translate(0.9 0.9)' })); }),
      sel && DISTRICTS[sel] ? h('polygon', { points: DISTRICTS[sel].poly.map(WC).join(' '), className: 'tn-cv-sel' }) : null,
      h('g', { className: 'tn-cv-blocks' }, houses.map(function (x, i) { return x.garden ? Garden(x.b, i) : h(House, { key: i, b: x.b, roof: x.roof, timber: x.timber, chimney: x.chimney, smoke: x.smoke, lit: x.lit, lit2: x.lit2, tall: x.tall }); })),
      // Városháza: palota szárnyakkal, udvarkerttel, rézkupolával
      h('g', { className: 'tn-cv-landmark' },
        h('path', { d: 'M86 118h64l4 3H90z', fill: '#2c1f13', opacity: 0.25 }),
        h('rect', { x: 84, y: 100, width: 14, height: 18, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('rect', { x: 134, y: 100, width: 14, height: 18, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M82 100.5L91 94L100 100.5zM132 100.5L141 94L150 100.5z', fill: 'var(--roof-blue)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        [87, 92, 137, 142].map(function (x, i) { return h('rect', { key: 'ww' + i, x: x, y: 104, width: 2.4, height: 3.4, rx: 1.1, fill: i % 3 ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.3 }); }),
        h('rect', { x: 96, y: 88, width: 40, height: 28, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.8 }),
        h('rect', { x: 120, y: 88, width: 16, height: 28, fill: '#000', opacity: 0.1 }),
        h('path', { d: 'M96 101h40', stroke: 'var(--stone-lo)', strokeWidth: 0.5 }),
        [99, 104, 109, 123, 128, 133].map(function (x, i) { return h('g', { key: 'w' + i }, h('rect', { x: x - 1, y: 91, width: 2.6, height: 4, rx: 1.3, fill: i % 2 ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.3 }), h('rect', { x: x - 1, y: 103.5, width: 2.6, height: 3.4, rx: 1.3, fill: i % 3 ? 'var(--window-dark)' : 'var(--window)', stroke: 'var(--outline)', strokeWidth: 0.3 })); }),
        [108, 112, 116, 120, 124].map(function (x, i) { return h('g', { key: 'c' + i }, h('rect', { x: x - 0.9, y: 99, width: 1.8, height: 16, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.35 }), h('rect', { x: x - 1.3, y: 98, width: 2.6, height: 1.2, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.3 })); }),
        h('path', { d: 'M106 98.2L116 92L126 98.2z', fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('circle', { cx: 116, cy: 95.6, r: 1.3, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
        h('path', { d: 'M104 116h24l1.6 1.6h-27.2zM102.6 117.6h26.8l1.4 1.6h-29.6z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('path', { d: 'M92 88.5L116 74L140 88.5z', fill: 'var(--roof-blue)', stroke: 'var(--outline)', strokeWidth: 0.8, strokeLinejoin: 'round' }),
        h('path', { d: 'M116 74L140 88.5H116z', fill: 'var(--roof-blue-lo)', opacity: 0.8 }),
        h('path', { d: 'M100 84h32M108 79.5h16', stroke: 'var(--roof-blue-lo)', strokeWidth: 0.4 }),
        h('rect', { x: 108, y: 66, width: 16, height: 9, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        [111, 115, 119].map(function (x, i) { return h('rect', { key: 'dw' + i, x: x, y: 68, width: 1.8, height: 4, rx: 0.9, fill: 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.25 }); }),
        h('path', { d: 'M106 66a10 10 0 0 1 20 0z', fill: 'var(--copper)', stroke: 'var(--outline)', strokeWidth: 0.8 }),
        h('path', { d: 'M116 56a10 10 0 0 1 10 10h-10z', fill: 'var(--copper-lo)', opacity: 0.8 }),
        h('path', { d: 'M110 62.5c2-3 4.5-4.5 6-4.8M112 66v-3M116 66V56M120 66v-4', stroke: 'var(--map-sea-line)', strokeWidth: 0.4, fill: 'none', opacity: 0.7 }),
        h('rect', { x: 114.8, y: 52.5, width: 2.4, height: 3.8, fill: 'var(--copper)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
        h('path', { d: 'M116 52.5v-7', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M116 45.5c2.4-1 4.4 1 6.8 0l-1.4 1.8 1.4 1.8c-2.4 1-4.4-1-6.8 0z', fill: 'var(--house-kek)', stroke: 'var(--outline)', strokeWidth: 0.35 }),
        h('path', { d: 'M113.6 116v-7a2.4 2.4 0 0 1 4.8 0v7z', fill: 'var(--timber)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('rect', { x: 92, y: 120, width: 48, height: 5, fill: '#9fb46a', stroke: 'var(--map-forest-lo)', strokeWidth: 0.5 }),
        [96, 104, 128, 136].map(function (x, i) { return h('circle', { key: 'hg' + i, cx: x, cy: 122.5, r: 1.6, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: 0.3 }); })),
      // Alvilág: fogadó istállóval, sikátor, szárítókötél, lámpás
      h('g', { className: 'tn-cv-landmark' },
        h('path', { d: 'M222 107h40l4 3h-40z', fill: '#2c1f13', opacity: 0.25 }),
        h('circle', { cx: 268, cy: 92, r: 14, fill: 'url(#' + lid + ')' }),
        h('path', { d: 'M259 107V86h13v21z', fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M262 107v-9h7v9M262 98l7 9M269 98l-7 9', stroke: 'var(--timber)', strokeWidth: 0.5, fill: 'none' }),
        h('path', { d: 'M257 87l8.5-6 8.5 6z', fill: 'var(--roof-brown)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('path', { d: 'M222 107V78l3-1.5V107zM225 107V76h34v31z', fill: 'var(--map-block)', stroke: 'var(--outline)', strokeWidth: 0.8, strokeLinejoin: 'round' }),
        h('path', { d: 'M225 91h34M236 76v31M248 76v31M225 76l11 15M248 91l11-15', stroke: 'var(--timber)', strokeWidth: 0.7 }),
        h('rect', { x: 248, y: 76, width: 11, height: 31, fill: '#000', opacity: 0.14 }),
        h('path', { d: 'M217 79L239 55L265 77z', fill: 'var(--roof-purple)', stroke: 'var(--outline)', strokeWidth: 0.8, strokeLinejoin: 'round' }),
        h('path', { d: 'M239 55L265 77H239z', fill: 'var(--ic-black)', opacity: 0.45 }),
        h('path', { d: 'M226 71h28M232 64.5h16M235 60h8', stroke: 'var(--ic-black)', strokeWidth: 0.45, opacity: 0.7 }),
        h('path', { d: 'M229 67.5h5v4h-5z', fill: 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('path', { d: 'M250 65v-11h5v15', fill: 'var(--stone-lo)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        [[253, 48, 2.6, 0.75], [256, 42, 3.4, 0.55], [260, 35, 4.2, 0.35]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2], fill: 'var(--stone-hi)', opacity: q[3] }); }),
        h('path', { d: 'M236 107v-11a5 5 0 0 1 10 0v11z', fill: 'var(--ic-peat)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
        h('path', { d: 'M241 96v11', stroke: 'var(--timber)', strokeWidth: 0.4 }),
        [228, 250].map(function (x, i) { return h('g', { key: 'win' + i }, h('rect', { x: x, y: 80, width: 5.5, height: 6, fill: i ? 'var(--window-dark)' : 'var(--window)', stroke: 'var(--outline)', strokeWidth: 0.5 }), h('path', { d: 'M' + x + ' 83h5.5M' + (x + 2.75) + ' 80v6', stroke: 'var(--timber)', strokeWidth: 0.4 }), h('rect', { x: x - 1.6, y: 80, width: 1.4, height: 6, fill: 'var(--roof-purple)', stroke: 'var(--outline)', strokeWidth: 0.3 })); }),
        [228, 250].map(function (x, i) { return h('g', { key: 'win2' + i }, h('rect', { x: x, y: 95, width: 5.5, height: 5, fill: i ? 'var(--window)' : 'var(--window-dark)', stroke: 'var(--outline)', strokeWidth: 0.5 })); }),
        h('path', { d: 'M241 91v-1h8', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('rect', { x: 243, y: 90, width: 6, height: 4, rx: 0.6, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.4 }),
        h('path', { d: 'M244.4 92h3.2', stroke: 'var(--ic-gold)', strokeWidth: 0.8 }),
        h('path', { d: 'M259 90h7v-3', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('rect', { x: 264, y: 87, width: 4.5, height: 6, rx: 1, fill: 'var(--ic-gold)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('path', { d: 'M213 74q9 5 13 1', fill: 'none', stroke: 'var(--outline)', strokeWidth: 0.35 }),
        [[215, 75.6, '#e8dcc0'], [219, 77, '#8c3a2c'], [222.5, 77, '#3b5f82']].map(function (q, i) { return h('rect', { key: 'l' + i, x: q[0], y: q[1], width: 2.2, height: 3, fill: q[2], stroke: 'var(--outline)', strokeWidth: 0.25 }); }),
        Barrel(261.5, 101, 'b1'), Barrel(265, 102.2, 'b2'), Barrel(263, 97.4, 'b3'), Crate(254, 103, 'k1'), Crate(254.6, 100, 'k2'),
        h('path', { d: 'M226 97h8v5h-8z', fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.45 })),
      // Vásártér: standok, tömeg, kút szoborral, szekér
      h('g', null,
        h('rect', { x: 146, y: 156, width: 80, height: 50, rx: 3, className: 'tn-cv-square' }),
        h('path', { d: 'M150 160h72v42h-72z', fill: 'none', stroke: 'var(--stone-lo)', strokeWidth: 0.4, strokeDasharray: '2 2', opacity: 0.6 }),
        Stall(150, 160, 'var(--roof-red)', 's1'), Stall(166, 160, 'var(--roof-blue)', 's2'), Stall(193, 160, 'var(--map-field)', 's3'), Stall(209, 160, 'var(--roof-teal)', 's4'),
        Stall(150, 190, 'var(--roof-teal)', 's5'), Stall(209, 190, 'var(--roof-red)', 's6'), Stall(166, 192, 'var(--roof-purple)', 's7'),
        Crate(184, 196, 'k1'), Crate(187.6, 196, 'k2'), Crate(185.8, 193, 'k3'), Barrel(193, 195, 'kb'),
        h('ellipse', { cx: 198, cy: 199, rx: 1.8, ry: 1.5, fill: 'var(--ic-cream)', stroke: 'var(--outline)', strokeWidth: 0.3 }), h('ellipse', { cx: 200.4, cy: 199.6, rx: 1.6, ry: 1.3, fill: 'var(--ic-cream)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
        h('path', { d: 'M180 181l3-2.5h6l3 2.5v6l-3 2.5h-6l-3-2.5z', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M181.8 181.9l2-1.6h4.4l2 1.6v4.2l-2 1.6h-4.4l-2-1.6z', fill: 'var(--map-sea)' }),
        h('path', { d: 'M183.2 184q1.4-1 2.8 0t2.8 0', stroke: 'var(--map-sea-line)', strokeWidth: 0.4, fill: 'none' }),
        h('rect', { x: 185, y: 180, width: 2, height: 4, fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
        h('path', { d: 'M185.2 180l.3-3.2a.6.6 0 0 1 1 0l.3 3.2z', fill: 'var(--copper)', stroke: 'var(--outline)', strokeWidth: 0.25 }),
        h('circle', { cx: 186, cy: 176.4, r: 0.7, fill: 'var(--copper)', stroke: 'var(--outline)', strokeWidth: 0.2 }),
        Cart(214, 205, 'cm')),
      people.map(function (q, i) { return Person(q[0], q[1], q[2], 'p' + i, 1.05); }),
      // Fal, bástyák, kaputornyok
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--outline)', strokeWidth: 8.6, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone)', strokeWidth: 7, strokeLinejoin: 'round' }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone-lo)', strokeWidth: 2, strokeLinejoin: 'round', opacity: 0.5 }),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--stone-hi)', strokeWidth: 0.8, strokeLinejoin: 'round', transform: 'translate(0 -2.2)' }),
      h('path', { d: crenels(WALL), fill: 'var(--stone-hi)', stroke: 'var(--outline)', strokeWidth: 0.3 }),
      WALL.map(function (q, i) { return Tower(q[0], q[1], i % 2 === 0, i === 1 || i === 4, 'tw' + i); }),
      GATES.map(function (g, i) { var x = g[0], y = g[1]; return h('g', { key: 'g' + i },
        h('rect', { x: x - 8, y: y - 6, width: 16, height: 11, fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.7 }),
        h('path', { d: 'M' + (x - 8) + ' ' + (y - 6) + 'v-2h2.2v2h2.2v-2h2.2v2h2.2v-2h2.2v2h2.2v-2h2.4v2', fill: 'var(--stone)', stroke: 'var(--outline)', strokeWidth: 0.5 }),
        h('path', { d: 'M' + (x - 3.6) + ' ' + (y + 5) + 'v-4.8a3.6 3.6 0 0 1 7.2 0V' + (y + 5) + 'z', fill: 'var(--window-dark)' }),
        h('path', { d: 'M' + (x - 1.8) + ' ' + (y - 1.2) + 'v6.2M' + x + ' ' + (y - 2.4) + 'v7.4M' + (x + 1.8) + ' ' + (y - 1.2) + 'v6.2M' + (x - 3.4) + ' ' + (y + 1.4) + 'h6.8M' + (x - 3.2) + ' ' + (y + 3.4) + 'h6.4', stroke: 'var(--stone-lo)', strokeWidth: 0.4 }),
        h('rect', { x: x - 7, y: y - 4, width: 1.6, height: 2.4, fill: 'var(--window-dark)' }), h('rect', { x: x + 5.4, y: y - 4, width: 1.6, height: 2.4, fill: 'var(--window-dark)' }),
        Person(x - 5.2, y + 6.2, 'var(--btn-red)', 'gd1', 0.9), Person(x + 5.2, y + 6.2, 'var(--btn-red)', 'gd2', 0.9)); }),
      p.coast ? h('g', null,
        [[296, 196, 330, 214], [282, 212, 312, 232], [268, 230, 296, 252]].map(function (q, i) { var dd = 'M' + q[0] + ' ' + q[1] + 'L' + q[2] + ' ' + q[3]; return h('g', { key: 'pier' + i }, h('path', { d: dd, stroke: '#2c1f13', strokeWidth: 7, strokeLinecap: 'butt', opacity: 0.3, transform: 'translate(1.5 1.5)' }), h('path', { d: dd, stroke: 'var(--outline)', strokeWidth: 5.6, strokeLinecap: 'butt' }), h('path', { d: dd, stroke: 'var(--ic-brown-hi)', strokeWidth: 4.2, strokeLinecap: 'butt' }), h('path', { d: dd, stroke: 'var(--ic-brown)', strokeWidth: 4.2, strokeDasharray: '0.5 1.6' })); }),
        h('g', { transform: 'translate(300 186) rotate(30)' }, h('path', { d: 'M0 0v-14l9 3', fill: 'none', stroke: 'var(--timber)', strokeWidth: 1.2 }), h('path', { d: 'M9-11v7', stroke: 'var(--outline)', strokeWidth: 0.3 }), h('rect', { x: 7.8, y: -4, width: 2.6, height: 2, fill: 'var(--ic-brown-hi)', stroke: 'var(--outline)', strokeWidth: 0.3 })),
        Crate(318, 208, 'hk1'), Crate(321.6, 209.8, 'hk2'), Barrel(304, 224, 'hb1'), Person(312, 213, CLOTH[1], 'hp1'), Person(298, 229, CLOTH[5], 'hp2'),
        h('g', { transform: 'translate(338 220) scale(1.2)' }, h(Ship, { x: 0, y: 0 })), h(Ship, { x: 330, y: 244 }), h(Ship, { x: 346, y: 186 }),
        [[318, 240], [306, 258]].map(function (q, i) { return h('g', { key: 'rb' + i, transform: 'translate(' + q[0] + ' ' + q[1] + ')' }, h('path', { d: 'M-3 0h6l-1 1.6h-4z', fill: 'var(--ic-brown)', stroke: 'var(--outline)', strokeWidth: 0.35 }), Person(0, -1.2, CLOTH[i + 2], 'rp', 0.7)); })) : null,
      Object.keys(DISTRICTS).map(function (k) {
        var D = DISTRICTS[k], v = dom(k), f = D.flag;
        return h('g', { key: 'fl' + k },
          v.contested ? h(Pennant, { x: f[0] + 12, y: f[1] + 4, tincture: v.contested }) : null,
          v.dominant ? h(Pennant, { x: f[0], y: f[1], tincture: v.dominant }) : null,
          h('text', { x: D.label[0], y: D.label[1], textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, D.name));
      }),
      stab === 'lazongo' ? [[86, 196], [270, 150], [120, 60]].map(function (q, i) { return h(Flame, { key: 'fx' + i, x: q[0], y: q[1] }); }) : null,
      stab === 'ingatag' ? h('g', { fill: 'var(--stone-hi)', stroke: 'var(--stone-lo)', strokeWidth: 0.6, opacity: 0.8 }, [[290, 150, 4], [293, 141, 5], [289, 130, 6.5], [284, 120, 5]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2] }); })) : null,
      h('rect', { width: 360, height: 280, fill: 'url(#' + sun + ')', pointerEvents: 'none' }),
      h('rect', { width: 360, height: 280, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      p.onSelect ? Object.keys(DISTRICTS).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: DISTRICTS[k].poly.map(WC).join(' '), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': DISTRICTS[k].name, 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }
