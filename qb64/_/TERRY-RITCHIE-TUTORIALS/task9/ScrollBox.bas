'---------------------
' - Define variables -
'---------------------

CONST SCREENWIDTH = 800 '               define screen dimensions
CONST SCREENHEIGHT = 600
CONST BRIGHTGREEN = _RGB32(0, 255, 0) ' define colors
CONST GREEN = _RGB32(0, 127, 0)
DIM BoxWidth% '                         width of box
DIM BoxHeight% '                        height of box
DIM x%, y% '                            box upper left x,y location

'-----------------------
'- Main program begins -
'-----------------------

SCREEN _NEWIMAGE(SCREENWIDTH, SCREENHEIGHT, 32) '       initiate graphics screen
BoxWidth% = 100 '                                       set starting width of box
BoxHeight% = 100 '                                      set starting height of box
_MOUSEHIDE '                                            hide the mouse pointer
DO '                                                    begin main program loop
    CLS '                                               clear the screen
    LOCATE 2, 32 '                                      display directions
    PRINT "Use mouse to move box around screen."
    LOCATE 4, 27
    PRINT "Hold left mouse button to change width of box."
    LOCATE 6, 26
    PRINT "Hold right mouse button to change height of box."
    LOCATE 8, 19
    PRINT "While holding a button down use scroll wheel to change box size."
    LOCATE 35, 37
    PRINT "Press ESC to leave program."
    WHILE _MOUSEINPUT '                                 something in mouse buffer?
        IF _MOUSEBUTTON(1) THEN '                       yes, left mouse button clicked?
            BoxWidth% = BoxWidth% - _MOUSEWHEEL * 5 '   yes, adjust width of box based on wheel movement
            IF BoxWidth% < 10 THEN BoxWidth% = 10 '     box can be no smaller than 10 pixels wide
            IF BoxWidth% > 100 THEN BoxWidth% = 100 '   box can be no larger than 100 pixels wide
        ELSEIF _MOUSEBUTTON(2) THEN '                   right mouse button clicked?
            BoxHeight% = BoxHeight% - _MOUSEWHEEL * 5 ' yes, adjust height of box based on wheel movement
            IF BoxHeight% < 10 THEN BoxHeight% = 10 '   box can be no smaller than 10 pixels high
            IF BoxHeight% > 100 THEN BoxHeight% = 100 ' box can be no larger than 100 pixels high
        END IF
    WEND '                                              leave loop when mouse buffer empty
    x% = _MOUSEX - BoxWidth% / 2 '                      calculate upper left x coordinate of box
    y% = _MOUSEY - BoxHeight% / 2 '                     calculate upper left y coordinate of box
    IF x% < 0 THEN '                                    box too far left?
        x% = 0 '                                        yes, keep box on left edge of screen
    ELSEIF x% + BoxWidth% - 1 > SCREENWIDTH THEN '      box too far right?
        x% = SCREENWIDTH - BoxWidth% '                  yes, keep box on right edge of screen
    END IF
    IF y% < 0 THEN '                                    box too high?
        y% = 0 '                                        yes, keep box on top edge of screen
    ELSEIF y% + BoxHeight% - 1 > SCREENHEIGHT THEN '    box too low?
        y% = SCREENHEIGHT - BoxHeight% '                yes, keep box on bottom edge of screen
    END IF
    LINE (x%, y%)-(x% + BoxWidth% - 1, y% + BoxHeight% - 1), BRIGHTGREEN, B ' draw box
    PAINT (x% + 1, y% + 1), GREEN, BRIGHTGREEN '                              paint inside of box
    _DISPLAY '                                          update screen with changes
LOOP UNTIL _KEYDOWN(27) '                               leave program when escape key pressed
SYSTEM '                                                return control to OS


