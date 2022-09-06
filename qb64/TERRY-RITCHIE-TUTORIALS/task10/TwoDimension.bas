'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM Contacts$(3, 5) ' two dimensional array used as contact database
DIM Match% '          contains index number of match if found
DIM Count% '          index counter
DIM SearchName$ '     name user wishes to search for

'----------------------------
'- Main Program Begins Here -
'----------------------------

Contacts$(1, 1) = "Mike Smith" '     populate database with information
Contacts$(1, 2) = "123 Any Street"
Contacts$(1, 3) = "Anytown"
Contacts$(1, 4) = "OH"
Contacts$(1, 5) = "12345"

Contacts$(2, 1) = "Laura Flowers"
Contacts$(2, 2) = "456 This Street"
Contacts$(2, 3) = "Toledo"
Contacts$(2, 4) = "MA"
Contacts$(2, 5) = "23432"

Contacts$(3, 1) = "Tom Thumb"
Contacts$(3, 2) = "765 My Street"
Contacts$(3, 3) = "Mayberry"
Contacts$(3, 4) = "NC"
Contacts$(3, 5) = "24241"

DO '                                                                       main loop begins
    PRINT '                                                                blank line
    PRINT "Enter a name, or partial name, to search for." '                display instructions
    INPUT "Enter nothing to end the program > ", SearchName$ '             get name to search for
    IF SearchName$ = "" OR SearchName$ = "nothing" THEN END '              end program if nothing
    Count% = 1 '                                                           reset index counter
    Match% = 0 '                                                           reset match indicator
    DO '                                                                   begin search loop
        IF INSTR(UCASE$(Contacts$(Count%, 1)), UCASE$(SearchName$)) THEN ' is name contained within?
            Match% = Count% '                                              yes, remember this index
            EXIT DO '                                                      leave the DO...LOOP
        END IF
        Count% = Count% + 1 '                                              increment index counter
    LOOP UNTIL Count% = 4 '                                                leave loop when value 4
    IF Match% THEN '                                                       was there a match? (<> 0)
        PRINT '                                                            yes, blank line
        PRINT "Match found!" '                                             inform user
        PRINT '                                                            blank line
        PRINT "Name   : "; Contacts$(Match%, 1) '                          display element values
        PRINT "Address: "; Contacts$(Match%, 2)
        PRINT "City   : "; Contacts$(Match%, 3)
        PRINT "State  : "; Contacts$(Match%, 4)
        PRINT "Zip    : "; Contacts$(Match%, 5)
    ELSE '                                                                 no, nothing matched
        PRINT '                                                            blank line
        PRINT "Match not found." '                                         inform user
    END IF
LOOP '                                                                     loop back to beginning




