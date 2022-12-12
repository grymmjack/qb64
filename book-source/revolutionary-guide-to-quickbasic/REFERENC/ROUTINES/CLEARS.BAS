10 REM SCREEN CLEARING ROUTINES
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "SCREEN CLEARING ROUTINES"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    Clearing the screen, is something we ALL take for granted, however there areother ways, much prettier and albeit slower than the standard routine. This"
120 PRINT "program is designed to show you some other ways of clearing the screen, with    some nice effects."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 REM THE NORMAL BORING CLS
210 CLS
220 A$ = "The normal boring CLS": GOSUB 540
230 CLS
240 REM THE DOUBLE HORIZONTAL CLOSING LINES
250 A$ = "The double horizontal closing lines routine": GOSUB 540
260 FOR A = 0 TO 175
270 LINE (0, A)-(640, A), 0
280 LINE (0, 350 - A)-(640, 350 - A), 0
290 NEXT A
300 REM THEN MOVING CURTAINS ROUTINE
310 A$ = "The classy closing curtains routine": GOSUB 540
320 FOR A = 0 TO 319
330 LINE (A, 1)-(A, 350), 15
340 LINE (A - 1, 1)-(A - 1, 350), 0
350 LINE (640 - A, 1)-(640 - A, 350), 15
360 LINE (641 - A, 1)-(641 - A, 350), 0
370 NEXT A
380 REM THE SCROLL UP ROUTINE
390 CLS
400 A$ = "The speedy scroll up routine": GOSUB 540
410 LOCATE 24, 1
420 FOR A = 1 TO 24: PRINT CHR$(13): NEXT A
430 REM THE PILLAR BOX ROUTINE
440 A$ = "The pillar box routine": GOSUB 540
450 FOR A = 0 TO 175
460 LINE (A, A)-(640 - A, 350 - A), 0, B
470 NEXT A
480 REM THE SCREEN FILL ROUTINE
490 A$ = "The screen fill routine": GOSUB 540
500 FOR A = 0 TO 320
510 LINE (320 - A, 175 - A)-(320 + A, 175 + A), 0, B
520 NEXT A
530 GOTO 660
540 REM FILL SCREEN WITH GARBAGE ROUTINE
550 COL = INT(RND * 9) + 4
560 FOR A = 1 TO 400
570 COL1 = COL + RND * 2 - RND * 2
580 COLOR COL1
590 LOCATE INT(RND * 23) + 1, INT(RND * 79) + 1
600 PRINT CHR$(INT(RND * 200) + 32);
610 NEXT A
620 LOCATE 2, (80 - LEN(A$)) / 2: COLOR 15: PRINT A$
630 COLOR 15: LOCATE 23, 1: PRINT "Press any key to clear screen"
640 WHILE INKEY$ = "": WEND
650 RETURN
660 REM ********* RETURN TO MENU POSER
670 CLS
680 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
690 LOCATE 3, 26: COLOR 7: PRINT "1"
700 LOCATE 4, 26: PRINT "2"
710 A$ = INKEY$: IF A$ = "" THEN GOTO 710
720 IF A$ = "1" THEN CLEAR : RUN
730 IF A$ = "2" THEN CLS : SYSTEM
740 GOTO 710

