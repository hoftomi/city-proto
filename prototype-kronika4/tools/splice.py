import re
src='/home/claude/kronika/src/ds/index.js'
s=open(src).read()
parts=open('/home/claude/kronika/tools/kronika_parts.js').read()
chunks=re.split(r'^/\*@@(\w+)\*/\n', parts, flags=re.M)[1:]
chunks=dict(zip(chunks[0::2], chunks[1::2]))
def span(name):
    if name=='STAB_MARK':
        i=s.index('  var STAB_MARK'); j=s.index('\n',i)+1; return i,j
    i=s.index('  function %s(p) {'%name)
    m=re.compile(r'^  (function |var |const |/\*)', re.M)
    mm=m.search(s, i+5)
    return i, mm.start()
for name,code in chunks.items():
    i,j=span(name)
    s=s[:i]+code.rstrip('\n')+'\n'+s[j:]
# icons
icons=open('/home/claude/kronika/tools/mese_icons.js').read()
anchor='    /* Árucikkek */'
assert anchor in s
s=s.replace(anchor, '    /* Navigáció és idő */\n'+icons+anchor,1)
# stroke weights
s=s.replace("strokeWidth: a.sw || 1.1, strokeLinecap","strokeWidth: (a.sw || 1.1) * 1.05, strokeLinecap",1)
s=s.replace("stroke: 'currentColor', strokeWidth: 1.75,","stroke: 'currentColor', strokeWidth: 2,",1)
# namespace
s=s.replace('"namespace":"TronNelkul"','"namespace":"TronKronika"').replace('// Trón nélkül design system — ES module build of components/bundle.js','// Trón nélkül – Krónika design system — ES module build of components/bundle.js')
open(src,'w').write(s)
print('ok', list(chunks))
s=open(src).read()
a="      p.art ? h(GameIcon, { name: p.art, size: p.size === 'sm' ? 18 : 20 }) : p.icon ? h(Icon, { name: p.icon, size: p.size === 'sm' ? 16 : 18 }) : null, p.children);"
assert a in s
s=s.replace(a,"""      (function () { var art = p.art || (GAME[p.icon] ? p.icon : NAV_ART[p.icon]); var z = p.size === 'sm' ? 18 : p.variant === 'seal' ? 24 : 20;
        return art ? h(GameIcon, { name: art, size: z }) : p.icon ? h(Icon, { name: p.icon, size: p.size === 'sm' ? 16 : 18 }) : null; })(), p.children);""")
open(src,'w').write(s)
