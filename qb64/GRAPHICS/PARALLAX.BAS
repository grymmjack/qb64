CONST w = 320 : CONST h = 200 : CONST bpp = 32

DIM CANVAS AS LONG : CANVAS& = _NEWIMAGE(w, h, bpp) : SCREEN CANVAS&

DIM bgFar    AS LONG : bgFar&    = _NEWIMAGE(w, h, bpp)
DIM bgNear   AS LONG : bgCloser& = _NEWIMAGE(w, h, bpp)
DIM fgGround AS LONG : fgGround& = _NEWIMAGE(w, h, bpp)
DIM fgSilo   AS LONG : fgSilo&   = _NEWIMAGE(w, h, bpp)

DIM moveX AS INTEGER
DIM k AS STRING
moveX% = 0
DO:
    _LIMIT 30
    k$ = INKEY$
    IF k$ = CHR$(0) + CHR$(75) THEN moveX% = moveX% - 10
    IF k$ = CHR$(0) + CHR$(77) THEN moveX% = moveX% + 10

    ' Draw stuff far away
    _DEST bgFar&
    CLS, _RGB32(0, 0, 0)
    LINE (100 + (moveX * 0.25), 50)-(200 + (moveX * 0.25), 100), _RGB32(48, 48, 48), BF

    ' ' Draw stuff near but behind
    _DEST bgNear&
    CLS, _RGB32(0, 0, 0)
    LINE (0 + (moveX * 0.5), 75)-(50 + (moveX * 0.5), 100), _RGB32(64, 64, 64), BF
    LINE (125 + (moveX * 0.5), 100)-(150 + (moveX * 0.5), 100), _RGB32(64, 64, 64), BF

    ' ' Draw ground
    _DEST fgGround&
    CLS, _RGB32(0, 0, 0)
    LINE (0, 100)-(w, h), _RGB32(128, 128, 128), BF 

    ' ' Draw silos in front
    _DEST fgSilo&
    CLS, _RGB32(0, 0, 0)
    LINE (50 + moveX, 25)-(75 + (75 + moveX), h), _RGB32(10, 10, 10), BF

    _DEST CANVAS&
    CLS, _RGB32(0, 0, 0)
    _CLEARCOLOR _RGB32(0,0,0), bgFar&
    _CLEARCOLOR _RGB32(0,0,0), bgNear&
    _CLEARCOLOR _RGB32(0,0,0), fgGround&
    _CLEARCOLOR _RGB32(0,0,0), fgSilo&
    _SETALPHA 0, _RGB32(0,0,0), bgFar&
    _SETALPHA 0, _RGB32(0,0,0), bgNear&
    _SETALPHA 0, _RGB32(0,0,0), fgGround&
    _SETALPHA 0, _RGB32(0,0,0), fgSilo&
    _SOURCE bgFar& : _PUTIMAGE
    _SOURCE bgNear& : _PUTIMAGE
    _SOURCE fgGround& : _PUTIMAGE
    _SOURCE fgSilo& : _PUTIMAGE
    _DISPLAY
LOOP UNTIL _KEYHIT=27
SYSTEM
