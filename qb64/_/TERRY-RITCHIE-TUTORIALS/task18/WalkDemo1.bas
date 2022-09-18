'** Walker Demo 1
'** Load Individual Sprite Images

CONST BRIGHTMAGENTA = _RGB32(255, 0, 255) ' declare colors
CONST WHITE = _RGB32(255, 255, 255)

DIM Frame% '             frame counter
DIM Sprite% '            sprite image counter
DIM Walker&(6) '         sprite images
DIM x1%, y1%, x2%, y2% ' sprite upper left and lower right X,Y coordinates
DIM Dir% '               sprite travel direction
DIM Filename$ '          file name of each sprite image
DIM Path$ '              location of sprites on drive

'** Load each sprite image one at a time

Path$ = "" '                              path to sprites
FOR Sprite% = 1 TO 6 '                                      load 6 sprites
    Filename$ = "walk" + _TRIM$(STR$(Sprite%)) + ".png" '   filename of sprite
    Walker&(Sprite%) = _LOADIMAGE(Path$ + Filename$, 32) '  load sprite
    _CLEARCOLOR BRIGHTMAGENTA, Walker&(Sprite%) '           set transparent color of sprite
NEXT Sprite%

Frame% = 0 '                                                reset frame counter
Sprite% = 1 '                                               reset sprite image counter
Dir% = 1 '                                                  set sprite direction
x1% = 10 '                                                  upper left X coordinate of sprites
y1% = 50 '                                                  upper left Y coordinate of sprites
y2% = y1% + 155 '                                           lower right Y coordinate of sprites
SCREEN _NEWIMAGE(640, 480, 32) '                            enter graphics screen
DO '                                                        begin main loop
    _LIMIT 30 '                                             30 frames per second
    CLS , WHITE '                                           clear screen in white
    LOCATE 2, 21 '                                          locate text cursor
    PRINT " Right/Left arrows to walk, ESC to exit. " '     print directions
    IF _KEYDOWN(19712) THEN '                               right arrow key pressed?
        Dir% = 1 '                                          yes, set direction heading to right
    ELSEIF _KEYDOWN(19200) THEN '                           left arrow key pressed?
        Dir% = -1 '                                         yes, set direction heading to left
    END IF
    IF x1% + Dir% * 3 < 536 AND x1% + Dir% * 3 > 0 THEN '   sprite at edge of screen?
        x1% = x1% + 3 * Dir% '                              no, update X location of sprite
    ELSE '                                                  yes, at edge of screen
        Dir% = -Dir% '                                      change sprite direction
    END IF
    x2% = x1% + 103 '                                       calculate lower right hand X coordinate
    SELECT CASE Dir% '                                      which direction is prite heading?
        CASE 1 '                                            to the right
            _PUTIMAGE (x1%, y1%), Walker&(Sprite%) '        display sprite image normal
        CASE -1 '                                           to the left
            _PUTIMAGE (x2%, y1%)-(x1%, y2%), Walker&(Sprite%) ' flip sprite image horizontally
    END SELECT
    Frame% = Frame% + 1 '                                   increment frame counter
    IF Frame% = 30 THEN Frame% = 0 '                        reset frame counter after 30 frames
    IF Frame% MOD 5 = 0 THEN '                              frame even divisible by 5?
        Sprite% = Sprite% + 1 '                             yes, increment sprite image counter
        IF Sprite% = 7 THEN Sprite% = 1 '                   keep sprite image counter within limits
    END IF
    _DISPLAY '                                              update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                   leave when ESC key pressed
FOR Sprite% = 1 TO 6 '                                      cycle through the six sprite images
    _FREEIMAGE Walker&(Sprite%) '                           free image from memory
NEXT Sprite%
SYSTEM '                                                    return to operating system

