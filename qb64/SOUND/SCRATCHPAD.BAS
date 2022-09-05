CLS
PRINT "SOUND SCRATCHPAD"
PRINT "----------------"
PRINT
PRINT "FREQUENCY = 37 to 32767, but 0 is allowed for delays"
PRINT "DURATION  = TIMER ticks with a duration of 1/18th second. 18 = one second"
PRINT
PRINT "PRESS ENTER TO QUIT"
PRINT

DO
    INPUT "SOUND FREQUENCY [0, 37 - 32767]   : ", frequency$
    IF frequency$ = "" THEN END
    IF VAL(frequency$) < 37 AND VAL(frequency$) <> 0 THEN
        PRINT "* FREQUENCY TOO LOW, USING FREQUENCY = 37"
        frequency$ = "37"
    END IF
    IF VAL(frequency$) > 32767 THEN
        PRINT "* FREQUENCY TOO HIGH, USING FREQUENCY = 32767"
        frequency$ = "32767"
    END IF

    INPUT "SOUND DURATION  [18 = one-second] : ", duration$
    IF duration$ = "" THEN END
    IF VAL(duration$) > 180 THEN
        PRINT "* DURATION > 10 SECONDS, USING DURATION = 180"
        duration$ = "180"
    END IF
    
    INPUT "LOOP HOW MANY TIMES? [0 - 10000]  : ", loops$
    IF loops$ = "" THEN END
    IF VAL(loops$) < 0 THEN
        PRINT "* LOOP CANNOT BE NEGATIVE, USING LOOP = 0"
        loops$ = "0"
    END IF
    IF VAL(loops$) > 10000 THEN
        PRINT "* LOOPS CANNOT BE > 10000, USING LOOPS = 100"
        loops$ = "0"
    END IF

    PRINT

    play_secs! = (VAL(duration$) / 18) * VAL(loops$)

    IF VAL(loops$) = 0 THEN
        PRINT "PLAYING SOUND(" + frequency$ + ", " + duration$ + ")..."; play_secs; " SECONDS."
        SOUND VAL(frequency$), VAL(duration$)
    ELSE
        PRINT "PLAYING SOUND(" + frequency$ + ", " + duration$ + ")..."; loops$; " TIMES "; play_secs; " SECONDS."
        FOR i = 0 to VAL(loops$)
            SOUND VAL(frequency$), VAL(duration$)
        NEXT i
    END IF
    PRINT
LOOP UNTIL _KEYHIT = 27