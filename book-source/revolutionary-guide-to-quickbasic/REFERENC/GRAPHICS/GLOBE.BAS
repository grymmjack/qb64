10 REM 3D WORLD
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "3D WORLD"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    Sine and Cosine rules are the pits. Or are they ? This program shows you howuseful they actually can be. They are the ONLY way to draw circles and curves."
120 PRINT "    This program draws repeated arcs and ellipses in an orderly fashion to make a 3D world."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 PRINT "The Globe : Press Q to quit."
220 PSET (320, 200), 0
230 FOR A = 1 TO 360
240 FOR B = 1 TO 19 STEP 2
250 IF INKEY$ = "Q" THEN GOTO 310
260 PSET (320 + (250 - 10 * B) * COS(A), 175 + 170 * SIN(A))
270 NEXT B
280 FOR C = 1 TO 19 STEP 2
290 PSET (320 + 250 * COS(A), 175 + (170 - 10 * C) * SIN(A))
300 NEXT C, A
305 WHILE INKEY$ = "": WEND
310 REM ********* RETURN TO MENU POSER
320 CLS
330 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
340 LOCATE 3, 26: COLOR 7: PRINT "1"
350 LOCATE 4, 26: PRINT "2"
360 A$ = INKEY$: IF A$ = "" THEN GOTO 360
370 IF A$ = "1" THEN CLEAR : RUN
380 IF A$ = "2" THEN CLS : SYSTEM
390 GOTO 360

