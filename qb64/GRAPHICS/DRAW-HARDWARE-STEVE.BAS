Option _Explicit

Dim As Integer lim, st, x, y, w, h
Dim As Single d
Dim As String FGC, BGC, T, M, B, F, ALIEN
Dim As Long ALIEN_SPRITE, ALIEN_32, ALIEN_HW, CANVAS

CANVAS& = _NewImage(320, 200, 32)
Screen CANVAS&
_FullScreen _SquarePixels

d! = 0
lim% = 60
st% = 1
x% = 0
y% = 10
w% = 50
h% = 50

FGC$ = "12": BGC$ = "8"
T$ = "C" + FGC$ + " R10 E5 R20 F5 R10 BL50"
M$ = "D20 BR50 BU20 D20               BL50"
B$ = "D10 E10 U10 R30 D10 F10 U10     BL50"
F$ = "BU20 BF5 P " + BGC$ + "," + FGC$
ALIEN$ = T$ + M$ + B$ + F$

ALIEN_SPRITE& = _NewImage(w% + 1, h% + 1, 256)
_Dest ALIEN_SPRITE&
PSet (0, 10)
Draw ALIEN$
_ClearColor 0, ALIEN_SPRITE&
ALIEN_32& = _NewImage(w% + 1, h% + 1, 32)
_Source ALIEN_SPRITE&: _Dest ALIEN_32&: _PutImage
ALIEN_HW& = _CopyImage(ALIEN_32&, 33)

Dim BG As Long



_Dest CANVAS&
Cls , _RGB32(0, 0, 255)
BG = _CopyImage(CANVAS&, 33)

_DisplayOrder _Hardware
Do
    x% = x% + st%
    If x% <= 0 Or x% >= _Width - w% Then st% = -st%
    _PutImage , BG
    _PutImage (x%, y%), ALIEN_HW&
    _Display
    If lim% > 0 Then _Limit lim%
Loop Until _KeyHit = 27

_FreeImage ALIEN_SPRITE&
_FreeImage ALIEN_HW&

System