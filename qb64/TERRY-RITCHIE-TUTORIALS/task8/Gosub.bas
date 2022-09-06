'--------------------------------
'- Variable declaration section -
'--------------------------------

CONST WHITE = _RGB32(255, 255, 255) ' define color white
DIM x%, y% '                          x,y coordinate pair of star to be drawn

'----------------
'- Main program -
'----------------

SCREEN _NEWIMAGE(640, 480, 32) '                initiate graphics screen
GOSUB DIRECTIONS '                              print directions
DO '                                            begin main program loop
    _LIMIT 60 '                                 limit to 60 frames per second
    WHILE _MOUSEINPUT: WEND '                   get latest mouse information
    IF _MOUSEBUTTON(1) THEN GOSUB DRAWSTAR '    if left mouse button then draw a star
    IF _MOUSEBUTTON(2) THEN GOSUB DIRECTIONS '  if right mouse button then clear the screen
    _DISPLAY '                                  update the screen with changes
LOOP UNTIL _KEYDOWN(27) '                       leave main loop when ESC pressed
SYSTEM '                                        return control to OS

'---------------------------------------------------------------------------------------------------------------
'- Clear the screen then print directions
'---------------------------------------------------------------------------------------------------------------
DIRECTIONS:

CLS '                                             clear the screen
PRINT '                                           print directions
PRINT " Left click anywhere on the screen to draw a star."
PRINT " Right click to clear the screen."
PRINT " Press the ESC key to exit the program."

RETURN '                                          return back to main code

'---------------------------------------------------------------------------------------------------------------
'- Draw a star at the current mouse pointer location
'---------------------------------------------------------------------------------------------------------------
DRAWSTAR:

x% = _MOUSEX '                                    get current x location of mouse pointer
y% = _MOUSEY '                                    get current y location of mouse pointer
LINE (x% - 10, y% - 3)-(x% + 10, y% - 3), WHITE ' draw a solid star
LINE -(x% - 7, y% + 7), WHITE
LINE -(x%, y% - 10), WHITE
LINE -(x% + 7, y% + 7), WHITE
LINE -(x% - 10, y% - 3), WHITE
PAINT (x%, y%), WHITE, WHITE
PAINT (x% - 5, y% - 1), WHITE, WHITE
PAINT (x% + 5, y% - 1), WHITE, WHITE
PAINT (x%, y% - 4), WHITE, WHITE
PAINT (x% - 3, y% + 3), WHITE, WHITE
PAINT (x% + 3, y% + 3), WHITE, WHITE

RETURN '                                          return back to main code










