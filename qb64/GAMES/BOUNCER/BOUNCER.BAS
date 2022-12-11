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
    IF CFG.LIM% > 0 THEN _LIMIT CFG.LIM%
    
    k$ = INKEY$

    SELECT CASE k$
        CASE " ": 'SPACE = randomize blocks
            blocks_init
        CASE ",": ', = increment total blocks
            blocks_inc
        CASE ".": '. = decrement total blocks
            blocks_dec
        CASE CHR$(0) + "?": 'F5 = start debugging
            debug_start 
        CASE CHR$(0) + "A": 'F7 = go to next debug step
            debug_next  
        CASE CHR$(0) + "B": 'F8 = stop debugging
            debug_stop
    END SELECT

    game_step

    IF DEBUGGER.ENABLED% OR DEBUGGER.CUR_STEP% <> DEBUGGER.PREV_STEP% THEN SLEEP
LOOP UNTIL _KEYHIT = 27 'ESC = Quit

COLOR 0, 7 : CLS
SYSTEM

SUB game_step
    ball_move
    ball_stay_in_bounds
    stats_update
    _DISPLAY
END SUB

'$INCLUDE:'_ALL.BM'
