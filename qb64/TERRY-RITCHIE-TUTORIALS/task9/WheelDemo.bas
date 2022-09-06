'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST BRIGHTGREEN = _RGB32(0, 255, 0)
DIM Green% '        green intensity of circle
DIM x%, y% '        x,y coordinate of circle

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                   initiate graphics screen
x% = 319 '                                         set x,y circle coordinates
y% = 239
_MOUSEHIDE '                                       Make mouse pointer invisible
Green% = 127 '                                     set green intensity
DO '                                               begin main loop
    CLS '                                          clear the screen
    LOCATE 2, 25 '                                 position text cursor
    PRINT "Use MOUSE to move circle around" '      print user instructions
    LOCATE 3, 22 '                                 position text cursor
    PRINT "Use scroll wheel to change intensity" ' print user instructions
    LOCATE 29, 27 '                                position text cursor
    PRINT "Press ESC to leave program"; '          print user instructions
    CIRCLE (x%, y%), 50, BRIGHTGREEN '             draw circle
    PAINT (x%, y%), _RGB32(0, Green%, 0), BRIGHTGREEN ' fill circle
    DO WHILE _MOUSEINPUT '                         get latest mouse information
        Green% = Green% - _MOUSEWHEEL * 16 '       set color according to wheel movement
        IF Green% > 254 THEN Green% = 254 '        keep green color within limits
        IF Green% < 0 THEN Green% = 0
    LOOP
    x% = _MOUSEX '                                 retrieve mouse X position
    y% = _MOUSEY '                                 retrieve mouse Y potition
    IF y% < 49 THEN y% = 49 '                      keep circle at top edge
    IF y% > 429 THEN y% = 429 '                    keep circle at bottom edge
    IF x% < 49 THEN x% = 49 '                      keep circle at left edge
    IF x% > 589 THEN x% = 589 '                    keep circle at right edge
    _DISPLAY '                                     update changes to the screen
LOOP UNTIL _KEYDOWN(27) '                          exit program if ESC pressed
SYSTEM '                                           return to Windows






















