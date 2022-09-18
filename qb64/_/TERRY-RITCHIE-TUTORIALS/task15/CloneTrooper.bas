CONST Gray = _RGB32(127, 127, 127) ' define colors
CONST RED = _RGB32(255, 0, 0)

DIM Trooper& '      trooper sprite sheet
DIM Walking&(5) '   walking trooper images
DIM Falling&(5) '   falling trooper images
DIM Standing& '     trooper just standing around
DIM Clone& '        a cloned trooper
DIM AllRight& '     "all right" voice
DIM Blaster& '      blaster sound
DIM MoveAlong& '    "move along" voice
DIM WhatsGoingOn& ' "do you know what's going on?" voice
DIM Uuhhh& '        clone removal sound
DIM Count% '        generic counter
DIM x!, y% '        coordinates of image box for walking trooper

Trooper& = _LOADIMAGE("trooper.png", 32) '    load the sprite sheet
Standing& = _NEWIMAGE(32, 68, 32) '                             create the standing image
_PUTIMAGE , Trooper&, Standing&, (192, 0)-(223, 67) '           extract the standing image
FOR Count% = 0 TO 5 '                                           cycle through six more images
    Walking&(Count%) = _NEWIMAGE(32, 68, 32) '                  create walking image cell
    Falling&(Count%) = _NEWIMAGE(46, 68, 32) '                  create falling image cell
    _PUTIMAGE , Trooper&, Walking&(Count%), (32 * Count%, 0)-(32 * Count% + 31, 67) '   extract walking image
    _PUTIMAGE , Trooper&, Falling&(Count%), (46 * Count%, 68)-(46 * Count% + 45, 135) ' extract falling image
NEXT Count%
_FREEIMAGE Trooper& '                                           sprite sheet no longer needed
AllRight& = _SNDOPEN("allright.ogg") '        load the sound files
Blaster& = _SNDOPEN("blaster.ogg")
MoveAlong& = _SNDOPEN("movealong.ogg")
WhatsGoingOn& = _SNDOPEN("whatsgoingon.ogg")
Uuhhh& = _SNDOPEN("uuhhh.ogg")
_SNDPLAY MoveAlong& '                                           play sound
SCREEN _NEWIMAGE(440, 230, 32) '                                enter graphics screen
x! = 48 '                                                       set upper left x location
y% = 102 '                                                      set upper left y location
Count% = 0 '                                                    reset counter
DO '                                                            walking forward loop
    _LIMIT 15 '                                                 15 frames per second
    CLS , Gray '                                                clear with gray
    x! = x! - .47 '                                             increase size of image box
    y% = y% - 1
    _PUTIMAGE (x!, y%)-(96 - x!, 204 - y%), Walking&(Count%) '  show walking trooper within box limits
    Count% = Count% + 1 '                                       increment counter
    IF Count% = 6 THEN Count% = 0 '                             reset if counter exceeds limit
    _DISPLAY '                                                  update screen with changes
LOOP UNTIL y% = 0
_AUTODISPLAY '                                                  auto update screen
CLS , Gray '                                                    clear with gray
_PUTIMAGE (0, 0)-(95, 204), Standing& '                         show trooper in standing position
LOCATE 14, 10 '                                                 position text cursor
PRINT "Press any key to clone the trooper."; '                  display instructions
SLEEP '                                                         wait for key stroke
_SNDPLAY AllRight& '                                            play sound
Clone& = _COPYIMAGE(Standing&) '                                create a copy of the standing image
_PUTIMAGE (120, 0)-(216, 204), Clone& '                         place copy on the screen
LOCATE 14, 10 '                                                 position text cursor
PRINT "Press any key to remove the clone. "; '                  display instructions
SLEEP '                                                         wait for key stroke
_SNDPLAY Blaster& '                                             play blaster sound (uh oh)
FOR Count% = 440 TO 150 STEP -1 '                               cycle from right side of screen to clone
    CLS , Gray '                                                clear with gray
    _PUTIMAGE (0, 0)-(95, 204), Standing& '                     place standing trooper
    _PUTIMAGE (120, 0)-(216, 204), Clone& '                     place his clone
    LINE (Count%, 100)-(Count% + 100, 104), RED, BF '           draw blaster beam
    _DISPLAY '                                                  update screen with changes
NEXT Count%
_SNDPLAY Uuhhh& '                                               play ugh sound
FOR Count% = 0 TO 5 '                                           cycle through falling images
    _LIMIT 15 '                                                 15 frames per second
    CLS , Gray '                                                clear with gray
    _PUTIMAGE (0, 0)-(95, 204), Standing& '                     place the standing trooper
    _PUTIMAGE (113, 0)-(250, 204), Falling&(Count%) '           place the falling trooper
    _DISPLAY '                                                  update screen with changes
NEXT Count%
_DELAY 1 '                                                      delay for 1 second
_SNDPLAY WhatsGoingOn& '                                        play confused trooper sound
_DELAY 4 '                                                      delay for 4 seconds
FOR Count% = 0 TO 5 '                                           cycle through standing and falling images
    _FREEIMAGE Walking&(Count%) '                               remove all walking images from memory
    _FREEIMAGE Falling&(Count%) '                               remove all falling images from memory
NEXT Count%
_FREEIMAGE Standing& '                                          remove all sound files from memory
_FREEIMAGE Clone&
_SNDCLOSE AllRight&
_SNDCLOSE Blaster&
_SNDCLOSE MoveAlong&
_SNDCLOSE WhatsGoingOn&
_SNDCLOSE Uuhhh&
SYSTEM '                                                        return to operating system





