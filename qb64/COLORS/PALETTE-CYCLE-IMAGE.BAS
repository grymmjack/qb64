$Debug
CONST FALSE = 0: CONST TRUE = NOT FALSE

CANVAS& = _NEWIMAGE(640, 480, 256)
SCREEN CANVAS&
x = 0
y = 0
w = 512
h = 256
img& = _LOADIMAGE("/Users/gj/git/qb64/qb64/COLORS/STARFIGHTER.png", 256)
_PUTIMAGE (x,y)-(x+w,y+h), img&, CANVAS&, (0, 0)-(w, h)
'_FULLSCREEN _SQUAREPIXELS

limit    = 60 ' Loop limiter
startIdx = 2 ' Starting palette color
endIdx   = 254 ' Ending palette color

' Direction of palette cycle
direction$ = "forwards"   
' direction$ = "backwards"
' direction$ = "pingpong"

' Determine color range of cycling
' IF endIdx > startIdx THEN
' ELSE
'     range = startIdx - endIdx
' END IF
range = endIdx - startIdx

' Holds all the colors
DIM c(255, 3) AS LONG

' Draw a line in every color, and build colors array
' c = 1
' FOR z = 0 TO UBOUND(c)
'     ' LINE (z, 0)-(z, 199), c
'     c = (c + 1) MOD UBOUND(c)
'     IF c = 0 THEN c = 1
' NEXT z

' Set starting palette using color array
' FOR z = 0 TO UBOUND(c)
'     OUT &H3C7, z
'     c(z, 1) = INP(&H3C9)
'     c(z, 2) = INP(&H3C9)
'     c(z, 3) = INP(&H3C9)
' NEXT z
FOR z = 0 TO UBOUND(c)
    value32& = _PALETTECOLOR(z, img&)
    c(z, 1) = _RED32(value32&)
    c(z, 2) = _GREEN32(value32&)
    c(z, 3) = _BLUE32(value32&)
NEXT z

' dump_colors c&(), "SCREEN 13", FALSE
' SLEEP

'   RGB(c& * 3) = red%: RGB((c& * 3) + 1) = green%: RGB((c& * 3) + 2) = blue%

' Cycle palette until ESC is pressed
DO
    SELECT CASE direction$
        CASE "pingpong":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c((z + o) MOD range + startIdx, 1), _
                        c((z + o) MOD range + startIdx, 2), _
                        c((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c((z + o) MOD range + startIdx, 1), _
                        c((z + o) MOD range + startIdx, 2), _
                        c((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
        CASE "forwards":
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c((z + o) MOD range + startIdx, 1), _
                        c((z + o) MOD range + startIdx, 2), _
                        c((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
        CASE "backwards":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    _PALETTECOLOR z, _RGB32( _
                        c((z + o) MOD range + startIdx, 1), _
                        c((z + o) MOD range + startIdx, 2), _
                        c((z + o) MOD range + startIdx, 3) _
                    )
                NEXT z
            NEXT o
    END SELECT
LOOP UNTIL _KEYHIT = 27

SUB dump_colors(colors&(), label$, verbose)
    l = LBOUND(colors&) : u = UBOUND(colors&)
    PRINT "COLORS: " label$
    FOR i = l to u
        dump_rgb colors&(i,0), colors&(i,1), colors&(i,2), i, verbose
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
