'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM Position% ' each position the search string is found at
DIM Phrase$ '   the base string
DIM Search$ '   the search string
DIM NextLine% ' the print line explaining where search string found

'----------------------------
'- Main Program Begins Here -
'----------------------------

Phrase$ = "The rain in Spain falls mainly on the plain." ' create INSTR base string
Search$ = "ain" '                                          create INSTR search string
Position% = 0 '                                            reset position of string found
NextLine% = 4 '                                            first text line to print results
PRINT Phrase$ '                                            display the base string
DO '                                                       loop through the base string
    Position% = INSTR(Position% + 1, Phrase$, Search$) '   look for search string at last position
    IF Position% THEN '                                    was a match found?
        LOCATE NextLine%, 1 '                              yes, set cursor line location
        NextLine% = NextLine% + 1 '                        increment cursor line location for next time
        PRINT "Found "; CHR$(34); Search$; CHR$(34); " at position"; Position% ' print result to screen
        LOCATE 2, Position% '                              locate cursor position below search string
        PRINT CHR$(24); '                                  print an up arrow symbol where found
    END IF
LOOP UNTIL Position% = 0 '                                 leave when no more matches found

