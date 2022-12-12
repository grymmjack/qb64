10 REM MAZE CREATOR
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM BRANCH(30, 1)
70 SCREEN 9: CLS
80 A$ = "MAZE CREATOR"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "     Mazes have always been and always will be, places and objects of curiosity,they can be found as the basis of many, many computer games. This program tries"
130 PRINT "to recreate a maze of any size (although always in a rectangular/square fashion)randomly each time it is run. It's a very complex program to explain so I won't.";
140 PRINT "     The possibilities games-wise and for educational purposes are endless. ALL the mazes created with this program are possible as well. The best mazes are thelargest ones, so patience is the greatest virtue here."
150 RAND = 0
160 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
170 A$ = ""
180 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 180
190 RAND = RAND - VAL(RIGHT$(TIME$, 2))
200 RANDOMIZE RAND
210 REM
220 CLS
230 MX = 0: MY = 0
240 WHILE MX < 5 OR MY < 5 OR MX > 79 OR MY > 23 OR MX MOD 2 = 0 OR MY MOD 2 = 0
250 CLS : PRINT "Enter width and height of maze separated by comma's, using only odd numbers"
260 INPUT "e.g. 21,9 or 17,21. In the range of 5,5 and 79,23 :", MX, MY
270 MX = INT(MX): MY = INT(MY)
280 WEND
290 MX = MX - 1: MY = MY - 1
300 LEFT = MX * MY / 4 - 1: E = 5
310 IF MX < 9 OR MY < 9 THEN E = 10
320 IF MX > 9 AND MY > 9 THEN E = 0
330 DIM MAZE%(MX, MY): BRAN = 0
340 FOR F = 0 TO MX: MAZE%(F, 0) = 2: MAZE%(F, MY) = 2: NEXT F
350 FOR F = 1 TO MY - 1: MAZE%(0, F) = 2: MAZE%(MX, F) = 2: NEXT F
360 FOR F = 2 TO MY - 2 STEP 2
370 FOR G = 2 TO MX - 2 STEP 2
380 MAZE%(G, F) = 2
390 NEXT G, F
400 MAZE%(MX - 1, 0) = 1
410 MAZE%(1, MY) = 1
420 X=MX-1:Y=1:H=2:LOOP=0:CX=-1:CY=1
430 WHILE LOOP=0
440 MAZE%(X, Y) = 1
450 GOSUB 750 ' ****** CREATE THE MAZE
460 WEND
470 GOSUB 1280 ' ****** DRAW THE MAZE ON THE SCREEN
480 RUN
490 END
500 REM ****** EXAMINE THE IMMEDIATE AREA OF MAZE
510 C$ = ""
520 IF X - 2 > 0 THEN IF MAZE%(X - D, Y) = 0 THEN C$ = C$ + "l"
530 IF X + 2 < MX THEN IF MAZE%(X + D, Y) = 0 THEN C$ = C$ + "r"
540 IF Y - 2 > 0 THEN IF MAZE%(X, Y - D) = 0 THEN C$ = C$ + "u"
550 IF Y + 2 < MY THEN IF MAZE%(X, Y + D) = 0 THEN C$ = C$ + "d"
560 C = LEN(C$)
570 RETURN
580 REM ****** END PATH
590 D = 1: GOSUB 500' ***** SEARCH THE SURROUNDING AREA
600 WHILE C > 0: GOSUB 1120: WEND
610 IF LEFT=0 THEN LOOP=1:RETURN
620 IF BRAN = 0 THEN GOSUB 660: RETURN
630 BRAN = BRAN - 1
640 X = BRANCH(BRAN, 0): Y = BRANCH(BRAN, 1)
650 RETURN
660 REM ****** SEARCH FOR A SECTION OF THE PATH
670 X = CX: Y = CY: FLAG = 0
680 WHILE FLAG = 0
690 X = X + 2
700 IF X > MX THEN X = 1: Y = Y + 2
710 IF Y > MY THEN Y = 1
720 IF MAZE%(X, Y) = 1 THEN GOSUB 1210
730 WEND
740 RETURN
750 REM ****** CREATE THE MAZE
760 R = INT(RND * 100) + 1
770 D = 2: GOSUB 500' ****** EXAMINE THE SURROUNDING AREA OF MAZE
780 IF C = 0 THEN GOSUB 580: RETURN' ****** END THE CURRENT PATH
790 IF R < E THEN GOSUB 580: RETURN' ******   "        "     "
800 IF R < 25 AND C > 1 AND BRAN < 31 THEN GOSUB 830' ***** MAKE A BRANCH
810 GOSUB 970 ' ****** MOVE
820 RETURN
830 REM ****** MAKE A BRANCHING
840 Z = INT(RND * C) + 1
850 B$ = MID$(C$, Z, 1)
860 IF B$ = "l" THEN MAZE%(X - 1, Y) = 1: NX = X - 2: NY = Y: GOSUB 550' ***** BRANCH S.H.
870 IF B$ = "r" THEN MAZE%(X + 1, Y) = 1: NX = X + 2: NY = Y: GOSUB 550' ***** BRANCH S.H.
880 IF B$ = "u" THEN MAZE%(X, Y - 1) = 1: NX = X: NY = Y - 2: GOSUB 550' ***** BRANCH S.H.
890 IF B$ = "d" THEN MAZE%(X, Y + 1) = 1: NX = X: NY = Y + 2: GOSUB 550' ***** BRANCH S.H.
900 C$ = LEFT$(C$, Z - 1) + MID$(C$, Z + 1, 4): C = C - 1
910 RETURN
920 REM ****** BRANCH STACK HANDLER
930 MAZE%(NX, NY) = 1
940 BRANCH(BRAN, 0) = NX: BRANCH(BRAN, 1) = NY
950 BRAN = BRAN + 1: LEFT = LEFT - 1
960 RETURN
970 REM ****** MOVE
980 WHILE C > 1
990 GOSUB 1120 ' ****** FILL IN WALLS, BREAK THEM
1000 WEND
1010 S$ = C$: H = 1
1020 GOSUB 1120: H = 2' ***** MAKE A PATH
1030 D = 1: GOSUB 500' ***** SEARCH SURROUNDINGS
1040 WHILE C > 0: GOSUB 1120: WEND
1050 C$ = S$
1060 IF C$ = "l" THEN X = X - 2
1070 IF C$ = "r" THEN X = X + 2
1080 IF C$ = "u" THEN Y = Y - 2
1090 IF C$ = "d" THEN Y = Y + 2
1100 LEFT = LEFT - 1
1110 RETURN
1120 REM ****** FILL IN WALLS, BREAK THEM, CLOSE OFF EXITS
1130 Z = INT(RND * C) + 1
1140 B$ = MID$(C$, Z, 1)
1150 IF B$ = "l" THEN MAZE%(X - 1, Y) = H
1160 IF B$ = "r" THEN MAZE%(X + 1, Y) = H
1170 IF B$ = "u" THEN MAZE%(X, Y - 1) = H
1180 IF B$ = "d" THEN MAZE%(X, Y + 1) = H
1190 C$ = LEFT$(C$, Z - 1) + MID$(C$, Z + 1, 4): C = C - 1
1200 RETURN
1210 REM ***** IS IT A SPACE NEXT ?
1220 D = 2: GOSUB 500' ***** SEARCH IMMEDIATE AREA
1230 IF C = 0 THEN RETURN
1240 CX = X: CY = Y: H = 1
1250 GOSUB 1120: H = 2: FLAG = 1: C$ = B$
1260 GOSUB 1060
1270 RETURN
1280 REM ****** DRAW MAZE ON THE SCREEN
1290 CLS
1300 FOR F = 0 TO MY: FOR G = 0 TO MX
1310 A = MAZE%(G, F)
1320 IF A = 1 THEN PRINT " "; :  ELSE PRINT "Û";
1330 NEXT G
1340 PRINT
1350 NEXT F
1360 WHILE INKEY$ = "": WEND
1370 REM ********* RETURN TO MENU POSER
1380 CLS
1390 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
1400 LOCATE 3, 26: COLOR 7: PRINT "1"
1410 LOCATE 4, 26: PRINT "2"
1420 A$ = INKEY$: IF A$ = "" THEN GOTO 1420
1430 IF A$ = "1" THEN CLEAR : RUN
1440 IF A$ = "2" THEN CLS : SYSTEM
1450 GOTO 1420

