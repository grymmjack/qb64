10 REM MAGIC NUMBER GAME
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "THE NUMBER GAME"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "   This is a simple game which demonstrates the flexibility of BASIC in adaptingto real life games or tricks. The idea is that you have to think of a number"
120 PRINT "between 1 and 20 and the computer will ask you a few questions to detemine your number. Please press a key between each prompt."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 COLOR 15: LOCATE 1, 33: PRINT "THE NUMBER GAME"
220 COLOR 7: LOCATE 2, 33: PRINT "---------------"
230 COLOR 10: LOCATE 5, 5: PRINT "Think of a number between 1 and 20 inclusive."
240 FOR PAUSE = 1 TO 2000: NEXT PAUSE
250 WHILE INKEY$ = "": WEND
260 LOCATE 7, 5: PRINT "Now double your number"
270 WHILE INKEY$ = "": WEND
280 RANDOMNUMBER = INT(RND * 20)
290 LOCATE 9, 5: PRINT "OK, Can you now add"; RANDOMNUMBER; "on."
300 WHILE INKEY$ = "": WEND
310 LOCATE 11, 5: PRINT "Now halve your new number."
320 WHILE INKEY$ = "": WEND
330 LOCATE 13, 5: PRINT "Now subtract your original number"
340 WHILE INKEY$ = "": WEND
350 COLOR 15: LOCATE 16, 5: PRINT "The number you thought of was :"; RANDOMNUMBER / 2
360 FOR A = 1 TO 3000: NEXT A
370 REM ********* RETURN TO MENU POSER
380 CLS
390 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
400 LOCATE 3, 26: COLOR 7: PRINT "1"
410 LOCATE 4, 26: PRINT "2"
430 A$ = INKEY$: IF A$ = "" THEN GOTO 430
440 IF A$ = "1" THEN CLEAR : RUN
460 IF A$ = "2" THEN CLS : SYSTEM
470 GOTO 430

