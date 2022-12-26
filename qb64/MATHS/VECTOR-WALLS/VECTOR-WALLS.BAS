SCREEN 12
' _FULLSCREEN _SQUAREPIXELS, _SMOOTH
' $CONSOLE

TYPE BRICK_OBJ
    x AS INTEGER
    y AS INTEGER
    w AS INTEGER
    h AS INTEGER
    color AS INTEGER
    lives AS INTEGER
END TYPE

TYPE LEVEL_OBJ
    brick_w AS INTEGER
    brick_h AS INTEGER
    brick_pad AS INTEGER
    brick_rows AS INTEGER
    start_x AS INTEGER
    end_x AS INTEGER
    start_y AS INTEGER
    end_y AS INTEGER
END TYPE

TYPE BALL_OBJ
    x AS INTEGER
    y AS INTEGER
    w AS INTEGER
    h AS INTEGER
    x_speed AS INTEGER
    y_speed AS INTEGER
    x_dir AS INTEGER
    y_dir AS INTEGER
    color AS INTEGER
END TYPE

DIM SHARED BALL AS BALL_OBJ
BALL.x%       = 0
BALL.y%       = 0
BALL.w%       = 4
BALL.h%       = 4
BALL.color%   = 15
BALL.x_dir%   = 0
BALL.y_dir%   = -1
BALL.x_speed% = 1
BALL.y_speed% = 1

DIM SHARED LEVEL AS LEVEL_OBJ
LEVEL.brick_w%    = _WIDTH\20
LEVEL.brick_h%    = _HEIGHT\40
LEVEL.brick_pad%  = _HEIGHT\100
LEVEL.brick_rows% = 14
LEVEL.start_x%    = 1
LEVEL.end_x%      = _WIDTH
LEVEL.start_y%    = 1
LEVEL.end_y%      = _HEIGHT

DIM SHARED bricks_per_row AS INTEGER
bricks_per_row% = _WIDTH \ (LEVEL.brick_w% + LEVEL.brick_pad%)
DIM SHARED BRICKS(1 TO bricks_per_row% * LEVEL.brick_rows%) AS BRICK_OBJ
CALL BRICKS_draw

RANDOMIZE TIMER
' BALL.x% = INT(RND(1)*_WIDTH-BALL.w%)
' BALL.y% = _HEIGHT-BALL.h%-1
BALL.x% = 5
BALL.y% = 240

DIM AS INTEGER new_x, new_y, col_x, col_y
DIM AS LONG col

DO:
    _LIMIT 120

    new_x% = BALL.x% + (BALL.x_speed% * BALL.x_dir%)
    new_y% = BALL.y% + (BALL.y_speed% * BALL.y_dir%)

    IF (new_x% <= 1) _
        OR (new_y% <= 1) _
        OR (new_x% + BALL.w% >= _WIDTH) _
        OR (new_y% + BALL.h% >= _HEIGHT) _
    THEN 
        WALL_collision
    END IF

    col& = POINT(new_x% + BALL.x_speed% * BALL.x_dir%, new_y% + BALL.y_speed% * BALL.y_dir%)
    ' _ECHO _TRIM$(STR$(new_x%)) + ", " + _TRIM$(STR$(new_y%))
    ' _ECHO _TRIM$(STR$(col&))
    IF col& <> 0 AND col& <> 15 THEN
        SOUND 15000, 0.005
        BRICK_collision
    END IF
        
    CALL BALL_erase(BALL.x%, BALL.y%)
    CALL BALL_draw(new_x%, new_y%)
    BALL.x% = new_x% : BALL.y% = new_y%

    _DISPLAY
LOOP UNTIL _KEYHIT=27

SUB WALL_collision
    DIM AS INTEGER new_x_dir, new_y_dir
    new_x_dir% = INT(RND(1)*3)-1 ' random number from -1, 0, +1
    new_y_dir% = INT(RND(1)*3)-1
    ' _ECHO _TRIM$(STR$(new_x_dir%)) + ", " + _TRIM$(STR$(new_y_dir%))
    BALL.x_dir% = new_x_dir%
    BALL.y_dir% = new_y_dir%
END SUB

SUB BRICK_collision
    BALL.y_dir% = BALL.y_dir% * -1
END SUB

SUB BALL_draw (x%, y%)
    ' PSET (x%, y%), BALL.color%
    LINE (x%, y%)-(x% + BALL.w%, y% + BALL.h%), BALL.color%, BF
END SUB

SUB BALL_erase (x%, y%)
    LINE (x%, y%)-(x% + BALL.w%, y% + ball.h%), 0, BF
END SUB

SUB BRICK_draw (x%, y%, c%)
    LINE (x%, y%)-(x% + LEVEL.brick_w%, y% + LEVEL.brick_h%), c%, BF
END SUB

SUB BRICKS_draw
    DIM AS INTEGER y, x
    FOR y%=0 TO LEVEL.brick_rows%
        FOR x%=0 to bricks_per_row%
            BRICK_draw _
            (x% * LEVEL.brick_w%) + (x% * LEVEL.brick_pad%), _
            (y% * LEVEL.brick_h%) + (y% * LEVEL.brick_pad%), y%
        NEXT x%
    NEXT y%
END SUB