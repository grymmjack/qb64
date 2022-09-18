CONST CYAN = _RGB32(0, 255, 255) ' define cyan color
DIM x1%, y1% '                     upper left coordinates
DIM x2%, y2% '                     lower right coordinates

SCREEN _NEWIMAGE(640, 480, 32) '   640 x 480 graphics screen
x2% = 639 '                        set starting coordinates
y2% = 479
PSET (0, 0), CYAN '                set pixel to start with
FOR Count% = 1 TO 60 '             cycle through line corkscrew 60 times
    LINE -(x2%, y1%), CYAN '       draw lines
    LINE -(x2%, y2%), CYAN
    LINE -(x1%, y2%), CYAN
    y1% = y1% + 4 '                update coordinates
    x2% = x2% - 4
    y2% = y2% - 4
    LINE -(x1%, y1%), CYAN '       draw next line
    x1% = x1% + 4 '                update coordinate
NEXT Count%
SLEEP '                            leave when key pressed
SYSTEM '                           return control to OS

