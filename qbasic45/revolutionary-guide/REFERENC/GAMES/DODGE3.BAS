10 REM 3 Player  Dodge v1.0
20 REM By A.Sill
30 REM FOR WROX PRESS
40 REM ++++++++ TITLE SCREEN
50 SCREEN 9
60 CLS
70 COLOR 3: LOCATE 2, 28: PRINT "THREE PLAYER DODGER"
80 COLOR 2: LOCATE 5, 2: PRINT "Player One is Green and uses the ARROW keys"
90 COLOR 4: LOCATE 7, 2: PRINT "Player Two is Red and uses the Q,A,W,E keys"
100 COLOR 14: LOCATE 9, 2: PRINT "Player Three is Yellow and uses N,M,P,L keys"
110 COLOR 7: LOCATE 22, 31: PRINT "Press any key"
120 WHILE A$ = "": A$ = INKEY$: WEND
130 REM ++++++++ INITIALISE VARIABLES
140 X1% = 100: X2% = 540: Y1% = 175: Y2% = 175: X3% = 320: Y3% = 50
150 D1% = 0: D2% = 0: PX1% = X1%: PX2% = X2%: PY1% = Y1%: PY2% = Y2%: D3% = 0: PX3% = X3%: PY3% = Y3%
160 REM ++++++++ DRAW GAME SCREEN
170 CLS
180 LINE (1, 1)-(640, 1), 7
190 LINE (639, 1)-(639, 329), 7
200 LINE (639, 329)-(1, 329), 7
210 LINE (1, 329)-(1, 1), 7
220 REM ++++++++ GAME
230 A$ = INKEY$
240 IF A$ = "Q" OR A$ = "q" THEN D1% = 2
250 IF A$ = "A" OR A$ = "a" THEN D1% = 4
260 IF A$ = "W" OR A$ = "w" THEN D1% = 3
270 IF A$ = "E" OR A$ = "e" THEN D1% = 1
280 IF A$ <> "" THEN IF ASC(LEFT$(A$, 1)) = 0 AND RIGHT$(A$, 1) = "M" THEN D2% = 1
290 IF A$ <> "" THEN IF ASC(LEFT$(A$, 1)) = 0 AND RIGHT$(A$, 1) = "H" THEN D2% = 2
300 IF A$ <> "" THEN IF ASC(LEFT$(A$, 1)) = 0 AND RIGHT$(A$, 1) = "K" THEN D2% = 3
310 IF A$ <> "" THEN IF ASC(LEFT$(A$, 1)) = 0 AND RIGHT$(A$, 1) = "P" THEN D2% = 4
320 IF A$ = "P" OR A$ = "p" THEN D3% = 2
330 IF A$ = "L" OR A$ = "l" THEN D3% = 4
340 IF A$ = "N" OR A$ = "n" THEN D3% = 3
350 IF A$ = "M" OR A$ = "m" THEN D3% = 1
360 IF D1% = 1 THEN X1% = X1% + 1
370 IF D1% = 2 THEN Y1% = Y1% - 1
380 IF D1% = 3 THEN X1% = X1% - 1
390 IF D1% = 4 THEN Y1% = Y1% + 1
400 IF D2% = 1 THEN X2% = X2% + 1
410 IF D2% = 2 THEN Y2% = Y2% - 1
420 IF D2% = 3 THEN X2% = X2% - 1
430 IF D2% = 4 THEN Y2% = Y2% + 1
440 IF D3% = 4 THEN Y3% = Y3% + 1
450 IF D3% = 1 THEN X3% = X3% + 1
460 IF D3% = 2 THEN Y3% = Y3% - 1
470 IF D3% = 3 THEN X3% = X3% - 1
480 IF POINT(X1%, Y1%) <> 4 AND POINT(X1%, Y1%) <> 14 AND POINT(X1%, Y1%) <> 7 THEN LINE (PX1%, PY1%)-(X1%, Y1%), 2 ELSE L% = 2: GOTO 530
490 IF POINT(X2%, Y2%) <> 2 AND POINT(X2%, Y2%) <> 14 AND POINT(X2%, Y2%) <> 7 THEN LINE (PX2%, PY2%)-(X2%, Y2%), 4 ELSE L% = 4: GOTO 530
500 IF POINT(X3%, Y3%) <> 2 AND POINT(X3%, Y3%) <> 4 AND POINT(X3%, Y3%) <> 7 THEN LINE (PX3%, PY3%)-(X3%, Y3%), 14 ELSE L% = 6: GOTO 530
510 PX1% = X1%: PX2% = X2%: PY1% = Y1%: PY2% = Y2%: PX3% = X3%: PY3% = Y3%
520 GOTO 230
530 REM ++++++++ CRASHED
540 IF L% = 2 THEN X% = X1%: Y% = Y1%: C% = 2
550 IF L% = 4 THEN X% = X2%: Y% = Y2%: C% = 4
560 IF L% = 6 THEN X% = X3%: Y% = Y3%: C% = 14
570 FOR A = 1 TO 20 STEP RND * 3 + 2
580 FOR B = 1 TO 360 STEP 5 + RND * 4
590 LINE (X%, Y%)-(X% + SIN(B) * A * 1.4, Y% + COS(B) * A), C%
600 NEXT B, A
610 WHILE A$ = "": A$ = INKEY$: WEND
620 RUN

