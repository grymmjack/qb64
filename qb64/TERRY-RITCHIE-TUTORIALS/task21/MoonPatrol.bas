'** Demo Moon Patrol Parallax

TYPE LAYER '            layer definition
    x AS INTEGER '      X location of layer
    y AS INTEGER '      Y location of layer
    xdir AS INTEGER '   X speed and direction of layer
    image AS LONG '     layer image
END TYPE

DIM Layer(3) AS LAYER ' array of 3 layers
DIM c% '                layer counter

Layer(1).image = _LOADIMAGE(".\tutorial\task21\moonpatrol1.png", 32) ' load layer images
Layer(2).image = _LOADIMAGE(".\tutorial\task21\moonpatrol2.png", 32)
Layer(3).image = _LOADIMAGE(".\tutorial\task21\moonpatrol3.png", 32)
Layer(1).xdir = -1 '                                                   set layer direction and speed
Layer(2).xdir = -2
Layer(3).xdir = -4
Layer(1).y = 95 '                                                      set layer Y position
Layer(2).y = 127
Layer(3).y = 191
SCREEN _NEWIMAGE(256, 256, 32) '                                       enter graphics screen
DO '                                                                   begin main loop
    _LIMIT 15 '                                                        15 frames per second
    CLS '                                                              clear screen
    c% = 0 '                                                           reset layer counter
    DO '                                                               cycle through layers
        c% = c% + 1 '                                                  increment layer counter
        _PUTIMAGE (Layer(c%).x, Layer(c%).y), Layer(c%).image '        place layer on screen
        Layer(c%).x = Layer(c%).x + Layer(c%).xdir '                   move layer to the left
        IF Layer(c%).x < -256 THEN Layer(c%).x = Layer(c%).x + 256 '   reset layer when end reached
    LOOP UNTIL c% = 3 '                                                leave when all layers placed
    _DISPLAY '                                                         update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                              leave when ESC key pressed
_FREEIMAGE Layer(1).image '                                            remove layer images from memory
_FREEIMAGE Layer(2).image
_FREEIMAGE Layer(3).image
SYSTEM '                                                               return to operating sysem



