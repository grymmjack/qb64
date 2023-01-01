''
' DDPATTERN - Load, display, and save DazzleDraw pattern data
' =============================================================================
' DazzleDraw is an Apple ][ drawing program released in 1985. There are some
' really neat patterns that it had, and I wanted to get them out of there and
' share them with others.
'
' Big thanks to the gents in Dark Theme Logic and QB64-PE Discords: 
' - SMcNeill, Sprezzo, keybone - you guys are the best.
'
' @author Rick Christy <grymmjack@gmail.com> 
'

DIM SHARED CANVAS AS LONG
CANVAS& = _NEWIMAGE(800, 1000, 32)
SCREEN CANVAS&
_TITLE "DDPATTERN"

CONST NUM_COLORS_IN_PALETTE = 15
CONST NUM_PATTERNS_IN_FILE  = 30
CONST NUM_ROWS_IN_PATTERN   = 8
CONST NUM_COLS_IN_PATTERN   = 8
CONST PATTERN_CELL_W        = 2
CONST PATTERN_CELL_H        = 2
CONST NUM_PATTERN_GRID_X    = 6
CONST NUM_PATTERN_GRID_Y    = 2

TYPE APPLE2_COLOR_PALETTE
    AS _UNSIGNED LONG BLACK, GRAY1, DBLUE, PURPLE, RED, ORANGE, PINK, YELLOW
    AS _UNSIGNED LONG GRAY2, DGREEN, BROWN, LGREEN, AQUA, MBLUE, LBLUE, WHITE
END TYPE
DIM SHARED A2_C AS APPLE2_COLOR_PALETTE
DIM SHARED A2_CN(0 TO NUM_COLORS_IN_PALETTE) AS _UNSIGNED LONG
A2_C.BLACK  = _RGB32(0, 0, 0)       : A2_CN(0)  = A2_C.BLACK
A2_C.GRAY1  = _RGB32(82, 82, 82)    : A2_CN(5)  = A2_C.GRAY1
A2_C.DBLUE  = _RGB32(0, 0, 163)     : A2_CN(1)  = A2_C.DBLUE
A2_C.PURPLE = _RGB32(206, 47, 214)  : A2_CN(9)  = A2_C.PURPLE
A2_C.RED    = _RGB32(206, 8, 45)    : A2_CN(8)  = A2_C.RED
A2_C.ORANGE = _RGB32(255, 101, 0)   : A2_CN(12) = A2_C.ORANGE
A2_C.PINK   = _RGB32(255, 158, 154) : A2_CN(13) = A2_C.PINK
A2_C.YELLOW = _RGB32(255, 255, 0)   : A2_CN(14) = A2_C.YELLOW
A2_C.GRAY2  = _RGB32(173, 173, 173) : A2_CN(10) = A2_C.GRAY2
A2_C.DGREEN = _RGB32(5, 99, 43)     : A2_CN(2)  = A2_C.DGREEN
A2_C.BROWN  = _RGB32(157, 100, 0)   : A2_CN(4)  = A2_C.BROWN
A2_C.LGREEN = _RGB32(24, 222, 0)    : A2_CN(6)  = A2_C.LGREEN
A2_C.AQUA   = _RGB32(57, 255, 142)  : A2_CN(7)  = A2_C.AQUA
A2_C.MBLUE  = _RGB32(40, 42, 255)   : A2_CN(3)  = A2_C.MBLUE
A2_C.LBLUE  = _RGB32(96, 155, 255)  : A2_CN(11) = A2_C.LBLUE
A2_C.WHITE  = _RGB32(255, 255, 255) : A2_CN(15) = A2_C.WHITE

DIM DAZZLEDRAW_PATTERNS_1(1 TO NUM_PATTERNS_IN_FILE) AS STRING * 64
DIM DAZZLEDRAW_PATTERNS_2(1 TO NUM_PATTERNS_IN_FILE) AS STRING * 64
DIM DAZZLEDRAW_PATTERNS_3(1 TO NUM_PATTERNS_IN_FILE) AS STRING * 64
DIM DAZZLEDRAW_PATTERNS_4(1 TO NUM_PATTERNS_IN_FILE) AS STRING * 64

load_dazzledraw_pattern_file "ORIG.PATTERNS.bin", DAZZLEDRAW_PATTERNS_1()
load_dazzledraw_pattern_file "MIXED.COLORS.bin",  DAZZLEDRAW_PATTERNS_2()
load_dazzledraw_pattern_file "B.W.PATTERNS1.bin", DAZZLEDRAW_PATTERNS_3()
load_dazzledraw_pattern_file "B.W.PATTERNS2.bin", DAZZLEDRAW_PATTERNS_4()

render_dazzledraw_pattern_column DAZZLEDRAW_PATTERNS_1(), 1, "ORIG.PATTERNS.bin"
render_dazzledraw_pattern_column DAZZLEDRAW_PATTERNS_2(), 2, "MIXED.COLORS.bin"
render_dazzledraw_pattern_column DAZZLEDRAW_PATTERNS_3(), 3, "B.W.PATTERNS1.bin"
render_dazzledraw_pattern_column DAZZLEDRAW_PATTERNS_4(), 4, "B.W.PATTERNS2.bin"



