'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Number% ' the number to guess
DIM Guess% '  the player's guess
DIM Tries% '  the number of tries

'----------------------------
'- Main program begins here -
'----------------------------

Number% = 44 '                                      the number to guess
PRINT "-------------------------------" '           print introduction
PRINT "-Welcome to Guess The Number! -"
PRINT "-------------------------------"
PRINT
PRINT "I'm thinking of a number from 1 to 100" '    print directions
PRINT
PRINT "Can you guess the number I am thinking of?"
PRINT
TRYAGAIN: '                                         back here to try again
Tries% = Tries% + 1 '                               increment try counter
INPUT "Enter your guess (1 to 100) >", Guess% '     get player guess value
IF Guess% > Number% THEN '                          too high?
    PRINT "Too high! Try again." '                  yes, inform player
ELSEIF Guess% < Number% THEN '                      too low?
    PRINT "Too low! Try again." '                   yes, inform player
END IF
IF Guess% <> Number% THEN GOTO TRYAGAIN '           go back if number not guessed
PRINT
PRINT "Correct! You guessed my number in"; Tries%; "tries."





