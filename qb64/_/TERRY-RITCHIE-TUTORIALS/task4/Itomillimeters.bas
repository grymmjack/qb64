'--------------------------------
'- Variable declaration section -
'--------------------------------

CONST mm = 25.4 '  the number of millimeters contained in an inch

DIM Inches! '      the number of inches to convert supplied by the user

'----------------------------
'- Main program begins here -
'----------------------------

PRINT "Inches to millimeters calculator"
PRINT "--------------------------------"
PRINT
INPUT "Enter the number of inches to convert > ", Inches!
PRINT
PRINT Inches!; "inches ="; Inches! * mm; "millimeters"

