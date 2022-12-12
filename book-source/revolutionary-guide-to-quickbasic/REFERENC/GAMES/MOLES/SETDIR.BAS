DEFINT A-Z

GOSUB Loadsetdir

GOSUB Callsetdir

END

Loadsetdir:
DIM setdir( 10 )
DEF SEG = VARSEG(setdir(0))
FOR i = 0 TO  19 
READ j
POKE (VARPTR(setdir(0)) + i), j
NEXT i
DEF SEG
RETURN

Callsetdir:
DEF SEG=VARSEG(setdir(0))
rem CALL ABSOLUTE (,,VARPTR(setdir(0)))
DEF SEG
RETURN


DATA &H55,&H89,&HE5,&HB4,&H3B,&H8B,&H5E,&H08
DATA &H8B,&H17,&HCD,&H21,&H8B,&H5E,&H06,&H89
DATA &H07,&H5D,&HCA,&H04
