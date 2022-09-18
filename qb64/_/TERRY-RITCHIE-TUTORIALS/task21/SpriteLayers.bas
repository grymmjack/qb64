'** Demo Sprite Layers
'** Bird sprites: https://www.spriters-resource.com/fullview/123364/
'** Sky image: https://en.wikipedia.org/wiki/Parallax_scrolling

CONST BIRDS = 100 '       number of birds on screen

TYPE BIRD '               bird definition
    x AS INTEGER '        X location of bird
    y AS INTEGER '        Y location of bird
    xdir AS INTEGER '     X direction of bird
    layer AS INTEGER '    layer bird is on
    image AS INTEGER '    current bird image
END TYPE

DIM Bird(BIRDS) AS BIRD ' bird array
DIM Sky& '                image of sky
DIM BirdSheet& '          bird sprite sheet
DIM BirdSprite&(19) '     20 individual bird sprites
DIM Count% '              generic counter
DIM x2%, y2% '            bird image lower right X,Y
DIM Layer% '              layer counter

RANDOMIZE TIMER '                                                           seed random number generator
Sky& = _LOADIMAGE("sky.png", 32) '                        load sky image
BirdSheet& = _LOADIMAGE("bird64x72.png", 32) '            load sprite sheet
FOR Count% = 0 TO 19 '                                                      cycle through sprite sheet images
    BirdSprite&(Count%) = _NEWIMAGE(64, 72, 32) '                           create sprite holder
    _PUTIMAGE , BirdSheet&, BirdSprite&(Count%), (Count% * 64, 0)-(Count% * 64 + 63, 71) ' get sprite from sheet
NEXT Count%
FOR Count% = 1 TO BIRDS '                                                   cycle through bird array
    Bird(Count%).layer = INT(RND(1) * 5) + 1 '                              place bird on random layer
    IF Bird(Count%).layer MOD 2 = 0 THEN '                                  bird on even layer?
        Bird(Count%).xdir = 1 '                                             yes, bird heading right
    ELSE '                                                                  no, on odd layer
        Bird(Count%).xdir = -1 '                                            bird heading left
    END IF
    Bird(Count%).x = INT(RND(1) * 640) '                                    random X location
    Bird(Count%).y = INT(RND(1) * 400) + 20 '                               random Y location
    Bird(Count%).image = INT(RND(1) * 20) '                                 start with random image
NEXT Count%
SCREEN _NEWIMAGE(640, 480, 32) '                                            enter graphics csreen
DO '                                                                        begin main loop
    _LIMIT 30 '                                                             30 frames per second
    _PUTIMAGE , Sky& '                                                      display first layer then bird
    FOR Layer% = 5 TO 1 STEP -1 '                                           cycle through layers
        FOR Count% = 1 TO BIRDS '                                           cycle through bird array
            IF Bird(Count%).layer = Layer% THEN '                           bird on current layer?
                Bird(Count%).image = Bird(Count%).image + 1 '               yes, increment bird image
                IF Bird(Count%).image = 20 THEN Bird(Count%).image = 0 '    keep image within limits
                Bird(Count%).x = Bird(Count%).x + Bird(Count%).xdir * (6 - Bird(Count%).layer) ' move bird
                IF Bird(Count%).x < -64 OR Bird(Count%).x > 640 THEN '      bird off screen?
                    Bird(Count%).xdir = -Bird(Count%).xdir '                yes, change X direction
                    Bird(Count%).layer = Bird(Count%).layer - 1 '           bring bird one layer forward
                    IF Bird(Count%).layer = 0 THEN Bird(Count%).layer = 5 ' keep layer within limits
                    Bird(Count%).y = INT(RND(1) * 400) + 20 '               new random Y location for bird
                END IF
                x2% = Bird(Count%).x + 64 / Bird(Count%).layer '            calculate image box lower right X
                y2% = Bird(Count%).y + 72 / Bird(Count%).layer '            calculate image box lower right Y
                IF SGN(Bird(Count%).xdir) = -1 THEN '                       bird heading left?
                    _PUTIMAGE (Bird(Count%).x, Bird(Count%).y)-(x2%, y2%), BirdSprite&(Bird(Count%).image) ' left
                ELSE '                                                      no, bird heading right
                    _PUTIMAGE (x2%, Bird(Count%).y)-(Bird(Count%).x, y2%), BirdSprite&(Bird(Count%).image) ' right
                END IF
            END IF
        NEXT Count%
    NEXT Layer%
    _DISPLAY '                                                              update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                                   leave loop if ESC pressed
_FREEIMAGE Sky& '                                                           remove images from memory
_FREEIMAGE BirdSheet&
FOR Count% = 0 TO 19
    _FREEIMAGE BirdSprite&(Count%)
NEXT Count%
SYSTEM '                                                                    return to operating system




















