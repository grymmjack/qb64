$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    $LET TRUE = TRUE
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

OPTION _EXPLICIT
$CONSOLE
CONST KEY_CAPSLOCK& = 100301

DIM SHARED AS LONG w, h, k, CANVAS, PAINTING, GUI
DIM SHARED AS INTEGER PAINT_COLOR
DIM AS INTEGER x, y
PAINT_COLOR% = 4

DO:  _LIMIT 60: LOOP UNTIL _SCREENEXISTS
w& = _DESKTOPWIDTH : h& = _DESKTOPHEIGHT 'get display size
w& = 320 : h& = 200 'override for 320x200
CANVAS& = _NEWIMAGE(w&, h&, 13)
PAINTING& = _NEWIMAGE(w&, h&, 13)
GUI& = _NEWIMAGE(w&, h&, 13)
SCREEN CANVAS&
' _FULLSCREEN _SQUAREPIXELS
_MOUSEHIDE

TYPE MOUSE_OBJ
    X     AS INTEGER
    Y     AS INTEGER
    OLD_X AS INTEGER
    OLD_Y AS INTEGER
    B1    AS INTEGER
    B2    AS INTEGER
    B3    AS INTEGER
    SW    AS INTEGER
    MOVED AS INTEGER
END TYPE
DIM SHARED MOUSE AS MOUSE_OBJ
MOUSE.X%     = 1
MOUSE.Y%     = 1
MOUSE.OLD_X% = 1
MOUSE.OLD_Y% = 1
MOUSE.B1%    = FALSE
MOUSE.B2%    = FALSE
MOUSE.B3%    = FALSE
MOUSE.MOVED% = FALSE
_MOUSEMOVE MOUSE.X%, MOUSE.Y%

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
    k& = _KEYHIT
    _LIMIT 60
    DO WHILE _MOUSEINPUT:
        IF MOUSE.X% <> _MOUSEX OR MOUSE.Y% <> _MOUSEY THEN
            MOUSE.X% = _MOUSEX : MOUSE.Y% = _MOUSEY
            MOUSE.MOVED% = TRUE
        ELSE
            MOUSE.MOVED% = FALSE
        END IF
        MOUSE.B1% = _MOUSEBUTTON(1)
        MOUSE.B2% = _MOUSEBUTTON(2)
        MOUSE.B3% = _MOUSEBUTTON(3)
        MOUSE.SW% = _MOUSEWHEEL
        PAINT_COLOR% = PAINT_COLOR% + -MOUSE.SW%
        IF PAINT_COLOR% > 15 THEN PAINT_COLOR% = 15
        IF PAINT_COLOR% < 0 THEN PAINT_COLOR% = 0
    LOOP
    CURSOR.C% = PAINT_COLOR%
    SCREEN_draw
    IF MOUSE.MOVED% THEN
        MOUSE.OLD_X% = MOUSE.X% : MOUSE.OLD_Y% = MOUSE.Y%
    END IF
LOOP UNTIL k&=27
_MOUSESHOW
SYSTEM


SUB POINTER_draw
    CURSOR_build
    CURSOR_draw
END SUB


' todo get status to hide when painting 
SUB SCREEN_draw
    CLS
    IF NOT ((MOUSE.Y% >= h& - _FONTHEIGHT + 1) AND (MOUSE.B1%)) THEN
        STATUS_draw
    ELSE
        STATUS_draw
    END IF
    _DEST CANVAS& :_SOURCE PAINTING& : _PUTIMAGE
    IF _KEYDOWN(KEY_CAPSLOCK&) THEN CROSSHAIR_draw 8
    _DEST CANVAS& :_SOURCE GUI& : _PUTIMAGE
    IF MOUSE.B1% THEN PAINT_on
    IF MOUSE.B2% THEN PAINT_clear
    POINTER_draw
    _DISPLAY
END SUB


SUB PAINT_on
    _DEST PAINTING&
    IF MOUSE.MOVED% THEN
        _ECHO "(MOUSE.OLD_X%, MOUSE.OLD_Y%)-(MOUSE.X%, MOUSE.Y%), PAINT_COLOR%"
        LINE (MOUSE.OLD_X%, MOUSE.OLD_Y%)-(MOUSE.X%, MOUSE.Y%), PAINT_COLOR%
    ELSE
        PSET (MOUSE.X%, MOUSE.Y%), PAINT_COLOR%
    END IF
    _DEST CANVAS&
END SUB


SUB PAINT_clear
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
    ' Draw Y bar - top to bottom
    LINE (MOUSE.X%, 1)-(MOUSE.X%, h&), kolor%, , &B0101010101010101
    ' Draw X bar - left to right
    LINE (1, MOUSE.Y%)-(w&, MOUSE.Y%), kolor%, , &B0101010101010101 
    s$  = " " + _TRIM$(STR$(MOUSE.X%)) + "," + _TRIM$(STR$(MOUSE.Y%)) + " "
    pw% = _PRINTWIDTH(s$)
    ph% = _FONTHEIGHT
    IF MOUSE.X% > (w& - pw%) THEN px% = w& - pw% ELSE px% = MOUSE.X%
    IF MOUSE.Y% > (h& - ph%) THEN py% = h& - ph% ELSE py% = MOUSE.Y%
    _PRINTSTRING(px%, py%), s$
END SUB


SUB STATUS_draw
    DIM s AS STRING
    DIM AS INTEGER px, py, pw, ph
    s$ = " COLOR "
    pw% = _PRINTWIDTH(s$)
    ph% = _FONTHEIGHT + 1
    px% = 1 : py% = h& - ph%+1
    _DEST GUI&
    _PALETTECOLOR 17, _RGB(0, 0, 0)
    _CLEARCOLOR 0
    LINE (1, h& - ph%)-(w&, h&), 8, BF
    COLOR 17, 8
    _PRINTSTRING(px%, py%), s$
    LINE (px% + pw%, py%)-(px% + pw% + 4, py% + 6), 17, B
    LINE (px% + pw%+1, py%+1)-(px% + pw% + 3, py% + 5), PAINT_COLOR%, BF
END SUB
