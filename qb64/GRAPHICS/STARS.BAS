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
    SPEED      AS SINGLE
    SIZE       AS SINGLE
END TYPE

DIM AS INTEGER NUM_STARS
DIM AS SINGLE BASE_BRIGHT, MAX_BRIGHT, SPEED_DIV, SZ_MIN, SZ_MAX
DIM AS SINGLE b, x, y, s
DIM AS INTEGER n

NUM_STARS%   = 1500  'how many stars are there
SZ_MIN!      = 1     'min size of star
SZ_MAX!      = 1     'max size of star
BASE_BRIGHT! = 20    'base light amount (brightness)
MAX_BRIGHT!  = 255   'maximum light amount (brightness)
SPEED_DIV!   = 500.0 'speed divisor - higher = slower

DIM STARS(NUM_STARS%) AS STAR

'create the stars
FOR n% = 1 TO NUM_STARS%
    STARS(n%).X = RND * _WIDTH
    STARS(n%).Y = RND * _HEIGHT
    b! = BASE_BRIGHT! + RND * MAX_BRIGHT!
    _ECHO STR$(b!)
    STARS(n%).BRIGHTNESS = b!
    STARS(n%).SPEED = b! / SPEED_DIV!
    s! = INT(RND * (SZ_MAX! - SZ_MIN! + 1) + 1)
    STARS(n%).SIZE = s!
NEXT n%

DO
    CLS
    'populate space
    FOR n% = 1 TO NUM_STARS%
        b! = stars(n%).BRIGHTNESS!
        x! = stars(n%).X!
        y! = stars(n%).Y!
        s! = stars(n%).SIZE!

        'draw star
        LINE (x! - s!, y! - s!)-(x! + s!, y! + s!), _RGB(b!, b!, b!), BF

        'parallax
        STARS(n%).X! = STARS(n%).X! - STARS(n%).SPEED!

        'wrap
        IF STARS(n%).X! < 0 THEN STARS(n%).X! = _WIDTH
    NEXT n%
    _DISPLAY
LOOP UNTIL INKEY$ <> ""
SYSTEM
