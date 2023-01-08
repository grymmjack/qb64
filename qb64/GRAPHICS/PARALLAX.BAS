OPTION _EXPLICIT
CONST w = 320 : CONST h = 200 : CONST bpp = 32
DIM CANVAS AS LONG : CANVAS& = _NEWIMAGE(w, h, bpp) : SCREEN CANVAS&
_FULLSCREEN _SQUAREPIXELS

CONST SPD        = 5
CONST MUL_FAR    = 0.1 
CONST MUL_NEAR   = 0.3 
CONST MUL_SILO   = 0.7
CONST MUL_FG     = 1
CONST MUL_ENTITY = 0.75
CONST COL_CLEAR  = _RGB32(0, 0, 0)
CONST COL_FAR    = _RGB32(48, 48, 48)
CONST COL_NEAR   = _RGB32(0, 164, 32)
CONST COL_GROUND = _RGB32(0, 64, 0)
CONST COL_SKY    = _RGB32(32, 128, 255)
CONST COL_ENTITY = _RGB32(255, 255, 255)
CONST COL_SILO   = _RGB32(128, 64, 32)
CONST COL_SILO2  = _RGB32(0, 64, 0)

DIM bgFar    AS LONG : bgFar&    = _NEWIMAGE(w, h, bpp)
DIM bgNear   AS LONG : bgNear&   = _NEWIMAGE(w, h, bpp)
DIM fgGround AS LONG : fgGround& = _NEWIMAGE(w, h, bpp)
DIM fgSilo   AS LONG : fgSilo&   = _NEWIMAGE(w, h, bpp)
DIM entity   AS LONG : entity&   = _NEWIMAGE(w, h, bpp)

DIM moveX AS INTEGER
DIM k AS STRING
moveX% = 0
DO:
    _LIMIT 30

    k$ = INKEY$
    IF k$ = CHR$(0) + CHR$(75) THEN moveX% = moveX% - SPD
    IF k$ = CHR$(0) + CHR$(77) THEN moveX% = moveX% + SPD

    ' Wait for a key to be pressed
    DO: k$ = INKEY$: LOOP UNTIL k$ = ""

    ' Draw stuff far away
    _DEST bgFar&
    CLS, COL_CLEAR : _SETALPHA 0, COL_CLEAR
    LINE (100 - (moveX% * MUL_FAR), 50)-(200 - (moveX% * MUL_FAR), 99), COL_FAR, BF
    LINE (150 - (moveX% * MUL_FAR), 10)-(320 - (moveX% * MUL_FAR), 99), COL_FAR, BF

    ' Draw stuff near but behind
    _DEST bgNear&
    CLS, COL_CLEAR : _SETALPHA 0, COL_CLEAR
    LINE (0 - (moveX% * MUL_NEAR), 75)-(50 - (moveX% * MUL_NEAR), 99), COL_NEAR, BF
    LINE (90 - (moveX% * MUL_NEAR), 90)-(120 - (moveX% * MUL_NEAR), 99), COL_NEAR, BF
    LINE (190 - (moveX% * MUL_NEAR), 80)-(220 - (moveX% * MUL_NEAR), 99), COL_NEAR, BF
    LINE (280 - (moveX% * MUL_NEAR), 90)-(300 - (moveX% * MUL_NEAR), 99), COL_NEAR, BF

    ' Draw ground
    _DEST fgGround&
    CLS, COL_CLEAR : _SETALPHA 0, COL_CLEAR
    LINE (0, 100)-(w, h), COL_GROUND, BF 

    ' Draw entity
    _DEST entity&
    CLS, COL_CLEAR : _SETALPHA 0, COL_CLEAR
    LINE (10 + (moveX% * MUL_ENTITY), 85)-(15 + (moveX% * MUL_ENTITY), 99), COL_ENTITY, BF

    ' Draw silos in front
    _DEST fgSilo&
    CLS, COL_CLEAR : _SETALPHA 0, COL_CLEAR
    LINE (310 - (moveX% * MUL_SILO), 25)-(320 - (moveX% * MUL_SILO), h), COL_SILO, BF
    LINE (300 - (moveX% * MUL_SILO), 0)-(330 - (moveX% * MUL_SILO), 75), COL_SILO2, BF

    ' Draw Composite
    _DEST CANVAS&
    CLS, COL_SKY
    _SOURCE bgFar&    : _PUTIMAGE
    _SOURCE bgNear&   : _PUTIMAGE
    _SOURCE fgGround& : _PUTIMAGE
    _SOURCE entity&   : _PUTIMAGE
    _SOURCE fgSilo&   : _PUTIMAGE

    _DISPLAY
LOOP UNTIL _KEYHIT=27 ' Exit on ESC
SYSTEM