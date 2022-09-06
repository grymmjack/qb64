SCREEN _NEWIMAGE(320, 200, 32)
_FULLSCREEN _SQUAREPIXELS

TYPE Grid
    imgWidth   AS INTEGER   ' Width of the full grid image
    imgHeight  AS INTEGER   ' Height of the full grid image
    fgColor    AS LONG      ' Foreground color of the grid lines
    xPos       AS INTEGER   ' X position of the grid in the image
    yPos       AS INTEGER   ' Y position of the grid in the image
    gridWidth  AS INTEGER   ' Width of a grid square
    gridHeight AS INTEGER   ' Height of a grid square
    hStyle     AS INTEGER   ' Horizontal style &B0000111100001111 (16 bits)
    vStyle     AS INTEGER   ' Vertical style &B0000111100001111 (16 bits)
    imgHandle  AS LONG      ' Grid image handle
END TYPE

DIM theGrid AS Grid
theGrid.imgWidth   = _WIDTH
theGrid.imgHeight  = _HEIGHT
theGrid.fgColor    = &HFF202020
theGrid.xPos       = 0
theGrid.yPos       = 0
theGrid.gridWidth  = 10
theGrid.gridHeight = 10
theGrid.hStyle     = &B1010101010101010 ' Dotted perfect when 10x10
theGrid.vStyle     = &B1010101010101010 ' Dotted perfect when 10x10
' theGrid.hStyle     = &B1111111111111111 ' Solid
' theGrid.vStyle     = &B1111111111111111 ' Solid
theGrid.imgHandle  = _NEWIMAGE(theGrid.imgWidth, theGrid.imgHeight, 32)

DrawGrid _
    theGrid.xPos, theGrid.yPos, _
    theGrid.imgWidth, theGrid.imgHeight, _
    theGrid.gridWidth, theGrid.gridHeight, _
    theGrid.fgColor, _
    theGrid.hStyle, theGrid.vStyle, _
    theGrid.imgHandle

_PUTIMAGE (0, 0), theGrid.imgHandle

SLEEP
END

' Draws a grid onto an image
SUB DrawGrid (xPos, yPos, w, h, gridW, gridH, fgColor&, hs, vs,imgHandle& )
    oldDest& = _DEST
    _DEST imgHandle&
    COLOR fgColor&
    FOR x = xPos to w STEP gridW
        LINE (x,yPos)-(x,yPos+h), fgColor&, , hs
    NEXT x
    FOR y = yPos to h STEP gridH
        LINE (xPos, y)-(xPos+w, y), fgColor&, , vs
    NEXT y
    _DEST oldDest&
END SUB