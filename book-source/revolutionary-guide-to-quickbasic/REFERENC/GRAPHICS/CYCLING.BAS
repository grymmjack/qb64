10 REM COLOUR CYCLING : THE FAST METHOD
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM                                                                      
60 SCREEN 9: CLS
70 A$ = "COLOUR CYCLING : THE FAST METHOD"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "Colour cycling is a frequently used method for highlighting parts of the screen quit effectively.  Most people though, use the inefficient method to do this."
120 PRINT "Most print the same area (be it text or graphics) again identically but in a    different colour.  A better and faster method is to use the PALETTE command.    This way, just colour the section of the screen you wish to be cycled in a "
130 PRINT "certain but different colour.  You then place your palette command in a loop.   Very efficient.   Press a key to switch between them or press 'C' for a         comparison."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM ##### END OF STANDARD SECTION #####
210 CLS
220 FOR A = 1 TO 24: COLOR 4: LOCATE A, 1: PRINT STRING$(79, "²"): NEXT A
230 FOR A = 5 TO 20: COLOR 12: LOCATE A, 5: PRINT STRING$(30, "²"): NEXT A
240 FOR A = 5 TO 20: COLOR 12: LOCATE A, 45: PRINT STRING$(30, "²"): NEXT A
250 COLOR 15: LOCATE 3, 13: PRINT "METHOD : REPRINT"
260 COLOR 15: LOCATE 3, 52: PRINT "METHOD : PALETTE"
270 WHILE INKEY$ = ""
280 FOR B = 1 TO 15
290 FOR A = 5 TO 20: COLOR B: LOCATE A, 5: PRINT STRING$(30, "²"): NEXT A
300 NEXT B
310 WEND
320 IF INKEY$ = "C" OR INKEY$ = "c" THEN GOTO 380
330 WHILE INKEY$ = ""
340 PALETTE 12, RND * 62 + 1
350 WEND
360 IF INKEY$ = "C" OR INKEY$ = "c" THEN GOTO 380
370 GOTO 270
380 REM ##### COMPARISON #####
390 LOCATE 7, 7: COLOR 15: PRINT "FORS"
400 LOCATE 7, 47: COLOR 15: PRINT "FORS"
410 LOCATE 9, 7: PRINT "Effective"
420 LOCATE 10, 7: PRINT "Smooth"
430 LOCATE 11, 7: PRINT "Distinguishable"
440 LOCATE 9, 47: PRINT "Fast"
450 LOCATE 10, 47: PRINT "Indistinguishable"
460 LOCATE 11, 47: PRINT "Eye-catching"
470 LOCATE 13, 7: PRINT "AGAINST"
480 LOCATE 13, 47: PRINT "AGAINST"
490 LOCATE 15, 7: PRINT "Slow"
500 LOCATE 15, 47: PRINT "Too fast (but can be slowed)"
510 LOCATE 16, 47: PRINT "Indistinguishable"
520 WHILE INKEY$ = "": WEND
530 GOTO 270
540 REM ********* RETURN TO MENU POSER
550 ' When in your favourite program make sure all line numbers are below
560 ' 60000 and then type MERGE "ADD" to merge in this program to yours
570 ' And hey presto you have a neat menu system at the end of your program
580 CLS
590 COLOR 14: LOCATE 1, 22: PRINT "End of program flow control"
600 COLOR 7: LOCATE 3, 1: PRINT "          Do you want to 1. Run again or"
610 PRINT "                         2. Exit back to DOS"
620 LOCATE 3, 26: COLOR 12: PRINT "1"
630 LOCATE 4, 26: PRINT "2"
640 A$ = INKEY$: IF A$ = "" THEN GOTO 640
650 IF A$ = "1" THEN CLEAR : RUN
660 IF A$ = "2" THEN CLS : SYSTEM
670 GOTO 640

