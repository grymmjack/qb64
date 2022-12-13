_TITLE "Starfield"

scrn& = _NEWIMAGE(800, 600, 32)
SCREEN scrn&

TYPE Star
    x AS SINGLE
    y AS SINGLE
    brightness AS INTEGER
    speed AS SINGLE
END TYPE

DIM stars(100) AS Star
DIM b AS SINGLE

'create the stars
FOR n = 1 TO 100
    stars(n).x = RND * 800
    stars(n).y = RND * 600
    b = 50 + RND * 200
    stars(n).brightness = b
    stars(n).speed = b / 1000.0
NEXT n

DO
    CLS
    FOR n = 1 TO 100
        b = stars(n).brightness
        x = stars(n).x
        y = stars(n).y
        LINE (x - 1, y - 1)-(x + 1, y + 1), _RGB(b, b, b), BF
        stars(n).x = stars(n).x - stars(n).speed
        IF stars(n).x < 0 THEN stars(n).x = 800
    NEXT n
    _DISPLAY
LOOP UNTIL INKEY$ <> ""
END

