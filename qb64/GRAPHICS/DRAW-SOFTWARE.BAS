OPTION _EXPLICIT
 
DIM AS INTEGER lim, st, x, y, w, h
DIM AS SINGLE d
DIM AS STRING FGC, BGC, T, M, B, F, ALIEN
DIM AS LONG ALIEN_SPRITE, ALIEN_32, ALIEN_HW, CANVAS
 
CANVAS& = _NEWIMAGE(320, 200, 32)
SCREEN CANVAS&
_FULLSCREEN _SQUAREPIXELS
 
d!   = 0
lim% = 120
st%  = 1
x%   = 0
y%   = 10
w%   = 50
h%   = 50
 
FGC$   = "12": BGC$ = "8"
T$     = "C" + FGC$ + " R10 E5 R20 F5 R10 BL50"
M$     = "D20 BR50 BU20 D20               BL50"
B$     = "D10 E10 U10 R30 D10 F10 U10     BL50"
F$     = "BU20 BF5 P " + BGC$ + "," + FGC$
ALIEN$ = T$ + M$ + B$ + F$
 
ALIEN_SPRITE& = _NEWIMAGE(w% + 1, h% + 1, 256)
_DEST ALIEN_SPRITE&
PSET (0, 10)
DRAW ALIEN$
_CLEARCOLOR 0, ALIEN_SPRITE&
ALIEN_32& = _NEWIMAGE(w% + 1, h% + 1, 32)
_SOURCE ALIEN_SPRITE&: _DEST ALIEN_32&: _PUTIMAGE
ALIEN_HW& = _COPYIMAGE(ALIEN_32&, 32)
 
_DEST CANVAS&
CLS , _RGB32(0, 0, 255)
DO
    FOR x% = 0 TO _WIDTH - w% + 1 STEP st%
        IF lim% > 0 THEN _LIMIT lim%
        _PUTIMAGE (x%, y%), ALIEN_HW&
        _DISPLAY
        CLS , _RGB32(0, 0, 255)
        IF d! > 0 THEN _DELAY d!
    NEXT x%
    FOR x% = _WIDTH - w% + 1 TO 0 STEP -st%
        IF lim% > 0 THEN _LIMIT lim%
        _PUTIMAGE (x%, y%), ALIEN_HW&
        _DISPLAY
        CLS , _RGB32(0, 0, 255)
        IF d! > 0 THEN _DELAY d!
    NEXT
LOOP UNTIL _KEYHIT = 27
 
_FREEIMAGE ALIEN_SPRITE&
_FREEIMAGE ALIEN_HW&
 
SYSTEM