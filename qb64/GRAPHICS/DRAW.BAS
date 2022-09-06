SCREEN _NEWIMAGE(320, 200, 256)
_FULLSCREEN _SQUAREPIXELS
COLOR ,1
CLS

m = 1
d = 0
lim = 120
st = 1
c = 1
x = 0
y = 10
w = 50
h = 50

FGC$ = "12" : BGC$="8"
T$ = "C"+FGC$+" R10 E5 R20 F5 R10             BL50"
M$ = "D20 BR50 BU20 D20             BL50"
B$ = "D10 E10 U10 R30 D10 F10 U10   BL50"
F$ = "BU20 BF5 P "+BGC$+","+FGC$

ALIEN$ = T$+M$+B$+F$

ALIEN_SPRITE_CLEAR& = _NEWIMAGE(w+1, h+1, 256)
ALIEN_SPRITE& = _NEWIMAGE(w+1, h+1, 256)
' ALIEN_HW_CLEAR& = _NEWIMAGE(w+1, h+1, 32)
' ALIEN_HW& = _NEWIMAGE(w+1, h+1, 32)
_DEST ALIEN_SPRITE&

' _PALETTECOLOR 0,  _RGB32(0, 0, 0)
' _PALETTECOLOR 1,  _RGB32(0, 0, 64)
' _PALETTECOLOR 12, _RGB32(255, 170, 170)
' _PALETTECOLOR 8,  _RGB32(170, 0, 0)
_CLEARCOLOR 0
PSET (0,10)
DRAW ALIEN$

_DEST ALIEN_SPRITE_CLEAR&
COLOR ,1
CLS

' ALIEN_HW& = _COPYIMAGE(ALIEN_SPRITE&, 33)
' ALIEN_HW_CLEAR& = _COPYIMAGE(ALIEN_SPRITE_CLEAR&, 33)

' _FREEIMAGE ALIEN_SPRITE&
' _FREEIMAGE ALIEN_SPRITE_CLEAR&

_DEST 0
' _DISPLAYORDER _HARDWARE
DO
    FOR x = 0 TO _WIDTH-w STEP st
        IF lim > 0 THEN _LIMIT lim
        _PUTIMAGE (x, y)-(x+w, y+h), ALIEN_SPRITE&, 0, (0,0)-(w,h)
        _DISPLAY
        _DELAY d
        _PUTIMAGE (x, y)-(x+w, y+h), ALIEN_SPRITE_CLEAR&, 0, (0,0)-(w,h)
        ' DRAW ALIEN$
        ' LINE (x, y-y)-(x + w, y + h), c, BF
        ' _DELAY 1
    NEXT x
    FOR x = _WIDTH-w TO 0 STEP -st
        IF lim > 0 THEN _LIMIT lim
        _PUTIMAGE (x, y)-(x+w, y+h), ALIEN_SPRITE&, 0, (0,0)-(w,h)
        _DISPLAY
        _DELAY d
        _PUTIMAGE (x, y)-(x+w, y+h), ALIEN_SPRITE_CLEAR&, 0, (0,0)-(w,h)
        ' DRAW ALIEN$
        ' LINE (x, y-y)-(x + w, y + h), c, BF
        ' _DELAY 1
    NEXT x
    LOOP UNTIL _KEYHIT