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

DIM k AS STRING 
DO:
    IF CFG.LIM% > 0 THEN _LIMIT CFG.LIM%
    k$ = INKEY$

    SELECT CASE k$
        CASE "=": '+/ = Increase speed by increasing limit
            CFG.LIM% = CFG.LIM% + 1 : stats_update
        CASE "-": '- = Decrease speed by decreasing limit  
            CFG.LIM% = CFG.LIM% - 1 : stats_update
        CASE " ": 'SPACE = randomize blocks
            blocks_init : game_step
        CASE ",": ', = increment total blocks
            blocks_dec : game_step
        CASE ".": '. = decrement total blocks
            blocks_inc : game_step
        CASE CHR$(0) + ";": 'F1 = show debug console
            debug_console : stats_update
        CASE CHR$(0) + "<": 'F2 = clear debug console
            console_clear : stats_update
        CASE CHR$(0) + "=": 'F3 = mark console
            console_mark : stats_update
        CASE CHR$(0) + "?": 'F5 = start debugging
            debug_start : stats_update
        CASE CHR$(0) + "A": 'F7 = go to next debug step
            debug_next : stats_update
        CASE CHR$(0) + "B": 'F8 = stop debugging
            debug_stop : game_step
        CASE CHR$(0) + "C": 'F9 = debug level min
            DEBUG.VERBOSITY% = DEBUG_MIN : stats_update
        CASE CHR$(0) + "D": 'F10 = debug level avg
            DEBUG.VERBOSITY% = DEBUG_AVG : stats_update
        CASE CHR$(0) + CHR$(133): 'F11 = debug level max
            DEBUG.VERBOSITY% = DEBUG_MAX : stats_update
        CASE CHR$(27): ' ESC = Quit
            timers_main_shutdown
            SYSTEM
    END SELECT

    IF DEBUG.ENABLED% THEN
        IF DEBUG.NEXT_STEP% THEN game_step
    ELSE
        game_step
    END IF

    _DISPLAY
    
LOOP UNTIL _KEYHIT = 27 'ESC = Quit

COLOR 0, 7 : CLS
SYSTEM

SUB game_step
    DPRINT "game_step", DEBUG_MIN
    IF DEBUG.ENABLED% THEN DEBUG.NEXT_STEP% = FALSE
    ball_move
    ball_stay_in_bounds
    stats_update
END SUB

'$INCLUDE:'_ALL.BM'
