'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM Fahrenheit! '   holds the user's input temperature in Fahrenheit
DIM Celsius! '      contains the formula's computation into Celsius

'----------------------------
'- Main program begins here -
'----------------------------

PRINT "Fahrenheit to Celsius Converter"
PRINT "-------------------------------"
PRINT
INPUT "Enter temperature in Fahrenheit: ", Fahrenheit!
Celsius! = 5 * (Fahrenheit! - 32) / 9
PRINT
PRINT Fahrenheit!; "degrees F ="; Celsius!; "degrees C"

