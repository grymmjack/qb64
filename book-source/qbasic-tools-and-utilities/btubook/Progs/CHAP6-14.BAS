'********* CHAP6-14.BAS - shows how to save/load EGA and VGA graphics screens

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB EgaBSave (FileName$)
DECLARE SUB EgaBLoad (FileName$)

SCREEN 9
LOCATE 25, 1
PRINT "Press a key to stop, and save the screen.";

'---- clever video effects by Brian Giedt
WHILE LEN(INKEY$) = 0
  T = (T MOD 150) + 1
  C = (C + 1) MOD 16
  LINE (T, T)-(300 - T, 300 - T), C, B
  LINE (300 + T, T)-(600 - T, 300 - T), C, B
WEND

LOCATE 25, 1
PRINT "Thank You!"; TAB(75);
CALL EgaBSave("SCREEN9")

CLS
LOCATE 25, 1
PRINT "Now press a key to read the screen.";
WHILE LEN(INKEY$) = 0: WEND
LOCATE 25, 1
PRINT TAB(75);

CALL EgaBLoad("SCREEN9")

SUB EgaBLoad (FileName$) STATIC

    'UnREM the KILL statements to erase the saved
    'images after they're loaded

    DEF SEG = &HA000
    OUT &H3C4, 2: OUT &H3C5, 1
    BLOAD FileName$ + ".BLU", 0
    'KILL FileName$ + ".BLU"

    OUT &H3C4, 2: OUT &H3C5, 2
    BLOAD FileName$ + ".GRN", 0
    'KILL FileName$ + ".GRN"

    OUT &H3C4, 2: OUT &H3C5, 4
    BLOAD FileName$ + ".RED", 0
    'KILL FileName$ + ".RED"

    OUT &H3C4, 2: OUT &H3C5, 8
    BLOAD FileName$ + ".INT", 0
    'KILL FileName$ + ".INT"
    OUT &H3C4, 2: OUT &H3C5, 15

END SUB

SUB EgaBSave (FileName$) STATIC

    DEF SEG = &HA000
    Size& = 28000       'use 38400 for VGA SCREEN 12
    
    OUT &H3CE, 4: OUT &H3CF, 0
    BSAVE FileName$ + ".BLU", 0, Size&

    OUT &H3CE, 4: OUT &H3CF, 1
    BSAVE FileName$ + ".GRN", 0, Size&

    OUT &H3CE, 4: OUT &H3CF, 2
    BSAVE FileName$ + ".RED", 0, Size&

    OUT &H3CE, 4: OUT &H3CF, 3
    BSAVE FileName$ + ".INT", 0, Size&

    OUT &H3CE, 4: OUT &H3CF, 0

END SUB
