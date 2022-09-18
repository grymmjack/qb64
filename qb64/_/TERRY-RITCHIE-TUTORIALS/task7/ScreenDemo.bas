'------------------------
'- SCREEN demonstration -
'------------------------

CONST WHITE = _RGB32(255, 255, 255) ' set colors
CONST YELLOW = _RGB32(255, 255, 0)

SCREEN _NEWIMAGE(640, 480, 32) '      switch into a 640x480 graphics screen
CLS '                                 clear the graphics screen
PSET (0, 0), WHITE '                  turn on white pixels
PSET (319, 239), WHITE
PSET (639, 479), WHITE
LINE (5, 5)-(50, 50), YELLOW '        draw yellow lines
LINE (5, 5)-(5, 15), YELLOW
LINE (5, 5)-(15, 5), YELLOW
LINE (319, 234)-(319, 189), YELLOW
LINE (319, 234)-(309, 224), YELLOW
LINE (319, 234)-(329, 224), YELLOW
LINE (634, 474)-(584, 424), YELLOW
LINE (634, 474)-(624, 474), YELLOW
LINE (634, 474)-(634, 464), YELLOW
LINE (0, 279)-(639, 279), YELLOW
LINE (0, 279)-(10, 269), YELLOW
LINE (0, 279)-(10, 289), YELLOW
LINE (639, 279)-(629, 269), YELLOW
LINE (639, 279)-(629, 289), YELLOW
LINE (150, 0)-(150, 479), YELLOW
LINE (150, 0)-(160, 10), YELLOW
LINE (150, 0)-(140, 10), YELLOW
LINE (150, 479)-(160, 469), YELLOW
LINE (150, 479)-(140, 469), YELLOW
LOCATE 4, 2 '                         place text on screen
PRINT "Coordinate 0,0"
LOCATE 5, 3
PRINT "(White dot)"
LOCATE 11, 34
PRINT "Center 319,239"
LOCATE 12, 35
PRINT "(White dot)"
LOCATE 26, 62
PRINT "Coordinate 639,479"
LOCATE 27, 66
PRINT "(White dot)"
LOCATE 18, 23
PRINT "Width of screen 640 pixels (0-639)"
LOCATE 25, 3
PRINT "Height of screen 480 pixels (0-479)"
SLEEP '                               wait for user to press a key
SYSTEM '                              return to Windows

