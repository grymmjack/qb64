'** Rectangular Collision Demo

CONST RED = _RGB32(255, 0, 0) '     define colors
CONST GREEN = _RGB32(0, 255, 0)
CONST YELLOW = _RGB32(255, 255, 0)

DIM RedX%, RedY% '                  red box upper left coordinate
DIM GreenX%, GreenY% '              green box upper left coordinate
DIM RedWidth%, RedHeight% '         red box width and height
DIM GreenWidth%, GreenHeight% '     green box width and height
DIM BoxColor~& '                    color of green box

GreenX% = 294 '                     upper left X coordinate of green box
GreenY% = 214 '                     upper left Y coordinate of green box
RedWidth% = 25 '                    width of red box
RedHeight% = 25 '                   height of red box
GreenWidth% = 50 '                  width of green box
GreenHeight% = 50 '                 height of green box
SCREEN _NEWIMAGE(640, 480, 32) '    enter graphics screen
_MOUSEHIDE '                        hide the mouse pointer
DO '                                begin main program loop
    _LIMIT 30 '                     30 frames per second
    CLS '                           clear screen
    WHILE _MOUSEINPUT: WEND '       get latest mouse information
    RedX% = _MOUSEX '               record mouse X location
    RedY% = _MOUSEY '               record mouse Y location

    '** check for collision between two rectangular areas

    IF RectCollide(RedX%, RedY%, RedWidth%, RedHeight%, GreenX%, GreenY%, GreenWidth%, GreenHeight%) THEN
        LOCATE 2, 36 '              position text cursor
        PRINT "COLLISION!" '        report collision happening
        BoxColor~& = YELLOW '       green box will become yellow during collision
    ELSE '                          no collision
        BoxColor~& = GREEN '        green box will be green when no collision
    END IF

    '** draw the two rectangles to screen

    LINE (GreenX%, GreenY%)-(GreenX% + GreenWidth% - 1, GreenY% + GreenHeight% - 1), BoxColor~&, BF
    LINE (RedX%, RedY%)-(RedX% + RedWidth% - 1, RedY% + RedHeight% - 1), RED, BF
    _DISPLAY '                      update screen with changes
LOOP UNTIL _KEYDOWN(27) '           leave when ESC key pressed
SYSTEM '                            return to operating system

'------------------------------------------------------------------------------------------------------------
FUNCTION RectCollide (Rectangle1_x1%, Rectangle1_y1%, Rectangle1Width%, Rectangle1Height%,_
                      Rectangle2_x1%, Rectangle2_y1%, Rectangle2Width%, Rectangle2Height%)
    '--------------------------------------------------------------------------------------------------------
    '- Checks for the collision between two rectangular areas. -
    '- Returns -1 if in collision                              -
    '- Returns  0 if no collision                              -
    '-                                                         -
    '- Rectangle1_x1%    - rectangle 1 upper left X            -
    '- Rectangle1_y1%    - rectangle 1 upper left y            -
    '- Rectangle1Width%  - width  of rectangle 1               -
    '- Rectangle1Height% - height of rectangle 1               -
    '- Rectangle2_x1%    - recatngle 2 upper left X            -
    '- Rectangle2_y1%    - rectangle 2 upper left Y            -
    '- Rectangle2Width%  - width  of rectangle 2               -
    '- Rectangle2Height% - height of rectangle 2               -
    '-----------------------------------------------------------

    '** declare local variables

    DIM Rectangle1_x2% ' rectangle 1 lower right X
    DIM Rectangle1_y2% ' rectangle 1 lower right Y
    DIM Rectangle2_x2% ' rectangle 2 lower right X
    DIM Rectangle2_y2% ' rectangle 2 lower right Y

    '** calculate lower right X,Y coordinate for each rectangle

    Rectangle1_x2% = Rectangle1_x1% + Rectangle1Width% - 1 '  rectangle 1 lower right X
    Rectangle1_y2% = Rectangle1_y1% + Rectangle1Height% - 1 ' rectangle 1 lower right Y
    Rectangle2_x2% = Rectangle2_x1% + Rectangle2Width% - 1 '  rectangle 2 lower right X
    Rectangle2_y2% = Rectangle2_y1% + Rectangle2Height% - 1 ' rectangle 2 lower right Y

    '** test for collision

    RectCollide = 0 '                                      assume no collision
    IF Rectangle1_x2% >= Rectangle2_x1% THEN '             rect 1 lower right X >= rect 2 upper left  X ?
        IF Rectangle1_x1% <= Rectangle2_x2% THEN '         rect 1 upper left  X <= rect 2 lower right X ?
            IF Rectangle1_y2% >= Rectangle2_y1% THEN '     rect 1 lower right Y >= rect 2 upper left  Y ?
                IF Rectangle1_y1% <= Rectangle2_y2% THEN ' rect 1 upper left  Y <= rect 2 lower right Y ?
                    RectCollide = -1 '                     if all 4 IFs true then a collision must be happening
                END IF
            END IF
        END IF
    END IF

END FUNCTION







