10 REM CALENDAR MAKER
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "CALENDAR MAKER"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "     This program calculates and prints (to the screen or to the printer) a fullyear's calendar for any year this century. Working out from complex routines it"
120 PRINT "then proceeds to print out the output in a traditional format."
130 RAND = 0
140 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
150 A$ = ""
160 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 160
170 RAND = RAND - VAL(RIGHT$(TIME$, 2))
180 RANDOMIZE RAND
190 REM
200 CLS
210 COLOR 10: PRINT "CALENDAR MAKER"
220 COLOR 2: PRINT "              "
230 PRINT : COLOR 10: INPUT "Enter the twentieth century year (e.g. 92 or 45 etc.) :"; Y%
240 IF Y% < 0 OR Y% > 99 THEN GOTO 200
250 PRINT : INPUT "Do you want the calendar to be sent to the (P)rinter or (S)creen :"; OU$
260 IF OU$ <> "P" AND OU$ <> "S" THEN GOTO 200
270 DIM DAY$(7), MONTH$(12), DAY%(12), MONTH%(12), OFFSET%(12)
280 FOR I% = 1 TO 7: READ DAY$(I%): NEXT I%
290 FOR I% = 1 TO 12: READ MONTH$(I%), DAY%(I%), OFFSET%(I%): NEXT I%
300 DATA SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
310 DATA JANUARY, 31, 0, FEBRUARY, 28, 3, MARCH, 31, 3, APRIL, 30, 6
320 DATA MAY, 31, 1, JUNE, 30, 4, JULY, 31, 6, AUGUST, 31, 2
330 DATA SEPTEMBER, 30, 5, OCTOBER, 31, 0, NOVEMBER, 30, 3, DECEMBER, 31, 5
340 FOR I% = 1 TO 12: D% = INT(Y% / 4) + Y% + OFFSET%(I%) + 2: CLS
350 R = Y% - 4
360 IF R > 3 THEN R = R - 4: GOTO 360
370 IF R = 0 AND I% < 3 THEN D% = D% - 1: DAY%(2) = 29
380 IF D% > 7 THEN D% = D% - 7: GOTO 380
390 MONTH%(I%) = D% - (2 * D%): NEXT I%
400 IF OU$ = "S" THEN PRINT TAB(30); "CALENDAR "; STR$(Y% + 1900)
410 IF OU$ = "P" THEN LPRINT TAB(30); "CALENDAR "; STR$(Y% + 1900)
420 IF OU$ = "S" THEN GOTO 500 ELSE GOTO 430
430 FOR I% = 1 TO 11 STEP 2
440 LPRINT TAB(10); MONTH$(I%); TAB(50); MONTH$(I% + 1)
450 FOR J% = 1 TO 7: FOR M% = 0 TO 1: IF M% = 0 THEN P% = 1 ELSE P% = 41
460 LPRINT TAB(P%); DAY$(J%); : N% = MONTH%(I% + M%) + J% + 1
470 FOR K% = 0 TO 6: IF N% > 0 AND N% < DAY%(I% + M%) + 1 THEN LPRINT TAB(P% + 10 + (K% * 4)); N%;
480 N% = N% + 7: NEXT: NEXT: LPRINT : NEXT: LPRINT : NEXT
490 GOTO 590
500 REM ********************* TO THE SCREEN
510 FOR I% = 1 TO 11 STEP 2
520 IF I% = 5 OR I% = 9 THEN WHILE INKEY$ = "": WEND
530 PRINT TAB(10); MONTH$(I%); TAB(50); MONTH$(I% + 1)
540 FOR J% = 1 TO 7: FOR M% = 0 TO 1: IF M% = 0 THEN P% = 1 ELSE P% = 41
550 PRINT TAB(P%); DAY$(J%); : N% = MONTH%(I% + M%) + J% + 1
560 FOR K% = 0 TO 6: IF N% > 0 AND N% < DAY%(I% + M%) + 1 THEN PRINT TAB(P% + 10 + (K% * 4)); N%;
570 N% = N% + 7: NEXT: NEXT: PRINT : NEXT: PRINT : NEXT
580 WHILE INKEY$ = "": WEND
590 REM ********* RETURN TO MENU POSER
600 CLS
610 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
620 LOCATE 3, 26: COLOR 7: PRINT "1"
630 LOCATE 4, 26: PRINT "2"
640 A$ = INKEY$: IF A$ = "" THEN GOTO 640
650 IF A$ = "1" THEN CLEAR : RUN
660 IF A$ = "2" THEN CLS : SYSTEM
670 GOTO 640

