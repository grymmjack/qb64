start = TIMER
DO
    IF TIMER - start >= 1 THEN
        PRINT "Timer: "; TIMER
        start = TIMER
    END IF

LOOP UNTIL INKEY$ = CHR$(27)

