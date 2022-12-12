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
RANDOMIZE TIMER
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

'$INCLUDE:'_ALL.BI'

configure
screen_init
ball_init
level_init
block_init
blocks_init
timers_init
debug_init

DIM AS STRING k, dmsg
DO:
    IF CFG.LIM% > 0 THEN _LIMIT CFG.LIM%
    k$ = INKEY$
    IF k$ <> "" THEN DPRINT "INKEY$", DEBUG_MIN
    SELECT CASE k$
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
        CASE CHR$(0) + ";": 'F1 = show debug console
            DPRINT "INKEY$: 'F1' DEBUG CONSOLE", DEBUG_AVG
            dmsg$ = " [BEFORE debug_console CODE]" 
            dmsg$ = dmsg$ + "  DEBUG ENABLED: " + b$(DEBUG.ENABLED%)
            dmsg$ = dmsg$ + "  IN CONSOLE: " + b$(DEBUG.IN_CONSOLE%)
            dmsg$ = dmsg$ + "  PREV_STEP: " + n$(DEBUG.PREV_STEP%)
            dmsg$ = dmsg$ + "  NEXT_STEP: " + n$(DEBUG.NEXT_STEP%)
            DPRINT dmsg$, DEBUG_MAX
            debug_console : stats_update
            dmsg$ = " [AFTER debug_console CODE]" 
            dmsg$ = dmsg$ + "  DEBUG ENABLED: " + b$(DEBUG.ENABLED%)
            dmsg$ = dmsg$ + "  IN CONSOLE: " + b$(DEBUG.IN_CONSOLE%)
            dmsg$ = dmsg$ + "  PREV_STEP: " + n$(DEBUG.PREV_STEP%)
            dmsg$ = dmsg$ + "  NEXT_STEP: " + n$(DEBUG.NEXT_STEP%)
            DPRINT dmsg$, DEBUG_MAX
        CASE CHR$(0) + "<": 'F2 = clear debug console
            DPRINT "INKEY$: 'F2' CLEAR CONSOLE", DEBUG_AVG
            console_clear : stats_update
        CASE CHR$(0) + "=": 'F3 = mark console
            DPRINT "INKEY$: 'F3' MARK CONSOLE", DEBUG_AVG
            console_mark : stats_update
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
        CASE CHR$(27): ' ESC = Quit
            DPRINT "INKEY$: 'ESC' QUIT", DEBUG_AVG
            timers_main_shutdown
            SYSTEM
    END SELECT

    IF DEBUG.ENABLED% = TRUE THEN
        IF DEBUG.NEXT_STEP% = TRUE THEN game_step
    ELSE
        game_step
    END IF

    IF DEBUG.IN_CONSOLE% = TRUE THEN 
        IF DEBUG.NEXT_STEP% = TRUE THEN
            DPRINT "debug_show_console", DEBUG_MAX
            debug_show_console
        END IF
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

'$INCLUDE:'_ALL.BM'
