10 REM SNOWFALL
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM                                                                      
60 SCREEN 9: CLS
70 A$ = "SNOWFALL"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "This nifty little routine simulates erratic snowfall.   The longer it goes, the more fascinating it becomes.  Should  a program be able to produce multiple"
120 PRINT "snowflakes simultaneously, it would look brilliant.  Hold down the SPACE bar to end the routine."
130 RAND = 0
140 REM LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 REM A$ = ""
160 REM A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM ##### END OF STANDARD SECTION #####
200 REM SET UP SCREEN
210 SCREEN 1: CLS
220 FOR A = 1 TO 50
230 X = RND * 320: Y = RND * 150 + 50: M = RND * 50
240 LINE (X, Y)-(X + M, Y), 2
250 NEXT A
260 LINE (1, 199)-(319, 199), 2
270 COLOR 0, 1: LOCATE 3, 16: PRINT "SNOWFALL"
280 PALETTE 3, 15
290 REM SNOWFALL
300 X% = INT(RND * 310) + 5: Y% = 1
310 IF INKEY$ = " " THEN GOTO 540
320 C1% = POINT(X% - 1, Y% + 1)
330 C2% = POINT(X%, Y% + 1)
340 C3% = POINT(X% + 1, Y% + 1)
350 C4% = POINT(X% - 1, Y% + 2)
360 C5% = POINT(X% + 1, Y% + 2)
370 IF C2% <> 0 THEN GOTO 420
380 IF C2% = 0 THEN Y% = Y% + 1
390 PSET (X%, Y%), 15
400 PSET (X%, Y% - 1), 0
410 GOTO 320
420 REM HIT SOMETHING
430 IF C2% = 3 THEN GOTO 460
440 IF C2% = 2 THEN PSET (X%, Y%), 15: PSET (X%, Y% - 1), 0: GOTO 300
450 PRINT "HIT ANOTHER COLOUR": STOP
460 REM MOVE LEFT OR RIGHT
470 IF (C1% <> 0 OR C4% <> 0) AND (C3% <> 0 OR C5% <> 0) THEN GOTO 300
480 LOR% = INT(RND * 2)
490 IF LOR% = 0 AND (C1% <> 0 OR C4% <> 0) THEN LOR% = 1: GOTO 510
500 IF LOR% = 0 AND C1% = 0 AND C4% = 0 THEN X% = X% - 1: Y% = Y% + 1: PSET (X%, Y%), 15: PSET (X% + 1, Y% - 1), 0
510 IF LOR% = 1 AND (C3% <> 0 OR C5% <> 0) THEN LOR% = 0: GOTO 490
520 IF LOR% = 1 AND C3% = 0 AND C5% = 0 THEN X% = X% + 1: Y% = Y% + 1: PSET (X%, Y%), 15: PSET (X% - 1, Y% - 1), 0
530 GOTO 320
540 REM ********* RETURN TO MENU POSER
550 ' When in your favourite program make sure all line numbers are below
560 ' 60000 and then type MERGE "ADD" to merge in this program to yours
570 ' And hey presto you have a neat menu system at the end of your program
580 CLS
590 COLOR 14: LOCATE 1, 22: PRINT "End of program flow control"
600 COLOR 7: LOCATE 3, 1: PRINT "          Do you want to 1. Run again or"
610 PRINT "                         2. Exit back to DOS"
620 LOCATE 3, 26: COLOR 12: PRINT "1"
630 LOCATE 4, 26: PRINT "2"
640 A$ = INKEY$: IF A$ = "" THEN GOTO 640
650 IF A$ = "1" THEN CLEAR : RUN
660 IF A$ = "2" THEN CLS : SYSTEM
670 GOTO 640

