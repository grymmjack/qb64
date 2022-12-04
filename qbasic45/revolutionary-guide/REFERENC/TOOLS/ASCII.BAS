10 REM ASCII TABLE
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 DIM A$(35)
70 SCREEN 9: CLS
80 A$ = "ASCII TABLE"
90 COLOR 2
100 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
110 COLOR 10
120 COLOR 10: LOCATE 5, 1: PRINT "    This is an additional program which displays the ASCII code on the screen.  The American Standard Code for Information Interchange is a standard code for"
130 PRINT "data. The first 128 numbers are industry standard, and the remaining 128-256 areused to represent differences between machines. All numbers are displayed here."
140 PRINT "    An individual's decimal code number can be found by taking the number of thecolumn it is in and multiplying that by 16 - and then adding the row number."
150 PRINT "    For example the letter A is in the 4th column and Row 1. So 4*16+1=65. Thus the ASCII code for the character A is 65."
170 RAND = 0
180 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
190 A$ = ""
200 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 200
210 RAND = RAND - VAL(RIGHT$(TIME$, 2))
220 RANDOMIZE RAND
230 REM
240 CLS
250 COLOR 12: LOCATE 2, 34: PRINT "ASCII  TABLE"
260 COLOR 15: LOCATE 5, 1: PRINT " DIGITS    -0     -1     -2  -3  -4  -5  -6  -7  -8  -9  -A  -B  -C  -D  -E  -F"
270 FOR A = 6 TO 21: LOCATE A, 3: PRINT A - 6: NEXT A
280 FOR A = 0 TO 31: READ A$(A): NEXT A
290 DATA NUL,SOH,STX,ETX,EOT,ENQ,ACK,BEL,BS,HT,LF,VT,FF,CR,SO,SI,DLE,DC1,DC2,DC3,DC4,NAK,SYN,ETB,CAN,EM,SUB,ESC,FS,GS,RS,US
300 COLOR 7: FOR A = 6 TO 21: LOCATE A, 12: PRINT A$(A - 6): LOCATE A, 19: PRINT A$((A - 6) + 16): NEXT A
310 FOR A = 0 TO 15
320 FOR B = 0 TO 15
330 LOCATE B + 6, ((A + 1) * 4) + 15
340 IF (A * 16) + B + 1 > 31 AND A * 16 + B + 1 < 256 THEN PRINT CHR$(A * 16 + B);
350 NEXT B, A
360 WHILE INKEY$ = "": WEND
370 CLEAR : RUN

