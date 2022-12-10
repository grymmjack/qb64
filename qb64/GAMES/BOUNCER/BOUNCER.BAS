$CONSOLE
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
RANDOMIZE TIMER

'$INCLUDE:'_ALL.BI'

configure
screen_init
ball_init
level_init
blocks_init
timers_init

DO:
    IF CFG.LIM > 0 THEN _LIMIT CFG.LIM   
    IF INKEY$ = " " THEN blocks_init
    ball_move
    ball_stay_in_bounds
    stats_update
    _DISPLAY
LOOP UNTIL _KEYHIT = 27

COLOR 0, 7 : CLS
SYSTEM

'$INCLUDE:'_ALL.BM'