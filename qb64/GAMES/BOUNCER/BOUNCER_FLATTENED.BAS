''
' BOUNCER
' 
' A little sandbox prototype to help me master the logic and physics for
' ball and paddle stuff. Mostly figuring out collisions and reflections.
'
' Press F5 to start the debugger. This is something that will also wind up
' going into my QB64_GJ_LIB for sure. Also a bunch of the _MISC.BM funcs
' and subs will be added too.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$CONSOLE
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

$EXEICON:'./BOUNCER.ico'
_TITLE "BOUNCER"
_CONSOLETITLE "BOUNCER"

TYPE CONFIG
    FULLSCREEN        AS INTEGER
    FULLSCREEN_SMOOTH AS INTEGER
    RANDOM_BG         AS INTEGER
    RANDOM_FG         AS INTEGER
    SOUND_ENABLED     AS INTEGER
    BALL_CHAOS_TIMER  AS INTEGER
    RAND_NUM_BLOCKS   AS INTEGER
    CHAOS_SECS        AS INTEGER
    NUM_BLOCKS        AS INTEGER
    ORIG_NUM_BLOCKS   AS INTEGER
    PREV_NUM_BLOCKS   AS INTEGER
    BLOCK_MAX_W       AS INTEGER
    BLOCK_MAX_H       AS INTEGER
    LIM               AS INTEGER
    AUTO_BLOCKS_SECS  AS INTEGER
END TYPE

DIM SHARED CFG AS CONFIG
TYPE SCREEN_OBJECT
    BG_KOLOR     AS LONG
    FG_KOLOR     AS LONG
    W            AS INTEGER
    H            AS INTEGER
    BPP          AS INTEGER
    VISIBLE_PAGE AS INTEGER
    ACTIVE_PAGE  AS INTEGER
END TYPE

DIM SHARED __SCREEN AS SCREEN_OBJECT
CONST GAME_SCREEN      = 0%
CONST DEBUGGER_CONSOLE = 1%
TYPE BALL_OBJECT
    X          AS INTEGER
    Y          AS INTEGER
    X_DIR      AS INTEGER
    Y_DIR      AS INTEGER
    SPEED      AS INTEGER
    KOLOR      AS LONG
    TRACE_PATH AS INTEGER
    HIT_90_NUM AS INTEGER
    DISPLAY    AS STRING * 1
END TYPE

DIM SHARED BALL AS BALL_OBJECT
DIM SHARED BALL_9GRID(1 TO 3, 1 TO 3) AS INTEGER
DIM SHARED BALL_25GRID(1 TO 5, 1 TO 5) AS INTEGER

DIM SHARED BALL_ROUND AS STRING
DIM SHARED BALL_SOLID AS STRING
BALL_ROUND$ = CHR$(9)
BALL_SOLID$ = CHR$(10)
TYPE BLOCK_OBJECT
    X       AS INTEGER
    Y       AS INTEGER
    W       AS INTEGER
    H       AS INTEGER
    INDEX   AS INTEGER
    KOLOR   AS LONG
    LIVES   AS INTEGER
    DISPLAY AS STRING * 1
END TYPE

DIM SHARED BLOCK AS BLOCK_OBJECT
DIM SHARED BLOCKS(1 TO CFG.NUM_BLOCKS%) AS BLOCK_OBJECT
TYPE LEVEL_OBJECT
    START_X AS INTEGER
    END_X   AS INTEGER
    START_Y AS INTEGER
    END_Y   AS INTEGER
END TYPE

DIM SHARED LEVEL AS LEVEL_OBJECT
TYPE STATS_OBJECT
    TOP_BOUNCES   AS INTEGER
    RIGHT_BOUNCES AS INTEGER
    BOT_BOUNCES   AS INTEGER
    LEFT_BOUNCES  AS INTEGER
    BLOCK_BOUNCES AS INTEGER
    BALL_INVERTS  AS INTEGER
    BALL_RANDOMS  AS INTEGER
END TYPE

DIM SHARED STATS AS STATS_OBJECT
TYPE TIMER_OBJECT
    STARTED   AS DOUBLE
    STOPPED   AS DOUBLE
    TICKS     AS LONG
    SECONDS   AS LONG
    HOLD      AS INTEGER
    LAP_COUNT AS INTEGER
END TYPE

TYPE TIMER_LAP
    STARTED AS DOUBLE
    STOPPED AS DOUBLE
    TICKS   AS LONG
END TYPE

DIM SHARED MAIN_TIMER AS INTEGER
DIM SHARED TICKS_TIMER AS TIMER_OBJECT
DIM SHARED TIMER_LAPS(10) AS TIMER_LAP
TYPE DEBUG_OBJECT
    ENABLED         AS INTEGER
    DO_BREAKPOINTS  AS INTEGER
    IN_CONSOLE      AS INTEGER
    VERBOSE         AS INTEGER
    VERBOSITY       AS INTEGER
    NEXT_STEP       AS INTEGER
    CUR_STEP        AS INTEGER
    PREV_STEP       AS INTEGER
    MARK_TIME       AS STRING
    MARK_TIMER      AS DOUBLE
    PREV_MARK_TIME  AS STRING
    PREV_MARK_TIMER AS DOUBLE
END TYPE

DIM SHARED DEBUG AS DEBUG_OBJECT
DIM SHARED AS INTEGER DEBUG_MIN, DEBUG_AVG, DEBUG_MAX, DEBUG_WTF
DEBUG_MIN% = 1
DEBUG_AVG% = 2
DEBUG_MAX% = 3
DEBUG_WTF% = 4

configure
ball_init
level_init
block_init
blocks_init
timers_init
debug_init
screen_init

