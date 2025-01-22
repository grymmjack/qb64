OPTION _EXPLICIT
OPTION _EXPLICITARRAY

' Trivial example where _IIF is more readable than IF...THEN...ELSE IMO

DIM AS STRING fruit, thing
DIM num_fruits AS _UNSIGNED _BYTE

thing$ = "apple"

' First we have 1 apple so don't pluralize with "appleS"
num_fruits~%% = 1
fruit$ = _IIF(num_fruits~%% > 1, thing$ + "s", thing$)
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; fruit$; "."

' Second we have more than 1 apple so pluralize with "appleS"
num_fruits~%% = 2
fruit$ = _IIF(num_fruits~%% > 1, thing$ + "s", thing$)
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; fruit$; "."

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' Same code with IF...THEN...ELSE

num_fruits~%% = 1
IF num_fruits~%% > 1 THEN
    fruit$ = thing$ + "s"
ELSE
    fruit$ = thing$
END IF
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; fruit$; "."

num_fruits~%% = 2
IF num_fruits~%% > 1 THEN
    fruit$ = thing$ + "s"
ELSE
    fruit$ = thing$
END IF
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; fruit$; "."

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

' Same code with function to simplify

' First we have 1 apple so don't pluralize with "appleS"
num_fruits~%% = 1
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; _
    plural$(thing$, num_fruits~%%); "."

' Second we have more than 1 apple so pluralize with "appleS"
num_fruits~%% = 2
PRINT "I have "; _TOSTR$(num_fruits~%%); " "; _
    plural$(thing$, num_fruits~%%); "."

''
' Function to simplify pluralization of a thing
' @param STRING the thing to pluralize
' @param _UNSIGNED _BYTE num_things  the number of things
' @return STRING the thing with an "s" appended if num_things > 1
' 
FUNCTION plural$(thing$, num_things~%%)
    plural$ = _IIF(num_things~%% > 1, thing$ + "s", thing$)
END FUNCTION