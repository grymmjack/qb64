'--------------------------------
'- Variable Declaration Section -
'--------------------------------

TYPE DOT
    x AS INTEGER '        x location of pixel
    y AS INTEGER '        y location of pixel
    color AS _UNSIGNED LONG ' color of pixel
END TYPE

DIM Pixel AS DOT ' a variable created with a TYPE definition

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '   enter graphics screen
Pixel.x = 319 '                    set pixel x coordinate
Pixel.y = 239 '                    set pixel y coordinate
Pixel.color = _RGB32(255, 255, 255) '  set pixel color (white)
PSET (Pixel.x, Pixel.y), Pixel.color ' draw pixel on screen

