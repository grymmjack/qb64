10 REM LASER : TEXT VERSION
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM                                                                      
60 SCREEN 9: CLS
70 A$ = "LASER : TEXT VERSION"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "On the disk, there are a number of graphics files that consist of a             ball or laser bolt bouncing around a landscape or the screen.  This program usesa text character to create a high speed low-res version."
120 PRINT ""
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM ##### END OF STANDARD SECTION #####
200 CLS
210 NUM% = 10: DIM DX%(NUM%), DY%(NUM%)
220 SCREEN 9: CLS
230 COLOR 4
240 D% = 1: X% = 40: Y% = 12
250 FOR A% = 1 TO NUM%: DX%(A%) = X%: DY%(A%) = Y%: NEXT A%
260 WHILE INKEY$ = ""
270 IF D% = 1 THEN X% = X% + 1: Y% = Y% - 1
280 IF D% = 1 AND X% > 79 THEN D% = 4: GOTO 360
290 IF D% = 1 AND Y% < 1 THEN D% = 2: GOTO 300
300 IF D% = 2 THEN X% = X% + 1: Y% = Y% + 1
310 IF D% = 2 AND X% > 79 THEN D% = 3: GOTO 330
320 IF D% = 2 AND Y% > 24 THEN D% = 1: GOTO 270
330 IF D% = 3 THEN X% = X% - 1: Y% = Y% + 1
340 IF D% = 3 AND Y% > 24 THEN D% = 4: GOTO 360
350 IF D% = 3 AND X% < 1 THEN D% = 2: GOTO 300
360 IF D% = 4 THEN X% = X% - 1: Y% = Y% - 1
370 IF D% = 4 AND X% < 1 THEN D% = 1: GOTO 270
380 IF D% = 4 AND Y% < 1 THEN D% = 3: GOTO 330
390 COLOR 15: LOCATE DY%(1), DX%(1): PRINT "±";
400 DX%(1) = X%: DY%(1) = Y%
410 LOCATE DY%(NUM% - 1), DX%(NUM% - 1): PRINT " ";
420 FOR A% = NUM% TO 2 STEP -1: DX%(A%) = DX%(A% - 1): DY%(A%) = DY%(A% - 1): NEXT A%
430 WEND
440 REM ********* RETURN TO MENU POSER
450 ' When in your favourite program make sure all line numbers are below
460 ' 60000 and then type MERGE "ADD" to merge in this program to yours
470 ' And hey presto you have a neat menu system at the end of your program
480 CLS
490 COLOR 14: LOCATE 1, 22: PRINT "End of program flow control"
500 COLOR 7: LOCATE 3, 1: PRINT "          Do you want to 1. Run again or"
510 PRINT "                         2. Exit back to DOS"
520 LOCATE 3, 26: COLOR 12: PRINT "1"
530 LOCATE 4, 26: PRINT "2"
540 A$ = INKEY$: IF A$ = "" THEN GOTO 540
550 IF A$ = "1" THEN CLEAR : RUN
560 IF A$ = "2" THEN CLS : SYSTEM
570 GOTO 540

