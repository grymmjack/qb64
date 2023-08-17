'*********** CHAP11-3.BAS - demonstrates getting the current default drive

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

'$INCLUDE: 'REGTYPE.BI'
DIM Registers AS RegType

DEF FnGetDrive%
  Registers.AX = &H1900
  CALL Interrupt(&H21, Registers, Registers)
  FnGetDrive% = (Registers.AX AND &HFF) + 65
END DEF

PRINT "The current default drive is "; CHR$(FnGetDrive%)
