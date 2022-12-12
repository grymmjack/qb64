10 REM FRACTALS 1
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "FRACTALS"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    Fractals are the mathematicians dream, recurring shapes within each other isa crude way to put it, but this program will serve as an introduction."
120 RAND = 0
130 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
140 A$ = ""
150 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 150
160 RAND = RAND - VAL(RIGHT$(TIME$, 2))
170 RANDOMIZE RAND
180 DIM X%(16), Y%(16)
190 REM
200 CLS
210 LOCATE 1, 1: PRINT "JULIA PLOT : PRESS Q TO QUIT."
220 FOR A% = 1 TO 4: FOR B% = 1 TO 4
230 C% = 4 * A% + B% - 4
240 X%(C%) = B% - 3
250 Y%(C%) = A% - 3
260 NEXT B%, A%
270 X%(2) = 0: Y%(2) = -3
280 X%(8) = 2: Y%(8) = 0
290 X%(9) = -3: Y%(9) = -1
300 X%(15) = -1: Y%(15) = 2
310 FOR D% = 1 TO 16
320 FOR E% = 1 TO 16
330 FOR F% = 1 TO 16
340 FOR G% = 1 TO 16
350 IF INKEY$ = "Q" THEN GOTO 400
360 XX% = 64 * X%(D%) + 16 * X%(E%) + 4 * X%(F%) + X%(G%)
370 YY% = 64 * Y%(D%) + 16 * Y%(E%) + 4 * Y%(F%) + Y%(G%)
380 PSET (320 + XX%, 175 + (YY% * .8)), G%
390 NEXT G%, F%, E%, D%
400 REM ********* RETURN TO MENU POSER
410 CLS
420 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
430 LOCATE 3, 26: COLOR 7: PRINT "1"
440 LOCATE 4, 26: PRINT "2"
450 A$ = INKEY$: IF A$ = "" THEN GOTO 450
460 IF A$ = "1" THEN CLEAR : RUN
470 IF A$ = "2" THEN CLS : SYSTEM
480 GOTO 450

