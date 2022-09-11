SCREEN 13
_FULLSCREEN _SQUAREPIXELS

limit    = 60 ' Loop limiter
startIdx = 64 ' Starting palette color
endIdx   = 96 ' Ending palette color

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
DIM c(255, 3)

' Draw a line in every color, and build colors array
c = 1
FOR z = 0 TO UBOUND(c)
    LINE (z, 0)-(z, 199), c
    c = (c + 1) MOD UBOUND(c)
    IF c = 0 THEN c = 1
NEXT z

' Set starting palette using color array
FOR z = 0 TO UBOUND(c)
    OUT &H3C7, z
    c(z, 1) = INP(&H3C9)
    c(z, 2) = INP(&H3C9)
    c(z, 3) = INP(&H3C9)
NEXT z

' Cycle palette until ESC is pressed
DO
    SELECT CASE direction$
        CASE "pingpong":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    OUT &H3C8, z
                    OUT &H3C9, c((z + o) MOD range + startIdx, 1)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 2)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 3)
                NEXT z
            NEXT o
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    OUT &H3C8, z
                    OUT &H3C9, c((z + o) MOD range + startIdx, 1)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 2)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 3)
                NEXT z
            NEXT o
        CASE "forwards":
            FOR o = endIdx TO startIdx STEP -1
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    OUT &H3C8, z
                    OUT &H3C9, c((z + o) MOD range + startIdx, 1)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 2)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 3)
                NEXT z
            NEXT o
        CASE "backwards":
            FOR o = startIdx TO endIdx
                _LIMIT limit
                FOR z = startIdx TO endIdx
                    OUT &H3C8, z
                    OUT &H3C9, c((z + o) MOD range + startIdx, 1)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 2)
                    OUT &H3C9, c((z + o) MOD range + startIdx, 3)
                NEXT z
            NEXT o
    END SELECT
LOOP UNTIL _KEYHIT = 27
