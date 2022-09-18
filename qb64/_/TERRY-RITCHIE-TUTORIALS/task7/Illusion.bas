CONST CYAN = _RGB32(0, 255, 255) '          define cyan color
DIM x1%, y1% '                              upper left coordinates
DIM x2%, y2% '                              lower right coordinates
DIM Count% '                                FOR...NEXT loop counter
DIM Bit% '                                  pixel to turn on in style
DIM Style& '                                calculated style of line

SCREEN _NEWIMAGE(640, 480, 32) '            640 x 480 graphics screen
DO '                                        begin animation loop
    CLS '                                   clear the screen
    _LIMIT 60 '                             limit animation to 60 frames per second
    x1% = 0 '                               set starting coordinates
    y1% = 0
    x2% = 639
    y2% = 479
    PSET (0, 0), CYAN '                     set pixel to start with
    Bit% = Bit% + 1 '                       increment style bit counter
    IF Bit% = 16 THEN Bit% = 0 '            keep bit between 0 and 15
    Style& = 2 ^ Bit% '                     calculate line style
    FOR Count% = 1 TO 60 '                  cycle through line corkscrew 60 times
        LINE -(x2%, y1%), CYAN, , Style& '  draw lines with style
        LINE -(x2%, y2%), CYAN, , Style&
        LINE -(x1%, y2%), CYAN, , Style&
        y1% = y1% + 4 '                     update coordinates
        x2% = x2% - 4
        y2% = y2% - 4
        LINE -(x1%, y1%), CYAN, , Style& '  draw next line
        x1% = x1% + 4 '                     update coordinate
    NEXT Count%
    _DISPLAY '                              update screen with changes
LOOP UNTIL _KEYHIT '                        leave animation loop when key pressed

