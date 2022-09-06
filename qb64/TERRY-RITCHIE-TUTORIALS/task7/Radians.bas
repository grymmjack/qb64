'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST PI = 3.1415926
CONST RED = _RGB32(255, 0, 0)
CONST YELLOW = _RGB32(255, 255, 0)
DIM StartRadian! ' starting point of circle arc
DIM StopRadian! '  ending point of circle arc
DIM Aspect! '      aspect ratio of circle (ellipses)
DIM Sign% '        holds the sign (-1 or +1) of arc radians

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                 initiate a graphics screen
StartRadian! = 2 * PI '                          set initial arc starting point
StopRadian! = 0 '                                set initial arc ending point
Aspect! = 1 '                                    set initial aspect ratio of circle
Sign% = 1 '                                      set radian sign

DO '                                             main loop begins here
    CLS '                                        clear the screen
    StopRadian! = StopRadian! + 2 * PI / 360 '   increment stop radian in 360ths
    IF StopRadian! > 2 * PI THEN '               has arc done a full sweep?
        StopRadian! = 0 '                        yes, reset the arc end point
    END IF
    LINE (319, 119)-(319, 359), RED '            draw vertical red line
    LINE (199, 239)-(439, 239), RED '            draw horizontal red line
    CIRCLE (319, 239), 100, YELLOW, Sign% * StartRadian!, Sign% * StopRadian!, Aspect! ' draw yellow arc
    LOCATE 2, 18 '                               display instructions
    PRINT "CIRCLE radian demonstration for creating arcs"
    LOCATE 4, 30
    IF Sign% = 1 THEN
        PRINT "Stop radian ="; StopRadian!
    ELSE
        PRINT "Stop radian ="; -StopRadian!
    END IF
    LOCATE 5, 29
    PRINT "Aspect ratio ="; Aspect!
    LOCATE 7, 32
    PRINT "Half PI 1.5707963"
    LOCATE 24, 32
    PRINT "1.5x PI 4.7123889"
    LOCATE 15, 57
    PRINT "0 or 2x PI 6.2831852"
    LOCATE 15, 13
    PRINT "PI 3.1415926"
    LOCATE 27, 3
    PRINT "Press SPACEBAR to change arc type, hold UP/DOWN arrow keys to change ellipse"
    LOCATE 29, 26
    PRINT "Press ESC key to exit program";
    IF _KEYHIT = 32 THEN '                       did user press space bar?
        Sign% = -Sign% '                         yes, change the sign
    END IF
    IF _KEYDOWN(18432) THEN '                    is user holding UP arrow?
        Aspect! = Aspect! + .005 '               yes, increment aspect ratio
        IF Aspect! > 3 THEN '                    is aspect ratio greater than 3?
            Aspect! = 3 '                        yes, limit its value to 3
        END IF
    END IF
    IF _KEYDOWN(20480) THEN '                    is user holding DOWN arrow?
        Aspect! = Aspect! - .005 '               yes, decrement aspect ratio
        IF Aspect! < .25 THEN '                  is aspect ratio less than .25?
            Aspect! = .25 '                      yes, limit its value to .25
        END IF
    END IF
    _LIMIT 60 '                                  limit loop to 60 FPS
    _DISPLAY '                                   update screen with changes
LOOP UNTIL _KEYDOWN(27) '                        leave loop when ESC key pressed
SYSTEM '                                         return to Windows