''
' Loads pattern data from a DazzleDraw pattern file
' The pattern file is taken from the DSK image and is binary
' @param STRING pattern_file$ on disk
' @param ARRAY of STRING * 64 pattern_data 
' 
SUB load_dazzledraw_pattern_file (pattern_file$, pattern_data() AS STRING * 64)
    DIM header AS STRING * 76
    DIM i AS INTEGER
    DIM f AS LONG
    f& = FREEFILE
    OPEN pattern_file$ FOR BINARY AS f&
        GET f&, , header$ ' Garbage data, skip passed it.
        FOR i% = 1 TO NUM_PATTERNS_IN_FILE
            GET f&, , pattern_data(i%)
        NEXT i%
    CLOSE f&
END SUB


''
' Render DazzleDraw pattern set in a column
' @param ARRAY of STRING * 64 pattern set data
' @param INTEGER column to render at
' @param STRING fn$ filename of pattern set
' 
SUB render_dazzledraw_pattern_column (patterns() AS STRING * 64, column%, fn$)
    DIM i AS INTEGER
    FOR i% = 0 TO NUM_PATTERNS_IN_FILE \ 2 - 1
        render_dazzledraw_pattern_grid _
            patterns(i% + 1), _
            PATTERN_CELL_W * ((column% - 1) * NUM_PATTERN_GRID_X), _
            NUM_PATTERN_GRID_Y * i%, _
            i%, _
            fn$
    NEXT i%
    FOR i% = NUM_PATTERNS_IN_FILE \ 2 TO NUM_PATTERNS_IN_FILE - 1
        render_dazzledraw_pattern_grid _
            patterns(i% + 1), _
            PATTERN_CELL_W * ((column% - 1) * NUM_PATTERN_GRID_X), _
            NUM_PATTERN_GRID_Y * i%, _
            i%, _
            fn$
    NEXT i%
END SUB


''
' Render a grid of DazzleDraw patterns
' @param STRING * 64 pattern$ data to render
' @param INTEGER x coordinate to render at
' @param INTEGER y coordinate to render at
' @param INTEGER num pattern number in set
' @param STRING fn$ filename of pattern set
' 
SUB render_dazzledraw_pattern_grid (pattern$, x%, y%, num%, fn$)
    DIM rows, cols AS INTEGER
    FOR rows% = y% TO y% + NUM_PATTERN_GRID_Y-1
        FOR cols% = x% TO x% + NUM_PATTERN_GRID_X
            render_dazzledraw_pattern _
                pattern$, _
                cols% * (PATTERN_CELL_W * NUM_COLS_IN_PATTERN), _
                rows% * (PATTERN_CELL_H * NUM_ROWS_IN_PATTERN), _
                PATTERN_CELL_W, _
                PATTERN_CELL_H, _
                num%, _
                fn$
        NEXT cols%
    NEXT rows%
END SUB


''
' Renders a DazzleDraw pattern and saves a copie to disk
' @param STRING * 64 pattern$ data of pattern colors
' @param INTEGER x coordinate to render pattern at
' @param INTEGER y coordinate to render pattern at
' @param INTEGER w width of pattern in units (multiplier for scale display)
' @param INTEGER h height of pattern in units (multiplier scale display)
' @param INTEGER num number of the pattern in the set (used for file names)
' @param STRING fn$ filename of the pattern set
' 
SUB render_dazzledraw_pattern (pattern$, x%, y%, w%, h%, num%, fn$)
    DIM AS INTEGER cols, rows, start_x, end_x, start_y, end_y, pixel, pixel_color
    DIM AS STRING char
    DIM AS _UNSIGNED LONG pattern_color
    DIM color_byte AS _UNSIGNED _BYTE

    DIM img AS LONG
    img& = _NEWIMAGE(NUM_COLS_IN_PATTERN, NUM_ROWS_IN_PATTERN, 32)

    pixel% = 1
    FOR rows% = 1 TO NUM_ROWS_IN_PATTERN
        FOR cols% = 1 TO NUM_COLS_IN_PATTERN
            start_x%        = x% + (w% * cols%)
            end_x%          = start_x% + w%
            start_y%        = y% + (h% * rows%)
            end_y%          = start_y% + h%
            color_byte~%%   = ASC(MID$(pattern$, pixel%, 1))
            char$           = MID$(pattern$, pixel%, 1)
            pixel_color%    = color_byte~%%
            pattern_color~& = A2_CN(pixel_color%)
            _DEST CANVAS&
            LINE (start_x%, start_y%)-(end_x%-1, end_y%-1), pattern_color~&, BF
            _DEST img&
            PSET (cols%-1, rows%-1), pattern_color~&
            pixel% = pixel% + 1
            _DEST CANVAS&
        NEXT cols%
    NEXT rows%

    ' SAVE single tile
    SAVEIMAGE img&, fn$ + _TRIM$(STR$(num%))
    _FREEIMAGE img&
END SUB


''
' Saves an image to disk as a BMP file
' This was written by GalleonDragon and taken from:
' https://github.com/QB64Official/qb64/wiki/SAVEIMAGE
'
' @param LONG image to save
' @param STRING filename to save as
' 
SUB SaveImage (image AS LONG, filename AS STRING)
    bytesperpixel& = _PIXELSIZE(image&)
    IF bytesperpixel& = 0 THEN PRINT "Text modes unsupported!": END
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
