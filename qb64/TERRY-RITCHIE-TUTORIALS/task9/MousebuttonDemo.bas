'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST GREEN = _RGB32(0, 127, 0) '       define colors
CONST BRIGHTGREEN = _RGB32(0, 255, 0)
CONST RED = _RGB32(127, 0, 0)
CONST BRIGHTRED = _RGB32(255, 0, 0)

DIM x%, y% '        x,y coordinate of circle
DIM LeftClick% '    -1 when left button clicked, 0 when not
DIM RightClick% '   -1 when right button clicked, 0 when not
DIM CircleColor~& ' color of circle
DIM PaintColor~& '  inside paint color of circle

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                   initiate graphics screen
x% = 319 '                                         set x,y circle coordinates
y% = 239
CircleColor~& = BRIGHTGREEN '                      set initial circle color
PaintColor~& = GREEN '                             set initial paint color
_MOUSEHIDE '                                       Make mouse pointer invisible
DO '                                               begin main loop
    CLS '                                          clear the screen
    LOCATE 2, 25 '                                 position text cursor
    PRINT "Use MOUSE to move circle around" '      print user instructions
    LOCATE 3, 22 '                                 position text cursor
    PRINT "Mouse buttons to change circle color" ' print user instructions
    LOCATE 29, 27 '                                position text cursor
    PRINT "Press ESC to leave program"; '          print user instructions
    CIRCLE (x%, y%), 50, CircleColor~& '           draw circle
    PAINT (x%, y%), PaintColor~&, CircleColor~& '  fill circle
    DO WHILE _MOUSEINPUT '                         get latest mouse information
    LOOP
    x% = _MOUSEX '                                 retrieve mouse X position
    y% = _MOUSEY '                                 retrieve mouse Y potition
    LeftClick% = _MOUSEBUTTON(1) '                 retrieve left button status
    RightClick% = _MOUSEBUTTON(2) '                retrieve right button status
    IF LeftClick% THEN '                           was left button clicked?
        CircleColor~& = BRIGHTGREEN '              yes, set circle color (bright green)
        PaintColor~& = GREEN '                     set circle fill color (green)
    ELSEIF RightClick% THEN '                      no, was right button clicked?
        CircleColor~& = BRIGHTRED '                yes, set circle color (bright red)
        PaintColor~& = RED '                       set circle fill color (red)
    END IF
    IF y% < 49 THEN y% = 49 '                      keep circle at top edge
    IF y% > 429 THEN y% = 429 '                    keep circle at bottom edge
    IF x% < 49 THEN x% = 49 '                      keep circle at left edge
    IF x% > 589 THEN x% = 589 '                    keep circle at right edge
    _DISPLAY '                                     update changes to the screen
LOOP UNTIL _KEYDOWN(27) '                          exit program if ESC pressed
SYSTEM '                                           return to Windows








