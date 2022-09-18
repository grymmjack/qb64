'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST TOTAL = 50 '                number of circles on screen at one time

DIM x!(TOTAL), y!(TOTAL) '       circle x,y coordinates
DIM Xdir!(TOTAL), Ydir!(TOTAL) ' circle x,y directions
DIM Size%(TOTAL) '               circle sizes
DIM Col~&(TOTAL) '               circle colors
DIM Count% '                     generic FOR...NEXT counter

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                                                 enter graphics screen
RANDOMIZE TIMER '                                                                seed number generator
FOR Count% = 1 TO TOTAL '                                                        cycle through circles
    Size%(Count%) = INT(RND(1) * 20) + 20 '                                      random circle size
    Col~&(Count%) = _RGB32(INT(RND(1) * 256), INT(RND(1) * 256), INT(RND(1) * 256)) ' random color
    x!(Count%) = INT(RND(1) * (639 - Size%(Count%) * 2)) + Size%(Count%) '       random x location
    y!(Count%) = INT(RND(1) * (479 - Size%(Count%) * 2)) + Size%(Count%) '       random y location
    Xdir!(Count%) = RND(1) - RND(1) '                                            random x direction
    Ydir!(Count%) = RND(1) - RND(1) '                                            random y direction
NEXT Count%
DO '                                                                             begin main program loop
    CLS '                                                                        clear the screen
    _LIMIT 240 '                                                                 240 frames per second
    FOR Count% = 1 TO TOTAL '                                                    cycle through circles
        x!(Count%) = x!(Count%) + Xdir!(Count%) '                                change circle x location
        IF x!(Count%) < Size%(Count%) OR x!(Count%) > 639 - Size%(Count%) THEN ' circle hit screen edge?
            Xdir!(Count%) = -Xdir!(Count%) '                                     yes, reverse x direction
        END IF
        y!(Count%) = y!(Count%) + Ydir!(Count%) '                                change circle y location
        IF y!(Count%) < Size%(Count%) OR y!(Count%) > 479 - Size%(Count%) THEN ' circle hit screen edge?
            Ydir!(Count%) = -Ydir!(Count%) '                                     yes, reverse y direction
        END IF
        CIRCLE (x!(Count%), y!(Count%)), Size%(Count%), Col~&(Count%) '          draw circle
        PAINT (x!(Count%), y!(Count%)), Col~&(Count%), Col~&(Count%) '           paint inside circle
    NEXT Count%
    _DISPLAY '                                                                   update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                                        leave loop when ESC pressed
SYSTEM '                                                                         return to Windows



















