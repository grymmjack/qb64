'$DYNAMIC
OPTION _EXPLICIT
OPTION _EXPLICITARRAY

CONST CHARS = 8
CONST COLS  = 9
CONST ROWS  = 9
CONST BPP2   = 32

' screen setup
DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(COLS * 150, ROWS * 100, BPP2)
SCREEN CANVAS&
_DEST CANVAS&

' glyph data
DIM GD(CHARS) AS STRING
GD$(0) = GD$(0) + "XXXXXXXXX"
GD$(0) = GD$(0) + ".X......."
GD$(0) = GD$(0) + "..X......"
GD$(0) = GD$(0) + "...X....."
GD$(0) = GD$(0) + "....X...."
GD$(0) = GD$(0) + ".....X..."
GD$(0) = GD$(0) + "......X.."
GD$(0) = GD$(0) + ".......X."
GD$(0) = GD$(0) + "XXXXXXXXX"

GD$(1) = GD$(1) + "XXXXXXXXX"
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."
GD$(1) = GD$(1) + "....X...."

GD$(2) = GD$(2) + "....X...."
GD$(2) = GD$(2) + "...X.X..."
GD$(2) = GD$(2) + "..X...X.."
GD$(2) = GD$(2) + ".X.....X."
GD$(2) = GD$(2) + "XXXXXXXXX"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"
GD$(2) = GD$(2) + "X.......X"

GD$(3) = GD$(3) + "XXXXXXXXX"
GD$(3) = GD$(3) + "X......X."
GD$(3) = GD$(3) + "X.....X.."
GD$(3) = GD$(3) + "X....X..."
GD$(3) = GD$(3) + "X...X...."
GD$(3) = GD$(3) + "X..X....."
GD$(3) = GD$(3) + "X.X......"
GD$(3) = GD$(3) + "XX......."
GD$(3) = GD$(3) + "XXXXXXXXX"

GD$(4) = GD$(4) + "XXXXXXXXX"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + "...XXXXXX"
GD$(4) = GD$(4) + "..X......"
GD$(4) = GD$(4) + ".X......."
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"
GD$(4) = GD$(4) + "X........"

GD$(5) = GD$(5) + "XXXXXXXXX"
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "....X...."
GD$(5) = GD$(5) + "XXXXXXXXX"

GD$(6) = GD$(6) + "XXXXXXXXX"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X........"
GD$(6) = GD$(6) + "X..XXXXXX"
GD$(6) = GD$(6) + "X...X...."
GD$(6) = GD$(6) + "X....X..."
GD$(6) = GD$(6) + "X.....X.."
GD$(6) = GD$(6) + "X......X."
GD$(6) = GD$(6) + "XXXXXXXXX"

GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "XXXXXXXXX"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"
GD$(7) = GD$(7) + "X.......X"

GD$(8) = GD$(8) + "XXXXXXXXX"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "....XXXXX"
GD$(8) = GD$(8) + "...X....."
GD$(8) = GD$(8) + "..X......"
GD$(8) = GD$(8) + ".X......."
GD$(8) = GD$(8) + "XXXXXXXXX"

' F0NT UDT
TYPE F0NT
    glyph_width AS INTEGER
    glyph_height AS INTEGER
    char AS STRING
    img AS LONG
END TYPE
DIM STARFIGHTER_FONT(CHARS) AS F0NT
DIM STARFIGHTER_BIG_FONT(CHARS) AS F0NT

' create the glyph images from the glyph data
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

' prepare for output
_DEST CANVAS&
COLOR 0, _RGB32(&H00, &H00, &HAA)
CLS

' test 1
DIM AS INTEGER x, y, scale, kerning, spacing
COLOR &HFFFFFF00
_PRINTSTRING (50, 20), "Testing spacing 0 to 4 with scale = 1"
FOR spacing% = 0 TO 4
    x% = 200 * spacing% + 50: y% = 50: scale% = 1
    CALL F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)
Next
 
' test 2
x% = 50: y% = 100: scale% = 4: kerning% = 0: spacing% = 4
CALL F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)
 
' test 3
x% = 50: y% = 200: scale% = 7: kerning% = 0: spacing% = 2
CALL F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)
 
