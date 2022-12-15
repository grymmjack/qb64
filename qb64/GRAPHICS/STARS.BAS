$CONSOLE
OPTION _EXPLICIT
OPTION _EXPLICITARRAY

_TITLE "STARS"

DIM AS LONG w, h
DO:  _LIMIT 10: LOOP UNTIL _SCREENEXISTS
w& = _DESKTOPWIDTH : h& = _DESKTOPHEIGHT
SCREEN _NEWIMAGE(w&, h&, 32)
_FULLSCREEN _SQUAREPIXELS

TYPE STAR
    X          AS SINGLE
    Y          AS SINGLE
    BRIGHTNESS AS SINGLE
    X_SPEED    AS SINGLE
    Y_SPEED    AS SINGLE
    SIZE       AS SINGLE
END TYPE

DIM AS INTEGER NUM_STARS
DIM AS SINGLE BASE_BRIGHT, MAX_BRIGHT, X_SPEED_DIV, Y_SPEED_DIV, SZ_MIN, SZ_MAX
DIM AS SINGLE b, x, y, s
DIM AS INTEGER n

NUM_STARS%   = 2000  'how many stars are there
SZ_MIN!      = 1     'min size of star
SZ_MAX!      = 1     'max size of star
BASE_BRIGHT! = 0    'base light amount (brightness)
MAX_BRIGHT!  = 150   'maximum light amount (brightness)
X_SPEED_DIV! = 1500  'speed_x divisor - higher = slower
Y_SPEED_DIV! = 1500 'speed_y divisor - higher = slower

DIM STARS(NUM_STARS%) AS STAR
DIM k AS STRING

'create the stars
FOR n% = 1 TO NUM_STARS%
    STARS(n%).X = RND * _WIDTH
    STARS(n%).Y = RND * _HEIGHT
    b! = BASE_BRIGHT! + RND * MAX_BRIGHT!
    STARS(n%).BRIGHTNESS = b!
    STARS(n%).X_SPEED = b! / X_SPEED_DIV!
    STARS(n%).Y_SPEED = b! / Y_SPEED_DIV!
    s! = INT(RND * (SZ_MAX! - SZ_MIN! + 1) + 1)
    STARS(n%).SIZE = s!
NEXT n%

DO
    CLS
    k$ = INKEY$
    SELECT CASE k$
        CASE CHR$(0) + "K": 'left arrow
            X_SPEED_DIV! = X_SPEED_DIV! + 100
            _ECHO "left - X_SPEED_DIV=" + _TRIM$(STR$(X_SPEED_DIV!))
        CASE CHR$(0) + "M": 'right arrow
            X_SPEED_DIV! = X_SPEED_DIV! - 100
            _ECHO "right - X_SPEED_DIV=" + _TRIM$(STR$(X_SPEED_DIV!))
        CASE CHR$(0) + "H": 'down arrow
            Y_SPEED_DIV! = Y_SPEED_DIV! + 100
            _ECHO "down - Y_SPEED_DIV=" + _TRIM$(STR$(Y_SPEED_DIV!))
        CASE CHR$(0) + "P": 'up arrow
            Y_SPEED_DIV! = Y_SPEED_DIV! - 100
            _ECHO "up - Y_SPEED_DIV=" + _TRIM$(STR$(Y_SPEED_DIV!))
        CASE "r": 'r - reset
            X_SPEED_DIV! = 1500
            Y_SPEED_DIV! = 1500
    END SELECT

    'populate space
    FOR n% = 1 TO NUM_STARS%
        b! = stars(n%).BRIGHTNESS!
        x! = stars(n%).X!
        y! = stars(n%).Y!
        s! = stars(n%).SIZE!
        STARS(n%).X_SPEED = b! / X_SPEED_DIV!
        STARS(n%).Y_SPEED = b! / Y_SPEED_DIV!

        'draw star
        LINE (x! - s!, y! - s!)-(x! + s!, y! + s!), _RGB(b!, b!, b!), BF

        'parallax
        STARS(n%).X! = STARS(n%).X! - STARS(n%).X_SPEED!
        STARS(n%).Y! = STARS(n%).Y! - STARS(n%).Y_SPEED!

        'wrap
        IF STARS(n%).X! < 0 THEN STARS(n%).X! = _WIDTH
        IF STARS(n%).Y! < 0 THEN STARS(n%).Y! = _HEIGHT
    NEXT n%
    _DISPLAY
LOOP UNTIL _KEYHIT = 27
SYSTEM
