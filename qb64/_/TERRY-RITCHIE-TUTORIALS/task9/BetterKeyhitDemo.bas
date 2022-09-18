'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST GREEN = _RGB32(0, 127, 0) '       set colors
CONST BRIGHTGREEN = _RGB32(0, 255, 0)

DIM KeyPress& '                         the value of the key user is pressing
DIM x%, y% '                            x,y coordinate of circle
DIM GoUp% '                             status of w key
DIM GoDown% '                           status of s key
DIM GoLeft% '                           status of a key
DIM GoRight% '                          status of d key

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '             initiate graphics screen
x% = 319 '                                   set x,y circle coordinates
y% = 239
DO '                                         begin main loop
    CLS '                                    clear the screen
    _LIMIT 240 '                             limit loop to 240 frames per second
    LOCATE 2, 25 '                           position text cursor
    PRINT "Use WASD to move circle around" ' print user instructions
    LOCATE 29, 27 '                          position text cursor
    PRINT "Press ESC to leave program"; '    print user instructions
    CIRCLE (x%, y%), 50, BRIGHTGREEN '       draw bright green circle
    PAINT (x%, y%), GREEN, BRIGHTGREEN '     fill in with green
    KeyPress& = _KEYHIT '                    get key the user is pressing
    IF KeyPress& = 119 THEN GoUp% = 1 '      remember when w key pressed
    IF KeyPress& = -119 THEN GoUp% = 0 '     remember when w key released
    IF KeyPress& = 115 THEN GoDown% = 1 '    remember when s key pressed
    IF KeyPress& = -115 THEN GoDown% = 0 '   remember when s key released
    IF KeyPress& = 97 THEN GoLeft% = 1 '     remember then a key pressed
    IF KeyPress& = -97 THEN GoLeft% = 0 '    remember when a key released
    IF KeyPress& = 100 THEN GoRight% = 1 '   remember when d key pressed
    IF KeyPress& = -100 THEN GoRight% = 0 '  remember when d key released
    IF GoUp% = 1 THEN y% = y% - 1 '          if w key then decrement y
    IF GoDown% = 1 THEN y% = y% + 1 '        if s key then increment y
    IF GoLeft% = 1 THEN x% = x% - 1 '        if a key then decrement x
    IF GoRight% = 1 THEN x% = x% + 1 '       if d key then increment x
    IF y% < 49 THEN y% = 49 '                stop circle at top edge
    IF y% > 429 THEN y% = 429 '              stop circle at bottom edge
    IF x% < 49 THEN x% = 49 '                stop circle at left edge
    IF x% > 589 THEN x% = 589 '              stop circle at right edge
    _DISPLAY '                               update changes to the screen
LOOP UNTIL _KEYDOWN(27) '                    exit program if ESC pressed
SYSTEM '                                     return to Windows