DIM AS STRING k, dmsg
DO:
    IF CFG.LIM% > 0 THEN _LIMIT CFG.LIM%
    k$ = INKEY$
    IF k$ <> "" THEN DPRINT "INKEY$", DEBUG_MIN
    SELECT CASE k$
        CASE LCASE$("s"): 'S = Toggle sound
            DPRINT "INKEY$: 'S' TOGGLE SOUND", DEBUG_AVG
            ball_toggle_sound : stats_update
        CASE LCASE$("b"): 'B = Toggle breakpoints
            DPRINT "INKEY$: 'B' TOGGLE BREAKPOINTS", DEBUG_AVG
            debug_toggle_do_breakpoints : stats_update
        CASE "=": '+/ = Increase speed by increasing limit
            DPRINT "INKEY$: '=' INCREASE LIMIT", DEBUG_AVG
            CFG.LIM% = CFG.LIM% + 1 : stats_update
        CASE "-": '- = Decrease speed by decreasing limit  
            DPRINT "INKEY$: '-' DECREASE LIMIT", DEBUG_AVG
            CFG.LIM% = CFG.LIM% - 1 : stats_update
        CASE " ": 'SPACE = randomize blocks
            DPRINT "INKEY$: ' ' RANDOMIZE BLOCKS", DEBUG_AVG
            blocks_init : game_step
        CASE ",": ', = increment total blocks
            DPRINT "INKEY$: ',' INCREMENT BLOCKS", DEBUG_AVG
            blocks_dec : game_step
        CASE ".": '. = decrement total blocks
            DPRINT "INKEY$: '.' DECREMENT BLOCKS", DEBUG_AVG
            blocks_inc : game_step
        CASE CHR$(0) + "G": 'HOME = Show console explicit
            DPRINT "INKEY$: 'HOME' SHOW DEBUG CONSOLE EXPLICIT", DEBUG_AVG
            debug_console_show
        CASE CHR$(0) + "O": 'END = Hide console explicit
            DPRINT "INKEY$: 'END' HIDE DEBUG CONSOLE EXPLICIT", DEBUG_AVG
            debug_console_hide
        CASE CHR$(0) + ";": 'F1 = toggle ball trace path
            DPRINT "INKEY$: 'F1' TOGGLE BALL TRACE PATH", DEBUG_AVG
            ball_toggle_trace_path
        CASE CHR$(0) + "<": 'F2 = clear debug console
            DPRINT "INKEY$: 'F2' CLEAR CONSOLE", DEBUG_AVG
            console_clear
        CASE CHR$(0) + "=": 'F3 = mark console
            DPRINT "INKEY$: 'F3' MARK CONSOLE", DEBUG_AVG
            console_mark
        CASE CHR$(0) + ">": 'F4 = toggle ball char
            DPRINT "INKEY$: 'F4' toggle ball char", DEBUG_AVG
            ball_toggle_char
        CASE CHR$(0) + "?": 'F5 = start debugging
            DPRINT "INKEY$: 'F5' START DEBUGGING", DEBUG_AVG
            debug_start : stats_update
        CASE CHR$(0) + "A": 'F7 = go to next debug step
            DPRINT "INKEY$: 'F7' NEXT STEP", DEBUG_AVG
            debug_next : stats_update
        CASE CHR$(0) + "B": 'F8 = stop debugging
            DPRINT "INKEY$: 'F8' STOP DEBUGGING", DEBUG_AVG
            debug_stop : game_step
        CASE CHR$(0) + "C": 'F9 = debug level min
            DPRINT "INKEY$: 'F9' DEBUG LEVEL MIN", DEBUG_AVG
            DEBUG.VERBOSITY% = DEBUG_MIN : stats_update
        CASE CHR$(0) + "D": 'F10 = debug level avg
            DPRINT "INKEY$: 'F10' DEBUG LEVEL AVG", DEBUG_AVG
            DEBUG.VERBOSITY% = DEBUG_AVG : stats_update
        CASE CHR$(0) + CHR$(133): 'F11 = debug level max
            DPRINT "INKEY$: 'F11' DEBUG LEVEL MAX", DEBUG_AVG
            DEBUG.VERBOSITY% = DEBUG_MAX : stats_update
        'FUTURE - add F12 - toggle cross hair to show x, y of screen and ball
        CASE CHR$(27): '  ESC = Quit
            DPRINT "INKEY$: 'ESC' QUIT", DEBUG_AVG
            timers_main_shutdown
            SYSTEM
    END SELECT

    IF DEBUG.ENABLED% = TRUE THEN
        IF DEBUG.NEXT_STEP% = TRUE THEN game_step
    ELSE
        game_step
    END IF

    _DISPLAY
    
LOOP UNTIL _KEYHIT = 27 'ESC = Quit

COLOR 0, 7 : CLS
SYSTEM

SUB game_step
    DPRINT "game_step", DEBUG_MIN
    IF DEBUG.ENABLED% = TRUE THEN DEBUG.NEXT_STEP% = FALSE
    ball_move
    ball_stay_in_bounds
    stats_update
END SUB

SUB configure
    DPRINT "configure", DEBUG_AVG
    CFG.FULLSCREEN%        = TRUE
    CFG.FULLSCREEN_SMOOTH% = TRUE
    CFG.RANDOM_BG%         = TRUE
    CFG.RANDOM_FG%         = TRUE
    CFG.SOUND_ENABLED%     = TRUE
    CFG.BALL_CHAOS_TIMER%  = TRUE
    CFG.RAND_NUM_BLOCKS%   = TRUE
    CFG.CHAOS_SECS%        = 5
    CFG.NUM_BLOCKS%        = 16
    CFG.ORIG_NUM_BLOCKS%   = CFG.NUM_BLOCKS%
    CFG.PREV_NUM_BLOCKS%   = CFG.NUM_BLOCKS%
    CFG.BLOCK_MAX_W%       = 10
    CFG.BLOCK_MAX_H%       = 10 
    CFG.LIM%               = 30
    CFG.AUTO_BLOCKS_SECS%  = 30
END SUB
SUB screen_init 
    DPRINT "screen_init", DEBUG_AVG
    screen_reset
    __SCREEN.W%            = _WIDTH
    __SCREEN.H%            = _HEIGHT
    __SCREEN.BPP%          = _PIXELSIZE
    __SCREEN.VISIBLE_PAGE% = 0
    __SCREEN.ACTIVE_PAGE%  = 0
    IF CFG.FULLSCREEN% = FALSE THEN
        _SCREENMOVE _MIDDLE
    END IF
END SUB

SUB screen_reset
    DPRINT "screen_reset", DEBUG_AVG
    screen_set_active_page GAME_SCREEN : screen_fullscreen
    screen_set_active_page DEBUGGER_CONSOLE : screen_fullscreen
END SUB


SUB screen_fullscreen
    DPRINT "screen_fullscreen", DEBUG_WTF
    _BLINK OFF
    _CONTROLCHR OFF
    IF CFG.FULLSCREEN% = TRUE THEN
        IF CFG.FULLSCREEN_SMOOTH% = TRUE THEN 
            _FULLSCREEN _SQUAREPIXELS, _SMOOTH
        ELSE
            _FULLSCREEN _SQUAREPIXELS
        END IF
    END IF
END SUB


SUB screen_clear
    DPRINT "screen_clear", DEBUG_AVG
    IF CFG.RANDOM_BG% = TRUE THEN __SCREEN.BG_KOLOR& = rand_in_range(0, 7)
    screen_set_active_page GAME_SCREEN
    COLOR BALL.KOLOR&,__SCREEN.BG_KOLOR&
    CLS
END SUB

SUB screen_set_active_page (page%)
    DPRINT "screen_set_active_page(page%=" + n$(page%) + ")", DEBUG_WTF
    SCREEN ,,page%
    screen_fullscreen
    __SCREEN.ACTIVE_PAGE% = page%
END SUB

SUB screen_set_visible_page (page%)
    DPRINT "screen_set_visible_page(page%=" + n$(page%) + ")", DEBUG_WTF
    SCREEN ,,,page%
    screen_fullscreen
    __SCREEN.VISIBLE_PAGE% = page%
END SUB

SUB screen_set_both_pages (page%)
    DPRINT "screen_set_both_pages(page%=" + n$(page%) + ")", DEBUG_WTF
    SCREEN ,,page%,page%
    screen_fullscreen
    __SCREEN.ACTIVE_PAGE%  = page%
    __SCREEN.VISIBLE_PAGE% = page%
END SUB
SUB ball_init
    DPRINT "ball_init", DEBUG_AVG
    BALL.X%          = rand_in_range(LEVEL.START_X%, LEVEL.END_X%)
    BALL.Y%          = rand_in_range(LEVEL.START_Y%, LEVEL.END_Y%)
    BALL.X_DIR%      = 1
    BALL.Y_DIR%      = -1
    BALL.SPEED%      = 1
    BALL.KOLOR&      = 15
    BALL.HIT_90_NUM% = 0
    BALL.TRACE_PATH% = TRUE
    BALL.DISPLAY$    = CHR$(9)
END SUB


SUB ball_toggle_char
    DPRINT "ball_toggle_char", DEBUG_MAX
    IF BALL.DISPLAY$ = BALL_ROUND$ THEN 
        BALL.DISPLAY$ = BALL_SOLID$
    ELSE 
        BALL.DISPLAY$ = BALL_ROUND$
    ENDIF
    screen_set_active_page GAME_SCREEN
    LOCATE BALL.Y%, BALL.X% : PRINT BALL.DISPLAY$;
END SUB


SUB ball_toggle_trace_path
    DPRINT "ball_toggle_trace_path", DEBUG_MAX
    IF BALL.TRACE_PATH% = TRUE THEN 
        BALL.TRACE_PATH% = FALSE
        ball_clear_traces
    ELSE
        BALL.TRACE_PATH% = TRUE
    END IF
END SUB


SUB ball_clear_traces
    DPRINT "ball_clear_traces", DEBUG_MAX
    DIM AS INTEGER y, x, c
    FOR y% = LEVEL.START_Y% TO LEVEL.END_Y%
        FOR x% = LEVEL.START_X TO LEVEL.END_X%
            c% = SCREEN(y%, x%)
            IF c% = 249 THEN
                screen_set_both_pages GAME_SCREEN
                LOCATE y%, x% : PRINT " ";
            END IF
        NEXT x%
    NEXT y%
