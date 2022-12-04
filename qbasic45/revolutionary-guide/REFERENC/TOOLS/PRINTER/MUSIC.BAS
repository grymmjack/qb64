10 REM MANUSCRIPT PRINTING
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "Manuscript Paper"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "   This little program prints out a page of manuscript paper, consisting of     ten staves each of five lines. This program was written with Epson or a         compatible printer in mind."
120 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
130 A$ = ""
140 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 140
150 RAND = RAND - VAL(RIGHT$(TIME$, 2))
160 RANDOMIZE RAND
170 REM
180 LPRINT CHR$(27); CHR$(49);
190 LPRINT CHR$(27); CHR$(45); CHR$(1);
200 LPRINT CHR$(27); CHR$(69);
210 GOSUB 310
220 FOR STAVE = 1 TO 10
230 FOR LINES = 1 TO 5
240 LPRINT "                                                                               "
250 NEXT LINES
260 GOSUB 310
270 NEXT STAVE
280 LPRINT CHR$(12);
290 LPRINT CHR$(27); CHR$(64);
300 GOTO 350
310 FOR SPACE = 1 TO 5
320 LPRINT
330 NEXT SPACE
340 RETURN
350 REM ********* RETURN TO MENU POSER
360 CLS
370 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
380 LOCATE 3, 26: COLOR 7: PRINT "1"
390 LOCATE 4, 26: PRINT "2"
400 A$ = INKEY$: IF A$ = "" THEN GOTO 400
410 IF A$ = "1" THEN CLEAR : RUN
420 IF A$ = "2" THEN CLS : SYSTEM
430 GOTO 400

