RANDOMIZE TIMER
ws& = _NEWIMAGE(2560, 1440, 32) 'large image page
s& = _NEWIMAGE(1280, 720, 32)' program screen

_DEST ws& 'create large image of random filled circles
FOR i = 1 TO 50
    x = RND(1) * 2560
    y = RND(1) * 1440
    clr& = _RGB32(RND(1) * 255, RND(1) * 255, RND(1) * 255)
    CIRCLE (x, y), RND(1) * 300, clr&
    PAINT (x, y), clr&
NEXT
PRINT "This is a demo of some screen scrolling.   Use the number pad keys to scroll.  4 goes left, 6 goes right.  8 up, 2 down. ESC key will close this program."
x = 0: y = 0
SCREEN s&

DO
    CLS
    _PUTIMAGE (0, 0), ws&, 0, (x, y)-(x + 1279, y + 719)
    a$ = INKEY$
    SELECT CASE a$
        CASE "4": x = x - 10: IF x < 0 THEN x = 0
        CASE "6": x = x + 10: IF x > 1280 THEN x = 1280
        CASE "8": y = y - 10: IF y < 0 THEN y = 0
        CASE "2": y = y + 10: IF y > 720 THEN y = 720
        CASE CHR$(27): SYSTEM
    END SELECT
    _DISPLAY
LOOP 
