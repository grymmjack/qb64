'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Count% '     used as a counter
DIM Remainder% ' the remainder of modulus division

'----------------------------
'- Main program begins here -
'----------------------------

Count% = 1 '                     set initial counter value
START: '                         back to the beginning
PRINT Count%; '                  display current value of counter
GOTO TESTREMAINDER '             is number odd or even?
EVEN: '                          jump here if even
PRINT "EVEN" '                   display EVEN after number
GOTO CONTINUE '                  continue with program
ODD: '                           jump here if odd
PRINT "ODD" '                    display ODD after number
GOTO CONTINUE '                  continue with program
TESTREMAINDER: '                 what was result of modular division?
IF Remainder% = 0 THEN '         was there a remainder?
    GOTO EVEN '                  no, must be even, go there
ELSE '                           yes, there was a remainder
    GOTO ODD '                   must be odd, go there
END IF
CONTINUE: '                      continue program here
Count% = Count% + 1 '            increment counter
Remainder% = Count% MOD 2 '      get the remainder of modulus division
IF Count% < 25 THEN GOTO START ' loop if counter less than 25

