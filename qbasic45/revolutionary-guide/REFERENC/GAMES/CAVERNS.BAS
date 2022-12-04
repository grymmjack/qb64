10 REM GAME 4 : CAVERNS
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "CAVERNS"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    This simple arcade game is a challenging and very frustrating puzzler. You  must work your way through the caverns with just one control key."
120 PRINT "    You can change the speed of the game and the difficulty (this changes the   height of the caverns)."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 REM This is the front screen of the game
210 DIF = 7: SPEED = 300
220 CLS
230 X = 10: Y = 10: NO = 0: X1 = 2: Y1 = 2
240 LOCATE 2, 34: COLOR 10: PRINT "CAVERNS"
250 COLOR 12: LOCATE 5, 5: PRINT "To toggle between the up and down direction use the V key"
260 COLOR 12: LOCATE 22, 34: PRINT "Press P to play"
270 COLOR 14: LOCATE 20, 15: PRINT "Use the ARROW keys to change the difficulty level"
280 LOCATE 19, 14: PRINT "Use the keys Q and O to change the speed of the game"
290 LOCATE 10, 18: PRINT "Difficulty level (1 Tough or 9 Easy) is "; DIF
300 LOCATE 9, 14: PRINT "Speed of game (1 Ultra Fast or 500 Very Slow) is "; SPEED
310 A$ = INKEY$: IF A$ = "" THEN GOTO 310
320 IF A$ = CHR$(0) + "H" AND DIF > 1 THEN DIF = DIF - 1: GOTO 290
330 IF A$ = CHR$(0) + "P" AND DIF < 9 THEN DIF = DIF + 1: GOTO 290
340 IF A$ = "Q" AND SPEED > 1 THEN SPEED = SPEED - 1: GOTO 300
350 IF A$ = "O" AND SPEED < 500 THEN SPEED = SPEED + 1: GOTO 300
360 IF A$ = "P" OR A$ = "p" THEN GOTO 380
370 GOTO 310
380 REM Create the playing screen depending on the difficulty level
390 CLS
400 LINE (1, 1)-(639, 349), 12, B
410 FOR X = 20 TO 620 STEP 6
420 H = 20 * DIF: LE = (350 - H) / 2
430 L = (LE / 2) + (INT(RND * (LE)))
440 LINE (X, 0)-(X, L), 4
450 LINE (X, L)-(X, H + L), 0
460 LINE (X, H + L)-(X, 349), 4
470 NEXT X
480 PSET (10, Y), 15
490 REM This is the game section of the program
500 WHILE INKEY$ = "": WEND
510 ST = 0: OX = X: OY = Y: X = 10
520 PSET (X, Y), 15
530 WHILE X < 635
540 PSET (X, Y), 15
550 PSET (OX, OY), 0
560 OX = X: OY = Y
570 X = X + X1: Y = Y + Y1
580 IF NTY > 0 THEN NTY = NTY - 1: GOTO 600
590 IF INKEY$ = "V" THEN Y1 = -Y1: NTY = 2
600 IF NTX > 0 THEN NTX = NTX - 1: GOTO 610
610 IF POINT(X + X1, Y) <> 0 THEN X1 = -X1
620 IF POINT(X, Y + Y1) <> 0 THEN Y1 = -Y1
630 FOR PAUSE = 1 TO SPEED: NEXT PAUSE
640 ST = ST + 1
650 WEND
660 COLOR 2: LOCATE 5, 26: PRINT "You have escaped THE caverns"
670 COLOR 11: LOCATE 8, 30: PRINT "You took "; INT(ST / 14); " seconds"
680 COLOR 9: LOCATE 22, 33: PRINT "Press any key"
690 WHILE INKEY$ = "": WEND
700 REM ********* RETURN TO MENU POSER
710 CLS
720 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
730 LOCATE 3, 26: COLOR 7: PRINT "1"
740 LOCATE 4, 26: PRINT "2"
750 A$ = INKEY$: IF A$ = "" THEN GOTO 750
760 IF A$ = "1" THEN CLEAR : RUN
770 IF A$ = "2" THEN CLS : SYSTEM
780 GOTO 750