END SUB


SUB ball_get_25grid
    DPRINT "ball_get_25grid", DEBUG_AVG 
    DIM AS INTEGER x, y, grid_x, grid_y, char
    FOR y%=1 TO 5
        grid_y% = clamp(BALL.Y%-5 + y%, LEVEL.START_Y%, LEVEL.END_Y%)
        FOR x% = 1 TO 5
            grid_x% = clamp(BALL.X%-5 + x%, LEVEL.START_X%, LEVEL.END_X%)
            screen_set_active_page GAME_SCREEN
            char% = SCREEN(grid_y%, grid_x%)
            IF char% <> ASC(BALL.DISPLAY$) THEN 
                SELECT CASE char%
                    CASE ASC(BLOCK.DISPLAY$):
                        BALL_25GRID(y%, x%) = 1
                    CASE ELSE:
                        BALL_25GRID(y%, x%) = 0
                END SELECT
            END IF
        NEXT x%
    NEXT y%
END SUB


SUB ball_get_9grid
    DPRINT "ball_get_9grid", DEBUG_AVG 
    DIM AS INTEGER x, y, grid_x, grid_y, char
    FOR y%=1 TO 3
        grid_y% = clamp(BALL.Y%-2 + y%, LEVEL.START_Y%, LEVEL.END_Y%)
        FOR x% = 1 TO 3
            grid_x% = clamp(BALL.X%-2 + x%, LEVEL.START_X%, LEVEL.END_X%)
            screen_set_active_page GAME_SCREEN
            char% = SCREEN(grid_y%, grid_x%)
            IF char% <> ASC(BALL.DISPLAY$) THEN 
                SELECT CASE char%
                    CASE ASC(BLOCK.DISPLAY$):
                        BALL_9GRID(y%, x%) = 1
                    CASE ELSE:
                        BALL_9GRID(y%, x%) = 0
                END SELECT
            END IF
        NEXT x%
    NEXT y%
    IF DEBUG.ENABLED% = TRUE AND DEBUG.VERBOSITY% >= DEBUG_AVG THEN ball_dump_9grid
END SUB


SUB ball_dump_9grid
    DPRINT "ball_dump_9grid", DEBUG_AVG
    DIM AS INTEGER y, x
    DIM s AS STRING
    DPRINT "", DEBUG_AVG
    DPRINT "BALL_9GRID(" + n$(y%) + ", " + n$(x%) + ") {", DEBUG_AVG
    FOR y% = 1 TO 3
        s$ = "    "
        FOR x% = 1 TO 3
            s$ = s$ + n$(BALL_9GRID(y%, x%)) + " "
        NEXT x%
        DPRINT s$, DEBUG_AVG
    NEXT y%
    DPRINT "}", DEBUG_AVG
END SUB


