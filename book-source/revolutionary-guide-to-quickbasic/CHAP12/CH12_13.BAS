REM Simple demonstration of text scrolling with fading
REM \CHAP12\CH12_13.BAS

CLS
COLOR 15
ts$ = "This simple ticker-tape style special effect is very eye-catching Ã and  Ã very easy to implement. If you take a long string, say this paragraph, Ã then we Ã  could scroll it through a box on the screen, using this simple Ã method:           "

looppos% = 1
sizeofbox% = 70
finalstring$ = ""

WHILE keyinput$ = ""
IF looppos% > (LEN(ts$) - sizeofbox%) THEN finalstring$ = MID$(ts$, Ã looppos%, Ã LEN(ts$) - looppos%) + LEFT$(ts$, (sizeofbox% - (LEN(ts$) - Ã looppos%))) 		Ã	ELSE finalstring$ = MID$(ts$, looppos%, sizeofbox%)
 COLOR 8: LOCATE 5, 5: PRINT LEFT$(finalstring$, 1);
 LOCATE 5, 70: PRINT MID$(finalstring$, 66, 1);
 COLOR 7: LOCATE 5, 6: PRINT MID$(finalstring$, 2, 1);
 LOCATE 5, 69: PRINT MID$(finalstring$, 65, 1);
 COLOR 7: LOCATE 5, 7: PRINT MID$(finalstring$, 3, 1);
 LOCATE 5, 68: PRINT MID$(finalstring$, 64, 1);
 COLOR 15: LOCATE 5, 8: PRINT MID$(finalstring$, 4, sizeofbox% - 10);
  
 looppos% = looppos% + 1                            ' increment position
 IF looppos% = LEN(ts$) THEN looppos% = 1           ' check for wraparound
 FOR B = 1 TO 5000: NEXT B                          ' delay loop
 keyinput$ = INKEY$
 WEND

 END