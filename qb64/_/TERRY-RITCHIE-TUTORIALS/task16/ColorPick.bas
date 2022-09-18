'** _RGB32 vs _RGB demo

DIM Red% '       red color component
DIM Green% '     green color component
DIM Blue% '      blue color component
DIM Screen256& ' 256 color image
DIM Screen32& '  16M color image
DIM Smode% '     current screen mode
DIM Mode$(1) '   screen mode details

Screen256& = _NEWIMAGE(640, 480, 256) '                    create 256 color image
Screen32& = _NEWIMAGE(640, 480, 32) '                      create 16M color image
Mode$(0) = "256 color (8 bit)" '                           256 color mode details
Mode$(1) = "16M color (32 bit)" '                          16M color mode details
Red% = 127
Green% = 127
Blue% = 127
SCREEN Screen256& '                                        start in 256 color mode
DO
    _LIMIT 60 '                                            60 loops per second
    KeyPress$ = INKEY$ '                                   did user press a key?
    IF KeyPress$ = " " THEN ' '                            yes, was it the space bar?
        Smode% = 1 - Smode% '                              yes, toggle screen mode indicator
        SELECT CASE Smode% '                               which mode are we in?
            CASE 0 '                                       256 color mode
                SCREEN Screen256& '                        change to 256 color screen
            CASE 1 '                                       16M color mode
                SCREEN Screen32& '                         change to 16M color screen
        END SELECT
    END IF
    CLS '                                                  clear the screen
    CIRCLE (319, 239), 100, _RGB(Red%, Green%, Blue%) '    draw circle using color components
    PAINT (319, 239), _RGB(Red%, Green%, Blue%), _RGB(Red%, Green%, Blue%) ' paint the circle
    IF _KEYDOWN(113) THEN '                                is Q key down?
        Red% = Red% + 1 '                                  yes, increment red component
        IF Red% = 256 THEN Red% = 255 '                    keep it in limits
    END IF
    IF _KEYDOWN(97) THEN '                                 is A key down?
        Red% = Red% - 1 '                                  yes, decrement red component
        IF Red% = -1 THEN Red% = 0 '                       keep it in limits
    END IF
    IF _KEYDOWN(119) THEN '                                is W key down?
        Green% = Green% + 1 '                              yes, increment green component
        IF Green% = 256 THEN Green% = 255 '                keep it in limits
    END IF
    IF _KEYDOWN(115) THEN '                                is S key down?
        Green% = Green% - 1 '                              yes, decrement green component
        IF Green% = -1 THEN Green% = 0 '                   keep it in limits
    END IF
    IF _KEYDOWN(101) THEN '                                is E key down?
        Blue% = Blue% + 1 '                                yes, increment blue component
        IF Blue% = 256 THEN Blue% = 255 '                  keep it in limits
    END IF
    IF _KEYDOWN(100) THEN '                                is D key down?
        Blue% = Blue% - 1 '                                yes, decrement blue component
        IF Blue% = -1 THEN Blue% = 0 '                     keep it in limits
    END IF
    PRINT " MODE  : "; Mode$(Smode%), , "SPACEBAR to change modes" ' display info to user
    PRINT " RED   : Dec ="; Red%, " Hex = "; HEX$(Red%), "Q to increase  A to decrease "
    PRINT " GREEN : Dec ="; Green%, " Hex = "; HEX$(Green%), "W to increase  S to decrease "
    PRINT " BLUE  : Dec ="; Blue%, " Hex = "; HEX$(Blue%), "E to increase  D to decrease "
    PRINT " _RGB  : Dec ="; _RGB(Red%, Green%, Blue%), " Hex = "; RIGHT$(HEX$(_RGB(Red%, Green%, Blue%)), 6)
    PRINT " _RGB32: Dec ="; _RGB32(Red%, Green%, Blue%), " Hex = "; RIGHT$(HEX$(_RGB32(Red%, Green%, Blue%)), 6)
    _DISPLAY '                                             update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                  leave when ESC key pressed
SYSTEM '                                                   return to Windows




























