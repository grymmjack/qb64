DIM AllFlags& ' image containing animations of flag
DIM Flags&(7) ' array containing individual frames of flag animation
DIM Count% '    generic counter
DIM Banner& '   Star Spangled Banner music

AllFlags& = _LOADIMAGE("flags.png", 32) ' load image into memory
Banner& = _SNDOPEN("anthem.ogg") '        load patriotic music into memory
DO '                                                        start image load loop
    Flags&(Count%) = _NEWIMAGE(256, 199, 32) '              create top row flag image holder
    Flags&(Count% + 4) = _NEWIMAGE(256, 199, 32) '          create bottom row flag image holder
    '*
    '* Get top row flag and place in appropriate Flags&() image
    '*
    _PUTIMAGE (0, 0)-(255, 198), AllFlags&, Flags&(Count%), (Count% * 256, 0)-(Count% * 256 + 255, 198)
    '*
    '* Get bottom row flag and place in appropriate Flags&() image
    '*
    _PUTIMAGE (0, 0)-(255, 198), AllFlags&, Flags&(Count% + 4), (Count% * 256, 199)-(Count% * 256 + 255, 397)
    Count% = Count% + 1 '                                   increment to next array index
LOOP UNTIL Count% = 4 '                                     leave loop when count exceeded
SCREEN _NEWIMAGE(256, 199, 32) '                            create graphics screen
_TITLE "All rise for our national anthem" '                 give window a title
_DELAY .5 '                                                 slight delay before screen move
_SCREENMOVE _MIDDLE '                                       move screen to middle of desktop
Count% = 0 '                                                reset array index counter
_SNDPLAY Banner& '                                          play patriotic music
DO '                                                        begin flag waving loop
    CLS , _RGB32(255, 255, 255) '                           clear screen with white background
    _LIMIT 10 '                                             10 frames per second
    _PUTIMAGE (0, 0), Flags&(Count%) '                      place flag image on screen
    _DISPLAY '                                              update screen with changes
    Count% = Count% + 1 '                                   increment array index counter
    IF Count% = 8 THEN Count% = 0 '                         keep index within limits
LOOP UNTIL _KEYDOWN(27) '                                   leave loop when ESC pressed
FOR Count% = 0 TO 7 '                                       cycle through all array indexes
    _FREEIMAGE Flags&(Count%) '                             free flag images from RAM (cleanup)
NEXT Count%
_SNDCLOSE Banner& '                                         free music from RAM (cleanup)
SYSTEM '                                                    return to Windows