' test 4
x% = 50: y% = 400: scale% = 8: spacing% = 2
CALL F0NT.print("STARFIGHTER", STARFIGHTER_FONT(), x%, y%, scale%, spacing%)

' scale test
CALL F0NT.scale("STARFIGHTER", STARFIGHTER_FONT(), STARFIGHTER_BIG_FONT(), 10)

' save glyphs to disk
CALL F0NT.save_glyphs_to_disk("STARFIGHTER", STARFIGHTER_BIG_FONT())

' cleanup
CALL F0NT.free(STARFIGHTER_FONT())
CALL F0NT.free(STARFIGHTER_BIG_FONT())



''
' Free the font glyph images from memory
'
' @param F0NT ARRAY f()
' 
SUB F0NT.free(f() AS F0NT)
    DIM AS INTEGER i, lb, ub
    lb% = LBOUND(f) : ub% = UBOUND(f)
    FOR i% = lb% TO ub%
        _FREEIMAGE f(i%).img&
    NEXT i%
END SUB


''
' Copies the source font to the dest font
'
' @param F0NT ARRAY sf() source font
' @param F0NT ARRAY df() dest font
'
SUB F0NT.copy(sf() AS F0NT, df() AS F0NT)
    DIM AS INTEGER i, lb, ub
    lb% = LBOUND(sf) : ub% = UBOUND(sf)
    REDIM df(lb% TO ub%) AS F0NT
    FOR i% = lb% TO ub%
        df(i%).char$ = sf(i%).char$
        df(i%).img&  = sf(i%).img&
    NEXT i%
END SUB


''
' Save glyphs of a font to disk
'
' @param STRING s$ characters to save
' @param F0NT ARRAY f()
' @param STRING dest_dir$
'
SUB F0NT.save_glyphs_to_disk(s$, f() AS F0NT)
    DIM AS INTEGER i, lb, ub
    lb% = LBOUND(f) : ub% = UBOUND(f)
    FOR i% = lb% TO ub%
        IF f(i%).char$ = CHR$(ASC(s$, i%+1)) THEN
            CALL SaveImage(f(i%).img&, f(i%).char$)
        END IF
    NEXT i%
END SUB


''
' Make a glyph from glyph data and store it in F0NT
'
' @param STRING c$ glyph character identifier
' @param F0NT ARRAY f() 
' @param STRING ARRAY glyph_data$() 
' @param LONG kolor& to make glyphs
' 
SUB F0NT.make_glyph(c$, f AS F0NT, glyph_data$, kolor&)
    DIM AS INTEGER y, x, p, dbg
    DIM s AS STRING
    DIM old_dest AS LONG
    ' dbg% = -1
    f.char$ = c$
    IF dbg% THEN PRINT c$
    f.img&  = _NEWIMAGE(COLS, ROWS, BPP2)
    old_dest& = _DEST : _DEST f.img&
    _CLEARCOLOR _RGB32(&H00, &H00, &H00)
    FOR y% = 0 TO ROWS
        FOR x% = 0 TO COLS
            p% = (y% * COLS) + x% + 1
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


''
' Get a glyph image from a F0NT by character identifier
'
' @param STRING c$ character identifier of glyph to get
' @param F0NT ARRAY f()
' @return LONG image handle for glyph image of F0NT
'
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


''
' Print something using a F0NT
'
' @param STRING s$ what to print
' @param F0NT ARRAY f()
' @param INTEGER x% position
' @param INTEGER y% position
' @param INTEGER scale% size multiplier
' @param INTEGER spacing% spaces between characters
'
SUB F0NT.print(s$, f() As F0NT, x%, y%, scale%, spacing%)
    DIM AS INTEGER i, l, dx1, dy1, dx2, dy2, orig_x
    DIM c AS STRING
    DIM g AS LONG
    l% = LEN(s$)
    FOR i% = 1 TO l%
        c$ = MID$(s$, i%, 1)
        dx1% = x% + (i% - 1) * (COLS + spacing%) * scale%
        dy1% = y%
        _PUTIMAGE (dx1%, dy1%)-STEP(COLS * scale% - 1, ROWS * scale% - 1), F0NT.get_glyph(c$, f())
    NEXT i%
