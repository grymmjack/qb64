'** Pixel Perfect Collision Demo #5

TYPE SPRITE '             sprite definition
    image AS LONG '       sprite image
    mask AS LONG '        sprite mask image
    x1 AS INTEGER '       upper left X
    y1 AS INTEGER '       upper left Y
    x2 AS INTEGER '       lower right X
    y2 AS INTEGER '       lower right Y
END TYPE

DIM RedOval AS SPRITE '   red oval images
DIM GreenOval AS SPRITE ' green oval images

RedOval.image = _LOADIMAGE("redoval.png", 32) '     load red oval image image
GreenOval.image = _LOADIMAGE("greenoval.png", 32) ' load green oval image
MakeMask RedOval '                                                    create mask for red oval image
MakeMask GreenOval '                                                  create mask for green oval image
SCREEN _NEWIMAGE(640, 480, 32) '                                      enter graphics screen
_MOUSEHIDE '                                                          hide the mouse pointer
GreenOval.x1 = 294 '                                                  green oval upper left X
GreenOval.y1 = 165 '                                                  green oval upper left Y
DO '                                                                  begin main program loop
    _LIMIT 30 '                                                       30 frames per second
    CLS '                                                             clear screen
    WHILE _MOUSEINPUT: WEND '                                         get latest mouse information
    _PUTIMAGE (GreenOval.x1, GreenOval.y1), GreenOval.image '         display green oval
    _PUTIMAGE (RedOval.x1, RedOval.y1), RedOval.image '               display red oval
    RedOval.x1 = _MOUSEX '                                            record mouse X location
    RedOval.y1 = _MOUSEY '                                            record mouse Y location
    IF PixelCollide(GreenOval, RedOval) THEN '                        pixel collision?
        LOCATE 2, 36 '                                                yes, position text cursor
        PRINT "COLLISION!" '                                          report collision happening
    END IF
    _DISPLAY '                                                        update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                             leave when ESC key pressed
SYSTEM '                                                              return to operating system

'------------------------------------------------------------------------------------------------------------
SUB MakeMask (Obj AS SPRITE)
    '--------------------------------------------------------------------------------------------------------
    '- Creates a negative mask of image for pixel collision detection. -
    '-                                                                 -
    '- Obj - object containing an image and mask image holder          -
    '-------------------------------------------------------------------

    DIM x%, y% '   image column and row counters
    DIM cc~& '     clear transparent color
    DIM Osource& ' original source image
    DIM Odest& '   original destination image

    Obj.mask = _NEWIMAGE(_WIDTH(Obj.image), _HEIGHT(Obj.image), 32) ' create mask image
    Osource& = _SOURCE '                               save source image
    Odest& = _DEST '                                   save destination image
    _SOURCE Obj.image '                                make object image the source
    _DEST Obj.mask '                                   make object mask image the destination
    cc~& = _RGB32(255, 0, 255) '                       set the color to be used as transparent
    FOR y% = 0 TO _HEIGHT(Obj.image) - 1 '             cycle through image rows
        FOR x% = 0 TO _WIDTH(Obj.image) - 1 '          cycle through image columns
            IF POINT(x%, y%) = cc~& THEN '             is image pixel the transparent color?
                PSET (x%, y%), _RGB32(0, 0, 0, 255) '  yes, set corresponding mask image to solid black
            ELSE '                                     no, pixel is part of actual image
                PSET (x%, y%), cc~& '                  set corresponding mask image to transparent color
            END IF
        NEXT x%
    NEXT y%
    _DEST Odest& '                                     restore original destination image
    _SOURCE Osource& '                                 restore original source image
    _SETALPHA 0, cc~&, Obj.image '                     set image transparent color
    _SETALPHA 0, cc~&, Obj.mask '                      set mask transparent color

END SUB

