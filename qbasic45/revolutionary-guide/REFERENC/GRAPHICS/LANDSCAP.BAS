10 REM Landscaping
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM A(250), B(250), C%(250)
70 SCREEN 9: CLS
80 A$ = "QBASIC LANDSCAPING"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 2: PRINT "Art is a very time consuming and expensive hobby on computers as well as being  extremely difficult. This little and very simple program  shows  what  can  be  done in very little space."
130 PRINT "Using Cosine and Sine functions sweeping countryside can be produced easily,    with a little more programming trees and other effects could easily be added."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 CLS
220 COLOR 15: LOCATE 1, 1: PRINT "Press Q to quit": PRINT "Press any key for another landscape"
230 N = 10' N holds the number of rows of hills
240 FOR A = 1 TO N
250 A(A) = RND * 80 / A: B(A) = RND * 15.70795
260 C%(A) = RND * 15 + 1
270 NEXT A
280 REM
290 FOR X% = 0 TO 639
300 A$ = INKEY$
310 IF A$ = "Q" OR A$ = "q" THEN GOTO 430
320 IF A$ <> "" THEN GOTO 180
330 IF INKEY$ = "Q" OR INKEY$ = "q" THEN SYSTEM
340 IF INKEY$ <> "" THEN GOTO 180
350 LINE (X%, 349)-(X%, 349), 0: Y = 16
360 K = 6.28 * X% / 640: FOR A = 1 TO N
370 Y = Y + A(A) * (1 + SIN(A * K + B(A)))
380 LINE (X%, 350 - Y)-(X%, 350 - DY), C%(A)
390 DY = Y
400 NEXT A, X%
410 FOR A = 1 TO 5000: NEXT A
420 GOTO 180
430 REM ********* RETURN TO MENU POSER
440 CLS
450 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
460 LOCATE 3, 26: COLOR 7: PRINT "1"
470 LOCATE 4, 26: PRINT "2"
480 A$ = INKEY$: IF A$ = "" THEN GOTO 480
490 IF A$ = "1" THEN CLEAR : RUN
500 IF A$ = "2" THEN CLS : SYSTEM
510 GOTO 480

