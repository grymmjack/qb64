$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    $LET TRUE = TRUE
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

OPTION _EXPLICIT
$CONSOLE

CONST KEY_CAPSLOCK& = 100301
CONST KEY_RSHIFT&   = 100303 
CONST KEY_LSHIFT&   = 100304

DIM AS INTEGER x, y
DIM SHARED AS LONG w, h, k, CANVAS, PAINTING, GUI
DIM SHARED AS INTEGER WHEEL_COLOR, KEY_COLOR, PAINT_COLOR
DIM SHARED AS INTEGER CONSTRAIN_X, CONSTRAIN_Y
CONSTRAIN_X% = FALSE : CONSTRAIN_Y% = FALSE
PAINT_COLOR% = 4 : WHEEL_COLOR% = FALSE : KEY_COLOR% = FALSE

DO:  _LIMIT 60: LOOP UNTIL _SCREENEXISTS
w& = _DESKTOPWIDTH : h& = _DESKTOPHEIGHT 'get display size
w& = 320 : h& = 200 'override for 320x200
CANVAS& = _NEWIMAGE(w&, h&, 13)
PAINTING& = _NEWIMAGE(w&, h&, 13)
GUI& = _NEWIMAGE(w&, h&, 13)
SCREEN CANVAS&
_FULLSCREEN _SQUAREPIXELS
_MOUSEHIDE

TYPE MOUSE_OBJ
    X     AS INTEGER
    Y     AS INTEGER
    OLD_X AS INTEGER
    OLD_Y AS INTEGER
    CON_X AS INTEGER
    CON_Y AS INTEGER
    B1    AS INTEGER
    B2    AS INTEGER
    B3    AS INTEGER
    OSW   AS INTEGER
    SW    AS INTEGER
    DRAG  AS STRING
END TYPE
DIM SHARED MOUSE AS MOUSE_OBJ
MOUSE.X%     = 1
MOUSE.Y%     = 1
MOUSE.OLD_X% = 1
MOUSE.OLD_Y% = 1
MOUSE.CON_X% = 0
MOUSE.CON_Y% = 0
MOUSE.OSW%   = 0
MOUSE.B1%    = FALSE
MOUSE.B2%    = FALSE
MOUSE.B3%    = FALSE
MOUSE.DRAG$  = ""

TYPE CURSOR_OBJ
    W  AS INTEGER
    H  AS INTEGER
    S  AS STRING
    C  AS INTEGER
    O  AS INTEGER 'outline
    OC AS INTEGER
    LC AS INTEGER
    RC AS INTEGER
    MC AS INTEGER
END TYPE

DIM SHARED CURSOR AS CURSOR_OBJ
CURSOR.W%  = 4
CURSOR.H%  = 4
CURSOR.C%  = 15
CURSOR.O%  = 7
CURSOR.LC% = 12
CURSOR.RC% = 9
CURSOR.MC% = 11
CURSOR.OC% = CURSOR.C%
IF w& > 640 THEN 
    CURSOR.W% = CURSOR.W% * 2
    CURSOR.H% = CURSOR.H% * 2
END IF

DO:   
    WHILE _MOUSEINPUT:
        MOUSE.X%  = _MOUSEX
        MOUSE.Y%  = _MOUSEY
        MOUSE.B1% = _MOUSEBUTTON(1)
        MOUSE.B2% = _MOUSEBUTTON(2)
        MOUSE.B3% = _MOUSEBUTTON(3)
        IF MOUSE.B1% THEN
            IF MOUSE.X% < MOUSE.OLD_X% THEN MOUSE.DRAG$ = "L"
            IF MOUSE.X% > MOUSE.OLD_X% THEN MOUSE.DRAG$ = "R"
            IF MOUSE.Y% < MOUSE.OLD_Y% THEN MOUSE.DRAG$ = "U"
            IF MOUSE.Y% > MOUSE.OLD_Y% THEN MOUSE.DRAG$ = "D"
            PAINT_on
        ELSE
            MOUSE.DRAG$ = ""
            MOUSE.CON_X% = 0 : MOUSE.CON_Y% = 0
            CONSTRAIN_X% = FALSE : CONSTRAIN_Y% = FALSE
        END IF
        IF MOUSE.B2% THEN PAINT_clear
        IF MOUSE.SW% <> MOUSE.OSW% THEN
            IF NOT KEY_COLOR% THEN
                PAINT_COLOR% = PAINT_COLOR% + -MOUSE.SW%
                WHEEL_COLOR% = TRUE
                KEY_COLOR%   = FALSE
                MOUSE.OSW% = MOUSE.SW%
            END IF
        END IF
        MOUSE.SW% = _MOUSEWHEEL

        ' DO: LOOP UNTIL _MOUSEINPUT = 0

        IF _KEYDOWN(KEY_CAPSLOCK&) AND NOT CONSTRAIN_X% AND NOT CONSTRAIN_Y% THEN
            IF MOUSE.DRAG$ = "L" OR MOUSE.DRAG$ = "R" THEN
                MOUSE.CON_Y% = MOUSE.Y%
                CONSTRAIN_X% = FALSE
                CONSTRAIN_Y% = TRUE
            ELSEIF MOUSE.DRAG$ = "U" OR MOUSE.DRAG$ = "D" THEN
                MOUSE.CON_X% = MOUSE.X%
                CONSTRAIN_X% = TRUE
                CONSTRAIN_Y% = FALSE
            END IF
        END IF
    WEND
    
    k& = _KEYHIT

    _LIMIT 60

    KEYS_color
    CURSOR.C% = PAINT_COLOR%
    SCREEN_draw
    IF PAINT_COLOR% > 15 THEN PAINT_COLOR% = 15
    IF PAINT_COLOR% < 0  THEN PAINT_COLOR% = 0
    MOUSE.OLD_X% = MOUSE.X% : MOUSE.OLD_Y% = MOUSE.Y%
