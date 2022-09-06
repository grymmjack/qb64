SCREEN _NEWIMAGE(640, 480, 32)
GRID& = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
_SCREENMOVE _MIDDLE
DrawGrid 0, 0, _WIDTH, _HEIGHT, 16, 16, &HFF303030, GRID&

_DEST 0
PSET(0, 0)
_PUTIMAGE (0, 0), GRID&
_DISPLAY

END 

SUB DrawGrid (xPos, yPos, w, h, gridW, gridH, fgColor&, imgHandle& )
    dest& = _DEST
    _DEST imgHandle&
    COLOR fgColor&
    PSET(0, 0)
    FOR x = xPos to w STEP gridW
        LINE (x,yPos)-(x,yPos+h), fgColor&
    NEXT x
    FOR y = yPos to h STEP gridH
        LINE (xPos, y)-(xPos+w, y), fgColor&
    NEXT y
    _DEST dest&
END SUB