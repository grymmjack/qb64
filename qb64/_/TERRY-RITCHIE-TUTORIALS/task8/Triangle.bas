'----------------------------
'- Declare global variables -
'----------------------------

CONST SCREENWIDTH = 800 '   width of screen
CONST SCREENHEIGHT = 600 '  height of screen

DIM Leg% '                  the length of the triangle base leg in pixels
DIM Height% '               the height of the triangle

'----------------
'- Main program -
'----------------

SCREEN _NEWIMAGE(SCREENWIDTH, SCREENHEIGHT, 32) '       initiate graphics screen
CLS '                                                   clear the screen
PRINT '                                                 get user input
INPUT " Enter the height of the triangle > ", Height%
INPUT " Enter the length of the base leg > ", Leg%
DrawTriangle Height%, Leg% '                            draw the triangle to the screen
PRINT
PRINT " Triangle complete. Press any key to exit."
SLEEP '                                                 wait for a key press
SYSTEM '                                                return control to OS

'------------------------------------------------------------------------------------------------------------
SUB DrawTriangle (h%, l%)
    '------------------------------------------------------------------------------------------------------------
    '- Draws a tringle given the height and base leg length. -
    '-                                                       -
    '- h% - the height of the triangle                       -
    '- l% - the base leg lenth of the triangle               -
    '---------------------------------------------------------

    '---------------------------
    '- Declare local variables -
    '---------------------------

    DIM x1%, y1% '  top x,y location of triangle
    DIM x2%, y2% '  lower left x,y location of triangle
    DIM x3%, y3% '  lower right x,y location of triangle

    '------------------------
    '- Subroutine main code -
    '------------------------

    x1% = SCREENWIDTH / 2 - 1 '                         calculate three x,y points for triangle
    x2% = SCREENWIDTH / 2 - l% / 2 - 1
    x3% = x2% + l%
    y1% = SCREENHEIGHT / 2 - h% / 2 - 1
    y2% = y1% + h%
    y3% = y2%
    LINE (x1%, y1%)-(x2%, y2%), _RGB32(255, 255, 0) '   draw the triangle
    LINE -(x3%, y2%), _RGB32(255, 0, 0)
    LINE -(x1%, y1%), _RGB32(255, 255, 0)
    LINE -(x1%, y2%), _RGB32(255, 0, 0)

END SUB









