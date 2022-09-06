'-------------------------
'- LINE demonstration #3 -
'-------------------------

CONST YELLOW = _RGB32(255, 255, 0) ' define yellow
DIM Style& '                         the line's style
DIM Bit% '                           the current bit in style to draw
DIM Dir% '                           style direction

Dir% = -1
SCREEN _NEWIMAGE(640, 480, 32) '                    switch into a 640x480 graphics screen
DO '                                                begin loop
    CLS '                                           clear the graphics screen
    _LIMIT 30 '                                     limit loop to 30 frames per second
    LOCATE 2, 33 '                                  print directions
    PRINT "A Stylized Line"
    LOCATE 4, 21
    PRINT "Press the Space Bar to change direction."
    LOCATE 6, 23
    PRINT "Press the Escape key to exit program."
    IF _KEYHIT = 32 THEN Dir% = -Dir% '             change bit counter direction when space bar pressed
    Bit% = Bit% + Dir% '                            increment bit counter
    IF Bit% = 16 THEN '                             keep bit counter between 0 and 15
        Bit% = 0
    ELSEIF Bit% = -1 THEN
        Bit% = 15
    END IF
    Style& = 2 ^ Bit% '                             calculate the line style
    LINE (99, 129)-(539, 409), YELLOW, B , Style& ' draw the line as a stylized box
    _DISPLAY '                                      update screen with changes
LOOP UNTIL _KEYDOWN(27) '                           leave loop when ESC key pressed

