OPTION _EXPLICIT

DIM SHARED AS LONG w, h, CANVAS
DIM AS INTEGER x, y

DO:  _LIMIT 60: LOOP UNTIL _SCREENEXISTS
w& = _DESKTOPWIDTH : h& = _DESKTOPHEIGHT 'get display size
w& = 320 : h& = 200 'override for 320x200
CANVAS& = _NEWIMAGE(w&, h&, 13)
SCREEN CANVAS&
_FULLSCREEN _SQUAREPIXELS
_MOUSEHIDE

TYPE CURSOR_OBJ
    W  AS INTEGER
    H  AS INTEGER
    S  AS STRING
    C  AS INTEGER
    OC AS INTEGER
    LC AS INTEGER
    RC AS INTEGER
    MC AS INTEGER
END TYPE

DIM SHARED CURSOR AS CURSOR_OBJ
CURSOR.W%  = 4
CURSOR.H%  = 4
CURSOR.C%  = 15
CURSOR.LC% = 12
CURSOR.RC% = 9
CURSOR.MC% = 11
CURSOR.OC% = CURSOR.C%
IF w& > 640 THEN 
    CURSOR.W% = CURSOR.W% * 2
    CURSOR.H% = CURSOR.H% * 2
END IF

DO:
    CLS
    _LIMIT 60
    WHILE _MOUSEINPUT : WEND
    CURSOR_build
    CURSOR_draw
    _DISPLAY
LOOP UNTIL _KEYHIT=27
_MOUSESHOW
SYSTEM



SUB CURSOR_build ()
    CURSOR.S$ = "C"  + _TRIM$(STR$(CURSOR.C%)) _
            + "D"  + _TRIM$(STR$(CURSOR.H%)) _ 
            + "R"  + _TRIM$(STR$(CURSOR.W%)) _ 
            + "H"  + _TRIM$(STR$(CURSOR.H%)) _ 
            + "B" _
            + "M+" + _TRIM$(STR$(CURSOR.W%\2)) _
            + ",+" + _TRIM$(STR$(CURSOR.H%)) _
            + "F"  + _TRIM$(STR$(CURSOR.W%\2)) _ 
            + "B" _
            + "M-" + _TRIM$(STR$(CURSOR.W%\2)) _
            + ",-" + _TRIM$(STR$(CURSOR.H% - 1)) _
            + "P" _
            + _TRIM$(STR$(CURSOR.C%)) _
            + ","  + _TRIM$(STR$(CURSOR.C%))
END SUB


SUB CURSOR_draw
    DIM s AS STRING
    IF _MOUSEBUTTON(1) THEN 
        CURSOR.C% = CURSOR.LC%
    ELSEIF _MOUSEBUTTON(2) THEN 
        CURSOR.C% = CURSOR.RC%
    ELSEIF _MOUSEBUTTON(3) THEN 
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
