'$INCLUDE:'_GJ_LIB.BI'
'$DYNAMIC

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

phrase$ = ""
phrase$ = "foo"
phrase$ = "foo bar"
phrase$ = "foo bar baz"
phrase$ = "foo bar baz bop bobo bilbo frodo"

DIM SHARED words$(LEN(phrase$))
str_explode phrase$, " ", words$(), wordCount%
IF wordCount% > 0 THEN
    REDIM _PRESERVE words$(wordCount%)
ELSE
    REDIM _PRESERVE words$(0)
END IF
PRINT dump_string_array$(words$(), "words")

phrase2$ = str_implode$(words$(), "::")
PRINT dump_string$(phrase2$, "phrase2")

'$INCLUDE:'_GJ_LIB.BM'