FUNCTION ball_will_bounce_9grid% (y%, x%)
    DPRINT "ball_will_bounce_9grid (" + _
        "y%=" + n$(y%) + ", x%=" + n$(x%) + ")", DEBUG_MAX
    DIM AS INTEGER check_y, check_x, checks_sum
    checks_sum% = 0
    FOR check_y% = 1 TO 3
        FOR check_x% = 1 TO 3
            checks_sum% = checks_sum% + BALL_9GRID(check_y%, check_x%)
        NEXT check_x%
    NEXT check_y%
    IF checks_sum% > 0 THEN
        ball_chaos_hold
        ball_will_bounce_9grid% = TRUE
    ELSE
        ball_will_bounce_9grid% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_bounce_25grid% (y%, x%)
    DPRINT "ball_will_bounce_25grid (" + _
        "y%=" + n$(y%) + ", x%=" + n$(x%) + ")", DEBUG_MAX
    DIM AS INTEGER check_y, check_x, checks_sum
    checks_sum% = 0
    FOR check_y% = 1 TO 5
        FOR check_x% = 1 TO 5
            checks_sum% = checks_sum% + BALL_25GRID(check_y%, check_x%)
        NEXT check_x%
    NEXT check_y%
    IF checks_sum% > 0 THEN
        ball_chaos_hold
        ball_will_bounce_25grid% = TRUE
    ELSE
        ball_will_bounce_25grid% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_invert_path% ()
    DPRINT "ball_will_invert_path()", DEBUG_AVG
    DIM AS INTEGER top_left, top_right, bot_left, bot_right, sum
    '_3L = 3 L shape neighbors _2L = partial L shape neighbors (2 but not 3)
    DIM AS INTEGER top_left_2L, top_right_2L, bot_left_2L, bot_right_2L
    DIM AS INTEGER top_left_3L, top_right_3L, bot_left_3L, bot_right_3L
    DIM AS INTEGER top_left_4L, top_right_4L, bot_left_4L, bot_right_4L
    DIM AS INTEGER top_left_5L, top_right_5L, bot_left_5L, bot_right_5L

    'x..
    '.*.
    '...\ = x-1 y-1
    top_left% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '..x
    '.*.
    '.../ = x+1 y-1
    top_right% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '...
    '.*.
    'x../ = x-1 y+1
    bot_left% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '...
    '.*.
    '..x\ = x+1 y+1
    bot_right% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'xx.
    'x*.
    '...\ = x-1 y-1
    top_left_2L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '.xx
    '.*x
    '.../ = x+1 y-1
    top_right_2L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '...
    'x*.
    'xx./ = x-1 y+1
    bot_left_2L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '...
    '.*x
    '.xx\ = x+1 y+1
    bot_right_2L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'xxx
    'x*.
    'x..\ = x-1 y-1
    top_left_3L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    'xxx
    '.*x
    '..x/ = x+1 y-1
    top_right_3L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'x..
    'x*.
    'xxx/ = x-1 y+1
    bot_left_3L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    '..x
    '.*x
    'xxx\ = x+1 y+1
    bot_right_3L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'xx.
    'x*.
    'x..\ = x-1 y-1
    top_left_4L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '.xx
    '.*x
    '..x/ = x+1 y-1
    top_right_4L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 1) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'x..
    'x*.
    'xx./ = x-1 y+1
    bot_left_4L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    '..x
    '.*x
    '.xx\ = x+1 y+1
    bot_right_4L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 1) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'x.x
    'x*.
    'x..\ = x-1 y-1
    top_left_5L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 0) _
    )
    'x.x
    '.*x
    '..x/ = x+1 y-1
    top_right_5L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 0) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    'x..
    'x*.
    'x.x/ = x-1 y+1
    bot_left_5L% = ( _
            (BALL_9GRID(1,1) = 1) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 0) _
        AND (BALL_9GRID(2,1) = 1) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 0) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    '..x
    '.*x
    'x.x\ = x+1 y+1
    bot_right_5L% = ( _
            (BALL_9GRID(1,1) = 0) _
        AND (BALL_9GRID(1,2) = 0) _
        AND (BALL_9GRID(1,3) = 1) _
        AND (BALL_9GRID(2,1) = 0) _
        AND (BALL_9GRID(2,2) = 0) _
        AND (BALL_9GRID(2,3) = 1) _
        AND (BALL_9GRID(3,1) = 1) _
        AND (BALL_9GRID(3,2) = 0) _
        AND (BALL_9GRID(3,3) = 1) _
    )
    sum% = 0
    DIM AS INTEGER will_corner, will_2L, will_3L, will_4L, will_5L, will_invert
    will_corner% = FALSE
    will_2L% = FALSE : will_3L% = FALSE : will_4L% = FALSE : will_5L% = FALSE
    will_invert% = FALSE
    IF top_left%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = -1 THEN 
        sum% = sum% + 1 : will_corner% = TRUE
    END IF
    IF top_right% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = -1 THEN 
        sum% = sum% + 1 : will_corner% = TRUE
    END IF
    IF bot_left%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = 1 THEN 
        sum% = sum% + 1 : will_corner% = TRUE
    END IF
    IF bot_right% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = 1 THEN 
        sum% = sum% + 1 : will_corner% = TRUE
    END IF
    IF top_left_2L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_2L% = TRUE
    END IF
    IF top_right_2L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_2L% = TRUE
    END IF
    IF bot_left_2L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_2L% = TRUE
    END IF
    IF bot_right_2L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_2L% = TRUE
    END IF
    IF top_left_3L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_3L% = TRUE
    END IF
    IF top_right_3L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_3L% = TRUE
    END IF
    IF bot_left_3L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_3L% = TRUE
    END IF
    IF bot_right_3L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_3L% = TRUE
    END IF
    IF top_left_4L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_4L% = TRUE
    END IF
    IF top_right_4L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_4L% = TRUE
    END IF
    IF bot_left_4L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_4L% = TRUE
    END IF
    IF bot_right_4L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_4L% = TRUE
    END IF
    IF top_left_5L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_5L% = TRUE
    END IF
    IF top_right_5L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = -1 THEN
        sum% = sum% + 1 : will_5L% = TRUE
    END IF
    IF bot_left_5L%  = TRUE AND BALL.X_DIR% = -1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_5L% = TRUE
    END IF
    IF bot_right_5L% = TRUE AND BALL.X_DIR% = 1 AND BALL.Y_DIR% = 1 THEN
        sum% = sum% + 1 : will_5L% = TRUE
    END IF
    IF sum% > 0 THEN will_invert% = TRUE
    DPRINT "    top_left%=" + b$(top_left%), DEBUG_WTF
    DPRINT "   top_right%=" + b$(top_right%), DEBUG_WTF
    DPRINT "    bot_left%=" + b$(bot_left%), DEBUG_WTF
    DPRINT "   bot_right%=" + b$(bot_right%), DEBUG_WTF
    DPRINT " top_left_2L%=" + b$(top_left_2L%), DEBUG_WTF
    DPRINT "top_right_2L%=" + b$(top_right_2L%), DEBUG_WTF
    DPRINT " bot_left_2L%=" + b$(bot_left_2L%), DEBUG_WTF
    DPRINT "bot_right_2L%=" + b$(bot_right_2L%), DEBUG_WTF
    DPRINT " top_left_3L%=" + b$(top_left_3L%), DEBUG_WTF
    DPRINT "top_right_3L%=" + b$(top_right_3L%), DEBUG_WTF
    DPRINT " bot_left_3L%=" + b$(bot_left_3L%), DEBUG_WTF
    DPRINT "bot_right_3L%=" + b$(bot_right_3L%), DEBUG_WTF
    DPRINT " top_left_4L%=" + b$(top_left_4L%), DEBUG_WTF
    DPRINT "top_right_4L%=" + b$(top_right_4L%), DEBUG_WTF
    DPRINT " bot_left_4L%=" + b$(bot_left_4L%), DEBUG_WTF
    DPRINT "bot_right_4L%=" + b$(bot_right_4L%), DEBUG_WTF
    DPRINT " top_left_5L%=" + b$(top_left_5L%), DEBUG_WTF
    DPRINT "top_right_5L%=" + b$(top_right_5L%), DEBUG_WTF
    DPRINT " bot_left_5L%=" + b$(bot_left_5L%), DEBUG_WTF
    DPRINT "bot_right_5L%=" + b$(bot_right_5L%), DEBUG_WTF
    DPRINT "-------------", DEBUG_WTF
    DPRINT " sum: " + n$(sum%), DEBUG_WTF
    DPRINT "-------------", DEBUG_WTF
    DPRINT " will invert%=" + b$(will_invert%), DEBUG_WTF
    DPRINT " will_corner%=" + b$(will_corner%), DEBUG_WTF
    DPRINT "     will_2L%=" + b$(will_2L%), DEBUG_WTF
    DPRINT "     will_3L%=" + b$(will_3L%), DEBUG_WTF
    DPRINT "     will_4L%=" + b$(will_4L%), DEBUG_WTF
    DPRINT "     will_5L%=" + b$(will_5L%), DEBUG_WTF
    IF sum% > 0 THEN
        DPRINT "ball_will_invert_path = TRUE", DEBUG_WTF
        ball_sound_invert
        ball_will_invert_path% = TRUE
    ELSE
        DPRINT "ball_will_invert_path = FALSE", DEBUG_WTF
        ball_will_invert_path% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_bounce_left% ()
    DPRINT "ball_will_bounce_left()", DEBUG_AVG
    '..x
    '.*x
    '..x
    IF BALL_9GRID(1,3) _
     + BALL_9GRID(2,3) _
     + BALL_9GRID(3,3) >= 2 _
    THEN 
        DPRINT "ball_will_bounce_left = TRUE", DEBUG_AVG
        BALL.HIT_90_NUM% = 0
        ball_will_bounce_left% = TRUE
    ELSE
        DPRINT "ball_will_bounce_left = FALSE", DEBUG_AVG
        ball_will_bounce_left% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_bounce_right% ()
    DPRINT "ball_will_bounce_right()", DEBUG_AVG
    'x..
    'x*.
    'x..
    IF BALL_9GRID(1,1) _
     + BALL_9GRID(2,1) _
     + BALL_9GRID(3,1) >= 2 _
    THEN 
        DPRINT "ball_will_bounce_right = TRUE", DEBUG_AVG
        BALL.HIT_90_NUM% = 0
        ball_will_bounce_right% = TRUE
    ELSE
        DPRINT "ball_will_bounce_right = FALSE", DEBUG_AVG
        ball_will_bounce_right% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_bounce_down% ()
    DPRINT "ball_will_bounce_down()", DEBUG_AVG
    'xxx
    '.*.
    '...
    IF BALL_9GRID(1,1) _
     + BALL_9GRID(1,2) _
     + BALL_9GRID(1,3) >= 2 _
    THEN 
        DPRINT "ball_will_bounce_down = TRUE", DEBUG_AVG
        BALL.HIT_90_NUM% = 0
        ball_will_bounce_down% = TRUE
    ELSE
        DPRINT "ball_will_bounce_down = FALSE", DEBUG_AVG
        ball_will_bounce_down% = FALSE
    END IF
END FUNCTION


FUNCTION ball_will_bounce_up% ()
    DPRINT "ball_will_bounce_up()", DEBUG_AVG
    '...
    '.*.
    'xxx
    IF BALL_9GRID(3,1) _
     + BALL_9GRID(3,2) _
     + BALL_9GRID(3,3) >= 2 _
    THEN 
        DPRINT "ball_will_bounce_up = TRUE", DEBUG_AVG
        BALL.HIT_90_NUM% = 0
        ball_will_bounce_up% = TRUE
    ELSE
        DPRINT "ball_will_bounce_up = FALSE", DEBUG_AVG
        ball_will_bounce_up% = FALSE
    END IF
END FUNCTION


SUB ball_hit_block
    DPRINT "ball_hit_block", DEBUG_AVG
    DIM AS INTEGER _
        bouncing_up, bouncing_down, _
        bouncing_left, bouncing_right, _
        inverting_path, bouncing
    bouncing%       = FALSE
    bouncing_up%    = ball_will_bounce_up%
    bouncing_down%  = ball_will_bounce_down%
    bouncing_left%  = ball_will_bounce_left%
    bouncing_right% = ball_will_bounce_right%
    inverting_path% = ball_will_invert_path%
    IF inverting_path% = TRUE THEN
        BALL.Y_DIR% = BALL.Y_DIR% * -1
        BALL.X_DIR% = BALL.X_DIR% * -1
        BALL.HIT_90_NUM% = BALL.HIT_90_NUM% + 1
        ball_sound_invert
    ELSEIF bouncing_up% = TRUE THEN 
        BALL.Y_DIR% = -1
        bouncing% = TRUE
    ELSEIF bouncing_down% = TRUE THEN 
        BALL.Y_DIR% = 1
        bouncing% = TRUE
    ELSEIF bouncing_left% = TRUE THEN 
        BALL.X_DIR% = -1
        bouncing% = TRUE
    ELSEIF bouncing_right% = TRUE THEN 
         BALL.X_DIR% = 1
        bouncing% = TRUE
    END IF
    IF bouncing% = TRUE THEN ball_sound_hit_block
