'
' Quick and dirty demo of trapping the mouse pointer within areas on the screen
'

CONST FALSE = 0, TRUE = NOT FALSE ' truth detectors
CONST SWIDTH = 800, SHEIGHT = 600 ' screen dimensions


TYPE TYPE_POINT '                  COORDINATE POINT PROPERTIES
    x AS INTEGER '                  x,y point
    y AS INTEGER
END TYPE

TYPE TYPE_SCREENAREA '              SCREEN AREA PROPERTIES
    min AS TYPE_POINT '            upper left
    max AS TYPE_POINT '            lower right
    Visible AS INTEGER '            this screen is available to mouse (t/f)
    Trapped AS INTEGER '            this screen has mouse trapped (t/f)
END TYPE

TYPE TYPE_MOUSE '                  MOUSE PROPERTIES
    x AS INTEGER '                  x location
    y AS INTEGER '                  y location
    trapped AS INTEGER '            screen area mouse trapped in (0 for none)
    hovering AS INTEGER '          screen area mouse is hovering over (0 for none)
    min AS TYPE_POINT '            upper left corner of trapped area
    max AS TYPE_POINT '            lower right corner of trapped area
END TYPE

REDIM ScreenArea(0) AS TYPE_SCREENAREA ' screen area array
DIM Mouse AS TYPE_MOUSE '                mouse properties

'+---------------------+
'| Define screen areas |
'+---------------------+

Screen1 = DefineScreenArea(10, 10, 90, 90, TRUE) '    (x1, y1, x2, y2, Visible)
Screen2 = DefineScreenArea(100, 10, 190, 90, TRUE)
Screen3 = DefineScreenArea(10, 100, 190, 190, TRUE)
Screen4 = DefineScreenArea(200, 10, 380, 190, TRUE)
screen5 = DefineScreenArea(10, 200, 380, 380, TRUE)

SCREEN _NEWIMAGE(SWIDTH, SHEIGHT, 32) ' create graphics screen
_MOUSEHIDE '                            hide the default mouse pointer (rem this line to see why)    <<---------------
DO
    _LIMIT 30
    CLS
    LOCATE 2, 50: PRINT "Move mouse to select screen area."
    LOCATE 4, 50: PRINT "Left mouse button to trap mouse pointer."
    LOCATE 6, 50: PRINT "Right mouse button to release mouse pointer."
    LOCATE 8, 50: PRINT "ESC to exit."
    LOCATE 10, 50: PRINT "Currently hovering screen area"; Mouse.hovering
    LOCATE 12, 50: PRINT "Currently trapped in area"; Mouse.trapped
    LOCATE 14, 50: PRINT "This area is defined as ";
    SELECT CASE Mouse.hovering
        CASE 0
            PRINT "the main screen."
        CASE Screen1
            PRINT CHR$(34); "Screen1"; CHR$(34)
        CASE Screen2
            PRINT CHR$(34); "Screen2"; CHR$(34)
        CASE Screen3
            PRINT CHR$(34); "Screen3"; CHR$(34)
        CASE Screen4
            PRINT CHR$(34); "Screen4"; CHR$(34)
        CASE screen5
            PRINT CHR$(34); "Screen5"; CHR$(34)
    END SELECT
    DrawScreenAreas
    _DISPLAY
LOOP UNTIL _KEYDOWN(27)

'---------------------------------------------------------------------------------------------------------------------------------
SUB UpdateMouse ()

    '+--------------------------------------------------------------------------------------------------------+
    '| Tracks the mouse movement and controls when the mouse pointer is trapped within a defined screen area. |
    '|                                                                                                        |
    '| Left mouse button  - trap the mouse within a screen area                                              |
    '| Right mouse button - release a trapped mouse from within a screen area                                |
    '+--------------------------------------------------------------------------------------------------------+

    SHARED Mouse AS TYPE_MOUSE '            need access to mouse properties
    SHARED ScreenArea() AS TYPE_SCREENAREA ' need access to screen areas
    DIM m AS TYPE_POINT '                    current mouse location
    DIM s AS INTEGER '                      screen area counter

    WHILE _MOUSEINPUT: WEND '                                    get latest mouse updates
    m.x = _MOUSEX '                                              record mouse position
    m.y = _MOUSEY
    IF Mouse.trapped THEN '                                      is mouse currently trapped?
        IF m.x < Mouse.min.x THEN m.x = Mouse.min.x '            yes, confine mouse to screen area
        IF m.x > Mouse.max.x THEN m.x = Mouse.max.x
        IF m.y < Mouse.min.y THEN m.y = Mouse.min.y
        IF m.y > Mouse.max.y THEN m.y = Mouse.max.y
        _MOUSEMOVE m.x, m.y '                                    force mouse to updated coordinates
        IF _MOUSEBUTTON(2) THEN '                                right button clicked?
            ScreenArea(Mouse.trapped).Trapped = 0 '              yes, screen area is no longer trapped
            Mouse.trapped = 0 '                                  mouse is no longer trapped
        END IF
    ELSE '                                                      no, mouse is not trapped
        IF _MOUSEBUTTON(1) AND UBOUND(ScreenArea) THEN '        is there a defined screen area to enter?
            s = 0 '                                              reset screen area counter
            DO '                                                cycle through screen areas
                s = s + 1 '                                      increment screen area counter
                IF MouseHovering(ScreenArea(s)) THEN '          is mouse hovering over this screen area?
                    ScreenArea(s).Trapped = -1 '                yes, this screen area is no trapping the mouse
                    Mouse.trapped = s '                          remember screen area mouse trapped in
                    Mouse.min = ScreenArea(s).min '              record upper left coordinate of screen area
                    Mouse.max = ScreenArea(s).max '              record lower right coordinate of screen area
                END IF
            LOOP UNTIL s = UBOUND(ScreenArea) OR Mouse.trapped ' leave when all screen areas checked or the mouse became trapped
        END IF
    END IF
    CIRCLE (m.x, m.y), 5 '                                      draw mouse pointer
    PSET (m.x, m.y) '                                            (replace with an image of a mouse pointer by using _PUTIMAGE)

