'** Particle Effects Demo - Roman Candles

TYPE CANDLE '              roman candle projectile definition
    x AS SINGLE '          X coordinate of projectile
    y AS SINGLE '          Y coordinate of projectile
    xdir AS SINGLE '       X vector of projectile
    ydir AS SINGLE '       Y vector of projectile
    life AS INTEGER '      lifespan of projectile
    fade AS SINGLE '       size reduction with each frame
    image AS LONG '        projectile image
    size AS SINGLE '       current size of projectile
    speed AS INTEGER '     X,Y vector speed of projectile
END TYPE

TYPE COLORS '              projectile color definition
    red AS INTEGER '       red component
    green AS INTEGER '     green component
    blue AS INTEGER '      blue component
    alpha AS INTEGER '     transparency component
END TYPE

DIM Projectile&(7) '       projectile images
REDIM Roman(0) AS CANDLE ' roman candles
DIM KeyWait% '             time to wait in between key strokes
DIM Candle% '              roman candle counter

MakeProjectiles '                               create the projectile images
RANDOMIZE TIMER '                               seed the random number generator
SCREEN _NEWIMAGE(640, 480, 32) '                enter graphics screen

DO '                                            begin main loop
    _LIMIT 60 '                                 60 frames per second
    CLS '                                       clear screen
    IF KeyWait% THEN KeyWait% = KeyWait% - 1 '  decrement key stroke counter
    IF _KEYDOWN(32) AND KeyWait% = 0 THEN '     space bar pressed?
        KeyWait% = INT(RND(1) * 20) + 10 '      yes, reset key stroke counter
        ShootProjectile 319, 350 '              send a roman candle projectile flying
    END IF
    UpdateProjectiles '                         maintain live projectiles
    _DISPLAY '                                  update screen with changes
LOOP UNTIL _KEYDOWN(27) '                       leave when ESC pressed
FOR Candle% = 1 TO 7 '                          cycle through projectile images
    _FREEIMAGE Projectile&(Candle%) '           remove projectile image from memory
NEXT Candle%
SYSTEM '                                        return to operating system

'------------------------------------------------------------------------------------------------------------
SUB MakeProjectiles ()
    '--------------------------------------------------------------------------------------------------------
    '- Create the projectile images -
    '--------------------------------

    SHARED Projectile&() '      need access to projectile images
    DIM Colors(7) AS COLORS '   projectile colors
    DIM Glowing% '              color counter
    DIM Ball% '                 image circle counter
    DIM Alpha% '                transparency level

    Colors(1).red = 0: Colors(1).green = 0: Colors(1).blue = 255 '     blue
    Colors(2).red = 0: Colors(2).green = 255: Colors(2).blue = 0 '     green
    Colors(3).red = 0: Colors(3).green = 255: Colors(3).blue = 255 '   cyan
    Colors(4).red = 255: Colors(4).green = 0: Colors(4).blue = 0 '     red
    Colors(5).red = 255: Colors(5).green = 0: Colors(5).blue = 255 '   magenta
    Colors(6).red = 255: Colors(6).green = 255: Colors(6).blue = 0 '   yellow
    Colors(7).red = 255: Colors(7).green = 255: Colors(7).blue = 255 ' white

    FOR Glowing% = 1 TO 7 '                                            cycle through projectile colors
        Projectile&(Glowing%) = _NEWIMAGE(65, 65, 32) '                create projectile image holder
        _DEST Projectile&(Glowing%) '                                  make image the destination
        Alpha% = 255 '                                                 reset transparency level
        FOR Ball% = 0 TO 32 '                                          cycle through circles
            CIRCLE (32, 32), Ball%, _RGB32(Colors(Glowing%).red,_
                                           Colors(Glowing%).green,_
                                           Colors(Glowing%).blue,_
                                           Alpha%) '                   draw circle
            Alpha% = Alpha% - 7 '                                      slightly decrement transparency level
        NEXT Ball%
    NEXT Glowing%
    _DEST 0 '                                                          return destination to screen

END SUB

