_FULLSCREEN _SQUAREPIXELS
SCREEN 0
_BLINK OFF
CLS
'_PALETTECOLOR 15, _RGB32(127, 127, 255)
LOCATE 1, 1

FOR BG = 0 TO 15
    FOR FG = 0 TO 31
        COLOR FG, BG
        PRINT " BG=" + STR$(BG) + " / FG=" + STR$(FG) + " ";
    NEXT FG
    SLEEP
    CLS
NEXT BG

'COLOR 16, 7
'TEXT$ = "TESTING 12345!"
'PRINT "۲��" + STRING$(72, " ") + "����"
'LOCATE 1, (80 - LEN(TEXT$)) \ 2
'PRINT "TESTING 12345!"
'LOCATE 25, 1
'SLEEP
'SYSTEM
