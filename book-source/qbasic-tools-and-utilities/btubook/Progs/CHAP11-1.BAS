'*********** CHAP11-1.BAS - demonstrates calling the PrtSc interrupt

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
TYPE RegType
  AX AS INTEGER
  BX AS INTEGER
  CX AS INTEGER
  DX AS INTEGER
  BP AS INTEGER
  SI AS INTEGER
  DI AS INTEGER
  FL AS INTEGER
END TYPE
DIM Registers AS RegType

CLS
FOR X% = 1 TO 24
  PRINT STRING$(80, X% + 64);
NEXT

CALL Interrupt(5, Registers, Registers)
