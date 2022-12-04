DEFINT A-Z

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
DEF SEG
RETURN

Callpscreen:
DEF SEG=VARSEG(pscreen(0))
rem CALL ABSOLUTE (,,VARPTR(pscreen(0)))
DEF SEG
RETURN


DATA &HCD,&H05,&HCB
