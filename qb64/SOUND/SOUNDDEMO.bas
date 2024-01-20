DIM Row$(1 TO 8)
SCREEN 12

   'make red-brick wall
    Row$(1) = CHR$(&H0) + CHR$(&H0) + CHR$(&HFE) + CHR$(&HFE)
    Row$(2) = Row$(1)
    Row$(3) = Row$(1)
    Row$(4) = CHR$(&H0) + CHR$(&H0) + CHR$(&H0) + CHR$(&H0)
    Row$(5) = CHR$(&H0) + CHR$(&H0) + CHR$(&HEF) + CHR$(&HEF)
    Row$(6) = Row$(5)
    Row$(7) = Row$(5)
    Row$(8) = Row$(4)
    Tile$ = Row$(1) + Row$(2) + Row$(3) + Row$(4) + Row$(5) + Row$(6) + Row$(7) + Row$(8)

    LINE (59, 124)-(581, 336), 14, B 'yellow box border to paint inside
    PAINT (320, 240), Tile$, 14 'paints brick tiles within yellow border
