'** Circular Collision Demo #3

CONST RED = _RGB32(255, 0, 0) '     define colors
CONST GREEN = _RGB32(0, 255, 0)
CONST YELLOW = _RGB32(255, 255, 0)

TYPE CIRCLES '          circle definition
    x AS INTEGER '      center X of circle
    y AS INTEGER '      center Y of circle
    radius AS INTEGER ' circle radius
END TYPE

DIM RedCircle AS CIRCLES '   red circle properties
DIM GreenCircle AS CIRCLES ' green circle properties
DIM CircleColor~& '          color of green circle

GreenCircle.x = 319 '                               green circle center X
GreenCircle.y = 239 '                               green circle center Y
GreenCircle.radius = 50 '                           green circle radius
RedCircle.radius = 25 '                             red circle radius

SCREEN _NEWIMAGE(640, 480, 32) '                    enter graphics screen
_MOUSEHIDE '                                        hide the mouse pointer
DO '                                                begin main program loop
    _LIMIT 30 '                                     30 frames per second
    CLS '                                           clear screen
    WHILE _MOUSEINPUT: WEND '                       get latest mouse information
    RedCircle.x = _MOUSEX '                         record mouse X location
    RedCircle.y = _MOUSEY '                         record mouse Y location
    IF CircCollide(RedCircle, GreenCircle) THEN '   circle collision?
        LOCATE 2, 36 '                              yes, position text cursor
        PRINT "COLLISION!" '                        report collision happening
        CircleColor~& = YELLOW '                    green circle become yellow during colision
    ELSE '                                          no collision
        CircleColor~& = GREEN '                     green circle will be green when no collision
    END IF
    CIRCLE (GreenCircle.x, GreenCircle.y), GreenCircle.radius, CircleColor~& ' draw green circle
    PAINT (GreenCircle.x, GreenCircle.y), CircleColor~&, CircleColor~& '       paint green circle
    CIRCLE (RedCircle.x, RedCircle.y), RedCircle.radius, RED '                 draw red circle
    PAINT (RedCircle.x, RedCircle.y), RED, RED '                               paint red circle
    _DISPLAY '                                      update screen with changes
LOOP UNTIL _KEYDOWN(27) '                           leave when ESC key pressed
SYSTEM '                                            return to operating system

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








