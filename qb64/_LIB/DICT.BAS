'$INCLUDE:'DUMP.BI'
'$DYNAMIC
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 32)
_FULLSCREEN _SQUAREPIXELS

TYPE Dict
    key AS STRING
    val AS STRING
END TYPE

DIM SHARED myDict(5) AS Dict
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

index% = dict_get_index_by_key(myDict(), "barbo")
index$ = _TRIM$(STR$(index%))
PRINT "index = " + index$
key$ = dict_get_key_by_index(myDict(), index%)
PRINT "key = " + key$
val$ = dict_get_val_by_index(myDict(), index%) 
PRINT "val (from index) = " + val$
PRINT "val (from key) = " + dict_get_val_by_key(myDict(), key$)

DIM SHARED keys2$(5)
DIM SHARED vals2$(5)

dict_get_keys myDict(), keys2$()
dict_get_vals myDict(), vals2$()

PRINT dump_string_array(keys2$(), "keys from dict_get_keys")
PRINT dump_string_array(vals2$(), "vals from dict_get_vals")

dict_swap_keys_for_vals myDict()
PRINT dump_dict(myDict(), "myDict swapped")


SUB dict_populate (dict() AS Dict, keys$(), vals$())
    uk = UBOUND(keys$) : uv = UBOUND(vals$)
    IF uk <> uv THEN EXIT SUB
    FOR i = 0 TO uk
        i$ = _TRIM$(STR$(i))
        dict(i).key = keys$(i)
        dict(i).val = vals$(i)
    NEXT i
END SUB


SUB dict_fill (dict() AS Dict)
    u = UBOUND(dict) : l = LBOUND(dict)
    FOR i = l TO u
        i$ = _TRIM$(STR$(i))
        dict(i).key = "key" + i$
        dict(i).val = i$
    NEXT i
END SUB


FUNCTION dict_get_index_by_key% (dict() AS Dict, key$)
    u = UBOUND(dict) : l = LBOUND(dict)
    FOR i = l TO u
        IF dict(i).key = key$ THEN
            dict_get_index_by_key% = i
            EXIT FUNCTION
        END IF
    NEXT i
END FUNCTION


FUNCTION dict_get_key_by_index$ (dict() AS Dict, index%)
    u = UBOUND(dict) : l = LBOUND(dict)
    IF index% >= l AND index% <= u THEN
        dict_get_key_by_index$ = dict(index%).key
    END IF
END FUNCTION


FUNCTION dict_get_val_by_index$ (dict() AS Dict, index%)
    u = UBOUND(dict) : l = LBOUND(dict)
    IF index% >= l AND index% <= u THEN
        dict_get_val_by_index$ = dict(index%).val
    END IF
END FUNCTION


FUNCTION dict_get_val_by_key$ (dict() AS Dict, key$)
    u = UBOUND(dict) : l = LBOUND(dict)
    FOR i = l TO u
        IF dict(i).key = key$ THEN
            dict_get_val_by_key$ = dict(i).val
            EXIT FUNCTION
        END IF
    NEXT i
END FUNCTION


SUB dict_get_keys (dict() AS Dict, keys$())
    u = UBOUND(dict) : l = LBOUND(dict) : c = u - l
    REDIM keys$(c)
    FOR i = l TO u
        keys$(i) = dict(i).key
    NEXT i
END SUB


SUB dict_get_vals (dict() AS Dict, vals$())
    u = UBOUND(dict) : l = LBOUND(dict) : c = u - l
    REDIM vals$(c)
    FOR i = l TO u
        vals$(i) = dict(i).val
    NEXT i
END SUB


SUB dict_swap_keys_for_vals (dict() AS Dict)
    u = UBOUND(dict) : l = LBOUND(dict) : c = u - l
    DIM res(c) AS Dict
    FOR i = l TO u
        res(i).key = dict(i).val
        res(i).val = dict(i).key
        SWAP dict(i).key, res(i).key
        SWAP dict(i).val, res(i).val
    NEXT i
END SUB


'$INCLUDE:'DUMP.BM'
