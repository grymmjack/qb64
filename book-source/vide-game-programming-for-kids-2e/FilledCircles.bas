SCREEN _NEWIMAGE(800, 600, 32)
RANDOMIZE TIMER

DO
    x = 50 + RND * 700
    y = 50 + RND * 500
    r = 10 + RND * 40
    red = RND * 256
    grn = RND * 256
    blu = RND * 256
    CIRCLE (x, y), r, _RGB(red, grn, blu)
    PAINT (x, y), _RGB(red, grn, blu), _RGB(red, grn, blu)
    _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27)
SYSTEM

