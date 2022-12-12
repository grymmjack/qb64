
DEFINT A-Z

REM  Sample program to demonstrate a machine code subroutine that
REM    calls BIOS interrupt 05H to do a screen print.

PRINT
PRINT
PRINT
PRINT "This"
PRINT
PRINT "           is"
PRINT
PRINT "                      a"
PRINT
PRINT "                             TEST"

GOSUB Loadpscreen

GOSUB Callpscreen

END


Loadpscreen:
DIM pscreen( 2 )
DEF SEG = VARSEG(pscreen(0))
FOR i = 0 TO  2
READ j
POKE (VARPTR(pscreen(0)) + i), j
NEXT i
RETURN

Callpscreen:
DEF SEG = VARSEG(pscreen(0))
CALL ABSOLUTE (VARPTR(pscreen(0)))
RETURN
DATA &HCD,&H05,&HCB