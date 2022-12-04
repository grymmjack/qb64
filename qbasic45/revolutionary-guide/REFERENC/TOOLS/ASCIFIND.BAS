10 REM ASCII FILE SEARCHER
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "ASCII FILE SEARCHER"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "     This utility is designed to search any ASCII file (although those in very  similar file types may work.) for certain piece of text. There is one flaw in"
120 PRINT "that a comma in the file sends the text to the next line. Any way it doesn't    detract from it at all so I'll shut up."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM
210 CLS
220 FLAG = 0: COUNT = 0
230 COLOR 4: LOCATE 5, 5: PRINT "ASCII FILE SEARCHER"
240 COLOR 8: LOCATE 6, 5: PRINT "-------------------"
250 COLOR 7: LOCATE 7, 5: INPUT "Enter ASCII filename :"; F$
260 IF F$ = "" OR LEN(F$) > 12 THEN GOTO 250
270 LOCATE 9, 5: INPUT "Enter text to search for :"; TEXT$
280 IF TEXT$ = "" OR LEN(TEXT$) > 40 THEN GOTO 270
290 OPEN F$ FOR INPUT AS #1
300 WHILE NOT EOF(1)
310 FLAG = FLAG + 1
320 INPUT #1, I$
330 IF INSTR(I$, TEXT$) <> 0 THEN COLOR 14: COUNT = COUNT + 1 ELSE COLOR 7
340 PRINT I$
350 IF FLAG = 24 THEN WHILE INKEY$ = "": WEND: FLAG = 0
360 WEND
370 CLOSE
380 PRINT : COLOR 4: PRINT "TEXT FOUND "; COUNT; " TIMES."
390 WHILE INKEY$ = "": WEND
400 REM ********* RETURN TO MENU POSER
410 CLS
420 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
430 LOCATE 3, 26: COLOR 7: PRINT "1"
440 LOCATE 4, 26: PRINT "2"
450 A$ = INKEY$: IF A$ = "" THEN GOTO 450
460 IF A$ = "1" THEN CLEAR : RUN
470 IF A$ = "2" THEN CLS : SYSTEM
480 GOTO 450

