'*
'* Hocus Pocus V2.2 by Terry Ritchie 01/24/14
'*
'* Use the mouse to create magic. Press ESC to leave this magical place.
'*

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST FALSE = 0, TRUE = NOT FALSE

CONST SWIDTH = 640 '       screen width
CONST SHEIGHT = 480 '      screen height
CONST BLOOMAMOUNT = 5 '    number of blooms per mouse movement (don't go too high!)
CONST MAXSIZE = 64 '       maximum size of blooms (don't go too high!)
CONST MAXLIFE = 32 '       maximum life time on screen
CONST MAXXSPEED = 6 '      maximum horizontal speed at bloom creation
CONST MAXYSPEED = 10 '     maximum vertical speed at bloom creation
CONST BOUNCE = FALSE '     set to TRUE to have blooms bounce off bottom of screen

TYPE CADABRA '             image properties
    lifespan AS INTEGER '  life span of bloom on screen
    x AS SINGLE '          x location of bloom
    y AS SINGLE '          y location of bloom
    size AS INTEGER '      size of bloom
    xdir AS SINGLE '       horizontal direction of bloom
    ydir AS SINGLE '       vertical direction of bloom
    xspeed AS SINGLE '     horizontal speed of bloom
    yspeed AS SINGLE '     vertical speed of bloom
    image AS LONG '        bloom image handle
    freed AS INTEGER '     boolean indicating if image handle has been freed
END TYPE

REDIM Abra(1) AS CADABRA ' dynamic array to hold properties
DIM x% '                   current x position of mouse
DIM y% '                   current y position of mouse
DIM Oldx% '                previous x position of mouse
DIM Oldy% '                previous y position of mouse
DIM Blooms% '              bloom counter
DIM sa& '                  Sorcerer's Apprentice sound file

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(SWIDTH, SHEIGHT, 32) '      create 32 bit graphics screen
_SCREENMOVE _MIDDLE '                        move window to center of desktop
sa& = _SNDOPEN("apprentice.ogg") ' load sound file into RAM
_SNDLOOP sa& '                               play music in continuous loop
_MOUSEHIDE '                                 hide the mouse pointer
_MOUSEMOVE SWIDTH \ 2, SHEIGHT \ 2 '         move mouse pointer to middle of screen
WHILE _MOUSEINPUT: WEND '                    get latest mouse information
x% = _MOUSEX '                               get current mouse x position
y% = _MOUSEY '                               get current mouse y position
Oldx% = x% '                                 remember mouse x position
Oldy% = y% '                                 remember mouse y position
Abra(1).freed = TRUE '                       first index is free to use
RANDOMIZE TIMER '                            seed random number generator
DO '                                         begin main loop
    _LIMIT 30 '                              30 frames per second
    WHILE _MOUSEINPUT: WEND '                get latest mouse information
    x% = _MOUSEX '                           get current mouse x position
    y% = _MOUSEY '                           get current mouse y position
    IF (Oldx% <> x%) OR (Oldy% <> y%) THEN ' has mouse moved since last loop?
        FOR Blooms% = 1 TO BLOOMAMOUNT '     yes, create set number of blooms
            HOCUS x%, y% '                   create bloom at current mouse location
        NEXT Blooms%
        Oldx% = x% '                         remember mouse x position
        Oldy% = y% '                         remember mouse y position
    END IF
    CLS '                                    clear screen
    POCUS '                                  draw active blooms
    _DISPLAY '                               update screen with changes
LOOP UNTIL _KEYDOWN(27) '                    leave when ESC pressed
SYSTEM '                                     return to Windows

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

'----------------------------------------------------------------------------------------------------------------------

