'*********** CHAP11-4.BAS - demonstrates changing the current default drive

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB ChDrive (Drive$)

'$INCLUDE: 'REGTYPE.BI'

DIM SHARED Registers AS RegType

INPUT "Enter the drive to make current: ", NewDrive$
CALL ChDrive(NewDrive$)

SUB ChDrive (Drive$) STATIC
  Registers.AX = &HE00
  Registers.DX = ASC(UCASE$(Drive$)) - 65
  CALL Interrupt(&H21, Registers, Registers)
END SUB
