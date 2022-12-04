10 REM RADAR
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM                                                                      
60 SCREEN 9: CLS
70 A$ = "RADAR"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "This radar scanner is just a slow circle routine  that shows how simple graphicstechniques can produce quite good (but slow) results.   The border is obligatoryand the various factors in the scan can be modified quite easily"
120 PRINT " with a bit of patience.   A good basis for some sort of ssslllooowww game! me   thinks."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM ##### END OF STANDARD SECTION #####
200 CLS
210 FOR A = 106 TO 320 STEP 3
220 CIRCLE (320, 175), A, 7
230 NEXT A
240 A% = 1
250 WHILE INKEY$ = ""
260 A% = A% + 1: IF A% > 25 THEN A% = 1
270 PSET (320, 175), 15
280 FOR B% = 1 TO 4
290 CIRCLE (320, 175), A% + ((B% - 1) * 25) - 1, 0
300 CIRCLE (320, 175), A% + ((B% - 1) * 25), 15
310 NEXT B%
320 WEND
330 REM ********* RETURN TO MENU POSER
340 CLS
350 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
360 LOCATE 3, 26: COLOR 7: PRINT "1"
370 LOCATE 4, 26: PRINT "2"
380 A$ = INKEY$: IF A$ = "" THEN GOTO 380
390 IF A$ = "1" THEN CLEAR : RUN
400 IF A$ = "2" THEN CLS : SYSTEM
410 GOTO 380

