'-------------------------
'- LINE demonstration #2 -
'-------------------------

CONST YELLOW = _RGB32(255, 255, 0) ' define yellow

SCREEN _NEWIMAGE(640, 480, 32) '     switch into a 640x480 graphics screen
CLS '                                clear the graphics screen
LINE (299, 219)-(319, 0), YELLOW '   draw a line
LINE -(339, 219), YELLOW '           draw a line from endpoint of last line
LINE -(639, 239), YELLOW '           draw a line from endpoint of last line
LINE -(339, 259), YELLOW '           ""
LINE -(319, 479), YELLOW '           ""
LINE -(299, 259), YELLOW '           etc..
LINE -(0, 239), YELLOW
LINE -(299, 219), YELLOW
LOCATE 16, 36
PRINT "PRESS A KEY"
SLEEP '                              pause computer until key pressed
SYSTEM '                             return control to OS



