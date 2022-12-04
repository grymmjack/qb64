DEFINT A-Z

GOSUB Loadcurrdir

GOSUB Callcurrdir

END

Loadcurrdir:
DIM currdir( 9 )
DEF SEG = VARSEG(currdir(0))
FOR i = 0 TO  17 
READ j
POKE (VARPTR(currdir(0)) + i), j
NEXT i
DEF SEG
RETURN

Callcurrdir:
DEF SEG=VARSEG(currdir(0))
rem CALL ABSOLUTE (,,VARPTR(currdir(0)))
DEF SEG
RETURN


DATA &H55,&H89,&HE5,&HB4,&H47,&HB2,&H00,&H8B
DATA &H5E,&H06,&H8B,&H37,&HCD,&H21,&H5D,&HCA
DATA &H02,&H00
