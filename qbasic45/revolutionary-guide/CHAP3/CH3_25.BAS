REM Demonstration of pattern filling
REM \CHAP3\CH3_25.BAS

SCREEN 2, 0
PRINT "Producing a circle filled with N's"
CIRCLE (140, 75), 130
t$ = CHR$(0) + CHR$(198) + CHR$(230) + CHR$(246)
t$ = t$ + CHR$(222) + CHR$(206) + CHR$(198)
t$ = t$ + CHR$(198) + CHR$(0)
PAINT (140, 75), t$
f$ = INPUT$(1)

END 
