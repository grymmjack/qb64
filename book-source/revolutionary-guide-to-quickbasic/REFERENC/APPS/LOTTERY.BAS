10 REM NATIONAL LOTTERY NUMBER PICKER
20 REM Written by A.Sill
30 REM WRITTEN FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "NATIONAL LOTTERY NUMBER PICKER"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "     This program will pick sets of six numbers for you, as required to enter   the national lottery.   You input how many sets you require and the program willdo the rest.   To print out press 'Print Screen' at the end."
120 PRINT "You will also have the option of whether you want to be prompted after each     number is drawn, to press a key.   Good Luck."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM ##### MAIN PROGRAM #####
200 CLS
210 COLOR 14: LOCATE 2, 29: PRINT "LOTTERY NUMBER PICKER"
220 COLOR 11: PRINT : INPUT "How many sets do you require : "; SETS%
230 IF SETS% < 1 OR SETS% > 9999 THEN GOTO 220
240 PRINT : INPUT "Do you want to be prompted to press a key (Y)es or (N)o ? : "; PROMPT$
250 IF PROMPT$ = "Y" OR PROMPT$ = "N" THEN GOTO 260 ELSE GOTO 240
260 CLS
270 FOR LoopVar = 1 TO SETS%
280 FOR A = 1 TO 6: NUMB%(A) = 0: NEXT A
290 FOR A = 1 TO 6
300 FOR WIPE = 7 TO 11: LOCATE WIPE, 1: PRINT SPACE$(80): NEXT WIPE
310 COLOR 14: LOCATE 2, 29: PRINT "LOTTERY NUMBER PICKER"
320 COLOR 11: LOCATE 5, 32: PRINT "Your numbers ..."
330 NUMB%(A) = INT(RND * 49) + 1
340 DOUB% = 0: FOR B = 1 TO A - 1: IF NUMB%(A) = NUMB%(B) THEN DOUB% = 1
350 NEXT B
360 IF DOUB% = 1 THEN GOTO 330
370 TEXT$ = STR$(NUMB%(A)): GOSUB 440
380 LOCATE 17 + LoopVar, 1: PRINT "Your numbers (Set"; LoopVar; ") :"; : FOR B = 1 TO A: COLOR 4: LOCATE 17 + LoopVar, 22 + (B * 3): PRINT NUMB%(B); : NEXT B
390 IF PROMPT$ = "Y" THEN WHILE INKEY$ = "": WEND
400 NEXT A
410 NEXT LoopVar
420 COLOR 8: LOCATE 24, 54: PRINT "PRINT SCREEN OR PRESS A KEY"; : WHILE INKEY$ = "": WEND
430 GOTO 560
440 REM ##### TEXT SIZE ROUTINE #####
450 COLOR 8
460 LOCATE 25, 1: PRINT TEXT$;
470 FOR X = 0 TO 8 * LEN(TEXT$)
480 FOR Y = 4 TO 13
490 IF POINT(X, 334 + Y) = 0 THEN 520
500 LINE ((X * 4) + 245, (Y * 4) + 100)-((X * 4) + 245, (Y * 4) + 102), 15
510 LINE ((X * 4) + 246, (Y * 4) + 100)-((X * 4) + 246, (Y * 4) + 102), 15
520 NEXT Y
530 NEXT X
540 LOCATE 25, 1: PRINT SPACE$(79);
550 RETURN
560 REM ********* RETURN TO MENU POSER
570 CLS
580 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
590 LOCATE 3, 26: COLOR 7: PRINT "1"
600 LOCATE 4, 26: PRINT "2"
610 A$ = INKEY$: IF A$ = "" THEN GOTO 610
620 IF A$ = "1" THEN CLEAR : RUN
630 IF A$ = "2" THEN CLS : SYSTEM
640 GOTO 610
650 REM ######### PAST RECORD FOR THE AUTHOR #########
660 REM WEEK ONE        2 NUMBERS         œ0
670 REM WEEK TWO        1 NUMBER          œ0
680 REM WEEK THREE      1 NUMBER          œ0
690 REM                 2 NUMBERS +BONUS  œ0
700 REM WEEK FOUR       1 NUMBER          œ0
710 REM WEEK FIVE       1 NUMBER          œ0
720 REM WEEK SIX        NONE              œ0
730 REM WEEK SEVEN      3 NUMBERS         œ10

