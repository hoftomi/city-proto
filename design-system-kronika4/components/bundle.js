// Trón nélkül – Krónika IV design system — ES module build of components/bundle.js
/* @ds-bundle: {"format":4,"namespace":"TronKronika4","components":[{"name":"InfluenceBar"},{"name":"ControlBadge"},{"name":"SuspicionMeter"},{"name":"CommandPoints"},{"name":"ReportCard"},{"name":"OrderSheet"},{"name":"HouseCrest"},{"name":"FactionTag"},{"name":"StabilityChip"},{"name":"TickTimer"},{"name":"ResourceChip"},{"name":"MapCanvas"},{"name":"MapCity"},{"name":"MapRoute"},{"name":"MapEstate"},{"name":"MapTerrain"},{"name":"MapCompass"},{"name":"MapCartouche"},{"name":"CityView"},{"name":"AppBar"},{"name":"NavBar"},{"name":"Button"},{"name":"TextField"},{"name":"Select"},{"name":"Tabs"},{"name":"Toast"},{"name":"Sheet"},{"name":"DataTable"},{"name":"Icon"},{"name":"GameIcon"},{"name":"MapViewport"}]} */
(function () { var React = window.React;

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
    return h('svg', { className: cx('tn-icon', p.className), width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', strokeWidth: 2, strokeLinecap: 'round', strokeLinejoin: 'round', 'aria-hidden': p.label ? undefined : true, role: p.label ? 'img' : undefined, 'aria-label': p.label },
      paths.map(function (d, i) { return h('path', { key: i, d: d }); }));
  }

  /* ---------- GameIcon: teli, illusztratív ikonok (erőforrás, árucikk, akció, ág) ---------- */
  // Elemenként: [tag, attribútumok]. f = kitöltés (--ic-* token), s = körvonal token ('none' = nincs), sw = vonalvastagság.
  var GAME = {
    /* Erőforrások */
    arany: [
      ['circle', { cx: 15.5, cy: 8.5, r: 5.5, f: 'gold-lo' }],
      ['circle', { cx: 10, cy: 14, r: 7, f: 'gold' }],
      ['circle', { cx: 10, cy: 14, r: 4.4, f: 'gold-hi', s: 'gold-lo' }],
      ['path', { d: 'M10 11.3v5.4', s: 'gold-lo', sw: 1.8 }],
      ['path', { d: 'M5.6 11.4a5 5 0 0 1 2.2-2.2', s: 'white', sw: 1.2 }]
    ],
    pp: [
      ['path', { d: 'M8.5 14.5 6 22l3-1.4 2.2 2 1-6.6z', f: 'red-lo' }],
      ['path', { d: 'M15.5 14.5 18 22l-3-1.4-2.2 2-1-6.6z', f: 'red-lo' }],
      ['path', { d: 'M12 2.5l1.6 1.2 2-.3 1 1.7 1.9.8-.1 2 1.2 1.6-1.2 1.6.1 2-1.9.8-1 1.7-2-.3L12 17.5l-1.6-1.2-2 .3-1-1.7-1.9-.8.1-2L4.4 10.5l1.2-1.6-.1-2 1.9-.8 1-1.7 2 .3z', f: 'red' }],
      ['circle', { cx: 12, cy: 10, r: 4.2, f: 'red-hi', s: 'red-lo' }],
      ['path', { d: 'M9.8 11.6l.6-2.8 1.6 1.4 1.6-1.4.6 2.8z', f: 'gold-hi', s: 'red-lo', sw: 0.9 }]
    ],
    legit: [
      ['path', { d: 'M4 18.5h16v2.5H4z', f: 'gold-lo' }],
      ['path', { d: 'M4 18.5 3 8.5l5 3.8L12 5l4 7.3 5-3.8-1 10z', f: 'gold' }],
      ['circle', { cx: 3, cy: 8, r: 1.4, f: 'gold-hi' }],
      ['circle', { cx: 12, cy: 4.5, r: 1.4, f: 'gold-hi' }],
      ['circle', { cx: 21, cy: 8, r: 1.4, f: 'gold-hi' }],
      ['circle', { cx: 12, cy: 14.5, r: 1.9, f: 'red' }],
      ['circle', { cx: 7.3, cy: 15.6, r: 1.2, f: 'blue' }],
      ['circle', { cx: 16.7, cy: 15.6, r: 1.2, f: 'blue' }]
    ],
    nep: [
      ['path', { d: 'M12 20.5s-8.5-5-8.5-10.8A4.6 4.6 0 0 1 12 7.2a4.6 4.6 0 0 1 8.5 2.5c0 5.8-8.5 10.8-8.5 10.8z', f: 'rose' }],
      ['path', { d: 'M6.6 9.6a2.4 2.4 0 0 1 2.3-2', s: 'white', sw: 1.4 }]
    ],
    ado: [
      ['path', { d: 'M9 6.5h6l-1.3-3h-3.4z', f: 'brown-hi' }],
      ['path', { d: 'M9 6.5C5 9.5 3.5 13.5 3.5 16a5 5 0 0 0 5 5h7a5 5 0 0 0 5-5c0-2.5-1.5-6.5-5.5-9.5z', f: 'brown-hi' }],
      ['path', { d: 'M8.5 7.2h7', s: 'brown', sw: 1.6 }],
      ['circle', { cx: 12, cy: 14.5, r: 3.6, f: 'gold', s: 'gold-lo' }],
      ['path', { d: 'M12 12.8v3.4', s: 'gold-lo', sw: 1.4 }]
    ],

    /* Navigáció és idő */
    navTerkep: [
      ['path', { d: 'M4 5.5c0-1.4 1-2.3 2.3-2.3S8.6 4.1 8.6 5.5v14c0-1.4-1-2.3-2.3-2.3S4 18.1 4 19.5z', f: 'brown-hi' }],
      ['path', { d: 'M8.6 5.5h11.1v14H8.6z', f: 'paper' }],
      ['path', { d: 'M10.5 9.5c1.5-2 4-2.2 5.2-.8 1.4 1.6.4 3.6 2 5-1.4 1.8-4.6 1.8-6 .4-1.2-1.2-2.2-2.6-1.2-4.6z', f: 'green', sw: 0.9 }],
      ['path', { d: 'M10.4 17.5c1.8-.6 2.6-1.8 4.2-1.8', s: 'red', sw: 1.3, f: 'none' }],
      ['path', { d: 'M16.6 15.8l2 2M18.6 15.8l-2 2', s: 'red', sw: 1.4 }],
      ['path', { d: 'M19.7 5.5a2.3 2.3 0 0 1 2.3 2.3v11.7c0-1.3-1-2.3-2.3-2.3', f: 'brown' }]
    ],
    navVaros: [
      ['path', { d: 'M3 21V10h5v11zM16 21V10h5v11z', f: 'stone' }],
      ['path', { d: 'M2 10.5 5.5 3 9 10.5zM15 10.5 18.5 3 22 10.5z', f: 'blue' }],
      ['path', { d: 'M8 21v-9h8v9z', f: 'stone-hi' }],
      ['path', { d: 'M8 12V9h1.8v1.6h1.5V9h1.4v1.6h1.5V9H16v3z', f: 'stone-hi' }],
      ['path', { d: 'M10 21v-4.2a2 2 0 0 1 4 0V21z', f: 'brown' }],
      ['path', { d: 'M18.5 3V1', s: 'line' }],
      ['path', { d: 'M18.5 1h3l-.8.9.8.9h-3z', f: 'red', sw: 0.8 }]
    ],
    navJel: [
      ['path', { d: 'M2.5 6.5h19v13h-19z', f: 'paper' }],
      ['path', { d: 'M2.5 6.5 12 14l9.5-7.5', f: 'cream' }],
      ['path', { d: 'M2.5 19.5l7-6.2M21.5 19.5l-7-6.2', s: 'cream-lo', sw: 1 }],
      ['circle', { cx: 12, cy: 14, r: 3.4, f: 'red' }],
      ['path', { d: 'M10.6 14.6l.6-1.8 1 .9 1-.9.6 1.8z', f: 'gold-hi', s: 'red-lo', sw: 0.7 }]
    ],
    navRang: [
      ['path', { d: 'M6.5 4.5H3.5c0 3.5 1.5 5.5 4 6M17.5 4.5h3c0 3.5-1.5 5.5-4 6', s: 'gold-lo', sw: 1.6, f: 'none' }],
      ['path', { d: 'M6.5 3h11v5.5c0 3.4-2.4 6-5.5 6s-5.5-2.6-5.5-6z', f: 'gold' }],
      ['path', { d: 'M10.5 14.3h3v3.2h-3z', f: 'gold-lo' }],
      ['path', { d: 'M7.5 21.5l1-4h7l1 4z', f: 'brown' }],
      ['path', { d: 'M12 5.3l.9 1.9 2 .2-1.5 1.4.4 2-1.8-1-1.8 1 .4-2-1.5-1.4 2-.2z', f: 'white', sw: 0.8 }],
      ['path', { d: 'M8.2 4.8v3.6', s: 'white', sw: 1.2 }]
    ],
    homokora: [
      ['path', { d: 'M5 2.5h14v2.2H5zM5 19.3h14v2.2H5z', f: 'brown' }],
      ['path', { d: 'M7 4.7h10c0 4-5 5.8-5 7.3s5 3.3 5 7.3H7c0-4 5-5.8 5-7.3S7 8.7 7 4.7z', f: 'sky' }],
      ['path', { d: 'M8.8 7.2h6.4c-.8 1.6-3.2 2.6-3.2 3.6s-2.4-2-3.2-3.6zM8.4 19.3c.3-2 2.4-3.3 3.6-3.3s3.3 1.3 3.6 3.3z', f: 'gold', sw: 0.8 }],
      ['path', { d: 'M12 12v3', s: 'gold-lo', sw: 1 }]
    ],
    /* Árucikkek */
    gabona: [
      ['path', { d: 'M12 21V8M12 21 8 11M12 21l4-10', s: 'brown', sw: 1.3 }],
      ['ellipse', { cx: 12, cy: 6, rx: 2.1, ry: 3.6, f: 'gold' }],
      ['ellipse', { cx: 7.4, cy: 9, rx: 1.9, ry: 3.3, f: 'gold', t: 'rotate(-28 7.4 9)' }],
      ['ellipse', { cx: 16.6, cy: 9, rx: 1.9, ry: 3.3, f: 'gold', t: 'rotate(28 16.6 9)' }],
      ['path', { d: 'M9.3 15.5h5.4', s: 'red', sw: 2.2 }]
    ],
    bor: [
      ['rect', { x: 10, y: 1.8, width: 4, height: 2.6, rx: 0.6, f: 'brown-hi' }],
      ['path', { d: 'M10 4.4h4V7c0 1 3.2 2 3.2 6.3V20a1 1 0 0 1-1 1H7.8a1 1 0 0 1-1-1v-6.7C6.8 9 10 8 10 7z', f: 'wine' }],
      ['rect', { x: 8.3, y: 12.5, width: 7.4, height: 4.5, rx: 0.5, f: 'paper' }],
      ['path', { d: 'M9 10.5c.5-.8 1-1.2 1.6-1.6', s: 'white', sw: 1.2 }]
    ],
    vas: [
      ['path', { d: 'M2.5 20.5l1.7-4.5h7.1l1.7 4.5z', f: 'steel' }],
      ['path', { d: 'M11.5 20.5l1.7-4.5h7.1l1.7 4.5z', f: 'steel' }],
      ['path', { d: 'M7 16l1.7-4.5h7.1L17.5 16z', f: 'steel-hi' }],
      ['path', { d: 'M9.5 12.8h5M4.8 17.3h5.9M13.8 17.3h5.9', s: 'white', sw: 1 }]
    ],
    ko: [
      ['rect', { x: 2.5, y: 14, width: 9.5, height: 6.5, rx: 0.8, f: 'stone' }],
      ['rect', { x: 12, y: 14, width: 9.5, height: 6.5, rx: 0.8, f: 'stone-lo' }],
      ['rect', { x: 7, y: 7.5, width: 10, height: 6.5, rx: 0.8, f: 'stone-hi' }],
      ['path', { d: 'M10 10l1.5 1.2M5 17l1.4-1M15 18.5l2-1', s: 'line', sw: 0.9 }]
    ],
    so: [
      ['path', { d: 'M5 13c1-4.2 3.8-7.5 7-7.5s6 3.3 7 7.5z', f: 'white' }],
      ['path', { d: 'M2.5 13h19a9.5 7.5 0 0 1-19 0z', f: 'brown' }],
      ['path', { d: 'M5 16.5c2 1.3 4.3 2 7 2', s: 'brown-hi', sw: 1.2 }],
      ['circle', { cx: 10, cy: 9.5, r: 0.7, f: 'stone', s: 'none' }],
      ['circle', { cx: 13.5, cy: 10.8, r: 0.7, f: 'stone', s: 'none' }]
    ],
    hal: [
      ['path', { d: 'M17 12l4.5-4v8z', f: 'blue' }],
      ['path', { d: 'M2.5 12c3-5.2 10-6.2 14.8-1.3v2.6C12.5 18.2 5.5 17.2 2.5 12z', f: 'sky' }],
      ['path', { d: 'M4.5 13.3c3.5 2.4 8 2.6 12.3.3', s: 'white', sw: 1.2 }],
      ['path', { d: 'M9 7.9c1.2-2 3-3 5-3.2-.4 1.4-.9 2.5-1.6 3.6', f: 'blue' }],
      ['circle', { cx: 6.3, cy: 11, r: 1, f: 'line', s: 'none' }]
    ],
    fuszer: [
      ['path', { d: 'M8 9 7 4.5l3 2 2-3.2 2 3.2 3-2L16 9z', f: 'orange-hi' }],
      ['path', { d: 'M8 9c-2.4 3-3.5 6-3.5 8a4 4 0 0 0 4 4h7a4 4 0 0 0 4-4c0-2-1.1-5-3.5-8z', f: 'orange' }],
      ['path', { d: 'M7.6 9.2h8.8', s: 'red-lo', sw: 1.8 }],
      ['circle', { cx: 10, cy: 14.5, r: 0.9, f: 'red', s: 'none' }],
      ['circle', { cx: 14, cy: 16.5, r: 0.9, f: 'red', s: 'none' }],
      ['circle', { cx: 11.5, cy: 18.3, r: 0.9, f: 'red', s: 'none' }]
    ],
    tozeg: [
      ['rect', { x: 2.5, y: 15, width: 9.5, height: 5.5, rx: 1, f: 'peat' }],
      ['rect', { x: 12, y: 15, width: 9.5, height: 5.5, rx: 1, f: 'peat' }],
      ['rect', { x: 7, y: 9.5, width: 10, height: 5.5, rx: 1, f: 'brown' }],
      ['path', { d: 'M12 9.5c-2-1.6-1.6-3.6 0-6 .3 1.4 1.3 2 1.8 3 .4 1-.2 2.3-1.8 3z', f: 'orange' }],
      ['path', { d: 'M5 17.5h4M14.5 18h4M9.5 12.2h5', s: 'brown-hi', sw: 1 }]
    ],
    csempesz: [
      ['rect', { x: 3, y: 8.5, width: 18, height: 12.5, rx: 0.8, f: 'brown-hi' }],
      ['path', { d: 'M3 8.5l18 12.5M21 8.5 3 21', s: 'brown', sw: 1.4 }],
      ['path', { d: 'M2 10.5c4-3.5 9-4.2 13.5-2.2l6.5.7-1.2 5c-5.8-2.2-12.2-1.4-18.8 1z', f: 'black' }],
      ['path', { d: 'M8.5 8.2l1.2 5.4', s: 'gold-lo', sw: 1.3 }]
    ],
    gyapju: [
      ['circle', { cx: 11.5, cy: 11.5, r: 7.8, f: 'cream' }],
      ['path', { d: 'M4.3 9.8c3.4.6 7 3.3 8.6 8.9M4.5 14.2c2.6.3 5 2 6 4.9M6.6 5.9c3.2 1.6 6.3 5.4 7.4 11.3M10.6 3.9c2.8 2 5 6.2 5.4 11M15.3 4.9c1.6 1.9 2.7 4.7 3 8', s: 'cream-lo', sw: 1.1 }],
      ['path', { d: 'M17.5 17c1.5 1.5 3 2.5 4.5 2.2', s: 'cream-lo', sw: 1.3 }]
    ],
    lo: [
      ['path', { d: 'M7 21l1-5.5c-2-1.2-3-3.2-3-5.5 0-3.8 3-6.8 7-6.8L14 1.5l1.2 3c3 1.2 4.8 4 4.8 7l-1 3.2-3-1-2 1.3V21z', f: 'brown' }],
      ['path', { d: 'M14 1.5l1.2 3c-2.4.4-4.4 2-5.2 4.5-.7 2-.5 4.3.5 6.3', s: 'line', f: 'none' }],
      ['path', { d: 'M12 3.2c-1.3 1.2-2.3 3-2.5 5 1.5-1.2 2.5-1.3 4-1.4', f: 'peat' }],
      ['circle', { cx: 15.3, cy: 8.3, r: 0.9, f: 'line', s: 'none' }],
      ['path', { d: 'M18.3 14.5l.6-1', s: 'line' }]
    ],

    /* Ágak */
    vasarter: [
      ['rect', { x: 4, y: 11.5, width: 16, height: 9, f: 'brown-hi' }],
      ['rect', { x: 5.5, y: 15, width: 13, height: 5.5, f: 'brown' }],
      ['path', { d: 'M2.5 11.5 4.5 4h15l2 7.5z', f: 'cream' }],
      ['path', { d: 'M6.5 4 5.4 11.5h3.2L9.2 4zM12 4v7.5h3L14.8 4zM17.5 4l1.1 7.5h2.9l-2-7.5z', f: 'red', s: 'none' }],
      ['path', { d: 'M2.5 11.5 4.5 4h15l2 7.5z', f: 'none' }],
      ['circle', { cx: 9, cy: 14.6, r: 1.3, f: 'gold' }],
      ['circle', { cx: 15, cy: 14.6, r: 1.3, f: 'green' }]
    ],
    varoshaza: [
      ['path', { d: 'M12 2.5 3 8h18z', f: 'blue' }],
      ['rect', { x: 3.5, y: 8, width: 17, height: 2, f: 'stone-hi' }],
      ['path', { d: 'M5.5 10h2.2v8H5.5zM10.9 10h2.2v8h-2.2zM16.3 10h2.2v8h-2.2z', f: 'stone-hi' }],
      ['rect', { x: 2.5, y: 18, width: 19, height: 3, f: 'stone' }],
      ['circle', { cx: 12, cy: 6, r: 1.1, f: 'gold', s: 'none' }]
    ],
    alvilag: [
      ['path', { d: 'M18.5 3.5 20.5 5.5 11 15l-2-2z', f: 'steel-hi' }],
      ['path', { d: 'M7.5 12l4.5 4.5M8.5 15.5 6 18', s: 'line', sw: 1.6 }],
      ['circle', { cx: 5.3, cy: 18.7, r: 1.3, f: 'gold' }],
      ['path', { d: 'M2.5 7.5c2.5-1.2 5-1.2 7 .5 2-1.7 4.5-1.7 7-.5 0 3.3-1.5 6-3.7 6-1.5 0-2.4-.8-3.3-2.2-.9 1.4-1.8 2.2-3.3 2.2-2.2 0-3.7-2.7-3.7-6z', f: 'black' }],
      ['ellipse', { cx: 6.1, cy: 9.2, rx: 1.3, ry: 0.8, f: 'white', s: 'none' }],
      ['ellipse', { cx: 12.9, cy: 9.2, rx: 1.3, ry: 0.8, f: 'white', s: 'none' }]
    ],

    /* Akciók */
    route: [
      ['path', { d: 'M11 3h2v18.5h-2z', f: 'brown' }],
      ['path', { d: 'M5 5h11.5L19 7.2 16.5 9.5H5z', f: 'gold' }],
      ['path', { d: 'M19 11H7.5L5 13.2l2.5 2.3H19z', f: 'paper' }],
      ['path', { d: 'M7.5 7.2h6M10 13.2h6', s: 'gold-lo', sw: 1 }],
      ['path', { d: 'M5.5 21.5h13', s: 'green', sw: 1.8 }]
    ],
    margin: [
      ['path', { d: 'M3 12.5 11.5 4H20v8.5L11.5 21z', f: 'gold-hi' }],
      ['circle', { cx: 16.2, cy: 7.8, r: 1.5, f: 'paper' }],
      ['path', { d: 'M9 15l4.5-4.5', s: 'red', sw: 1.4 }],
      ['circle', { cx: 9.5, cy: 11.3, r: 1.1, f: 'none', s: 'red' }],
      ['circle', { cx: 13, cy: 14.8, r: 1.1, f: 'none', s: 'red' }]
    ],
    buyShares: [
      ['circle', { cx: 11, cy: 13, r: 8, f: 'paper' }],
      ['path', { d: 'M11 13V5a8 8 0 0 1 8 8z', f: 'gold' }],
      ['path', { d: 'M11 13l-6.2 5.1A8 8 0 0 1 3 13z', f: 'sky' }],
      ['circle', { cx: 18.5, cy: 5, r: 3.5, f: 'green' }],
      ['path', { d: 'M18.5 3.3v3.4M16.8 5h3.4', s: 'white', sw: 1.4 }]
    ],
    buyout: [
      ['path', { d: 'M10 13.5V5.5a8 8 0 1 0 8 8z', f: 'sky' }],
      ['path', { d: 'M13 10.5V2.5a8 8 0 0 1 8 8z', f: 'gold' }],
      ['path', { d: 'M3.5 20.5c3 1.5 7 1 9.5-1.5', s: 'red', sw: 1.6, f: 'none' }],
      ['path', { d: 'M13.8 17.5l-.6 2.3-2.3-.3', s: 'red', sw: 1.6, f: 'none' }]
    ],
    defend: [
      ['path', { d: 'M12 2.5l8 3v6.5c0 4.5-3.2 7.8-8 9.5-4.8-1.7-8-5-8-9.5V5.5z', f: 'blue' }],
      ['path', { d: 'M12 2.5v19c-4.8-1.7-8-5-8-9.5V5.5z', f: 'sky', s: 'none' }],
      ['path', { d: 'M12 2.5l8 3v6.5c0 4.5-3.2 7.8-8 9.5-4.8-1.7-8-5-8-9.5V5.5z', f: 'none' }],
      ['circle', { cx: 12, cy: 11.5, r: 3.3, f: 'gold', s: 'gold-lo' }],
      ['path', { d: 'M12 10v3', s: 'gold-lo', sw: 1.3 }]
    ],
    foundParty: [
      ['path', { d: 'M5 2.5h1.8v19H5z', f: 'brown' }],
      ['path', { d: 'M6.8 4H20l-3 4.5 3 4.5H6.8z', f: 'blue' }],
      ['path', { d: 'M6.8 8.5H17', s: 'gold', sw: 1.6 }],
      ['circle', { cx: 5.9, cy: 2.4, r: 1.3, f: 'gold' }],
      ['path', { d: 'M3 21.5h6', s: 'line', sw: 1.6 }]
    ],
    program: [
      ['path', { d: 'M5 5.5h11v13.5a2 2 0 0 1-2 2H4.5a2 2 0 0 1-2-2v-1.5H5z', f: 'paper' }],
      ['path', { d: 'M5 5.5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1H16', f: 'cream' }],
      ['path', { d: 'M7.5 9.5h5.5M7.5 12.5h5.5M7.5 15.5h3.5', s: 'stone-lo', sw: 1.1 }],
      ['path', { d: 'M21.5 2.5c-3 .5-6 3.5-7.5 8.5l1 .5c3.5-2.5 6-5.5 6.5-9z', f: 'white' }],
      ['path', { d: 'M14 11l-1.2 2.5', s: 'line', sw: 1.2 }]
    ],
    festival: [
      ['path', { d: 'M1.5 5c7 4 14 4 21 0', s: 'brown', sw: 1.3, f: 'none' }],
      ['path', { d: 'M3.5 6.2 5 12l2.5-4.7z', f: 'red' }],
      ['path', { d: 'M9 7.8 10.3 13.5 12.5 8.1z', f: 'gold' }],
      ['path', { d: 'M14.5 8 15.8 13.4l2.3-5.9z', f: 'blue' }],
      ['path', { d: 'M19.8 6.6l.9 5.4 2-4.9z', f: 'green' }],
      ['path', { d: 'M12 16.5v5M9.5 19h5M10.2 17.2l3.6 3.6M13.8 17.2l-3.6 3.6', s: 'orange', sw: 1.3 }]
    ],
    news: [
      ['path', { d: 'M3 10.5v3l2 .5 12 5V5L5 10z', f: 'gold' }],
      ['path', { d: 'M17 5c2 1.5 3 4 3 7s-1 5.5-3 7z', f: 'gold-hi' }],
      ['rect', { x: 1.8, y: 10, width: 2.4, height: 4, rx: 0.8, f: 'gold-lo' }],
      ['path', { d: 'M6 14.5l1.2 6h3l-1.2-5', f: 'red' }],
      ['path', { d: 'M8 9.8l6-2.5', s: 'white', sw: 1.1 }]
    ],
    hireSpy: [
      ['path', { d: 'M12 2.5c-4 0-6.5 3.5-6.5 7.5v4L3 21.5h18L18.5 14v-4c0-4-2.5-7.5-6.5-7.5z', f: 'purple' }],
      ['path', { d: 'M12 6c-2.2 0-3.6 2-3.6 4.2 0 2.5 1.6 4.3 3.6 4.3s3.6-1.8 3.6-4.3C15.6 8 14.2 6 12 6z', f: 'black' }],
      ['path', { d: 'M9.8 10h1.4M12.8 10h1.4', s: 'gold-hi', sw: 1.2 }],
      ['circle', { cx: 18, cy: 18, r: 3.3, f: 'gold', s: 'gold-lo' }],
      ['path', { d: 'M18 16.6v2.8', s: 'gold-lo', sw: 1.2 }]
    ],
    guard: [
      ['path', { d: 'M9.5 2.5h5l1 2.5h-7z', f: 'steel' }],
      ['path', { d: 'M12 1v1.5', s: 'line', sw: 1.3 }],
      ['path', { d: 'M7 5h10l-1 13H8z', f: 'gold-hi' }],
      ['path', { d: 'M12 8.5c-2 2-2.2 4 0 6.5 2.2-2.5 2-4.5 0-6.5z', f: 'orange' }],
      ['path', { d: 'M7 5h10M8 18h8', s: 'steel-lo', sw: 1.6 }],
      ['path', { d: 'M7.5 18h9l.8 3.5H6.7z', f: 'steel' }]
    ],
    spy: [
      ['path', { d: 'M3 15.5 14.5 7l2.8 3.8L5.8 19.3z', f: 'gold' }],
      ['path', { d: 'M14.5 7 17.5 4.8l2.8 3.8-3 2.2z', f: 'gold-hi' }],
      ['ellipse', { cx: 18.9, cy: 6.7, rx: 1.3, ry: 2.4, f: 'sky', t: 'rotate(-36 18.9 6.7)' }],
      ['path', { d: 'M8 11.8l2.8 3.8', s: 'gold-lo', sw: 1.3 }],
      ['path', { d: 'M6.5 19l-1.5 3M8.5 17.5l2 4', s: 'brown', sw: 1.4 }]
    ],
    verify: [
      ['path', { d: 'M3 3.5h11v17H3z', f: 'paper' }],
      ['path', { d: 'M5.5 7h6M5.5 10h6M5.5 13h4', s: 'stone-lo', sw: 1.1 }],
      ['path', { d: 'M17.2 17.2 21.5 21.5', s: 'brown', sw: 2.6 }],
      ['circle', { cx: 14.5, cy: 14.5, r: 4.3, f: 'sky' }],
      ['path', { d: 'M12.6 14.6l1.4 1.4 2.6-2.8', s: 'green', sw: 1.6 }]
    ],
    debunk: [
      ['path', { d: 'M3 3.5h8l-1.5 4 2 3.5-1.5 4 1.5 5.5H3z', f: 'paper' }],
      ['path', { d: 'M13.5 3.5H21v17h-7.5l-1-5.5 1.5-4-2-3.5z', f: 'paper', t: 'translate(1 1) rotate(6 17 12)' }],
      ['path', { d: 'M5 7.5h3.5M5 10.5h4M5 13.5h3', s: 'stone-lo', sw: 1.1 }],
      ['path', { d: 'M15.5 9.5l4 4M19.5 9.5l-4 4', s: 'red', sw: 2 }]
    ]
  };
  var BRANCH_OF = { route: null, margin: 'vasarter', buyShares: 'vasarter', buyout: 'vasarter', defend: 'vasarter', foundParty: 'varoshaza', program: 'varoshaza', festival: 'varoshaza', news: 'varoshaza', hireSpy: 'alvilag', guard: 'alvilag', spy: 'alvilag', verify: 'alvilag', debunk: 'alvilag' };
  function icv(k) { return k === 'none' ? 'none' : 'var(--ic-' + k + ')'; }
  function GameIcon(p) {
    var name = p.name, parts = GAME[name];
    if (!parts) return h(Icon, { name: p.name, size: p.size, label: p.label, className: p.className });
    var size = p.size || 20, tile = p.tile === true ? BRANCH_OF[name] || 'kozos' : p.tile;
    var art = h('svg', { className: cx('tn-gicon', p.className), width: size, height: size, viewBox: '0 0 24 24', 'aria-hidden': p.label && !tile ? undefined : true, role: p.label && !tile ? 'img' : undefined, 'aria-label': tile ? undefined : p.label },
      parts.map(function (e, i) {
        var a = e[1], o = { key: i, fill: icv(a.f || 'none'), stroke: icv(a.s || 'line'), strokeWidth: (a.sw || 1.1) * 1.05, strokeLinecap: 'round', strokeLinejoin: 'round' };
        Object.keys(a).forEach(function (k) { if (k === 't') o.transform = a.t; else if (['f', 's', 'sw'].indexOf(k) < 0) o[k] = a[k]; });
        return h(e[0], o);
      }));
    if (!tile) return art;
    return h('span', { className: cx('tn-gtile', 'tn-gtile-' + tile), style: { width: Math.round(size * 1.6), height: Math.round(size * 1.6) }, role: p.label ? 'img' : undefined, 'aria-label': p.label, 'aria-hidden': p.label ? undefined : true }, art);
  }
  GameIcon.names = Object.keys(GAME);
  GameIcon.branchOf = BRANCH_OF;

  /* ---------- Base UI ---------- */
  function Button(p) {
    var rest = Object.assign({}, p); ['variant', 'size', 'icon', 'art', 'className', 'children'].forEach(function (k) { delete rest[k]; });
    return h('button', Object.assign({ type: 'button' }, rest, { className: cx('tn-btn', p.variant && p.variant !== 'default' && 'tn-btn-' + p.variant, p.size === 'sm' && 'tn-btn-sm', p.className) }),
      (function () { var art = p.art || (GAME[p.icon] ? p.icon : NAV_ART[p.icon]); var z = p.size === 'sm' ? 18 : p.variant === 'seal' ? 24 : 20;
        return art ? h(GameIcon, { name: art, size: z }) : p.icon ? h(Icon, { name: p.icon, size: p.size === 'sm' ? 16 : 18 }) : null; })(), p.children);
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
      return h('button', { key: t.id, role: 'tab', className: cx('tn-tab', t.tone && 'tn-tab-' + t.tone), 'aria-selected': t.id === active ? 'true' : 'false', onClick: function () { p.onChange ? p.onChange(t.id) : st[1](t.id); } },
        t.art ? h(GameIcon, { name: t.art, size: 18 }) : null, t.label, t.badge ? h('span', { className: 'tn-tab-badge' }, t.badge) : null);
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
  var RES = { nep: ['nep', 'Népszerűség'], ado: ['ado', 'Adó'], arany: ['arany', 'Arany'], bp: ['bp', 'Befolyáspont'], ke: ['ke', 'Katonai erő'], legit: ['legit', 'Legitimitás'], pp: ['pp', 'Parancspont'] };
  var RES_SHORT = { nep: 'N', arany: 'A', bp: 'BP', ke: 'KE', legit: 'L', pp: 'PP' };
  function ResourceChip(p) {
    var r = RES[p.kind] || RES.arany, d = p.delta;
    return h('span', { className: cx('tn-res', 'tn-res-' + p.kind), title: r[1] },
      GAME[r[0]] ? h(GameIcon, { name: r[0], size: 18, label: r[1] }) : h(Icon, { name: r[0], size: 14, label: r[1] }), h('span', null, p.value),
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
          h('span', { className: 'tn-order-label' }, o.art ? h(GameIcon, { name: o.art, size: 16, tile: true, className: 'tn-order-art' }) : null, o.label, o.hidden ? h('span', { className: 'tn-hidden-tag' }, 'Rejtett') : null),
          h('span', { className: 'tn-order-cost' }, costText(o.cost), p.onRemove && !p.sealed ? h('button', { type: 'button', className: 'tn-order-remove', 'aria-label': o.label + ' törlése', onClick: function () { p.onRemove(i); } }, h(Icon, { name: 'close', size: 14 })) : null),
          h('span', { className: 'tn-order-meta' }, [o.city, o.faction && FACTIONS[o.faction] ? FACTIONS[o.faction][1] : o.faction, o.note].filter(Boolean).join(' · ')));
      })),
      h('div', { className: 'tn-orders-foot' },
        h('span', { className: cx('tn-orders-total', over && 'tn-over') }, total + ' / ' + (p.available || 0) + ' PP', over ? ' · túllépés' : ''),
        p.sealed ? h('span', { className: 'tn-sealed' }, h(Icon, { name: 'pp', size: 16 }), 'Lepecsételve') : h(Button, { variant: 'seal', icon: 'pp', disabled: over || !orders.length, onClick: p.onSeal }, 'Parancsok lepecsételése')));
  }

  function TickTimer(p) {
    return h('span', { className: cx('tn-tick', p.soon && 'tn-tick-soon') }, h(GameIcon, { name: 'homokora', size: 18 }),
      h('span', null, 'Elszámolás ', p.at ? h('b', null, p.at) : null), p.remaining ? h('span', { className: 'tn-tick-rem' }, p.remaining) : null);
  }
  /* ---------- Map ---------- */
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
    var hr = rng('hs' + seed), shade = [];
    for (var si = 0; si < 40; si++) shade.push(h('ellipse', { key: si, cx: (hr() * w).toFixed(1), cy: (hr() * hh).toFixed(1), rx: (14 + hr() * 34).toFixed(1), ry: (8 + hr() * 18).toFixed(1), fill: si % 3 ? '#fff4cf' : '#2f4a22', opacity: si % 3 ? 0.22 : 0.2 }));
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h(PaintDefs, null), h(I4Defs, null),
      h('defs', null,
        h('radialGradient', { id: gid, cx: '42%', cy: '38%', r: '85%' }, h('stop', { offset: '0%', stopColor: 'var(--map-grass-hi)' }), h('stop', { offset: '100%', stopColor: 'var(--map-grass)' })),
        h('radialGradient', { id: lid, cx: '25%', cy: '15%', r: '70%' }, h('stop', { offset: '0%', stopColor: '#fff4cf', stopOpacity: 0.22 }), h('stop', { offset: '100%', stopColor: '#fff4cf', stopOpacity: 0 })),
        h('radialGradient', { id: vid, cx: '50%', cy: '50%', r: '72%' }, h('stop', { offset: '68%', stopColor: '#000', stopOpacity: 0 }), h('stop', { offset: '100%', stopColor: '#2c1f13', stopOpacity: 0.32 }))),
      h('rect', { width: w, height: hh, fill: 'url(#' + gid + ')' }),
      h('g', { 'aria-hidden': true }, h('g', { filter: 'url(#kg-blur-lg)' }, groundPatches(seed, w, hh, 170), shade),
        h('path', { d: tufts(seed, w, hh, 420), stroke: 'var(--map-tuft)', strokeWidth: 0.45, fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round', opacity: 0.4 }),
        flowers(seed, w, hh, 90)),
      (function () { var gr = rng('mg' + seed), A = [], B = []; for (var q = 0; q < 1300; q++) { var x = gr() * w, y = gr() * hh, l = 0.6 + gr() * 0.9; (q % 2 ? A : B).push('M' + x.toFixed(1) + ' ' + y.toFixed(1) + 'l' + ((gr() - 0.5) * 0.6).toFixed(1) + ' -' + l.toFixed(1)); } return h('g', { 'aria-hidden': true }, h('path', { d: A.join(''), stroke: '#5f7d3a', strokeWidth: 0.3, opacity: 0.45 }), h('path', { d: B.join(''), stroke: '#d2e09a', strokeWidth: 0.3, opacity: 0.4 })); })(),
      p.children,
      h('rect', { width: w, height: hh, filter: 'url(#kg-grain)', opacity: 0.3, pointerEvents: 'none' }),
      h('rect', { width: w, height: hh, fill: 'url(#' + lid + ')', pointerEvents: 'none' }),
      h('rect', { width: w, height: hh, fill: 'url(#' + vid + ')', pointerEvents: 'none' }),
      h('g', { pointerEvents: 'none', 'aria-hidden': true },
        h('rect', { x: 2.5, y: 2.5, width: w - 5, height: hh - 5, fill: 'none', stroke: 'var(--frame-lo)', strokeWidth: 0.5, opacity: 0.7 }),
        h('path', { d: ticks.join(''), stroke: 'var(--outline)', strokeWidth: 0.45, opacity: 0.55 })));
  }
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
      p.name ? h('text', { className: 'tn-city-label', x: 0, y: 17, textAnchor: 'middle' }, p.name) : null);
  }
  /* ---------- Map terrain ---------- */
  function rng(seed) { var s = 0; for (var i = 0; i < String(seed).length; i++) s = (s * 31 + String(seed).charCodeAt(i)) >>> 0; s = s || 7; return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; }; }
  function useUid(p) { var id = React.useId ? React.useId() : 'x'; return 'tn' + String(id).replace(/[^A-Za-z0-9]/g, '') + (p || ''); }

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
  function Mountain(p) { var s = p.s || 1; return iWith(1.45 * s, p.x, p.y, function () { return h('g', null, iRock(0, 0, 6, 10.5, 'mt' + p.x + p.y, 'm', { snow: true }).el); }); }
  function Tree(t, k) { return iTree(t.x, t.y + t.r * 1.15, t.r * 1.05, t.pine ? 'pine' : t.fruit ? 'fruit' : 'oak', k, rng('tr' + t.x.toFixed(1) + t.y.toFixed(1))); }
  function Forest(p) {
    var r = rng('f' + p.x + p.y), n = p.n || 5, trees = [], cnt = Math.round(n * 2.4), sx = n * 3.4, sy = n * 1.7;
    for (var i = 0; i < cnt; i++) { var a = r() * Math.PI * 2, d = Math.sqrt(r()); trees.push({ x: p.x + Math.cos(a) * d * sx, y: p.y + Math.sin(a) * d * sy, r: (p.small ? 1.8 : 2.6) + r() * 1.5, pine: r() < (p.pine == null ? 0.45 : p.pine) }); }
    trees.sort(function (a, b) { return a.y - b.y; });
    return h('g', null,
      n > 2 ? h('ellipse', { cx: p.x + 1, cy: p.y + 2, rx: sx + 3, ry: sy + 2.5, fill: 'var(--map-forest-lo)', opacity: 0.4, filter: 'url(#kg-blur)' }) : null,
      trees.map(function (t, i) { return Tree(t, i); }));
  }
  var CROPS = ['var(--map-field)', 'var(--map-field-2)', 'var(--map-grass-hi)', '#b9b56a', '#c8a45a', 'var(--map-field)'];
  function Field(p) { return Farm({ x: p.x, y: p.y, cols: 2, rows: 1, cw: p.w / 2, ch: p.h }); }
  function Farm(p) {
    var r = rng('farm' + p.x + p.y), cw = p.cw || 9, ch = p.ch || 6, c = p.cols * cw / ((p.cols + p.rows) * 0.866), X = p.x + p.rows * c * 0.866, fs = [];
    return iWith(1, X, p.y, function () {
      for (var i = 0; i < p.cols; i++) for (var j = 0; j < p.rows; j++) fs.push(iField(i * c, j * c, (i + 1) * c - 0.2, (j + 1) * c - 0.2, Math.floor(r() * CROP4.length), r() < 0.5, 'f' + i + '-' + j, r));
      var hb = []; for (var e = 0; e < p.cols + p.rows; e++) { var edge = r() < 0.5, t = r(), q = edge ? iP(t * p.cols * c, Math.floor(r() * (p.rows + 1)) * c) : iP(Math.floor(r() * (p.cols + 1)) * c, t * p.rows * c); hb.push(h('circle', { key: e, cx: iF(q[0]), cy: iF(q[1]), r: 1.2, fill: 'url(#i4-tree2)', stroke: '#1f3319', strokeWidth: 0.2 })); }
      return h('g', null, fs, hb, p.house ? MiniHouse(p.x - 4, p.y - 6, 'var(--roof-red)', 'fh', 4) : null);
    });
  }
  var RMAP = { 'var(--roof-red)': 'red', 'var(--roof-brown)': 'brown', 'var(--roof-blue)': 'slate', 'var(--roof-teal)': 'teal' };
  function MiniHouse(x, y, roof, k, w) { w = w || 4; var sc = w / 4, r = rng('mh' + x + y); return iWith(1.1 * sc, x + w / 2, y + w * 0.4, function () { return h('g', { key: k }, iHouse([-1.8, -1.5, 3.6, 3, 1, r() < 0.5 ? 'plaster' : 'white', RMAP[roof] || 'red', r() < 0.5 ? 'c' : ''], r, 'h').el); }); }
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
  function Hill(x, y, s, k) {
    var w = 10 * s, t = 6.5 * s, r = rng('hl' + x + y), tf = [];
    for (var i = 0; i < 9; i++) { var tx = x - w * 0.7 + r() * w * 1.4, ty = y - t * (0.15 + r() * 0.55); tf.push('M' + iF(tx) + ' ' + iF(ty) + 'l.4-1.3M' + iF(tx + 0.8) + ' ' + iF(ty) + 'l.2-1.1'); }
    return h('g', { key: k },
      h('ellipse', { cx: x + w * 0.35, cy: y + 0.6, rx: w * 1.15, ry: t * 0.35, fill: '#2c3f1c', opacity: 0.25, filter: 'url(#kg-blur)' }),
      h('path', { d: 'M' + (x - w) + ' ' + y + 'C' + (x - w * 0.6) + ' ' + (y - t) + ' ' + (x + w * 0.5) + ' ' + (y - t * 1.05) + ' ' + (x + w) + ' ' + y + 'Q' + x + ' ' + (y + t * 0.18) + ' ' + (x - w) + ' ' + y + 'z', fill: 'url(#i4-hill)' }),
      h('path', { d: tf.join(''), stroke: '#5f7d3a', strokeWidth: 0.4, opacity: 0.6, strokeLinecap: 'round' }));
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
  /* ---------- City view ---------- */
  var WALL = [[60, 70], [150, 30], [260, 40], [320, 110], [300, 200], [210, 250], [100, 240], [40, 160]];
  var GATES = [[40, 160], [185, 35], [320, 110], [210, 250]];
  var STREETS = [[[40, 160], [180, 140]], [[180, 140], [320, 110]], [[185, 35], [180, 140]], [[180, 140], [210, 250]]];
  var DISTRICTS = {
    nemesseg: { poly: [[60, 70], [150, 30], [185, 35], [180, 140], [40, 160]], name: 'Városháza', label: [110, 138], flag: [138, 72] },
    katonasag: { poly: [[185, 35], [260, 40], [320, 110], [180, 140]], name: 'Alvilág', label: [226, 124], flag: [262, 52] },
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
    var x = p.x, y = p.y, c = tint(p.tincture);
    return h('g', null, h('path', { d: 'M' + x + ' ' + (y + 22) + 'V' + (y - 6), stroke: 'var(--outline)', strokeWidth: 1.3, strokeLinecap: 'round' }),
      h('circle', { cx: x, cy: y - 6.8, r: 1.4, fill: 'var(--frame)', stroke: 'var(--outline)', strokeWidth: 0.6 }),
      h('path', { d: 'M' + x + ' ' + (y - 5) + 'c5-2 9 2 15 0l-3.5 4.5 3.5 4.5c-6 2-10-2-15 0z', fill: c, stroke: 'var(--outline)', strokeWidth: 0.9, strokeLinejoin: 'round' }),
      h('path', { d: 'M' + (x + 7) + ' ' + (y - 4.8) + 'c2 .6 4 .6 8-.2l-3.5 4.5 3.5 4.5c-4 .8-6 .8-8 .2z', fill: '#000', opacity: 0.18 }));
  }
  function Flame(p) { return h('g', null, h('circle', { cx: p.x + 1, cy: p.y - 6, r: 11, fill: 'var(--ic-orange-hi)', opacity: 0.3 }), h('path', { d: 'M' + p.x + ' ' + p.y + 'c-6-3-5-9 0-15c0 4 3 4 3 8c1-2 2-3 1.5-6c5 5 3.5 11-4.5 13z', fill: 'var(--ic-orange)', stroke: 'var(--outline)', strokeWidth: 0.8 }), h('path', { d: 'M' + (p.x + 0.5) + ' ' + (p.y - 1) + 'c-2.5-1.5-2-4 0-6c1 2 3 3 0 6z', fill: 'var(--ic-gold-hi)' })); }
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
  /* ház: spec = [u, v, w, d, emelet, anyag, tető, jelzők]
     jelzők: j = kiugró emelet, t = favázas, s = bolt ponyvával, g = cégér, d = tetőablak, b = erkély,
             n = nemesi ablakok, c = kémény, l = világító ablakok, k = düledező, h = konty, p = gúla, v = gerinc v irányban, f = virágláda */
  function iHouse(sp, r, key) {
    var u0 = sp[0], v0 = sp[1], w = sp[2], dd = sp[3], fl = sp[4], m = MAT[sp[5]], R = ROOF[sp[6]], fg = sp[7] || '', o = [];
    var has = function (c) { return fg.indexOf(c) >= 0; };
    var fh = 2.5, H = fl * fh + 0.3, jet = has('j') && fl > 1 ? 0.5 : 0, u1 = u0 + w, v1 = v0 + dd, U1 = u1 + jet, V1 = v1 + jet;
    var type = has('h') ? 'hip' : has('p') ? 'pyr' : has('v') ? 'gv' : (w >= dd ? 'gu' : 'gv');
    var span = type === 'gv' ? w : dd, rh = sp[8] || Math.min(type === 'gu' || type === 'gv' ? 5.2 : 4, span * (type === 'hip' || type === 'pyr' ? 0.45 : 0.62));
    var slum = has('k'), noble = has('n'), dark = sp[5] === 'dark' || sp[5] === 'grey';
    var shut = SHUT[Math.floor(r() * SHUT.length)], kind = sp[6] === 'thatch' ? 'thatch' : sp[6] === 'slate' ? 'slate' : 'tile';
    // árnyék a földön
    o.push(h('polygon', { key: o.length, points: iPts([[U1, v0, 0], [U1 + H * 0.75, v0 + H * 0.12, 0], [U1 + H * 0.75, V1 + H * 0.2, 0], [u0 + H * 0.3, V1 + H * 0.2, 0], [u0, V1, 0]]), fill: '#24190f', opacity: 0.3, filter: 'url(#kg-blur)' }));
    var stoneBase = jet || has('n') || sp[5] === 'stone';
    var gm = stoneBase ? MAT.stone : m, B0, B1;
    if (jet) {
      B0 = iBox(o, u0, v0, u1, v1, 0, fh, gm, { noTop: true });
      iStone(o, B0.L, gm, 3, Math.round(w / 1.1)); iStone(o, B0.R, gm, 3, Math.round(dd / 1.1));
      iPoly(o, [[u0, V1, fh], [U1, V1, fh], [U1, v0, fh], [U1, v0, fh - 0.3], [U1, V1, fh - 0.3], [u0, V1, fh - 0.3]], '#5a3a24', { strokeWidth: 0.25 });
      for (var q = 0.5; q < w; q += 1.6) iPathEl(o, iLn([u0 + q, v1, fh - 0.3], [u0 + q, V1, fh - 0.3]), '#3e2a18', 0.6);
      B1 = iBox(o, u0, v0, U1, V1, fh, H, m, { noTop: true });
      if (has('t')) { iTimber(o, B1.L, w + jet, fl - 1); iTimber(o, B1.R, dd + jet, fl - 1); }
    } else {
      B1 = iBox(o, u0, v0, u1, v1, 0, H, m, { noTop: true });
      if (sp[5] === 'stone' || sp[5] === 'grey') { iStone(o, B1.L, m, Math.round(H / 0.7), Math.round(w / 1.2)); iStone(o, B1.R, m, Math.round(H / 0.7), Math.round(dd / 1.2)); }
      else if (sp[5] === 'wood' || sp[5] === 'barn') { iPlanks(o, B1.L, Math.round(w / 0.5), m.line); iPlanks(o, B1.R, Math.round(dd / 0.5), m.line); }
      else if (has('t')) { iTimber(o, B1.L, w, fl); iTimber(o, B1.R, dd, fl); }
      else if (noble) { iPoly(o, iQ(B1.L, 0, 0, 1, 0.9 / H), MAT.stone.lit, { strokeWidth: 0.2 }); iPoly(o, iQ(B1.R, 0, 0, 1, 0.9 / H), MAT.stone.shade, { strokeWidth: 0.2 }); }
      if (noble) { iPathEl(o, iLn(iM(B1.L, 0, fh / H), iM(B1.L, 1, fh / H)) + iLn(iM(B1.R, 0, fh / H), iM(B1.R, 1, fh / H)), '#fff8e8', 0.8, { opacity: 0.6 }); }
    }
    if (slum) { var st = []; for (var n = 0; n < 5; n++) { var ps = iM(B1.L, r(), r() * 0.8 + 0.1), pp = iP.apply(null, ps); st.push('M' + iF(pp[0]) + ' ' + iF(pp[1]) + 'c.8 .6 1.4 1.6 1 2.6'); } iPathEl(o, st.join(''), '#3e342b', 0.5, { opacity: 0.5 }); }
    // ablakok emeletenként
    function faceL(f) { var vv = f === 0 ? v1 : V1, uu = f === 0 ? u1 : U1; return [[u0, vv, f * fh], [uu, vv, f * fh], [uu, vv, (f + 1) * fh], [u0, vv, (f + 1) * fh]]; }
    function faceR(f) { var vv = f === 0 ? v1 : V1, uu = f === 0 ? u1 : U1; return [[uu, vv, f * fh], [uu, v0, f * fh], [uu, v0, (f + 1) * fh], [uu, vv, (f + 1) * fh]]; }
    var doorAt = -1;
    for (var f = 0; f < fl; f++) {
      [[faceL(f), f === 0 ? w : w + jet, 'L'], [faceR(f), f === 0 ? dd : dd + jet, 'R']].forEach(function (Q) {
        var F = Q[0], len = Q[1], nW = I4.S < 1.6 ? 1 : Math.max(1, Math.floor(len / (noble ? 1.9 : 2.3))), ww = (noble ? 0.85 : 0.95) / len;
        if (f === 0 && Q[2] === 'L') doorAt = nW > 2 ? 1 : 0;
        for (var i = 0; i < nW; i++) {
          var s = (i + 0.5) / nW;
          if (f === 0 && Q[2] === 'L' && i === doorAt) { iDoor(o, F, s - 0.55 / len, s + 0.55 / len, 0.72, slum ? '#4a3a2e' : noble ? '#5a3a24' : ['#6e4a2c', '#4f6a86', '#7a3e2a', '#5f7d52'][Math.floor(r() * 4)], noble); continue; }
          if (f === 0 && has('s') && Q[2] === 'L') { iPoly(o, iQ(F, s - 0.8 / len, 0.12, s + 0.8 / len, 0.66), '#3a3130', { strokeWidth: 0.25 }); iPathEl(o, iLn(iM(F, s, 0.12), iM(F, s, 0.66)), '#e6dac0', 0.3); continue; }
          var lit = has('l') ? r() < 0.55 : r() < 0.12;
          iWin(o, F, s - ww / 2, noble ? 0.24 : 0.3, s + ww / 2, noble ? 0.74 : 0.76, { arch: noble && f > 0, shutter: !noble && !dark && r() < 0.75 ? shut : (dark && r() < 0.4 ? '#4a3a2e' : null), lit: lit, board: slum && !lit && r() < 0.35, flower: !slum && !noble && f > 0 && r() < 0.3, frame: dark ? '#9a8a76' : noble ? '#f3ecdc' : null });
        }
      });
    }
    // bolt: ponyva és áru
    if (has('s')) {
      var F0 = faceL(0), cols = ['#b5412f', '#3f6590', '#c99a2e', '#5b7d3c'][Math.floor(r() * 4)], aw = [[u0 + 0.2, v1, fh * 0.92], [u1 - 0.2, v1, fh * 0.92], [u1 - 0.2, v1 + 1.5, fh * 0.55], [u0 + 0.2, v1 + 1.5, fh * 0.55]];
      var N = Math.max(4, Math.round(w / 0.6));
      for (var a = 0; a < N; a++) iPoly(o, iQ(aw, a / N, 0, (a + 1) / N, 1), a % 2 ? '#f1e8d4' : cols, { strokeWidth: 0.2 });
      iPathEl(o, iLn(aw[0], aw[1]), I4O, 0.35);
      var sc = []; for (var b2 = 0; b2 < N; b2++) { var pa = iP.apply(null, iM(aw, (b2 + 0.5) / N, 0)); sc.push('M' + iF(pa[0] - 1) + ' ' + iF(pa[1]) + 'q1 1.4 2 0'); }
      iPathEl(o, sc.join(''), cols, 0.8);
      for (var g2 = 0; g2 < 3; g2++) { var gp = iP(u0 + 0.6 + g2 * 1.3 + (doorAt === 0 ? w * 0.4 : 0), v1 + 0.9, 0); o.push(h('g', { key: o.length }, kCrate(gp[0] - 1.7, gp[1], 'c'), h('circle', { cx: gp[0] - 0.8, cy: gp[1] - 3.3, r: 0.7, fill: ['#c0503a', '#d9a441', '#6b9a3a'][g2] }), h('circle', { cx: gp[0] + 0.5, cy: gp[1] - 3.4, r: 0.7, fill: ['#d9a441', '#c0503a', '#8a6a3a'][g2] }))); }
    }
    if (has('b') && fl > 1) {
      var bz = fh + 0.1, BF = [[u0 + w * 0.25, V1, bz], [u0 + w * 0.75, V1, bz], [u0 + w * 0.75, V1 + 0.8, bz], [u0 + w * 0.25, V1 + 0.8, bz]];
      iPoly(o, [[u0 + w * 0.25, V1, bz], [u0 + w * 0.75, V1, bz], [u0 + w * 0.75, V1 + 0.8, bz], [u0 + w * 0.25, V1 + 0.8, bz]], '#cfc3a8', { strokeWidth: 0.25 });
      var bl = []; for (var bb = 0; bb <= 6; bb++) { var bp = iL(BF[3], BF[2], bb / 6); bl.push(iLn(bp, [bp[0], bp[1], bz + 0.9])); } bl.push(iLn([BF[3][0], BF[3][1], bz + 0.9], [BF[2][0], BF[2][1], bz + 0.9]));
      iPathEl(o, bl.join(''), '#6f6352', 0.4);
    }
    if (has('g')) {
      var gz = fh * 0.95, gv = V1 - 0.35, gu = U1;
      iPathEl(o, iLn([gu, gv, gz], [gu + 1.4, gv, gz]) + iLn([gu, gv, gz - 0.6], [gu + 0.8, gv, gz]), '#2e2a28', 0.45);
      var SB = [[gu + 0.35, gv, gz - 1.3], [gu + 1.25, gv, gz - 1.3], [gu + 1.25, gv, gz - 0.2], [gu + 0.35, gv, gz - 0.2]];
      iPoly(o, SB, slum ? '#4a3a2a' : '#b98a4e', { strokeWidth: 0.3 });
      var sc2 = iP.apply(null, iM(SB, 0.5, 0.5)); o.push(h('circle', { key: o.length, cx: iF(sc2[0]), cy: iF(sc2[1]), r: 0.9, fill: slum ? '#d8b55c' : '#6e4a2c' }));
    }
    if (has('f')) { var vz = []; for (var vi = 0; vi < 6; vi++) { var vp = iP.apply(null, iM(faceL(0), 0.02 + r() * 0.1, r() * 0.9)); vz.push(h('circle', { key: vi, cx: iF(vp[0]), cy: iF(vp[1]), r: iF(0.8 + r() * 0.6), fill: '#5f8a45', opacity: 0.9 })); } o.push(h('g', { key: o.length }, vz)); }
    // tető kéménnyel
    var chim = has('c'), roofMid = function (oo) {
      if (!chim) return;
      var cu = type === 'gv' ? u0 + w * 0.22 : u0 + w * (0.25 + r() * 0.5), cv = type === 'gv' ? v0 + dd * (0.3 + r() * 0.4) : v0 + dd * 0.2;
      iChimney(oo, cu, cv, H + rh * 0.35, H + rh + 1.1);
      if (r() < 0.6 || has('l')) iSmoke(oo, cu + 0.45, cv + 0.45, H + rh + 1.6, r);
    };
    iRoof(o, u0, v0, U1, V1, H, rh, type, R, m, { kind: kind, mid: roofMid, gableWin: fl > 1 && !slum, dark: dark });
    if (has('d') && type === 'gu' && w > 5) {
      for (var dn = 0; dn < (w > 8 ? 2 : 1); dn++) {
        var du = u0 + w * (w > 8 ? 0.25 + dn * 0.42 : 0.4), dv = (v0 + V1) / 2 + (V1 - v0) * 0.08, dz = H + rh * 0.35;
        iBox(o, du, dv, du + 1.5, dv + 1.2, dz, dz + 1.5, m, { noTop: true });
        var DF = iBoxF(du, dv, du + 1.5, dv + 1.2, dz, dz + 1.5).L; iWin(o, DF, 0.3, 0.2, 0.7, 0.8, { lit: has('l') && r() < 0.5, sill: false });
        iRoof(o, du, dv, du + 1.5, dv + 1.2, dz + 1.5, 0.9, 'gv', R, m, { kind: kind, ov: 0.2 });
      }
    }
    if (slum && has('k') && r() < 0.5) { var hp = iP(u0 + w * 0.6, (v0 + V1) / 2 + dd * 0.25, H + rh * 0.5); o.push(h('path', { key: o.length, d: 'M' + iF(hp[0]) + ' ' + iF(hp[1]) + 'l2.2-1 1.2 1.6-1.4 1.4z', fill: '#1d1614' })); }
    var cxs = iP(u0 + w / 2, v1, 0), tilt = slum ? (r() - 0.5) * 3.2 : 0;
    return { el: h('g', { key: key, transform: tilt ? 'rotate(' + tilt.toFixed(1) + ' ' + iF(cxs[0]) + ' ' + iF(cxs[1]) + ')' : undefined }, o), depth: U1 + V1 };
  }
  /* fák: képernyő-koordinátában, a talppontra */
  function iTree(x, y, s, kind, key, r) {
    var o = [];
    o.push(h('ellipse', { key: o.length, cx: iF(x + s * 0.7), cy: iF(y + s * 0.12), rx: iF(s * 1.25), ry: iF(s * 0.42), fill: '#1f2a14', opacity: 0.32, filter: 'url(#kg-blur)' }));
    if (kind === 'pine') {
      o.push(h('rect', { key: o.length, x: iF(x - s * 0.1), y: iF(y - s * 0.7), width: iF(s * 0.2), height: iF(s * 0.7), fill: '#5b3d27' }));
      [[0.35, 1.0], [-0.35, 0.82], [-1.0, 0.64], [-1.6, 0.44]].forEach(function (q, i) {
        var ty = y + q[0] * s - s * 0.2, ww = q[1] * s, tp = ty - s * 1.05;
        o.push(h('path', { key: o.length, d: 'M' + iF(x - ww) + ' ' + iF(ty) + 'Q' + iF(x - ww * 0.4) + ' ' + iF(ty - s * 0.25) + ' ' + iF(x) + ' ' + iF(tp) + 'Q' + iF(x + ww * 0.4) + ' ' + iF(ty - s * 0.25) + ' ' + iF(x + ww) + ' ' + iF(ty) + 'Q' + iF(x) + ' ' + iF(ty + s * 0.2) + ' ' + iF(x - ww) + ' ' + iF(ty) + 'z', fill: 'url(#kg-pine)', stroke: '#1f3319', strokeWidth: 0.35, strokeOpacity: 0.6 }));
        o.push(h('path', { key: o.length, d: 'M' + iF(x - ww * 0.7) + ' ' + iF(ty - s * 0.05) + 'Q' + iF(x - ww * 0.35) + ' ' + iF(ty - s * 0.3) + ' ' + iF(x - s * 0.08) + ' ' + iF(tp + s * 0.2), stroke: '#8fb872', strokeWidth: iF(s * 0.1), fill: 'none', opacity: 0.55, strokeLinecap: 'round' }));
      });
      return h('g', { key: key }, o);
    }
    if (kind === 'cypress') {
      o.push(h('ellipse', { key: o.length, cx: iF(x), cy: iF(y - s * 1.3), rx: iF(s * 0.45), ry: iF(s * 1.4), fill: 'url(#kg-pine)', stroke: '#1f3319', strokeWidth: 0.35, strokeOpacity: 0.6 }));
      o.push(h('path', { key: o.length, d: 'M' + iF(x - s * 0.2) + ' ' + iF(y - s * 0.6) + 'q-.2 -1.2 .1-2.4', stroke: '#9cc27a', strokeWidth: iF(s * 0.12), fill: 'none', opacity: 0.5, strokeLinecap: 'round' }));
      return h('g', { key: key }, o);
    }
    o.push(h('path', { key: o.length, d: 'M' + iF(x - s * 0.12) + ' ' + iF(y) + 'l' + iF(s * 0.04) + ' -' + iF(s * 1.1) + 'h' + iF(s * 0.18) + 'l' + iF(s * 0.04) + ' ' + iF(s * 1.1) + 'z', fill: '#5b3d27' }));
    var cl = kind === 'bush' ? [[-0.5, -0.45, 0.55], [0.45, -0.4, 0.55], [0, -0.75, 0.6]] : [[-0.62, -1.15, 0.62], [0.62, -1.1, 0.6], [0, -1.05, 0.66], [-0.35, -1.7, 0.66], [0.38, -1.62, 0.62], [0, -2.12, 0.55]];
    if (kind !== 'bush') for (var e = 0; e < 3; e++) cl.push([(r() - 0.5) * 1.5, -1 - r() * 1.1, 0.35 + r() * 0.2]);
    cl.sort(function (a, b) { return (b[1] - b[0] * 0.3) - (a[1] - a[0] * 0.3); });
    var gr = kind === 'autumn' ? 'url(#i4-autumn)' : 'url(#i4-tree' + (1 + Math.floor(r() * 3)) + ')';
    o.push(h('circle', { key: o.length, cx: iF(x + s * 0.1), cy: iF(y + s * (kind === 'bush' ? -0.45 : -1.25)), r: iF(s * (kind === 'bush' ? 0.85 : 1.15)), fill: '#2c4520' }));
    cl.forEach(function (q) { var jx = (r() - 0.5) * 0.12, jy = (r() - 0.5) * 0.12; o.push(h('circle', { key: o.length, cx: iF(x + (q[0] + jx) * s), cy: iF(y + (q[1] + jy) * s), r: iF(q[2] * s), fill: gr, stroke: '#1f3319', strokeWidth: 0.3, strokeOpacity: 0.45 })); });
    for (var i = 0; i < 5; i++) o.push(h('circle', { key: o.length, cx: iF(x + (r() - 0.7) * s * 1.1), cy: iF(y - s * (kind === 'bush' ? 0.7 : 1.6) - r() * s * 0.5), r: iF(s * (0.12 + r() * 0.1)), fill: '#b9d27e', opacity: 0.55 }));
    if (kind === 'fruit') for (var j = 0; j < 6; j++) o.push(h('circle', { key: o.length, cx: iF(x + (r() - 0.5) * s * 1.6), cy: iF(y - s * (1 + r() * 1.1)), r: iF(s * 0.1), fill: '#c0443a' }));
    return h('g', { key: key }, o);
  }
  function iFig(x, y, c, key, hood, r) {
    var skin = ['#e2c09a', '#c9a07a', '#b08060'][Math.floor(r() * 3)], hat = r() < 0.3;
    return h('g', { key: key, transform: 'translate(' + iF(x) + ' ' + iF(y) + ')' },
      h('ellipse', { cx: 1.2, cy: 0.3, rx: 2, ry: 0.6, fill: '#1e140c', opacity: 0.35 }),
      h('path', { d: 'M-.8 0v-2.2M.8 0v-2.2', stroke: '#3a3130', strokeWidth: 0.7 }),
      h('path', { d: 'M-1.5-1.8l.4-3.4a1.1 1.1 0 0 1 2.2 0l.4 3.4z', fill: c, stroke: '#2a1e14', strokeWidth: 0.25 }),
      h('path', { d: 'M-1.2-4.2l-.5 2M1.2-4.2l.5 2', stroke: c, strokeWidth: 0.7, strokeLinecap: 'round' }),
      hood ? h('path', { d: 'M-1.2-5.2a1.2 1.2 0 0 1 2.4 0l.2 1.2h-2.8z', fill: '#241c22', stroke: '#2a1e14', strokeWidth: 0.2 }) : h('circle', { cx: 0, cy: -5.7, r: 0.95, fill: skin, stroke: '#2a1e14', strokeWidth: 0.2 }),
      !hood && hat ? h('path', { d: 'M-1.4-6.2h2.8M-.8-6.3a.8.8 0 0 1 1.6 0', stroke: '#6b4a30', strokeWidth: 0.6, fill: '#6b4a30' }) : null);
  }
  /* piaci stand */
  function iStall(u, v, kind, key, r) {
    var o = [], cl = { fruit: '#b5412f', cloth: '#3f6590', fish: '#3f6590', pots: '#c99a2e', bread: '#c99a2e', herbs: '#5b7d3c', meat: '#b5412f', spice: '#8a5a2e' }[kind] || '#b5412f';
    o.push(h('polygon', { key: o.length, points: iPts([[u + 2.8, v, 0], [u + 4.4, v + 0.4, 0], [u + 4.4, v + 2.2, 0], [u + 0.6, v + 2.2, 0], [u, v + 1.6, 0]]), fill: '#24190f', opacity: 0.28, filter: 'url(#kg-blur)' }));
    iPathEl(o, iLn([u + 0.1, v + 0.1, 0], [u + 0.1, v + 0.1, 2.6]) + iLn([u + 2.7, v + 0.1, 0], [u + 2.7, v + 0.1, 2.6]), '#5b3d27', 0.55);
    iBox(o, u, v + 0.2, u + 2.8, v + 1.5, 0, 0.95, MAT.wood, { top: '#b98a5a' });
    iPlanks(o, iBoxF(u, v + 0.2, u + 2.8, v + 1.5, 0, 0.95).L, 5, '#48301c');
    var top = iP(u, v + 0.2, 0.95), gd = [], cols = { fruit: ['#c0503a', '#d9a441', '#6b9a3a'], cloth: ['#8c3a2c', '#3b5f82', '#d8b55c', '#5a4466'], fish: ['#9fb3c2', '#b8c8d2'], pots: ['#b7643a', '#c98a55'], bread: ['#c9914e', '#b8803e'], herbs: ['#5f8a45', '#7fa05a'], meat: ['#b5503c', '#d88a7a'], spice: ['#c96d2a', '#d8b55c', '#8c3a2c'] }[kind] || ['#c0503a'];
    for (var i = 0; i < 9; i++) { var gp = iP(u + 0.4 + (i % 5) * 0.52, v + 0.5 + Math.floor(i / 5) * 0.55, 0.95); gd.push(h('circle', { key: i, cx: iF(gp[0]), cy: iF(gp[1] - 0.6), r: kind === 'cloth' ? 1 : 0.75, fill: cols[i % cols.length], stroke: '#2a1e14', strokeWidth: 0.15 })); }
    o.push(h('g', { key: o.length }, gd));
    iPathEl(o, iLn([u + 0.1, v + 1.6, 0], [u + 0.1, v + 1.6, 2.1]) + iLn([u + 2.7, v + 1.6, 0], [u + 2.7, v + 1.6, 2.1]), '#5b3d27', 0.55);
    var aw = [[u - 0.25, v + 2.05, 1.95], [u + 3.05, v + 2.05, 1.95], [u + 3.05, v - 0.2, 2.75], [u - 0.25, v - 0.2, 2.75]], N = 6;
    for (var a = 0; a < N; a++) iPoly(o, iQ(aw, a / N, 0, (a + 1) / N, 1), a % 2 ? '#f3ead6' : cl, { strokeWidth: 0.2 });
    var sc = []; for (var b = 0; b < N; b++) { var pa = iP.apply(null, iM(aw, (b + 0.5) / N, 0)); sc.push('M' + iF(pa[0] - 1.2) + ' ' + iF(pa[1]) + 'q1.2 1.6 2.4 0'); }
    iPathEl(o, sc.join(''), cl, 0.9);
    iAo(o, [aw[3], aw[2], aw[1], aw[0]]);
    var vp = iP(u + 1.4, v - 0.6, 0);
    return { el: h('g', { key: key }, o), depth: u + v + 5 };
  }
  function iWell(u, v, key) {
    var o = [];
    iCyl(o, u, v, 1.1, 0, 1.0, 'stone', { courses: true, topFill: '#6f6352' });
    var c = iP(u, v, 1.0); o.push(h('ellipse', { key: o.length, cx: iF(c[0]), cy: iF(c[1]), rx: 2.6, ry: 1.5, fill: '#2d3f48' }));
    iPathEl(o, iLn([u - 0.9, v, 1], [u - 0.9, v, 3.2]) + iLn([u + 0.9, v, 1], [u + 0.9, v, 3.2]) + iLn([u - 0.9, v, 2.9], [u + 0.9, v, 2.9]), '#5b3d27', 0.7);
    iRoof(o, u - 1.2, v - 0.9, u + 1.2, v + 0.9, 3.1, 1.1, 'gu', ROOF.brown, MAT.wood, { ov: 0.2 });
    return { el: h('g', { key: key }, o), depth: u + v + 2 };
  }
  function iFountain(u, v, rr, key, statue) {
    var o = [];
    iCyl(o, u, v, rr, 0, 0.8, 'stone', { courses: false, topFill: '#d8ccb2' });
    var c = iP(u, v, 0.8), rx = rr * 0.86 * 1.2247 * I4.S, ry = rr * 0.86 * 0.7071 * I4.S;
    o.push(h('ellipse', { key: o.length, cx: iF(c[0]), cy: iF(c[1]), rx: iF(rx), ry: iF(ry), fill: 'url(#kg-water)' }));
    o.push(h('path', { key: o.length, d: 'M' + iF(c[0] - rx * 0.6) + ' ' + iF(c[1]) + 'q' + iF(rx * 0.3) + ' -1.2 ' + iF(rx * 0.6) + ' 0t' + iF(rx * 0.6) + ' 0', stroke: '#e8f1ec', strokeWidth: 0.5, fill: 'none', opacity: 0.8 }));
    iCyl(o, u, v, rr * 0.18, 0.8, 2.6, 'stone', {});
    if (statue) {
      iBox(o, u - 0.5, v - 0.5, u + 0.5, v + 0.5, 2.6, 3.2, MAT.stone);
      var t = iP(u, v, 3.2);
      o.push(h('path', { key: o.length, d: 'M' + iF(t[0] - 1.4) + ' ' + iF(t[1]) + 'l.5-5.2a.9.9 0 0 1 1.8 0l.5 5.2z', fill: 'url(#kg-copper)', stroke: '#2a3f36', strokeWidth: 0.3 }));
      o.push(h('circle', { key: o.length, cx: iF(t[0]), cy: iF(t[1] - 6.2), r: 1.1, fill: 'url(#kg-copper)', stroke: '#2a3f36', strokeWidth: 0.25 }));
      o.push(h('path', { key: o.length, d: 'M' + iF(t[0] + 0.8) + ' ' + iF(t[1] - 4.6) + 'l2.4-2.6', stroke: '#5a8871', strokeWidth: 0.8, strokeLinecap: 'round' }));
    } else {
      var tt = iP(u, v, 2.6); o.push(h('ellipse', { key: o.length, cx: iF(tt[0]), cy: iF(tt[1]), rx: 2.4, ry: 1.2, fill: '#d8ccb2', stroke: I4O, strokeWidth: 0.3 }));
      o.push(h('path', { key: o.length, d: 'M' + iF(tt[0]) + ' ' + iF(tt[1] - 0.5) + 'q-2 -3 -4 1M' + iF(tt[0]) + ' ' + iF(tt[1] - 0.5) + 'q2 -3 4 1', stroke: '#eef6f4', strokeWidth: 0.7, fill: 'none', opacity: 0.8 }));
    }
    return { el: h('g', { key: key }, o), depth: u + v + rr * 2 };
  }
  /* parcella: iso paralelogramma sorokkal */
  var CROP4 = [['#d8b95a', '#b08e35', 'wheat'], ['#9db55e', '#728d3c', 'green'], ['#a67c55', '#7a5838', 'plow'], ['#c9b865', '#9f8f40', 'hay'], ['#86a656', '#5c7a36', 'veg'], ['#b2a36a', '#8c7e48', 'stub']];
  function iField(u0, v0, u1, v1, ci, alongU, key, r) {
    var c = CROP4[ci], o = [], d = [];
    o.push(h('polygon', { key: o.length, points: iPts([[u0 + 0.3, v0 + 0.3], [u1 + 0.3, v0 + 0.3], [u1 + 0.3, v1 + 0.6], [u0 + 0.3, v1 + 0.6]]), fill: '#2c1f13', opacity: 0.16, filter: 'url(#kg-blur)' }));
    o.push(h('polygon', { key: o.length, points: iPts([[u0, v0], [u1, v0], [u1, v1], [u0, v1]]), fill: c[0] }));
    if (alongU) for (var v = v0 + 0.45; v < v1; v += 0.75) d.push(iLn([u0 + 0.2, v], [u1 - 0.2, v]));
    else for (var u = u0 + 0.45; u < u1; u += 0.75) d.push(iLn([u, v0 + 0.2], [u, v1 - 0.2]));
    iPathEl(o, d.join(''), c[1], c[2] === 'plow' ? 0.8 : 0.55, { opacity: 0.85 });
    if (c[2] === 'wheat' || c[2] === 'hay') { var t = []; for (var i = 0; i < (u1 - u0) * (v1 - v0) * 0.6; i++) { var p = iP(u0 + r() * (u1 - u0), v0 + r() * (v1 - v0)); t.push('M' + iF(p[0]) + ' ' + iF(p[1]) + 'l.3-1.4'); } iPathEl(o, t.join(''), '#f0dc97', 0.45, { opacity: 0.7 }); }
    if (c[2] === 'veg') { var cs = []; for (var j = 0; j < (u1 - u0) * (v1 - v0) * 0.35; j++) { var q = iP(u0 + 0.4 + r() * (u1 - u0 - 0.8), v0 + 0.4 + r() * (v1 - v0 - 0.8)); cs.push(h('circle', { key: j, cx: iF(q[0]), cy: iF(q[1]), r: 0.75, fill: j % 3 ? '#4f7a32' : '#6f9a44' })); } o.push(h('g', { key: o.length }, cs)); }
    o.push(h('polygon', { key: o.length, points: iPts([[u0, v0], [u1, v0], [u1, v1], [u0, v1]]), fill: 'url(#i4-ao)', opacity: 0.5 }));
    return h('g', { key: key }, o);
  }
  function iFence(pts, key) {
    var o = [], d = [], rails = [];
    for (var i = 0; i < pts.length - 1; i++) {
      var a = pts[i], b = pts[i + 1], L = Math.hypot(b[0] - a[0], b[1] - a[1]), n = Math.max(1, Math.round(L / 1.6));
      for (var k = 0; k <= n; k++) { var p = iL(a, b, k / n); d.push(iLn([p[0], p[1], 0], [p[0], p[1], 1.1])); }
      rails.push(iLn([a[0], a[1], 0.95], [b[0], b[1], 0.95]) + iLn([a[0], a[1], 0.5], [b[0], b[1], 0.5]));
    }
    iPathEl(o, rails.join(''), '#7a5a3a', 0.45); iPathEl(o, d.join(''), '#5b3d27', 0.6);
    return h('g', { key: key }, o);
  }
  function iHay(u, v, s, key) {
    var p = iP(u, v, 0), o = [];
    o.push(h('ellipse', { key: 0, cx: iF(p[0] + s * 1.2), cy: iF(p[1] + 0.5), rx: iF(s * 1.8), ry: iF(s * 0.6), fill: '#24190f', opacity: 0.3, filter: 'url(#kg-blur)' }));
    o.push(h('path', { key: 1, d: 'M' + iF(p[0] - s * 1.3) + ' ' + iF(p[1]) + 'C' + iF(p[0] - s * 1.3) + ' ' + iF(p[1] - s * 2.2) + ' ' + iF(p[0] + s * 1.3) + ' ' + iF(p[1] - s * 2.2) + ' ' + iF(p[0] + s * 1.3) + ' ' + iF(p[1]) + 'Q' + iF(p[0]) + ' ' + iF(p[1] + s * 0.5) + ' ' + iF(p[0] - s * 1.3) + ' ' + iF(p[1]) + 'z', fill: 'url(#i4r-thatch)', stroke: '#6e5424', strokeWidth: 0.35 }));
    o.push(h('path', { key: 2, d: 'M' + iF(p[0] - s * 0.8) + ' ' + iF(p[1] - s * 0.9) + 'q' + iF(s * 0.8) + ' ' + iF(-s * 0.5) + ' ' + iF(s * 1.6) + ' 0M' + iF(p[0] - s * 1.1) + ' ' + iF(p[1] - s * 0.3) + 'q' + iF(s * 1.1) + ' ' + iF(-s * 0.5) + ' ' + iF(s * 2.2) + ' 0', stroke: '#8a6c30', strokeWidth: 0.35, fill: 'none', opacity: 0.7 }));
    return { el: h('g', { key: key }, o), depth: u + v };
  }
  function iCart(u, v, key, load) {
    var o = [];
    iBox(o, u, v, u + 2.8, v + 1.5, 0.8, 1.7, MAT.wood, { top: '#8a6040' });
    if (load) { var t = iP(u + 1.4, v + 0.75, 1.7); o.push(h('ellipse', { key: o.length, cx: iF(t[0]), cy: iF(t[1] - 0.8), rx: 3.4, ry: 1.9, fill: load, stroke: I4O, strokeWidth: 0.3 })); }
    [[u + 0.6, v + 1.5], [u + 2.2, v + 1.5]].forEach(function (w) { var c = iP(w[0], w[1], 0.75); o.push(h('ellipse', { key: o.length, cx: iF(c[0]), cy: iF(c[1]), rx: 1.6, ry: 2.4, transform: 'rotate(-30 ' + iF(c[0]) + ' ' + iF(c[1]) + ')', fill: '#6b4a30', stroke: I4O, strokeWidth: 0.35 })); o.push(h('circle', { key: o.length, cx: iF(c[0]), cy: iF(c[1]), r: 0.4, fill: '#3a2a1c' })); });
    iPathEl(o, iLn([u + 2.8, v + 0.75, 1.1], [u + 4.4, v + 0.75, 0.9]), '#5b3d27', 0.6);
    var hp = iP(u + 5.4, v + 0.75, 0);
    o.push(h('g', { key: o.length }, kAnimal(hp[0], hp[1], 'cow', 'hx', false)));
    return { el: h('g', { key: key }, o), depth: u + v + 5 };
  }
  function iBarrels(u, v, n, key) {
    var o = [];
    for (var i = 0; i < n; i++) { var p = iP(u + (i % 3) * 0.9, v + Math.floor(i / 3) * 0.9, 0); o.push(h('g', { key: i }, kBarrel(p[0] - 1.5, p[1], 'b'))); }
    return { el: h('g', { key: key }, o), depth: u + v + 2 };
  }
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
  /* ---------- MapViewport: nagyítható, húzható térképablak ---------- */
  function MapViewport(p) {
    var ref = React.useRef(null), drag = React.useRef(null), zoom = p.zoom || 1, max = p.max || 3, min = p.min || 1;
    var fx = p.focus ? p.focus[0] : 0.5, fy = p.focus ? p.focus[1] : 0.5;
    React.useEffect(function () {
      function go() { var el = ref.current; if (!el) return; el.scrollLeft = Math.max(0, fx * el.scrollWidth - el.clientWidth / 2); el.scrollTop = Math.max(0, fy * el.scrollHeight - el.clientHeight / 2); }
      go(); var r1 = requestAnimationFrame(go), t1 = setTimeout(go, 120);
      return function () { cancelAnimationFrame(r1); clearTimeout(t1); };
    }, [zoom, fx, fy]);
    function down(e) { if (e.pointerType !== 'mouse' || e.button !== 0) return; drag.current = { x: e.clientX, y: e.clientY, l: ref.current.scrollLeft, t: ref.current.scrollTop, moved: false }; }
    function move(e) { var d = drag.current; if (!d) return; var dx = e.clientX - d.x, dy = e.clientY - d.y; if (!d.moved && Math.abs(dx) + Math.abs(dy) > 5) d.moved = true; if (d.moved) { ref.current.scrollLeft = d.l - dx; ref.current.scrollTop = d.t - dy; } }
    function up() { var d = drag.current; drag.current = null; if (d && d.moved && ref.current) { ref.current.setAttribute('data-dragged', '1'); setTimeout(function () { if (ref.current) ref.current.removeAttribute('data-dragged'); }, 0); } }
    function step(z) { if (p.onZoom) p.onZoom(Math.max(min, Math.min(max, Math.round(z * 100) / 100))); }
    return h('div', { className: cx('tn-viewport', p.className), style: { aspectRatio: p.aspect || '360 / 260' } },
      h('div', { ref: ref, className: 'tn-viewport-scroll', onPointerDown: down, onPointerMove: move, onPointerUp: up, onPointerLeave: up,
        onClickCapture: function (e) { if (ref.current && ref.current.getAttribute('data-dragged')) { e.stopPropagation(); e.preventDefault(); } } },
        h('div', { className: 'tn-viewport-inner', style: { width: (zoom * 100) + '%' } }, p.children)),
      p.onZoom ? h('div', { className: 'tn-viewport-ctl' },
        h('button', { type: 'button', 'aria-label': 'Nagyítás', disabled: zoom >= max, onClick: function () { step(zoom + 0.6); } }, '+'),
        h('button', { type: 'button', 'aria-label': 'Kicsinyítés', disabled: zoom <= min, onClick: function () { step(zoom - 0.6); } }, '\u2212'),
        h('button', { type: 'button', 'aria-label': 'Teljes nézet', className: 'tn-viewport-fit', disabled: zoom <= min, onClick: function () { step(min); } }, h(Icon, { name: 'terkep', size: 15 }))) : null);
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
  var NAV_ART = { terkep: 'navTerkep', varos: 'navVaros', kem: 'navJel', pp: 'pp', legit: 'navRang', diplomacia: 'program' };
  function NavBar(p) {
    return h('nav', { className: 'tn-nav', 'aria-label': 'Fő navigáció' }, (p.items || []).map(function (it) {
      var on = it.id === p.active, art = it.art || NAV_ART[it.icon];
      return h('button', { key: it.id, className: cx('tn-nav-item', on && 'tn-on'), 'aria-current': on ? 'page' : undefined, onClick: p.onChange ? function () { p.onChange(it.id); } : undefined },
        h('span', { className: 'tn-nav-icon' }, art ? h(GameIcon, { name: art, size: 28 }) : h(Icon, { name: it.icon, size: 22 }), it.badge ? h('span', { className: 'tn-nav-badge' }, it.badge) : null), h('span', { className: 'tn-nav-label' }, it.label));
    }));
  }
  window.TronKronika4 = Object.assign(window.TronKronika4 || {}, {
    Icon: Icon, GameIcon: GameIcon, Button: Button, TextField: TextField, Select: Select, Tabs: Tabs, Toast: Toast, Sheet: Sheet, DataTable: DataTable,
    ResourceChip: ResourceChip, CommandPoints: CommandPoints, HouseCrest: HouseCrest, FactionTag: FactionTag, StabilityChip: StabilityChip,
    ControlBadge: ControlBadge, InfluenceBar: InfluenceBar, SuspicionMeter: SuspicionMeter, ReportCard: ReportCard, OrderSheet: OrderSheet,
    TickTimer: TickTimer, MapCanvas: MapCanvas, MapTerrain: MapTerrain, MapCompass: MapCompass, MapCartouche: MapCartouche, CityView: CityView, AppBar: AppBar, NavBar: NavBar, MapRoute: MapRoute, MapCity: MapCity, MapEstate: MapEstate, MapViewport: MapViewport
  });
})();
