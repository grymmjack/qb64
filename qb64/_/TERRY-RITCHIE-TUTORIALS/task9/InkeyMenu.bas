'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM KeyPress$ '  hold the value of a user key press
DIM Highlight% ' the current highlighted menu entry
DIM Selected% '  the selected menu entry
DIM Count% '     generic counter

'----------------------------
'- Main Program Begins Here -
'----------------------------

Highlight% = 1 '                              set initial highlighted entry
Selected% = 0 '                               no entry selected yet
LOCATE 2, 30 '                                position text cursor on screen
PRINT "Example Menu System" '                 print menu title
LOCATE 13, 22 '                               position text cursor on screen
PRINT "Use UP/DOWN arrow keys to highlight" ' print instructions to user
LOCATE 14, 24 '                               position text cursor
PRINT "Press ENTER to make a selection" '     print more instructions to user
DO '                                          begin main loop
    FOR Count% = 1 TO 5 '                     create 5 dummy menu entries
        LOCATE Count% + 5, 32 '               position text cursor on screen
        IF Highlight% = Count% THEN '         is this the highlghted entry?
            COLOR 30, 1 '                     yes, text flashing yellow on blue
        ELSE '                                no
            COLOR 14, 0 '                     text yellow on black
        END IF
        PRINT " Menu Option"; Count% '        display the menu entry
    NEXT Count%
    DO '                                      begin key press loop
        KeyPress$ = INKEY$ '                  get key from buffer
        _LIMIT 30 '                           30 loops per second (don't hog CPU)
    LOOP UNTIL KeyPress$ <> "" '              loop back if no key pressed (null)
    IF KeyPress$ = CHR$(13) THEN '            did user press ENTER?
        Selected% = Highlight% '              yes, remember which entry selected
    ELSEIF KeyPress$ = CHR$(0) + "H" THEN '   no, did user press UP ARROW?
        IF Highlight% <> 1 THEN '             yes, already on first entry?
            Highlight% = Highlight% - 1 '     no, move up one entry
        END IF
    ELSEIF KeyPress$ = CHR$(0) + "P" THEN '   no, did user press DOWN ARROW?
        IF Highlight% <> 5 THEN '             yes, already on last entry?
            Highlight% = Highlight% + 1 '     no, move down one entry
        END IF
    END IF
LOOP UNTIL Selected% <> 0 '                   loop back if nothing selected
LOCATE 18, 2 '                                position text cursor
COLOR 15, 0 '                                 text bright white on black
PRINT "You chose menu option"; Selected% '    report which entry chosen













