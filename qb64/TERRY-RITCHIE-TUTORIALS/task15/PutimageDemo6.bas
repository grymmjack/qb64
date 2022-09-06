'** Putimage Demo 6 - Image flipping in all four directions

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

DIM Sky& '      handle to hold sky image
DIM Bee& '      handle to hold bee image
DIM Arrows& '   handle to hold arrows image
DIM BeeX% '     x center location of bee
DIM BeeY% '     y center location of bee
DIM Angle% '    angle in degrees from bee to center of screen

'----------------------------
'- Main Program Begins Here -
'----------------------------

Sky& = _LOADIMAGE(".\tutorial\task15\sky.png", 32) '       load sky image into RAM
Arrows& = _LOADIMAGE(".\tutorial\task15\arrows.png", 32) ' load arrows image into RAM
Bee& = _LOADIMAGE(".\tutorial\task15\tbee0.png", 32) '     load bee image into RAM
BeeX% = 319 '                                          set initial x coordinate of bee
BeeY% = 70 '                                           set initial y coordinate of bee
SCREEN _NEWIMAGE(640, 480, 32) '                       create graphics screen
DO '                                                   begin main loop
    CLS '                                              clear the screen
    _LIMIT 60 '                                        60 times per second
    _PUTIMAGE (0, 0), Sky& '                           place sky image on screen
    _PUTIMAGE (BeeX% - 67, BeeY% - 67)-(BeeX% + 68, BeeY% + 68), Bee& ' place bee
    Angle% = INT(GETANGLE#(319, 239, BeeX%, BeeY%)) '  get angle from center screen to bee
    LOCATE 1, 1 '                                      position cursor
    PRINT "Angle ="; Angle% '                          show user current angle
    LOCATE 2, 1 '                                      position cursor
    SELECT CASE Angle% '                               in which quadrant does angle fall?
        CASE 0 TO 90 '                                 quadrant 1
            _PUTIMAGE (252, 172)-(387, 307), Arrows& ' normal image placement
            PRINT "Normal image placement"
        CASE 91 TO 180 '                               quadrant 2
            _PUTIMAGE (252, 307)-(387, 172), Arrows& ' flip image vertically
            PRINT "Arrows image flipped vertically"
        CASE 181 TO 270 '                              quadrant 3
            _PUTIMAGE (387, 307)-(252, 172), Arrows& ' flip image horizontally and vertically
            PRINT "Arrows image flipped vertically and horizontally"
        CASE 271 TO 359 '                              quadrant 4
            _PUTIMAGE (387, 172)-(252, 307), Arrows& ' flip image horizontally
            PRINT "Arrows image flipped horizontally"
    END SELECT
    WHILE _MOUSEINPUT: WEND '                          get latest mouse update
    BeeX% = _MOUSEX '                                  save current mouse x location
    BeeY% = _MOUSEY '                                  save current mouse y location
    _DISPLAY '                                         update screen with changes
LOOP UNTIL _KEYDOWN(27) '                              loop until ESC pressed
_FREEIMAGE Sky& '                                      clean memory before leaving
_FREEIMAGE Bee&
_FREEIMAGE Arrows&
SYSTEM '                                               return to Windows

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

FUNCTION GETANGLE# (x1#, y1#, x2#, y2#)

    '*
    '* Returns the angle in degrees from 0 to 359.9999.... between 2 given coordinate pairs.
    '* Adapted from a function by Rob, aka Galleon, located in the QB64 Wiki
    '*

    IF y2# = y1# THEN '                                        both Y values same?
        IF x1# = x2# THEN '                                    yes, both X values same?
            EXIT FUNCTION '                                    yes, points are same, no angle
        END IF
        IF x2# > x1# THEN '                                    second X value greater?
            GETANGLE# = 90 '                                   yes, then must be 90 degrees
        ELSE '                                                 no, second X value is less
            GETANGLE# = 270 '                                  then must be 270 degrees
        END IF
        EXIT FUNCTION '                                        leave function
    END IF
    IF x2# = x1# THEN '                                        both X values same?
        IF y2# > y1# THEN '                                    second Y value greater?
            GETANGLE# = 180 '                                  yes, then must be 180 degrees
        END IF
        EXIT FUNCTION '                                        leave function
    END IF
    IF y2# < y1# THEN '                                        second Y value less?
        IF x2# > x1# THEN '                                    yes, second X value greater?
            GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 ' yes, compute angle
        ELSE '                                                 no, second X value less
            GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 360 ' compute angle
        END IF
    ELSE '                                                     no, second Y value greater
        GETANGLE# = ATN((x2# - x1#) / (y2# - y1#)) * -57.2957795131 + 180 ' compute angle
    END IF

END FUNCTION






























