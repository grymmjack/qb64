'''
' DRAW_GRID.bas
' Draws a flexible grid. Feel free to use this for whatever you like.
'
' @author Rick Christy <grymmjack@gmail.com>
'

' Setup screen for 320x200 32bit
SCREEN _NEWIMAGE(320, 200, 32)

' Enter fullscreen mode and keep pixels 1:1 ratio square
_FULLSCREEN _SQUAREPIXELS

' A grid consists of horizontal and vertical lines of color
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

' Setup the grid object
DIM theGrid AS Grid
theGrid.imgWidth   = _WIDTH             ' Width of the screen
theGrid.imgHeight  = _HEIGHT            ' Height of the screen
theGrid.fgColor    = &HFF202020         ' Fully opaque dark gray
' theGrid.fgColor    = &H80202020         ' Half transparent dark gray
theGrid.xPos       = 0                  ' Left-most pixel of screen
theGrid.yPos       = 0                  ' Top-most pixel of screen
theGrid.gridWidth  = 10                 ' Grid width of 10 divides evenly
theGrid.gridHeight = 10                 ' Grid height of 10 divides evenly
theGrid.hStyle     = &B1111111111111111 ' Solid
theGrid.vStyle     = &B1111111111111111 ' Solid
' theGrid.hStyle     = &B1010101010101010 ' Dotted evenly when 10 x 10
' theGrid.vStyle     = &B1010101010101010 ' Dotted evenly when 10 x 10
theGrid.imgHandle  = _NEWIMAGE(theGrid.imgWidth, theGrid.imgHeight, 32)

' Draw the grid into the grid image
DrawGrid _
    theGrid.xPos, theGrid.yPos, _
    theGrid.imgWidth, theGrid.imgHeight, _
    theGrid.gridWidth, theGrid.gridHeight, _
    theGrid.fgColor, _
    theGrid.hStyle, theGrid.vStyle, _
    theGrid.imgHandle

' Put the grid image onto the screen
_PUTIMAGE (theGrid.xPos, theGrid.yPos), theGrid.imgHandle

' Wait for keypress
SLEEP

END



' Draws a grid onto an image
SUB DrawGrid (xPos, yPos, w, h, gridW, gridH, fgColor&, hs, vs, imgHandle&)
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