REM This program lets you experiment with four parameters of FM music:
REM attack rate, decay rate, sustain level and release time.
REM \CHAP11\CH11_15.BAS

REM Wouter Bergmann Tiest
REM 17th December 1995

DECLARE SUB DrawBars ()
DECLARE SUB InitFM ()
DECLARE SUB DrawScreen ()
DECLARE SUB SetReg (Reg%, Value%)
DECLARE FUNCTION SetValues% ()
DECLARE SUB PlayNote ()

CONST BaseAddr = &H220 'Change if your sound card uses another base address

CONST RegAddr = BaseAddr + 8, DataAddr = BaseAddr + 9
CONST Escape = 27, Enter = 13, left = 75, right = 77, up = 72, down = 80

DEFINT A-Z

DIM SHARED Params(1 TO 4) 'Hold values for parameters
COMMON SHARED CurrParam 'Holds number of current parameter

InitFM

CurrParam = 1 'Set initial values
Params(1) = 14
Params(2) = 4
Params(3) = 9
Params(4) = 13

DrawScreen
DO
LOOP UNTIL SetValues = Escape
CLS
END

SUB DrawBars
  LOCATE 8, 1
  PRINT "    Attack    Decay     Sustain   Release";
  FOR i = 15 TO 0 STEP -1
    PRINT
    FOR j = 1 TO 4
      LOCATE , 10 * j - 3
      IF Params(j) >= i THEN PRINT "€€";  ELSE PRINT "±±"; 'Draw bars
    NEXT j
  NEXT i
  COLOR 1, 7 'Reverse video
  LOCATE 8, CurrParam * 10 - 5
  SELECT CASE CurrParam
  CASE 1
    PRINT "Attack"
  CASE 2
    PRINT "Decay"
  CASE 3
    PRINT "Sustain"
  CASE 4
    PRINT "Release"
  END SELECT
  COLOR 7, 1 'Normal colours
END SUB

SUB DrawScreen
  COLOR 7, 1
  CLS
  PRINT "            ."
  PRINT "           .  ."
  PRINT "          .     ."
  PRINT "         .        .  .  .  .  .  ."
  PRINT "        .                          ."
  PRINT "       .                             ."
  PRINT "      .                                ."
  LOCATE 9, 10
  PRINT "Fast";
  LOCATE 9, 20
  PRINT "Fast";
  LOCATE 9, 30
  PRINT "Soft";
  LOCATE 9, 40
  PRINT "Early";
  LOCATE 24, 10
  PRINT "Slow";
  LOCATE 24, 20
  PRINT "Slow";
  LOCATE 24, 30
  PRINT "Loud";
  LOCATE 24, 40
  PRINT "Late";
  LOCATE 9, 50
  PRINT "Choose parameter with"
  LOCATE 10, 50
  PRINT "left and right arrow keys."
  LOCATE 11, 50
  PRINT "Adjust bars with"
  LOCATE 12, 50
  PRINT "up and down arrow keys."
  LOCATE 13, 50
  PRINT "Press <Enter> to play note."
  LOCATE 14, 50
  PRINT "Press <Esc> to exit."
END SUB

SUB InitFM
  FOR i = 0 TO 224
    SetReg i, 0 'Clear all registers
  NEXT i
  SetReg &H20, &H1 'Plays carrier note at specified octave
  SetReg &H23, &H1 'Plays modulator note at specified octave
  SetReg &H40, &H1F 'Set carrier total level to softest
  SetReg &H43, &H0 'Set modulator level to loudest
  SetReg &HA0, &H81 'Set note to D
END SUB

SUB PlayNote
  SetReg &H60, 16 * Params(1) + Params(2) 'Set carrier attack and decay
  SetReg &H63, 16 * Params(1) + Params(2) 'Set modulator attack and decay
  SetReg &H80, 16 * Params(3) + Params(4) 'Set carrier sustain and release
  SetReg &H83, 16 * Params(3) + Params(4) 'Set modulator sustain and release
  time! = TIMER + 1
  SetReg &HB0, &H31 'Set octave and switch channel on
  DO
  LOOP UNTIL TIMER > time!
  SetReg &HB0, 0 'Switch channel off
END SUB

SUB SetReg (Reg, Value)
  OUT RegAddr, Reg
  OUT DataAddr, Value
END SUB

FUNCTION SetValues
  DO
    DrawBars
    DO
      key$ = INKEY$
    LOOP WHILE key$ = ""
    SELECT CASE ASC(key$)
    CASE Enter
      PlayNote
    CASE Escape
      SetValues = Escape
      EXIT FUNCTION
    CASE 0 'Extended key codes
      SELECT CASE ASC(RIGHT$(key$, 1))
      CASE up
        IF Params(CurrParam) < 15 THEN Params(CurrParam) = Params(CurrParam) + 1
      CASE down
        IF Params(CurrParam) > 0 THEN Params(CurrParam) = Params(CurrParam) - 1
      CASE left
        CurrParam = CurrParam - 1
        IF CurrParam = 0 THEN CurrParam = 4
      CASE right
        CurrParam = CurrParam + 1
        IF CurrParam = 5 THEN CurrParam = 1
      END SELECT
    END SELECT
  LOOP
END FUNCTION

