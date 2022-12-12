REM Factorial calculation
REM PROGRAMS\CHAP_2\CH2_28.BAS

DEF fnfactorial (x%)
IF x% < 0 OR x% > 50 THEN fnfactorial = -1: EXIT DEF
total = 1
FOR i% = x% TO 2 STEP -1
    total = total * i%
NEXT i%
fnfactorial = total
END DEF
'Main block of code
CLS
PRINT fnfactorial(10)
PRINT fnfactorial(80)

END