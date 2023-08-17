'********** MONITOR.BAS - shows how to detect the display adapter type

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE SUB INTERRUPT (IntNum, InRegs AS ANY, OutRegs AS ANY)
DECLARE FUNCTION Monitor% (Segment)

TYPE RegType
  AX    AS INTEGER
  BX    AS INTEGER
  CX    AS INTEGER
  DX    AS INTEGER
  BP    AS INTEGER
  SI    AS INTEGER
  DI    AS INTEGER
  Flags AS INTEGER
END TYPE
DIM SHARED InRegs AS RegType, OutRegs AS RegType

SELECT CASE Monitor%(Segment)
  CASE 1
    PRINT "Monochrome";
  CASE 2
    PRINT "Hercules";
  CASE 3
    PRINT "CGA";
  CASE 4
    PRINT "EGA";
  CASE 5
    PRINT "VGA";
  CASE ELSE
    PRINT "Unknown";
END SELECT
PRINT " monitor at segment &H"; HEX$(Segment)

FUNCTION Monitor% (Segment) STATIC

  DEF SEG = 0                       'first see if it's color or mono
  Segment = &HB800                  'assume color

  IF PEEK(&H463) = &HB4 THEN

    Segment = &HB000                'assign the monochrome segment
    Status = INP(&H3BA)             'get the current video status
    FOR X = 1 TO 30000              'test for a Hercules 30000 times
      IF INP(&H3BA) <> Status THEN
        Monitor% = 2                'the port changed, it's a Herc
        EXIT FUNCTION               'all done
      END IF
    NEXT
    Monitor% = 1                    'it's a plain monochrome

  ELSE                              'it's some sort of color monitor

    InRegs.AX = &H1A00              'first test for VGA
    CALL INTERRUPT(&H10, InRegs, OutRegs)
    IF (OutRegs.AX AND &HFF) = &H1A THEN
      Monitor% = 5                  'it's a VGA
      EXIT FUNCTION                 'all done
    END IF

    InRegs.AX = &H1200              'now test for EGA
    InRegs.BX = &H10
    CALL INTERRUPT(&H10, InRegs, OutRegs)
    IF (OutRegs.BX AND &HFF) = &H10 THEN
      Monitor% = 3                  'if BL is still &H10 it's a CGA
    ELSE
      Monitor% = 4                  'otherwise it's an EGA
    END IF

  END IF

END FUNCTION
