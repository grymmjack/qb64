10 REM ASCII TO BASIC FILE CONVERSION
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM DAT$(5000)
70 SCREEN 9: CLS
80 A$ = "ASCII TO BASIC FILE CONVERSION"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "     This very useful file is of use to many people not just programmers, it    converts ANY ASCII file into a BASIC program. It can place the data into either"
130 PRINT "DATA statements or into PRINT statements to be output to the screen."
140 RAND = 0
150 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
160 A$ = ""
170 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 170
180 RAND = RAND - VAL(RIGHT$(TIME$, 2))
190 RANDOMIZE RAND
200 REM ********* STARTING SCREEN AND FILENAME ROTUINE
210 CLS
220 COLOR 9: LOCATE 2, 3: PRINT "ASCII to BASIC file conversions"
230 LINE (15, 26)-(263, 26), 1
240 LINE (20, 28)-(258, 28), 1
250 COLOR 9: LOCATE 4, 3: PRINT "Enter the filename of the file which you want to convert, please include the"
260 INPUT "full path name and extensions : "; F$
270 IF F$ = "" OR LEN(F$) > 40 THEN GOTO 260
280 PRINT
290 PRINT "   The file must be ASCII and the new BASIC file will have the above name but"
300 PRINT "with the .BAS extension."
310 PRINT
320 PRINT "ARE YOU SURE (Y)es or (N)o ?"
330 A$ = INKEY$: IF A$ = "" THEN GOTO 330
340 IF A$ = "Y" OR A$ = "y" THEN GOTO 370
350 IF A$ = "N" OR A$ = "n" THEN RUN
360 GOTO 330
370 REM ********** TYPE OF BASIC FILE TO BE CREATED
380 PRINT : PRINT "Do you want the data to be placed into (D)ata or (P)rint statements ?"
390 A$ = ""
400 A$ = INKEY$: IF A$ = "" THEN 400
410 IF A$ = "D" OR A$ = "d" THEN STATE$ = "DATA ": GOTO 440
420 IF A$ = "P" OR A$ = "p" THEN STATE$ = "PRINT " + CHR$(34): GOTO 440
430 GOTO 400
440 REM ********** CONVERT FILE
450 PRINT : PRINT "Reading file to memory"
460 A = 0
470 OPEN F$ FOR INPUT AS #1
480 WHILE NOT EOF(1)
490 A = A + 1
500 INPUT #1, A$
510 DAT$(A) = A$
520 WEND
530 CLOSE
540 PRINT : PRINT "Writing new file to disk"
550 D = INSTR(F$, ".")
560 IF D = 0 THEN F$ = F$ + ".BAS"
570 IF D > 0 THEN F$ = LEFT$(F$, D - 1) + ".BAS"
580 OPEN F$ FOR OUTPUT AS #1
590 FOR B = 1 TO A
600 C = B * 10
610 PRINT #1, C; STATE$; DAT$(B);
620 IF RIGHT$(STATE$, 1) = CHR$(34) THEN PRINT #1, CHR$(34) ELSE PRINT #1, ""
630 NEXT B
640 CLOSE
650 PRINT : PRINT "The file "; F$; " has been created."
660 WHILE INKEY$ = "": WEND
670 REM ********* RETURN TO MENU POSER
680 CLS
690 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
700 LOCATE 3, 26: COLOR 7: PRINT "1"
710 LOCATE 4, 26: PRINT "2"
720 A$ = INKEY$: IF A$ = "" THEN GOTO 720
730 IF A$ = "1" THEN CLEAR : RUN
740 IF A$ = "2" THEN CLS : SYSTEM
750 GOTO 720

