REM Demonstration of the COLOR statement for text mode
REM \CHAP3\CH3_8.BAS

SCREEN 0: CLS
FOR i% = 0 to 15
    COLOR i%
    PRINT i%;
NEXT I%

END