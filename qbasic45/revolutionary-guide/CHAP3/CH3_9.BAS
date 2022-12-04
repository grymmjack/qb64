REM USING operator COLOR for EGA mode
REM \CHAP3\CH3_9.BAS

SCREEN 9
FOR i% = 0 to 15
    COLOR i%
    PRINT i%;
NEXT i%

END