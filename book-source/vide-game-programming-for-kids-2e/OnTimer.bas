t = _FREETIMER
ON TIMER(t, 1) PrintDateTime
TIMER(t) ON
DO
    LOCATE 1, 1
    COLOR 10
    PRINT TIMER
LOOP UNTIL INKEY$ = CHR$(27)

SUB PrintDateTime
LOCATE 3, 1
COLOR 11
PRINT "Date: "; DATE$
PRINT "Time: "; TIME$
END SUB


