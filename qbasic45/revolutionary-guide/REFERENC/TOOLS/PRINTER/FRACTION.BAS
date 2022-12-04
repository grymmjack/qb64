10 REM FRACTIONS
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "FRACTIONS"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "   One problem with word processors and the like, is that they all have severe  problems with handling fractions. This can be overcome by using a simple BASIC"
120 PRINT "program."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 INPUT "Numerator   : ", A: C = A + 48
220 INPUT "Denominator : ", B: D = B + 48
230 LPRINT CHR$(27); "x"; CHR$(1); CHR$(27); "S"; CHR$(0);
240 LPRINT CHR$(C); CHR$(27); "T"; CHR$(8); CHR$(27); "S";
250 LPRINT CHR$(1); CHR$(D)
260 REM ********* RETURN TO MENU POSER
270 CLS
280 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
290 LOCATE 3, 26: COLOR 7: PRINT "1"
300 LOCATE 4, 26: PRINT "2"
310 A$ = INKEY$: IF A$ = "" THEN GOTO 310
320 IF A$ = "1" THEN CLEAR : RUN
330 IF A$ = "2" THEN CLS : SYSTEM
340 GOTO 310

