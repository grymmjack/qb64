TYPE BALL_OBJECT
    X       AS INTEGER
    Y       AS INTEGER
    X_DIR   AS INTEGER
    Y_DIR   AS INTEGER
    SPEED   AS INTEGER
    KOLOR   AS INTEGER
    DISPLAY AS STRING
END TYPE

DIM SHARED BALL AS BALL_OBJECT
DIM SHARED BALL_9GRID(1 TO 3, 1 TO 3) AS INTEGER

PRINT " 123"
PRINT "1"
PRINT "2"
PRINT "3" 
FOR y%=1 TO 3
    LOCATE y%+1
    FOR x%=1 TO 3
        DIM v AS INTEGER
        DIM s AS STRING
        READ v%
        BALL_9GRID(y%, x%) = v%
        LOCATE , x%+1
        IF v% = 1 THEN s$ = "X" ELSE s$ = " "
        PRINT s$;
    NEXT x%
    PRINT
NEXT y%

DATA 1, 1, 1 
DATA 0, 0, 1
DATA 0, 0, 1

SUB ball_get_9grid
    DIM AS INTEGER x, y, grid_x, grid_y, char
    FOR y%=1 TO 3
        grid_y% = clamp(BALL.Y% + y%, LEVEL.START_Y%, LEVEL.END_Y%)
        FOR x% = 1 TO 3
            grid_x% = clamp(BALL.X% + x%, LEVEL.START_X%, LEVEL.END_X%)
            char% = SCREEN(grid_y%, grid_x%)
            IF char% <> ASC(BALL.DISPLAY$) THEN 
                SELECT CASE char%
                    CASE ASC(BLOCK.DISPLAY$)
                END SELECT
                BALL_9GRID(y%, x%) = 1
            ELSE
                BALL_9GRID(y%, x%) = 0
            END IF
        NEXT x%
    NEXT y%
END SUB

FUNCTION ball_will_bounce_9grid% (y%, x%)
    DIM AS INTEGER check_y, check_x
    check_y% = BALL.Y% + BALL.Y_DIR%
    check_x% = BALL.X% + BALL.X_DIR%
    IF check_y% + 
    ball_will_bounce_9rid% = 
EBD FUNCTION