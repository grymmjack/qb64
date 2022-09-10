SCREEN _NEWIMAGE(_DESKTOPWIDTH,_DESKTOPHEIGHT,13)
_FULLSCREEN _SQUAREPIXELS

CONST FALSE = 0: CONST TRUE = NOT FALSE

DIM COLORS&(255, 2)
OUT &H3C7, 0
FOR i = 0 TO 255
    COLORS&(i,0) = INP(&H3C9)*4
    COLORS&(i,1) = INP(&H3C9)*4
    COLORS&(i,2) = INP(&H3C9)*4
NEXT i

dump_colors COLORS&(), "SCREEN 13", TRUE

SUB dump_colors(colors&(), label$, verbose)
    l = LBOUND(colors&) : u = UBOUND(colors&)
    PRINT "COLORS: " label$
    FOR i = l to u
        dump_rgb colors&(i,0), colors&(i,1), colors&(i,2), i, verbose
    NEXT i
END SUB

SUB dump_rgb(r&, g&, b&, idx%, verbose)
    IF verbose THEN 
        PRINT idx% " R:" r& " G: " g& " B: " b& " ";
        COLOR _RGB(r&, g&, b&)
        PRINT CHR$(219)
        COLOR _DEFAULTCOLOR
    ELSE
        COLOR _RGB(r&, g&, b&)
        PRINT CHR$(219);
        COLOR _DEFAULTCOLOR
    END IF
END SUB