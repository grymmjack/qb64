'$DYNAMIC
$Debug
_SCREENMOVE 1200,400

phrase$ = "foo bar baz"
DIM words(LEN(phrase$)) AS STRING
extract_words phrase$, words$()
dump_string_array words$(), "words"



SUB extract_words (s$, words$())
    DIM spaces(LEN(s$)) AS INTEGER
    find_chars s$, " ", spaces%()
    n = UBOUND(spaces)
    dump_integer_array spaces%(), "spaces"
    FOR i = 0 TO n
        IF i + 1 <= n THEN
            word$ = MID$(s$, spaces(i), spaces(i+1))
            words$(i) = word$
        ELSE
            word$ = MID$(s$, spaces(i))
            words$(i) = word$
        END IF
    NEXT i
    REDIM _PRESERVE words$(UBOUND(spaces))
END SUB



SUB find_chars (search$, char$, arrayFound%())
    length = LEN(search$) : found = -1 : x = 0 : i = 1
    DO
        found = INSTR(i, search$, char$)
        IF found > 0 THEN
            arrayFound%(x) = found
            i = found + 1
            x = x + 1
        ELSE
            i = i + 1
        END IF
    LOOP UNTIL i = length
    IF x > 0 THEN
        REDIM _PRESERVE arrayFound%(x)
    END IF
END SUB



SUB dump_string_array (arrayString$(), label$)
    n = UBOUND(arrayString$)
    PRINT : PRINT label$; "$("; _TRIM$(STR$(n)); ") {"
    FOR i = 0 TO n
        PRINT SPC(2); "("; _TRIM$(STR$(i)); "): "; 
        PRINT CHR$(34); arrayString$(i); CHR$(34)
    NEXT i
    PRINT "}" : PRINT
END SUB



SUB dump_integer_array (arrayInteger%(), label$)
    n = UBOUND(arrayInteger%)
    PRINT : PRINT label$; "%("; _TRIM$(STR$(n)); ") {"
    FOR i = 0 TO n
        PRINT SPC(2); "("; _TRIM$(STR$(i)); "):"; arrayInteger%(i)
    NEXT i
    PRINT "}" : PRINT
END SUB



SUB dump_single_array (arraySingle%(), label$)
    n = UBOUND(arraySingle%)
    PRINT : PRINT label$; "!("; _TRIM$(STR$(n)); ") {"
    FOR i = 0 TO n
        PRINT SPC(2); "("; _TRIM$(STR$(i)); "):"; arraySingle%(i)
    NEXT i
    PRINT "}" : PRINT
END SUB



SUB dump_long_array (arrayLong%(), label$)
    n = UBOUND(arrayLong%)
    PRINT : PRINT label$; "&("; _TRIM$(STR$(n)); ") {"
    FOR i = 0 TO n
        PRINT SPC(2); "("; _TRIM$(STR$(i)); "):"; arrayLong%(i)
    NEXT i
    PRINT "}" : PRINT
END SUB