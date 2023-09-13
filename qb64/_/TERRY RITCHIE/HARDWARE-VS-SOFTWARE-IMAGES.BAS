OPTION _EXPLICIT '                declare those variables son!

CONST TOTAL = 8000 '              too many circles will crash program depending on amount of RAM and VRAM
CONST SWIDTH = 1280 '             screen width
CONST SHEIGHT = 720 '             screen height

TYPE SPRITEXY '                   sprite location and vector
    x AS SINGLE '                 horizontal coordinate
    y AS SINGLE '                 vertical coordinate
    xdir AS SINGLE '              x vector
    ydir AS SINGLE '              y vector
END TYPE

DIM SpriteSW(TOTAL) AS LONG '     software sprites
DIM SpriteHW(TOTAL) AS LONG '     hardware sprites
DIM SpriteXY(TOTAL) AS SPRITEXY ' sprite locations and vecotrs
DIM HWSprite AS LONG '            original sprite used for copying ('HARD' printed inside)
DIM SWSprite AS LONG '            original sprite used for copying ('SOFT' printed inside)
DIM Count AS INTEGER '            sprite counter
DIM Software AS INTEGER '         -1 in software mode, 0 in hardware mode
DIM a AS STRING '                 key pressed by user
DIM t1 AS DOUBLE '                timer at start of frame
DIM t2 AS DOUBLE '                timer at end of frame
DIM t3 AS DOUBLE '                total time taken to draw sprites

RANDOMIZE TIMER '                                     seed random number generator
SCREEN _NEWIMAGE(SWIDTH, SHEIGHT, 32) '               create screen canvas
Software = -1 '                                       start in software mode
HWSprite = _NEWIMAGE(50, 50, 32) '                    temp hardware sprite image
SWSprite = _NEWIMAGE(50, 50, 32) '                    temp software sprite image (notice 32 - still a software sprite at this point)
_DEST HWSprite '                                      draw on temp hardware sprite image
LOCATE 2, 2: PRINT "HARD"; '                          print inside circle
CIRCLE (24, 24), 24 '                                 draw circle
_DEST SWSprite '                                      draw on temp software sprite image
LOCATE 2, 2: PRINT "SOFT"; '                          print inside circle
CIRCLE (24, 24), 24 '                                 draw circle
_DEST 0 '                                             draw on main screen canvas
FOR Count = 1 TO TOTAL '                              cycle through sprites
    SpriteSW(Count) = _COPYIMAGE(SWSprite, 32) '      copy the software sprite
    SpriteHW(Count) = _COPYIMAGE(HWSprite, 33) '      copy the software sprite to a hardware sprite (notice 33)
    SpriteXY(Count).x = SWIDTH / 2 - 24 '             x coordinate start (centered)
    SpriteXY(Count).y = SHEIGHT / 2 - 24 '            y coordinate start (centered)
    SpriteXY(Count).xdir = RND - RND '                random x vector from -1 to 1
    SpriteXY(Count).ydir = RND - RND '                random y vector from -1 to 1
NEXT Count
_FREEIMAGE SWSprite '                                 temp sprites no longer need
_FREEIMAGE HWSprite

DO '                                                  begin frame loop
    t1 = TIMER(.001) '                                get frame start time
    Count = 0 '                                       reset sprite counter
    IF Software THEN CLS '                            software screens need clearing, hardware don't
    DO '                                                                                                                  begin sprite draw loop
        Count = Count + 1 '                                                                                               increment sprite counter
        IF Software THEN '                                                                                                software mode?
            _PUTIMAGE (SpriteXY(Count).x, SpriteXY(Count).y), SpriteSW(Count) '                                           yes, draw software sprite
        ELSE '                                                                                                            no
            _PUTIMAGE (SpriteXY(Count).x, SpriteXY(Count).y), SpriteHW(Count) '                                           draw hardware sprite
        END IF
        SpriteXY(Count).x = SpriteXY(Count).x + SpriteXY(Count).xdir '                                                    move sprite by set vectors
        SpriteXY(Count).y = SpriteXY(Count).y + SpriteXY(Count).ydir
        IF SpriteXY(Count).x > SWIDTH - 50 OR SpriteXY(Count).x < 1 THEN SpriteXY(Count).xdir = -SpriteXY(Count).xdir '   keep sprite on screen
        IF SpriteXY(Count).y > SHEIGHT - 50 OR SpriteXY(Count).y < 32 THEN SpriteXY(Count).ydir = -SpriteXY(Count).ydir
    LOOP UNTIL Count = TOTAL '                                                                                            leave when all sprites drawn
    t2 = TIMER(.001) '                                get frame end time
    t3 = t2 - t1 '                                    calculate total time
    IF t3 > 0 THEN '                                  avoid /0
        LOCATE 2, 28 '                                position cursor
        PRINT USING "#### FPS "; 1 / t3; '            print frame count
        IF Software THEN '                            software mode?
            PRINT "software mode "; '                 yes, print indicator
        ELSE '                                        no
            PRINT "hardware mode "; '                 print indictaor
        END IF
    END IF
    LOCATE 1, 2 '                                     print instructions
    PRINT "Controlling"; TOTAL; "sprites. Press 'H' for hardware or 'S' for software - ESC to quit"
    _DISPLAY '                                        update screen with changes
    a = UCASE$(INKEY$) '                              get user keypress (if any)
    IF a = "S" THEN Software = -1 '                   if user pressed S key set software mode
    IF a = "H" THEN Software = 0: CLS '               if user pressed H set hardware mode and clear software screen
LOOP UNTIL a = CHR$(27) '                             leave when user presses ESC key
FOR Count = 1 TO TOTAL '                              cycle through sprites
    _FREEIMAGE SpriteSW(Count) '                      remove sprites from RAM
    _FREEIMAGE SpriteHW(Count)
NEXT Count
SYSTEM '                                              return to operating system