END SUB


SUB ball_erase (y%, x%)
    DPRINT "ball_erase", DEBUG_AVG
    DIM AS INTEGER c
    y% = clamp(y%, LEVEL.START_Y%, LEVEL.END_Y%)
    x% = clamp(x%, LEVEL.START_X%, LEVEL.END_X%)
    c% = SCREEN(y%, x%)
    IF c% = ASC(BLOCK.DISPLAY$) THEN EXIT SUB
    screen_set_active_page GAME_SCREEN
    COLOR BALL.KOLOR&, __SCREEN.BG_KOLOR&
    IF BALL.TRACE_PATH% = FALSE THEN 
        LOCATE y%, x% : PRINT SPACE$(LEN(BALL.DISPLAY$))
    ELSE 
        LOCATE y%, x% : PRINT CHR$(249);
    END IF
END SUB


SUB ball_move
    DPRINT "ball_move", DEBUG_AVG
    ball_erase BALL.Y%, BALL.X%
    ball_get_9grid
    IF (ball_will_bounce_9grid(BALL.Y%, BALL.X%)) THEN
        ball_hit_block
    END IF
    BALL.X% = clamp(BALL.X% + BALL.X_DIR%, LEVEL.START_X%, LEVEL.END_X%)
    BALL.Y% = clamp(BALL.Y% + BALL.Y_DIR%, LEVEL.START_Y%, LEVEL.END_Y%)
    screen_set_active_page GAME_SCREEN
    COLOR BALL.KOLOR&, __SCREEN.BG_KOLOR&
    LOCATE BALL.Y%, BALL.X% : PRINT BALL.DISPLAY$;
    ball_chaos_unhold
END SUB

SUB ball_chaos_hold
    DPRINT "ball_chaos_hold", DEBUG_MAX
    TICKS_TIMER.HOLD% = TRUE
END SUB

SUB ball_chaos_unhold
    DPRINT "ball_chaos_unhold", DEBUG_MAX
    TICKS_TIMER.HOLD% = FALSE
END SUB

SUB ball_chaos
    DIM AS INTEGER old_x, old_y, x, y, sum
    ball_get_25grid
    FOR y% = 1 TO 5
        FOR x% = 1 TO 5
            sum% = sum% + BALL_25GRID(y%, x%)
        NEXT x%
    NEXT y%
    IF sum% = 0 THEN
        old_x% = BALL.X% : old_y% = BALL.Y%
        ball_erase old_y%, old_x%
        BALL.X% = BALL.X% + (rand_in_range(0,1) * rand_sign)
        BALL.Y% = BALL.Y% + (rand_in_range(0,1) * rand_sign)
        DIM s AS STRING
        s$ = "***** BALL_CHAOS_TIMER ***** "
        s$ = s$ + "OLD BALL.Y%=" + n$(old_y%)
        s$ = s$ + ", BALL.X%=" + n$(old_x%)
        s$ = s$ + " -> NEW BALL.Y%=" + n$(BALL.Y%)
        s$ = s$ + ", BALL.X%=" + n$(BALL.X%)
        DPRINT s$, DEBUG_MIN
        ball_sound_chaos
    ELSE
        ball_chaos_hold
    END IF
END SUB


SUB ball_stay_in_bounds
    DPRINT "ball_stay_in_bounds", DEBUG_AVG
    DIM AS INTEGER new_x, pad
    IF BALL.Y% <= LEVEL.START_Y% THEN 
        ball_bounce_top
    ELSEIF BALL.X% >= LEVEL.END_X% THEN 
        ball_bounce_right
    ELSEIF BALL.Y% >= LEVEL.END_Y% THEN 
        ball_bounce_bot
    ELSEIF BALL.X% <= LEVEL.START_X% THEN 
        ball_bounce_left
    END IF
    pad% = 3
    'top left corner of level
    IF BALL.Y% = (LEVEL.START_Y% + pad%) AND BALL.X% = (LEVEL.START_X% + pad%) THEN
        DPRINT "* IN TOP LEFT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% + rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            ball_erase BALL.Y%, BALL.X%
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF        
    END IF
    'bottom left corner of level
    IF BALL.Y% = (LEVEL.END_Y% - pad%) AND BALL.X% = (LEVEL.START_X% + pad%) THEN
        DPRINT "* IN BOTTOM LEFT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% + rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            ball_erase BALL.Y%, BALL.X%
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF
    'top right corner of level
    IF BALL.Y% = (LEVEL.START_Y% + pad%) AND BALL.X% = (LEVEL.END_X% - pad%) THEN
        DPRINT "* IN TOP RIGHT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% - rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            ball_erase BALL.Y%, BALL.X%
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF
    'bottom right corner of level
    IF BALL.Y% = (LEVEL.END_Y% - pad%) AND BALL.X% = (LEVEL.END_X% - pad%) THEN
        DPRINT "* IN BOTTOM RIGHT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% - rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            ball_erase BALL.Y%, BALL.X%
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF    
END SUB


SUB ball_bounce_top
    DPRINT "ball_bounce_top", DEBUG_AVG
    BALL.Y_DIR% = BALL.Y_DIR% * -1
    DIM AS INTEGER new_x
    ball_sound_bounce_top
END SUB


SUB ball_bounce_right   
    DPRINT "ball_bounce_right", DEBUG_AVG
    BALL.X_DIR% = BALL.X_DIR% * -1
    ball_sound_bounce_right
END SUB


SUB ball_bounce_bot
    DPRINT "ball_bounce_bot", DEBUG_AVG
    BALL.Y_DIR% = BALL.Y_DIR% * -1
    ball_sound_bounce_bot
END SUB


SUB ball_bounce_left
    DPRINT "ball_bounce_left", DEBUG_AVG
    BALL.X_DIR% = BALL.X_DIR% * -1
    ball_sound_bounce_left
END SUB


SUB ball_toggle_sound
    DPRINT "ball_toggle_sound", DEBUG_MAX
    IF CFG.SOUND_ENABLED% = TRUE THEN 
        CFG.SOUND_ENABLED% = FALSE
    ELSE
        CFG.SOUND_ENABLED% = TRUE
    END IF
END SUB


SUB ball_sound_random
    DPRINT "ball_sound_random", DEBUG_MAX
    STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    ball_soundfx_random
END SUB

SUB ball_soundfx_random
    PLAY "V25 O5 T255 MS L64 C,D#,E#,G MF"
END SUB

SUB ball_sound_chaos
    DPRINT "ball_sound_chaos", DEBUG_MAX
    STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    PLAY "V25 O6 T180 MS L64 DD#DD#DD#DD# MF"
END SUB

SUB ball_sound_bounce_top
    DPRINT "ball_sound_bounce_top", DEBUG_MAX
    STATS.TOP_BOUNCES% = STATS.TOP_BOUNCES% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    PLAY "V50 O4 T180 MS L32 C MF"
END SUB

SUB ball_sound_bounce_bot
    DPRINT "ball_sound_bounce_bot", DEBUG_MAX
    STATS.BOT_BOUNCES% = STATS.BOT_BOUNCES% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    PLAY "V50 O3 T180 MS L32 C MF"
END SUB

SUB ball_sound_bounce_left
    DPRINT "ball_sound_bounce_left", DEBUG_MAX
    STATS.LEFT_BOUNCES% = STATS.LEFT_BOUNCES% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    PLAY "V50 O3 T180 MS L32 F MF"
END SUB

