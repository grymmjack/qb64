10 REM PROJECTILES
20 REM Written by A.Sill
30 REM In GWBASIC
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "PROJECTILES"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "This program simulates the trajectories of projectiles according to the laws"
120 PRINT "of nature.   This branch of mathematics has faithfully been represented and     enables the user to fully redefine each factor involved in the path of the      projectile.   A combination of this program and the landscaping program has"
130 PRINT "produced an excellent game called Battle, check it out.   There are hundreds of other applications too, experiment and have fun."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 SCREEN 9: CLS
220 ANGLE = 3.14159 / 6
230 LOCATE 1, 1: COLOR 5: PRINT "PROJECTILES"
240 COLOR 14: LOCATE 1, 74: PRINT "-1 EXIT";
250 IF INPUTANGLE <> 0 THEN LOCATE 1, 20: COLOR 1: PRINT "Please re-type"
260 COLOR 1: PRINT "~~~~~~~~~~~"
270 COLOR 7: PRINT : INPUT "Enter Speed of particle (m/sec) : "; SPEED
280 IF SPEED < 0 THEN GOTO 390
290 GRAVITY = 9.8
300 INPUT "Enter gravity (9.8m/s2) : "; GRAVITY
310 INPUT "Enter angle (degrees) : "; INPUTANGLE
320 ANGLE = INPUTANGLE / 57.29577951#
330 WINDOW (0, 350)-(640, 0)
340 FOR X = 1 TO 640
350 Y = (X * TAN(ANGLE)) - ((.5 * GRAVITY * (X ^ 2)) / ((SPEED ^ 2) * (COS(ANGLE) ^ 2)))
360 LINE (X, Y)-(X, Y), 14
370 NEXT X
380 IF Y < 0 THEN GOTO 230
390 REM ********* RETURN TO MENU POSER
400 CLS
410 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
420 LOCATE 3, 26: COLOR 7: PRINT "1"
430 LOCATE 4, 26: PRINT "2"
440 A$ = INKEY$: IF A$ = "" THEN GOTO 440
450 IF A$ = "1" THEN CLEAR : RUN
460 IF A$ = "2" THEN CLS : SYSTEM
470 GOTO 440

