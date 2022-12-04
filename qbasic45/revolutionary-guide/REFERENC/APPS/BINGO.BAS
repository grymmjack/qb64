10 REM BINGO CALLER
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM U(100)
70 SCREEN 9: CLS
80 A$ = "BINGO CALLER"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "     This program replaces the manual task of number calling in a game of bingo,it exploits an array to store all the numbers that have previously been called."
130 PRINT "It is a very short program and has almost no use whatsoever (except to the many bingo halls which have an IBM-PC compatible computer and BASIC.)"
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 FOR A = 1 TO 99: U(A) = 0: NEXT A
220 COUNTER = 0
230 CLS
240 COLOR 10: LOCATE 2, 34: PRINT "BINGO CALLER"
250 WHILE COUNTER < 99
260 LOCATE 10, 2: COLOR 11: PRINT "Called :"; COUNTER + 1
270 X = INT(RND * 99) + 1                             ' CHOOSE NUMBER AT RANDOM
280 IF U(X) = 1 THEN GOTO 270     ' IF NUMBER HAS BEEN USED THEN CHOOSE ANOTHER
290 U(X) = 1: COUNTER = COUNTER + 1'SAY THAT THE NUMBER PICKED HAS NOW BEEN USED
300 IF X / 10 <> INT(X / 10) THEN LOCATE (X + 5) / 10 + 5, ((((X + 9) / 10) - FIX((X + 9) / 10) + 1) * 40) - 20 ELSE LOCATE (X + 5) / 10 + 4, ((((X + 9) / 10) - FIX((X + 9) / 10) + 1) * 40) - 20
310 ' THE ABOVE LINE CALCULATES WHERE THE NUMBER IS TO BE PLACED ON THE GRID
320 ' FOLLOW THAT IF YOU CAN.
330 COLOR ((X - 1) / 40) + 9: PRINT X
340 WHILE INKEY$ = "": WEND
350 WEND
360 WHILE INKEY$ = "": WEND
370 REM ********* RETURN TO MENU POSER
380 CLS
390 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
400 LOCATE 3, 26: COLOR 7: PRINT "1"
410 LOCATE 4, 26: PRINT "2"
420 A$ = INKEY$: IF A$ = "" THEN GOTO 420
430 IF A$ = "1" THEN CLEAR : RUN
440 IF A$ = "2" THEN CLS : SYSTEM
450 GOTO 420

