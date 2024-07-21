$COLOR:32
CONST BALL_RADIUS = 5
CONST PADDLE_SPAN = 25
CONST PADDLE_HEIGHT = 10
CONST PADDLE_VELOCITY = 5
CONST PADDLE_GRADIENT = 0.3
CONST BLOCK_WIDTH = 42
CONST BLOCK_HEIGHT = 10
CONST BLOCK_MARGIN = 10
CONST NUM_BLOCKS = 36
CONST SPEED_PER_LEVEL = 1.1
 
CONST FALSE = 0, TRUE = NOT FALSE
CONST KEY_LEFT = 19200
CONST KEY_RIGHT = 19712
 
TYPE block_t
    x1 AS INTEGER
    x2 AS INTEGER
    y1 AS INTEGER
    y2 AS INTEGER
    alive AS INTEGER
    colour AS _UNSIGNED LONG
END TYPE
DIM blocks(1 TO NUM_BLOCKS) AS block_t
 
DIM SHARED colours(1 TO 12) AS _UNSIGNED LONG
colours(1) = Peru
colours(2) = RazzleDazzleRose
colours(3) = Wheat
colours(4) = WildBlueYonder
colours(5) = Lavender
colours(6) = MountainMeadow
colours(7) = BurntOrange
colours(8) = PeachPuff
colours(9) = LawnGreen
colours(10) = Chestnut
colours(11) = IndianRed
colours(12) = LightGoldenRodYellow
 
SCREEN _NEWIMAGE(640, 480, 32)
RANDOMIZE TIMER
 
start:
level = 0
 
next_level:
level = level + 1
ball_vy = -(3 + SPEED_PER_LEVEL * level)
win_condition = FALSE
init_blocks blocks()
ball_x = _WIDTH / 2
ball_vx = INT(RND * 5)
ball_y = _HEIGHT * 0.9
paddle_x = _WIDTH / 2
paddle_y = _HEIGHT - PADDLE_HEIGHT - 10
CLS
centreprint "Level" + STR$(level)
_DISPLAY
_DELAY 2
 
DO
    CLS , 0
    'Paddle movement
    IF _KEYDOWN(KEY_LEFT) THEN paddle_x = paddle_x - PADDLE_VELOCITY
    IF paddle_x < PADDLE_SPAN THEN paddle_x = PADDLE_SPAN
    IF _KEYDOWN(KEY_RIGHT) THEN paddle_x = paddle_x + PADDLE_VELOCITY
    IF paddle_x > _WIDTH - PADDLE_SPAN THEN paddle_x = _WIDTH - PADDLE_SPAN
    'Ball movement
    ball_x = ball_x + ball_vx
    ball_y = ball_y + ball_vy
    'Draw paddle
    LINE (paddle_x - PADDLE_SPAN, paddle_y)-(paddle_x + PADDLE_SPAN, paddle_y + PADDLE_HEIGHT), White, BF
    'Draw ball
    CIRCLE (ball_x, ball_y), BALL_RADIUS, White
    'Draw blocks & block collision
    win_condition = TRUE
    FOR b = LBOUND(blocks) TO UBOUND(blocks)
        IF NOT blocks(b).alive THEN _CONTINUE
        top_bound = ball_y + BALL_RADIUS >= blocks(b).y1
        bottom_bound = ball_y - BALL_RADIUS <= blocks(b).y2
        left_bound = ball_x + BALL_RADIUS >= blocks(b).x1
        right_bound = ball_x - BALL_RADIUS <= blocks(b).x2
        IF top_bound AND left_bound AND right_bound AND bottom_bound THEN
            ball_vy = -ball_vy
            blocks(b).alive = FALSE
        ELSE
            LINE (blocks(b).x1, blocks(b).y1)-(blocks(b).x2, blocks(b).y2), blocks(b).colour, BF
            win_condition = FALSE
        END IF
    NEXT b
    'Win?
    IF win_condition THEN GOTO next_level
    'Boundary collision
    IF ball_x - BALL_RADIUS + ball_vx <= 0 OR ball_x + BALL_RADIUS + ball_vx >= _WIDTH THEN ball_vx = -ball_vx
    IF ball_y - BALL_RADIUS + ball_vy <= 0 THEN ball_vy = -ball_vy
    'Paddle collision
    IF ABS(ball_x - paddle_x) <= PADDLE_SPAN + BALL_RADIUS AND ball_y + BALL_RADIUS >= paddle_y THEN
        ball_vy = -ball_vy
        ball_vx = (ball_x - paddle_x) * PADDLE_GRADIENT
    END IF
    'Missed ball
    IF ball_y - BALL_RADIUS >= _HEIGHT THEN
        centreprint "Game Over"
        _DELAY 2
        GOTO start
    END IF
    _DISPLAY
    _LIMIT 60
LOOP
PRINT "Game over"
 
SUB init_blocks (blocks() AS block_t)
    x = BLOCK_MARGIN
    y = BLOCK_MARGIN
    FOR i = LBOUND(blocks) TO UBOUND(blocks)
        blocks(i).alive = TRUE
        IF x + BLOCK_WIDTH > _WIDTH THEN
            x = BLOCK_MARGIN
            y = y + BLOCK_HEIGHT + BLOCK_MARGIN
        END IF
        blocks(i).x1 = x
        blocks(i).x2 = x + BLOCK_WIDTH
        blocks(i).y1 = y
        blocks(i).y2 = y + BLOCK_HEIGHT
        blocks(i).colour = colours(INT(RND * UBOUND(colours)) + 1)
        x = x + BLOCK_WIDTH + BLOCK_MARGIN
    NEXT i
END SUB
 
SUB centreprint (s$)
    _PRINTSTRING ((_WIDTH - _PRINTWIDTH(s$)) / 2, (_HEIGHT - _FONTHEIGHT) / 2), s$
    _DISPLAY
END SUB