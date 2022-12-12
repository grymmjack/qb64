10 REM BOUNDER
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 RAND% = 0
70 DIM OX%(150), OY%(150)
80 SCREEN 9: CLS
90 A$ = "BOUNDER"
100 COLOR 2
110 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
120 COLOR 10
130 COLOR 10: LOCATE 5, 1: PRINT "    There comes a time, in a programmers life when he or she wants a ball to    bounce around the screen. There are various routines to do this, but the one    which follows is probably the fastest method around."
140 PRINT "    Still, it isn't 100% perfect but it is very very fast and needs slowing downin most cases. The following isn't just a ball but more of a laser bolt."
150 PRINT "    All the variables are easily altered to change it's length, jump size, speedand even direction (press V). Press Q to quit."
160 RAND = 0
170 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
180 A$ = ""
190 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 190
200 RAND = RAND - VAL(RIGHT$(TIME$, 2))
210 RANDOMIZE RAND
220 REM
230 CLS
240 LENGTH% = 20
250 FOR A = 1 TO LENGTH%: OX%(A) = X%: OY%(A) = Y%: NEXT A
260 FOR A = 1 TO 1000
270 C = RND * 640: D = RND * 350: E = RND * 45: F = RND * 40
280 LINE (C, D)-(C + F, D + E), INT(RND * 2) * 12, BF
290 NEXT A
300 X% = INT(RND * 630) + 5: Y% = INT(RND * 340) + 5
310 IF POINT(X%, Y%) <> 0 THEN 300
320 NO% = 0: X1% = 2: Y1% = 1
330 LINE (1, 1)-(639, 349), 12, B
340 WHILE INKEY$ = "": WEND
350 OX%(0) = X%: OY%(0) = Y%
360 PSET (X%, Y%), 15
370 WHILE -1
380 PSET (X%, Y%), 15
390 PSET (OX%(LENGTH%), OY%(LENGTH%)), 0
400 FOR A% = LENGTH% TO 1 STEP -1: OX%(A%) = OX%(A% - 1): OY%(A%) = OY%(A% - 1): NEXT A%: OX%(0) = X%: OY%(0) = Y%
410 X% = X% + X1%: Y% = Y% + Y1%
420 IF NTY% > 0 THEN NTY% = NTY% - 1: GOTO 460
430 IF INKEY$ = "Q" THEN GOTO 500
440 IF INKEY$ = "V" THEN Y1% = -Y1%: NTY% = 2
450 IF INKEY$ = "Q" THEN GOTO 500
460 IF NTX% > 0 THEN NTX% = NTX% - 1: GOTO 470
470 IF POINT(X% + X1%, Y%) <> 0 THEN X1% = -X1%
480 IF POINT(X%, Y% + Y1%) <> 0 THEN Y1% = -Y1%
490 WEND
500 REM ********* RETURN TO MENU POSER
510 CLS
520 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
530 LOCATE 3, 26: COLOR 7: PRINT "1"
540 LOCATE 4, 26: PRINT "2"
550 A$ = INKEY$: IF A$ = "" THEN GOTO 550
560 IF A$ = "1" THEN CLEAR : RUN
570 IF A$ = "2" THEN CLS : SYSTEM
580 GOTO 550