'------------------------------------------------------------------------------------------------------------
FUNCTION PixelCollide (Obj1 AS SPRITE, Obj2 AS SPRITE)
    '--------------------------------------------------------------------------------------------------------
    '- Checks for pixel perfect collision between two rectangular areas. -
    '- Returns -1 if in collision                                        -
    '- Returns  0 if no collision                                        -
    '-                                                                   -
    '- obj1 - rectangle 1 coordinates                                    -
    '- obj2 - rectangle 2 coordinates                                    -
    '---------------------------------------------------------------------

    DIM x1%, y1% ' upper left x,y coordinate of rectangular collision area
    DIM x2%, y2% ' lower right x,y coordinate of rectangular collision area
    DIM Test& '    overlap image to test for collision
    DIM Hit% '     -1 (TRUE) if a collision occurs, 0 (FALSE) otherwise
    DIM Osource& ' original source image handle
    DIM p~& '      pixel color being tested in overlap image

    Obj1.x2 = Obj1.x1 + _WIDTH(Obj1.image) - 1 '  calculate lower right x,y coordinates
    Obj1.y2 = Obj1.y1 + _HEIGHT(Obj1.image) - 1 ' of both objects
    Obj2.x2 = Obj2.x1 + _WIDTH(Obj2.image) - 1
    Obj2.y2 = Obj2.y1 + _HEIGHT(Obj2.image) - 1
    Hit% = 0 '                                    assume no collision

    '** perform rectangular collision check

    IF Obj1.x2 >= Obj2.x1 THEN '                  rect 1 lower right X >= rect 2 upper left  X ?
        IF Obj1.x1 <= Obj2.x2 THEN '              rect 1 upper left  X <= rect 2 lower right X ?
            IF Obj1.y2 >= Obj2.y1 THEN '          rect 1 lower right Y >= rect 2 upper left  Y ?
                IF Obj1.y1 <= Obj2.y2 THEN '      rect 1 upper left  Y <= rect 2 lower right Y ?

                    '** rectangular collision detected, perform pixel perfect collision check

                    IF Obj2.x1 <= Obj1.x1 THEN x1% = Obj1.x1 ELSE x1% = Obj2.x1 ' calculate overlapping
                    IF Obj2.y1 <= Obj1.y1 THEN y1% = Obj1.y1 ELSE y1% = Obj2.y1 ' square coordinates
                    IF Obj2.x2 <= Obj1.x2 THEN x2% = Obj2.x2 ELSE x2% = Obj1.x2
                    IF Obj2.y2 <= Obj1.y2 THEN y2% = Obj2.y2 ELSE y2% = Obj1.y2
                    Test& = _NEWIMAGE(x2% - x1% + 1, y2% - y1% + 1, 32) '               make overlap image
                    _PUTIMAGE (-(x1% - Obj1.x1), -(y1% - Obj1.y1)), Obj1.image, Test& ' place image 1
                    _PUTIMAGE (-(x1% - Obj2.x1), -(y1% - Obj2.y1)), Obj2.mask, Test& '  place image mask 2

                    '** enable the line below to see a visual represenation of mask on image
                    '_PUTIMAGE (x1%, y1%), Test&

                    y1% = 0 '                                    reset row counter
                    Osource& = _SOURCE '                         record current source image
                    _SOURCE Test& '                              make test image the source
                    DO '                                         begin row (y) loop
                        x1% = 0 '                                reset column counter
                        DO '                                     begin column (x) loop
                            p~& = POINT(x1%, y1%) '              get color at current coordinate

                            '** if color from object 1 then a collision has occurred

                            IF p~& <> _RGB32(0, 0, 0, 255) AND p~& <> _RGB32(0, 0, 0, 0) THEN Hit% = -1
                            x1% = x1% + 1 '                      increment to next column
                        LOOP UNTIL x1% = _WIDTH(Test&) OR Hit% ' leave when column checked or collision
                        y1% = y1% + 1 '                          increment to next row
                    LOOP UNTIL y1% = _HEIGHT(Test&) OR Hit% '    leave when all rows checked or collision
                    _SOURCE Osource& '                           restore original destination
                    _FREEIMAGE Test& '                           test image no longer needed (free RAM)
                END IF
            END IF
        END IF
    END IF
    PixelCollide = Hit% '                                        return result of collision check

END FUNCTION