LOOP UNTIL k&=27
_MOUSESHOW
SYSTEM


SUB KEYS_color ()
    DIM keypress AS STRING
    keypress$ = INKEY$
    SELECT CASE keypress$
        CASE "0": PAINT_COLOR% = 0
        CASE "1": PAINT_COLOR% = 1
        CASE "2": PAINT_COLOR% = 2
        CASE "3": PAINT_COLOR% = 3
        CASE "4": PAINT_COLOR% = 4
        CASE "5": PAINT_COLOR% = 5
        CASE "6": PAINT_COLOR% = 6
        CASE "7": PAINT_COLOR% = 7
        CASE "8": PAINT_COLOR% = 8
        CASE "9": PAINT_COLOR% = 9
        CASE "!": PAINT_COLOR% = 9
        CASE "@": PAINT_COLOR% = 10
        CASE "#": PAINT_COLOR% = 11
        CASE "$": PAINT_COLOR% = 12
        CASE "%": PAINT_COLOR% = 13
        CASE "^": PAINT_COLOR% = 14
        CASE "&": PAINT_COLOR% = 15
        EVERYCASE:
            KEY_COLOR%   = TRUE 
            WHEEL_COLOR% = FALSE
    END SELECT
END SUB


SUB POINTER_draw ()
    CURSOR_build
    CURSOR_draw
END SUB


' todo get status to hide when painting 
SUB SCREEN_draw ()
    CLS
    STATUS_draw
    _DEST CANVAS& :_SOURCE PAINTING& : _PUTIMAGE
    IF _KEYDOWN(KEY_CAPSLOCK&) THEN CROSSHAIR_draw 8
    _DEST CANVAS& :_SOURCE GUI& : _PUTIMAGE
    POINTER_draw
    _DISPLAY
END SUB


SUB PAINT_on ()
    _DEST PAINTING&
    IF CONSTRAIN_X% THEN
        LINE (MOUSE.CON_X%, MOUSE.OLD_Y%)-(MOUSE.CON_X%, MOUSE.Y%), PAINT_COLOR%
    ELSEIF CONSTRAIN_Y% THEN
        LINE (MOUSE.OLD_X%, MOUSE.CON_Y%)-(MOUSE.X%, MOUSE.CON_Y%), PAINT_COLOR%
    ELSE
        LINE (MOUSE.OLD_X%, MOUSE.OLD_Y%)-(MOUSE.X%, MOUSE.Y%), PAINT_COLOR%
    END IF
    _DEST CANVAS&
END SUB


SUB PAINT_clear ()
    _DEST PAINTING&
    CLS
    _DEST CANVAS&
END SUB


SUB CURSOR_build ()
    CURSOR.S$ = "C"  + _TRIM$(STR$(CURSOR.O%)) _
              + "D"  + _TRIM$(STR$(CURSOR.H%)) _ 
              + "R"  + _TRIM$(STR$(CURSOR.W%)) _ 
              + "H"  + _TRIM$(STR$(CURSOR.H%)) _ 
              + "B" _
              + "M+" + _TRIM$(STR$(CURSOR.W%\2)) _
              + ",+" + _TRIM$(STR$(CURSOR.H%)) _
              + "F"  + _TRIM$(STR$(CURSOR.W%\2))
    IF CURSOR.C% <> 0 THEN 'fill cursor 0 else color is black keep outline
        CURSOR.S$ = CURSOR.S$ _
                  + "B" _
                  + "M-" + _TRIM$(STR$(CURSOR.W%\2)) _
                  + ",-" + _TRIM$(STR$(CURSOR.H% - 1)) _
                  + "P"  + _TRIM$(STR$(CURSOR.C%)) _
                  + ","  + _TRIM$(STR$(CURSOR.O%))
    END IF
