import re
src='/home/claude/kronika3/src/ds/index.js'; base='/home/claude/kronika2/src/ds/index.js'
s=open(base).read()
m=re.compile(r'^  (function |var |const |/\*)', re.M)
parts=open('/home/claude/kronika3/tools/k3_city.js').read()
chunks=re.split(r'^/\*@@(\w+)\*/\n', parts, flags=re.M)[1:]
chunks=dict(zip(chunks[0::2], chunks[1::2]))
for name,code in chunks.items():
    i=s.index('  function %s(p) {'%name); j=m.search(s,i+5).start()
    s=s[:i]+code.rstrip('\n')+'\n'+s[j:]
s=s.replace('"namespace":"TronKronika2"','"namespace":"TronKronika3"').replace('Krónika II design system','Krónika III design system')
def rep(a,b,cnt=1):
    global s
    assert s.count(a)>=1, a[:80]
    s=s.replace(a,b,cnt)
# MapCanvas painterly
rep("""    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h('defs', null,""","""    var hr = rng('hs' + seed), shade = [];
    for (var si = 0; si < 40; si++) shade.push(h('ellipse', { key: si, cx: (hr() * w).toFixed(1), cy: (hr() * hh).toFixed(1), rx: (14 + hr() * 34).toFixed(1), ry: (8 + hr() * 18).toFixed(1), fill: si % 3 ? '#fff4cf' : '#2f4a22', opacity: si % 3 ? 0.22 : 0.2 }));
    return h('svg', { className: 'tn-map', viewBox: '0 0 ' + w + ' ' + hh, role: 'img', 'aria-label': p.title || 'Térkép' },
      h(PaintDefs, null),
      h('defs', null,""")
rep("""      h('g', { 'aria-hidden': true }, groundPatches(seed, w, hh, 170),""","""      h('g', { 'aria-hidden': true }, h('g', { filter: 'url(#kg-blur-lg)' }, groundPatches(seed, w, hh, 170), shade),""")
rep("""      p.children,
      h('rect', { width: w, height: hh, fill: 'url(#' + lid + ')', pointerEvents: 'none' }),""","""      p.children,
      h('rect', { width: w, height: hh, filter: 'url(#kg-grain)', opacity: 0.3, pointerEvents: 'none' }),
      h('rect', { width: w, height: hh, fill: 'url(#' + lid + ')', pointerEvents: 'none' }),""")
# Mountain
rep("""      h('ellipse', { cx: x + 2.5, cy: y + 1, rx: w + 3, ry: 2.8 * s, fill: '#2c1f13', opacity: 0.2 }),
      h('path', { d: sil, fill: 'var(--map-rock)' }),""","""      h('ellipse', { cx: x + 3, cy: y + 1, rx: w + 5, ry: 3.6 * s, fill: '#2c1f13', opacity: 0.3, filter: 'url(#kg-blur)' }),
      h('ellipse', { cx: x, cy: y - 1, rx: w * 1.25, ry: 4 * s, fill: '#8a9a5a', opacity: 0.5, filter: 'url(#kg-blur)' }),
      h('path', { d: sil, fill: 'var(--map-rock)' }),""")
rep("""      h('path', { d: snow, fill: 'var(--map-snow)' }),""","""      h('path', { d: sil, fill: 'url(#kg-fade)' }),
      h('path', { d: snow, fill: 'var(--map-snow)' }),""")
# Trees
rep("""fill: 'var(--map-pine)', stroke: 'var(--outline)', strokeWidth: sw, strokeLinejoin: 'round' }),""","""fill: 'url(#kg-pine)', stroke: 'var(--outline)', strokeWidth: sw, strokeLinejoin: 'round' }),""")
rep("""      h('circle', { cx: x, cy: y - r * 0.35, r: r * 0.8, fill: 'var(--map-forest)', stroke: 'var(--outline)', strokeWidth: sw }),""","""      h('circle', { cx: x, cy: y - r * 0.35, r: r * 0.8, fill: 'url(#kg-tree)', stroke: 'var(--outline)', strokeWidth: sw }),""")
rep("""      h('circle', { cx: x - r * 0.35, cy: y + r * 0.05, r: r * 0.5, fill: 'var(--map-forest)' }),""","""      h('circle', { cx: x - r * 0.35, cy: y + r * 0.05, r: r * 0.5, fill: 'url(#kg-tree)', opacity: 0.8 }),""")
rep("""fill: 'var(--map-forest-lo)', opacity: 0.35 }) : null,""","""fill: 'var(--map-forest-lo)', opacity: 0.4, filter: 'url(#kg-blur)' }) : null,""")
rep("""      o,
      h('rect', { x: p.x, y: p.y, width: p.cols * cw, height: p.rows * ch, fill: 'none', stroke: 'var(--map-forest-lo)', strokeWidth: 1.1, opacity: 0.9 }),
      h('path', { d: hedges.join(''), stroke: 'var(--map-forest-lo)', strokeWidth: 0.8, opacity: 0.85 }),""","""      h('rect', { x: p.x + 1, y: p.y + 1.5, width: p.cols * cw, height: p.rows * ch, fill: '#2c1f13', opacity: 0.22, filter: 'url(#kg-blur)' }),
      o,
      h('rect', { x: p.x, y: p.y, width: p.cols * cw, height: p.rows * ch, fill: 'url(#kg-fade)' }),
      h('rect', { x: p.x, y: p.y, width: p.cols * cw, height: p.rows * ch, fill: 'none', stroke: '#4d6a34', strokeWidth: 1.5, strokeDasharray: '0.1 1.7', strokeLinecap: 'round', opacity: 0.9 }),
      h('path', { d: hedges.join(''), stroke: '#557a3a', strokeWidth: 1.2, strokeDasharray: '0.1 1.5', strokeLinecap: 'round', opacity: 0.85 }),""")
rep("""strokeWidth: 0.45, fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round', opacity: 0.75 }),
        flowers(seed, w, hh, 90)),""","""strokeWidth: 0.45, fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round', opacity: 0.4 }),
        flowers(seed, w, hh, 90)),""")
open(src,'w').write(s)
print('ok')
