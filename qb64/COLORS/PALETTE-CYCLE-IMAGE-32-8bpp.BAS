CONST FALSE = 0: CONST TRUE = NOT FALSE

CANVAS& = _NEWIMAGE(800, 600, 32)
SCREEN CANVAS&

w = 512
h = 256
x = (800 - w) \ 2
y = (600 - h) \ 2

img& = _LOADIMAGE("ASSETS/STARFIGHTER-VGA.png", 256)
_SCREENMOVE _MIDDLE

_PUTIMAGE (x,y), img&, CANVAS&
' _FULLSCREEN _SQUAREPIXELS

SLEEP 

limit    = 5 ' Loop limiter
startIdx = 40 ' Starting palette color
endIdx   = 44 ' Ending palette color

' Direction of palette cycle
' direction$ = "forwards"   
' direction$ = "backwards"
direction$ = "pingpong"

' Determine color range of cycling
range = endIdx - startIdx

' Holds all the colors
DIM c(255, 3) AS LONG

' Get starting palette from image using color array
FOR z& = 0 TO UBOUND(c)
    value32& = _PALETTECOLOR(z&, img&)
    r& = _RED32(value32&)
    g& = _GREEN32(value32&)
    b& = _BLUE32(value32&)
    c&(z&, 1) = r&
    c&(z&, 2) = g&
    c&(z&, 3) = b&
NEXT z&

dump_colors c&(), "SCREEN 13", FALSE

SLEEP

' Cycle palette until ESC is pressed
DO
    SELECT CASE direction$
        CASE "pingpong":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    ), img&
                    _PUTIMAGE (x,y), img&, CANVAS&
                NEXT z
            NEXT o
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    ), img&
                    _PUTIMAGE (x,y), img&, CANVAS&
                NEXT z
            NEXT o
        CASE "forwards":
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    ), img&
                    _PUTIMAGE (x,y), img&, CANVAS&
                NEXT z
            NEXT o
        CASE "backwards":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c&((z + o) MOD range + startIdx, 1), _
                        c&((z + o) MOD range + startIdx, 2), _
                        c&((z + o) MOD range + startIdx, 3) _
                    ), img&
                    _PUTIMAGE (x,y), img&, CANVAS&
                NEXT z
            NEXT o
    END SELECT
LOOP UNTIL _KEYHIT = 27

SUB dump_colors (colors&(), label$, verbose)
    l = LBOUND(colors&) : u = UBOUND(colors&)
    PRINT "COLORS: " label$
    FOR i = l to u
        dump_rgb colors&(i,1), colors&(i,2), colors&(i,3), i, verbose
    NEXT i
END SUB

SUB dump_rgb (r&, g&, b&, idx%, verbose)
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
