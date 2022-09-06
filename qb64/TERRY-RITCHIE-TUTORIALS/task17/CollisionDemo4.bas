'** Circular Collision Demo #4
'** Rectangular Collision Checked First

CONST RED = _RGB32(255, 0, 0) '     define colors
CONST GREEN = _RGB32(0, 255, 0)
CONST YELLOW = _RGB32(255, 255, 0)
CONST DARKGREEN = _RGB32(0, 127, 0)

TYPE CIRCLES '               circle definition
    x AS INTEGER '           center X of circle
    y AS INTEGER '           center Y of circle
    radius AS INTEGER '      circle radius
END TYPE

TYPE RECT '                  rectangle definition
    x1 AS INTEGER '          upper left X
    y1 AS INTEGER '          upper left Y
    x2 AS INTEGER '          lower right X
    y2 AS INTEGER '          lower right Y
END TYPE

DIM RedCircle AS CIRCLES '   red circle properties
DIM GreenCircle AS CIRCLES ' green circle properties
DIM RedBox AS RECT '         rectangle coordinates of red circle
DIM GreenBox AS RECT '       rectangle coordinates of green circle
DIM CircleColor~& '          color of green circle

GreenCircle.x = 319 '                                 green circle center X
GreenCircle.y = 239 '                                 green circle center Y
GreenCircle.radius = 50 '                             green circle radius
RedCircle.radius = 25 '                               red circle radius

SCREEN _NEWIMAGE(640, 480, 32) '                      enter graphics screen
_MOUSEHIDE '                                          hide the mouse pointer
DO '                                                  begin main program loop
    _LIMIT 30 '                                       30 frames per second
    CLS '                                             clear screen
    WHILE _MOUSEINPUT: WEND '                         get latest mouse information
    RedCircle.x = _MOUSEX '                           record mouse X location
    RedCircle.y = _MOUSEY '                           record mouse Y location
    RedBox.x1 = RedCircle.x - RedCircle.radius '      calculate rectangular coordinates
    RedBox.y1 = RedCircle.y - RedCircle.radius '      for red and green circle
    RedBox.x2 = RedCircle.x + RedCircle.radius
    RedBox.y2 = RedCircle.y + RedCircle.radius
    GreenBox.x1 = GreenCircle.x - GreenCircle.radius
    GreenBox.y1 = GreenCircle.y - GreenCircle.radius
    GreenBox.x2 = GreenCircle.x + GreenCircle.radius
    GreenBox.y2 = GreenCircle.y + GreenCircle.radius
    IF RectCollide(RedBox, GreenBox) THEN '           rectangular collision?
        LOCATE 2, 33 '                                yes, position text cursor
        PRINT "PROXIMITY ALERT!" '                    report the close proximity
        CircleColor~& = DARKGREEN '                   green circle become dark green during proximity
        IF CircCollide(RedCircle, GreenCircle) THEN ' circle collision?
            LOCATE 2, 33 '                            yes, position text cursor
            PRINT "   COLLISION!   " '                report collision happening
            CircleColor~& = YELLOW '                  green circle become yellow during collision
        END IF
    ELSE '                                            no collision
        CircleColor~& = GREEN '                       green circle will be green when no collision
    END IF
    CIRCLE (GreenCircle.x, GreenCircle.y), GreenCircle.radius, CircleColor~& ' draw green circle
    PAINT (GreenCircle.x, GreenCircle.y), CircleColor~&, CircleColor~& '       paint green circle
    CIRCLE (RedCircle.x, RedCircle.y), RedCircle.radius, RED '                 draw red circle
    PAINT (RedCircle.x, RedCircle.y), RED, RED '                               paint red circle
    _DISPLAY '                                        update screen with changes
LOOP UNTIL _KEYDOWN(27) '                             leave when ESC key pressed
SYSTEM '                                              return to operating system

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

'------------------------------------------------------------------------------------------------------------
FUNCTION CircCollide (Circ1 AS CIRCLES, Circ2 AS CIRCLES)
    '--------------------------------------------------------------------------------------------------------
    '- Checks for the collision between two circular areas.            -
    '- Returns -1 if in collision                                      -
    '- Returns  0 if no collision                                      -
    '-                                                                 -
    '- Circ1 - circle 1 properties                                     -
    '- Circ2 - circle 2 properties                                     -
    '-                                                                 -
    '- Removal of square root by Brandon Ritchie for                   -
    '- more efficient and faster code. 05/10/20                        -
    '-                                                                 -
    '- original code read:                                             -
    '-                                                                 -
    '- Hypot% = INT(SQR(SideA% * SideA% + SideB% * SideB%))            -
    '- IF Hypot% <= Circ1.radius + Circ2.radius THEN CircCollide = -1  -
    '-                                                                 -
    '- Changed to current code below                                   -
    '-------------------------------------------------------------------

    '** declare local variables

    DIM SideA% ' side A length of right triangle
    DIM SideB% ' side B length of right triangle
    DIM Hypot& ' hypotenuse squared length of right triangle (side C)

    '** check for collision

    CircCollide = 0 '                                       assume no collision
    SideA% = Circ1.x - Circ2.x '                            calculate length of side A
    SideB% = Circ1.y - Circ2.y '                            calculate length of side B
    Hypot& = SideA% * SideA% + SideB% * SideB% '            calculate hypotenuse squared

    '** is hypotenuse squared <= the square of radii added together?
    '** if so then collison has occurred

    IF Hypot& <= (Circ1.radius + Circ2.radius) * (Circ1.radius + Circ2.radius) THEN CircCollide = -1 '                                  yes, a collision has occurred

END FUNCTION




















