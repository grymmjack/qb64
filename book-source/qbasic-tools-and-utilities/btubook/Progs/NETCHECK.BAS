'*********** NETCHECK.BAS - identifies which network is running

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'$INCLUDE: 'REGTYPE.BI'

DIM SHARED Registers AS RegType

DECLARE FUNCTION NWThere% ()
DECLARE FUNCTION BVThere% ()
DECLARE FUNCTION MSThere% ()

'NOTE: Do not change the order in which these tests are performed.

PRINT "I think the network is ";

IF NWThere% THEN
  PRINT "Novell Netware"
ELSEIF BVThere% THEN
  PRINT "Banyon Vines"
ELSEIF MSThere% THEN
  PRINT "Lantastic or other MS compatible"
ELSE
  PRINT "Something I don't recognize, or no network"
END IF

FUNCTION BVThere% STATIC

     BVThere% = -1
     Registers.AX = &HD701
     CALL Interrupt(&H2F, Registers, Registers)
     AL = Registers.AX AND 255
     IF AL <> 0 THEN BVThere% = 0

END FUNCTION

FUNCTION MSThere% STATIC

  MSThere% = -1
  Registers.AX = &HB800
  CALL Interrupt(&H2F, Registers, Registers)
  AL = Registers.AX AND 255
  IF AL = 0 THEN MSThere% = 0

END FUNCTION

FUNCTION NWThere% STATIC

  NWThere% = -1
  Registers.AX = &H7A00
  CALL Interrupt(&H2F, Registers, Registers)
  AL = Registers.AX AND 255
  IF AL <> &HFF THEN NWThere% = 0

END FUNCTION
