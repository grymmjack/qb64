REM Simple demonstration of text scrolling
REM \CHAP12\CH12_11.BAS

CLS
ts$ = "This simple ticker-tape style special effect is very eye-catching and very Ã	easy to implement. If you take a long string, say this paragraph, then we could 	 Ã	scroll it through a box on the screen, using this simple method:        "
looppos% = 1
sizeofbox% = 70
finalstring$ = ""

WHILE keyinput$ = ""
    IF looppos% > (LEN(ts$) - sizeofbox%) THEN finalstring$ = MID$(ts$, looppos%, Ã 	    LEN(ts$) - looppos%) + LEFT$(ts$, (sizeofbox% - (LEN(ts$) - looppos%))) ELSE  Ã
 finalstring$ = MID$(ts$, looppos%, sizeofbox%)
    LOCATE 5, 5: PRINT finalstring$
       looppos% = looppos% + 1               ' increment position
       IF looppos% = LEN(ts$) THEN looppos% = 1      ' check for wraparound
    FOR B = 1 TO 500: NEXT B                          							' delay loop
    keyinput$ = INKEY$
WEND

END