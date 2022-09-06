'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM User$(5) ' array to hold up to 6 strings (0 to 5)
DIM Count% '   generic counter used in FOR...NEXT loop

'----------------------------
'- Main Program Begins Here -
'----------------------------

User$(0) = "Terry" '      assign an element to each array index
User$(1) = "Mark"
User$(2) = "John"
User$(3) = "Mary"
User$(4) = "Luke"
User$(5) = "Melissa"

FOR Count% = 0 TO 5 '     loop through all 6 array indexes
    PRINT User$(Count%) ' display element of each array index
NEXT Count%

