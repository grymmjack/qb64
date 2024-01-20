'$DYNAMIC
DIM SHARED EGA(0 TO 15) AS _UNSIGNED LONG
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
REDIM SHARED indexedColors(UBOUND(EGA~&), 3) AS _UNSIGNED _BYTE

DIM CANVAS AS LONG
CANVAS& = _NEWIMAGE(800, 600, 32)
_DEST CANVAS&
SCREEN CANVAS&

DIM i AS INTEGER
FOR i% = LBOUND(EGA~&) TO UBOUND(EGA~&)
    CALL hex_to_rgb(EGA~&(), indexedColors~%%(), i%)
    COLOR _RGB32( _
        indexedColors~%%(i% ,0), _
        indexedColors~%%(i% ,1), _
        indexedColors~%%(i% ,2), _
        indexedColors~%%(i% ,3) _
    )
    PRINT i%, 
    PRINT indexedColors~%%(i% ,0), 
    PRINT indexedColors~%%(i%, 1), 
    PRINT indexedColors~%%(i%, 2),
    PRINT indexedColors~%%(i%, 3)
NEXT i%

RANDOMIZE TIMER
DIM AS INTEGER cr, cg, cb, ca
cr% = INT(RND * 255)
cg% = INT(RND * 255)
cb% = INT(RND * 255)
ca% = 255
PRINT
PRINT "Closest to (";cr%;",";cg%;",";cb%;",";ca%;") ="; 
DIM closest AS INTEGER
closest% = closest_color_index%(cr%, cg%, cb%, ca%, indexedColors~%%())
COLOR _RGB32( _
    indexedColors~%%(closest%, 0), _
    indexedColors~%%(closest%, 1), _
    indexedColors~%%(closest%, 2), _
    indexedColors~%%(closest%, 3) _
)
PRINT closest%

FUNCTION RGBHEX~&(hexColor$)
    RGBHEX~& = _RGB32( _
        VAL("&H" + LEFT$(hexColor$, 2)), _
        VAL("&H" + MID$(hexColor$, 3, 2)), _
        VAL("&H" + RIGHT$(hexColor$, 2)) _
    )
END FUNCTION

SUB hex_to_rgb(src_pal~&(), dest_pal~%%(), idx%)
    DIM c AS _UNSIGNED LONG
    c~& = src_pal~&(idx%)
    dest_pal~%%(idx%, 0) = _RED32(c~&)
    dest_pal~%%(idx%, 1) = _GREEN32(c~&)
    dest_pal~%%(idx%, 2) = _BLUE32(c~&)
    dest_pal~%%(idx%, 3) = _ALPHA32(c~&)
END SUB

'https://github.com/libgd/libgd/blob/58d25665be1c146e7284f253fa679e8256afa6cb/src/gd.c#L460

FUNCTION closest_color_index%(r%, g%, b%, a%, pal~%%())
    DIM AS INTEGER i, found, rr, gg, bb, aa, first
    DIM AS LONG dist, mindist
    dist& = 0 : mindist& = 0 : first% = 1
    FOR i% = LBOUND(pal~%%) TO UBOUND(pal~%%)
        rr% = pal~%%(i%, 0) - r%
        gg% = pal~%%(i%, 1) - g%
        bb% = pal~%%(i%, 2) - b%
        aa% = pal~%%(i%, 3) - a%
        dist& = rr% * rr% + gg% * gg% + bb% * bb% + aa% * aa%
        ' PRINT dist&, mindist&
        IF first% OR (dist& < mindist&) THEN
            mindist& = dist&
            found% = i%
            ' PRINT "found: "; found%
            first% = 0
        END IF
    NEXT i%
    ' PRINT "final closest index: "; found%
    closest_color_index% = found%
END FUNCTION
