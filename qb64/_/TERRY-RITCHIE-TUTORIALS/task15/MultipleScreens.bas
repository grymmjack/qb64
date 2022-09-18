'*
'* Multiple screens demo
'*

DIM Image&(4) ' 4 image surfaces
DIM Count% '    image counter

'* prepare image surfaces

FOR Count% = 1 TO 4 '                                   cycle 4 times
    Image&(Count%) = _NEWIMAGE(640, 480, 32) '          create a new surface image
    _DEST Image&(Count%) '                              make the surface the destination
    CLS '                                               clear the surface
    LOCATE 2, 2 '                                       position text cursor
    PRINT "This is image number"; Count% '              print the surface number
    CIRCLE (Count% * 100, 300), 50 '                    draw a circle on the surface
NEXT Count%
Count% = 1 '                                            reset image counter

'* display each surface

DO '                                                    main program loop
    SCREEN Image&(Count%) '                             use image as current screen
    LOCATE 4, 2 '                                       position text cursor
    PRINT "Press ENTER to switch to the next screen." ' print directions
    PRINT " Press ESC to exit."
    SLEEP '                                             wait for key stroke
    Count% = Count% + 1 '                               increment image counter
    IF Count% = 5 THEN Count% = 1 '                     keep count within limits
LOOP UNTIL _KEYDOWN(27) '                               leave when escape key pressed
SYSTEM '                                                return to operating system

