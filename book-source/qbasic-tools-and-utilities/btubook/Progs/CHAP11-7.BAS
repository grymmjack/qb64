'*********** CHAP11-7.BAS - demonstrates reading the current directory

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'$INCLUDE: 'REGTYPE.BI'

DIM Registers AS RegType

DEF FnGetDir$ (Drive$)
  STATIC Temp$, Drive, Zero     'local variables

  IF LEN(Drive$) THEN           'did they pass a drive?
    Drive = ASC(UCASE$(Drive$)) - 64
  ELSE
    Drive = 0
  END IF
 
  Temp$ = SPACE$(65)            'DOS stores the name here
 
  Registers.AX = &H4700         'get directory service
  Registers.DX = Drive          'the drive goes in DL
  Registers.SI = SADD(Temp$)    'show DOS where Temp$ is
  Registers.DS = SSEG(Temp$)    'use this with BASIC PDS
 'Registers.DS = -1             'use this with QuickBASIC
 
  CALL DOSInt(Registers)        'call DOS

  IF Registers.Flags AND 1 THEN 'must be an invalid drive
    FnGetDir$ = ""
  ELSE
    Zero = INSTR(Temp$, CHR$(0))    'find the zero byte
    FnGetDir$ = "\" + LEFT$(Temp$, Zero)
  END IF
END DEF


PRINT "Which drive? ";
DO
  Drive$ = INKEY$
LOOP UNTIL LEN(Drive$)
PRINT


Cur$ = FnGetDir$(Drive$)
IF LEN(Cur$) THEN
  PRINT "The current directory is ";
  PRINT Drive$; ":"; FnGetDir$(Drive$)
ELSE
  PRINT "Invalid drive"
END IF

PRINT "The current directory for the default drive is ";
PRINT FnGetDir$("")
