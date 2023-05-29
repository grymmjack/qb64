$COLOR:32
SCREEN _NEWIMAGE(800, 600, 32)

COLOR Black        : _PRINTSTRING (0,  0*16), CHR$(219) : AS_RGB  0
COLOR Blue         : _PRINTSTRING (0,  1*16), CHR$(219) : AS_RGB  1
COLOR Green        : _PRINTSTRING (0,  2*16), CHR$(219) : AS_RGB  2
COLOR Cyan         : _PRINTSTRING (0,  3*16), CHR$(219) : AS_RGB  3
COLOR Red          : _PRINTSTRING (0,  4*16), CHR$(219) : AS_RGB  4
COLOR Magenta      : _PRINTSTRING (0,  5*16), CHR$(219) : AS_RGB  5
COLOR Brown        : _PRINTSTRING (0,  6*16), CHR$(219) : AS_RGB  6
COLOR White        : _PRINTSTRING (0,  7*16), CHR$(219) : AS_RGB  7
COLOR Gray         : _PRINTSTRING (0,  8*16), CHR$(219) : AS_RGB  8
COLOR LightBlue    : _PRINTSTRING (0,  9*16), CHR$(219) : AS_RGB  9
COLOR LightGreen   : _PRINTSTRING (0, 10*16), CHR$(219) : AS_RGB 10
COLOR LightCyan    : _PRINTSTRING (0, 11*16), CHR$(219) : AS_RGB 11
COLOR LightRed     : _PRINTSTRING (0, 12*16), CHR$(219) : AS_RGB 12
COLOR LightMagenta : _PRINTSTRING (0, 13*16), CHR$(219) : AS_RGB 13
COLOR Yellow       : _PRINTSTRING (0, 14*16), CHR$(219) : AS_RGB 14
COLOR BrightWhite  : _PRINTSTRING (0, 15*16), CHR$(219) : AS_RGB 15

SUB AS_RGB(row AS INTEGER)
    DIM AS LONG r, g, b
    DIM c AS _UNSIGNED LONG
    c~& = POINT(0, row% * 16)
    r& = _RED32(c~&)
    g& = _GREEN32(c~&)
    b& = _BLUE32(c~&)
    COLOR _RGB32(&HFF, &HFF, &HFF)
    _PRINTSTRING (24, row% * 16), "#"
    PRINT_HEX r&, g&, b&, row%
END SUB

SUB PRINT_HEX(r AS LONG, g AS LONG, b AS LONG, row AS INTEGER)
    IF r& < 17 THEN
        _PRINTSTRING (32, row% * 16), "0" + HEX$(r&)
    ELSE
        _PRINTSTRING (32, row% * 16), HEX$(r&)
    END IF
    IF g& < 17 THEN
        _PRINTSTRING (32+16, row% * 16), "0" + HEX$(g&)
    ELSE
        _PRINTSTRING (32+16, row% * 16), HEX$(g&)
    END IF
    IF b& < 17 THEN
        _PRINTSTRING (32+32, row% * 16), "0" + HEX$(b&)
    ELSE
        _PRINTSTRING (32+32, row% * 16), HEX$(b&)
    END IF
END SUB