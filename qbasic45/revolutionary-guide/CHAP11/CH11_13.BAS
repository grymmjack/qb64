REM This program plots sound sample data on the screen using SoundBlaster DSP
REM \CHAP11\CH11_13.BAS

REM Wouter Bergmann Tiest
REM 17th December 1995

CONST ScreenMode = 12, xMax = 640 'Change for other screen modes
CONST BaseAddr = &H220 'Change if your sound card uses another base address

CONST CommAddr = BaseAddr + &HC, DataAddr = BaseAddr + &HA

DEFINT A-Z
DIM Byte(xMax)
SCREEN ScreenMode
DO
  OUT CommAddr, &H20 'Give command to sample a byte
  PRESET (i, Byte(i))
  Byte(i) = INP(DataAddr) 'Read value from data port
  PSET (i, Byte(i))
  i = (i + 1) MOD xMax 'Wrap i when end is reached
LOOP

