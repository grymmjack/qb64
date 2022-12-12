REM Demonstration of PLAYs micro-language
REM \CHAP11\CH11_5.BAS

CLS
scale$ = "CDEFGAB"
PLAY "l16"
FOR i% = 0 to 5
    PLAY "O" + STR$(i%)
    PLAY "x" + VARPTR$(scale$)
NEXT i%
PRINT "END"

END 