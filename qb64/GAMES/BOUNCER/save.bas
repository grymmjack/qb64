    'top left corner of level
    IF BALL.Y% = (LEVEL.START_Y% + pad%) AND BALL.X% = (LEVEL.START_X% + pad%) THEN
        DPRINT "* IN TOP LEFT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% + rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF        
    END IF
    'bottom left corner of level
    IF BALL.Y% = (LEVEL.END_Y% - pad%) AND BALL.X% = (LEVEL.START_X% + pad%) THEN
        DPRINT "* IN BOTTOM LEFT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% + rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF
    'top right corner of level
    IF BALL.Y% = (LEVEL.START_Y% + pad%) AND BALL.X% = (LEVEL.END_X% - pad%) THEN
        DPRINT "* IN TOP RIGHT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% - rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF
    'bottom right corner of level
    IF BALL.Y% = (LEVEL.END_Y% - pad%) AND BALL.X% = (LEVEL.END_X% - pad%) THEN
        DPRINT "* IN BOTTOM RIGHT CORNER OF LEVEL", DEBUG_AVG
        new_x% = BALL.X% - rand_in_range(1,pad%)
        IF new_x% <> BALL.X% THEN 
            BALL.HIT_90_NUM% = 0
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF


FUNCTION ball_safe_random_zone%
    DIM AS INTEGER safe_start_x, safe_end_x, safe_start_y, safe_end_y
    safe_start_x% = ((LEVEL.END_X% - LEVEL.START_X%) \ 3) + LEVEL.START_X%
    safe_end_x% = LEVEL.END_X% - safe_start_x%
    safe_start_y% = ((LEVEL.END_Y% - LEVEL.START_Y%) \ 3) + LEVEL.START_Y%
    safe_end_y% = LEVEL.END_Y% - safe_start_y%
    IF _
        in_range(BALL.Y%, safe_start_y%, safe_end_y%) _
    AND in_range(BALL.X%, safe_start_x%, safe_end_x%) THEN
        ball_safe_random_zone% =  TRUE
    ELSE
        ball_safe_random_zone% = FALSE
    END IF
END FUNCTION





    IF ball_safe_random_zone = TRUE THEN
        new_x% = BALL.X% + (rand_in_range(1,2) * rand_sign)
        debug_breakpoint n$(new_x%)
        IF new_x% <> BALL.X% THEN 
            IF BALL.HIT_90_NUM% >= 3 THEN BALL.HIT_90_NUM% = 0
            BALL.X% = new_x%
            ball_sound_random
            STATS.BALL_RANDOMS% = STATS.BALL_RANDOMS% + 1
        END IF
    END IF
