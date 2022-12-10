$Debug
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
CONST FALSE = 0 : CONST TRUE = NOT FALSE

TYPE BALL_OBJECT
    X AS INTEGER
    Y AS INTEGER
    VECTOR_X AS INTEGER
    VECTOR_Y AS INTEGER
    DISPLAY AS STRING
    KOLOR AS INTEGER
    CURRENT_VELOCITY AS INTEGER
    MAX_VELOCITY AS INTEGER
    SPEED_X AS INTEGER
    SPEED_Y AS INTEGER
    HAS_LAUNCHED AS INTEGER  
END TYPE
DIM SHARED BALL AS BALL_OBJECT
BALL.X%                = 1
BALL.Y%                = _HEIGHT - 2
BALL.DISPLAY$          = CHR$(9)
BALL.KOLOR%            = 15
BALL.CURRENT_VELOCITY% = 0
BALL.MAX_VELOCITY%     = 3
BALL.SPEED_X%          = 0
BALL.SPEED_Y%          = 0
BALL.HAS_LAUNCHED%     = FALSE

TYPE PADDLE_OBJECT
    X AS INTEGER
    Y AS INTEGER
    MAX_X AS INTEGER
    DISPLAY AS STRING
    KOLOR AS INTEGER
    CAN_SHOOT AS INTEGER
    CAN_STICK AS INTEGER
    LIVES AS INTEGER
END TYPE
DIM SHARED PADDLE AS PADDLE_OBJECT
PADDLE.DISPLAY$   = STRING$(7, CHR$(223))
PADDLE.Y%         = _HEIGHT - 1
PADDLE.X%         = 1
PADDLE.MAX_X%     = _WIDTH - LEN(PADDLE.DISPLAY$)
PADDLE.KOLOR%     = 14
PADDLE.CAN_SHOOT% = FALSE
PADDLE.CAN_STICK% = FALSE
PADDLE.LIVES%     = 3

TYPE BRICK_OBJECT
    X AS INTEGER
    Y AS INTEGER
    INDEX AS INTEGER
    DISPLAY AS STRING
    KOLOR AS INTEGER
    LIVES AS INTEGER
END TYPE
DIM SHARED BRICK AS BRICK_OBJECT
BRICK.X%       = 1
BRICK.Y%       = 1
' BRICK.DISPLAY$ = STRING$(3, CHR$(220)) + CHR$(32)
BRICK.DISPLAY$ = STRING$(3, CHR$(220)) + CHR$(221)
BRICK.KOLOR%   = 1
BRICK.LIVES%   = 1

TYPE LEVEL_OBJECT
    START_X AS INTEGER
    START_Y AS INTEGER
    BRICKS_PER_ROW AS INTEGER
    ROWS_OF_BRICKS AS INTEGER
    TOTAL_BRICKS AS INTEGER
END TYPE
DIM SHARED LEVEL AS LEVEL_OBJECT
LEVEL.START_X%        = 1
LEVEL.START_Y%        = 1
LEVEL.BRICKS_PER_ROW% = _WIDTH \ LEN(BRICK.DISPLAY$)
LEVEL.ROWS_OF_BRICKS% = 10
LEVEL.TOTAL_BRICKS%   = LEVEL.BRICKS_PER_ROW% * LEVEL.ROWS_OF_BRICKS%

DIM SHARED BRICKS(1 TO LEVEL.TOTAL_BRICKS%) AS BRICK_OBJECT


startup
init
DO:
    _LIMIT 30
    DO WHILE _MOUSEINPUT:
        RANDOMIZE TIMER
        IF INT(_MOUSEX) <= PADDLE.MAX_X% THEN 
            draw_paddle(_MOUSEX)
        END IF
        IF _MOUSEBUTTON(1) AND BALL.HAS_LAUNCHED% = FALSE THEN 
            launch_ball
        END IF
    LOOP
    IF BALL.HAS_LAUNCHED% THEN
        check_ball_collisions
        move_ball
        check_ball_bounds
    END IF
    _DISPLAY
