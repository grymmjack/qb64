''
' IMG2PAL
'
' Converts any QB64 supported image to a fixed color palette by calculating
' the closest Euclidean Distance matching indexed color to RGB components.
'
' EGA is currently used to support conversion of pixel art with IMG2ANS, but
' I will also support loading .PAL files for indexed palettes besides EGA.
'
' @author Rick Christy <grymmjack@gmail.com>
'
' @see https://en.wikipedia.org/wiki/Euclidean_distance
' @see https://stackoverflow.com/questions/57862060/finding-the-closest-indexed-color-value-to-the-current-color-in-javascript-p5
' @see https://github.com/libgd/libgd/blob/58d25665be1c146e7284f253fa679e8256afa6cb/src/gd.c#L460
'
' @version 0.1
'
'$DYNAMIC

'EGA palette is easy to use in hex color value format
DIM EGA(0 TO 15) AS _UNSIGNED LONG
EGA~&(0)  = &HFF000000
EGA~&(1)  = &HFF0000AA
EGA~&(2)  = &HFF00AA00
EGA~&(3)  = &HFF00AAAA
EGA~&(4)  = &HFFAA0000
EGA~&(5)  = &HFFAA00AA
EGA~&(6)  = &HFFAA5500
EGA~&(7)  = &HFFAAAAAA
EGA~&(8)  = &HFF555555
EGA~&(9)  = &HFF5555FF
EGA~&(10) = &HFF55FF55
EGA~&(11) = &HFF55FFFF
EGA~&(12) = &HFFFF5555
EGA~&(13) = &HFFFF55FF
EGA~&(14) = &HFFFFFF55
EGA~&(15) = &HFFFFFFFF
'0 = RED, 1 = GREEN, 2 = BLUE, 3 = ALPHA
DIM indexedColors(UBOUND(EGA~&), 2) AS _UNSIGNED _BYTE

'Setup screen
DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(800, 600, 32)
_DEST CANVAS&
SCREEN CANVAS&

'Populate indexedColors from EGA array and display indexes and components
DIM i AS INTEGER
FOR i% = LBOUND(EGA~&) TO UBOUND(EGA~&)
    CALL hex_to_rgb(EGA~&(), indexedColors~%%(), i%)
NEXT i%

'Create random components to test matching algorithm
DIM k AS STRING
DO:
    k$ = INKEY$
    IF k$ = CHR$(27) THEN END
    RANDOMIZE TIMER
    DIM AS INTEGER cr, cg, cb', ca
    cr% = INT(RND * 255)
    cg% = INT(RND * 255)
    cb% = INT(RND * 255)

    'Display matching index in indexedColors color which was found
    FOR i% = LBOUND(EGA~&) TO UBOUND(EGA~&)
        COLOR _RGB32( _
            indexedColors~%%(i%, 0), _
            indexedColors~%%(i%, 1), _
            indexedColors~%%(i%, 2) _
        )
        PRINT i%, 
        PRINT indexedColors~%%(i%, 0), 
        PRINT indexedColors~%%(i%, 1), 
        PRINT indexedColors~%%(i%, 2)
    NEXT i%
    PRINT
    PRINT "Closest to (";cr%;",";cg%;",";cb%;") = "; 
    COLOR _RGB32(cr%, cg%, cb%)
    PRINT CHR$(219);
    DIM closest AS INTEGER
    closest% = closest_color_index%(cr%, cg%, cb%, indexedColors~%%())
    COLOR _RGB32( _
        indexedColors~%%(closest%, 0), _
        indexedColors~%%(closest%, 1), _
        indexedColors~%%(closest%, 2) _
    )
    PRINT CHR$(219);
    PRINT closest%
    COLOR _RGB32(255, 255, 255)
    PRINT "Press SPACE to randomize another match, or ESC to quit."
    SLEEP
    CLS
LOOP


''
' Creates a _RGB32 color from a passed in hex color string
'
' @param STRING hexColor 
' @return _UNSIGNED LONG _RGB32 color
'
FUNCTION RGBHEX~&(hexColor$)
    RGBHEX~& = _RGB32( _
        VAL("&H" + LEFT$(hexColor$, 2)), _
        VAL("&H" + MID$(hexColor$, 3, 2)), _
        VAL("&H" + RIGHT$(hexColor$, 2)) _
    )
END FUNCTION



''
' Populates a destionation multidimensional palette array using hex color values
' 
' @param ARRAY _UNSIGNED LONG src_pal source palette of hex color values
' @param ARRAY _UNSIGNED _BYTE dest_pal destination palette for components
' @param INTEGER idx Index of arrays to work on
'
SUB hex_to_rgb(src_pal~&(), dest_pal~%%(), idx%)
    DIM c AS _UNSIGNED LONG
    c~& = src_pal~&(idx%)
    dest_pal~%%(idx%, 0) = _RED32(c~&)
    dest_pal~%%(idx%, 1) = _GREEN32(c~&)
    dest_pal~%%(idx%, 2) = _BLUE32(c~&)
END SUB



''
' Finds closest color index in palette for passed in RGB color
'
' Ported from gd's gdImageColorClosestAlpha function here:
' https://github.com/libgd/libgd/blob/58d25665be1c146e7284f253fa679e8256afa6cb/src/gd.c#L460
'
' @param INTEGER r Red component of color to match
' @param INTEGER g Green component of color to match
' @param INTEGER b Blue component of color to match
' @param INTEGER a Alpha component of color to match
' @param ARRAY _UNSIGNED _BYTE pal Palette to search for matches in
' @return INTEGER index of the closest color in palette to passed in RGB color
'
FUNCTION closest_color_index%(r%, g%, b%, pal~%%())
    DIM AS INTEGER i, found, rr, gg, bb, first
    DIM AS LONG dist, mindist
    dist& = 0 : mindist& = 0 : first% = 1
    FOR i% = LBOUND(pal~%%) TO UBOUND(pal~%%)
        rr% = pal~%%(i%, 0) - r%
        gg% = pal~%%(i%, 1) - g%
        bb% = pal~%%(i%, 2) - b%
        dist& = rr% * rr% + gg% * gg% + bb% * bb%
        IF first% OR (dist& < mindist&) THEN
            mindist& = dist&
            found% = i%
            first% = 0
        END IF
    NEXT i%
    closest_color_index% = found%
END FUNCTION