END SUB

'---------------------------------------------------------------------------------------------------------------------------------
SUB DrawScreenAreas ()

    '+-----------------------------------------------------+
    '| Draws the visible defined screen area borders.      |
    '|                                                    |
    '| Bright white - screen area has mouse trapped within |
    '| White        - mouse is hovering over screen area  |
    '| Gray        - no mouse activity within screen area |
    '+-----------------------------------------------------+

    SHARED ScreenArea() AS TYPE_SCREENAREA '  need access to screen areas
    SHARED Mouse AS TYPE_MOUSE '              need access to mouse properties
    STATIC Colour(-1 TO 1) AS _UNSIGNED LONG ' border colors
    DIM Area AS TYPE_SCREENAREA '              current screen area being checked
    DIM s AS INTEGER '                        screen area counter
    DIM Border AS INTEGER '                    current screen area border color

    IF UBOUND(ScreenArea) = 0 THEN EXIT SUB '                                      leave if no defined screen areas
    IF NOT Colour(-1) THEN '                                                        set border colors if not set yet
        Colour(-1) = _RGB32(255, 255, 255) '                                        trapped (bright white)
        Colour(0) = _RGB32(127, 127, 127) '                                        not hovering (gray)
        Colour(1) = _RGB32(192, 192, 192) '                                        hovering (white)
    END IF
    Mouse.hovering = 0
    s = 0 '                                                                        reset screen area counter
    DO '                                                                            cycle through screen areas
        s = s + 1 '                                                                increment screen area counter
        Area = ScreenArea(s) '                                                      get screen area
        IF Area.Visible THEN '                                                      is this area visible?
            IF Area.Trapped THEN '                                                  yes, is this area trapping the mouse?
                Border = -1 '                                                      yes, set border color
            ELSE '                                                                  no, this area is not trapping mouse
                IF Mouse.trapped THEN '                                            is the mouse trapped in another area?
                    Border = 0 '                                                    yes, set border color to non hovering
                ELSE '                                                              no, mouse is not trapped in any area
                    Border = MouseHovering(Area) '                                  set border color (0 not hovering, 1 hovering)
                    IF Border THEN Mouse.hovering = s
                END IF
            END IF
        END IF
        LINE (Area.min.x, Area.min.y)-(Area.max.x, Area.max.y), Colour(Border), B ' draw screen area border
        UpdateMouse '                                                              update mouse
    LOOP UNTIL s = UBOUND(ScreenArea) '                                            leave when all screen areas checked
END SUB

'---------------------------------------------------------------------------------------------------------------------------------
FUNCTION MouseHovering (Area AS TYPE_SCREENAREA)

    '+--------------------------------------------------------------------------------+
    '| Returns a value of 1 if the mouse is hovering over the given area, 0 otherwise |
    '+--------------------------------------------------------------------------------+

    MouseHovering = 0 '                          assume mouse not hovering over area
    WHILE _MOUSEINPUT: WEND '                    get latest mouse updates
    IF _MOUSEX >= Area.min.x THEN '              is mouse pointer currently within area limits?
        IF _MOUSEX <= Area.max.x THEN
            IF _MOUSEY >= Area.min.y THEN
                IF _MOUSEY <= Area.max.y THEN
                    MouseHovering = 1 '          yes, report that mouse is hovering this area
                END IF
            END IF
        END IF
    END IF

END FUNCTION

'---------------------------------------------------------------------------------------------------------------------------------
FUNCTION DefineScreenArea (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER, Visible AS INTEGER)

    '+-------------------------------------------------------------+
    '| Defines areas on the screen for the mouse to get trapped in |
    '+-------------------------------------------------------------+

    SHARED ScreenArea() AS TYPE_SCREENAREA ' need access to screen areas

    REDIM _PRESERVE ScreenArea(UBOUND(ScreenArea) + 1) AS TYPE_SCREENAREA ' increase array size
    ScreenArea(UBOUND(ScreenArea)).min.x = x1 '                            set new screen area coordinates
    ScreenArea(UBOUND(ScreenArea)).max.x = x2
    ScreenArea(UBOUND(ScreenArea)).min.y = y1
    ScreenArea(UBOUND(ScreenArea)).max.y = y2
    ScreenArea(UBOUND(ScreenArea)).Visible = Visible '                      set visible status
    DefineScreenArea = UBOUND(ScreenArea) '                                return handle of screen area

END FUNCTION
