DEFINT A-Z

GOSUB Loadgetbit
astring$ = "abc"
ax = 0
bitnumber = 1
FOR i = 1 TO 3
FOR j = 1 TO 8
GOSUB Callgetbit
PRINT value;
bitnumber = bitnumber + 1
NEXT j
PRINT
NEXT i

END

Loadgetbit:
DIM getbit(28)
DEF SEG = VARSEG(getbit(0))
FOR i = 0 TO 50
READ j
POKE (VARPTR(getbit(0)) + i), j
NEXT i
DEF SEG
RETURN

Callgetbit:
DEF SEG = VARSEG(getbit(0))
CALL ABSOLUTE(SADD(astring$), bitnumber, value, VARPTR(getbit(0)))
DEF SEG
RETURN



DATA &H55,&H8B,&HEC,&H8B,&H5E,&H08,&H8B,&H17
DATA &H83,&HEA,&H01,&H8B,&HCA,&H81,&HE1,&HF8
DATA &H00,&H2B,&HD1,&HD1,&HE9,&HD1,&HE9,&HD1
DATA &HE9,&H8B,&H5E,&H0A,&H8B,&H37,&H03,&HF1
DATA &HAC,&HB1,&H07,&H2A,&HCA,&HD3,&HE8,&H25
DATA &H01,&H00,&H8B,&H5E,&H06,&H89,&H07,&H5D
DATA &HCA,&H06,&H00

