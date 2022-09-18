'--------------------------------
'- Variable declaration section -
'--------------------------------

CONST WHITE = _RGB32(255, 255, 255) ' define color white

'----------------
'- Main program -
'----------------

SCREEN _NEWIMAGE(640, 480, 32) '                        initiate graphics screen
DIrections '                                            print directions
DO '                                                    begin main program loop
    _LIMIT 60 '                                         limit to 60 frames per second
    WHILE _MOUSEINPUT: WEND '                           get latest mouse information
    IF _MOUSEBUTTON(1) THEN DrawStar _MOUSEX, _MOUSEY ' if left button then draw star at pointer location
    IF _MOUSEBUTTON(2) THEN DIrections '                if right button then clear the screen
    _DISPLAY '                                          update the screen with changes
LOOP UNTIL _KEYDOWN(27) '                               leave main loop when ESC pressed
SYSTEM '                                                return control to OS

'---------------------------------------------------------------------------------------------------------------
SUB DIrections ()
    '-----------------------------------------------------------------------------------------------------------
    '- Clear the screen then print directions -
    '------------------------------------------

    CLS '                                             clear the screen
    PRINT '                                           print directions
    PRINT " Left click anywhere on the screen to draw a star."
    PRINT " Right click to clear the screen."
    PRINT " Press the ESC key to exit the program."

END SUB

'---------------------------------------------------------------------------------------------------------------
SUB DrawStar (x%, y%)
    '-----------------------------------------------------------------------------------------------------------
    '- Draw a star at coordinate provided -
    '-                                    -
    '- x% - x location to draw star       -
    '- y% - y location to draw star       -
    '--------------------------------------

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

END SUB






