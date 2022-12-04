REM The action of the BEEP statement
REM \CHAP11\CH11_1.BAS

FOR I = 1 to 4
    BEEP
    FOR J = 1 to 1200
    NEXT J
NEXT I
BEEP: BEEP: BEEP
PRINT "END"

END 
