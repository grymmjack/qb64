REM COM2BAS

DEFINT A-Z

REM  This utility reads a binary file and writes a file
REM     with QBasic DATA statements and load and call routines

CLS
PRINT "COM2BAS      Copyright 1995 F.A. Gregory "
PRINT

OK$ = " "
DO UNTIL (OK$ = "Y" OR OK$ = "Q")
   GOSUB GetUserInput
   LOOP

IF (OK$ = "Q") THEN
   SYSTEM
   END IF

GOSUB Openfiles
IF (OK$ = "N") THEN
   SYSTEM
   END IF

GOSUB WriteBas
GOSUB ProcessComFile
GOSUB Closefiles
SYSTEM


Openfiles:

OK$ = "Y"
OPEN comfile$ FOR BINARY AS #1 LEN = 1
IF LOF(1) = 0 THEN
   CLOSE #1
   PRINT comfile$; " is empty"
   OK$ = "N"
   END IF
  
IF OK$ = "Y" THEN
   OPEN basfile$ FOR OUTPUT AS #2
   END IF

RETURN


WriteBas:

arraysize = INT((LOF(1) + 1) / 2)

PRINT #2, "DEFINT A-Z"
PRINT #2, ""
PRINT #2, "GOSUB Load"; progname$; ""
PRINT #2, ""
PRINT #2, "GOSUB Call"; progname$; ""
PRINT #2, ""
PRINT #2, "END"
PRINT #2, ""
PRINT #2, "Load"; progname$; ":"
PRINT #2, "DIM "; progname$; "("; arraysize; ")"
PRINT #2, "DEF SEG = VARSEG("; progname$; "(0))"
PRINT #2, "FOR i = 0 TO "; (LOF(1) - 1); ""
PRINT #2, "READ j"
PRINT #2, "POKE (VARPTR("; progname$; "(0)) + i), j"
PRINT #2, "NEXT i"
PRINT #2, "DEF SEG"
PRINT #2, "RETURN"
PRINT #2, ""
PRINT #2, "Call"; progname$; ":"
PRINT #2, "DEF SEG=VARSEG("; progname$; "(0))"
PRINT #2, "rem CALL ABSOLUTE (,,VARPTR("; progname$; "(0)))"
PRINT #2, "DEF SEG"
PRINT #2, "RETURN"
PRINT #2, ""

PRINT #2, ""

RETURN

ProcessComFile:
   
com$ = SPACE$(1)
PRINT
PRINT "COM file length = "; LOF(1)
PRINT #2, "DATA ";
j = 1
FOR i = 1 TO LOF(1)
        
  GET #1, , com$
  h$ = RIGHT$("0" + HEX$(ASC(com$)), 2)
  PRINT #2, "&H"; h$;
  
  IF j = 8 AND i <> LOF(1) THEN
     PRINT #2, ""
     PRINT #2, "DATA ";
     j = 0
     ELSE
       IF i <> LOF(1) THEN
          PRINT #2, ",";
          END IF
    END IF
j = j + 1
NEXT i
PRINT #2, ""
RETURN

Closefiles:

CLOSE
RETURN

GetUserInput:

GOSUB GetFilenames
DO UNTIL (OK$ = "Y" OR OK$ = "N" OR OK$ = "Q")
   GOSUB GetOK
   LOOP

RETURN

GetFilenames:
OK$ = " "
PRINT "COM file name";
INPUT comfile$
REM PRINT "BAS file name (sample.bas)";
REM INPUT basfile$
progname$ = comfile$
comfile$ = progname$ + ".com"
PRINT
basfile$ = progname$ + ".bas"
PRINT "COM file="; comfile$; "  "; "BAS file="; basfile$
PRINT

RETURN

GetOK:

PRINT "OK (enter Y or N, Q to quit)";
INPUT OK$
IF OK$ = "y" THEN
   OK$ = "Y"
   END IF
IF OK$ = "n" THEN
   OK$ = "N"
   END IF
IF OK$ = "q" THEN
   OK$ = "Q"
   END IF

RETURN



