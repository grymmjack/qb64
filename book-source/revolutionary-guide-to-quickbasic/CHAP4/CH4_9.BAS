REM Demonstration of INKEY$ harnessed within a WHILE loop
REM \CHAP4\CH4_9.BAS

WHILE Keypress$ = ""
    Keypress$ = INKEY$
    IF Keypress$<>"" THEN PRINT Keypress$
WEND

END 
 