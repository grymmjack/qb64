REM Demonstration of the DRAW statement
REM \CHAP3\CH3_14.BAS

SCREEN 1, 0
PRINT "Draw various size cubes"
INPUT "Scale (1-255) "; scale
DRAW "S" + STR$(scale)
DRAW "bm +0,2 l3 u3 r3 d3 e1 u3 g1 e1 l3 g1"
 
END