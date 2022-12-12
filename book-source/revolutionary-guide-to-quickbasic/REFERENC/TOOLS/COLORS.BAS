10 REM BASIC SCREEN COLOUR CHART
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM C$(15)
70 SCREEN 9: CLS
80 A$ = "BASIC SCREEN COLOUR CHART"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "     There are 16 colours available to BASIC users, these being those numbered  0 (zero) to 15 (fifteen). Many colour charts often state incorrect colour labels";
130 PRINT "for example one BASIC programming book states that colour number 8 (Dark     Grey) is Green. This actual software program shows you the colours alongside    their 'appropriate' name."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 CLS
220 COLOR 15: LOCATE 2, 32: PRINT "THE COLOUR CHART"
230 FOR A = 0 TO 15
240 READ C$(A)
250 IF A > 0 THEN COLOR A ELSE COLOR 7
260 LOCATE A + 4, 5: PRINT A: IF A > 0 THEN LOCATE A + 4, 11: PRINT "лллллллллллллл"
270 IF A > 0 THEN COLOR A ELSE COLOR 7
280 LOCATE A + 4, 30: PRINT C$(A)
290 NEXT A
300 DATA Jet Black,Dark Blue,Darkish Green,Cyan or Light Bluey
310 DATA Darkish Red,Magenta or Bright Purple,Brown or Orange (?)
320 DATA White (?) or Light Grey,Dark Grey,Bright Light Blue
330 DATA Pale Light Green,Bright Light Cyan or Very Pale Blue
340 DATA Pale Red,Pale Bright Pink,Plain Bright Yellow
350 DATA Bright White
360 WHILE INKEY$ = "": WEND
370 REM ********* RETURN TO MENU POSER
380 CLS
390 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
400 LOCATE 3, 26: COLOR 7: PRINT "1"
410 LOCATE 4, 26: PRINT "2"
420 A$ = INKEY$: IF A$ = "" THEN GOTO 420
430 IF A$ = "1" THEN CLEAR : RUN
440 IF A$ = "2" THEN CLS : SYSTEM
450 GOTO 420

