'$DYNAMIC
'$INCLUDE:'../_LIB/DUMP.BI'

DIM phrase$ AS STRING
phrase$ = "foo bar baz"

DIM words(10) AS STRING
extract_words phrase$, words

PRINT words(0)

SUB extract_words(s$, words())
    FOR i = 0 TO LEN(s$)
        letter$ = MID$(s$, i, 1)
        PRINT CHR$(34); letter$; CHR$(34);
        IF letter$ = " " THEN
            PRINT " Found a space"
        END IF
    NEXT i
END SUB


'$INCLUDE:'../_LIB/DUMP.BM'