SUB ball_sound_bounce_right
    DPRINT "ball_sound_bounce_right", DEBUG_MAX
    STATS.RIGHT_BOUNCES% = STATS.RIGHT_BOUNCES% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    PLAY "V50 O3 T180 MS L32 G MF"
END SUB

SUB ball_sound_hit_block
    DPRINT "ball_sound_hit_block", DEBUG_MAX
    STATS.BLOCK_BOUNCES% = STATS.BLOCK_BOUNCES% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    DIM r AS INTEGER
    r% = rand_in_range(1,6)
    SELECT CASE r%
        CASE 1:
            PLAY "V70 O1 T180 MS L32 C MF"
        CASE 2: 
            PLAY "V70 O1 T180 MS L32 G MF"
        CASE 3:
            PLAY "V70 O1 T180 MS L32 D MF"
        CASE 4:
            PLAY "V70 O1 T180 MS L32 F MF"
        CASE 5:
            PLAY "V70 O1 T180 MS L32 G MF"
        CASE 5:
            PLAY "V70 O3 T255 MS L64 A MF"
    END SELECT
END SUB

SUB ball_sound_invert
    DPRINT "ball_sound_invert", DEBUG_MAX
    STATS.BALL_INVERTS% = STATS.BALL_INVERTS% + 1
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    ball_soundfx_random
END SUB
SUB block_init
    DPRINT "block_init", DEBUG_AVG
    BLOCK.X%       = 1
    BLOCK.Y%       = 1
    BLOCK.W%       = CFG.BLOCK_MAX_W%
    BLOCK.H%       = CFG.BLOCK_MAX_H%
    BLOCK.INDEX%   = 0
    BLOCK.KOLOR&   = 10
    BLOCK.LIVES%   = 3
    BLOCK.DISPLAY$ = CHR$(219) 'CHR$(177)
END SUB


SUB blocks_init
    DPRINT "blocks_init", DEBUG_AVG
    blocks_sound_init
    DIM AS INTEGER i, j, w, h, x, y, in_range_x, in_range_y
    DIM c AS LONG
    screen_clear
    IF CFG.RAND_NUM_BLOCKS% = TRUE THEN
        CFG.PREV_NUM_BLOCKS% = CFG.NUM_BLOCKS%
        CFG.NUM_BLOCKS% = rand_in_range(1, CFG.ORIG_NUM_BLOCKS%)
    END IF
    REDIM BLOCKS(1 TO CFG.NUM_BLOCKS%) AS BLOCK_OBJECT
    ball_get_9grid
    FOR i% = 1 TO CFG.NUM_BLOCKS%
        w% = rand_in_range(1, CFG.BLOCK_MAX_W%)
        h% = rand_in_range(1, CFG.BLOCK_MAX_H%)
        DO: 'prevent creation of block where ball currently is
            x% = clamp(rand_in_range(LEVEL.START_X%, LEVEL.END_X%-w%), 1, LEVEL.END_X%)
            y% = clamp(rand_in_range(LEVEL.START_Y%, LEVEL.END_Y%-h%), 1, LEVEL.END_Y%)
            in_range_x% = in_range(BALL.X%, x%, x%+w%)
            in_range_y% = in_range(BALL.Y%, y%, y%+h%)
        LOOP UNTIL in_range_x% = FALSE AND in_range_y% = FALSE AND ball_will_bounce_9grid(y%, x%) = FALSE
        IF CFG.RANDOM_BG% = TRUE THEN 
            DO:
                c& = rand_in_range(8,15)
            LOOP UNTIL c& <> _BACKGROUNDCOLOR
        ELSE
            DO:
                c& = rand_in_range(1,15)
            LOOP UNTIL c& <> _BACKGROUNDCOLOR
        END IF
        IF CFG.RANDOM_FG% = TRUE THEN
            DO:
                BALL.KOLOR& = rand_in_range(8,15)
            LOOP UNTIL BALL.KOLOR& <> _BACKGROUNDCOLOR
        END IF
        ' kludge to fix contrast for low contrast color combinations
        IF BALL.KOLOR& = 3 AND _BACKGROUNDCOLOR = 2 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 2 AND _BACKGROUNDCOLOR = 3 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 4 AND _BACKGROUNDCOLOR = 5 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 5 AND _BACKGROUNDCOLOR = 4 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 1 AND _BACKGROUNDCOLOR = 4 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 4 AND _BACKGROUNDCOLOR = 1 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 6 AND _BACKGROUNDCOLOR = 5 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 5 AND _BACKGROUNDCOLOR = 6 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 6 AND _BACKGROUNDCOLOR = 4 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 4 AND _BACKGROUNDCOLOR = 6 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 6 AND _BACKGROUNDCOLOR = 3 THEN BALL.KOLOR& = 15
        IF BALL.KOLOR& = 3 AND _BACKGROUNDCOLOR = 6 THEN BALL.KOLOR& = 15
        IF _BACKGROUNDCOLOR = 7 THEN BALL.KOLOR& = 0
        BLOCKS(i%).X% = x%
        BLOCKS(i%).Y% = y%
        BLOCKS(i%).W% = rand_in_range(1, CFG.BLOCK_MAX_W%)
        BLOCKS(i%).H% = rand_in_range(1, CFG.BLOCK_MAX_H%)
        BLOCKS(i%).KOLOR& = c&
        FOR j% = y% TO y%+h%
            screen_set_active_page GAME_SCREEN
            LOCATE j%, x%
            COLOR c&, __SCREEN.BG_KOLOR&
            PRINT STRING$(w%, BLOCK.DISPLAY$);
        NEXT j%    
    NEXT i%
END SUB


SUB blocks_inc
    DPRINT "blocks_inc", DEBUG_AVG
    CFG.PREV_NUM_BLOCKS% = CFG.NUM_BLOCKS%
    CFG.NUM_BLOCKS% = min(CFG.NUM_BLOCKS%+1, 1)
    IF CFG.PREV_NUM_BLOCKS% <> CFG.NUM_BLOCKS% THEN blocks_init
END SUB


SUB blocks_dec
    DPRINT "blocks_dev", DEBUG_AVG
    CFG.PREV_NUM_BLOCKS% = CFG.NUM_BLOCKS%
    CFG.NUM_BLOCKS% = min(CFG.NUM_BLOCKS%-1, 1)
    IF CFG.PREV_NUM_BLOCKS% <> CFG.NUM_BLOCKS% THEN blocks_init
END SUB


SUB blocks_sound_init
    DPRINT "blocks_sound_init", DEBUG_AVG
    IF CFG.SOUND_ENABLED% = FALSE THEN EXIT SUB
    DIM r AS INTEGER
    r% = rand_in_range(1,6)
    SELECT CASE r%
        CASE 1:
            PLAY "V70 O3 T180 MS L32 C,C#,D,D# O4 C,C#,D,D# O5 C,C#,D,D# MB"
        CASE 2: 
            PLAY "V70 O3 T180 MS L32 G,G#,A,A# O4 G,G#,A,A# O5 G,G#,A,A# MB"
        CASE 3:
            PLAY "V70 O3 T180 MS L32 D,D#,E,E# O4 D,D#,E,E# O5 D,D#,E,E# MB"
        CASE 4:
            PLAY "V70 O3 T180 MS L32 F,F#,G,G# O4 F,F#,G,G# O5 F,F#,G,G# MB"
        CASE 5:
            PLAY "V70 O3 T180 MS L32 B,B#,C,C# O4 B,B#,C,C# O5 B,B#,C,C# MB"
        CASE 5:
            PLAY "V70 O3 T255 MS L32 A,A#,C,C# O4 A,A#,C,C# O5 A,A#,C,C# MB"
    END SELECT    
END SUB
SUB level_init
    DPRINT "level_init", DEBUG_AVG
    LEVEL.START_X% = 1
    LEVEL.START_Y% = 1
    LEVEL.END_X%   = _WIDTH
    LEVEL.END_Y%   = _HEIGHT - 3