END SUB


''
' Scales a source F0NT glyphs images and stores into dest F0NT
'
' @param STRING s$ Glyphs to scale
' @param F0NT ARRAY sf() source font
' @param F0NT ARRAY df() dest font
' @param INTEGER scale% multiplier
'
SUB F0NT.scale(s$, sf() AS F0NT, df() AS F0NT, scale%)
    DIM AS INTEGER i, lb, ub, dx1, dy1, dx2, dy2
    DIM AS LONG sg, dg, old_dest
    CALL F0NT.copy(sf(), df())
    lb% = LBOUND(sf) : ub% = UBOUND(sf)
    old_dest& = _DEST
    FOR i% = lb% TO ub%
        dx1%  = 0
        dy1%  = 0
        dx2%  = (COLS * scale%) + dx1%
        dy2%  = (ROWS * scale%) + dy1%
        df(i%).img& = _NEWIMAGE(dx2%, dy2%, BPP2)
        _SOURCE sf(i%).img& : _DEST df(i%).img&
        _PUTIMAGE (dx1%, dy1%)-(dx2%, dy2%)
    NEXT i%
    _DEST old_dest&
END SUB


''
' Save image to disk as filename by Galleon
'
' @param LONG image& to save to disk
' @param STRING filename$ to save as
'
SUB SaveImage (image&, filename$)
    DIM AS LONG f, c, cv, x, y, py, px, lastsource, bpp, bytesperpixel
    DIM AS STRING b, d, ext, padder, r
    bytesperpixel& = _PIXELSIZE(image&)
    IF bytesperpixel& = 0 THEN PRINT "Text modes unsupported!": EXIT SUB
    IF bytesperpixel& = 1 THEN bpp& = 8 ELSE bpp& = 24
    x& = _WIDTH(image&)
    y& = _HEIGHT(image&)
    b$="BM????QB64????"+MKL$(40)+MKL$(x&)+MKL$(y&)+MKI$(1)+MKI$(bpp&)+MKL$(0)+"????"+STRING$(16, 0) 'partial BMP header info(???? to be filled later)
    IF bytesperpixel& = 1 THEN
        FOR c& = 0 TO 255 ' read BGR color settings from JPG image + 1 byte spacer(CHR$(0))
            cv& = _PALETTECOLOR(c&, image&) ' color attribute to read. 
            b$ = b$ +CHR$(_BLUE32(cv&))+CHR$(_GREEN32(cv&))+CHR$(_RED32(cv&))+CHR$(0) 'spacer byte
        NEXT
    END IF
    MID$(b$, 11, 4) = MKL$(LEN(b$)) ' image pixel data offset(BMP header)
    lastsource& = _SOURCE
    _SOURCE image&
    IF ((x& * 3) MOD 4) THEN padder$ = STRING$(4 - ((x& * 3) MOD 4), 0)
    FOR py& = y& - 1 TO 0 STEP -1 ' read JPG image pixel color data 
        r$ = ""
        FOR px& = 0 TO x& - 1
            c& = POINT(px&, py&) 'POINT 32 bit values are large LONG values 
            IF bytesperpixel& = 1 THEN r$ = r$ + CHR$(c&) ELSE r$ = r$ + LEFT$(MKL$(c&), 3)
        NEXT px&  
        d$ = d$ + r$ + padder$
    NEXT py&
    _SOURCE lastsource&
    MID$(b$, 35, 4) = MKL$(LEN(d$)) ' image size(BMP header)
    b$ = b$ + d$ ' total file data bytes to create file
    MID$(b$, 3, 4) = MKL$(LEN(b$)) ' size of data file(BMP header)
    IF LCASE$(RIGHT$(filename$, 4)) <> ".bmp" THEN ext$ = ".bmp"
    f& = FREEFILE
    OPEN filename$ + ext$ FOR OUTPUT AS #f&: CLOSE #f& ' erases an existing file
    OPEN filename$ + ext$ FOR BINARY AS #f&
    PUT #f&,,b$
    CLOSE #f&
END SUB
