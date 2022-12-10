_FULLSCREEN _SQUAREPIXELS
'SCREEN _NEWIMAGE(1920, 1080, 256)
SCREEN 13
CONST NUM_BALLS           = 3
CONST LIM                 = 120
CONST MAX_SPEED           = 4
CONST CIRC_RADIUS         = 0
CONST CIRC_COLOR          = 10
CONST USE_SOUND           = 1
CONST SOUND_FREQ          = 5000
CONST SOUND_DUR           = 0.05
CONST DELAY_DUR           = 0
CONST GROWTH_RATE         = 1
CONST MAX_RADIUS          = 512
CONST RADIUS_INC          = 5
CONST RANDOM_COLORS       = 1
CONST CIRCLES             = 0
CONST BOXES               = 1
CONST FILLED_BOXES        = 0
CONST BOTH_BOX_TYPES      = 0
CONST EGA_COLORS          = 0
CONST COLOR_RANGE_START   = 0
CONST COLOR_RANGE_END     = 0
CONST USE_COLOR_CHOICES   = 1
CONST COLOR_THEME_FIRE    = 0
CONST COLOR_THEME_WATER   = 0
CONST COLOR_THEME_MONO    = 1
DIM SHARED growth AS INTEGER
growth = 0

' PURPLE (with duplicates to increase odds on some colors)
REDIM COLOR_CHOICES(10) AS INTEGER
COLOR_CHOICES(0) = 8
COLOR_CHOICES(1) = 8
COLOR_CHOICES(2) = 8
COLOR_CHOICES(3) = 8
COLOR_CHOICES(4) = 5
COLOR_CHOICES(5) = 5
COLOR_CHOICES(6) = 5
COLOR_CHOICES(7) = 11
COLOR_CHOICES(8) = 13
COLOR_CHOICES(9) = 13
COLOR_CHOICES(10) = 14

IF COLOR_THEME_FIRE = 1 THEN 
    REDIM COLOR_CHOICES(4) AS INTEGER
    COLOR_CHOICES(0) = 4
    COLOR_CHOICES(1) = 6
    COLOR_CHOICES(2) = 12
    COLOR_CHOICES(3) = 14
    COLOR_CHOICES(4) = 15
ELSEIF COLOR_THEME_WATER = 1 THEN
    REDIM COLOR_CHOICES(4) AS INTEGER
    COLOR_CHOICES(0) = 1
    COLOR_CHOICES(1) = 3
    COLOR_CHOICES(2) = 9
    COLOR_CHOICES(3) = 11
    COLOR_CHOICES(4) = 15
ELSEIF COLOR_THEME_MONO = 1 THEN
    REDIM COLOR_CHOICES(2) AS INTEGER
    COLOR_CHOICES(0) = 8
    COLOR_CHOICES(1) = 7
    COLOR_CHOICES(2) = 15
ENDIF

RANDOMIZE TIMER
DIM x(NUM_BALLS), y(NUM_BALLS), dx(NUM_BALLS), dy(NUM_BALLS), c(NUM_BALLS), r(NUM_BALLS)
FOR a = 1 TO NUM_BALLS
    x(a) = INT(RND * _WIDTH) + 1
    y(a) = INT(RND * _HEIGHT) + 1
    dx(a) = (RND * MAX_SPEED) - 1
    dy(a) = (RND * MAX_SPEED) - 1
    r(a) = RADIUS_INC
    IF RANDOM_COLORS = 1 THEN
        IF EGA_COLORS = 1 THEN
            RANDOMIZE TIMER
            c(a) = (RND * 14) + 1
        ELSE
            IF USE_COLOR_CHOICES = 1 THEN
                RANDOMIZE TIMER
                c(a) = COLOR_CHOICES(RND * UBOUND(COLOR_CHOICES))
            ELSE
                IF COLOR_RANGE_START > 0 AND COLOR_RANGE_END > 0 THEN
                    RANDOMIZE TIMER
                    c(a) = (RND * COLOR_RANGE_END) + 1 - COLOR_RANGE_START
                ELSE
                    RANDOMIZE TIMER
                    c(a) = (RND * 254) + 1
                END IF
            END IF
        END IF
    ELSE
        c(a) = CIRC_COLOR
    END IF
NEXT
DO
    CLS
    _LIMIT LIM                          'regulates speed of balls in QB64
    FOR a = 1 TO NUM_BALLS
        IF CIRCLES = 1 THEN
            CIRCLE(x(a), y(a)), CIRC_RADIUS+r(a), c(a)         'all erasing and drawing is done on page 1
        ELSEIF BOXES = 1 THEN
            LINE (x(a), y(a))-(x(a)+r(a), y(a)+r(a)), c(a), B
        ELSEIF FILLED_BOXES = 1 THEN
            LINE (x(a), y(a))-(x(a)+r(a), y(a)+r(a)), c(a), BF
        ELSEIF BOTH_BOX_TYPES = 1 THEN
            RANDOMIZE TIMER
            X = INT(RND * 2) - 1
            IF X = 0 THEN
                LINE (x(a), y(a))-(x(a)+r(a), y(a)+r(a)), c(a), BF
            ELSE 
                LINE (x(a), y(a))-(x(a)+r(a), y(a)+r(a)), c(a), B
            END IF
        ELSE
            LINE (x(a), y(a))-(x(a)+r(a), y(a)+r(a)), c(a)
        END IF
        x(a) = x(a) + dx(a)
        y(a) = y(a) + dy(a)
        IF x(a) > _WIDTH-CIRC_RADIUS THEN 
            dx(a) = -dx(a): x(a) = x(a) - 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = RADIUS_INC
            END IF
            hit
        END IF
        IF x(a) < CIRC_RADIUS THEN 
            dx(a) = -dx(a): x(a) = x(a) + 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = RADIUS_INC
            END IF
            hit
        END IF
        IF y(a) > _HEIGHT-CIRC_RADIUS THEN 
            dy(a) = -dy(a): y(a) = y(a) - 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = RADIUS_INC
            END IF
            hit
        END IF
        IF y(a) < CIRC_RADIUS THEN 
            dy(a) = -dy(a): y(a) = y(a) + 1
            IF r(a) < MAX_RADIUS THEN
                r(a) = r(a) + RADIUS_INC
            ELSE
                r(a) = RADIUS_INC
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