/* @ds-bundle: {"format":4,"namespace":"TronNelkul","components":[{"name":"InfluenceBar"},{"name":"ControlBadge"},{"name":"SuspicionMeter"},{"name":"CommandPoints"},{"name":"ReportCard"},{"name":"OrderSheet"},{"name":"HouseCrest"},{"name":"FactionTag"},{"name":"StabilityChip"},{"name":"TickTimer"},{"name":"ResourceChip"},{"name":"MapCanvas"},{"name":"MapCity"},{"name":"MapRoute"},{"name":"MapEstate"},{"name":"MapTerrain"},{"name":"MapCompass"},{"name":"MapCartouche"},{"name":"CityView"},{"name":"AppBar"},{"name":"NavBar"},{"name":"Button"},{"name":"TextField"},{"name":"Select"},{"name":"Tabs"},{"name":"Toast"},{"name":"Sheet"},{"name":"DataTable"},{"name":"Icon"}]} */
(function () {
  var React = window.React;
  var h = React.createElement;
  function cx() { return Array.prototype.filter.call(arguments, Boolean).join(' '); }
  function fmt(n, d) { return Number(n).toFixed(d == null ? 1 : d).replace('.', ','); }

  var TINCTURES = { voros: 'Vörös', kek: 'Kék', zold: 'Zöld', arany: 'Arany', bibor: 'Bíbor', fekete: 'Fekete', narancs: 'Narancs', szeder: 'Szeder' };
  function tint(t) { return 'var(--house-' + (TINCTURES[t] ? t : 'fekete') + ')'; }

  /* ---------- Icon ---------- */
  var ICONS = {
    nemesseg: ['M4 18h16', 'M5 18 4 8l5 4 3-6 3 6 5-4-1 10'],
    kereskedok: ['M12 4v16', 'M8 20h8', 'M5 7h14', 'M5 7l-3 6h6z', 'M19 7l-3 6h6z'],
    katonasag: ['M19 5 9 15', 'M15 5h4v4', 'M7 13l4 4', 'M8 16l-3 3', 'M4 18l2 2'],
    arany: ['M12 5a7 7 0 1 0 0 14 7 7 0 1 0 0-14z', 'M12 8.5v7'],
    bp: ['M6 4h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6z', 'M9 9h6', 'M9 13h6'],
    ke: ['M12 3l7 3v6c0 4-3 7-7 9-4-2-7-5-7-9V6z'],
    legit: ['M12 3l2.6 5.6 6.1.7-4.5 4.2 1.2 6L12 16.6 6.6 19.5l1.2-6-4.5-4.2 6.1-.7z'],
    pp: ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 9a3 3 0 1 0 0 6 3 3 0 1 0 0-6z'],
    kem: ['M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z', 'M12 9a3 3 0 1 0 0 6 3 3 0 1 0 0-6z'],
    katonai: ['M5 21V4h11l-2 4 2 4H5'],
    diplomacia: ['M7 3h10v18l-5-3-5 3z'],
    esemeny: ['M12 3v2', 'M6 11a6 6 0 0 1 12 0v5l2 2H4l2-2z', 'M10 21h4'],
    frakcio: ['M4 20V10l8-6 8 6v10', 'M9 20v-6h6v6'],
    route: ['M4 18c4 0 4-12 8-12s4 12 8 12'],
    lock: ['M6 11h12v9H6z', 'M9 11V8a3 3 0 0 1 6 0v3'],
    warning: ['M12 3l10 18H2z', 'M12 10v5', 'M12 18v.5'],
    clock: ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 8v4l3 2'],
    check: ['M5 12l5 5 9-10'],
    close: ['M6 6l12 12', 'M18 6 6 18'],
    hidden: ['M3 10c3-3 15-3 18 0l-2 6h-5l-2-2-2 2H5z'],
    terkep: ['M3 6l6-2 6 2 6-2v14l-6 2-6-2-6 2z', 'M9 4v14', 'M15 6v14'],
    varos: ['M3 21V10l3-2 3 2v11', 'M9 21V6l3-3 3 3v15', 'M15 21v-9l3-2 3 2v9', 'M2 21h20'],
    info: ['M12 4a8 8 0 1 0 0 16 8 8 0 1 0 0-16z', 'M12 11v5', 'M12 8v.5']
  };
  function Icon(p) {
    var size = p.size || 18, paths = ICONS[p.name] || ICONS.info;
    return h('svg', { className: cx('tn-icon', p.className), width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', strokeWidth: 1.75, strokeLinecap: 'round', strokeLinejoin: 'round', 'aria-hidden': p.label ? undefined : true, role: p.label ? 'img' : undefined, 'aria-label': p.label },
      paths.map(function (d, i) { return h('path', { key: i, d: d }); }));
  }

  /* ---------- Base UI ---------- */
  function Button(p) {
    var rest = Object.assign({}, p); ['variant', 'size', 'icon', 'className', 'children'].forEach(function (k) { delete rest[k]; });
    return h('button', Object.assign({ type: 'button' }, rest, { className: cx('tn-btn', p.variant && p.variant !== 'default' && 'tn-btn-' + p.variant, p.size === 'sm' && 'tn-btn-sm', p.className) }),
      p.icon ? h(Icon, { name: p.icon, size: p.size === 'sm' ? 16 : 18 }) : null, p.children);
  }

  function TextField(p) {
    var rest = Object.assign({}, p); ['label', 'hint', 'error', 'id'].forEach(function (k) { delete rest[k]; });
    var id = p.id || 'f-' + String(p.label || 'x').replace(/\W+/g, '-');
    return h('div', { className: cx('tn-field', p.error && 'tn-field-error') },
      h('label', { className: 'tn-field-label', htmlFor: id }, p.label),
      h('input', Object.assign({ id: id, className: 'tn-input' }, rest)),
      (p.error || p.hint) ? h('div', { className: 'tn-field-hint' }, p.error || p.hint) : null);
  }

  function Select(p) {
    var id = p.id || 's-' + String(p.label || 'x').replace(/\W+/g, '-');
    return h('div', { className: 'tn-field' },
      h('label', { className: 'tn-field-label', htmlFor: id }, p.label),
      h('select', { id: id, className: 'tn-select', value: p.value, defaultValue: p.value == null ? p.defaultValue : undefined, onChange: p.onChange },
        (p.options || []).map(function (o) { var v = typeof o === 'string' ? o : o.value; return h('option', { key: v, value: v }, typeof o === 'string' ? o : o.label); })),
      p.hint ? h('div', { className: 'tn-field-hint' }, p.hint) : null);
  }

  function Tabs(p) {
    var st = React.useState(p.active || (p.tabs && p.tabs[0] && p.tabs[0].id));
    var active = p.onChange ? p.active : st[0];
    return h('div', { className: 'tn-tabs', role: 'tablist' }, (p.tabs || []).map(function (t) {
      return h('button', { key: t.id, role: 'tab', className: 'tn-tab', 'aria-selected': t.id === active ? 'true' : 'false', onClick: function () { p.onChange ? p.onChange(t.id) : st[1](t.id); } },
        t.label, t.badge ? h('span', { className: 'tn-tab-badge' }, t.badge) : null);
    }));
  }

  var TOAST_ICON = { info: 'info', ok: 'check', warn: 'warning', danger: 'warning' };
  function Toast(p) {
    var tone = p.tone || 'info';
    return h('div', { className: 'tn-toast tn-toast-' + tone, role: tone === 'danger' ? 'alert' : 'status' },
      h(Icon, { name: p.icon || TOAST_ICON[tone] }), h('div', { className: 'tn-toast-title' }, p.title),
      p.children ? h('div', { className: 'tn-toast-body' }, p.children) : null);
  }

  function Sheet(p) {
    if (p.open === false) return null;
    return h('div', { className: cx('tn-sheet-scrim', p.inline && 'tn-inline') },
      h('div', { className: 'tn-sheet', role: 'dialog', 'aria-modal': 'true', 'aria-label': p.title },
        h('div', { className: 'tn-sheet-grip' }),
        h('div', { className: 'tn-sheet-head' }, h('h2', { className: 'tn-sheet-title' }, p.title),
          p.onClose !== undefined ? h(Button, { variant: 'quiet', size: 'sm', icon: 'close', 'aria-label': 'Bezárás', onClick: p.onClose }) : null),
        h('div', null, p.children),
        p.footer ? h('div', { className: 'tn-sheet-foot' }, p.footer) : null));
  }

  function DataTable(p) {
    var cols = p.columns || [];
    return h('div', { className: 'tn-table-wrap' }, h('table', { className: 'tn-table' },
      p.caption ? h('caption', { className: 'tn-muted', style: { textAlign: 'left', padding: '8px 12px' } }, p.caption) : null,
      h('thead', null, h('tr', null, cols.map(function (c) { return h('th', { key: c.key, className: c.align === 'right' ? 'tn-r' : undefined, style: c.align === 'right' ? { fontFamily: 'var(--font-sans)' } : undefined }, c.label); }))),
      h('tbody', null, (p.rows || []).map(function (r, i) {
        return h('tr', { key: r.id || i, className: r.self ? 'tn-self' : undefined }, cols.map(function (c) {
          var v = c.render ? c.render(r) : r[c.key];
          return h('td', { key: c.key, className: c.align === 'right' ? 'tn-r' : undefined }, v);
        }));
      }))));
  }

  /* ---------- Game ---------- */
  var RES = { arany: ['arany', 'Arany'], bp: ['bp', 'Befolyáspont'], ke: ['ke', 'Katonai erő'], legit: ['legit', 'Legitimitás'], pp: ['pp', 'Parancspont'] };
  var RES_SHORT = { arany: 'A', bp: 'BP', ke: 'KE', legit: 'L', pp: 'PP' };
  function ResourceChip(p) {
    var r = RES[p.kind] || RES.arany, d = p.delta;
    return h('span', { className: 'tn-res', title: r[1] },
      h(Icon, { name: r[0], size: 14, label: r[1] }), h('span', null, p.value),
      d != null ? h('span', { className: cx('tn-res-delta', d < 0 && 'tn-neg') }, (d > 0 ? '+' : d < 0 ? '−' : '±') + Math.abs(d)) : null);
  }

  function CommandPoints(p) {
    var max = p.max || 20, avail = p.available || 0, pend = Math.min(p.pending || 0, avail), daily = p.daily || 10;
    var pips = [];
    for (var i = 0; i < max; i++) {
      var s = i < avail - pend ? 'tn-pip-on' : i < avail ? 'tn-pip-pending' : '';
      pips.push(h('span', { key: i, className: cx('tn-pip', s) }));
    }
    return h('div', { className: 'tn-pp', role: 'group', 'aria-label': 'Parancspont' },
      h('div', { className: 'tn-pp-head' },
        h('span', { className: 'tn-field-label' }, 'Parancspont'),
        h('span', { className: 'tn-pp-value' }, (avail - pend) + ' / ' + max)),
      h('div', { className: 'tn-pp-pips', 'aria-hidden': true }, pips),
      h('div', { className: 'tn-field-hint' }, pend ? pend + ' PP lefoglalva a parancslapon · ' : '', '+' + daily + ' a következő körben'));
  }

  function HouseCrest(p) {
    var size = p.size || 28, fill = tint(p.tincture);
    return h('svg', { className: 'tn-crest', width: size, height: size * 1.1, viewBox: '0 0 24 26.4', role: 'img', 'aria-label': (p.name || 'Ház') + (p.npc ? ' (NPC)' : '') },
      h('path', { d: 'M2 2h20v9.5c0 6.5-5 10.5-10 13C7 22 2 18 2 11.5z', fill: fill, stroke: p.npc ? 'var(--ink-muted)' : 'var(--ink)', strokeWidth: 1.5, strokeDasharray: p.npc ? '2.5 2' : undefined }),
      p.initial ? h('text', { className: 'tn-crest-initial', x: 12, y: 15.5, textAnchor: 'middle', fontSize: 11, fill: 'var(--paper-raised)' }, p.initial) : null);
  }

  var FACTIONS = { nemesseg: ['nemesseg', 'Nemesség'], kereskedok: ['kereskedok', 'Kereskedők'], katonasag: ['katonasag', 'Katonaság'] };
  function FactionTag(p) {
    var f = FACTIONS[p.faction] || FACTIONS.nemesseg;
    return h('span', { className: 'tn-chip' }, h(Icon, { name: f[0], size: 15 }), f[1]);
  }

  var STAB = { stabil: 'Stabil', ingatag: 'Ingatag', lazongo: 'Lázongó' };
  var STAB_ICON = { stabil: 'check', ingatag: 'warning', lazongo: 'warning' };
  function StabilityChip(p) {
    var l = STAB[p.level] ? p.level : 'stabil';
    return h('span', { className: 'tn-chip tn-chip-' + l }, h(Icon, { name: STAB_ICON[l], size: 14 }), STAB[l]);
  }

  var LEVELS = [['jelenlet', 'Jelenlét'], ['partner', 'Helyi partner'], ['dominans', 'Domináns'], ['varoskontroll', 'Városkontroll'], ['protektoratus', 'Protektorátus']];
  function ControlBadge(p) {
    var idx = -1; LEVELS.forEach(function (l, i) { if (l[0] === p.level) idx = i; });
    var steps = []; for (var i = 0; i < 5; i++) steps.push(h('i', { key: i, className: cx('tn-ctl-step', i <= idx && 'tn-on') }));
    return h('span', { className: 'tn-ctl' }, h('span', { className: 'tn-ctl-steps', 'aria-hidden': true }, steps), idx < 0 ? h('span', { className: 'tn-muted' }, 'Nincs jelenlét') : LEVELS[idx][1]);
  }

  function band(v, w) { var lo = Math.floor(v / w) * w; return lo + '–' + Math.min(100, lo + w); }
  function showVal(v, precision) { return precision === 'band10' ? band(v, 10) : precision === 'band5' ? String(Math.round(v / 5) * 5) : fmt(v); }
  function InfluenceBar(p) {
    var segs = (p.segments || []).slice().sort(function (a, b) { return b.value - a.value; });
    var used = segs.reduce(function (s, x) { return s + x.value; }, 0) + (p.unknown || 0);
    var neutral = Math.max(0, 100 - used), precision = p.precision || 'exact';
    var bars = segs.map(function (s, i) {
      return h('div', { key: 'p' + i, className: cx('tn-seg', s.self && 'tn-seg-self'), style: { flex: s.value + ' 0 0', background: tint(s.tincture) }, title: s.name + ': ' + showVal(s.value, precision) });
    });
    if (p.unknown) bars.push(h('div', { key: 'u', className: 'tn-seg tn-seg-unknown', style: { flex: p.unknown + ' 0 0' }, title: 'Ismeretlen: ' + showVal(p.unknown, precision) }));
    if (neutral > 0) bars.push(h('div', { key: 'n', className: 'tn-seg tn-seg-neutral', style: { flex: neutral + ' 0 0' }, title: 'Semleges: ' + fmt(neutral) }));
    var ticks = p.thresholds === false ? [] : [10, 25, 35];
    var f = FACTIONS[p.faction];
    return h('div', { className: 'tn-inf' },
      f || p.aside ? h('div', { className: 'tn-inf-head' }, f ? h('span', { className: 'tn-report-title', style: { display: 'inline-flex', gap: 6, alignItems: 'center' } }, h(Icon, { name: f[0], size: 18 }), f[1]) : h('span'), p.aside || null) : null,
      h('div', { className: 'tn-inf-track', role: 'img', 'aria-label': (f ? f[1] + ': ' : '') + segs.map(function (s) { return s.name + ' ' + showVal(s.value, precision); }).join(', ') + (p.unknown ? ', Ismeretlen ' + showVal(p.unknown, precision) : '') + ', Semleges ' + fmt(neutral) },
        h('div', { className: 'tn-inf-bar' }, bars),
        ticks.map(function (t) { return h('span', { key: t, className: 'tn-inf-tick', style: { left: t + '%' } }); })),
      ticks.length ? h('div', { className: 'tn-inf-scale', 'aria-hidden': true }, ticks.map(function (t) { return h('span', { key: t, style: { left: t + '%' } }, t); })) : null,
      p.legend === false ? null : h('div', { className: 'tn-inf-legend' },
        segs.map(function (s, i) { return h('span', { key: i, className: 'tn-inf-key' }, h('span', { className: 'tn-inf-sw', style: { background: tint(s.tincture) } }), h('span', { style: { fontWeight: s.self ? 700 : 400 } }, s.name), h('span', { className: 'tn-num tn-muted' }, showVal(s.value, s.self ? 'exact' : precision))); }),
        p.unknown ? h('span', { className: 'tn-inf-key' }, h('span', { className: 'tn-inf-sw tn-seg-unknown' }), 'Ismeretlen', h('span', { className: 'tn-num tn-muted' }, showVal(p.unknown, precision))) : null,
        h('span', { className: 'tn-inf-key' }, h('span', { className: 'tn-inf-sw tn-seg-neutral' }), 'Semleges', h('span', { className: 'tn-num tn-muted' }, fmt(neutral)))));
  }

  var SUS = ['Nincs gyanú', 'Gyanakvó', 'Bizalmatlan', 'Kiűzetés'];
  var SUS_NOTE = ['', 'nyereség ×0,75', 'nyereség ×0,5 · romlás +2%', 'a befolyás fele elveszett'];
  function SuspicionMeter(p) {
    var v = Math.max(0, Math.min(3, p.value || 0)), eyes = [];
    for (var i = 0; i < 3; i++) eyes.push(h('span', { key: i, className: i < v ? 'tn-on' : undefined }, h(Icon, { name: 'kem', size: 16 })));
    return h('span', { className: 'tn-sus tn-sus-' + v },
      h('span', { className: 'tn-sus-eyes', 'aria-hidden': true }, eyes),
      h('span', null, SUS[v]), p.showEffect !== false && v ? h('span', { className: 'tn-muted', style: { fontWeight: 400 } }, SUS_NOTE[v]) : null);
  }

  var KINDS = { kem: ['kem', 'Kémjelentés'], katonai: ['katonai', 'Katonai'], frakcio: ['frakcio', 'Frakció'], diplomacia: ['diplomacia', 'Diplomácia'], esemeny: ['esemeny', 'Városi esemény'] };
  var CONF = { gyenge: [1, 'Gyenge forrás'], kozepes: [2, 'Közepes forrás'], eros: [3, 'Megbízható forrás'] };
  function ReportCard(p) {
    var k = KINDS[p.kind] || KINDS.esemeny, c = p.confidence && CONF[p.confidence];
    var bars = []; if (c) for (var i = 0; i < 3; i++) bars.push(h('i', { key: i, className: i < c[0] ? 'tn-on' : undefined, style: { height: 5 + i * 4 } }));
    return h('article', { className: 'tn-report' },
      h('div', { className: 'tn-report-head' },
        h('span', { className: 'tn-report-kind' }, h(Icon, { name: k[0], size: 15 }), k[1], p.tick ? h('span', { style: { fontWeight: 400, letterSpacing: 0, textTransform: 'none' } }, ' · ' + p.tick) : null),
        c ? h('span', { className: 'tn-conf' }, h('span', { className: 'tn-conf-bars', 'aria-hidden': true }, bars), c[1]) : null),
      p.title ? h('h3', { className: 'tn-report-title' }, p.title) : null,
      p.children ? h('p', { className: 'tn-report-text' }, p.children) : null,
      p.footer ? h('div', { className: 'tn-row', style: { marginTop: 4 } }, p.footer) : null);
  }

  function costText(c) { return Object.keys(c || {}).filter(function (k) { return c[k]; }).map(function (k) { return c[k] + ' ' + (RES_SHORT[k] || k.toUpperCase()); }).join(' · '); }
  function OrderSheet(p) {
    var orders = p.orders || [], total = orders.reduce(function (s, o) { return s + ((o.cost && o.cost.pp) || 0); }, 0), over = total > (p.available || 0);
    return h('section', { className: 'tn-orders', 'aria-label': 'Parancslap' },
      h('div', { className: 'tn-orders-head' }, h('span', { className: 'tn-sheet-title', style: { fontSize: 18 } }, 'Parancslap'), h('span', { className: 'tn-muted', style: { fontSize: 13 } }, p.round ? p.round + '. kör' : '')),
      h('ol', { className: 'tn-orders-list' }, orders.map(function (o, i) {
        return h('li', { key: i, className: 'tn-order' },
          h('span', { className: 'tn-order-label' }, o.label, o.hidden ? h('span', { className: 'tn-hidden-tag' }, 'Rejtett') : null),
          h('span', { className: 'tn-order-cost' }, costText(o.cost)),
          h('span', { className: 'tn-order-meta' }, [o.city, o.faction && FACTIONS[o.faction] ? FACTIONS[o.faction][1] : o.faction, o.note].filter(Boolean).join(' · ')));
      })),
      h('div', { className: 'tn-orders-foot' },
        h('span', { className: cx('tn-orders-total', over && 'tn-over') }, total + ' / ' + (p.available || 0) + ' PP', over ? ' · túllépés' : ''),
        p.sealed ? h('span', { className: 'tn-sealed' }, h(Icon, { name: 'pp', size: 16 }), 'Lepecsételve') : h(Button, { variant: 'seal', icon: 'pp', disabled: over || !orders.length, onClick: p.onSeal }, 'Parancsok lepecsételése')));
  }

  function TickTimer(p) {
    return h('span', { className: cx('tn-tick', p.soon && 'tn-tick-soon') }, h(Icon, { name: 'clock', size: 16 }),
      h('span', null, 'Feldolgozás ', p.at ? h('b', null, p.at) : null), p.remaining ? h('span', { className: p.soon ? undefined : 'tn-muted' }, '· ' + p.remaining) : null);
  }

  /* ---------- Map ---------- */
  function MapCanvas(p) {
    var w = p.width || 360, hh = p.height || 240, lines = [], step = p.grid || 40;
    for (var x = step; x < w; x += step) lines.push('M' + x + ' 0V' + hh);
    for (var y = step; y < hh; y += step) lines.push('M0 ' + y + 'H' + w);
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h('path', { className: 'tn-map-grid', d: lines.join(''), opacity: 0.7 }), p.children);
  }
  function MapRoute(p) {
    var a = p.from, b = p.to, st = p.state || 'base', mx = (a[0] + b[0]) / 2, my = (a[1] + b[1]) / 2;
    var ang = Math.atan2(b[1] - a[1], b[0] - a[0]) + Math.PI / 2, dx = Math.cos(ang) * 8, dy = Math.sin(ang) * 8;
    return h('g', null,
      h('line', { className: 'tn-route tn-route-' + st, x1: a[0], y1: a[1], x2: b[0], y2: b[1], style: st === 'rival' ? { stroke: tint(p.tincture) } : undefined }),
      st === 'blocked' ? h('g', null, h('circle', { className: 'tn-block-mark', cx: mx, cy: my, r: 7 }), h('line', { x1: mx - dx * .6, y1: my - dy * .6, x2: mx + dx * .6, y2: my + dy * .6, stroke: 'var(--danger)', strokeWidth: 2.5, strokeLinecap: 'round' })) : null);
  }
  var STAB_MARK = { stabil: '', ingatag: '!', lazongo: '!!' };
  function MapCity(p) {
    var st = p.state || 'reachable', r = p.keyCity ? 7 : 5.5, lx = p.labelSide === 'left' ? -r - 6 : r + 6;
    return h('g', { className: cx('tn-city', 'tn-city-' + st, p.keyCity && 'tn-city-key'), transform: 'translate(' + p.x + ' ' + p.y + ')' },
      st === 'reachable' ? h('circle', { className: 'tn-city-halo', r: r + 7 }) : null,
      h('circle', { className: 'tn-city-dot', r: r }),
      p.keyCity ? h('circle', { className: 'tn-city-inner', r: 2.5 }) : null,
      h('text', { className: 'tn-city-label', x: lx, y: 4.5, textAnchor: p.labelSide === 'left' ? 'end' : 'start' }, p.name),
      p.stability && STAB_MARK[p.stability] ? h('text', { className: 'tn-city-stab tn-stab-' + p.stability, x: 0, y: -r - 5, textAnchor: 'middle' }, STAB_MARK[p.stability]) : null);
  }
  function MapEstate(p) {
    return h('g', { transform: 'translate(' + (p.x - 7) + ' ' + (p.y - 8) + ')' },
      h('path', { className: 'tn-estate', d: 'M0 0h14v6.5c0 4.5-3.5 7.5-7 9.5C3.5 14 0 11 0 6.5z', fill: tint(p.tincture), strokeDasharray: p.npc ? '2 1.5' : undefined }),
      p.name ? h('text', { className: 'tn-city-label', x: 7, y: 28, textAnchor: 'middle', style: { fontSize: 11 } }, p.name) : null);
  }


  /* ---------- Map terrain ---------- */
  function rng(seed) { var s = 0; for (var i = 0; i < String(seed).length; i++) s = (s * 31 + String(seed).charCodeAt(i)) >>> 0; s = s || 7; return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; }; }
  function useUid(p) { var id = React.useId ? React.useId() : 'x'; return 'tn' + String(id).replace(/[^A-Za-z0-9]/g, '') + (p || ''); }

  function Ripples(p) {
    var cid = useUid('sea');
    return h('g', null,
      h('clipPath', { id: cid }, h('path', { d: p.d })),
      h('path', { className: 'tn-sea', d: p.d }),
      h('g', { clipPath: 'url(#' + cid + ')' },
        [22, 14, 7].map(function (w, i) { return h('path', { key: i, d: p.d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: w, opacity: 0.35 + i * 0.2 }); }),
        [18, 10, 3].map(function (w, i) { return h('path', { key: 's' + i, d: p.d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: w }); })),
      h('path', { d: p.d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 1.25 }));
  }
  function Mountain(p) {
    var s = p.s || 1, x = p.x, y = p.y, w = 11 * s, ht = 13 * s, hatch = [];
    for (var i = 1; i <= 4; i++) { var t = i / 5; hatch.push('M' + (x + w * t * 0.9) + ' ' + (y - ht + ht * t + 1) + 'l' + (-2.5 * s) + ' ' + (4 * s)); }
    return h('g', null,
      h('path', { d: 'M' + (x - w) + ' ' + y + 'L' + x + ' ' + (y - ht) + 'L' + (x + w) + ' ' + y, fill: 'var(--paper-raised)', stroke: 'var(--map-relief)', strokeWidth: 1.3, strokeLinejoin: 'round' }),
      h('path', { d: hatch.join(''), stroke: 'var(--map-relief)', strokeWidth: 1, strokeLinecap: 'round' }));
  }
  function Forest(p) {
    var r = rng('f' + p.x + p.y), n = p.n || 5, trees = [];
    for (var i = 0; i < n; i++) {
      var tx = p.x + (r() - 0.5) * n * 5, ty = p.y + (r() - 0.5) * n * 2.6, rr = 3 + r() * 1.6;
      trees.push({ x: tx, y: ty, r: rr });
    }
    trees.sort(function (a, b) { return a.y - b.y; });
    return h('g', null, trees.map(function (t, i) {
      return h('g', { key: i }, h('path', { d: 'M' + t.x + ' ' + t.y + 'v' + (t.r + 2.5), stroke: 'var(--map-relief)', strokeWidth: 1 }),
        h('circle', { cx: t.x, cy: t.y, r: t.r, fill: 'var(--map-forest)', stroke: 'var(--map-relief)', strokeWidth: 0.9 }));
    }));
  }
  function Field(p) {
    var lines = [], gap = 3.5;
    for (var i = gap; i < p.h; i += gap) lines.push('M' + p.x + ' ' + (p.y + i) + 'h' + p.w);
    return h('g', { transform: p.rot ? 'rotate(' + p.rot + ' ' + (p.x + p.w / 2) + ' ' + (p.y + p.h / 2) + ')' : undefined },
      h('rect', { x: p.x, y: p.y, width: p.w, height: p.h, fill: 'none', stroke: 'var(--map-relief)', strokeWidth: 0.8, opacity: 0.8 }),
      h('path', { d: lines.join(''), stroke: 'var(--map-relief)', strokeWidth: 0.6, opacity: 0.7 }));
  }
  function Marsh(p) {
    var r = rng('m' + p.x), out = [];
    for (var i = 0; i < (p.n || 5); i++) { var x = p.x + (r() - 0.5) * 30, y = p.y + (r() - 0.5) * 14; out.push('M' + (x - 4) + ' ' + y + 'h8M' + x + ' ' + y + 'l-2-4M' + x + ' ' + y + 'v-5M' + x + ' ' + y + 'l2-4'); }
    return h('path', { d: out.join(''), stroke: 'var(--map-relief)', strokeWidth: 0.9, strokeLinecap: 'round', fill: 'none' });
  }
  function MapTerrain(p) {
    return h('g', { className: 'tn-terrain', 'aria-hidden': true },
      (p.fields || []).map(function (f, i) { return h(Field, { key: 'fd' + i, x: f[0], y: f[1], w: f[2], h: f[3], rot: f[4] }); }),
      p.sea ? h(Ripples, { d: p.sea }) : null,
      (p.rivers || []).map(function (d, i) { return h('g', { key: 'r' + i }, h('path', { d: d, fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 3.2, strokeLinecap: 'round' }), h('path', { d: d, fill: 'none', stroke: 'var(--map-sea)', strokeWidth: 1.4, strokeLinecap: 'round' })); }),
      (p.marsh || []).map(function (m, i) { return h(Marsh, { key: 'ms' + i, x: m[0], y: m[1], n: m[2] }); }),
      (p.mountains || []).map(function (m, i) { return h(Mountain, { key: 'mt' + i, x: m[0], y: m[1], s: m[2] }); }),
      (p.forests || []).map(function (f, i) { return h(Forest, { key: 'fo' + i, x: f[0], y: f[1], n: f[2] }); }));
  }
  function MapCompass(p) {
    var R = p.size || 22, r = R * 0.22, pts = [], pts2 = [];
    for (var i = 0; i < 8; i++) { var a = i * Math.PI / 4 - Math.PI / 2, rad = i % 2 ? R * 0.55 : R; pts.push([Math.cos(a) * rad, Math.sin(a) * rad]); var b = a + Math.PI / 8; pts.push([Math.cos(b) * r, Math.sin(b) * r]); }
    return h('g', { className: 'tn-compass', transform: 'translate(' + p.x + ' ' + p.y + ')', 'aria-hidden': true },
      h('circle', { r: R * 0.78, fill: 'none', stroke: 'var(--ink)', strokeWidth: 0.8, opacity: 0.6 }),
      h('polygon', { points: pts.map(function (q) { return q[0].toFixed(1) + ',' + q[1].toFixed(1); }).join(' '), fill: 'var(--paper-raised)', stroke: 'var(--ink)', strokeWidth: 1, strokeLinejoin: 'round' }),
      h('path', { d: 'M0 ' + (-R) + 'L' + r + ' ' + (-r) + 'L0 0z', fill: 'var(--ink)' }),
      h('text', { y: -R - 4, textAnchor: 'middle', className: 'tn-compass-n' }, 'É'));
  }
  function MapCartouche(p) {
    var w = p.width || 150, x = p.x, y = p.y;
    return h('g', { className: 'tn-cartouche', transform: 'translate(' + x + ' ' + y + ')' },
      h('rect', { width: w, height: 40, fill: 'var(--paper-raised)', stroke: 'var(--ink)', strokeWidth: 1 }),
      h('rect', { x: 3, y: 3, width: w - 6, height: 34, fill: 'none', stroke: 'var(--ink)', strokeWidth: 0.5 }),
      h('text', { x: w / 2, y: 17, textAnchor: 'middle', className: 'tn-cart-title' }, p.title),
      h('g', { transform: 'translate(' + (w / 2 - 30) + ' 22)' },
        h('rect', { width: 30, height: 3, fill: 'var(--ink)' }), h('rect', { x: 30, width: 30, height: 3, fill: 'none', stroke: 'var(--ink)', strokeWidth: 0.6 }),
        h('text', { x: 30, y: 12, textAnchor: 'middle', className: 'tn-cart-scale' }, p.scale || '1 napi járóföld')));
  }

  /* ---------- City view ---------- */
  var WALL = [[60, 70], [150, 30], [260, 40], [320, 110], [300, 200], [210, 250], [100, 240], [40, 160]];
  var GATES = [[40, 160], [185, 35], [320, 110], [210, 250]];
  var STREETS = [[[40, 160], [180, 140]], [[180, 140], [320, 110]], [[185, 35], [180, 140]], [[180, 140], [210, 250]]];
  var DISTRICTS = {
    nemesseg: { poly: [[60, 70], [150, 30], [185, 35], [180, 140], [40, 160]], name: 'Felsőváros', label: [110, 138], flag: [138, 72] },
    katonasag: { poly: [[185, 35], [260, 40], [320, 110], [180, 140]], name: 'Citadella', label: [226, 124], flag: [262, 52] },
    kereskedok: { poly: [[40, 160], [180, 140], [320, 110], [300, 200], [210, 250], [100, 240]], name: 'Vásártér', label: [185, 224], flag: [224, 162] }
  };
  function inPoly(x, y, poly) { var c = false; for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) { var a = poly[i], b = poly[j]; if (((a[1] > y) !== (b[1] > y)) && (x < (b[0] - a[0]) * (y - a[1]) / (b[1] - a[1]) + a[0])) c = !c; } return c; }
  function segDist(px, py, s) { var a = s[0], b = s[1], dx = b[0] - a[0], dy = b[1] - a[1], t = Math.max(0, Math.min(1, ((px - a[0]) * dx + (py - a[1]) * dy) / (dx * dx + dy * dy))); return Math.hypot(px - a[0] - t * dx, py - a[1] - t * dy); }
  function nearWall(x, y) { for (var i = 0; i < WALL.length; i++) if (segDist(x, y, [WALL[i], WALL[(i + 1) % WALL.length]]) < 9) return true; return false; }
  var LANDMARKS = [function (x, y) { return x > 84 && x < 146 && y > 66 && y < 122; }, function (x, y) { return Math.hypot(x - 244, y - 80) < 38; }, function (x, y) { return x > 144 && x < 228 && y > 154 && y < 208; }];
  var BLOCK_CACHE = {};
  function cityBlocks(seed) {
    if (BLOCK_CACHE[seed]) return BLOCK_CACHE[seed];
    var r = rng(seed), out = [];
    for (var y = 36; y < 250; y += 12) for (var x = 44; x < 320; x += 13) {
      var w = 7 + r() * 4, hh = 6 + r() * 3.5, bx = x + (r() - 0.5) * 3, by = y + (r() - 0.5) * 3, cxp = bx + w / 2, cyp = by + hh / 2;
      if (r() < 0.12) continue;
      if (!inPoly(bx, by, WALL) || !inPoly(bx + w, by + hh, WALL) || !inPoly(bx + w, by, WALL) || !inPoly(bx, by + hh, WALL)) continue;
      if (nearWall(cxp, cyp)) continue;
      var bad = false; STREETS.forEach(function (s) { if (segDist(cxp, cyp, s) < 9) bad = true; }); if (bad) continue;
      LANDMARKS.forEach(function (f) { if (f(cxp, cyp)) bad = true; }); if (bad) continue;
      out.push([bx.toFixed(1), by.toFixed(1), w.toFixed(1), hh.toFixed(1)]);
    }
    return (BLOCK_CACHE[seed] = out);
  }
  function Pennant(p) {
    var x = p.x, y = p.y, w = 13, L = 16;
    return h('g', null, h('path', { d: 'M' + x + ' ' + (y + 22) + 'V' + (y - 4), stroke: 'var(--ink)', strokeWidth: 1.3 }),
      h('path', { d: 'M' + x + ' ' + (y - 4) + 'h' + w + 'l-4 ' + (L / 4) + 'l4 ' + (L / 4) + 'h-' + w + 'z', fill: tint(p.tincture), stroke: 'var(--paper-raised)', strokeWidth: 0.8 }));
  }
  function Flame(p) { return h('path', { d: 'M' + p.x + ' ' + p.y + 'c-5-3-4-8 0-13c0 4 3 4 3 7c1-2 2-3 1-5c4 4 3 9-4 11z', fill: 'var(--danger)', stroke: 'var(--paper)', strokeWidth: 0.8 }); }
  function Ship(p) { return h('g', { transform: 'translate(' + p.x + ' ' + p.y + ')' }, h('path', { d: 'M-9 0h18l-4 4h-10z', fill: 'var(--ink)' }), h('path', { d: 'M0 0v-14', stroke: 'var(--ink)', strokeWidth: 1 }), h('path', { d: 'M1-13c6 3 6 8 0 11z', fill: 'var(--paper-raised)', stroke: 'var(--ink)', strokeWidth: 0.8 }), h('path', { d: 'M-12 7q3-2 6 0t6 0t6 0t6 0', fill: 'none', stroke: 'var(--map-sea-line)', strokeWidth: 0.9 })); }

  function CityView(p) {
    var d = p.districts || {}, blocks = cityBlocks(p.name || 'varos'), wallPts = WALL.map(function (q) { return q.join(','); }).join(' ');
    var sel = p.selected, stab = p.stability;
    function dom(k) { var v = d[k] || {}; return v; }
    return h('svg', { className: 'tn-city-view', viewBox: '0 0 360 280', role: 'img', 'aria-label': (p.name || 'Város') + ' látképe' },
      h('rect', { width: 360, height: 280, fill: 'var(--paper)' }),
      h(MapTerrain, { fields: p.coast ? [[6, 8, 46, 26, -8], [8, 196, 36, 24, 10], [322, 20, 34, 22, 6]] : [[6, 8, 46, 26, -8], [8, 196, 36, 24, 10], [322, 20, 34, 22, 6], [300, 228, 50, 26, -6]], forests: [[26, 262, 6], [340, 70, 4]],
        sea: p.coast ? 'M336 84C318 140 352 176 310 222C284 250 262 266 252 280H360V84Z' : null, mountains: p.coast ? [] : [[330, 160, 1], [345, 178, 0.8]] }),
      GATES.map(function (g, i) { var dx = g[0] - 180, dy = g[1] - 140, L = Math.hypot(dx, dy); return h('path', { key: 'rd' + i, d: 'M' + g[0] + ' ' + g[1] + 'l' + (dx / L * 40) + ' ' + (dy / L * 40), stroke: 'var(--map-relief)', strokeWidth: 1.2, strokeDasharray: '3 3' }); }),
      h('polygon', { points: wallPts, fill: 'var(--paper-raised)' }),
      sel && DISTRICTS[sel] ? h('polygon', { points: DISTRICTS[sel].poly.map(function (q) { return q.join(','); }).join(' '), className: 'tn-cv-sel' }) : null,
      h('g', { className: 'tn-cv-blocks' }, blocks.map(function (b, i) { return h('rect', { key: i, x: b[0], y: b[1], width: b[2], height: b[3] }); })),
      h('g', { className: 'tn-cv-landmark' },
        h('rect', { x: 92, y: 76, width: 48, height: 38 }), h('rect', { x: 102, y: 86, width: 28, height: 18, className: 'tn-cv-court' }),
        [[92, 76], [140, 76], [92, 114], [140, 114]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: 4.5 }); })),
      h('g', null,
        h('polygon', { className: 'tn-cv-bastion', points: (function () { var o = []; for (var i = 0; i < 10; i++) { var a = i * Math.PI / 5 - Math.PI / 2, rr = i % 2 ? 19 : 31; o.push((244 + Math.cos(a) * rr).toFixed(1) + ',' + (80 + Math.sin(a) * rr).toFixed(1)); } return o.join(' '); })() }),
        h('rect', { className: 'tn-cv-keep', x: 236, y: 72, width: 16, height: 16 })),
      h('g', null,
        h('rect', { x: 148, y: 158, width: 76, height: 46, className: 'tn-cv-square' }),
        [[156, 166], [170, 166], [196, 166], [210, 166], [156, 190], [210, 190]].map(function (q, i) { return h('rect', { key: i, x: q[0], y: q[1], width: 8, height: 6, className: 'tn-cv-stall' }); }),
        h('circle', { cx: 186, cy: 181, r: 5, className: 'tn-cv-well' })),
      h('polygon', { points: wallPts, fill: 'none', stroke: 'var(--ink)', strokeWidth: 2.4, strokeLinejoin: 'round' }),
      WALL.map(function (q, i) { return h('circle', { key: 'tw' + i, cx: q[0], cy: q[1], r: 5, fill: 'var(--paper-raised)', stroke: 'var(--ink)', strokeWidth: 1.8 }); }),
      GATES.map(function (g, i) { return h('rect', { key: 'g' + i, x: g[0] - 4, y: g[1] - 4, width: 8, height: 8, fill: 'var(--ink)', transform: 'rotate(45 ' + g[0] + ' ' + g[1] + ')' }); }),
      p.coast ? h('g', null, h('path', { d: 'M300 200l24 16M284 214l20 18', stroke: 'var(--ink)', strokeWidth: 3, strokeLinecap: 'square' }), h(Ship, { x: 332, y: 244 }), h(Ship, { x: 344, y: 196 })) : null,
      Object.keys(DISTRICTS).map(function (k) {
        var D = DISTRICTS[k], v = dom(k), f = D.flag;
        return h('g', { key: 'fl' + k },
          v.contested ? h(Pennant, { x: f[0] + 10, y: f[1] + 4, tincture: v.contested }) : null,
          v.dominant ? h(Pennant, { x: f[0], y: f[1], tincture: v.dominant }) : null,
          h('text', { x: D.label[0], y: D.label[1], textAnchor: 'middle', className: cx('tn-cv-label', sel === k && 'tn-on') }, D.name));
      }),
      stab === 'lazongo' ? [[86, 196], [270, 150], [120, 60]].map(function (q, i) { return h(Flame, { key: 'fx' + i, x: q[0], y: q[1] }); }) : null,
      stab === 'ingatag' ? h('g', { fill: 'var(--ink-muted)', opacity: 0.55 }, [[290, 150, 4], [293, 141, 5], [289, 130, 6.5]].map(function (q, i) { return h('circle', { key: i, cx: q[0], cy: q[1], r: q[2] }); })) : null,
      p.onSelect ? Object.keys(DISTRICTS).map(function (k) {
        return h('polygon', { key: 'hit' + k, points: DISTRICTS[k].poly.map(function (q) { return q.join(','); }).join(' '), className: 'tn-cv-hit', role: 'button', tabIndex: 0, 'aria-label': DISTRICTS[k].name + ', ' + FACTIONS[k][1], 'aria-pressed': sel === k ? 'true' : 'false',
          onClick: function () { p.onSelect(k); }, onKeyDown: function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); p.onSelect(k); } } });
      }) : null);
  }

  /* ---------- App chrome ---------- */
  function AppBar(p) {
    var hs = p.house || {};
    return h('header', { className: 'tn-appbar' },
      h('div', { className: 'tn-appbar-top' },
        h('span', { className: 'tn-appbar-house' }, h(HouseCrest, { tincture: hs.tincture, initial: hs.initial, name: hs.name, size: 24 }), h('span', { className: 'tn-appbar-name' }, hs.name)),
        p.timer ? h(TickTimer, p.timer) : null),
      p.resources ? h('div', { className: 'tn-appbar-res' }, p.resources.map(function (r, i) { return h(ResourceChip, Object.assign({ key: i }, r)); })) : null);
  }
  function NavBar(p) {
    return h('nav', { className: 'tn-nav', 'aria-label': 'Fő navigáció' }, (p.items || []).map(function (it) {
      var on = it.id === p.active;
      return h('button', { key: it.id, className: cx('tn-nav-item', on && 'tn-on'), 'aria-current': on ? 'page' : undefined, onClick: p.onChange ? function () { p.onChange(it.id); } : undefined },
        h('span', { className: 'tn-nav-icon' }, h(Icon, { name: it.icon, size: 22 }), it.badge ? h('span', { className: 'tn-nav-badge' }, it.badge) : null), it.label);
    }));
  }

  window.TronNelkul = Object.assign(window.TronNelkul || {}, {
    Icon: Icon, Button: Button, TextField: TextField, Select: Select, Tabs: Tabs, Toast: Toast, Sheet: Sheet, DataTable: DataTable,
    ResourceChip: ResourceChip, CommandPoints: CommandPoints, HouseCrest: HouseCrest, FactionTag: FactionTag, StabilityChip: StabilityChip,
    ControlBadge: ControlBadge, InfluenceBar: InfluenceBar, SuspicionMeter: SuspicionMeter, ReportCard: ReportCard, OrderSheet: OrderSheet,
    TickTimer: TickTimer, MapCanvas: MapCanvas, MapTerrain: MapTerrain, MapCompass: MapCompass, MapCartouche: MapCartouche, CityView: CityView, AppBar: AppBar, NavBar: NavBar, MapRoute: MapRoute, MapCity: MapCity, MapEstate: MapEstate
  });
})();