END SUB
SUB stats_init
    DPRINT "stats_init", DEBUG_AVG
    STATS.TOP_BOUNCES%   = 0
    STATS.RIGHT_BOUNCES% = 0
    STATS.BOT_BOUNCES%   = 0
    STATS.LEFT_BOUNCES%  = 0
    STATS.BLOCK_BOUNCES% = 0
    STATS.BALL_INVERTS%  = 0
    STATS.BALL_RANDOMS%  = 0
END Sub


SUB stats_update
    DPRINT "stats_update", DEBUG_MAX
    DIM t AS INTEGER
    DIM AS LONG old_fg, old_bg
    old_fg& = _DEFAULTCOLOR
    old_bg& = _BACKGROUNDCOLOR
    t% = STATS.TOP_BOUNCES%
    DIM AS STRING s, s2, s3
    s$ = "ESC:END,SPACE:RND,+/-:SPD,F1:TRACE,F4:BALL,F5:DEBUG->HOME/END:SHOW/HIDE CONSOLE"

    s2$ = "BOUNCE"
    IF BALL.TRACE_PATH% = TRUE THEN s2$ = s2$ + " TR"
    s2$ = s2$ + " T" + n$(STATS.TOP_BOUNCES%)
    s2$ = s2$ + " R" + n$(STATS.RIGHT_BOUNCES%)
    s2$ = s2$ + " B" + n$(STATS.BOT_BOUNCES%)
    s2$ = s2$ + " L" + n$(STATS.LEFT_BOUNCES%)
    s2$ = s2$ + " BL" + n$(STATS.BLOCK_BOUNCES%)
    ' s2$ = s2$ + " BI" + n$(STATS.BALL_INVERTS%)
    ' s2$ = s2$ + " BR" + n$(STATS.BALL_RANDOMS%)
    ' s2$ = s2$ + " B9" + n$(BALL.HIT_90_NUM%)
    ' s2$ = s2$ + " TI:" + ln$(TICKS_TIMER.SECONDS&)
    s2$ = s2$ + " FPS:" + n$(CFG.LIM%)
    s2$ = s2$ + " #B" + n$(CFG.NUM_BLOCKS%)
    IF DEBUG.DO_BREAKPOINTS% = TRUE THEN
        s2$ = s2$ + " B:RKP ON"
    ELSE
        s2$ = s2$ + " B:RKP OFF"
    END IF
    IF CFG.SOUND_ENABLED% = TRUE THEN
        s2$ = s2$ + " S:ND ON"
    ELSE
        s2$ = s2$ + " S:ND OFF"
    END IF

    screen_set_both_pages GAME_SCREEN
    LOCATE _HEIGHT-2, 1 : PRINT SPACE$(_WIDTH)
    IF DEBUG.ENABLED% = TRUE THEN
        SELECT CASE DEBUG.VERBOSITY%
            CASE DEBUG_MIN: 
                s3$ = "[MIN]"
            CASE DEBUG_AVG: 
                s3$ = "[AVG]"
            CASE DEBUG_MAX: 
                s3$ = "[MAX]"
        END SELECT
        s3$ = s3$ + " S:" + n$(DEBUG.CUR_STEP%)
        s3$ = s3$ + "  F2:CLR  F3:MARK  F7:NEXT  F8:STOP"
        s3$ = s3$ + "  F9:MIN  F10:AVG  F11:MAX"
        COLOR 0,15
        LOCATE _HEIGHT-2, 1 : PRINT SPACE$(_WIDTH)
        LOCATE _HEIGHT-2, 1 : PRINT s3$;
    END IF
    COLOR 15, 0
    LOCATE _HEIGHT-1, 1 : PRINT SPACE$(_WIDTH);
    LOCATE _HEIGHT-1, 1 : PRINT s$;
    LOCATE _HEIGHT, 1 : PRINT SPACE$(_WIDTH);
    LOCATE _HEIGHT, 1 : PRINT s2$;
    COLOR old_fg&, old_bg&
END SUB
SUB timers_init
    DPRINT "timers_init", DEBUG_AVG
    TICKS_TIMER.STARTED#   = TIMER
    TICKS_TIMER.TICKS&     = 0
    TICKS_TIMER.SECONDS&   = 0
    TIMER_LAPS(0).STARTED# = TICKS_TIMER.STARTED#
    TICKS_TIMER.LAP_COUNT% = 1
    TICKS_TIMER.HOLD%      = FALSE
    timers_main_startup
END SUB

SUB timers_tick
    DPRINT "timers_tick", DEBUG_MAX
    IF CFG.AUTO_BLOCKS_SECS% > 0 THEN
        IF TICKS_TIMER.TICKS& > 0 AND TICKS_TIMER.TICKS& MOD CFG.AUTO_BLOCKS_SECS% = 0 THEN 
            blocks_init
        END IF
    END IF
    IF CFG.BALL_CHAOS_TIMER% = TRUE AND TICKS_TIMER.HOLD% = FALSE THEN
        IF TICKS_TIMER.TICKS& MOD CFG.CHAOS_SECS% = 0 THEN
            ball_chaos
        END IF
    END IF
    TICKS_TIMER.TICKS& = TICKS_TIMER.TICKS& + 1
    TICKS_TIMER.SECONDS& = TICKS_TIMER.SECONDS& + 1
END SUB

SUB timers_ticks_reset
    DPRINT "timers_ticks_reset", DEBUG_AVG
    TICKS_TIMER.TICKS&   = 0
    TICKS_TIMER.SECONDS& = 0
END SUB

SUB timers_main_startup
    DPRINT "timers_main_startup", DEBUG_AVG
    MAIN_TIMER% = _FREETIMER
    ON TIMER(MAIN_TIMER%, 1) timers_tick
    TIMER(MAIN_TIMER%) ON
END SUB

SUB timers_main_shutdown
    DPRINT "timers_main_shutdown", DEBUG_AVG
    TIMER(MAIN_TIMER%) OFF
    TIMER(MAIN_TIMER%) FREE
END SUB

SUB timers_start_lap
    DPRINT "timers_start_lap", DEBUG_MAX
END SUB

SUB timers_end_lap
    DPRINT "timers_end_lap", DEBUG_MAX
END SUB
FUNCTION n$ (integ%)
    DPRINT "n$(integ%=" + _TRIM$(STR$(integ%)) + ")", DEBUG_WTF
    n$ = _TRIM$(STR$(integ%))
END FUNCTION

FUNCTION b$ (integ%)
    DPRINT "b$(integ%=" + _TRIM$(STR$(integ%)) + ")", DEBUG_MAX
    IF integ% = -1 THEN
        b$ = "TRUE"
    ELSEIF integ% = 0 THEN
        b$ = "FALSE"
    ENDIF
END FUNCTION

FUNCTION ln$ (longval!)
    DPRINT "ln$(longval!=" + _TRIM$(STR$(longval!)) + ")", DEBUG_MAX
    ln$ = _TRIM$(STR$(longval!))
END FUNCTION

FUNCTION inc% (value%)
    DPRINT "inc(value%=" + n$(value%) + ")", DEBUG_MAX
    inc% = value% + 1
END FUNCTION

FUNCTION dec% (value%)
    DPRINT "dec(value%=" + n$(value%) + ")", DEBUG_MAX
    dec% = value% - 1
END FUNCTION

FUNCTION inv% (value%)
    DPRINT "inv(value%=" + n$(value%) + ")", DEBUG_MAX
    inv% = value% * -1
END FUNCTION

FUNCTION min% (value%, minimum%)
    DPRINT _
        "min(value%=" + n$(value%) + _
        ", minimum%=" + n$(minimum%) + ")", DEBUG_MAX
    IF value% < minimum% THEN value% = minimum%
    min% = value%
END FUNCTION

