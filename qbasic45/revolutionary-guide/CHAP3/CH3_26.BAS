REM Demonstration of combinations of drawing statements
REM \CHAP3\CH3_26.BAS

SCREEN 1: CLS
LOCATE 1, 3
PRINT "Operators LINE, DRAW, CIRCLE and PAINT"
CIRCLE (160, 100), 60, 1, , , 5 / 6
PAINT (110, 100), CHR$(&HAA) + CHR$(&HAB), 1
LINE (140, 80)-(180, 120), 1, bf
DRAW "bm75,100 e85 f85 g85 h85"
f$ = INPUT$(1)

END
