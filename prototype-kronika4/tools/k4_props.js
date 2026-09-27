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
