$Debug
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
CONST FALSE = 0 : CONST TRUE = NOT FALSE

DIM SHARED BALL AS STRING
DIM SHARED BRIK AS STRING
DIM SHARED PADL AS STRING
DIM SHARED PADL_X AS INTEGER

DIM SHARED BALL_X AS INTEGER
DIM SHARED BALL_Y AS INTEGER
DIM SHARED BALL_VELO_CURRENT AS INTEGER
DIM SHARED BALL_VELO_MAX AS INTEGER
DIM SHARED BALL_SPEED_Y AS INTEGER
DIM SHARED BALL_SPEED_X AS INTEGER
DIM SHARED BALL_LAUNCHED AS INTEGER

BALL$ = CHR$(9) 
BRIK$ = CHR$(220)+CHR$(220)+CHR$(220)+CHR$(32)
PADL$ = CHR$(223)+CHR$(223)+CHR$(223)+CHR$(223)+CHR$(223)+CHR$(223)+CHR$(223)

DIM PADL_MAX_X AS INTEGER : PADL_MAX_X% = _WIDTH - LEN(PADL$)
DIM SHARED PADL_Y AS INTEGER : PADL_Y% = _HEIGHT - 1

startup
init
DO:
    _LIMIT 30
    DO WHILE _MOUSEINPUT:
        IF INT(_MOUSEX) <= PADL_MAX_X% THEN draw_paddle(_MOUSEX)
        IF _MOUSEBUTTON(1) AND NOT BALL_LAUNCHED% THEN launch_ball(_MOUSEX)
    LOOP
    move_ball
    _DISPLAY
LOOP UNTIL _KEYHIT = 27 'ESC to quit
shutdown


SUB launch_ball (mouse_x%)
    BALL_LAUNCHED% = TRUE
END SUB


SUB move_ball
    
END SUB


SUB draw_paddle (mouse_x%)
    COLOR 14
    PADL_X% = mouse_x%
    LOCATE PADL_Y% - 1, 1 : PRINT SPACE$(_WIDTH);
    LOCATE PADL_Y%, 1 : PRINT SPACE$(_WIDTH);
    LOCATE PADL_Y%, PADL_X% : PRINT PADL$;
    IF BALL_LAUNCHED% = FALSE THEN 
        BALL_X% = PADL_CENTER
        BALL_Y% = PADL_Y% - 1
        draw_ball
    END IF
END SUB


SUB draw_ball ()
    COLOR 15
    LOCATE BALL_Y%, BALL_X%
    PRINT BALL$;
END SUB






FUNCTION PADL_CENTER% ()
    PADL_CENTER% = PADL_X% + (LEN(PADL$) \ 2)
END FUNCTION


SUB init ()
    init_bricks
    init_paddle
    init_ball
    BALL_LAUNCHED% = 0
END SUB


SUB init_bricks ()
    DIM AS INTEGER y, i
    FOR y% = 1 TO 10
        COLOR y%
        FOR i% = 1 TO _WIDTH \ LEN(BRIK$)
            PRINT BRIK$;
        NEXT i% 
    NEXT y%
END SUB


SUB init_paddle ()
    COLOR 14
    PADL_X% = _WIDTH - LEN(PADL$) \ 2
    LOCATE PADL_Y%, PADL_X%
    PRINT PADL$;
END SUB


SUB init_ball ()
    COLOR 15
    BALL_LAUNCHED% = FALSE
    BALL_VELO_CURRENT% = 0
    BALL_X% = PADL_CENTER
    BALL_Y% = PADL_Y% - 1
END SUB


SUB startup ()
    _FULLSCREEN _SQUAREPIXELS, _SMOOTH
    _BLINK OFF
    _CONTROLCHR OFF
    _MOUSEHIDE
    SCREEN 0
END SUB


SUB shutdown ()
    _BLINK ON
    _MOUSESHOW
    _CONTROLCHR ON
    _FULLSCREEN OFF
    SYSTEM
END SUB


