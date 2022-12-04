DEFINT A-Z

GOSUB Loadfrespc
ax = 0
bx = 0
cx = 0
dx = 0
CLS
GOSUB Callfrespc

PRINT ax, bx, cx, dx

freebytes# = CLNG(ax) * CLNG(bx) * CLNG(cx)
PRINT freebytes#
END

Loadfrespc:
DIM frespc( 21 )
DEF SEG = VARSEG(frespc(0))
FOR i = 0 TO  41 
READ j
POKE (VARPTR(frespc(0)) + i), j
NEXT i
DEF SEG
RETURN

Callfrespc:
DEF SEG=VARSEG(frespc(0))
CALL ABSOLUTE (ax,bx,cx,dx,VARPTR(frespc(0)))
DEF SEG
RETURN


DATA &H55,&H89,&HE5,&H8B,&H5E,&H06,&H8A,&H17
DATA &HB4,&H36,&HCD,&H21,&H52,&H51,&H53,&H8B
DATA &H5E,&H0C,&H89,&H07,&H8B,&H5E,&H0A,&H58
DATA &H89,&H07,&H8B,&H5E,&H08,&H59,&H89,&H0F
DATA &H8B,&H5E,&H06,&H5A,&H89,&H17,&H5D,&HCA
DATA &H08,&H00
