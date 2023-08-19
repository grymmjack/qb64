DIM m AS _MEM
DIM n AS _MEM

m = _MEMNEW(10)
n = _MEMNEW(100)

_MEMPUT m, m.OFFSET, "1234567890"

s$ = SPACE$(10) 'to load into a variable length string set its length first
_MEMGET m, m.OFFSET, s$
PRINT "in:[" + s$ + "]"

_MEMCOPY m, m.OFFSET, m.SIZE TO n, n.OFFSET 'put m into n

b$ = SPACE$(10)
_MEMGET n, n.OFFSET, b$
PRINT "out:[" + b$ + "]"
_MEMFREE m: _MEMFREE n 'always clear the memory when done
