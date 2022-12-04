REM Clip a picture of a cube
REM \CHAP3\CH3_17.BAS

SCREEN 1, 0
VIEW SCREEN (120, 30)-(210, 110), , 3
DRAW "l60 u60 r60 d60 e20 u60 g20 e20 l60 g20"
f$ = INPUT$(1)
 
END