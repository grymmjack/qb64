CONST CHARS = 8
CONST COLS  = 9
CONST ROWS  = 9
CONST BPP   = 32

DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(1280, 720, 32)
SCREEN CANVAS&
_DEST CANVAS&

DIM SHARED GD(CHARS) AS STRING

         GD$(0) = "XXXXXXXXX"
GD$(0) = GD$(0) + ".X......."
GD$(0) = GD$(0) + "..X......"
GD$(0) = GD$(0) + "...X....."
GD$(0) = GD$(0) + "....X...."
GD$(0) = GD$(0) + ".....X..."
GD$(0) = GD$(0) + "......X.."
GD$(0) = GD$(0) + ".......X."
GD$(0) = GD$(0) + "XXXXXXXXX"

         GD$(1) = "XXXXXXXXX"
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."

         GD$(2) = "....X...."
GD$(2) = GD$(2) + "...XXX..."
GD$(2) = GD$(2) + "..X...X.."
GD$(2) = GD$(2) + ".X.....X."
GD$(2) = GD$(2) + "XXXXXXXXX"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"

         GD$(3) = "XXXXXXXXX"
GD$(3) = GD$(3) + "X......X."
GD$(3) = GD$(3) + "X.....X.."
GD$(3) = GD$(3) + "X....X..."
GD$(3) = GD$(3) + "X...X...."
GD$(3) = GD$(3) + "X..X....."
GD$(3) = GD$(3) + "X.X......"
GD$(3) = GD$(3) + "XX......."
GD$(3) = GD$(3) + "XXXXXXXXX"

         GD$(4) = "XXXXXXXXX"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + "...XXXXXX"
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"

         GD$(5) = "XXXXXXXXX"
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "XXXXXXXXX"

         GD$(6) = "XXXXXXXXX"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X..XXXXXX"
GD$(6) = GD$(6) + "X...X...."
GD$(6) = GD$(6) + "X....X..."
GD$(6) = GD$(6) + "X.....X.."
GD$(6) = GD$(6) + "X......X."
GD$(6) = GD$(6) + "XXXXXXXXX"

         GD$(7) = "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "XXXXXXXXX"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"

         GD$(8) = "XXXXXXXXX"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "....XXXXX"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "XXXXXXXXX"

TYPE F0NT
    char AS STRING
    img AS LONG
END TYPE
DIM SHARED STARFIGHTER_FONT(CHARS) AS F0NT

DIM kolor AS LONG
kolor& = _RGB32(&HFF, &HFF, &HFF)
CALL F0NT.make_glyph("S", STARFIGHTER_FONT(0), GD$(0), kolor&)
CALL F0NT.make_glyph("T", STARFIGHTER_FONT(1), GD$(1), kolor&)
CALL F0NT.make_glyph("A", STARFIGHTER_FONT(2), GD$(2), kolor&)
CALL F0NT.make_glyph("R", STARFIGHTER_FONT(3), GD$(3), kolor&)
CALL F0NT.make_glyph("F", STARFIGHTER_FONT(4), GD$(4), kolor&)
CALL F0NT.make_glyph("I", STARFIGHTER_FONT(5), GD$(5), kolor&)
CALL F0NT.make_glyph("G", STARFIGHTER_FONT(6), GD$(6), kolor&)
CALL F0NT.make_glyph("H", STARFIGHTER_FONT(7), GD$(7), kolor&)
CALL F0NT.make_glyph("E", STARFIGHTER_FONT(8), GD$(8), kolor&)

_DEST CANVAS&
DIM AS INTEGER x, y, scale, kerning, spacing
x% = 0 : y% = 0 : scale% = 4 : kerning% = 0 : spacing% = 1
CALL F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, kerning%, spacing%)

SUB F0NT.make_glyph(c$, f AS F0NT, glyph_data$, kolor&)
    DIM AS INTEGER y, x, p, dbg
    DIM s AS STRING
    DIM old_dest AS LONG
    ' dbg% = -1
    f.char$ = c$
    IF dbg% THEN PRINT c$
    f.img&  = _NEWIMAGE(COLS, ROWS, BPP)
    old_dest& = _DEST : _DEST f.img&
    _CLEARCOLOR _RGB32(&H00, &H00, &H00)
    FOR y% = 0 TO ROWS
        FOR x% = 0 TO COLS
            p% = (y% * COLS) + x%+1
            s$ = MID$(glyph_data$, p%, 1)
            IF dbg% THEN
                _DEST old_dest& : PRINT s$; : _DEST f.img&
            END IF
            IF s$ <> "." THEN
                CALL PSET((x%, y%), kolor&)
            END IF            
        NEXT x%
        IF dbg% THEN
            _DEST old_dest& : PRINT : _DEST f.img&
        END IF
    NEXT y%
    IF dbg% THEN SLEEP
    _DEST old_dest&
END SUB


FUNCTION F0NT.get_glyph&(c$, f() AS F0NT)
    DIM AS INTEGER i, lb, ub
    lb% = LBOUND(f) : ub% = UBOUND(f)
    FOR i% = lb% TO ub%
        IF f(i%).char$ = c$ THEN
            F0NT.get_glyph& = f(i%).img&
            EXIT FUNCTION
        END IF
    NEXT i%
END FUNCTION


SUB F0NT.print(s$, f() AS F0NT, x%, y%, scale%, kerning%, spacing%)
    DIM AS INTEGER i, l, dx1, dy1, dx2, dy2
    DIM c AS STRING
    DIM g AS LONG
    l% = LEN(s$)
    PSET (x%, y%)
    FOR i% = 0 TO l%
        c$ = MID$(s$, i%, 1)
        g& = F0NT.get_glyph(c$, f()) 
        _SOURCE g&
        dx1%  = (i% * (COLS * scale%)) + (i% * (spacing% * COLS))
        dy1%  = y%
        dx2%  = (COLS * scale%) + dx1%
        dy2%  = (ROWS * scale%) + dy1%
        _PUTIMAGE (dx1%, dy1%)-(dx2%, dy2%)
    NEXT i%
END SUB