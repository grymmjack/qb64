REM Varying the lengths of notes
REM \CHAP11\CH11_8.BAS

CLS : PRINT "This is a whole note."
PLAY "MF O3 C1"
FOR n = 2 to 64
    LOCATE 1, 10
    PRINT " 1 /"; n; "note."
    PLAY "L" + Str$(n) + "C"
NEXT n
 
END