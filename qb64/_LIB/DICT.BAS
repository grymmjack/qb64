'$INCLUDE:'DUMP.BI'

TYPE Dict
    key AS STRING
    val AS STRING
END TYPE

DIM SHARED myDict(15) AS Dict
DIM keys$(5)
DIM vals$(5)

keys$(0) = "bilbo"
keys$(1) = "frodo"
keys$(2) = "bobo"
keys$(3) = "foodo"
keys$(4) = "barbo"
keys$(5) = "bazbo"
vals$(0) = "baggins"
vals$(1) = "baggins"
vals$(2) = "biggins"
vals$(3) = "boggins"
vals$(4) = "bebbins"
vals$(5) = "zobbins"

' dict_fill myDict()
dict_populate myDict(), keys$(), vals$()

PRINT dump_dict(myDict(), "myDict")

SUB dict_populate(dict() AS Dict, keys$(), vals$())
    uk = UBOUND(keys$) : uv = UBOUND(vals$)
    IF uk <> uv THEN EXIT SUB
    FOR i = 0 TO uk
        i$ = _TRIM$(STR$(i))
        dict(i).key = keys$(i)
        dict(i).val = vals$(i)
    NEXT i
END SUB


SUB dict_fill(dict() AS Dict)
    u = UBOUND(dict) : l = LBOUND(dict)
    FOR i = l TO u
        i$ = _TRIM$(STR$(i))
        dict(i).key = "key" + i$
        dict(i).val = i$
    NEXT i
END SUB

'$INCLUDE:'DUMP.BM'
