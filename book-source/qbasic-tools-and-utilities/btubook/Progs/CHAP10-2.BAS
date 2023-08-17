'********** CHAP10-2.BAS - modifies the printer timeout values

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB INTERRUPT (IntNo, InRegs AS ANY, OutRegs AS ANY)
DECLARE FUNCTION LPTReady% (LPTNumber)

'$INCLUDE: 'REGTYPE.BI'

LPTNumber = 1

IF LPTReady%(LPTNumber) THEN
  PRINT "The printer is on-line and ready to go."
ELSE
  PRINT "Sorry, the printer is not available."
END IF

FUNCTION LPTReady% (LPTNumber) STATIC

  DIM Regs AS RegType                'for CALL INTERRUPT
  LPTReady% = 0                      'assume not ready

  Address = &H477 + LPTNumber        'LPT timeout address
  DEF SEG = 0                        'access segment zero
  OldValue = PEEK(Address)           'save current setting
  POKE Address, 1                    '1 retry
 
  Regs.AX = 32                       'first print a space
  Regs.DX = LPTNumber - 1            'convert to 0-based
  CALL INTERRUPT(&H17, Regs, Regs)   'print the space
  
  Result = (Regs.AX \ 256) OR 128    'get AH, ignore busy
  Result = Result AND 191            'and acknowledge
  IF Result = 144 THEN               'it worked!
    Regs.AX = 8                      'print a backspace
    CALL INTERRUPT(&H17, Regs, Regs) '  to undo CHR$(32)
    LPTReady% = -1                   'return success
  END IF
 
  POKE Address, OldValue             'restore original
                                     '  timeout value
END FUNCTION
