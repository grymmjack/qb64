'*********** CHAP11-2.BAS - demonstrates calling the BIOS video interrupt

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB ClearScreen (ULRow, ULCol, LRRow, LRCol, Colr)

'$INCLUDE: 'REGTYPE.BI'

DIM SHARED Registers AS RegType

CLS
FG = 7: BG = 1
COLOR FG, BG

FOR X% = 1 TO 24
  PRINT STRING$(80, X% + 64);
NEXT

Colr = FG + 16 * BG
CALL ClearScreen(5, 10, 20, 70, Colr)

SUB ClearScreen (ULRow, ULCol, LRRow, LRCol, Colr) STATIC

  Registers.AX = &H600
  Registers.BX = Colr * 256
  Registers.CX = (ULCol - 1) + (256 * (ULRow - 1))
  Registers.DX = (LRCol - 1) + (256 * (LRRow - 1))
  CALL Interrupt(&H10, Registers, Registers)

END SUB
