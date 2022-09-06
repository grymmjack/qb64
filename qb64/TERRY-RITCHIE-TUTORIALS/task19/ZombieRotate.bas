'** Demo Zombie Animation With Rotation
'** Overhead zombie sprites provided by Riley Gombart at:
'** https://opengameart.org/content/animated-top-down-zombie
'** Sounds downloaded from The Sounds Resource at:
'** https://www.sounds-resource.com/pc_computer/plantsvszombies/sound/1430

CONST TRANSPARENT = _RGB32(255, 0, 255) ' transparent color

DIM ZombieSheet& '     zombie sprite sheet
DIM Zombie&(15) '      zombie sprites parsed from sheet
DIM Brains& '          brain image
DIM Groan&(6) '        zombie groaning sounds
DIM zx!, zy! '         zombie X,Y location
DIM zxvector! '        zombie X vector
DIM zyvector! '        zombie Y vector
DIM bx!, by! '         brains X,Y location
DIM RotatedZombie& '   rotated zombie sprite
DIM Sprite% '          sprite counter
DIM Angle2Brains! '    angle from zombie to brains
DIM Frame% '           frame counter

'** Load sprite sheet and parse out individual sprites

ZombieSheet& = _LOADIMAGE("zombie311x288.png", 32)
_CLEARCOLOR TRANSPARENT, ZombieSheet&
FOR Sprite% = 0 TO 15
    Zombie&(Sprite%) = _NEWIMAGE(311, 288, 32)
    _PUTIMAGE , ZombieSheet&, Zombie&(Sprite%), (Sprite% * 311, 0)-(Sprite% * 311 + 310, 287)

    '** load the zombie groan sounds

    IF Sprite% < 6 THEN
        Groan&(Sprite% + 1) = _SNDOPEN("groan" + _TRIM$(STR$(Sprite% + 1)) + ".ogg")
    END IF
NEXT Sprite%
_FREEIMAGE ZombieSheet& '                                  sprite sheet no longer needed
Brains& = _LOADIMAGE("brains.png", 32) ' load brain image
_CLEARCOLOR TRANSPARENT, Brains& '                         set brain image transparent color
SCREEN _NEWIMAGE(800, 600, 32) '                           enter graphics screen
RANDOMIZE TIMER '                                          seed random number generator
_MOUSEHIDE '                                               hide mouse pointer
Sprite% = 0 '                                              reset srpite counter
zx! = 399 '                                                center zombie X,Y location
zy! = 299
Frame% = 0 '                                               reset frame counter
DO '                                                       begin main loop
    _LIMIT 30 '                                            30 frames per second
    CLS '                                                  clear screen
    WHILE _MOUSEINPUT: WEND '                              get latest mouse information
    bx! = _MOUSEX '                                        record mouse X,Y location
    by! = _MOUSEY
    Angle2Brains! = P2PAngle(zx!, zy!, bx!, by!) '         get angle from zombie to brains
    Angle2Vector Angle2Brains!, zxvector!, zyvector! '     convert angle to vectors
    Frame% = Frame% + 1 '                                  increment frame counter
    IF Frame% = 90 THEN '                                  90 frames gone by? (3 seconds)
        Frame% = 0 '                                       yes, reset frame counter
        _SNDPLAY Groan&(INT(RND(1) * 6) + 1) '             play random zombie groan
    END IF
    IF Frame% MOD 5 = 0 THEN '                             frame evenly divisible by 5? (6 FPS)
        Sprite% = Sprite% + 1 '                            yes, increment to next sprite in animation
        IF Sprite% = 16 THEN Sprite% = 0 '                 keep sprite number within limit
        RotateImage Angle2Brains!, Zombie&(Sprite%), RotatedZombie& ' rotate zombie sprite at same angle
    END IF
    zx! = zx! + zxvector! '                                update zombie X,Y location
    zy! = zy! + zyvector!

    '** draw zombie and brain centered on their respective X,Y locations

    _PUTIMAGE (zx! - _WIDTH(RotatedZombie&) \ 2, zy! - _HEIGHT(RotatedZombie&) \ 2), RotatedZombie&
    _PUTIMAGE (bx! - _WIDTH(Brains&) \ 2, by! - _HEIGHT(Brains&) \ 2), Brains&

    _DISPLAY '                                             update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                  leave when ESC key pressed

