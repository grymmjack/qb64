'** Demo - Bouncing Ball 3
'** X and Y vectors controlled with arrow keys
'** Slope line drawn indicating speed and direction

CONST SCREENWIDTH = 639 '  maximum pixel width value of screen
CONST SCREENHEIGHT = 479 ' maximum pixel width height of screen

TYPE BALL '                ball definition
    x AS SINGLE '          the X location of the ball
    y AS SINGLE '          the Y location of the ball
    xvector AS SINGLE '    the X direction of the ball
    yvector AS SINGLE '    the Y direction of the ball
    radius AS INTEGER '    the radius of the ball
    speed AS INTEGER '     the speed of the ball
END TYPE

DIM Ball AS BALL '         a ball object
DIM Dir$(-2 TO 2) '        user info strings indicating direction of ball

Dir$(1) = " moving right " + CHR$(26) '                   create direction info strings
Dir$(-1) = " moving left  " + CHR$(27)
Dir$(2) = " moving down  " + CHR$(25)
Dir$(-2) = " moving up    " + CHR$(24)
RANDOMIZE TIMER '                                         seed random number generator
Ball.speed = 5 '                                          set the ball speed
Ball.xvector = (RND(1) - RND(1)) '                        create random X vector for ball
Ball.yvector = (RND(1) - RND(1)) '                        create random Y vector for ball
Ball.x = SCREENWIDTH \ 2 '                                set ball X location at center of screen
Ball.y = SCREENHEIGHT \ 2 '                               set ball Y location at center of screen
Ball.radius = 15 '                                        set the ball radius
SCREEN _NEWIMAGE(SCREENWIDTH + 1, SCREENHEIGHT + 1, 32) ' enter 640x480 graphics screen
_PRINTMODE _KEEPBACKGROUND '                              merge text and bouncing ball
DO '                                                      begin main loop
    _LIMIT 30 '                                           30 frames per second
    CLS '                                                 clear screen
    CIRCLE (Ball.x, Ball.y), Ball.radius '                draw ball (default white)
    PAINT (Ball.x, Ball.y) '                              paint ball (default white)
    LINE (Ball.x, Ball.y)-(Ball.x + Ball.xvector * 100, Ball.y + Ball.yvector * 100) ' draw slope line

    '** if ball hits left or right side of screen reverse the X vector direction

    IF Ball.x + Ball.xvector > SCREENWIDTH - Ball.radius OR Ball.x + Ball.xvector < Ball.radius - 1 THEN
        Ball.xvector = -Ball.xvector
    END IF

    '** if ball hits top or bottom of screen reverse the Y vector direction

    IF Ball.y + Ball.yvector > SCREENHEIGHT - Ball.radius OR Ball.y + Ball.yvector < Ball.radius - 1 THEN
        Ball.yvector = -Ball.yvector
    END IF

    Ball.x = Ball.x + Ball.xvector * Ball.speed '         add the X vector to ball current X location
    Ball.y = Ball.y + Ball.yvector * Ball.speed '         add the Y vector to ball current Y location
    LOCATE 2, 2 '                                         print information to the user
    PRINT "Ball X direction > "; USING ("##.##"); Ball.xvector;
    PRINT Dir$(SGN(Ball.xvector))
    LOCATE 3, 2
    PRINT "Ball Y direction > "; USING ("##.##"); Ball.yvector;
    PRINT Dir$(SGN(Ball.yvector) * 2)
    LOCATE 4, 2
    PRINT "Ball speed       > "; Ball.speed
    LOCATE 5, 2
    PRINT "Ball X,Y location> "; INT(Ball.x); INT(Ball.y)
    LOCATE 6, 2
    PRINT "RIGHT ARROW increase X vector, LEFT ARROW decrease X vector."
    LOCATE 7, 2
    PRINT "DOWN ARROW increase Y vector, UP ARROW decrease Y vector."
    IF _KEYDOWN(19712) THEN '                             right arrow key?
        Ball.xvector = Ball.xvector + .05 '               yes, increase X vector
    ELSEIF _KEYDOWN(19200) THEN '                         left arrow key?
        Ball.xvector = Ball.xvector - .05 '               yes, decrease X vector
    END IF
    IF Ball.xvector < -1 THEN Ball.xvector = -1 '         keep X vector within limits
    IF Ball.xvector > 1 THEN Ball.xvector = 1

    IF _KEYDOWN(20480) THEN '                             down arrow key?
        Ball.yvector = Ball.yvector + .05 '               yes, increase Y vector
    ELSEIF _KEYDOWN(18432) THEN '                         up arrow key?
        Ball.yvector = Ball.yvector - .05 '               yes, decrease Y vector
    END IF
    IF Ball.yvector < -1 THEN Ball.yvector = -1 '         keep Y vector within limits
    IF Ball.yvector > 1 THEN Ball.yvector = 1
    _DISPLAY '                                            update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                 leave when ESC key pressed
SYSTEM '                                                  return to operating system



















