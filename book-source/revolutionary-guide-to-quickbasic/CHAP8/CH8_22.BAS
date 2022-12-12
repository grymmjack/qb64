REM A Celebration
REM \CHAP8\CH8_22.BAS

DECLARE SUB PAUSE ()
DECLARE SUB HOUSE ()
DECLARE SUB MAN (X!, C!)
DECLARE SUB FIREWORKS (X!, Y!, R!, N!)
SCREEN 9: CLS
DIM X(240), Y(240)
'The Landscape
HOUSE
MAN 20, 7: MAN 320, 7: MAN 330, 7
MAN 345, 7: MAN 610, 7: MAN 630, 7
LINE (0, 320)-(639, 320), 7
'Draw rocket's trajectory and moving man
FOR J = 1 TO 3
  FOR I = 0 TO 240
	 SELECT CASE J  'Drawing the moving man
		CASE 1:  MAN 180 + I / 2, 7
		CASE 2:  MAN 300 - I / 2, 7
		CASE 3:  MAN 180 + I / 2, 7
	 END SELECT
	 W = .005 * I
	 X1 = 290 - 300 * COS(W + .5)
	 Y1 = 545 - 500 * SIN(W + .5)
	 PSET (X1, Y1), 7  'Drawing trajectory
	 X(I) = X1: Y(I) = Y1
	 PAUSE
	 SELECT CASE J  'Clear the moving man
		CASE 1: MAN 180 + I / 2, 0
		CASE 2: MAN 300 - I / 2, 0
		CASE 3: MAN 180 + I / 2, 0
	 END SELECT
  NEXT
  SELECT CASE J    'End position of the moving man
	 CASE 1: MAN 300, 7
	 CASE 2: MAN 180, 7
	 CASE 3: MAN 300, 7
  END SELECT
  'Draw fireworks
  FIREWORKS X1, Y1, 30, 400
  'Erase rocket's traectory
  FOR I = 0 TO 580
	 I1 = INT(240 * RND)
	 PRESET (X(I1), Y(I1))
	 PAUSE
  NEXT
  FOR I = 0 TO 240
	 PRESET (X(I), Y(I))
	 PAUSE
  NEXT
  SLEEP (2)
NEXT
SCREEN 0
END

SUB FIREWORKS (X1, Y1, R, N)
	DIM X(N), Y(N)
	RANDOMIZE (TIMER)
	FOR I = 1 TO N
	 A = 6.28 * RND
	 RN = R * RND
	 XC = X1 + RN * 1.4 * COS(A)
	 YC = Y1 + RN * SIN(A)
	 PSET (XC, YC), 7 + 9 * RND
	 X(I) = XC: Y(I) = YC
	 XC2 = X(I) + 60: YC2 = Y(I) + 20
	 PSET (XC2, YC2), 8 + 8 * RND
	 XC3 = X(I) - 90: YC3 = Y(I) + 30
	 PSET (XC3, YC3), 9 + 7 * RND
	 FOR T = 1 TO 10: NEXT
	 NEXT
	 FOR I = 1 TO N
		PRESET (X(I), Y(I))
		PRESET (X(I) + 60, Y(I) + 20)
		PRESET (X(I) - 90, Y(I) + 30)
		PAUSE
	 NEXT
END SUB

SUB HOUSE
  FOR X = 60 TO 70
	 FOR Y = 15 TO 23
		LOCATE Y, X
		COLOR 7
		PRINT "H";
	 NEXT
  NEXT
END SUB

SUB MAN (X, C)
	CIRCLE (X, 304), 2, C
	LINE (X, 304)-(X, 314), C
	LINE (X - 3, 319)-(X, 314), C
	LINE (X, 314)-(X + 3, 319), C
	LINE (X - 5, 307)-(X, 310), C
	LINE (X, 310)-(X + 5, 307), C
END SUB

SUB PAUSE
  FOR T = 0 TO 100: NEXT
END SUB

