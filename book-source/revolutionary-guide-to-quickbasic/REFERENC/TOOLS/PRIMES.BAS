10 REM PRIME NUMBER GENERATOR
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM P(10000)
70 SCREEN 9: CLS
80 A$ = "PRIME NUMBER GENERATOR"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "   This little program shows the mathematics capabilities possible with such a  short program. It generates the first 7000 prime numbers. It does take a long   while to complete."
130 PRINT "   There is an option after they have all been printed for them all to be saved to a file which will be called PRIMES. in the current directory."
140 PRINT "   To save you time, we have already included the first 1000 on your disk."
150 PRINT "On the disk there is a program that checks whether any specified   number is a prime number. Useful (Hmm.)"
160 RAND = 0
170 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
180 A$ = ""
190 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 190
200 RAND = RAND - VAL(RIGHT$(TIME$, 2))
210 RANDOMIZE RAND
220 REM
230 CLS
240 P(0) = 1: P(1) = 2: P(2) = 3
250 FOR N = 3 TO 7000
260 P(N) = P(N - 1)
270 FLAG = 0
280 WHILE FLAG = 0
290 FLAG = 1
300 P(N) = P(N) + 2
310 S = SQR(P(N))
320 M = 0
330 WHILE FLAG * (P(M + 1) <= S)
340 M = M + 1
350 D = P(N) / P(M)
360 FLAG = D - INT(D)
370 WEND
380 WEND
390 PRINT N, P(N)
400 NEXT N
410 PRINT "Do you want to write all these to a file (Y)es or (N)o ?"
420 A$ = INKEY$: IF A$ = "" THEN 420
430 IF A$ = "Y" OR A$ = "y" THEN GOTO 460
440 IF A$ = "N" OR A$ = "n" THEN GOTO 510
450 GOTO 420
460 OPEN "PRIMES" FOR OUTPUT AS #1
470 FOR A = 1 TO 7000
480 PRINT #1, P(A)
490 NEXT A
500 CLOSE
510 REM ********* RETURN TO MENU POSER
520 CLS
530 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
540 LOCATE 3, 26: COLOR 7: PRINT "1"
550 LOCATE 4, 26: PRINT "2"
560 A$ = INKEY$: IF A$ = "" THEN GOTO 560
570 IF A$ = "1" THEN CLEAR : RUN
580 IF A$ = "2" THEN CLS : SYSTEM
590 GOTO 560

