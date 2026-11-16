# ATO_FlightPlan — outils de vérification / extraction (Python 3 + `pip install lupa luaparser`)

Utilisés pendant la réorganisation. Un assistant peut les recréer à partir de ce fichier.
Chaîne type : `extract_range.py` (extraire des lignes en fonction) puis `verify_step.py` + `verify_body.py` (prouver que rien n'a changé), `finalize_aliases.py` (ajouter les alias `local X = AtoFP.X` en fin de série).

## lua_free.py
Analyse statique : noms libres (globaux) lus / écrits par un fichier Lua. Usage : `lua_free.py fichier...`

```python
# Analyse statique : noms globaux (libres) lus / écrits par un fichier Lua. Usage: lua_free.py fichier...
import sys
from luaparser import ast, astnodes as N
def stmts(b):
    while isinstance(b,N.Block): b=b.body
    return b if isinstance(b,list) else [b]
def analyse(src):
    tree=ast.parse(src)
    reads={}; writes={}
    scopes=[set()]
    def declared(n): return any(n in s for s in scopes)
    def line(nd):
        return getattr(nd,'line',None) or 0
    def read(n,nd): 
        if not declared(n): reads.setdefault(n,[]).append(line(nd))
    def write(n,nd):
        if not declared(n): writes.setdefault(n,[]).append(line(nd))
    def block(b,new=True):
        if new: scopes.append(set())
        for s in stmts(b): stmt(s)
        if new: scopes.pop()
    def expr(e):
        if e is None: return
        if isinstance(e,list):
            for x in e: expr(x)
            return
        if isinstance(e,N.Name): read(e.id,e); return
        if isinstance(e,N.Index):
            expr(e.value)
            if e.notation!=N.IndexNotation.DOT: expr(e.idx)
            return
        if isinstance(e,N.Field):
            if e.key is not None and not (isinstance(e.key,N.Name) and not e.between_brackets): expr(e.key)
            expr(e.value); return
        if isinstance(e,N.Invoke):
            expr(e.source); expr(e.args); return
        if isinstance(e,(N.AnonymousFunction,)):
            func(e.args,e.body); return
        if isinstance(e,N.Block): block(e); return
        if isinstance(e,N.Node):
            for k,v in e.__dict__.items():
                if k.startswith('_') or k in('line','first_token','last_token','comments'): continue
                if isinstance(v,(N.Node,list)): expr(v)
    def func(args,body):
        scopes.append(set(a.id for a in args if isinstance(a,N.Name)))
        for a in args:
            pass
        for s in stmts(body): stmt(s)
        scopes.pop()
    def target(t):
        if isinstance(t,N.Name): write(t.id,t)
        else: expr(t)
    def stmt(s):
        if isinstance(s,N.LocalAssign):
            expr(s.values)
            for t in s.targets: scopes[-1].add(t.id)
        elif isinstance(s,N.Assign):
            expr(s.values)
            for t in s.targets: target(t)
        elif isinstance(s,N.LocalFunction):
            scopes[-1].add(s.name.id); func(s.args,s.body)
        elif isinstance(s,N.Function):
            if isinstance(s.name,N.Name): write(s.name.id,s.name)
            else: expr(s.name)
            func(s.args,s.body)
        elif isinstance(s,N.Method):
            expr(s.source); func([N.Name('self')]+list(s.args),s.body)
        elif isinstance(s,N.Fornum):
            expr([s.start,s.stop,s.step]); scopes.append({s.target.id}); block(s.body,False); scopes.pop()
        elif isinstance(s,N.Forin):
            expr(s.iter); scopes.append({t.id for t in s.targets}); block(s.body,False); scopes.pop()
        elif isinstance(s,N.While): expr(s.test); block(s.body)
        elif isinstance(s,N.Repeat): scopes.append(set()); block(s.body,False); expr(s.test); scopes.pop()
        elif isinstance(s,N.If):
            expr(s.test); block(s.body)
            o=s.orelse
            if isinstance(o,N.If): stmt(o)
            elif o is not None: block(o)
        elif isinstance(s,N.Do): block(s.body)
        elif isinstance(s,N.Block): block(s)
        else: expr(s)
    block(tree.body,False)
    return reads,writes
if __name__=='__main__':
    for f in sys.argv[1:]:
        r,w=analyse(open(f,encoding='utf-8').read())
        print(f,len(r),'lus',len(w),'écrits')
```

## extract_range.py
Extrait les lignes N..M de ATO_FlightPlan.lua en fonction dans ATO_FP_60_Loop.lua, déduit paramètres / valeurs rendues. Usage : `extract_range.py DOSSIER DEBUT FIN NomFonction "description" [NB_TABS=5]` (variable d'env PREFIX pour le repère de phase). Travailler de bas en haut.

```python
# Extrait une phase de la boucle (entre deux repères AtoFP.phase = "X") de ATO_FlightPlan.lua vers ATO_FP_60_Loop.lua.
# Usage: extract_range.py DOSSIER LIGNE_DEBUT LIGNE_FIN NOM_FONCTION "description" [NB_TABULATIONS=5]
import sys,re,os
sys.path.insert(0,os.path.dirname(__file__))
from lua_free import analyse
from luaparser import ast, astnodes as N
from lupa.lua51 import LuaRuntime
D,S0,E0,FN,DESC=sys.argv[1:6]
NT=int(sys.argv[6]) if len(sys.argv)>6 else 5
MP=D+'/ATO_FlightPlan.lua'; LP=D+'/ATO_FlightPlan/ATO_FP_60_Loop.lua'; CP=D+'/ATO_FlightPlan/ATO_FP_Check.lua'
rd=lambda p: open(p,'rb').read().decode('utf-8',errors='surrogateescape')
M=rd(MP).split('\r\n'); LPT=rd(LP).split('\r\n')
TI='\t'*NT
shift=0   # les alias sont écrits à part (_aliases.txt) pour ne pas décaler les lignes
start=int(S0)+shift; end=int(E0)+shift
while end>=start and (not M[end-1].strip() or M[end-1].strip().startswith('--')): end-=1
snip=M[start-1:end]
ded=[]
for l in snip:
    if l.startswith(TI): ded.append(l[NT:])
    else: ded.append(l)   # ligne vide, ou indentée autrement (espaces) : gardée telle quelle
code='\r\n'.join(ded)
lua=LuaRuntime(); chk=lua.eval('function(s) local f,e=loadstring(s) return e end')
err=chk('local function x()\n'+code.replace('\r\n','\n')+'\nend')
assert not err, 'syntaxe: '+str(err)
assert not re.search(r'(?m)^return\b',code), 'return au niveau haut'
R,W=analyse(code)
# locals déclarés au niveau haut du snippet
tree=ast.parse(code); top=[]
def stm(x):
    while isinstance(x,N.Block): x=x.body
    return x if isinstance(x,list) else [x]
for s in stm(tree.body):
    if isinstance(s,N.LocalAssign): top+= [t.id for t in s.targets]
    if isinstance(s,N.LocalFunction): top.append(s.name.id)
# locals visibles dans main avant le snippet (sur-approximation sûre)
pre='\n'.join(M[:start-1])
locs=set()
for mm in re.finditer(r'\blocal\s+(?:function\s+)?([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)*)',pre):
    for n in mm.group(1).split(','): locs.add(n.strip())
for mm in re.finditer(r'\bfor\s+([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)*)\s*(?:=|in)',pre):
    for n in mm.group(1).split(','): locs.add(n.strip())
free=set(R)|set(W)
cand=sorted(n for n in free if n in locs)
# alias possibles : main 'local X = AtoFP.X' avant l'Include du Loop et X jamais réassigné
inc=[i for i,l in enumerate(M) if '60_Loop.lua' in l and 'Include' in l][0]
alias=set()
for i in range(inc):
    mm=re.match(r'local (\w+) = AtoFP\.(\w+)\s*(--.*)?$',M[i])
    if mm and mm.group(1)==mm.group(2): alias.add(mm.group(1))
fulltxt='\n'.join(M)
header=[l for l in LPT[:80] if re.match(r'local (\w+) = AtoFP\.\1\s*$',l)]
hdrnames={re.match(r'local (\w+)',l).group(1) for l in header}
use_alias=[];params=[]
for n in cand:
    reassigned=re.search(r'(?m)^\s*'+n+r'\s*=[^=]',fulltxt) is not None
    if n in W: params.append(n); continue
    if (n in alias or n in hdrnames) and not reassigned: use_alias.append(n)
    else: params.append(n)
prio=['flight','f','p','role','sideName']
params=[x for x in prio if x in params]+[x for x in params if x not in prio]
after='\n'.join(M[end:])
newlocals=[n for n in dict.fromkeys(top) if re.search(r'\b'+n+r'\b',after)]
written=[n for n in params if n in W]
rets=list(dict.fromkeys(newlocals+written))
# danger : une fonction définie ailleurs dans main qui lit/écrit une variable que l'on passe par valeur
snip_lines=(start,end)
mt=ast.parse('\n'.join(M))
bad=[]
for nd in ast.walk(mt):
    if isinstance(nd,(N.Function,N.LocalFunction,N.AnonymousFunction)):
        try: l1=nd.first_token.line; l2=nd.last_token.line
        except Exception: continue
        if l1>=snip_lines[0] and l2<=snip_lines[1]: continue
        if l1<=snip_lines[0] and l2>=snip_lines[1]: continue   # fonction englobante (Guard)
        src='\n'.join(M[l1-1:l2])
        for n in params:
            if re.search(r'(?<![\w.])'+n+r'\s*=[^=]',src) or (n in written and re.search(r'(?<![\w.])'+n+r'\b',src)):
                bad.append((n,l1))
if bad: print('ATTENTION fonctions de main qui touchent une variable passée par valeur:',bad)
inner=[]
for nd in ast.walk(tree):
    if isinstance(nd,(N.Function,N.LocalFunction,N.AnonymousFunction)):
        try: l1=nd.first_token.line; l2=nd.last_token.line
        except Exception: continue
        src='\n'.join(code.split('\r\n')[l1-1:l2])
        for n in rets:
            if re.search(r'(?<![\w.])'+n+r'\b',src): inner.append((n,l1))
if inner: print('ATTENTION fonctions internes qui utilisent une valeur rendue:',inner)
print('params:',params); print('alias:',use_alias); print('rend:',rets,'(nouveaux:',newlocals,'modifiés:',written,')')
# fonction
fn=['','--= = = = = = = =  = = = = = = = = = =  = = = = = = = = = =  ==  = = =','-- '+DESC,
    '-- Code d\'origine inchangé (décalé de 4 tabulations vers la gauche). Les paramètres sont les variables de la boucle / du vol utilisées.']
if rets: fn.append('-- Rend : '+', '.join(rets))
fn.append('local function %s(%s)'%(FN,', '.join(params)))
fn+=ded
if rets: fn.append('return '+', '.join(rets))
fn+=['end','']
# insertion dans Loop
j=[k for k,l in enumerate(LPT) if l.startswith('AtoFP.FlightTriggersAndDebug =')][0]
LPT[j:j]=fn
j=[k for k,l in enumerate(LPT) if l.startswith('AtoFP.FlightTriggersAndDebug =')][0]
LPT.insert(j+1,'AtoFP.%s = %s'%(FN,FN))
for n in use_alias:
    if n not in hdrnames:
        k=[k for k,l in enumerate(LPT) if l.startswith('local debugStart = AtoFP.debugStart')][0]
        LPT.insert(k+1,'local %s = AtoFP.%s'%(n,n)); hdrnames.add(n)
k=[k for k,l in enumerate(LPT) if 'FlightSarAlert / FlightInterceptAwacs' in l][0]
LPT.insert(k+1,'--   %s = %s'%(FN,DESC.split(' : ',1)[-1][:90] if ' : ' in DESC else DESC))
open(LP,'wb').write('\r\n'.join(LPT).encode('utf-8',errors='surrogateescape'))
# main : appel
call='%s(%s)'%(FN,', '.join(params))
T4=TI
if not rets: stmt=[T4+call]
else:
    ex=[n for n in rets if n not in newlocals]; nw=[n for n in rets if n in newlocals]
    if not ex: stmt=[T4+'local %s = %s'%(', '.join(nw),call)]
    elif not nw: stmt=[T4+'%s = %s'%(', '.join(ex),call)]
    else: stmt=[T4+'local '+', '.join(nw), T4+'%s = %s'%(', '.join(rets),call)]
M[start-1:end]=[TI+'AtoFP.phase = "'+os.environ.get('PREFIX','B:')+FN+'"']+stmt
txt='\r\n'.join(M)
anchor='local FlightRecovery = AtoFP.FlightRecovery'
lastalias=[l for l in M if re.match(r'local (Flight|Wp)\w+ = AtoFP\.',l)][-1]
open(D+'/_aliases.txt','a').write('local %s = AtoFP.%s\n'%(FN,FN))
open(MP,'wb').write(txt.encode('utf-8',errors='surrogateescape'))
c=rd(CP); c=c.replace('{ "function", "FlightInsertInMission" },','{ "function", "FlightInsertInMission" }, { "function", "%s" },'%FN,1)
open(CP,'wb').write(c.encode('utf-8',errors='surrogateescape'))
open(D+'/_last_extract.txt','w').write('%s %d %d\n'%(FN,start,end))
```

## verify_step.py
Compare deux arborescences : syntaxe, noms libres nouveaux / disparus. Usage : `verify_step.py AVANT APRES`

```python
# Usage: verify_step.py AVANT APRES  (dossiers contenant ATO_FlightPlan.lua et ATO_FlightPlan/)
import sys,glob,os,re
sys.path.insert(0,os.path.dirname(__file__))
from lua_free import analyse
from lupa.lua51 import LuaRuntime
A,B=sys.argv[1:3]
chk=LuaRuntime().eval('function(s,n) local f,e=loadstring(s,n) return e end')
rd=lambda p: open(p,'rb').read().decode('utf-8',errors='replace')
files=lambda d:[d+'/ATO_FlightPlan.lua']+sorted(glob.glob(d+'/ATO_FlightPlan/ATO_FP_*.lua'))
ok=True
for f in files(B):
    e=chk(rd(f),f)
    if e: print('SYNTAXE',f,e); ok=False
def union(d):
    R={};W={}
    for f in files(d):
        if 'Check' in f: continue
        r,w=analyse(rd(f))
        for k in r: R.setdefault(k,set()).add(os.path.basename(f))
        for k in w: W.setdefault(k,set()).add(os.path.basename(f))
    return R,W
R0,W0=union(A);R1,W1=union(B)
nr=sorted(k for k in R1 if k not in R0 and not k.startswith(('Wp','Prep'))); gone=sorted(k for k in R0 if k not in R1); wd=sorted(set(W1)^set(W0))
print('nouvelles lectures libres:',nr,'| disparues:',gone,'| écritures libres diff:',wd)
if nr or wd: ok=False
main=rd(B+'/ATO_FlightPlan.lua'); locs=set()
for m in re.finditer(r'\blocal\s+(?:function\s+)?([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)*)',main):
    for n in m.group(1).split(','): locs.add(n.strip())
for m in re.finditer(r'\bfor\s+([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)*)\s*(?:=|in)',main):
    for n in m.group(1).split(','): locs.add(n.strip())
for f in files(B)[1:]:
    if 'Check' in f or 'Final' in f or 'Identity' in f or 'Spawn' in f or 'Tasks' in f: continue
    r,w=analyse(rd(f)); bad=sorted(set(r)&locs)
    print(os.path.basename(f),'libres qui sont aussi des locals de main (à examiner):',bad)
# ignore whitespace-only diffs: reconstitue l'original = main_apres avec appels remplacés ? (fait séparément)
print('OK' if ok else 'PROBLEME')
```

## verify_body.py
Vérifie qu'un corps extrait est identique à l'original. Usage : `verify_body.py AVANT APRES NomFonction DEBUT FIN NB_TABS`

```python
import sys,re
A,B,FN,start,end=sys.argv[1],sys.argv[2],sys.argv[3],int(sys.argv[4]),int(sys.argv[5]); NT=int(sys.argv[6]) if len(sys.argv)>6 else 4
rd=lambda p: open(p,'rb').read().decode('utf-8',errors='surrogateescape').split('\r\n')
o=rd(A+'/ATO_FlightPlan.lua')[start-1:end]; n=rd(B+'/ATO_FlightPlan/ATO_FP_60_Loop.lua')
i=[k for k,l in enumerate(n) if l.startswith('local function '+FN+'(')][0]
body=n[i+1:i+1+len(o)]
re_=['\t'*NT+l if l.strip() else l for l in body]
print(FN,'corps identique:',all(p.strip()==q.strip() for p,q in zip(o,re_)) and len(o)==len(body),len(o),len(body))
```

## finalize_aliases.py
Insère dans ATO_FlightPlan.lua les alias en attente (_aliases.txt). Usage : `finalize_aliases.py DOSSIER`

```python
import sys,re
D=sys.argv[1]
rd=lambda p: open(p,'rb').read().decode('utf-8',errors='surrogateescape')
M=rd(D+'/ATO_FlightPlan.lua').split('\r\n')
al=[l for l in open(D+'/_aliases.txt').read().split('\n') if l][::-1]   # ordre d'extraction inverse = ordre du fichier
i=max(k for k,l in enumerate(M) if re.match(r'local Flight\w+ = AtoFP\.',l))
M[i+1:i+1]=al
open(D+'/ATO_FlightPlan.lua','wb').write('\r\n'.join(M).encode('utf-8',errors='surrogateescape'))
print(len(al),'alias ajoutés après la ligne',i+1)
```