'------------------------------------------------------------------------------------------------------------
SUB ShootProjectile (x%, y%)
    '--------------------------------------------------------------------------------------------------------
    '- Initiate a roman candle projectile at x,y -
    '---------------------------------------------

    SHARED Roman() AS CANDLE ' need access to roman candles
    DIM Cleanup% '             -1 (TRUE) if all projectiles dead
    DIM Candle% '              roman candle counter

    Cleanup% = -1 '                                                 assume all projectiles dead
    Candle% = 0 '                                                   reset roman candle counter
    DO '                                                            cycle through roman candles
        IF Roman(Candle%).life <> 0 THEN Cleanup% = 0 '             if this one alive cleanup can't happen
        Candle% = Candle% + 1 '                                     increment roman candle counter
    LOOP UNTIL Candle% = UBOUND(Roman) + 1 OR Cleanup% = 0 '        leave when all checked or no cleanup
    IF Cleanup% THEN REDIM Roman(0) AS CANDLE '                     reset array if cleanup needed
    REDIM _PRESERVE Roman(UBOUND(Roman) + 1) AS CANDLE '            add one index to the roman candle array
    Roman(UBOUND(Roman)).life = INT(RND(1) * 60) + 30 '             random lifespan
    Roman(UBOUND(Roman)).x = x% '                                   set X coordinate
    Roman(UBOUND(Roman)).y = y% '                                   set Y coordinate
    Roman(UBOUND(Roman)).xdir = RND(1) - RND(1) '                   random X vector
    Roman(UBOUND(Roman)).ydir = -RND(1) - 1 '                       random -Y vector
    Roman(UBOUND(Roman)).size = 64 '                                initial size of projectile image
    Roman(UBOUND(Roman)).fade = 65 / Roman(UBOUND(Roman)).life '    size step down rate of image
    Roman(UBOUND(roman)).speed = INT(RND(1) * 5) + 5 '              random speed
    Roman(UBOUND(roman)).image = INT(RND(1) * 7) + 1 '              random projectile image

END SUB

'------------------------------------------------------------------------------------------------------------
SUB UpdateProjectiles ()
    '--------------------------------------------------------------------------------------------------------
    '- Maintain live projectiles -
    '-----------------------------

    SHARED Projectile&() '      need access to projectile images
    SHARED Roman() AS CANDLE '  need access to roman candles
    DIM Candle% '               roman candle counter
    DIM Cleanup% '              -1 (TRUE) if cleanup needed
    DIM size% '                 size of projectile image

    IF UBOUND(Roman) = 0 THEN EXIT SUB '                        if array empty leave
    Candle% = 0 '                                               reset roman candle counter
    Cleanup% = -1 '                                             assume array cleanup will be needed
    DO '                                                        cycle through roman candle projectiles
        Candle% = Candle% + 1 '                                 increment roman candle counter
        IF Roman(Candle%).life > 0 THEN '                       is this projectile active?
            Cleanup% = 0 '                                      yes, cleanup can't happen
            size% = Roman(Candle%).size \ 2 '                   calculate half width/height of projectile
            _PUTIMAGE (Roman(Candle%).x - Size%, Roman(Candle%).y - Size%)-_
                      (Roman(Candle%).x + Size%, Roman(Candle%).y + Size%),_
                      Projectile&(Roman(Candle%).image) '       draw image inside current box size
            Roman(Candle%).size = Roman(Candle%).size - Roman(Candle%).fade ' decrease size of image box
            Roman(Candle%).life = Roman(Candle%).life - 1 '     decrease projectile lifespan
            Roman(Candle%).x = Roman(Candle%).x + Roman(Candle%).xdir * Roman(Candle%).speed ' update X,Y
            Roman(Candle%).y = Roman(Candle%).y + Roman(Candle%).ydir * Roman(Candle%).speed ' coordinates
            Roman(Candle%).ydir = Roman(Candle%).ydir + .05 '   simulate gravity with vertical vector
            Roman(Candle%).speed = Roman(Candle%).speed * .95 ' decrease speed of projectil slightly
        END IF
    LOOP UNTIL Candle% = UBOUND(Roman) '                        leave when all active projectiles processed
    IF Cleanup% THEN REDIM Roman(0) AS CANDLE '                 reset array if cleanup needed

END SUB











