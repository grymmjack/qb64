'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM KeyPress$ ' single key presses by user
DIM KeyValue% ' ASCII value of key pressed

'----------------------------
'- Main Program Begins Here -
'----------------------------

DO '                                                  begin main loop
    DO '                                              begin key input loop
        KeyPress$ = INKEY$ '                          get any key pressed
    LOOP UNTIL KeyPress$ <> "" '                      leave loop if key pressed
    KeyValue% = ASC(KeyPress$) '                      get ASCII value of key pressed
    IF KeyValue% < 32 THEN '                          is value less than 32?
        PRINT " Control key   "; '                    yes, this is a control character
    ELSEIF KeyValue% > 47 AND KeyValue% < 58 THEN '   no, is value between 47 and 58?
        PRINT " Numeric key   "; '                    yes, this is a numeric character
    ELSEIF KeyValue% > 64 AND KeyValue% < 91 THEN '   no, is value between 64 and 91?
        PRINT " UPPERcase key "; '                    yes, this is an upper case character
    ELSEIF KeyValue% > 96 AND KeyValue% < 123 THEN '  no, is value between 96 and 123?
        PRINT " Lowercase Key "; '                    yes, this is a lower case character
    ELSEIF KeyValue% = 32 THEN '                      no, is value 32?
        PRINT " Spacebar Key  "; '                    yes, this is a space character
    ELSE '                                            no
        PRINT " Symbol Key    "; '                    assume all others are symbol characters
    END IF
    PRINT CHR$(26); " "; CHR$(KeyValue%) '            print right arrow and character
LOOP UNTIL KeyPress$ = CHR$(27) '                     leave main loop when ESC key pressed

