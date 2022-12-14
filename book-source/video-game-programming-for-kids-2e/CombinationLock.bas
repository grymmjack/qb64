PRINT "Combination Lock Game"
PRINT "Guess the combination lock if you can!"
PRINT "Each number will be from 1 to 6."
RANDOMIZE TIMER
guesses = 0
state = 1

REM make the combination lock
number1 = INT(RND * 6) + 1
number2 = INT(RND * 6) + 1
number3 = INT(RND * 6) + 1

DO
    correct = 0
    INPUT "Guess #1: ", num1
    INPUT "Guess #2: ", num2
    INPUT "Guess #3: ", num3

    REM check #1
    IF num1 = number1 THEN
        correct = correct + 1
        PRINT "#1 is correct!"
    ELSE
        IF number1 > num1 THEN PRINT "#1 is higher"
        IF number1 < num1 THEN PRINT "#1 is lower"
    END IF

    REM check #2
    IF num2 = number2 THEN
        correct = correct + 1
        PRINT "#2 is correct!"
    ELSE
        IF number2 > num2 THEN PRINT "#2 is higher"
        IF number2 < num2 THEN PRINT "#2 is lower"
    END IF

    REM check #3
    IF num3 = number3 THEN
        correct = correct + 1
        PRINT "#3 is correct!"
    ELSE
        IF number3 > num3 THEN PRINT "#3 is higher"
        IF number3 < num3 THEN PRINT "#3 is lower"
    END IF

    guesses = guesses + 1
LOOP UNTIL correct = 3

REM the player wins
PRINT "You opened the lock and got the treasure!"
PRINT "It took you "; guesses; " guesses."

