REM Guessing game
PRINT "Guess what number I'm thinking about!"
RANDOMIZE TIMER
answer = INT(RND * 100)
tries = 0
DO
    INPUT guess
    IF guess < answer THEN
        PRINT "Too low!"
    END IF
    IF guess > answer THEN
        PRINT "Too high!"
    END IF
    tries = tries + 1
LOOP UNTIL guess = answer
PRINT "You got it in "; tries; " tries."

