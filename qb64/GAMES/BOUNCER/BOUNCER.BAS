$CONSOLE
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
RANDOMIZE TIMER

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
    IF CFG.LIM > 0 THEN _LIMIT CFG.LIM
    k$ = INKEY$
    SELECT CASE k$
        CASE " "  : blocks_init
        CASE ","  : blocks_inc
        CASE "."  : blocks_dec
        CASE " ?" : debug_start 'F5
        CASE " A" : debug_next  'F7
        CASE " B" : debug_stop  'F8
    END SELECT
    IF NOT DEBUGGER.ENABLED% OR DEBUGGER.CUR_STEP% <> DEBUGGER.PREV_STEP% THEN
        ball_move
        ball_stay_in_bounds
        stats_update
    _DISPLAY
LOOP UNTIL _KEYHIT = 27

COLOR 0, 7 : CLS
SYSTEM

'$INCLUDE:'_ALL.BM'