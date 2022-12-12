10 REM ETCH A SKETCH
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "ETCH-A-SKETCH"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "   Etch a sketch is a classic drawing tool for kids and it can be so easily     reproduced on a computer screen in a small BASIC program."
120 PRINT "   Use the W,S,O,P keys to move the pixel around and the C key will clear the   screen, the Q key will quit the program. The actual code is quite advanced, as  the registered users will be able to see, but not unfathomable."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 CLS
220 COLOR 15: LOCATE 1, 1: PRINT "Press Q to quit program": PRINT "Press C to clear the screen": PRINT "Use the W,S,O,P TO move around"
230 RESTORE 380
240 FOR J = 2 TO 5
250 READ A(J), B(J)
260 NEXT J
270 X = 320: Y = 150
280 PSET (X, Y), 15
290 A$ = " WPSOQC"
300 WHILE -1
310 D = INSTR(A$, INKEY$)
320 IF D = 6 THEN GOTO 390
330 IF D = 7 THEN 210
340 X = (X + A(D)) AND 511
350 Y = (Y + B(D)) AND 255
360 LINE -(X, Y), 15
370 WEND
380 DATA 0,-2,2,0,0,2,-2,0
390 REM ********* RETURN TO MENU POSER
400 CLS
410 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
420 LOCATE 3, 26: COLOR 7: PRINT "1"
430 LOCATE 4, 26: PRINT "2"
440 A$ = INKEY$: IF A$ = "" THEN GOTO 440
450 IF A$ = "1" THEN CLEAR : RUN
460 IF A$ = "2" THEN CLS : SYSTEM
470 GOTO 440

