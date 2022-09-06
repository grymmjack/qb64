'**      Putimage Demo 3 - Resizing
'**
'** _PUTIMAGE (dx1%, dy1%) - (dx2%, dy2%), Source&, Dest&

DIM Bee& '                   the image file
DIM dx1%, dy1%, dx2%, dy2% ' x,y coordinates of display box

Bee& = _LOADIMAGE(".\tutorial\task15\tbee0.png", 32) '  load bee image file into memory
SCREEN _NEWIMAGE(640, 480, 32) '                        enter a graphics screen (becomes new destination)
dx1% = (640 - _WIDTH(Bee&)) \ 2 '                       calculate upper left x position
dy1% = (480 - _WIDTH(Bee&)) \ 2 '                       calculate upper left y position
dx2% = dx1% + _WIDTH(Bee&) '                            calculate lower right x poisition
dy2% = dy1% + _HEIGHT(Bee&) '                           calculate lower right y position
DO '                                                    main loop
    _LIMIT 240 '                                        limit speed to 240 frames per second
    CLS , _RGB32(127, 127, 127) '                       clear the screen with gray
    LOCATE 2, 23 '                                      position text cursor
    PRINT "Resizing an image using _PUTIMAGE." '        display instructions
    LOCATE 3, 14
    PRINT "Use UP/DOWN arrow keys to resize image, ESC to exit."
    _PUTIMAGE (dx1%, dy1%)-(dx2%, dy2%), Bee& '         put image on screen
    IF _KEYDOWN(18432) THEN '                           up arrow key pressed?
        dx1% = dx1% - 1 '                               yes, increase size of display box
        dy1% = dy1% - 1
        dx2% = dx2% + 1
        dy2% = dy2% + 1
    ELSEIF _KEYDOWN(20480) THEN '                       down arrow pressed?
        dx1% = dx1% + 1 '                               yes, decrease size of display box
        dy1% = dy1% + 1
        dx2% = dx2% - 1
        dy2% = dy2% - 1
    END IF
    _DISPLAY '                                          update screen with changes
LOOP UNTIL _KEYDOWN(27)
_FREEIMAGE Bee& '                                       remove bee image from memory
SYSTEM '                                                return to OS

