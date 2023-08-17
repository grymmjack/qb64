'*********** CHAP6-12.BAS - demonstrates direct access to video memory

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

CLS
LOCATE 20, 1
PRINT "Keep pressing a key to continue"

DEF SEG = 0
IF PEEK(&H463) = &HB4 THEN
  DEF SEG = &HB000
ELSE
  DEF SEG = &HB800
END IF

Test$ = "Hello!"
Colr = 9

FOR X = 1 TO LEN(Test$)         'walk through the string
  Char = ASC(MID$(Test$, X, 1)) 'get this character
  POKE Address, Char            'poke to display memory
  WHILE LEN(INKEY$) = 0: WEND   'pause for a keypress
  POKE Address + 1, Colr        'now poke the color
  Address = Address + 2         'bump to the next address
  WHILE LEN(INKEY$) = 0: WEND   'pause for a keypress
NEXT
END
