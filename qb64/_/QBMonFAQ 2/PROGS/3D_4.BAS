'**************************************************************
' 3D_4.BAS - little 3D-Graphics Demo
' ========
' A lot of toruses are appearing in a 3D world
'
' (c) By www.tek-tips.com
'**************************************************************
'$DYNAMIC
DEFINT A-Z
DECLARE SUB GrayScale ()
DECLARE FUNCTION RandomInt (Lb, Ub)
'
'The following arrays will be used to
'shift the Qbasic color palette.
REDIM PalArray(0 TO 128) AS LONG
REDIM DefPal(16, 3) AS INTEGER
'
SCREEN 12'640x480
CALL GrayScale 'shift from color to grayscale
'
DO
'This loop creates 3D organic shapes
'at random screen locations until the user taps a key.
Cx = RandomInt(0, 639) 'get a random center X and Y
Cy = RandomInt(0, 479)
CcircInc = 1
Ccirc = 1
XC = RandomInt(0, 1)
YC = RandomInt(0, 1)
IF XC THEN cxPos = -1 ELSE cxPos = 1
IF YC THEN cyPos = -1 ELSE cyPos = 1
'Asp! is random mask for the circle commands that follow.
Asp! = 5! / (RandomInt(2, 15))
cxDir = RandomInt(1, 2): IF cxDir = 2 THEN cxDir = -1
cyDir = RandomInt(1, 2): IF cyDir = 2 THEN cyDir = -1
Rend = RandomInt(4, 64) 'pick a random size for the organic
'
FOR Re = 1 TO 1
  FOR R = 1 TO Rend
    IF INKEY$ <> "" THEN 'The user has tapped a key.
      SCREEN 0 'Revert to text mode.
      END 'Quit the program.
    END IF
    Ccirc = Ccirc + CcircInc
    IF Ccirc > 15 THEN Ccirc = 15: CcircInc = -1
    IF Ccirc < 1 THEN Ccirc = 1: CcircInc = 1
    CIRCLE (Cx, Cy), R, Ccirc, , , Asp!
    CIRCLE (Cx + cxPos, Cy + cyPos), R, 16 - Ccirc, , , Asp!
  NEXT
NEXT
LOOP


'
SUB GrayScale
'This subroutine shifts the 16 color Qbasic palette so that
'references to each color result in shades of gray.
REDIM PalArray(0 TO 128) AS LONG
REDIM DefPal(16, 3) AS INTEGER
'
DefPal(1, 1) = 42: DefPal(1, 2) = 42: DefPal(1, 3) = 42
Intense = 1
FOR Re = 2 TO 16
  DefPal(Re, 1) = Intense: DefPal(Re, 2) = Intense: DefPal(Re, 3) = Intense
  Intense = Intense + 4
  IF Re = 15 THEN Intense = 63
NEXT
FOR Re = 1 TO 16
  PalArray(Re) = (65536 * DefPal(Re, 1)) + (256 * DefPal(Re, 2)) + DefPal(Re, 3)
NEXT
'
FOR Re = 17 TO 128
  PalArray(Re) = -1
NEXT
PALETTE USING PalArray(1)
END SUB

FUNCTION RandomInt (Lb, Ub)
'This function just returns a random integer value from Lb to Ub.
RandomInt = INT((Ub - Lb + 1) * RND + Lb)
END FUNCTION

