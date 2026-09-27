import re
src='/home/claude/kronika2/src/ds/index.js'
s=open(src).read()
m=re.compile(r'^  (function |var |const |/\*)', re.M)
def remove_fn(name):
    global s
    key='  function %s('%name
    i=s.index(key); j=m.search(s,i+5).start(); s=s[:i]+s[j:]
for n in ['tufts','Tree','House','Stall','Crate','Barrel','Cart']: remove_fn(n)
i=s.index('  var ROOFS'); j=s.index('\n',i)+1; s=s[:i]+s[j:]
parts=open('/home/claude/kronika2/tools/k2_parts.js').read()
chunks=re.split(r'^/\*@@(\w+)\*/\n', parts, flags=re.M)[1:]
chunks=dict(zip(chunks[0::2], chunks[1::2]))
for name,code in chunks.items():
    i=s.index('  function %s(p) {'%name); j=m.search(s,i+5).start()
    s=s[:i]+code.rstrip('\n')+'\n'+s[j:]
s=s.replace('"namespace":"TronKronika"','"namespace":"TronKronika2"').replace('Krónika design system','Krónika II design system')
open(src,'w').write(s)
print('ok')