SUB HOCUS (hx%, hy%)

    '*
    '* Maintains the bloom array by creating bloom properties for a new bloom.
    '* If no array indexes are free a new one is added to the end of the array to
    '* hold the new bloom. If an unused index is available the new bloom will occupy
    '* that free index position. If no blooms are currently active the array is
    '* erased and reset to an index of 1 to be built again.
    '*
    '* hx% - x location of new bloom
    '* hy% - y location of new bloom
    '*

    SHARED Abra() AS CADABRA ' need access to bloom array

    DIM CleanUp% '             if true array will be reset
    DIM Count% '               generic counter
    DIM Index% '               array index to create new bloom in
    DIM OriginalDest& '        destination screen/image of calling routine
    DIM Red% '                 red color component of bloom
    DIM Green% '               green color component of bloom
    DIM Blue% '                blue color component of bloom
    DIM RedStep% '             red fade amount
    DIM GreenStep% '           green fade amount
    DIM BlueStep% '            blue fade amount
    DIM Alpha% '               alpha channel fade amount

    CleanUp% = TRUE '                                           assume array will need reset
    Index% = 0 '                                                reset available index marker
    Count% = 1 '                                                start array index counter at 1
    DO WHILE Count% <= UBOUND(Abra) '                           cycle through entire array
        IF Abra(Count%).lifespan = 0 THEN '                     has this image run its course?
            IF NOT Abra(Count%).freed THEN '                    yes, has the image been freed from RAM?
                _FREEIMAGE Abra(Count%).image '                 no, remove the image from RAM
                Abra(Count%).freed = TRUE '                     remember that it has been removed
            END IF
            IF Index% = 0 THEN '                                has an available array index been chosen?
                Index% = Count% '                               no, mark this array index as available
            END IF
        ELSE '                                                  no, this image is still active
            CleanUp% = FALSE '                                  do not clear the array
        END IF
        Count% = Count% + 1 '                                   increment array index counter
    LOOP
    IF CleanUp% THEN '                                          have all images run their course?
        REDIM Abra(1) AS CADABRA '                              yes, reset the array
        Abra(1).freed = TRUE '                                  there is no image here yet
        Index% = 1 '                                            mark first index as available
    ELSE '                                                      no, there are still active images
        IF Index% = 0 THEN '                                    were all the images in the array active?
            REDIM _PRESERVE Abra(UBOUND(abra) + 1) AS CADABRA ' yes, increase the array size by 1
            Index% = UBOUND(abra) '                             mark top index as available
        END IF
    END IF
    Abra(Index%).lifespan = INT(RND(1) * MAXLIFE) + 16 '        random length of time to live (frames)
    Abra(Index%).x = hx% '                                      bloom x location
    Abra(Index%).y = hy% '                                      bloom y location
    Abra(Index%).size = INT(RND(1) * (MAXSIZE * .75) + (MAXSIZE * .25)) ' random size of bloom
    Abra(Index%).xdir = (RND(1) - RND(1)) * 3 '                 random horizontal direction of bloom
    Abra(Index%).ydir = -1 '                                    vertical direction of bloom (up)
    Abra(Index%).xspeed = INT(RND(1) * MAXXSPEED) '             random horizontal speed of bloom
    Abra(Index%).yspeed = INT(RND(1) * MAXYSPEED) '             random vertical speed of bloom
    Abra(Index%).image = _NEWIMAGE(Abra(Index%).size * 2, Abra(Index%).size * 2, 32) ' create image holder
    Red% = INT(RND(1) * 255) + 1 '                              random red component value
    Green% = INT(RND(1) * 255) + 1 '                            random green compoenent value
    Blue% = INT(RND(1) * 255) + 1 '                             random blue component value
    RedStep% = (255 - Red%) \ Abra(Index%).size '               random fade of red component
    GreenStep% = (255 - Green%) \ Abra(Index%).size '           random fade of green component
    BlueStep% = (255 - Blue%) \ Abra(Index%).size '             random fade of blue component
    AlphaStep! = 255 \ Abra(Index%).size '                      compute fade of alpha channel
    Alpha% = 0 '                                                start alpha channel completely transparent
    OriginalDest& = _DEST '                                     save calling routine's destination screen/image
    _DEST Abra(Index%).image '                                  set destination to bloom image
    Count% = Abra(Index%).size '                                start from outside of bloom working in
    DO WHILE Count% > 0 '                                       start bloom drawing loop
        '*
        '* Draw circle with current red, green, blue components
        '*
        CIRCLE (_WIDTH(Abra(Index%).image) / 2, _HEIGHT(Abra(Index%).image) / 2),_
                Count%, _RGB32(Red%, Green%, Blue%)
        '*
        '* Paint circle with current red, green, blue components
        '*
        PAINT (_WIDTH(Abra(Index%).image) / 2, _HEIGHT(Abra(Index%).image) / 2),_
               _RGB32(Red%, Green%, Blue%), _RGB32(Red%, Green%, Blue%)
        _SETALPHA Alpha%, _RGB32(Red%, Green%, Blue%) '         set transparency level of current color
        Red% = Red% + RedStep% '                                increase red component
        Green% = Green% + GreenStep% '                          increase green component
        Blue% = Blue% + BlueStep% '                             increase blue component
        Alpha% = Alpha% + AlphaStep! '                          increase opacity level of alpha channel
        Count% = Count% - 1 '                                   decrease size of circle
    LOOP '                                                      leave loop when smallest circle drawn
    _DEST OriginalDest& '                                       return original destination to calling routine

END SUB

'----------------------------------------------------------------------------------------------------------------------

SUB POCUS ()

    '*
    '* places active blooms onto the screen or current image and updates their
    '* position, size and speed
    '*

    SHARED Abra() AS CADABRA ' need access to bloom array

    DIM c% '                   array index counter
    DIM o% '                   bloom image size x,y offset

    c% = UBOUND(Abra) '                                                 start at top of array
    DO WHILE c% > 0 '                                                   loop until beginning of array
        IF Abra(c%).lifespan > 0 THEN '                                 is this bloom active?
            o% = INT(Abra(c%).size) '                                   yes, get current size of bloom image
            _PUTIMAGE (Abra(c%).x - o%, Abra(c%).y - o%)-(Abra(c%).x + o%, Abra(c%).y + o%), Abra(c%).image
            Abra(c%).lifespan = Abra(c%).lifespan - 1 '                 decrement lifespan of bloom
            Abra(c%).size = Abra(c%).size * .95 '                       decrease size of bloom slightly
            Abra(c%).x = Abra(c%).x + Abra(c%).xdir * Abra(c%).xspeed ' update x position of bloom
            Abra(c%).y = Abra(c%).y + Abra(c%).ydir * Abra(c%).yspeed ' update y position of bloom
            IF Abra(c%).y > SHEIGHT - 1 THEN '                          has bloom left bottom of screen?
                IF BOUNCE THEN '                                        should bloom bounce?
                    Abra(c%).yspeed = -Abra(c%).yspeed '                yes, reverse y velocity
                ELSE '                                                  no
                    Abra(c%).lifespan = 0 '                             kill it, no longer needed
                END IF
            END IF
            Abra(c%).xspeed = Abra(c%).xspeed * .9 '                    decrease x velocity slightly
            Abra(c%).yspeed = Abra(c%).yspeed - .5 '                    decrease y velocity (simulating gravity)
        END IF
        c% = c% - 1 '                                                   decrement to next index in array
    LOOP

END SUB

