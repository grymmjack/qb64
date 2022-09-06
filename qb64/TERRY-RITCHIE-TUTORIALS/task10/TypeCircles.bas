'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST TOTAL = 50 '              number of circles on screen at one time

TYPE CIRCLES '                  data structure to hold circle info
    x AS SINGLE '               x location of circle
    y AS SINGLE '               y location of circle
    r AS INTEGER '              radius of circle
    c AS _UNSIGNED LONG '       color of circle
    Xdir AS SINGLE '            x direction of circle
    Ydir AS SINGLE '            y direction of cicle
END TYPE

DIM Circles(TOTAL) AS CIRCLES ' structured array to hold circles
DIM Count% '                    generic FOR...NEXT counter

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                                                 enter graphics screen
RANDOMIZE TIMER '                                                                seed number generator
FOR Count% = 0 TO TOTAL '                                                        cycle through circles
    Circles(Count%).r = INT(RND(1) * 20) + 20 '                                  random circle size
    Circles(Count%).c = _RGB32(INT(RND(1) * 256), INT(RND(1) * 256), INT(RND(1) * 256)) ' random color
    Circles(Count%).x = INT(RND(1) * (639 - Circles(Count%).r * 2)) + Circles(Count%).r ' random x location
    Circles(Count%).y = INT(RND(1) * (479 - Circles(Count%).r * 2)) + Circles(Count%).r ' random y location
    Circles(Count%).Xdir = RND(1) - RND(1) '                                     random x direction
    Circles(Count%).Ydir = RND(1) - RND(1) '                                     random y direction
NEXT Count%
DO '                                                                             begin main program loop
    CLS '                                                                        clear the screen
    _LIMIT 240 '                                                                 240 frames per second
    FOR Count% = 0 TO TOTAL '                                                    cycle through circles
        Circles(Count%).x = Circles(Count%).x + Circles(Count%).Xdir '           change circle x location
        IF Circles(Count%).x < Circles(Count%).r OR Circles(Count%).x > 639 - Circles(Count%).r THEN 'screen edge?
            Circles(Count%).Xdir = -Circles(Count%).Xdir '                       yes, reverse x direction
        END IF
        Circles(Count%).y = Circles(Count%).y + Circles(Count%).Ydir '           change circle y location
        IF Circles(Count%).y < Circles(Count%).r OR Circles(Count%).y > 479 - Circles(Count%).r THEN 'screen edge?
            Circles(Count%).Ydir = -Circles(Count%).Ydir '                       yes, reverse y direction
        END IF
        CIRCLE (Circles(Count%).x, Circles(Count%).y), Circles(Count%).r, Circles(Count%).c ' draw circle
        PAINT (Circles(Count%).x, Circles(Count%).y), Circles(Count%).c, Circles(Count%).c '  paint inside circle
    NEXT Count%
    _DISPLAY '                                                                   update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                                        leave loop when ESC pressed
SYSTEM '                                                                         return to Windows



















