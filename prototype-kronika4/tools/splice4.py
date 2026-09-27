import re
base='/home/claude/kronika3/src/ds/index.js'; src='/home/claude/kronika4/src/ds/index.js'
s=open(base).read()
m=re.compile(r'^  (function |var |const |/\*)', re.M)
code=''.join(open('/home/claude/kronika4/tools/'+f).read() for f in ['k4_iso.js','k4_props.js','k4_city.js'])
i=s.index('  function CityView(p) {'); j=m.search(s,i+5).start()
s=s[:i]+code.rstrip('\n')+'\n'+s[j:]
parts=open('/home/claude/kronika4/tools/k4_map.js').read()
chunks=re.split(r'^/\*@@(\w+)\*/\n', parts, flags=re.M)[1:]
for name,cd in zip(chunks[0::2], chunks[1::2]):
    i=s.index('  function %s('%name); j=m.search(s,i+5).start()
    s=s[:i]+cd.rstrip('\n')+'\n'+s[j:]
a="      h(PaintDefs, null),\n      h('defs', null,"
assert a in s
s=s.replace(a,"      h(PaintDefs, null), h(I4Defs, null),\n      h('defs', null,",1)
a="      p.children,\n      h('rect', { width: w, height: hh, filter: 'url(#kg-grain)'"
assert a in s
s=s.replace(a,"      (function () { var gr = rng('mg' + seed), A = [], B = []; for (var q = 0; q < 1300; q++) { var x = gr() * w, y = gr() * hh, l = 0.6 + gr() * 0.9; (q % 2 ? A : B).push('M' + x.toFixed(1) + ' ' + y.toFixed(1) + 'l' + ((gr() - 0.5) * 0.6).toFixed(1) + ' -' + l.toFixed(1)); } return h('g', { 'aria-hidden': true }, h('path', { d: A.join(''), stroke: '#5f7d3a', strokeWidth: 0.3, opacity: 0.45 }), h('path', { d: B.join(''), stroke: '#d2e09a', strokeWidth: 0.3, opacity: 0.4 })); })(),\n"+a[len("      "):] if False else "      (function () { var gr = rng('mg' + seed), A = [], B = []; for (var q = 0; q < 1300; q++) { var x = gr() * w, y = gr() * hh, l = 0.6 + gr() * 0.9; (q % 2 ? A : B).push('M' + x.toFixed(1) + ' ' + y.toFixed(1) + 'l' + ((gr() - 0.5) * 0.6).toFixed(1) + ' -' + l.toFixed(1)); } return h('g', { 'aria-hidden': true }, h('path', { d: A.join(''), stroke: '#5f7d3a', strokeWidth: 0.3, opacity: 0.45 }), h('path', { d: B.join(''), stroke: '#d2e09a', strokeWidth: 0.3, opacity: 0.4 })); })(),\n"+a,1)
s=s.replace('"namespace":"TronKronika3"','"namespace":"TronKronika4"').replace('Krónika III design system','Krónika IV design system')
open(src,'w').write(s)
print('ok')
