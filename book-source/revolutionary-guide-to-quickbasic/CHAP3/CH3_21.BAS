REM Demonstration of 2 linear diagrams in different windows
REM \CHAP3\CH3_21.BAS

Declare SUB LineChart ()
'DRAW a line chart and then the same line
'chart scaled by VIEW
SCREEN 2
WINDOW (-.5, -4)-(7.5, 16)
CALL LineChart   'LINE graph drawn first time
VIEW (130, 117)-(550, 180), , 1
CALL LineChart   'LINE graph drawn again in new viewport
DATA 0, 13, 9, 4, 6, 13
f$ = INPUT$(1)

SUB LineChart
  CLS
  RESTORE
  LINE (0, 0)-(7, 0)    'x-axis
  LINE (0, 14)-(0, 0)   'y-axis
  READ a
  PSET (1, a)
  FOR m = 2 TO 6
      READ a
      LINE -(m, a)
  NEXT m
END SUB
