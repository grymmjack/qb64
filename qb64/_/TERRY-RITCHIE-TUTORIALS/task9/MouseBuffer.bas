'-------------------------------------
'- Reading the mouse buffer contents -
'-------------------------------------

CONST WHITE = _RGB32(255, 255, 255) '   define white
DIM KeyPress$ '                         user input when asked to press ENTER

SCREEN _NEWIMAGE(640, 480, 32) '                    initiate graphics screen
CLS
PRINT
INPUT " Click around on the screen a few times then press the ENTER key", KeyPress$
WHILE _MOUSEINPUT '                                 is there mouse data in the buffer?
    IF _MOUSEBUTTON(1) THEN '                       yes, is this data related to the left mouse button?
        LINE -(_MOUSEX, _MOUSEY), WHITE '           yes, draw a line to mouse position where click happened
    END IF
WEND '                                              leave loop only when no mouse data remains in buffer
PRINT " Your pattern of clicks is now displayed"

