REM Create a dart board
REM \CHAP3\CH3_24.BAS

SCREEN 9, 0
COLOR 0, 1
FOR n = 1 to 15
    CIRCLE (320, 170), 15 * n, 3
NEXT n
FOR n = 1 to 15
    PAINT (310 + 15 * n, 170), n, 3
NEXT n
f$ = INPUT$(1)

END
