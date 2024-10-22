10 REM BUSINESS 2 : CLUB FIXTURES
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "CLUB FIXTURES"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    This program calculates, who plays who in a league, irrespective of which   kind of league. A perfect program for a sports club or even among friends."
120 PRINT "    Just enter the number of teams in the league and the computer will output toeither screen, printer or an ASCII file, the fixtures for each week."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 COLOR 14: LOCATE 2, 27: PRINT "League Fixtures Calculator"
220 DEFINT A-Z
230 COLOR 10: LOCATE 5, 5: INPUT "Enter number of league teams (Maximum 60) :"; NUM%
240 IF NUM% < 3 OR NUM% > 60 THEN 230
250 IF INT(NUM% / 2) - NUM% / 2 <> 0 THEN NUM% = NUM% + 1: BYE% = 1
260 DIM FIXTURES%(NUM% - 1, NUM% / 2, 2)
270 COLOR 7: LOCATE 7, 5: PRINT "Please Wait"
280 FOR LoopVar = 1 TO NUM% - 1
290 VAR1 = 1: Y = NUM%: FLAG1 = 0: W = NUM% - 1: FLAG2 = 1
300 FOR C = 1 TO W
310 IF C <> LoopVar OR VAR1 > Y THEN GOTO 350
320 FIXTURES%(LoopVar, FLAG2, 1) = VAR1
330 FIXTURES%(LoopVar, FLAG2, 2) = Y
340 FLAG2 = FLAG2 + 1
350 IF FLAG1 = 1 THEN Y = VAR1: FLAG1 = 0
360 Y = Y - 1: IF Y = VAR1 THEN Y = NUM%: FLAG1 = 1
370 IF Y > 0 THEN GOTO 400
380 IF VAR1 = W THEN Y = NUM%: FLAG1 = 1: GOTO 400
390 Y = NUM% - 1
400 NEXT C
410 VAR1 = VAR1 + 1: Y = NUM% - VAR1 + 1: FLAG1 = 0
420 IF VAR1 <> NUM% THEN 300
430 NEXT LoopVar
440 CLS
450 COLOR 14: LOCATE 2, 27: PRINT "CLUB LEAGUE FIXTURES OUTPUT"
460 COLOR 10: LOCATE 5, 5: PRINT "(F)ile - ASCII"
470 LOCATE 6, 5: PRINT "(P)rinter"
480 LOCATE 7, 5: PRINT "(S)creen"
490 LOCATE 8, 5: PRINT "(Q)uit program"
500 A$ = INKEY$: IF A$ = "" THEN 500
510 IF A$ = "Q" OR A$ = "q" THEN GOTO 560
520 IF A$ = "F" OR A$ = "f" THEN GOTO 580
530 IF A$ = "P" OR A$ = "p" THEN GOTO 800
540 IF A$ = "S" OR A$ = "s" THEN GOTO 990
550 GOTO 500
560 REM ++++++++++ QUIT PROGRAM
570 GOTO 1200
580 REM ++++++++++ SEND TO A FILE
590 CLS
600 INPUT "Enter filename :"; FILENAME$
610 OPEN FILENAME$ FOR OUTPUT AS #1
620 PRINT #1, "Set of full league fixtures for "; NUM% - BYE%; " teams."
630 FOR LoopVar1 = 1 TO W STEP 7
640 FLAG2 = 1: TA = 0
650 PRINT #1, ""
660 FOR LoopVar2 = LoopVar1 TO LoopVar1 + 6
670 IF LoopVar2 > W THEN GOTO 730
680 PRINT #1, TAB(TA); FIXTURES%(LoopVar2, FLAG2, 1);
690 IF FIXTURES%(LoopVar2, FLAG2, 2) = NUM% AND BYE% = 1 THEN PRINT #1, "  Bye"; : GOTO 710
700 PRINT #1, "-"; FIXTURES%(LoopVar2, FLAG2, 2);
710 TA = TA + 11
720 NEXT LoopVar2
730 TA = 0: FLAG2 = FLAG2 + 1: IF FLAG2 <= NUM% / 2 THEN GOTO 650
740 PRINT #1, ""
750 NEXT LoopVar1
760 PRINT #1, ""
770 CLOSE
780 PRINT : PRINT "Press any key"
790 WHILE INKEY$ = "": WEND: CLEAR : RUN
800 REM ++++++++++ SEND TO PRINTER
810 CLS
820 COLOR 12: LPRINT "Set of full league fixtures for "; NUM% - BYE%; " teams."
830 FOR LoopVar1 = 1 TO W STEP 7
840 FLAG2 = 1: TA = 0
850 LPRINT
860 FOR LoopVar2 = LoopVar1 TO LoopVar1 + 6
870 IF LoopVar2 > W THEN GOTO 930
880 LPRINT TAB(TA); FIXTURES%(LoopVar2, FLAG2, 1);
890 IF FIXTURES%(LoopVar2, FLAG2, 2) = NUM% AND BYE% = 1 THEN LPRINT "  Bye"; : GOTO 910
900 LPRINT "-"; FIXTURES%(LoopVar2, FLAG2, 2);
910 TA = TA + 11
920 NEXT LoopVar2
930 TA = 0: FLAG2 = FLAG2 + 1: IF FLAG2 <= NUM% / 2 THEN GOTO 850
940 LPRINT
950 NEXT LoopVar1
960 LPRINT
970 PRINT : PRINT "Press any key"
980 WHILE INKEY$ = "": WEND: CLEAR : RUN
990 REM ++++++++++ SEND TO SCREEN
1000 CLS
1010 COLOR 12
1020 PRINT "Set of full league fixtures for "; NUM% - BYE%; " teams."
1030 FOR LoopVar1 = 1 TO W STEP 7
1040 COLOR 7
1050 FLAG2 = 1: TA = 0
1060 PRINT
1070 FOR LoopVar2 = LoopVar1 TO LoopVar1 + 6
1080 IF LoopVar2 > W THEN GOTO 1140
1090 PRINT TAB(TA); FIXTURES%(LoopVar2, FLAG2, 1);
1100 IF FIXTURES%(LoopVar2, FLAG2, 2) = NUM% AND BYE% = 1 THEN PRINT "  Bye"; : GOTO 1120
1110 PRINT "-"; FIXTURES%(LoopVar2, FLAG2, 2);
1120 TA = TA + 11
1130 NEXT LoopVar2
1140 TA = 0: FLAG2 = FLAG2 + 1: IF FLAG2 <= NUM% / 2 THEN GOTO 1060
1150 PRINT
1160 NEXT LoopVar1
1170 PRINT
1180 PRINT : PRINT "Press any key"
1190 WHILE INKEY$ = "": WEND: CLEAR : RUN
1200 REM ********* RETURN TO MENU POSER
1210 CLS
1220 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
1230 LOCATE 3, 26: COLOR 7: PRINT "1"
1240 LOCATE 4, 26: PRINT "2"
1250 A$ = INKEY$: IF A$ = "" THEN GOTO 1250
1260 IF A$ = "1" THEN CLEAR : RUN
1270 IF A$ = "2" THEN CLS : SYSTEM
1280 GOTO 1250

