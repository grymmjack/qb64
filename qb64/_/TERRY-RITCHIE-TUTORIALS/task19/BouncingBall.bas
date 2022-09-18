'** Demo - Bouncing Ball

CONST SCREENWIDTH = 639 '  maximum pixel width value of screen
CONST SCREENHEIGHT = 479 ' maximum pixel width height of screen

DIM BallXvector! ' the X direction of the ball
DIM BallYvector! ' the Y direction of the ball
DIM BallX! '       the X location of the ball
DIM BallY! '       the Y location of the ball
DIM BallRadius% '  the radius of the ball
DIM BallSpeed% '   the speed of the ball

RANDOMIZE TIMER '                                         seed random number generator
BallSpeed% = 10 '                                         set the ball speed
BallXvector! = (RND(1) - RND(1)) * BallSpeed% '           create random X vector for ball
BallYvector! = (RND(1) - RND(1)) * BallSpeed% '           create random Y vector for ball
BallX! = SCREENWIDTH \ 2 '                                set ball X location at center of screen
BallY! = SCREENHEIGHT \ 2 '                               set ball Y location at center of screen
BallRadius% = 25 '                                        set the ball radius
SCREEN _NEWIMAGE(SCREENWIDTH + 1, SCREENHEIGHT + 1, 32) ' enter 640x480 graphics screen
_PRINTMODE _KEEPBACKGROUND '                              merge text and bouncing ball
DO '                                                      begin main loop
    _LIMIT 30 '                                           30 frames per second
    CLS '                                                 clear screen
    CIRCLE (BallX!, BallY!), BallRadius% '                draw ball (default white)
    PAINT (BallX!, BallY!) '                              paint ball (default white)

    '** if ball hits left or right side of screen reverse the X vector direction

    IF BallX! + BallXvector! > SCREENWIDTH - BallRadius% OR BallX! + BallXvector! < BallRadius% - 1 THEN
        BallXvector! = -BallXvector!
    END IF

    '** if ball hits top or bottom of screen reverse the Y vector direction

    IF BallY! + BallYvector! > SCREENHEIGHT - BallRadius% OR BallY! + BallYvector! < BallRadius% - 1 THEN
        BallYvector = -BallYvector!
    END IF

    BallX! = BallX! + BallXvector! '                      add the X vector to ball current X location
    BallY! = BallY! + BallYvector! '                      add the Y vector to ball current Y location
    LOCATE 2, 2 '                                         print information to the user
    PRINT "Ball X direction > "; USING ("##.##"); BallXvector!;
    IF SGN(BallXvector!) = 1 THEN
        PRINT " moving right "; CHR$(26)
    ELSE
        PRINT " moving left  "; CHR$(27)
    END IF
    LOCATE 3, 2
    PRINT "Ball Y direction > "; USING ("##.##"); BallYvector!;
    IF SGN(BallYvector!) = 1 THEN
        PRINT " moving down  "; CHR$(25)
    ELSE
        PRINT " moving up    "; CHR$(24)
    END IF
    LOCATE 4, 2
    PRINT "Ball X,Y location> "; INT(BallX!); INT(BallY!)
    _DISPLAY '                                            update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                 leave when ESC key pressed
SYSTEM '                                                  return to operating system




