'---------------
'- Line Styles -
'---------------

CONST YELLOW = _RGB32(255, 255, 0) ' define yellow

SCREEN _NEWIMAGE(640, 480, 32) '                    switch into a 640x480 graphics screen
CLS
LINE (10, 10)-(629, 10), YELLOW, , 43690 '   a dotted line 1010101010101010

LINE (10, 50)-(629, 50), YELLOW, , 52428 '   a dotted line 1100110011001100

LINE (10, 90)-(629, 90), YELLOW, , 61680 '   a dashed line 1111000011110000

LINE (10, 130)-(629, 130), YELLOW, , 65280 ' a dashed line 1111111100000000