FUNCTION max% (value%, maximum%)
    DPRINT _
        "max(value%=" + n$(value%) + _
        ", maximum%=" + n$(maximum%) + ")", DEBUG_MAX
    IF value% > maximum% THEN value% = maximum%
    max% = value%
END FUNCTION

FUNCTION clamp% (value%, minimum%, maximum%)
    DPRINT _
        "clamp(value%=" + n$(value%) + _
        ", minimum%=" + n$(minimum%) + _
        ", maximum%=" + n$(maximum%) + ")", DEBUG_MAX
    IF value% > maximum% THEN
        clamp% = maximum%
    ELSEIF value% < minimum% THEN
        clamp% = minimum%
    ELSE
        clamp% = value%
    END IF
END FUNCTION

FUNCTION in_range% (value%, minimum%, maximum%)
    DPRINT _
        "in_range(value%=" + n$(value%) + _
        ", minimum%=" + n$(minimum%) + _
        ", maximum%=" + n$(maximum%) + ")", DEBUG_MAX
    IF value% >= minimum% AND value% <= maximum% THEN 
        in_range% = TRUE
    ELSE
        in_range% = FALSE
    END IF
END FUNCTION

FUNCTION rand_sign% ()
    DIM r AS INTEGER
    r% = -1 + INT(RND*2)
    IF r% = 0 THEN r% = 1
    rand_sign% = r%
END FUNCTION

FUNCTION rand_in_range% (minimum%, maximum%)
    DPRINT _
        "rand_in_range(minimum%=" + n$(minimum%) + _
        ", maximum%=" + n$(maximum%) + ")", DEBUG_MAX
    rand_in_range% = INT(RND * (maximum% - minimum% + 1)) + 1
END FUNCTION

FUNCTION rand_int_choice% (arr_choices%())
    DPRINT "rand_int_choice(arr_choices%())", DEBUG_MAX
    DIM AS INTEGER minimum, maximum
    minimum% = LBOUND(arr_choices%) : maximum% = UBOUND(arr_choices%)
    rand_int_choice% = arr_choices%(rand_in_range(minimum%, maximum%))
END FUNCTION

FUNCTION rand_str_choice$ (arr_choices$())
    DPRINT "rand_str_choice(arr_choices%())", DEBUG_MAX
    DIM AS INTEGER minimum, maximum
    minimum% = LBOUND(arr_choices$) : maximum% = UBOUND(arr_choices$)
    rand_str_choice$ = arr_choices$(rand_in_range(minimum%, maximum%))
END FUNCTION
SUB debug_init
    DPRINT "debug_init", DEBUG_MAX
    DEBUG.ENABLED%         = FALSE
    DEBUG.DO_BREAKPOINTS%  = TRUE
    DEBUG.IN_CONSOLE%      = FALSE
    DEBUG.VERBOSE%         = TRUE
    DEBUG.VERBOSITY%       = DEBUG_MIN
    DEBUG.NEXT_STEP%       = TRUE
    DEBUG.CUR_STEP%        = 0
    DEBUG.PREV_STEP%       = 0
    DEBUG.PREV_MARK_TIME$  = ""
    DEBUG.PREV_MARK_TIMER# = 0
    DEBUG.MARK_TIME$       = ""
    DEBUG.MARK_TIMER#      = 0
    IF DEBUG.ENABLED% = TRUE THEN debug_start
END SUB

SUB debug_start
    DPRINT "debug_start", DEBUG_MAX
    DEBUG.ENABLED% = TRUE
    TIMER(MAIN_TIMER%) OFF
END SUB

SUB debug_next
    DPRINT "debug_next", DEBUG_MAX
    IF DEBUG.ENABLED% = TRUE THEN
        DEBUG.PREV_STEP% = DEBUG.CUR_STEP%
        DEBUG.CUR_STEP%  = DEBUG.CUR_STEP% + 1
        DEBUG.NEXT_STEP% = TRUE
    END IF
END SUB

SUB debug_breakpoint (msg$)
    DPRINT "debug_breakpoint", DEBUG_MIN
    IF DEBUG.DO_BREAKPOINTS% = TRUE THEN
        DEBUG.ENABLED% = TRUE
        DEBUG.NEXT_STEP% = FALSE
        TIMER(MAIN_TIMER%) OFF
        DPRINT "[BREAKPOINT REACHED]: " + msg$, DEBUG_MIN
        console_mark
        debug_console
    END IF
END SUB

SUB debug_toggle_do_breakpoints
    DPRINT "debug_toggle_do_breakpoints", DEBUG_MAX
    IF DEBUG.DO_BREAKPOINTS% = TRUE THEN 
        DEBUG.DO_BREAKPOINTS% = FALSE
    ELSE 
        DEBUG.DO_BREAKPOINTS% = TRUE
    ENDIF
END SUB


SUB debug_stop
    DPRINT "debug_stop", DEBUG_MAX
    IF DEBUG.ENABLED% = TRUE THEN
        IF DEBUG.IN_CONSOLE% = TRUE THEN 
            debug_console_hide
        END IF
        DEBUG.ENABLED%   = FALSE
        DEBUG.NEXT_STEP% = FALSE
        TIMER(MAIN_TIMER%) ON
    END IF
END SUB

SUB debug_console
    DPRINT "debug_console", DEBUG_MAX
    IF DEBUG.IN_CONSOLE% = FALSE THEN 
        debug_console_show
    ELSE 
        debug_console_hide
    END IF
END SUB

SUB debug_console_show
    DPRINT "debug_console_show", DEBUG_MAX
    screen_set_both_pages DEBUGGER_CONSOLE
    DEBUG.IN_CONSOLE% = TRUE
END SUB

SUB debug_console_hide
    DPRINT "debug_console_hide", DEBUG_MAX
    IF DEBUG.ENABLED% = TRUE THEN
        screen_set_both_pages GAME_SCREEN
        DEBUG.IN_CONSOLE% = FALSE
    END IF
END SUB

SUB console_clear
    DPRINT "console_clear", DEBUG_MAX
    IF DEBUG.ENABLED% = TRUE THEN
        screen_set_active_page DEBUGGER_CONSOLE
        CLS
        DIM i AS INTEGER
        FOR i% = 0 TO 200
            _ECHO ""
        NEXT i%
    END IF
END SUB

SUB console_mark
    DPRINT "console_mark", DEBUG_MAX
    DIM time_diff AS DOUBLE
    IF DEBUG.ENABLED% = TRUE THEN
        DEBUG.MARK_TIME$  = TIME$
        DEBUG.MARK_TIMER# = TIMER
        DPRINT "", DEBUG_MIN
        IF DEBUG.PREV_MARK_TIMER# > 0 THEN
            time_diff# = DEBUG.MARK_TIMER# - DEBUG.PREV_MARK_TIMER#
            DPRINT DEBUG.PREV_MARK_TIME$ + " TO " + DEBUG.MARK_TIME$ + _
                " (" + _TRIM$(STR$(time_diff#)) + ")" + _
                STRING$(40, "="), DEBUG_MIN
        ELSE
            DPRINT DEBUG.MARK_TIME$ + " " + STRING$(40, "="), DEBUG_MIN
        END IF
        DPRINT "", DEBUG_MIN
        DEBUG.PREV_MARK_TIME$  = DEBUG.MARK_TIME$
        DEBUG.PREV_MARK_TIMER# = DEBUG.MARK_TIMER#
    END IF
END SUB

SUB console_log (s$)
    IF DEBUG.ENABLED% = TRUE THEN
        screen_set_active_page DEBUGGER_CONSOLE
        LOCATE ,1 : PRINT s$
    END IF
END SUB

SUB DPRINT (s$, verbosity%)
    IF DEBUG.ENABLED% = TRUE THEN 
        IF DEBUG.VERBOSITY% >= verbosity% THEN console_log(s$)
    END IF
    IF DEBUG.VERBOSE% = TRUE THEN 
        IF DEBUG.VERBOSITY% >= verbosity% THEN _ECHO s$
    END IF
END SUB
