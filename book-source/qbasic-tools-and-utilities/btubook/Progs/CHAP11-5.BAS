'*********** CHAP11-5.BAS - demonstrates testing for a valid drive

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB ChDrive (Drive$)

'$INCLUDE: 'REGTYPE.BI'

DIM SHARED Registers AS RegType

DEF FnGetDrive%
  Registers.AX = &H1900
  CALL Interrupt(&H21, Registers, Registers)
  FnGetDrive% = (Registers.AX AND &HFF) + 65
END DEF

DEF FnDriveValid% (TestDrive$)
  STATIC Current                'local to this function
  Current = FnGetDrive%         'save the current drive
  FnDriveValid% = 0             'assume not valid
  CALL ChDrive(TestDrive$)      'try to set a new drive
  IF ASC(UCASE$(TestDrive$)) = FnGetDrive% THEN
     FnDriveValid% = -1         'they match so it's valid
  END IF
  CALL ChDrive(CHR$(Current))   'either way restore it
END DEF

INPUT "Enter the drive to test for validity: ", Drive$
IF FnDriveValid%(Drive$) THEN
   PRINT Drive$; " is a valid drive."
ELSE
   PRINT "Sorry, drive "; Drive$; " is not valid."
END IF

SUB ChDrive (Drive$) STATIC
  Registers.AX = &HE00
  Registers.DX = ASC(UCASE$(Drive$)) - 65
  CALL Interrupt(&H21, Registers, Registers)
END SUB