LOOP UNTIL _KEYHIT = 27 'ESC to quit
shutdown


SUB check_ball_collisions
    DIM AS INTEGER x, y, c
    x% = POS(0)
    y% = CSRLIN
    c% = SCREEN(BALL.Y% + (BALL.SPEED_Y% * BALL.CURRENT_VELOCITY%), BALL.X%)
    IF c% <> 9 AND c% <> 32 AND c% <> 223 THEN ' hit not ball
        erase_brick(get_brick_hit_by_ball)
        ball_bounce_down
    ELSEIF c% = 223 THEN
        ball_hit_paddle
    END IF
    IF BALL.X% + BALL.SPEED_X% >= _WIDTH THEN
        ball_bounce_left
    END IF
    IF BALL.X% - BALL.SPEED_X% <= 1 THEN
        ball_bounce_right
    END IF
    IF BALL.Y% - BALL.SPEED_Y% <= 1 THEN
        ball_bounce_down
    END IF
END SUB


SUB ball_hit_paddle
    ball_bounce_up
END SUB


SUB ball_bounce_up
    BALL.CURRENT_VELOCITY% = 1
    BALL.SPEED_Y% = BALL.SPEED_Y% * BALL.CURRENT_VELOCITY%
END SUB


SUB ball_bounce_down
    BALL.CURRENT_VELOCITY% = -1
    BALL.SPEED_Y% = BALL.SPEED_Y% * BALL.CURRENT_VELOCITY%
END SUB


SUB ball_bounce_left
    BALL.CURRENT_VELOCITY% = -1
    BALL.SPEED_X% = BALL.SPEED_X% * BALL.CURRENT_VELOCITY%
END SUB


SUB ball_bounce_right
    BALL.CURRENT_VELOCITY% = 1
    BALL.SPEED_X% = BALL.SPEED_X% * BALL.CURRENT_VELOCITY%
END SUB


SUB check_ball_bounds
    IF BALL.Y% >= PADDLE.Y% THEN
        kill_paddle
    END IF
END SUB


SUB kill_paddle
    BALL.SPEED_X% = 0
    BALL.SPEED_Y% = 0
    erase_paddle
    PADDLE.LIVES% = PADDLE.LIVES% - 1
    SLEEP 1
    PADDLE.KOLOR% = 14
    init_paddle
    init_ball
END SUB


FUNCTION get_brick_hit_by_ball% ()
    DIM idx AS INTEGER
    idx% = get_brick_index_at_xy(BALL.X%, BALL.Y%)
    get_brick_hit_by_ball% = idx%
END FUNCTION


FUNCTION get_brick_index_at_xy% (x%, y%)
    DIM AS INTEGER i, start_x, end_x
    DIM b AS BRICK_OBJECT
    FOR i% = 1 TO LEVEL.TOTAL_BRICKS%
        b = BRICKS(i%)
        start_x% = b.X%
        end_x% = b.X% + LEN(b.DISPLAY$)
        IF x% >= start_x% AND x% <= end_x% AND y% = b.Y% THEN
            get_brick_index_at_xy% = i%
        END IF
    NEXT i%
END FUNCTION


SUB launch_ball ()
    BALL.HAS_LAUNCHED% = TRUE
    BALL.CURRENT_VELOCITY% = 1
    BALL.SPEED_Y% = 1
    BALL.SPEED_X% = INT(RND * 2) - 1
END SUB


SUB move_ball
    BALL.SPEED_Y% = BALL.SPEED_Y% * BALL.CURRENT_VELOCITY%
    BALL.SPEED_X% = BALL.SPEED_X% * BALL.CURRENT_VELOCITY%
    erase_ball
    BALL.X% = BALL.X% + BALL.SPEED_X%
    BALL.Y% = BALL.Y% - BALL.SPEED_Y%
    draw_ball
END Sub



