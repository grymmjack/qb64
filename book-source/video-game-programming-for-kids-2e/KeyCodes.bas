PRINT "Key Decoder Program"
DO
    k$ = INKEY$
    IF k$ <> "" THEN
        code = ASC(k$)
        IF code = 0 THEN
            code = ASC(k$, 2)
            IF code = 72 THEN PRINT "Up";
        END IF
        PRINT k$; " = "; code
    END IF
LOOP UNTIL code = 27
SYSTEM

