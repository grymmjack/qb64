10 REM EPSON PRINT STYLES
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 SCREEN 9: CLS
70 A$ = "EPSON PRINT STYLES"
80 COLOR 2
90 LOCATE 2, (80 - LEN(A$)) / 2: PRINT A$
100 COLOR 10
110 COLOR 10: LOCATE 5, 1: PRINT "    This program outputs to your EPSON compatible printer, standard codes for   the various modes and typefaces available through BASIC. The various commands"
120 PRINT "may vary greatly between different printers, but most of them should work on    nearly all dot matrix printers. Codes are given for switching each style on and off, if you are still unsure then you can look at the unprotected version of"
130 PRINT "this package (registered version) and glean what you want."
140 PRINT "    If some of the lines are of the same typeface then don't worry then there   are probably some different codes which create the desired effect, as outlined  probably in your printer's manual."
150 RAND = 0
160 LOCATE 20, 33: COLOR 12: PRINT "Press any key"
170 A$ = ""
180 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 180
190 RAND = RAND - VAL(RIGHT$(TIME$, 2))
200 RANDOMIZE RAND
210 REM
220 CLS
230 COLOR 1: PRINT "Press a key to print out the samples."
240 WHILE INKEY$ = "": WEND
250 LPRINT "This is the standard typeface or 'Pica' as it is sometimes known."
260 LPRINT
270 LPRINT CHR$(27); "M"; "This is the Mini typeface ON (ESC + M) OFF (ESC + P)."
280 LPRINT CHR$(27); "P"
290 LPRINT CHR$(27); "p"; CHR$(1); "This is the proportional typeface ON (ESC + p + 1) OFF (ESC + p + 0)"
300 LPRINT CHR$(27); "p"; CHR$(0)
310 LPRINT CHR$(15); "This is the condensed typeface ON (15) OFF (18)"
320 LPRINT CHR$(18)
330 LPRINT CHR$(27); "x"; CHR$(1); "This is the NLQ standard typeface ON (ESC + x + 1) OFF (ESC + x + 0)"
340 LPRINT CHR$(27); "x"; CHR$(0)
350 LPRINT CHR$(27); "S"; CHR$(1); "This is the subscript function ON (ESC + S + 1) OFF (ESC + T)"
360 LPRINT CHR$(27); "T"
370 LPRINT CHR$(27); "S"; CHR$(0); "This is the superscript function ON (ESC + S + 0) OFF (ESC + T)"
380 LPRINT CHR$(27); "T"
390 LPRINT CHR$(27); "G"; "This is the double strike option ON (ESC + G) OFF (ESC + H)"
400 LPRINT CHR$(27); "H"
410 LPRINT CHR$(27); "4"; "This is the italics style ON (ESC + 4) OFF (ESC + 5)"
420 LPRINT CHR$(27); "5"
430 LPRINT CHR$(27); "E"; "This is the function for bold text ON (ESC + E) OFF (ESC + F)"
440 LPRINT CHR$(27); "F"
450 LPRINT CHR$(27); "-"; CHR$(1); "This is the underlining feature ON (ESC + - + 1) OFF (ESC + - 0)"
460 LPRINT CHR$(27); "-"; CHR$(0)
470 LPRINT CHR$(27); "W"; CHR$(1); "This's double width ON (ESC + W + 1) OFF (ESC + W + 0)"
480 LPRINT CHR$(27); "W"; CHR$(0)
490 REM ********* RETURN TO MENU POSER
500 CLS
510 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to DOS ?."
520 LOCATE 3, 26: COLOR 7: PRINT "1"
530 LOCATE 4, 26: PRINT "2"
540 A$ = INKEY$: IF A$ = "" THEN GOTO 540
550 IF A$ = "1" THEN CLEAR : RUN
560 IF A$ = "2" THEN CLS : SYSTEM
570 GOTO 540

