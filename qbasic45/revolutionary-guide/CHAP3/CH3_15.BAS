REM Demonstration of the use of substrings with DRAW
REM \CHAP3\CH3_15.BAS

SCREEN 1
Triangle$ = "f90 l180 e100 f90 g10 h90"
DRAW "C2 X" + VARPTR$(Triangle$)
DRAW "bd30 p1,2"
f$ = INPUT$(1)

END