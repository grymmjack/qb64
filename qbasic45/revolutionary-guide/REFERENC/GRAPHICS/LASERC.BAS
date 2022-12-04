10 REM LASER COLOUR
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM                                                                      
60 SCREEN 9: CLS
70 A$ = "LASER COLOUR"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "This effect is a combination of laser and colour cycling.  This is quite a very interesting interactive effect because each time you press a key, then the laser";
120 PRINT "stops bouncing and its trail shines.  When you press a key again - the bouncing starts again but in a different direction.  Enjoy - it's theraputic."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM ##### END OF STANDARD SECTION #####
200 CLS
210 SCREEN 9: CLS
220 COLOR 4
230 C% = 1: D% = 1: E% = 1: F% = 2: X% = INT(RND * 600) + 10: Y% = INT(RND * 330) + 10: DX% = X%: DY% = Y%
240 WHILE INKEY$ = ""
250 IF D% = 1 THEN X% = X% + 1: Y% = Y% - 1
260 IF D% = 1 AND X% > 639 THEN D% = 4: GOTO 340
270 IF D% = 1 AND Y% < 1 THEN D% = 2: GOTO 280
280 IF D% = 2 THEN X% = X% + 1: Y% = Y% + 1
290 IF D% = 2 AND X% > 639 THEN D% = 3: GOTO 310
300 IF D% = 2 AND Y% > 349 THEN D% = 1: GOTO 250
310 IF D% = 3 THEN X% = X% - 1: Y% = Y% + 1
320 IF D% = 3 AND Y% > 349 THEN D% = 4: GOTO 340
330 IF D% = 3 AND X% < 1 THEN D% = 2: GOTO 280
340 IF D% = 4 THEN X% = X% - 1: Y% = Y% - 1
350 IF D% = 4 AND X% < 1 THEN D% = 1: GOTO 250
360 IF D% = 4 AND Y% < 1 THEN D% = 3: GOTO 310
370 LINE (DX%, DY%)-(X%, Y%), C%
380 C% = C% + 1: IF C% = 6 THEN C% = 1
390 DX% = X%: DY% = Y%
400 WEND
410 WHILE INKEY$ = ""
420 E% = E% + 1: IF E% = 6 THEN E% = 1
430 F% = F% + 1: IF F% = 64 THEN F% = 1
440 PALETTE E%, F%
450 WEND
460 D% = D% + 1: IF D% = 5 THEN D% = 1
470 GOTO 240
480 REM ********* RETURN TO MENU POSER
490 ' When in your favourite program make sure all line numbers are below
500 ' 60000 and then type MERGE "ADD" to merge in this program to yours
510 ' And hey presto you have a neat menu system at the end of your program
520 CLS
530 COLOR 14: LOCATE 1, 22: PRINT "End of program flow control"
540 COLOR 7: LOCATE 3, 1: PRINT "          Do you want to 1. Run again or"
550 PRINT "                         2. Exit back to DOS"
560 LOCATE 3, 26: COLOR 12: PRINT "1"
570 LOCATE 4, 26: PRINT "2"
580 A$ = INKEY$: IF A$ = "" THEN GOTO 580
590 IF A$ = "1" THEN CLEAR : RUN
600 IF A$ = "2" THEN CLS : SYSTEM
610 GOTO 580

