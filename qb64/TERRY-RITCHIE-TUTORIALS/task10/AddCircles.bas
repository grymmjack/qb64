'--------------------------------
'- Variable Declaration Section -
'--------------------------------

TYPE CIRCLES '                data structure to hold circle info
    x AS SINGLE '             x location of circle
    y AS SINGLE '             y location of circle
    r AS INTEGER '            radius of circle
    c AS _UNSIGNED LONG '     color of circle
    Xdir AS SINGLE '          x direction of circle
    Ydir AS SINGLE '          y direction of cicle
END TYPE

REDIM Circles(0) AS CIRCLES ' structured dynamic array to hold circles
DIM Count% '                  generic FOR...NEXT counter
DIM Total% '                  total number of circles on screen

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                         enter graphics screen
RANDOMIZE TIMER '                                        seed number generator
Total% = 0 '                                             start with one circle
MakeCircle Total% '                                      create first circle
DO '                                                     begin main program loop
    CLS '                                                clear the screen
    _LIMIT 240 '                                         240 frames per second
    IF _KEYDOWN(18432) THEN '                            up arrow key pressed?
        Total% = Total% + 1 '                            yes, increment total circles
        IF Total% > 499 THEN '                           too many circles?
            Total% = 499 '                               yes, limit to max allowed
        ELSE '                                           no, still ok to add circle
            REDIM _PRESERVE Circles(Total%) AS CIRCLES ' resize array
            MakeCircle Total% '                          create circle at new index
        END IF
    ELSEIF _KEYDOWN(20480) THEN '                        down arrow key pressed?
        Total% = Total% - 1 '                            yes, decrement total circles
        IF Total% < 0 THEN Total% = 0 '                  limit to minimum if too few circles
    END IF
    FOR Count% = 0 TO Total% '                                          cycle through circles
        Circles(Count%).x = Circles(Count%).x + Circles(Count%).Xdir '  change circle x location
        IF Circles(Count%).x < Circles(Count%).r OR Circles(Count%).x > 639 - Circles(Count%).r THEN 'screen edge?
            Circles(Count%).Xdir = -Circles(Count%).Xdir '              yes, reverse x direction
        END IF
        Circles(Count%).y = Circles(Count%).y + Circles(Count%).Ydir '  change circle y location
        IF Circles(Count%).y < Circles(Count%).r OR Circles(Count%).y > 479 - Circles(Count%).r THEN 'screen edge?
            Circles(Count%).Ydir = -Circles(Count%).Ydir '              yes, reverse y direction
        END IF
        CIRCLE (Circles(Count%).x, Circles(Count%).y), Circles(Count%).r, Circles(Count%).c ' draw circle
        PAINT (Circles(Count%).x, Circles(Count%).y), Circles(Count%).c, Circles(Count%).c '  paint inside circle
    NEXT Count%
    LOCATE 2, 7 '                                                       print instructions
    PRINT "Press UP arrow key to add circles, DOWN arrow key to subract circles"
    LOCATE 4, 32
    PRINT "Press ESC to exit"
    LOCATE 28, 36
    PRINT "Total ="; Total% + 1 '                                       show total circles on screen
    _DISPLAY '                                                          update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                               leave loop when ESC pressed
SYSTEM '                                                                return to Windows

'------------------------------------------------------------------------------------------------------------
SUB MakeCircle (Index%)
    '--------------------------------------------------------------------------------------------------------
    '- Creates a new circle in Circle array at Index% -
    '--------------------------------------------------

    SHARED Circles() AS CIRCLES

    Circles(Index%).r = INT(RND(1) * 20) + 20 '                                  random circle size
    Circles(Index%).c = _RGB32(INT(RND(1) * 256), INT(RND(1) * 256), INT(RND(1) * 256)) ' random color
    Circles(Index%).x = INT(RND(1) * (639 - Circles(Index%).r * 2)) + Circles(Index%).r ' random x location
    Circles(Index%).y = INT(RND(1) * (479 - Circles(Index%).r * 2)) + Circles(Index%).r ' random y location
    Circles(Index%).Xdir = RND(1) - RND(1) '                                     random x direction
    Circles(Index%).Ydir = RND(1) - RND(1) '                                     random y direction

END SUB
















