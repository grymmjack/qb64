'** Rectangular Collision Demo #2

CONST RED = _RGB32(255, 0, 0) '     define colors
CONST GREEN = _RGB32(0, 255, 0)
CONST YELLOW = _RGB32(255, 255, 0)

TYPE RECT '            rectangle definition
    x1 AS INTEGER '    upper left X
    y1 AS INTEGER '    upper left Y
    x2 AS INTEGER '    lower right X
    y2 AS INTEGER '    lower right Y
END TYPE

DIM RedBox AS RECT '   red rectangle coordinates
DIM GreenBox AS RECT ' green rectangle coordinates
DIM BoxColor~& '       color of green box

GreenBox.x1 = 294 '                         upper left X coordinate of green box
GreenBox.y1 = 214 '                         upper left Y coordinate of green box
GreenBox.x2 = 344 '                         lower right X coordinate of green box
GreenBox.y2 = 264 '                         lower right Y coordinate of green box

SCREEN _NEWIMAGE(640, 480, 32) '            enter graphics screen
_MOUSEHIDE '                                hide the mouse pointer
DO '                                        begin main program loop
    _LIMIT 30 '                             30 frames per second
    CLS '                                   clear screen
    WHILE _MOUSEINPUT: WEND '               get latest mouse information
    RedBox.x1 = _MOUSEX '                   record mouse X location
    RedBox.y1 = _MOUSEY '                   record mouse Y location
    RedBox.x2 = RedBox.x1 + 25 '            calculate lower right X
    RedBox.y2 = RedBox.y1 + 25 '            calculate lower right Y
    IF RectCollide(RedBox, GreenBox) THEN ' rectangle collision?
        LOCATE 2, 36 '                      yes, position text cursor
        PRINT "COLLISION!" '                report collision happening
        BoxColor~& = YELLOW '               green box will become yellow during collision
    ELSE '                                  no collision
        BoxColor~& = GREEN '                green box will be green when no collision
    END IF
    LINE (GreenBox.x1, GreenBox.y1)-(GreenBox.x2, GreenBox.y2), BoxColor~&, BF ' draw green box
    LINE (RedBox.x1, RedBox.y1)-(RedBox.x2, RedBox.y2), RED, BF '                draw red box
    _DISPLAY '                              update screen with changes
LOOP UNTIL _KEYDOWN(27) '                   leave when ESC key pressed
SYSTEM '                                    return to operating system

'------------------------------------------------------------------------------------------------------------
FUNCTION RectCollide (Rect1 AS RECT, Rect2 AS RECT)
    '--------------------------------------------------------------------------------------------------------
    '- Checks for the collision between two rectangular areas. -
    '- Returns -1 if in collision                              -
    '- Returns  0 if no collision                              -
    '-                                                         -
    '- Rect1 - rectangle 1 coordinates                         -
    '- Rect2 - rectangle 2 coordinates                         -
    '-----------------------------------------------------------

    RectCollide = 0 '                          assume no collision
    IF Rect1.x2 >= Rect2.x1 THEN '             rect 1 lower right X >= rect 2 upper left  X ?
        IF Rect1.x1 <= Rect2.x2 THEN '         rect 1 upper left  X <= rect 2 lower right X ?
            IF Rect1.y2 >= Rect2.y1 THEN '     rect 1 lower right Y >= rect 2 upper left  Y ?
                IF Rect1.y1 <= Rect2.y2 THEN ' rect 1 upper left  Y <= rect 2 lower right Y ?
                    RectCollide = -1 '         if all 4 IFs true then a collision must be happening
                END IF
            END IF
        END IF
    END IF

END FUNCTION







