'** Sprite demo using a mnumbered sprite sheet

DIM MarioSheet& ' the mario sprite sheet
DIM x%, y% '      X,Y coordinate of sprite on sheet
DIM Columns% '    number of sprite columns contained on sheet

MarioSheet& = _LOADIMAGE("mario32x32.png", 32) ' load sprite cheet
Columns% = _WIDTH(MarioSheet&) \ 32 '                              calculate number of columns on sheet

SCREEN _NEWIMAGE(320, 200, 32) '                                   enter graphics screen
DO '                                                               begin main loop
    CLS '                                                          clear screen
    LOCATE 2, 1 '                                                  position text cursor
    LINE INPUT "Enter sprite number (0 to exit)> ", n$ '           print directions
    Num% = VAL(n$) '                                               convert asnwer to numeric value
    IF Num% > 0 THEN '                                             value greater than 0?
        IF Num% MOD Columns% = 0 THEN '                            yes, is this sprite in rightmost column?
            x% = 32 * (Columns% - 1) '                             yes, calculate X coordinate of this sprite
            y% = (Num% \ Columns% - 1) * 32 '                      calculate Y coordinate of this sprite
        ELSE '                                                     no, in column left of rightmost column
            x% = (Num% MOD Columns% - 1) * 32 '                    calculate X coordinate of this sprite
            y% = (Num% \ Columns%) * 32 '                          calculate Y coordinate of this sprite
        END IF
        IF y% > _HEIGHT(MarioSheet&) - 1 THEN '                    does sprite row exist?
            LOCATE 7, 2 '                                          no, position text cursor
            PRINT "That sprite does not exist!" '                  report error to user
        ELSE '                                                     yes, row exists
            _PUTIMAGE (100, 50), MarioSheet&, , (x%, y%)-(x% + 31, y% + 31) ' copy/paste from sprite sheet
            LOCATE 7, 2 '                                          position text cursor
            PRINT "Sprite located at position"; Num% '             print results
            LOCATE 8, 2 '                                          position text cursor
            PRINT "Press any key to continue.." '                  print directions
        END IF
        DO: LOOP UNTIL INKEY$ <> "" '                              wait for key press
    END IF
LOOP UNTIL Num% = 0 '                                              leave when 0 entered for sprite number
_FREEIMAGE MarioSheet& '                                           remove sprite sheet from memory
SYSTEM '                                                           return to operating system





