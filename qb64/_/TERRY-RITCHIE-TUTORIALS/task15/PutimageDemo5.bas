'** Putimage Demo 5 - flipping the bee

DIM Sky& '      handle to hold sky image
DIM Bee&(1) '   handle array to hold 2 bee images (0 and 1)
DIM BeeDir% '   direction of bee
DIM BeeX% '     x center location of bee
DIM BeeY% '     y center location of bee
DIM BeeSize! '  size of bee 0 to 2 (0% to 200%)
DIM SizeDir! '  direction size is going in (increasing or decreasing)
DIM WhichBee% ' indicates which bee image to show (array index)
DIM Buzz& '     buzzing sound

Sky& = _LOADIMAGE("sky.png", 32) '      load sky image into memory
Bee&(0) = _LOADIMAGE("tbee0.png", 32) ' load first bee image into memory
Bee&(1) = _LOADIMAGE("tbee1.png", 32) ' load second bee image into memory
Buzz& = _SNDOPEN("bee.ogg") '           load buzzing sound into memory
BeeX% = 319 '                                             set initial x coordinate of bee
BeeY% = 171 '                                             set initial y coordinate of bee
BeeDir% = -1 '                                            set initial direction of bee (up)
WhichBee% = 1 '                                           set initial bee image to show
BeeSize! = 1 '                                            set initial size of bee (100%)
SizeDir! = .01 '                                          set initial size direction (getting larger)
SCREEN _NEWIMAGE(640, 480, 32) '                          create graphics screen
_SNDLOOP Buzz& '                                          loop the buzzing sound
DO '                                                      begin main loop
    _LIMIT 60 '                                           60 times per second
    _PUTIMAGE (0, 0), Sky& '                              place sky image on screen (no CLS needed)
    WhichBee% = 1 - WhichBee% '                           bee image index (toggle between 0 and 1)
    BeeSize! = BeeSize! + SizeDir! '                      increase bee size percentage
    IF BeeSize! > 2 OR BeeSize! < .25 THEN '              bee too big or small?
        SizeDir! = -SizeDir! '                            yes, reverse size direction
    END IF
    Adder% = 135 * BeeSize! \ 2 '                         half size of bee image times percentage
    IF SGN(BeeDir%) = -1 THEN '                           is bee heading up screen?
        '** draw from top left to lower right
        _PUTIMAGE (BeeX% - Adder%, BeeY% - Adder%)-(BeeX% + Adder%, BeeY% + Adder%), Bee&(WhichBee%)
    ELSE '                                                no, bee is heading down screen
        '** draw from lower right to top left
        _PUTIMAGE (BeeX% + Adder%, BeeY% + Adder%)-(BeeX% - Adder%, BeeY% - Adder%), Bee&(WhichBee%)
    END IF
    BeeY% = BeeY% + BeeDir% '                             increment bee y location
    IF BeeY% = 0 OR BeeY% = 479 THEN '                    has y hit top or bottom of screen?
        BeeDir% = -BeeDir% '                              yes, reverse direction of bee
    END IF
    _DISPLAY '                                            update screen with changes
LOOP UNTIL _KEYDOWN(27) '                                 loop until ESC pressed
_FREEIMAGE Sky& '                                         clean memory before leaving
_FREEIMAGE Bee&(0)
_FREEIMAGE Bee&(1)
_SNDCLOSE Buzz&
SYSTEM '                                                  return to operating system












