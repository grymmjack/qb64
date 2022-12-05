_FULLSCREEN _SQUAREPIXELS
SCREEN _NEWIMAGE(1920, 1080, 256)
CONST NUM_BALLS = 2048
CONST LIM = 120
CONST MAX_SPEED = 5
CONST CIRC_RADIUS = 0
CONST CIRC_COLOR = 10
CONST USE_SOUND = 0
CONST SOUND_FREQ = 5000
CONST SOUND_DUR = 0.05
CONST DELAY_DUR = 0
CONST GROWTH_RATE = 1
CONST MAX_RADIUS = 1000
CONST RADIUS_INC = 10
DIM SHARED growth AS INTEGER
growth = 0

RANDOMIZE TIMER
DIM x(NUM_BALLS), y(NUM_BALLS), dx(NUM_BALLS), dy(NUM_BALLS), c(NUM_BALLS), r(NUM_BALLS)
FOR a = 1 TO NUM_BALLS
    x(a) = INT(RND * _WIDTH) + 1
    y(a) = INT(RND * _HEIGHT) + 1
    dx(a) = (RND * MAX_SPEED) - 1
    dy(a) = (RND * MAX_SPEED) - 1
    r(a) = 0
    c(a) = (RND * 255) - 1 + 1
NEXT
DO
    CLS
    _LIMIT LIM                          'regulates speed of balls in QB64
    FOR a = 1 TO NUM_BALLS
        CIRCLE(x(a), y(a)), CIRC_RADIUS+r(a), c(a)         'all erasing and drawing is done on page 1
        x(a) = x(a) + dx(a)
        y(a) = y(a) + dy(a)
        IF x(a) > _WIDTH-CIRC_RADIUS THEN 
            dx(a) = -dx(a): x(a) = x(a) - 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = 0
            END IF
            hit
        END IF
        IF x(a) < CIRC_RADIUS THEN 
            dx(a) = -dx(a): x(a) = x(a) + 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = 0
            END IF
            hit
        END IF
        IF y(a) > _HEIGHT-CIRC_RADIUS THEN 
            dy(a) = -dy(a): y(a) = y(a) - 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = 0
            END IF
            hit
        END IF
        IF y(a) < CIRC_RADIUS THEN 
            dy(a) = -dy(a): y(a) = y(a) + 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = 0
            END IF
            hit
        END IF

    NEXT
    _DISPLAY
LOOP UNTIL INKEY$ = CHR$(27) ' escape exit

SUB hit()
    IF USE_SOUND = 1 THEN
        SOUND SOUND_FREQ+(growth*2), SOUND_DUR
        _DELAY DELAY_DUR
    END IF
    IF growth < MAX_RADIUS THEN
        growth = growth + GROWTH_RATE
    END IF
END SUB