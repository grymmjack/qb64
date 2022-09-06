DEFINT A-Z

CONST pi! = 3.141593

' Define co-ordinates of box to rotate here, with (0,0) at the centre of the
' screen. BOXX1 = left co-or, BOXX2 = right co-or, BOXY1 = top co-or,
' BOXY2= bottom co-or, ie rectangle defined by (BOXX1, BOXY1)-(BOXX2, BOXY2)

CONST BOXX1 = -50
CONST BOXX2 = 25
CONST BOXY1 = -50
CONST BOXY2 = 25

DIM r!(BOXX1 TO BOXX2, BOXY1 TO BOXY2)
DIM a!(BOXX1 TO BOXX2, BOXY1 TO BOXY2)
DIM p(BOXX1 TO BOXX2, BOXY1 TO BOXY2)

FOR x = BOXX1 TO BOXX2
FOR y = BOXY1 TO BOXY2

r!(x, y) = SQR((x ^ 2) + (y ^ 2))
IF x < 0 THEN r!(x, y) = -r!(x, y)
IF x = 0 THEN a!(x, y) = (pi / 4) ELSE a!(x, y) = ATN(y / x)

NEXT y
NEXT x

SCREEN 7
WINDOW (-160, 100)-(160, -100) ' We set the co-ordinate system of the screen so
                               ' that the point (0,0) is in the centre of the
                               ' screen.


' *** INSERT DRAWING CODE HERE, ETC. ***

LINE (0, 0)-(50,50), 15, B
LINE (-11, 11)-(11, -11), 12, B
LINE (-12, 12)-(12, -12), 13
LINE (-12, -12)-(12, 12), 14

' *** END OF DRAWING CODE ***

FOR x = BOXX1 TO BOXX2
FOR y = BOXY1 TO BOXY2
p(x, y) = POINT(x, y)
NEXT y
NEXT x

a$ = INPUT$(1)

' Rotation code here. Note that angles are in RADIANS where 2ã rads=360ø
' (Characters in above comment may show incorrectly under Windows, it should
' read 2pi rads=360 degrees)

curpage = 0

DO

FOR angle! = 0 TO 2 * pi! STEP .1
SCREEN 7, , curpage, 1 - curpage
CLS
_LIMIT 1
FOR x = BOXX1 TO BOXX2
FOR y = BOXY1 TO BOXY2

newx = COS(angle! + a!(x, y)) * r!(x, y)
newy = SIN(angle! + a!(x, y)) * r!(x, y)

PSET (newx, newy), p(x, y)

NEXT y
NEXT x
curpage = 1 - curpage
NEXT angle!
 
LOOP UNTIL INKEY$ = CHR$(27)