'--------------------------------
'- Variable declaration section -
'--------------------------------

TYPE CIRCLETYPE '                    CIRCLE DATA
    x AS SINGLE '                    x location of circle
    y AS SINGLE '                    y location of circle
    c AS _UNSIGNED LONG '            color of circle
    r AS INTEGER '                   radius of circle
    xdir AS SINGLE '                 x direction of circle
    ydir AS SINGLE '                 y direction of circle
END TYPE

CONST CIRCLES = 50 '                 maximum number of circles on the screen
CONST SCREENWIDTH = 640 '            graphics screen width
CONST SCREENHEIGHT = 480 '           graphics screen height

DIM Cir(CIRCLES - 1) AS CIRCLETYPE ' circle array
DIM Count% '                         circle counter
DIM Red%, Green%, Blue% '            circle color attributes
DIM OkToPaint% '                     toggle painting flag on/off

'----------------------
'- Begin main program -
'----------------------

RANDOMIZE TIMER '                                       seed the random number generator
FOR Count% = 0 TO CIRCLES - 1 '                         cycle through all circles
    Cir(Count%).x = SCREENWIDTH / 2 - 1 '               calculate x center point of circle
    Cir(Count%).y = SCREENHEIGHT / 2 - 1 '              calculate y center point of circle
    Red% = INT(RND(1) * 256) '                          random red intensity from 0 to 255
    Green% = INT(RND(1) * 256) '                        random green intensity from 0 to 255
    Blue% = INT(RND(1) * 256) '                         random blue intensity from 0 to 255
    Cir(Count%).c = _RGB32(Red%, Green%, Blue%) '       combine colors and save circle color
    Cir(Count%).r = INT(RND(1) * 40) + 11 '             random radius 10 to 50 pixels
    Cir(Count%).xdir = (RND(1) * 2 - RND(1) * 2) * 2 '  random x direction -2 to 2
    Cir(Count%).ydir = (RND(1) * 2 - RND(1) * 2) * 2 '  random y direction -2 to 2
NEXT Count%
OkToPaint% = -1 '                                                                start with painting enabled
SCREEN _NEWIMAGE(SCREENWIDTH, SCREENHEIGHT, 32) '                                create graphics screen
DO '                                                                             begin main program loop
    CLS '                                                                        clear the screen
    _LIMIT 60 '                                                                  limit to 60 frames per second
    FOR Count% = 0 TO CIRCLES - 1 '                                              cycle through all circles
        IF Cir(Count%).x <= Cir(Count%).r THEN '                                 edge of circle hit left wall?
            Cir(Count%).xdir = -Cir(Count%).xdir '                               yes, reverse x direction
        ELSEIF Cir(Count%).x >= SCREENWIDTH - Cir(Count%).r - 1 THEN '           edge of circle hit right wall?
            Cir(Count%).xdir = -Cir(Count%).xdir '                               yes, reverse x direction
        END IF
        IF Cir(Count%).y <= Cir(Count%).r THEN '                                 edge of circle hit top wall?
            Cir(Count%).ydir = -Cir(Count%).ydir '                               yes, change y direction
        ELSEIF Cir(Count%).y >= SCREENHEIGHT - Cir(Count%).r - 1 THEN '          edge of circle hit bottom wall?
            Cir(Count%).ydir = -Cir(Count%).ydir '                               yes, change y direction
        END IF
        Cir(Count%).x = Cir(Count%).x + Cir(Count%).xdir '                       update circle x location
        Cir(Count%).y = Cir(Count%).y + Cir(Count%).ydir '                       update circle y location
        CIRCLE (Cir(Count%).x, Cir(Count%).y), Cir(Count%).r, Cir(Count%).c '    draw circle
        IF OkToPaint% THEN '                                                     paint circles?
            PAINT (Cir(Count%).x, Cir(Count%).y), Cir(Count%).c, Cir(Count%).c ' yes, paint circle
        END IF
    NEXT Count%
    LOCATE 2, 26 '                                                               display directions
    PRINT "PRESS SPACEBAR TO TOGGLE PAINT"
    IF _KEYHIT = 32 THEN OkToPaint% = NOT OkToPaint% '                           togggle paint flag if space bar
    _DISPLAY '                                                                   update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                                        exit loop when ESC key pressed
SYSTEM '                                                                         return control to OS



























