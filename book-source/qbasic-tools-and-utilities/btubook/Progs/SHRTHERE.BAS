'*********** SHRTHERE.BAS - determines if SHARE.EXE is loaded

'Copyright (c) 1992 Ethan Winer

'NOTE: If you are running Windows version 3.1 Windows itself reports that
'      SHARE is loaded and active.

DEFINT A-Z
DECLARE FUNCTION ShareThere% ()

'$INCLUDE: 'REGTYPE.BI'


PRINT "SHARE.EXE is ";
IF NOT ShareThere% THEN PRINT "NOT ";
PRINT "installed on this PC."

FUNCTION ShareThere% STATIC

  DIM Registers AS RegType
  ShareThere% = -1              'assume Share is loaded
  Registers.AX = &H1000         'service 10h
  CALL Interrupt(&H2F, Registers, Registers)
  AL = Registers.AX AND 255     'isolate the result in AL
  IF AL <> &HFF THEN ShareThere% = 0

END FUNCTION
