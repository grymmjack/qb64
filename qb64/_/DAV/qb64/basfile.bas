'==================
' BASFILE.BAS v0.10
'==================
'Coded by Dav for QB64 (c) 2009

'BASFILE helps you include binary files INSIDE your QB64 compiled programs.
'It does this by converting file to BAS code that you add to your program
'that will recreate the file when you wish to use it.

'BASFILE will ask you for a file to convert, and will output the BAS code.

'=========================================================================

DEFINT A-Z
DECLARE FUNCTION E$ (B$)

PRINT
PRINT "============="
PRINT "BASFILE v0.10"
PRINT "============="
PRINT

INPUT "INPUT File --> ", IN$: IF IN$ = "" THEN END
INPUT "OUTPUT File -> ", OUT$: IF OUT$ = "" THEN END
OPEN IN$ FOR BINARY AS 1
IF LOF(1) = 0 THEN
    CLOSE : KILL IN$
    PRINT UCASE$(IN$); " not found!": END
END IF

OPEN OUT$ FOR OUTPUT AS 2
PRINT : PRINT "Encoding file...";

Q$ = CHR$(34) 'quotation mark
PRINT #2, "A$ = "; Q$; Q$
PRINT #2, "A$ = A$ + "; Q$;

DO
    a$ = INPUT$(3, 1)
    BC& = BC& + 3: LL& = LL& + 4
    IF LL& = 60 THEN
      LL& = 0
      PRINT #2, E$(a$); : PRINT #2, Q$
      PRINT #2, "A$ = A$ + "; Q$;
    ELSE
      PRINT #2, E$(a$);
    END IF
    IF LOF(1) - BC& < 3 THEN
      a$ = INPUT$(LOF(1) - BC&, 1): B$ = E$(a$)
      SELECT CASE LEN(B$)
        CASE 0: a$ = Q$
        CASE 1: a$ = "%%%" + B$ + Q$
        CASE 2: a$ = "%%" + B$ + Q$
        CASE 3: a$ = "%" + B$ + Q$
      END SELECT: PRINT #2, a$; : EXIT DO
    END IF
LOOP: PRINT #2, "" 

PRINT #2, "btemp$="; Q$; Q$
PRINT #2, "FOR i&=1TO LEN(A$) STEP 4:B$=MID$(A$,i&,4)"
PRINT #2, "IF INSTR(1,B$,"; Q$; "%"; Q$; ") THEN"
PRINT #2, "FOR C%=1 TO LEN(B$):F$=MID$(B$,C%,1)"
PRINT #2, "IF F$<>"; Q$; "%"; Q$; "THEN C$=C$+F$"
PRINT #2, "NEXT:B$=C$"
PRINT #2, "END IF:FOR t%=LEN(B$) TO 1 STEP-1"
PRINT #2, "B&=B&*64+ASC(MID$(B$,t%))-48"
PRINT #2, "NEXT:X$="; Q$; Q$; ":FOR t%=1 TO LEN(B$)-1"
PRINT #2, "X$=X$+CHR$(B& AND 255):B&=B&\256"
PRINT #2, "NEXT:btemp$=btemp$+X$:NEXT"
PRINT #2, "BASFILE$=btemp$:btemp$="; Q$; Q$
PRINT #2, "'==================================="
PRINT #2, "'EXAMPLE: SAVE BASFILE$ TO DISK"
PRINT #2, "'==================================="
PRINT #2, "'OPEN "; Q$; IN$; Q$; " FOR OUTPUT AS #1"
PRINT #2, "'PRINT #1, BASFILE$;"
PRINT #2, "'CLOSE #1"

PRINT "Done!"
PRINT UCASE$(OUT$); " saved."
END

FUNCTION E$ (B$)

FOR T% = LEN(B$) TO 1 STEP -1
     B& = B& * 256 + ASC(MID$(B$, T%))
NEXT

a$ = ""
FOR T% = 1 TO LEN(B$) + 1
     g$ = CHR$(48 + (B& AND 63)): B& = B& \ 64
     'If < and > are here, replace them with # and *
     'Just so there's no HTML tag problems with forums.
     'They'll be restored during the decoding process..
     'IF g$ = "<" THEN g$ = "#"
     'IF g$ = ">" THEN g$ = "*"
     a$ = a$ + g$
NEXT: E$ = a$

END FUNCTION