'--------------------------------
'- Variable declaration section -
'--------------------------------
DIM Menu% '       the user selected menu option
DIM Value! '      value the user entered
'----------------------------
'- Main program begins here -
'----------------------------
DO '                                                                      begin main program loop
    CLS '                                                                 clear the screen
    PRINT "   -- Conversion Utility --" '                                 display menu
    PRINT
    PRINT "1. Convert Fahrenheit to Celsius"
    PRINT "2. Convert inches to millimeters"
    PRINT "3. End program"
    PRINT
    INPUT "   Enter selection > ", Menu% '                                get user's choice
    PRINT
    IF Menu% = 1 THEN '                                                   user select option 1?
        INPUT "Enter temperature in Fahrenheit to convert > ", Value! '   yes, get user input
        PRINT Value!; "degrees F ="; 5 * (Value! - 32) / 9; "degreec C" ' display results
        PRINT "Press any key to return to menu ..."
        SLEEP '                                                           wait for a key press
    ELSEIF Menu% = 2 THEN '                                               user select option 2?
        INPUT "Enter the number of inches to convert > ", Value! '        yes, get user input
        PRINT Value!; "inches ="; Value! * 25.4; "millimeters" '          display results
        PRINT "Press any key to return to menu ..."
        SLEEP '                                                           wait for a key press
    END IF
LOOP UNTIL Menu% = 3 '                                                    leave when option 3 selected
SYSTEM '                                                                  return control to OS



