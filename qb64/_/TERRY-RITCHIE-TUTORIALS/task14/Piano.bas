'*
'* QB64 Simple Piano
'*
'* Demonstrates the use of external sound files to create a realistic piano.
'*
'* ESC         - exit program
'* RIGHT ARROW - increase octave
'* LEFT ARROW  - decrease octave
'* Piano Keys  -  R T  U I O   (black keys)
'*             - D F GH J K L  (white keys)
'*

'--------------------------------
'- Variable Declaration Section -
'--------------------------------

TYPE IVORY '          key information
    u AS INTEGER '    upper case value
    l AS INTEGER '    lower case value
    Down AS INTEGER ' key position
    x AS INTEGER '    key indicator x coordinate
    y AS INTEGER '    key indicator y coordinate
END TYPE

DIM K(12) AS IVORY '  key information array
DIM Tone&(88) '       piano key sounds array
DIM imgPiano& '       piano keyboard image
DIM imgAoctave& '     active octave image
DIM imgIoctave& '     inactive octave image
DIM Octave% '         current octave
DIM Khit& '           keyboard status
DIM Keys% '           key cycle counter

'----------------------------
'- Main Program Begins Here -
'----------------------------

LOADPIANO '                                                          load piano assets
SCREEN _NEWIMAGE(512, 263, 32) '                                     create default screen
_TITLE "PIANO" '                                                     set window title
_SCREENMOVE _MIDDLE '                                                center window on desktop
_PUTIMAGE (0, 0), imgPiano& '                                        show piano image
SHOWOCTAVE '                                                         update octave indicator
DO '                                                                 MAIN LOOP begins
    Khit& = _KEYHIT '                                                get keyboard status
    IF Khit& THEN '                                                  was a key hit?
        IF Khit& = 19200 OR Khit& = 19712 THEN '                     yes, left or right key?
            IF Khit& = 19200 THEN '                                  yes, left key?
                Octave% = Octave% - 1 '                              yes, decrease octave
                IF Octave% = -1 THEN Octave% = 0 '                   keep octave in limits
            ELSE '                                                   no, must be right key
                Octave% = Octave% + 1 '                              increase octave
                IF Octave% = 5 THEN Octave% = 4 '                    keep octave in limits
            END IF
            SHOWOCTAVE '                                             update octave indicator
        ELSEIF Khit& = 27 THEN '                                     no, escape key?
            QUIT '                                                   yes, quit program
        END IF
    END IF
    FOR Keys% = 1 TO 12 '                                            cycle through keys
        IF _KEYDOWN(K(Keys%).u) OR _KEYDOWN(K(Keys%).l) THEN '       key pressed?
            PRESS Keys% '                                            yes, play note
        ELSE '                                                       no
            RELEASE Keys% '                                          remove key indicator
        END IF
    NEXT Keys%
    _DISPLAY '                                                       update screen changes
LOOP '                                                               MAIN LOOP back

'-----------------------------------
'- Function and Subroutine section -
'-----------------------------------

'--------------------------------------------------------------------------------------------

SUB QUIT ()

    '*
    '* Cleans RAM by removing all image and sound assets and then exits to Windows.
    '*

    SHARED Tone&() '     need access to piano key sounds array
    SHARED imgPiano& '   need access to piano keyboard image
    SHARED imgAoctave& ' need access to active octave image
    SHARED imgIoctave& ' need access to inactive octave image

    DIM Count% '         generic counter

    FOR Count% = 1 TO 88 '        cycle through all 88 sound files
        _SNDCLOSE Tone&(Count%) ' remove sound file from RAM
    NEXT Count%
    _FREEIMAGE imgPiano& '        remove piano image from RAM
    _FREEIMAGE imgAoctave& '      remove active octave image from RAM
    _FREEIMAGE imgIoctave& '      remove inactive octave image from RAM
    SYSTEM '                      return to Windows

END SUB

'--------------------------------------------------------------------------------------------

SUB RELEASE (k%)

    '*
    '* Removes key press display and sets key as being released
    '*

    SHARED K() AS IVORY ' need access to key information array

    IF K(k%).Down THEN '                                                  is key pressed?
        K(k%).Down = 0 '                                                  yes, set it as released
        SELECT CASE k% '                                                  which key is it?
            CASE 1, 3, 5, 6, 8, 10, 12 '                                  white key
                LINE (K(k%).x, K(k%).y)-(K(k%).x + 27, K(k%).y + 27), _RGB32(255, 255, 255), BF
            CASE ELSE '                                                   black key
                LINE (K(k%).x, K(k%).y)-(K(k%).x + 27, K(k%).y + 27), _RGB32(32, 32, 32), BF
        END SELECT
    END IF

END SUB

'--------------------------------------------------------------------------------------------

SUB PRESS (k%)

    '*
    '* Applies key press display and sets key as being pressed
    '*

    SHARED K() AS IVORY ' need access to key information array
    SHARED Tone&() '      need access to piano key sounds array
    SHARED Octave% '      need access to current octave

    IF NOT K(k%).Down THEN '                                               is key released?
        K(k%).Down = -1 '                                                  yes, set it as pressed
        _SNDPLAY Tone&(Octave% * 12 + k%) '                                play tone for key
        SELECT CASE k% '                                                   which key is it?
            CASE 1, 3, 5, 6, 8, 10, 12 '                                   white key
                LINE (K(k%).x, K(k%).y)-(K(k%).x + 27, K(k%).y + 27), _RGB32(0, 0, 0), BF
            CASE ELSE '                                                    black key
                LINE (K(k%).x, K(k%).y)-(K(k%).x + 27, K(k%).y + 27), _RGB32(255, 255, 255), BF
        END SELECT
    END IF

