'** Ball Chaser Demo
'** Calculate angle from object to object
'** Use angle to calculate vector values

CONST BRIGHTGREEN = _RGB32(0, 255, 0) ' declare colors
CONST BRIGHTRED = _RGB32(255, 0, 0)
CONST PI = 3.1415926 '                  value of Pi
CONST PIDIV180 = PI / 180 '             value of Pi / 180

TYPE BALL '                             ball definition
    x AS SINGLE '                       X location
    y AS SINGLE '                       Y location
    xvector AS SINGLE '                 X vector
    yvector AS SINGLE '                 Y vector
    radius AS INTEGER '                 ball radius
    speed AS INTEGER '                  ball speed
END TYPE

DIM GreenBall AS BALL '                 auto moving green ball
DIM RedBall AS BALL '                   user controlled red ball
DIM Angle2RedBall! '                    angle from green ball to red ball

GreenBall.x = 319 '                     set green ball properties
GreenBall.y = 239
GreenBall.speed = 5
GreenBall.radius = 15
RedBall.radius = 15 '                   red ball radius

SCREEN _NEWIMAGE(640, 480, 32) '        enter graphics screen
_MOUSEHIDE '                            hide mouse pointer
DO '                                    begin main loop
    _LIMIT 30 '                         30 frames per second
    CLS '                               clear screen
    WHILE _MOUSEINPUT: WEND '           get latest mouse information
    RedBall.x = _MOUSEX '               red ball X coordinate
    RedBall.y = _MOUSEY '               red ball Y coordinate

    '** get the angle from green ball to red ball

    Angle2RedBall! = P2PAngle(GreenBall.x, GreenBall.y, RedBall.x, RedBall.y)

    '** calculate X and Y vectors of green ball based on angle

    Angle2Vector Angle2RedBall!, GreenBall.xvector, GreenBall.yvector
    GreenBall.x = GreenBall.x + GreenBall.xvector * GreenBall.speed
    GreenBall.y = GreenBall.y + GreenBall.yvector * GreenBall.speed

    '** display information

    LOCATE 2, 2
    PRINT "Angle to red ball   >"; Angle2RedBall!
    LOCATE 3, 2
    PRINT "Green ball X vector > "; USING "##.##"; GreenBall.xvector
    LOCATE 4, 2
    PRINT "Green ball Y vector > "; USING "##.##"; GreenBall.yvector

    '** draw objects

    CIRCLE (RedBall.x, RedBall.y), RedBall.radius, BRIGHTRED
    PAINT (RedBall.x, RedBall.y), BRIGHTRED, BRIGHTRED
    CIRCLE (GreenBall.x, GreenBall.y), GreenBall.radius, BRIGHTGREEN
    PAINT (GreenBall.x, GreenBall.y), BRIGHTGREEN, BRIGHTGREEN
    _DISPLAY
LOOP UNTIL _KEYDOWN(27)
SYSTEM

'------------------------------------------------------------------------------------------------------------
SUB Angle2Vector (Angle!, xv!, yv!) ' angle to vector calculator
    '--------------------------------------------------------------------------------------------------------
    '- Converts the angle passed in to x and y vector values                         -
    '-                                                                               -
    '- Angle! - the angle to convert to vectors (0 to 359.99)                        -
    '- xv!    - the x vector calculated from Angle!                                  -
    '- yv!    - the y vecotr calculated from Angle!                                  -
    '-                                                                               -
    '- NOTE: the values in xv! and yv! will be passed back to the calling variables. -
    '---------------------------------------------------------------------------------

    xv! = SIN(Angle! * PIDIV180) '  calculate x vector value
    yv! = -COS(Angle! * PIDIV180) ' calculate y vector value

END SUB

'------------------------------------------------------------------------------------------------------------
FUNCTION P2PAngle (x1!, y1!, x2!, y2!) ' point to point angle calculator
    '--------------------------------------------------------------------------------------------------------
    '- Calculates the angle (0 to 359) in degrees between two coordinate pairs. -                                                 |
    '-                                                                          -                                                 |
    '- Input : x1! = x coordinate location of first point  (from)               -                                                  |
    '-         y1! = y coordinate location of first point                       -                                                  |
    '-         x2! = x coordinate location of second point (to)                 -                                                  |
    '-         y2! = y coordinate location of second point                      -                                                  |
    '- Output: the angle from x1,y1 to x2,y2 in degrees.                        -                                                 |
    '----------------------------------------------------------------------------
    '  _________________________________________________________________________________
    ' |      0ø         y2-y1                                                           |
    ' |      |           (B)              x2,y2           Formula used here:            |
    ' |      |~~|~~~~~~~~~~~~~~~~~~~~~~~~~~/                                            |
    ' |      |--+                        /           radians = ATN((x2-x1)/(y2-y1))     |
    ' |      |>>>****                  /             degrees = radians * 180 / -Pi      |
    ' |      |       ******          /                                                  |
    ' |      |             ***     /                  (180 / -Pi = -57.2957795131)      |
    ' |      |                ** /                                                      |
    ' |      |                 /**                Arctangent is used to get the change  |
    ' |      |       x2-x1   /    **              in Y divided by the change in X. We   |
    ' |      |        (A)  /        *             do this by setting up a right         |
    ' |      |           /           *            triangle between the two points using |
    ' |      |         /    Direction *           the vertical zero degree axis as a    |
    ' |      | angle /    of rotation *           reference. The result of calculating  |
    ' |      |-_   /                   *          the Arctangent of length A divided by |
    ' |      |  ~/                     |          length B is the answer in radians. To |
    ' |      | /                       V          convert the radians to degrees we     |
    ' |      +----------------------------- 90ø   multiply the radians by 180 and then  |
    ' |    x1,y1                                  divide by -Pi.                        |
    '  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    '
    ' This function is based off of work initially done by Rob (Galleon) with his getangle#
    ' function found at the now defunct QB64.net web site:
    ' http://www.qb64.net/forum/index.php?topic=3934.0

    DIM angle! ' angle from x1,y1 to x2,y2

    IF y1! = y2! THEN '                                        both y values same?
        IF x1! = x2! THEN '                                    yes, both x values same?
            EXIT FUNCTION '                                    yes, there is no angle (0), leave
        END IF
        IF x2! > x1! THEN '                                    is second x to the right of first x?
            P2PAngle = 90 '                                    yes, the angle must be 90 degrees
        ELSE '                                                 no, second x is to the left of first x
            P2PAngle = 270 '                                   the angle must be 270 degrees
        END IF
        EXIT FUNCTION '                                        leave function, angle computed
    END IF
    IF x1! = x2! THEN '                                        both x values same?
        IF y2! > y1! THEN '                                    yes, is second y lower than first y?
            P2PAngle = 180 '                                   yes, the angle must be 180
        END IF
        EXIT FUNCTION '                                        leave function, angle computed
    END IF
    angle! = ATN((x2! - x1!) / (y2! - y1!)) * -57.2957795131 ' calculate initial angle

    '** Adjust for angle quadrant

    IF y2! < y1! THEN '                                        is second y higher than first y?
        IF x2! > x1! THEN '                                    yes, is second x to right of first x?
            P2PAngle = angle! '                                yes, angle needs no adjustment
        ELSE '                                                 no, second x is to left of first x
            P2PAngle = angle! + 360 '                          adjust angle accordingly
        END IF
    ELSE '                                                     no, second y is lower than first y
        P2PAngle = angle! + 180 '                              adjust angle accordingly
    END IF

END FUNCTION

























