'*********** CHAP6-5.BAS - shows how to save/load entire arrays

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
CONST NumEls% = 20000
REDIM Array(1 TO NumEls%)       'create the array

FOR X = 1 TO NumEls%            'file it with values
  Array(X) = X
NEXT

DEF SEG = VARSEG(Array(1))      'set the BSAVE segment
BSAVE "ARRAY.DAT", VARPTR(Array(1)), NumEls% * LEN(Array(1))

REDIM Array(1 TO NumEls%)       'recreate the array
DEF SEG = VARSEG(Array(1))      'in case the array moved
BLOAD "ARRAY.DAT", VARPTR(Array(1))

FOR X = 1 TO NumEls%            'prove the data is valid
  IF Array(X) <> X THEN
    PRINT "Error in element"; X
  END IF
NEXT
