'*********** CHAP6-13.BAS - shows how to save/load CGA graphics screens

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
SCREEN 1

DEF SEG = 0
PageSize = PEEK(&H44C) + 256 * PEEK(&H44D)

FOR X = 1 TO 10
  CIRCLE (140, 95), X * 10, 2
NEXT

DEF SEG = &HB800
BSAVE "CIRCLES.CGA", 0, PageSize
PRINT "The screen was just saved, press a key."
WHILE LEN(INKEY$) = 0: WEND

CLS
PRINT "Now press a key to load the screen."
WHILE LEN(INKEY$) = 0: WEND
BLOAD "CIRCLES.CGA", 0