END SUB


SUB CURSOR_draw ()
    DIM s AS STRING
    IF MOUSE.B1% THEN 
        CURSOR.C% = CURSOR.LC%
    ELSEIF MOUSE.B2% THEN 
        CURSOR.C% = CURSOR.RC%
    ELSEIF MOUSE.B3% THEN 
        CURSOR.C% = CURSOR.MC%
    ELSE 
        CURSOR.C% = CURSOR.OC%
    END IF

    s$ = "B" _
       + "M" _
       + _TRIM$(STR$(_MOUSEX)) _
       + "," _
       + _TRIM$(STR$(_MOUSEY)) _
       + CURSOR.S$
    DRAW s$
END SUB


SUB CROSSHAIR_draw (kolor%)
    DIM s AS STRING
    DIM AS INTEGER px, py, pw, ph
    s$ = " " + _TRIM$(STR$(MOUSE.X%)) + "," + _TRIM$(STR$(MOUSE.Y%)) + " "
    IF CONSTRAIN_X% THEN
        ' Draw Y bar - top to bottom
        LINE (MOUSE.CON_X%, 1)-(MOUSE.CON_X%, h&), kolor%, , &B0101010101010101
        s$ = " " + _TRIM$(STR$(MOUSE.CON_X%)) + "," + _TRIM$(STR$(MOUSE.Y%)) + " "
    ELSE
        LINE (MOUSE.X%, 1)-(MOUSE.X%, h&), kolor%, , &B0101010101010101
        s$ = " " + _TRIM$(STR$(MOUSE.X%)) + "," + _TRIM$(STR$(MOUSE.Y%)) + " "
    END IF
    IF CONSTRAIN_Y% THEN
        ' Draw X bar - left to right
        LINE (1, MOUSE.CON_Y%)-(w&, MOUSE.CON_Y%), kolor%, , &B0101010101010101
        s$ = " " + _TRIM$(STR$(MOUSE.X%)) + "," + _TRIM$(STR$(MOUSE.CON_Y%)) + " "
    ELSE
        LINE (1, MOUSE.Y%)-(w&, MOUSE.Y%), kolor%, , &B0101010101010101
    END IF
    pw% = _PRINTWIDTH(s$)
    ph% = _FONTHEIGHT
    IF MOUSE.X% > (w& - pw%) THEN px% = w& - pw% ELSE px% = MOUSE.X%
    IF MOUSE.Y% > (h& - ph%) THEN py% = h& - ph% ELSE py% = MOUSE.Y%
    _PRINTSTRING(px%, py%), s$
END SUB


SUB STATUS_draw ()
    DIM s AS STRING
    DIM AS INTEGER px, py, pw, ph
    s$ = " COLOR "
    pw% = _PRINTWIDTH(s$)
    ph% = _FONTHEIGHT + 1
    px% = 0 : py% = h& - ph%+1
    s$ = s$ + "  " + n$(MOUSE.X%) + "," + n$(MOUSE.Y%)
    IF MOUSE.B1% THEN s$ = s$ + " B1"
    IF MOUSE.B2% THEN s$ = s$ + " B2"
    IF MOUSE.B3% THEN s$ = s$ + " B3"
    IF _KEYDOWN(KEY_CAPSLOCK&) THEN s$ = s$ + " " + CHR$(30)
    ' IF MOUSE.DRAG$ <> "" THEN s$ = s$ + " D" + MOUSE.DRAG$
    ' s$ = s$ + " " + n$(MOUSE.CON_X%) + "," + n$(MOUSE.CON_Y%)
    IF CONSTRAIN_X% THEN s$ = s$ + " CX"
    IF CONSTRAIN_Y% THEN s$ = s$ + " CY"
    _DEST GUI&
    _PALETTECOLOR 17, _RGB(0, 0, 0)
    _CLEARCOLOR 0
    LINE (0, h& - ph%)-(w&, h&), 8, BF
    COLOR 17, 8
    _PRINTSTRING(px%, py%), s$
    LINE (px% + pw%, py%)-(px% + pw% + 4, py% + 6), 17, B
    LINE (px% + pw%+1, py%+1)-(px% + pw% + 3, py% + 5), PAINT_COLOR%, BF
END SUB


FUNCTION n$ (v%)
    n$ = _TRIM$(STR$(v%))
END FUNCTION