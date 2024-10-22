10 REM THE BATTLE
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 ON ERROR GOTO 540
70 DIM MEMX%(640), MEMY%(640)
80 DIM S(360), C(360)
90 SCREEN 9: CLS
100 A$ = "THE BATTLE"
110 COLOR 2
120 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
130 COLOR 10
140 COLOR 10: LOCATE 5, 1: PRINT "The battle is a game between two warring factions on a hilly landscape."
150 PRINT "Each player takes it in turns to take a shot at the other player.   The first tomake a direct hit wins.   In order to ensure that the first player to shoot doesnot win every time a number of varying factors have been introduced."
160 PRINT "Each landscape is very much different, positions are different and a random windis present."
170 RAND = 0
180 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
190 A$ = ""
200 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 200
210 RAND = RAND - VAL(RIGHT$(TIME$, 2))
220 RANDOMIZE RAND
230 CLS
240 FOR T = 0 TO 360
250 S(T) = SIN(T): C(T) = COS(T): NEXT T
260 REM
270 CLS
280 RANDOMIZE RND * 3276 * VAL(RIGHT$(TIME$, 2))
290 DIM A(250), B(250), C%(250)
300 SCREEN 9: NN% = 4: CLS
310 FOR N% = 1 TO NN%
320 A(N%) = RND * 110 / N%: B(N%) = RND * 16.70795
330 C%(N%) = RND * 15 + 1
340 IF C%(N%) = 10 OR C%(N%) = 11 THEN GOTO 330
350 NEXT N%
360 LX1% = INT(RND * 80) + 10: LX2% = 630 - INT(RND * 80)
370 FOR X% = 0 TO 639
380 LINE (X%, 349)-(X%, 349), 0: Y = 16
390 K = 6.28 * X% / 640: FOR N% = 1 TO NN%
400 Y = Y + A(N%) * (1 + SIN(N% * K + B(N%)))
410 IF LX1% = X% AND N% = NN% THEN LY1% = 350 - Y
420 IF LX2% = X% AND N% = NN% THEN LY2% = 350 - Y
430 LINE (X%, 350 - Y)-(X%, 350 - DY), C%(N%)
440 DY = Y
450 NEXT N%, X%
460 FOR B = LY1% - 5 TO LY1% + 5
470 LINE (LX1% - 5, B)-(LX1% + 5, B), 15
480 NEXT B
490 LINE (LX1% - 5, LY1% - 5)-(LX1% + 5, LY1% + 5), 10, BF
500 FOR B = LY2% - 5 TO LY2% + 5
510 LINE (LX2% - 5, B)-(LX2% + 5, B), 15
520 NEXT B
530 LINE (LX2% - 5, LY2% - 5)-(LX2% + 5, LY2% + 5), 11, BF
540 REM ***** GET PLAYER 1 INPUT
550 LOCATE 1, 1: PRINT STRING$(30, " ")
560 COLOR 10: LOCATE 1, 1: INPUT "Angle : "; ANGLE1%
570 LOCATE 2, 1: INPUT "Speed : "; SPEED1%
580 IF SPEED1% < 20 OR SPEED1% > 200 THEN GOTO 570
590 LOCATE 1, 1: PRINT "Player 1 Shoots"
600 LOCATE 2, 1: PRINT STRING$(30, " ")
610 PLAYER% = 1
620 GOSUB 730
630 REM ***** GET PLAYER 2 INPUT
640 LOCATE 1, 1: PRINT STRING$(30, " ")
650 COLOR 11: LOCATE 1, 1: INPUT "Angle : "; ANGLE2%
660 LOCATE 2, 1: INPUT "Speed : "; SPEED2%
670 IF SPEED2% < 20 OR SPEED2% > 200 THEN GOTO 660
680 LOCATE 1, 1: PRINT "Player 2 Shoots"
690 LOCATE 2, 1: PRINT STRING$(30, " ")
700 PLAYER% = 2
710 GOSUB 730
720 GOTO 540
730 REM ##### PROJECTILE SECTION
740 GRAVITY = 9.8
750 IF PLAYER% = 1 THEN ANGLE = ANGLE1% / 57.29577951#: SPEED% = SPEED1%: DX% = LX1%: DY% = 350 - LY1%: COL% = 10
760 IF PLAYER% = 2 THEN ANGLE = ANGLE2% / 57.29577951#: SPEED% = SPEED2%: DX% = LX2%: DY% = 350 - LY2%: COL% = 11
770 WINDOW (0, 350)-(640, 0)
780 CRASH% = 0: X = 1
790 WHILE (CRASH% <> 1)
800 X = X + 2
810 SOUND 640 - X, 1
820 Y% = (X * TAN(ANGLE)) - ((.5 * GRAVITY * (X ^ 2)) / ((SPEED% ^ 2) * (COS(ANGLE) ^ 2)))
830 IF PLAYER% = 1 AND ((POINT(X + DX%, Y% + DY%) <> 0 AND POINT(X + DX%, Y% + DY%) <> 10 AND POINT(X + DX%, Y% + DY%) <> -1) OR X + DX% > 640 OR Y% + DY% < 0) THEN CRASH% = 1
840 IF PLAYER% = 1 AND POINT(X + DX%, Y% + DY%) = 11 THEN WIN% = 1
850 IF PLAYER% = 2 AND ((POINT(DX% - X, Y% + DY%) <> 0 AND POINT(DX% - X, Y% + DY%) <> 11 AND POINT(DX% - X, Y% + DY%) <> -1) OR DX% - X < 0 OR Y% + DY% < 0) THEN CRASH% = 1
860 IF PLAYER% = 2 AND POINT(DX% - X, Y% + DY%) = 10 THEN WIN% = 2
870 MEMY%(X) = Y% + DY%
880 IF PLAYER% = 1 THEN MEMX%(X) = X + DX% ELSE MEMX%(X) = DX% - X
890 IF PLAYER% = 1 THEN LINE (X + DX%, Y% + DY%)-(X + DX%, Y% + DY%), COL%
900 IF PLAYER% = 2 THEN LINE (DX% - X, Y% + DY%)-(DX% - X, Y% + DY%), COL%
910 IF X > 20 THEN LINE (MEMX%(X - 20), MEMY%(X - 20))-(MEMX%(X - 20), MEMY%(X - 20)), 0
920 CNT% = X
930 WEND
940 IF X < 20 THEN TX = 20 - X ELSE TX = 0
950 FOR A = X - 19 + TX TO X
960 LINE (MEMX%(A), MEMY%(A))-(MEMX%(A), MEMY%(A)), 0
970 NEXT A
980 X = MEMX%(CNT%): Y = MEMY%(CNT%)
990 IF WIN% = 1 THEN GOTO 1120
1000 IF WIN% = 2 THEN GOTO 1280
1010 GOSUB 1030
1020 RETURN
1030 REM ##### DRAW EXPLOSION
1040 FOR T = 1 TO 20
1050 FOR W = 0 TO 324 STEP 36
1060 IF POINT(S(W) * T + X, C(W) * T + Y) = 11 OR POINT(S(W) * T + X, C(W) * T + Y) = 10 THEN 1100
1070 PSET (S(W) * T + X, C(W) * T + Y), 0
1080 IF POINT(S(W) * (T - 12) + X, C(W) * (T - 12) + Y) = 11 OR POINT(S(W) * (T - 12) + X, C(W) * (T - 12) + Y) = 10 THEN 1100
1090 IF T > 10 THEN PSET (S(W) * (T - 12) + X, C(W) * (T - 12) + Y), 0
1100 NEXT W, T
1110 RETURN
1120 REM ##### PLAYER 1 WINS #####
1130 FOR T = 1 TO 60
1140 IF T > 50 AND T < 61 THEN COL% = 15
1150 IF T > 40 AND T < 51 THEN COL% = 14
1160 IF T > 30 AND T < 41 THEN COL% = 8
1170 IF T > 20 AND T < 31 THEN COL% = 12
1180 IF T > 10 AND T < 21 THEN COL% = 4
1190 CIRCLE (X, Y), T, COL%
1200 SOUND RND * 100 + 50, .5
1210 IF T > 40 THEN CIRCLE (X, Y), T - 40, 0
1220 NEXT T
1230 FOR T = 20 TO 60
1240 SOUND RND * 100 + 50, .5
1250 CIRCLE (X, Y), T, 0
1260 NEXT T
1270 GOTO 1420
1280 REM ##### PLAYER 2 WINS #####
1290 FOR T = 1 TO 60
1300 IF T > 50 AND T < 61 THEN COL% = 15
1310 IF T > 40 AND T < 51 THEN COL% = 14
1320 IF T > 30 AND T < 41 THEN COL% = 8
1330 IF T > 20 AND T < 31 THEN COL% = 12
1340 IF T > 10 AND T < 21 THEN COL% = 4
1350 CIRCLE (X, Y), T, COL%
1360 IF T > 40 THEN CIRCLE (X, Y), T - 40, 0
1370 NEXT T
1380 FOR T = 20 TO 60
1390 CIRCLE (X, Y), T, 0
1400 NEXT T
1410 GOTO 1420
1420 REM ##### SOMEONES WON #####
1430 LOCATE 1, 1: PRINT STRING$(78, " ");
1440 IF WIN% = 1 THEN COLOR 10: LOCATE 1, 33: PRINT "PLAYER 1 WINS"
1450 IF WIN% = 2 THEN COLOR 11: LOCATE 1, 33: PRINT "PLAYER 2 WINS"
1460 COLOR 14: LOCATE 24, 27: PRINT "Press any key to play again";
1470 WHILE INKEY$ = "": WEND
1480 CLEAR : RUN

