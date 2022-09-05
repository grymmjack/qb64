FREQ_MAX    = 1500
FREQ_MIN    = 400

LIMIT       = 120

TIME_STEP_S = 10
TIME_STEP_F = 180
TIME_STEP_C = 100

TIME_MIN    = 0.18
TIME_SLOW   = 20
TIME_FAST   = 180

SLOW_LOOPS  = 3
FAST_LOOPS  = 20
REG_LOOPS   = 5

SLOW=0
DO
    DO
        TIME_STEP = TIME_STEP_S
        FOR i = FREQ_MIN TO FREQ_MAX STEP TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        FOR i = FREQ_MAX TO FREQ_MIN STEP - TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        SLOW = SLOW + 1
    LOOP UNTIL SLOW = SLOW_LOOPS
    SLOW = 0

    TIME_STEP = TIME_STEP_F
    FAST = 0
    DO
        FOR i = FREQ_MIN TO FREQ_MAX STEP TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        FOR i = FREQ_MAX TO FREQ_MIN STEP - TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        FAST = FAST + 1
    LOOP UNTIL FAST = FAST_LOOPS
    TIME_STEP = TIME_SLOW
    FAST = 0

    TIME_STEP = TIME_STEP_C
    REG = 0
    DO
        FOR i = FREQ_MIN TO FREQ_MAX STEP TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        FOR i = FREQ_MAX TO FREQ_MIN STEP - TIME_STEP
            _LIMIT LIMIT
            PRINT "SOUND";i
            SOUND i, TIME_MIN
        NEXT i
        REG = REG + 1
    LOOP UNTIL REG = REG_LOOPS
    TIME_STEP = TIME_STEP_S
    REG = 0


LOOP UNTIL _KEYHIT
