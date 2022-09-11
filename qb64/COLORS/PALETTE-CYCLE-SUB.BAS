SCREEN 13
_FULLSCREEN _SQUAREPIXELS

limit    = 60
startIdx = 16
endIdx   = 32

' Determine range of cycling
IF endIdx > startIdx THEN
    range = endIdx - startIdx
ELSE
    range = startIdx - endIdx
END IF

DIM SHARED c(255, 3)

' Build c array
c = 1
FOR z = 1 TO UBOUND(c)
    LINE (z, 0)-(z, 199), c
    c = (c + 1) MOD UBOUND(c)
    IF c = 0 THEN c = 1
NEXT z

SLEEP

' Set palette using c array
FOR z = startIdx TO endIdx
    OUT &H3C7, z
    c(z, 1) = INP(&H3C9)
    c(z, 2) = INP(&H3C9)
    c(z, 3) = INP(&H3C9)
NEXT z

DO
    _LIMIT limit
    cycle_palette c(), startIdx, endIdx, "forwards"
LOOP UNTIL _KEYHIT = 27

' Cycle palette from startIdx to endIdx
SUB cycle_palette (c(), startIdx, endIdx, direction$)
    STATIC o AS INTEGER
    STATIC z AS INTEGER

    SELECT CASE direction$
        CASE "forwards", "pingpong-forwards": 
            starting = startIdx
            ending   = endIdx
            range    = ending - starting
        CASE "backwards", "pingpong-backwards":
            starting = endIdx
            ending   = startIdx
            range    = starting - ending
    END SELECT

    IF z = ending THEN z = starting
    OUT &H3C8, z    
    OUT &H3C9, c((z + o) MOD startIdx + range, 1)
    OUT &H3C9, c((z + o) MOD startIdx + range, 2)
    OUT &H3C9, c((z + o) MOD startIdx + range, 3)
    
    SELECT CASE direction$
        CASE "forwards", "pingpong-forwards": 
            o = o + 1
            z = z + 1
        CASE "backwards", "pingpong-backwards":
            o = o - 1
            z = z + 1
    END SELECT
    
    IF o = ending THEN o = starting
    
    ' IF direction$ = "pingpong" THEN
    '     FOR o = endIdx TO startIdx STEP -1
    '         _LIMIT limit
    '         FOR z = endIdx TO startIdx STEP -1
    '             OUT &H3C8, z
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 1)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 2)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 3)
    '         NEXT z
    '     NEXT o
    '     FOR o = startIdx TO endIdx
    '         _LIMIT limit
    '         FOR z = startIdx TO endIdx
    '             OUT &H3C8, z
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 1)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 2)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 3)
    '         NEXT z
    '     NEXT o
    ' ELSEIF direction$ = "forwards" THEN
    '     FOR o = startIdx TO endIdx
    '         _LIMIT limit
    '         FOR z = startIdx TO endIdx
    '             OUT &H3C8, z
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 1)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 2)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 3)
    '         NEXT z
    '     NEXT o
    ' ELSEIF direction$ = "backwards"
    '     FOR o = endIdx TO startIdx STEP -1
    '         _LIMIT limit
    '         FOR z = endIdx TO startIdx STEP -1
    '             OUT &H3C8, z
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 1)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 2)
    '             OUT &H3C9, c((z + o) MOD startIdx + range, 3)
    '         NEXT z
    '     NEXT o
    ' END IF
END SUB