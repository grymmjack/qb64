'$DYNAMIC
'$INCLUDE:'../_LIB/_GJ_LIB.BI'

SCREEN _NEWIMAGE(800, 600, 32)
_SCREENMOVE 1000, 400

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

'$INCLUDE:'../_LIB/_GJ_LIB.BM'