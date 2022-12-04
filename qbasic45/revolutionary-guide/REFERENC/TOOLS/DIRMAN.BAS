10 REM DIRECTORY MANAGER
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 ON ERROR GOTO 810
70 SCREEN 9: CLS
80 VIEW PRINT 1 TO 24
90 A$ = "DIRECTORY MANAGER"
100 COLOR 2
110 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
120 COLOR 10
130 COLOR 10: LOCATE 5, 1: PRINT "This program shows how file and directory data can be handled by GW-BASIC.  The program demonstrates the simple directory manipulation commands.   Please note  that problems will occur should directories contain a large"
140 PRINT "number of files and make a mess of the screen and program."
150 RAND = 0
160 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
170 A$ = ""
180 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 180
190 RAND = RAND - VAL(RIGHT$(TIME$, 2))
200 RANDOMIZE RAND
210 REM
220 CLS
230 VIEW PRINT 6 TO 24
240 COLOR 14
250 PRINT : PRINT "                             Current Directory"
260 PRINT
270 COLOR 7
280 FILES
290 VIEW PRINT 1 TO 5
300 COLOR 10: PRINT STRING$(80, "°");
310 PRINT "°° "; : COLOR 14: PRINT "                          Directory Manager                                "; : COLOR 10: PRINT "°°";
320 PRINT "°°                                                                            °°";
330 PRINT "°°   "; : COLOR 7: PRINT "(C)hange directory (M)ake new directory (D)elete a directory e(X)it     "; : COLOR 10: PRINT " °°";
340 PRINT STRING$(80, "°");
350 A$ = INKEY$: IF A$ = "" THEN GOTO 350
360 IF A$ = "C" OR A$ = "c" THEN GOTO 410
370 IF A$ = "M" OR A$ = "m" THEN GOTO 510
380 IF A$ = "D" OR A$ = "d" THEN GOTO 610
390 IF A$ = "X" OR A$ = "x" THEN GOTO 710
400 GOTO 350
410 REM ##### CHANGE DIRECTORY
420 VIEW PRINT 1 TO 24
430 COLOR 10: PRINT STRING$(80, "°");
440 PRINT "°° "; : COLOR 14: PRINT "                            Change Directory                               "; : COLOR 10: PRINT "°°";
450 PRINT "°°                                                                            °°";
460 PRINT "°°                                                                            °°";
470 PRINT STRING$(80, "°");
480 LOCATE 4, 4: INPUT "Enter full path : "; PATH$
490 CHDIR PATH$
500 GOTO 220
510 REM ##### MAKE NEW DIRECTORY
520 VIEW PRINT 1 TO 24
530 COLOR 10: PRINT STRING$(80, "°");
540 PRINT "°° "; : COLOR 14: PRINT "                            Create Directory                               "; : COLOR 10: PRINT "°°";
550 PRINT "°°                                                                            °°";
560 PRINT "°°                                                                            °°";
570 PRINT STRING$(80, "°");
580 LOCATE 4, 4: INPUT "Enter full path : "; PATH$
590 MKDIR PATH$
600 GOTO 220
610 REM ##### DELETE A DIRECTORY
620 VIEW PRINT 1 TO 24
630 COLOR 10: PRINT STRING$(80, "°");
640 PRINT "°° "; : COLOR 14: PRINT "                            Delete Directory                               "; : COLOR 10: PRINT "°°";
650 PRINT "°°                                                                            °°";
660 PRINT "°°                                                                            °°";
670 PRINT STRING$(80, "°");
680 LOCATE 4, 4: INPUT "Enter full path : "; PATH$
690 RMDIR PATH$
700 GOTO 220
710 REM ##### EXIT FROM FILE MANAGER
720 VIEW PRINT 1 TO 24
730 COLOR 10: PRINT STRING$(80, "°");
740 PRINT "°° "; : COLOR 14: PRINT "                            Exit from Manager                              "; : COLOR 10: PRINT "°°";
750 PRINT "°°                                                                            °°";
760 PRINT "°°                                                                            °°";
770 PRINT STRING$(80, "°");
780 LOCATE 4, 4: INPUT "Are you sure : "; PATH$
790 IF LEFT$(PATH$, 1) = "Y" OR LEFT$(PATH$, 1) = "y" THEN SYSTEM
800 GOTO 810
810 REM ##### AN ERROR HAS OCCURRED #####
820 BEEP
830 VIEW PRINT 1 TO 24
840 GOTO 220

