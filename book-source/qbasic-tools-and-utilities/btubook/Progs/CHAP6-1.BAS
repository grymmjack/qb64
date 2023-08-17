'*********** CHAP6-1.BAS - shows how to direct printed output

'Copyright (c) 1992 Ethan Winer

PRINT "Printer, Screen, or File? (P/S/F): ";

DO
  Choice$ = UCASE$(INKEY$)
LOOP UNTIL INSTR(" PSF", Choice$) > 1

IF Choice$ = "P" THEN
  Report$ = "LPT1:"
ELSEIF Choice$ = "S" THEN
  Report$ = "SCRN:"
ELSE
  PRINT
  LINE INPUT "Enter a file name: ", Report$
END IF

OPEN Report$ FOR OUTPUT AS #1
  PRINT #1, Header$
  PRINT #1, SomeStuff$
  PRINT #1, MoreStuff$
    ...
    ...
  CLOSE #1
END
