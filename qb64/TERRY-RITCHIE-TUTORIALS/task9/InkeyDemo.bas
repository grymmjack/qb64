'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST GREEN = _RGB32(0, 127, 0) '       set colors
CONST BRIGHTGREEN = _RGB32(0, 255, 0)

DIM KeyPress$ '                         the key user is pressing
DIM x%, y% '                            x,y coordinate of circle

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '             initiate graphics screen
x% = 319 '                                   set x,y circle coordinates
y% = 239
DO '                                         begin main loop
    CLS '                                    clear the screen
    _LIMIT 30 '                              keep loop at 30 frames per second
    LOCATE 2, 25 '                           position text cursor
    PRINT "Use WASD to move circle around" ' print user instructions
    LOCATE 29, 27 '                          position text cursor
    PRINT "Press ESC to leave program"; '    print user instructions
    CIRCLE (x%, y%), 50, BRIGHTGREEN '       draw bright green circle
    PAINT (x%, y%), GREEN, BRIGHTGREEN '     fill in with green
    KeyPress$ = INKEY$ '                     grab any key being pressed
    IF KeyPress$ = "w" THEN y% = y% - 1 '    if w then decrement y
    IF KeyPress$ = "s" THEN y% = y% + 1 '    if s then increment y
    IF KeyPress$ = "a" THEN x% = x% - 1 '    if a then decrement x
    IF KeyPress$ = "d" THEN x% = x% + 1 '    if d then increment x
    IF y% < 49 THEN y% = 49 '                stop circle at top edge
    IF y% > 429 THEN y% = 429 '              stop circle at bottom edge
    IF x% < 49 THEN x% = 49 '                stop circle at left edge
    IF x% > 589 THEN x% = 589 '              stop circle at right edge
    _DISPLAY '                               update changes to the screen
LOOP UNTIL KeyPress$ = CHR$(27) '            exit program if ESC pressed
SYSTEM '                                     return to Windows

























