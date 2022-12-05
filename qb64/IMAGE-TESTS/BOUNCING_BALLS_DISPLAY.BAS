_FULLSCREEN _SQUAREPIXELS
SCREEN 4
CONST NUM_BALLS = 2
CONST LIM = 120
CONST MAX_SPEED = 2
CONST CIRC_RADIUS = 15
CONST CIRC_COLOR = 10
CONST SOUND_FREQ = 241
CONST SOUND_DUR = 0.1
DIM x(NUM_BALLS), y(NUM_BALLS), dx(NUM_BALLS), dy(NUM_BALLS)
FOR a = 1 TO NUM_BALLS
    x(a) = INT(RND * _WIDTH) + 1
    y(a) = INT(RND * _HEIGHT) + 1
    dx(a) = (RND * MAX_SPEED) - 1
    dy(a) = (RND * MAX_SPEED) - 1
NEXT
DO
    CLS
    _LIMIT LIM                          'regulates speed of balls in QB64
    FOR a = 1 TO NUM_BALLS
        CIRCLE(x(a), y(a)), CIRC_RADIUS, CIRC_COLOR         'all erasing and drawing is done on page 1
        x(a) = x(a) + dx(a)
        y(a) = y(a) + dy(a)
        IF x(a) > _WIDTH THEN 
            dx(a) = -dx(a): x(a) = x(a) - 1
            SOUND SOUND_FREQ, SOUND_DUR
        END IF
        IF x(a) < 0 THEN 
            dx(a) = -dx(a): x(a) = x(a) + 1
            SOUND SOUND_FREQ, SOUND_DUR
        END IF
        IF y(a) > _HEIGHT THEN 
            dy(a) = -dy(a): y(a) = y(a) - 1
            SOUND SOUND_FREQ, SOUND_DUR
        END IF
        IF y(a) < 0 THEN 
            dy(a) = -dy(a): y(a) = y(a) + 1
            SOUND SOUND_FREQ, SOUND_DUR
        END IF

    NEXT
    _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27) ' escape exit
