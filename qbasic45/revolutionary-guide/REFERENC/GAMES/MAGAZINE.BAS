10 REM MAGAZINE EDITOR
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "MAGAZINE EDITOR"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "This game is a simple strategy game where you control the publishing of your ownmagazine.   All factors are taken into consideration and demonstrate the great  effectiveness of simple programs."
120 PRINT "Of course this game is no prize winner but it does show how ideas for programs  can provide a good engine.   There are all manner of improvements possible for  this type of game but they are up to you."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 COLOR 14: LOCATE 1, 33: PRINT "MAGAZINE EDITOR"
220 COLOR 7: LOCATE 5, 5: INPUT "Enter name of your magazine : "; NAM$
230 CLS : COLOR 3: LOCATE 1, 34: PRINT NAM$
240 PRINT : COLOR 7: PRINT "MONEY :"; TAB(21); "READERS :"
250 PRINT "MAGAZINE COST :"; TAB(21); "Issue number "
260 MONEY = 10000: GOSUB 640: ISS = 0: RE = 0
270 WHILE MONEY > 0 AND MONEY < 100000000#
280 ISS = ISS + 1: GOSUB 300: WEND
290 PRINT "WELL DONE : YOU'RE A BILLIONAIRE !"
300 REM ***** MAKE ONE ISSUE
310 PRINT
320 INPUT "How much money for the cover (1-100) :"; COV
330 IF COV < 1 OR COV > 100 OR COV > MONEY THEN GOTO 310
340 CASH = CASH - COV
350 PRINT "Will you put a free item on the cover (y/n)"
360 A$ = INKEY$: IF A$ = "" THEN GOTO 360
370 IF A$ = "Y" OR A$ = "y" THEN CAS = .4 ELSE IF A$ = "N" OR A$ = "n" THEN CAS = 0 ELSE GOTO 360
380 PRINT "Will you include a poster or pullout (y/n)"
390 A$ = INKEY$: IF A$ = "" THEN GOTO 390
400 IF A$ = "Y" OR A$ = "y" THEN PO = .1 ELSE IF A$ = "N" OR A$ = "n" THEN PO = 0 ELSE GOTO 390
410 PRINT "What type of paper : "
420 PRINT "1 - Low quality (10 for 1p)"
430 PRINT "2 - Medium quality (5 for 1p)"
440 PRINT "3 - High quality (2 for 1p)"
450 A$ = INKEY$: IF VAL(A$) < 1 OR VAL(A$) > 3 THEN GOTO 450
460 TY = VAL(A$)
470 INPUT "How many pages (10-250)"; A
480 IF A < 10 OR A > 250 THEN GOTO 470 ELSE P = A
490 CP = INT(10 / TY)
500 IF CP = 3 THEN CP = 2
510 INPUT "Make how many copies"; A
520 A = ABS(A)
530 IF A * (P / CP / 100 + .1 + CAS) > MONEY THEN GOTO 510
540 MM = A
550 INPUT "Price of magazine : œ", COST
560 COST = ABS(COST)
570 MR = INT((COV + P + TY * 50 + (100 - COST * 10 + CAS * 20 + 500) + PO * 100) / 10)
580 PRINT "RATING IS : "; MR
590 RE = INT((RE / INT(RND * 2 + 1)) + MR * (30 - COST * 5 + RND * 20) + P * TY * 10 + RND * 100 + PO * 1000 + RND * 100 * 2)
600 IF RE > MM THEN RE = MM
610 IF COST > 5 THEN RE = 0: PRINT "Too expensive!!": GOTO 630
620 IF ISS > 3 THEN BA = INT(RND * RE / 10): PRINT BA; " readers buy back issues": PRINT "gain = œ"; BA * COST: MONEY = MONEY + BA * COST
630 MONEY = INT(MONEY - (COV + P * CP / 10000 * MM) - (CAS * MM + PO * MM) + RE * COST): A$ = ""
640 REM ***** UPDATE
650 CLS : COLOR 3: LOCATE 1, 34: PRINT NAM$
660 PRINT : COLOR 7: PRINT "MONEY :"; TAB(25); "READERS :"
670 PRINT "MAGAZINE COST :"; TAB(25); "Issue number "
680 LOCATE 3, 8: PRINT MONEY
690 LOCATE 3, 35: PRINT RE
700 LOCATE 4, 16: PRINT COST
710 LOCATE 4, 39: PRINT ISS
720 LOCATE 5, 1: PRINT "RATING IS : "; MR
730 WHILE INKEY$ = "": WEND
740 RETURN

