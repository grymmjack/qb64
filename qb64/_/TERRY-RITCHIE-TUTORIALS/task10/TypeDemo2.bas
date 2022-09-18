'--------------------------------
'- Variable Declaration Section -
'--------------------------------

CONST MAXPIXELS = 10 '         number of pixels +1 on screen

TYPE DOT
    x AS INTEGER '             x location of pixel
    y AS INTEGER '             y location of pixel
    c AS _UNSIGNED LONG '      color of pixel
END TYPE

DIM Pixel(MAXPIXELS) AS DOT '  create one dimension array with data structure
DIM Count% '                   index counter

'----------------------------
'- Main Program Begins Here -
'----------------------------

SCREEN _NEWIMAGE(640, 480, 32) '                               enter graphics screen
RANDOMIZE TIMER '                                              seed random number generator
FOR Count% = 0 TO MAXPIXELS '                                  cycle through all indexes
    Pixel(Count%).x = INT(RND(1) * 640) '                      random x between 0 and 639
    Pixel(Count%).y = INT(RND(1) * 480) '                      random y between 0 and 479
    Pixel(Count%).c = _RGB32(255, 255, 255) '                  set pixel color (white)
    PSET (Pixel(Count%).x, Pixel(Count%).y), Pixel(Count%).c ' turn pixel on
NEXT Count%

