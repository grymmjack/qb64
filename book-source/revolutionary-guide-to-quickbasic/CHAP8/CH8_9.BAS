REM Modularized font manipulation program
REM \CHAP8\CH8_9.BAS

 DECLARE SUB Title (T$, X0!, Y0!)
 DECLARE SUB CharCir (C$, X0!, Y0!, R!, C!)
 SCREEN 9
 Title "The title is written!", 195, 200
 CharCir "  Hello my friend!   ", 320, 180, 120, 15

 SUB CharCir (C$, X0, Y0, R, C)
 LOCATE 25, 1
 PRINT C$;
 FOR Y% = 0 TO 11
     YR = 3 * Y% + R
     FOR X% = 0 TO 319
         IF POINT(X%, 349 - Y%) <> 0 THEN
	         W = .01964 * X%
	         Xc = X0 - 1.5 * YR * COS(W)
	         Yc = Y0 - YR * SIN(W)
	         LINE (Xc, Yc)-(Xc + 2, Yc + 2), C, BF
         END IF
     NEXT X%
 NEXT Y%
 END SUB

 SUB Title (T$, X0, Y0)
 LOCATE 25, 1
 PRINT T$;
 FOR Y% = 0 TO 11
     DX = .6 * Y% + X0: DY = 2 * Y%
     FOR X% = 0 TO 319
         Z = POINT(X%, 349 - Y%)
         IF Z <> 0 THEN
         XI = DX + 2 * X%
         LINE (XI, Y0 - DY)-(XI - 1, Y0 + 2 - DY), 15
         END IF
     NEXT X%
 NEXT Y%
 END SUB

