'mode 33 copyimage test

SCREEN _NEWIMAGE(800, 600, 32)
RANDOMIZE TIMER

FOR i = 1 TO 100

    LINE (RND * 800, RND * 600)-(RND * 800, RND * 600), _RGB32(RND * 256, RND * 256, RND * 256), BF
    CircleFill RND * 800, RND * 600, RND * 200, _RGB32(RND * 256, RND * 256, RND * 256)
    LINE (100, 100)-(200, 200), -1, BF 'white box to keep things simple
NEXT
PRINT "Let's take a moment and showcase WHY we might want to use hardware images."
PRINT
PRINT "First, let's start with an simple image, and let's copy it to hardware."

h2& = _COPYIMAGE(0)
h2hw& = _COPYIMAGE(0, 33) '<------    make a copy of the screen and make it a hardware copy
changedirection = -1
x = 400: y = 300
xchange = -1: ychange = 1
SLEEP
_DELAY .25
_KEYCLEAR

t# = TIMER
DO
    fps = fps + 1
    CLS
    IF changedirection THEN xchange = -1 * xchange: ychange = -1 * ychange: changedirection = 0
    x = x + xchange: y = y + ychange
    IF x < 0 OR x > _WIDTH OR y < 0 OR y > _HEIGHT THEN changedirection = -1
    _PUTIMAGE (x, y)-STEP(200, 200), h2& 'put the software image on the screen
    IF TIMER > t# + 1 THEN out1$ = STR$(fps): t# = TIMER: fps = 0
    PRINT "FPS:"; out1$; " with use of _PUTIMAGE with software screens and software "
    _DISPLAY 'hardware images require a DISPLAY statement to render
LOOP UNTIL _KEYHIT

_DELAY .25
_KEYCLEAR
t# = TIMER: fps = 0
DO
    fps = fps + 1
    CLS
    IF changedirection THEN xchange = -1 * xchange: ychange = -1 * ychange: changedirection = 0
    x = x + xchange: y = y + ychange
    IF x < 0 OR x > _WIDTH OR y < 0 OR y > _HEIGHT THEN changedirection = -1
    _PUTIMAGE (x, y)-STEP(200, 200), h2hw& 'put the hardware image over the screen  (they're separate layers, so you can overlap them)
    IF TIMER > t# + 1 THEN out2$ = STR$(fps): t# = TIMER: fps = 0
    PRINT "FPS:"; out1$; " with use of _PUTIMAGE with software screens and software images"
    PRINT "FPS:"; out2$; " with use of _PUTIMAGE with software screens and hardware images"
    _DISPLAY 'hardware images require a DISPLAY statement to render
LOOP UNTIL _KEYHIT

_DELAY .25
_KEYCLEAR

_DISPLAYORDER _HARDWARE 'notice I'm not using a software screen at all now.  The PRINT Statements below will NOT show.

t# = TIMER: fps = 0
DO
    fps = fps + 1
    CLS
    IF changedirection THEN xchange = -1 * xchange: ychange = -1 * ychange: changedirection = 0
    x = x + xchange: y = y + ychange
    IF x < 0 OR x > _WIDTH OR y < 0 OR y > _HEIGHT THEN changedirection = -1
    _PUTIMAGE (x, y)-STEP(200, 200), h2hw& 'put the hardware image over the screen  (they're separate layers, so you can overlap them)
    IF TIMER > t# + 1 THEN out3$ = STR$(fps): t# = TIMER: fps = 0
    PRINT "FPS:"; out1$; " with use of _PUTIMAGE with software screens and software images"
    PRINT "FPS:"; out2$; " with use of _PUTIMAGE with software screens and hardware images"
    _DISPLAY 'hardware images require a DISPLAY statement to render
LOOP UNTIL _KEYHIT

_DISPLAYORDER _SOFTWARE , _HARDWARE 'lets put the software screens back into our display
CLS

PRINT "FPS:"; out1$; " with use of _PUTIMAGE with software screens and software images"
PRINT "FPS:"; out2$; " with use of _PUTIMAGE with software screens and hardware images"
PRINT "FPS:"; out3$; " with use of _PUTIMAGE with hardware ONLY images and screens"





SUB CircleFill (CX AS LONG, CY AS LONG, R AS LONG, C AS LONG)
    DIM Radius AS LONG, RadiusError AS LONG
    DIM X AS LONG, Y AS LONG

    Radius = ABS(R)
    RadiusError = -Radius
    X = Radius
    Y = 0

    IF Radius = 0 THEN PSET (CX, CY), C: EXIT SUB

    ' Draw the middle span here so we don't draw it twice in the main loop,
    ' which would be a problem with blending turned on.
    LINE (CX - X, CY)-(CX + X, CY), C, BF

    WHILE X > Y
        RadiusError = RadiusError + Y * 2 + 1
        IF RadiusError >= 0 THEN
            IF X <> Y + 1 THEN
                LINE (CX - Y, CY - X)-(CX + Y, CY - X), C, BF
                LINE (CX - Y, CY + X)-(CX + Y, CY + X), C, BF
            END IF
            X = X - 1
            RadiusError = RadiusError - X * 2
        END IF
        Y = Y + 1
        LINE (CX - X, CY - Y)-(CX + X, CY - Y), C, BF
        LINE (CX - X, CY + Y)-(CX + X, CY + Y), C, BF
    WEND

END SUB