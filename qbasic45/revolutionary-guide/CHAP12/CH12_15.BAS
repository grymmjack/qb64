REM Demonstrating the Status Bar
REM \CHAP12\CH12_15.BAS

DECLARE SUB DelayManager (percentage!)
SCREEN 9
CLS

FOR i% = 1 TO 1000
    DelayManager (i% \ 10)
NEXT i%

DelayManager (100)

END 