'** perform memory cleanup

FOR Sprite% = 0 TO 15 '                                    cycle through zombie images
    _FREEIMAGE Zombie&(Sprite%) '                          remove image from memory
    IF Sprite% < 6 THEN _SNDCLOSE Groan&(Sprite% + 1) '    remove sound from memory
NEXT Sprite%
_FREEIMAGE RotatedZombie& '                                remove image from memory
_FREEIMAGE Brains& '                                       remove image from memory
SYSTEM '                                                   return to operating system

'------------------------------------------------------------------------------------------------------------
SUB RotateImage (Angle!, InImage&, OutImage&) ' image rotation
    '--------------------------------------------------------------------------------------------------------
    '- Rotates an image from 0 to 359.99.. degrees       -
    '-                                                   -
    '- Angle!    - the angle of rotation (0 to 359.99..) -
    '- InImage&  - the image to be rotated               -
    '- OutImage& - the new rotated image sent back       -
    '-----------------------------------------------------

    ' -------------------------------------------------------------------------------
    ' | The original cell width and height        px(0),py(0)           px(3),py(3) |
    ' | are used to calculate the four         ....... +---------------------+      |
    ' | corners of the image. These four          ^    |~\_     _MAPTRIANGLE |      |
    ' | corners are then rotated through 360      |    |   ~\_       #2      |      |
    ' | degrees to the new corner locations      cell  |      ~\_            |      |
    ' | for _MAPTRIANGLE, and also to           height |         ~\_         |      |
    ' | calculate the new width and height        |    |            ~\_      |      |
    ' | of the rotated image.                     |    | _MAPTRIANGLE  ~\_   |      |
    ' |                                           V    |      #1          ~\_|      |
    ' |                                        ....... +---------------------+      |
    ' |                                           px(1),py(1)           px(2),py(2) |
    ' |                                                :                     :      |
    ' |                                                :<--- cell width ---->:      |
    ' |                                                :                     :      |
    ' |                                                                             |
    ' -------------------------------------------------------------------------------

    DIM Polar AS INTEGER '     counter used for calculating _MAPTRIANGLE x,y coordinate pairs
    DIM px(3) AS INTEGER '     _MAPTRIANGLE X coordinate
    DIM py(3) AS INTEGER '     _MAPTRIANGLE Y coordinate
    DIM Xoffset AS INTEGER '   X offset to center rotated image
    DIM Yoffset AS INTEGER '   Y offset to center rotated image
    DIM SINr AS SINGLE '       SIN of image corner rotation
    DIM COSr AS SINGLE '       COSIN of image corner rotation
    DIM Left AS INTEGER '      new left X coordinate of rotated image
    DIM Top AS INTEGER '       new top Y coordinate of rotated image
    DIM Right AS INTEGER '     new right X coordinate of rotated image
    DIM Bottom AS INTEGER '    new bottom Y coordinate of rotated image
    DIM x AS SINGLE '          rotated X location of image corner
    DIM y AS SINGLE '          rotated Y location of image corner
    DIM RotWidth AS INTEGER '  width of rotated image
    DIM RotHeight AS INTEGER ' height of rotated image

    IF OutImage& THEN _FREEIMAGE OutImage& '            free existing rotated image if present

    px(0) = -_WIDTH(InImage&) / 2 '                     get triangular image corner coordinates
    py(0) = -_HEIGHT(InImage&) / 2
    px(1) = px(0)
    py(1) = _HEIGHT(InImage&) / 2
    px(2) = _WIDTH(InImage&) / 2
    py(2) = py(1)
    px(3) = px(2)
    py(3) = py(0)
    SINr = SIN(-Angle! / 57.2957795131) '               calculate SINE of rotation
    COSr = COS(-Angle! / 57.2957795131) '               calculate COSINE of rotation
    Left = 0 '                                          reset rotated image boundaries
    Top = 0
    Right = 0
    Bottom = 0
    Polar = 0 '                                         reset polar coordinate counter
    DO '                                                loop through the 4 polar coordinates
        x = (px(Polar) * COSr + SINr * py(Polar)) '     calculate rotated image X corner
        y = (py(Polar) * COSr - px(Polar) * SINr) '     calculate rotated image Y corner
        px(Polar) = x '                                 record new corner X location
        py(Polar) = y '                                 record new corner Y location
        IF px(Polar) < Left THEN Left = px(Polar) '     get smallest left X value seen so far
        IF px(Polar) > Right THEN Right = px(Polar) '   get greatest right X value seen so far
        IF py(Polar) < Top THEN Top = py(Polar) '       get smallest top Y value seen so far
        IF py(Polar) > Bottom THEN Bottom = py(Polar) ' get greatest bottom Y value seen so far
        Polar = Polar + 1 '                             increment to next polar coordinate pair
    LOOP UNTIL Polar = 4 '                              leave when all 4 corners processed
    RotWidth = Right - Left + 1 '                       calculate the width of the rotated image
    RotHeight = Bottom - Top + 1 '                      calculate the height of the rotated image
    Xoffset = RotWidth \ 2 '                            calculate X offset to center image
    Yoffset = RotHeight \ 2 '                           calculate Y offset to center image
    px(0) = px(0) + Xoffset '                           center all 4 coordinate pairs
    px(1) = px(1) + Xoffset
    px(2) = px(2) + Xoffset
    px(3) = px(3) + Xoffset
    py(0) = py(0) + Yoffset
    py(1) = py(1) + Yoffset
    py(2) = py(2) + Yoffset
    py(3) = py(3) + Yoffset
    OutImage& = _NEWIMAGE(RotWidth, RotHeight, 32) '    created rotated image holder

    ' -----------------------------------------------------------------------
    ' | Map the two triangles to their new locations                        |
    ' |---------------------------------------------------------------------|
    ' | The new px() and py() pairs     px(0),py(0)           px(3),py(3)   |
    ' | are used by _MAPTRIANGLE to          +---------------------+        |
    ' | lay the two triangles down       ,>  |~\_     _MAPTRIANGLE |  >,    |
    ' | at the new coordinates.         /    |   ~\_       #2      |    \   |
    ' | Basically the four corners     |     |      ~\_            |     |  |
    ' | were rotated about a center   |      |         ~\_         |      | |
    ' | axis.                          |     |            ~\_      |     |  |
    ' |                                 \    | _MAPTRIANGLE  ~\_   |    /   |
    ' |                                  `<  |      #1          ~\_|  <'    |
    ' |                                      +---------------------+        |
    ' |                                 px(1),py(1)           px(2),py(2)   |
    ' -----------------------------------------------------------------------

    _MAPTRIANGLE (0, 0)-(0, _HEIGHT(InImage&) - 1)-(_WIDTH(InImage&) - 1, _HEIGHT(InImage&) - 1), InImage& TO _
                 (px(0), py(0))-(px(1), py(1))-(px(2), py(2)), OutImage&
    _MAPTRIANGLE (0, 0)-(_WIDTH(InImage&) - 1, 0)-(_WIDTH(InImage&) - 1, _HEIGHT(InImage&) - 1), InImage& TO _
                 (px(0), py(0))-(px(3), py(3))-(px(2), py(2)), OutImage&

END SUB

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

    xv! = SIN(Angle! * .01745329) '  calculate x vector value
    yv! = -COS(Angle! * .01745329) ' calculate y vector value

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
    ' |      0�         y2-y1                                                           |
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
    ' |      +----------------------------- 90�   multiply the radians by 180 and then  |
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






























