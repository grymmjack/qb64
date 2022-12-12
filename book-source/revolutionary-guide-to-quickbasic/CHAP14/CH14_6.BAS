REM Demonstration of a Bar Chart with the Rouleaux of Coins Scenario
REM \CHAP14\CH14_6.BAS
 
DECLARE SUB Title (T$, X0!, Y0!)
DECLARE SUB ColCir (R!, X!, N!, CC!, CL!)
 
SCREEN 9
Title "Family's Wages", 200, 20
LOCATE 25, 1: PRINT "                    ";

R = 25	'Set the coin radius
FOR I = 1 TO 5	'Get Bar Info
    READ N
    ColCir R, I * 100, N, 14, 12
NEXT I
 
LINE (10, 0)-(10, 300)

'Y axis tick marks
FOR I = 0 TO 5
    LINE (10, 300 - I * 60)-(14, 300 - I * 60)
NEXT I

'Rest of y axis detail
LOCATE 1, 3: PRINT "50000 $ (USA)"
LOCATE 22, 3: PRINT "0"
LOCATE 24, 11
PRINT "1992         1993         1994";
PRINT "        1995         1996";
F$ = INPUT$(1)

END

DATA 20,30, 42,40,45

SUB ColCir (R, X, N, CC, CL)
  CIRCLE (X, 300), R, CC, 3.141, 0, .2
  CIRCLE (X, 300 - N * 6), R, CC, , , .2
  LINE (X - R, 300)-(X - R, 300 - N * 6), CC
  LINE (X + R, 300)-(X + R, 300 - N * 6), CC
  PAINT (X, 299), CC
  FOR I = 0 TO N - 1
      CIRCLE (X, 300 - I * 6), R, CL, 3.141, 0, .2
  NEXT I
  CIRCLE (X, 300 - N * 6), R, CL, , , .2
  LINE (X - R, 300)-(X - R, 300 - N * 6), CL
  LINE (X + R, 300)-(X + R, 300 - N * 6), CL
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