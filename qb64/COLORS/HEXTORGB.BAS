' By a740g
SCREEN _NEWIMAGE(640, 480, 32)
CLS , HexToRGB32("FFFF00") 'yellow

FUNCTION HexToRGB32~&(hexColor AS STRING)
    IF LEN(hexColor) <> 6 THEN ERROR 17
    HexToRGB32 = _RGB32( _
        VAL("&H" + LEFT$(hexColor, 2)), _
        VAL("&H" + MID$(hexColor, 3, 2)), _
        VAL("&H" + RIGHT$(hexColor, 2)) _
    )
END FUNCTION