SUB erase_ball
    LOCATE BALL.Y%, BALL.X%
    PRINT SPACE$(LEN(BALL.DISPLAY$));
END SUB


SUB erase_brick(brick_index%)
    DIM brik AS BRICK_OBJECT
    brik = BRICKS(brick_index%)
    LOCATE brik.Y%, brik.X%
    PRINT SPACE$(LEN(brik.DISPLAY$));
END SUB


SUB hit_paddle
    DIM new_ball_velocity AS INTEGER
    new_ball_velocity% = BALL.CURRENT_VELOCITY% + PADDLE_HIT_LOCATION
    IF new_ball_velocity% <= BALL.MAX_VELOCITY% THEN
        BALL.CURRENT_VELOCITY% = new_ball_velocity%
    END IF
END SUB


SUB draw_paddle (mouse_x%)
    COLOR PADDLE.KOLOR%
    PADDLE.X% = mouse_x%
    LOCATE PADDLE.Y% - 1, 1 : PRINT SPACE$(_WIDTH);
    LOCATE PADDLE.Y%, 1 : PRINT SPACE$(_WIDTH);
    LOCATE PADDLE.Y%, PADDLE.X% : PRINT PADDLE.DISPLAY$;
    IF BALL.HAS_LAUNCHED% = FALSE THEN 
        BALL.X% = PADDLE_CENTER
        BALL.Y% = PADDLE.Y% - 1
        draw_ball
    END IF
END SUB

SUB erase_paddle
    LOCATE PADDLE.Y%, PADDLE.X%
    PRINT SPACE$(LEN(PADDLE.DISPLAY$));
END SUB


SUB draw_ball ()
    COLOR BALL.KOLOR%
    LOCATE clamp(BALL.Y%, 1, 24), clamp(BALL.X%, 1, 80)
    PRINT BALL.DISPLAY$;
END SUB


FUNCTION clamp% (value%, min%, max%)
    IF value% > max% THEN
        clamp% = max%
    ELSEIF value% < min% THEN
        clamp% = min%
    ELSE
        clamp% = value%
    END IF
END FUNCTION


FUNCTION PADDLE_HIT_LOCATION% ()
    PADDLE_HIT_LOCATION% = PADDLE_CENTER
END FUNCTION


FUNCTION PADDLE_CENTER% ()
    PADDLE_CENTER% = PADDLE.X% + (LEN(PADDLE.DISPLAY$) \ 2)
END FUNCTION


SUB init ()
    init_bricks
    init_paddle
    init_ball
    BALL.HAS_LAUNCHED% = FALSE
END SUB


SUB init_bricks ()
    DIM AS INTEGER y, i, n
    n% = 0
    FOR y% = 1 TO LEVEL.ROWS_OF_BRICKS%
        COLOR y%
        FOR i% = 1 TO LEVEL.BRICKS_PER_ROW%
            n% = n% + 1
            BRICKS(n%).Y% = CSRLIN
            BRICKS(n%).X% = POS(0)
            BRICKS(n%).DISPLAY$ = BRICK.DISPLAY$
            BRICKS(n%).INDEX% = n%
            BRICKS(n%).LIVES% = 1
            PRINT BRICK.DISPLAY$;
        NEXT i% 
    NEXT y%
END SUB


SUB init_paddle ()
    COLOR PADDLE.KOLOR%
    PADDLE.X% = (_WIDTH - LEN(PADDLE.DISPLAY$)) \ 2
    LOCATE PADDLE.Y%, PADDLE.X%
    PRINT PADDLE.DISPLAY$;
END SUB


SUB init_ball ()
    COLOR BALL.KOLOR%
    BALL.HAS_LAUNCHED% = FALSE
    BALL.CURRENT_VELOCITY% = 0
    BALL.X% = PADDLE_CENTER
    BALL.Y% = PADDLE.Y% - 1
END SUB


SUB startup ()
'    _FULLSCREEN _SQUAREPIXELS, _SMOOTH
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
