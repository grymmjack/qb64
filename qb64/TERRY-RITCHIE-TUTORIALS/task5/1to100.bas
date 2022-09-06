'--------------------------------
'- Variable declaration section -
'--------------------------------

DIM Value% '    numeric value the user supplies

'----------------------------
'- Main program begins here -
'----------------------------

INPUT "Enter a number between 1 and 100 >", Value%
IF Value% < 1 THEN
    PRINT "That number is less than one!"
    PRINT "Perhaps you should read the directions."
ELSEIF Value% > 100 THEN
    PRINT "That number is greater than one hundred!"
    PRINT "Hello, McFly, directions are important!"
ELSE
    PRINT "Thank you for following directions."
END IF



