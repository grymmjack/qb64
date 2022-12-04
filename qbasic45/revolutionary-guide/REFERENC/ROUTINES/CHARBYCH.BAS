10 REM CHARACTER BY CHARACTER PRINTING
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "CHARACTER BY CHARACTER PRINTING"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "   This is a neat and stylish effect of  printing text on a screen. Instead of  using the PRINT command this easily used method provides a novel alternative."
120 PRINT "It can be used to simulate a typewriter for instance, or even a telegraph - the routine can be speeded up but it loses the beeping effect."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 TEXT$ = "This is an example string of character by character printing to the screen. The routine takes a string (i.e. A$ or TEXT$ etc.) and prints out each character in ": GOSUB 240
220 TEXT$ = "turn. This method coupled with a tiny beep is a neat way to emulate a simple    typewriter on screen.": GOSUB 240
230 GOTO 310
240 REM THIS IS THE ROUTINE BIT
250 FOR A = 1 TO LEN(TEXT$)
260 PRINT MID$(TEXT$, A, 1);
270 FOR SPEED = 1 TO 200: NEXT SPEED
280 IF MID$(TEXT$, A, 1) <> " " THEN SOUND 45, .05
290 NEXT A
300 RETURN
310 REM ********* RETURN TO MENU POSER
320 WHILE INKEY$ = "": WEND
330 CLS
340 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
350 LOCATE 3, 26: COLOR 7: PRINT "1"
360 LOCATE 4, 26: PRINT "2"
370 A$ = INKEY$: IF A$ = "" THEN GOTO 370
380 IF A$ = "1" THEN CLEAR : RUN
390 IF A$ = "2" THEN CLS : SYSTEM
400 GOTO 370

