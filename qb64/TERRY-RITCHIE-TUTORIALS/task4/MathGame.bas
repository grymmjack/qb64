score% = 0
PRINT "Hello Player! What is your name?"
INPUT PlayerName$
PRINT
PRINT "Welcome " + PlayerName$ + "!"
PRINT "Please answer the following math questions."
PRINT "A score of 5 is perfect."
PRINT "What is the result of 1 + 1"
INPUT answer%
IF answer% = 2 THEN score% = score% + 1
PRINT "What does 3 times 4 equal"
INPUT answer%
IF answer% = 12 THEN score% = score% + 1
PRINT "What's the answer to 81 divided by 9"
INPUT answer%
IF answer% = 9 THEN score% = score% + 1
PRINT "What does 7 times 8 plus 10 equal"
INPUT answer%
IF answer% = 66 THEN score% = score% + 1
PRINT "What is the answer to the ultimate question of life, the universe, and everything."
INPUT answer%
IF answer% = 42 THEN score% = score% + 1
PRINT "Your score:"; score%
PRINT "You have the skills of ";
IF score% = 0 THEN PRINT "pond scum"
IF score% = 1 THEN PRINT "a counting horse"
IF score% = 2 THEN PRINT "a genius monkey"
IF score% = 3 THEN PRINT "an above average dolphin"
IF score% = 4 THEN PRINT "a grade school human"
IF score% = 5 THEN PRINT "the Deep Thought computer!"
PRINT "Thank you for playing " + PlayerName$



