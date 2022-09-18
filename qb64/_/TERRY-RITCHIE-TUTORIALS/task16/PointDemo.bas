'** Demo - POINT

DIM Sky& '     sky image
DIM Bee& '     bee image (with transparency)
DIM Pcolor~& ' color at mouse pointer

Sky& = _LOADIMAGE("sky.png", 32) '   load sky image
Bee& = _LOADIMAGE("tbee0.png", 32) ' load transparent bee image
SCREEN _NEWIMAGE(640, 480, 32) '                       create graphics screen
DO '                                                   begin main loop
    _LIMIT 30 '                                        30 frames per second
    _PUTIMAGE (0, 0), Sky& '                           place sky image on screen
    _PUTIMAGE (250, 171), Bee& '                       place transparent bee image on screen
    WHILE _MOUSEINPUT: WEND '                          get latest mouse information
    Pcolor~& = POINT(_MOUSEX, _MOUSEY) '               get color at mouse pointer
    LOCATE 2, 2 '                                      print results
    PRINT "Color:"; Pcolor~&
    LOCATE 3, 2
    PRINT "Red  :"; _RED32(Pcolor~&) '                 print just the red compoenet value
    LOCATE 4, 2
    PRINT "Green:"; _GREEN32(Pcolor~&) '               print just the green component values
    LOCATE 5, 2
    PRINT "Blue :"; _BLUE32(Pcolor~&) '                print just the blue component values
    _DISPLAY '                                         update screen with changes
LOOP UNTIL _KEYDOWN(32) '                              end loop when ESC key pressed
SYSTEM '                                               return to operating system


