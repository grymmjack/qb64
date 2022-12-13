score = 0
PRINT "Welcome to the Trivia Game"
PRINT

PRINT "QUESTION 1"
INPUT "Are you the greatest programmer in the world?", answer$
IF answer$ = "yes" THEN
    PRINT "Correct!"
    score = score + 1
ELSE
    PRINT "Wrong! It's yes."
END IF
PRINT "SCORE: "; score
PRINT

PRINT "QUESTION 2"
INPUT "What is Obi-Wan's last name? ", answer$
IF answer$ = "Kenobi" THEN
    PRINT "Correct!"
    score = score + 1
ELSE
    PRINT "Wrong! It's Kenobi."
END IF
PRINT "SCORE: "; score
PRINT


PRINT "QUESTION 3"
INPUT "Who was Nemo's friend, the purple fish?", answer$
IF answer$ = "Dory" THEN
    PRINT "Correct!"
    score = score + 1
ELSE
    PRINT "Wrong! It's Dory."
END IF
PRINT "SCORE: "; score
PRINT

PRINT "QUESTION x"
INPUT "<add your own question>", answer$
IF answer$ = "<edit>" THEN
    PRINT "Correct!"
    score = score + 1
ELSE
    PRINT "Wrong!"
END IF
PRINT "SCORE: "; score
PRINT


PRINT "GAME OVER"

