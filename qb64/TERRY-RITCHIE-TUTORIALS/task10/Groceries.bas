'---------------------
'- Declare variables -
'---------------------

TYPE GROCERIES '               grocery list structure
    Item AS STRING '           grocery item description
    Price AS STRING '          grocery item price
END TYPE

REDIM MyList(0) AS GROCERIES ' grocery list array
DIM Item$ '                    grocery item
DIM Index% '                   current array index
DIM Total! '                   total price of groceries

'----------------
'- Main program -
'----------------

PRINT "              My Grocery List" '                    print instructions
PRINT "       -----------------------------"
PRINT " Enter nothing in description when finished."
PRINT
Index% = 0 '                                               initialize variables
Total! = 0
DO '                                                       begin main program loop
    LINE INPUT "Description: "; Item$ '                    get grocery item
    IF Item$ <> "" THEN '                                  was an item entered?
        Index% = Index% + 1 '                              yes, increment array index number
        REDIM _PRESERVE MyList(Index%) AS GROCERIES '      resize the array and preserve values
        MyList(Index%).Item = Item$ '                      add grocery item to array
        LINE INPUT "Item Price : "; MyList(Index%).Price ' get grocery item price
        Total! = Total! + VAL(MyList(Index%).Price) '      add item price to total
    END IF
LOOP UNTIL Item$ = "" '                                    leave loop when no more items
PRINT '                                                    print master grocery list
PRINT "Here is the list of items you need:"
PRINT "-----------------------------------"
FOR Index% = 1 TO UBOUND(MyList) '                         loop up to upper boundary of array
    PRINT MyList(Index%).Item '                            print item at current index
NEXT Index%
PRINT "-----------------------------------"
PRINT "You'll also need $"; Total! '                       display total cost to user





