END SUB

'--------------------------------------------------------------------------------------------

SUB SHOWOCTAVE

    '*
    '* Updates the small top piano keyboard to show current active octave
    '*

    SHARED Octave% '     need access to current octave
    SHARED imgAoctave& ' need access to active octave image
    SHARED imgIoctave& ' need access to inactive octave image

    DIM Count% '         generic counter

    FOR Count% = 0 TO 4 '                                    cycle through octaves
        IF Count% = Octave% THEN '                           current octave?
            _PUTIMAGE (96 + (Count% * 64), 0), imgAoctave& ' yes, place active octave image
        ELSE '                                               no
            _PUTIMAGE (96 + (Count% * 64), 0), imgIoctave& ' place inactive octave image
        END IF
    NEXT Count%

END SUB

'--------------------------------------------------------------------------------------------

SUB LOADPIANO ()

    '*
    '* Loads the piano sounds and images and initializes variables
    '*

    SHARED K() AS IVORY ' need access to key information array
    SHARED Tone&() '      need access to piano key sounds array
    SHARED imgPiano& '    need access to piano keyboard image
    SHARED imgAoctave& '  need access to active octave image
    SHARED imgIoctave& '  need access to inactive octave image
    SHARED Octave% '      need access to current octave

    DIM Note% '           counter used to open sounds
    DIM Count% '          counter used to close sounds if error
    DIM Path$ '           path to sound and graphics files
    DIM File$ '           sound file names

    Path$ = ""
    IF _DIREXISTS(Path$) THEN '                                        path exist?
        FOR Note% = 1 TO 88 '                                          cycle through notes
            File$ = Path$ + LTRIM$(STR$(Note%)) + ".ogg" '             construct file name
            IF _FILEEXISTS(File$) THEN '                               sound file exist?
                Tone&(Note%) = _SNDOPEN(File$) '                       yes, load sound file
            ELSE '                                                     no, sound file missing
                PRINT '                                                report error to user
                PRINT " ERROR: Sound file "; File$; " is missing."
                IF Note% > 1 THEN '                                    did any sounds load?
                    FOR Count% = Note% TO 1 STEP -1 '                  yes, cycle notes backwards
                        _SNDCLOSE Tone&(Count%) '                      remove sound from RAM
                    NEXT Count%
                    END '                                              end program
                END IF
            END IF
        NEXT Note%
    ELSE '                                                             no, path missing
        PRINT '                                                        report error to user
        PRINT " ERROR: The SND\PIANO\ folder could not be found."
        END '                                                          end program
    END IF
    IF _FILEEXISTS(Path$ + "piano.png") THEN '                     image file exist?
        imgPiano& = _LOADIMAGE(Path$ + "piano.png", 32) '          yes, load image file
    ELSE '                                                         no, image file missing
        PRINT '                                                    report error to user
        PRINT " ERROR: piano.png missing."
        END '                                                      end program
    END IF
    IF _FILEEXISTS(Path$ + "active.png") THEN '                    image file exist?
        imgAoctave& = _LOADIMAGE(Path$ + "active.png", 32) '       yes, load image file
    ELSE '                                                         no, image file missing
        PRINT '                                                    report error to user
        PRINT " ERROR: active.png missing."
        _FREEIMAGE imgPiano& '                                     remove image from RAM
        END '                                                      end program
    END IF
    IF _FILEEXISTS(Path$ + "inactive.png") THEN '                  image file exist?
        imgIoctave& = _LOADIMAGE(Path$ + "inactive.png", 32) '     yes, load image file
    ELSE '                                                         no, image file missing
        PRINT '                                                    report error to user
        PRINT " ERROR: inactive.png missing."
        _FREEIMAGE imgPiano& '                                     remove image from RAM
        _FREEIMAGE imgAoctave& '                                   remove image from RAM
        END '                                                      end program
    END IF
    K(1).x = 22: K(1).y = 212: K(2).x = 60: K(2).y = 132 '             set indicator coordinates
    K(3).x = 95: K(3).y = 212: K(4).x = 134: K(4).y = 132
    K(5).x = 168: K(5).y = 212: K(6).x = 241: K(6).y = 212
    K(7).x = 278: K(7).y = 132: K(8).x = 314: K(8).y = 212
    K(9).x = 353: K(9).y = 132: K(10).x = 387: K(10).y = 212
    K(11).x = 428: K(11).y = 132: K(12).x = 460: K(12).y = 212
    K(1).l = 100: K(1).u = 68: K(2).l = 114: K(2).u = 82 '             set key case values
    K(3).l = 102: K(3).u = 70: K(4).l = 116: K(4).u = 84
    K(5).l = 103: K(5).u = 71: K(6).l = 104: K(6).u = 72
    K(7).l = 117: K(7).u = 85: K(8).l = 106: K(8).u = 74
    K(9).l = 105: K(9).u = 73: K(10).l = 107: K(10).u = 75
    K(11).l = 111: K(11).u = 79: K(12).l = 108: K(12).u = 76
    Octave% = 2 '                                                      set initial octave

END SUB

'--------------------------------------------------------------------------------------------

