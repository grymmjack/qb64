'** Demo Layers
'** Bird sprites: https://www.spriters-resource.com/fullview/123364/
'** Layer images: https://en.wikipedia.org/wiki/Parallax_scrolling

TYPE BIRD '             bird definition
    x AS INTEGER '      X location of bird
    y AS INTEGER '      Y location of bird
    image AS INTEGER '  current bird image
END TYPE

DIM Bird(3) AS BIRD '   bird array
DIM Sky& '              image of sky
DIM Ground& '           image of ground
DIM Pillars& '          image of pillars
DIM BirdSheet& '        bird sprite sheet
DIM BirdSprite&(19) '   20 individual bird sprites
DIM Count% '            generic counter

RANDOMIZE TIMER '                                               seed random number generator
Sky& = _LOADIMAGE("sky.png", 32) '            load sky image
Ground& = _LOADIMAGE("tground.png", 32) '     load ground image
Pillars& = _LOADIMAGE("tpillars.png", 32) '   load pillars image
BirdSheet& = _LOADIMAGE("bird64x72.png", 32) 'load sprite sheet
FOR Count% = 0 TO 19 '                                          cycle through sprite sheet images
    BirdSprite&(Count%) = _NEWIMAGE(64, 72, 32) '               create sprite holder
    _PUTIMAGE , BirdSheet&, BirdSprite&(Count%), (Count% * 64, 0)-(Count% * 64 + 63, 71) ' get sprite from sheet
NEXT Count%
FOR Count% = 1 TO 3 '                                           cycle through bird array
    Bird(Count%).x = 640 '                                      set bird X location
    Bird(Count%).y = 320 '                                      set bird Y location
    Bird(Count%).image = INT(RND(1) * 20) '                     start with random image
NEXT Count%
SCREEN _NEWIMAGE(640, 480, 32) '                                enter graphics csreen
DO '                                                            begin main loop
    _LIMIT 30 '                                                 30 frames per second
    CLS '                                                       clear screen
    _PUTIMAGE , Sky& '                                          display first layer then bird
    _PUTIMAGE (Bird(1).x, Bird(1).y)-(Bird(1).x + 31, Bird(1).y + 35), BirdSprite&(Bird(1).image) ' 1/2 size
    _PUTIMAGE , Pillars& '                                      display second layer then bird
    _PUTIMAGE (Bird(2).x, Bird(2).y)-(Bird(2).x + 47, Bird(2).y + 53), BirdSprite&(Bird(2).image) ' 3/4 size
    _PUTIMAGE , Ground& '                                       display third layer then bird
    _PUTIMAGE (Bird(3).x, Bird(3).y), BirdSprite&(Bird(3).image) '                                  full size
    FOR Count% = 1 TO 3 '                                       cycle through bird array
        Bird(Count%).x = Bird(Count%).x - Count% '              move bird to left
        IF Bird(Count%).x < -64 THEN Bird(Count%).x = 640 '     start at right side when left reached
        Bird(Count%).image = Bird(Count%).image + 1 '           go to next image
        IF Bird(Count%).image = 20 THEN Bird(Count%).image = 0 'go back to first image when last reached
    NEXT Count%
    _DISPLAY '                                                  update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                       leave loop if ESC pressed
_FREEIMAGE Sky& '                                               remove images from memory
_FREEIMAGE Ground&
_FREEIMAGE Pillars&
_FREEIMAGE BirdSheet&
FOR Count% = 0 TO 19
    _FREEIMAGE BirdSprite&(Count%)
NEXT Count%
SYSTEM '                                                        return to operating system

