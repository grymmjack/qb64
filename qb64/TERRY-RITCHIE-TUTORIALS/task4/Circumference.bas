'--------------------------------
'- Variable declaration section -
'--------------------------------

CONST Pi = 3.1415926 '  the value for Pi

DIM Radius! '           the radius of the circle supplied by the user

'----------------------------
'- Main program begins here -
'----------------------------

PRINT "Circle circumference calculator (Pi times r"; CHR$(253); ")"
PRINT "---------------------------------------------"
PRINT
INPUT "Enter the circle's radius > ", Radius!
PRINT
PRINT "The circumference of the circle is"; Pi * Radius! ^ 2

