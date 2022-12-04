 REM Program for drawing 3-D figures
 REM \CHAP10\CH10_3.BAS
   
    SCREEN 9: CLS
    LOCATE 1, 12: PRINT "3D-GRAPHICS"
    LOCATE 3, 5: PRINT "Djakonov V.P. Smolensk 1994"
    LOCATE 5, 3: PRINT "Program presents 1O algoritms"
    LOCATE 7, 5: PRINT "FOR DISPLAYED 3D-OBJECTS"
    LOCATE 11, 3: PRINT "1 KNOLL          2 LETTER A"
    LOCATE 12, 3: PRINT "3 WAVES          4 HOUSE"
    LOCATE 13, 3: PRINT "5 LETTER O       6 CROSS"
    LOCATE 14, 3: PRINT "7 CONE           8 PYRAMID"
    LOCATE 15, 3: PRINT "9 OBJECT 1       10 OBJECT 2"
    LOCATE 17, 7: PRINT "Press Q for quit"
    LOCATE 18, 3: PRINT "Press C for CopyScreen"
    LOCATE 19, 7: PRINT "Press M for menu"
    LOCATE 21, 5: INPUT "Input menu position"; N$
    IF N$ = "Q" OR N$ = "q" THEN END
    IF N$ = "M" OR N$ = "m" THEN RUN
    CLS : N = VAL(N$)
    ON N GOSUB F1, F2, F3, F4, F5, F6, F7, F8, F9, F10
    DO
      M$ = INPUT$(1)
      IF M$ = "C" OR M$ = "c" THEN GOSUB CSEGA
      IF M$ = "E" OR M$ = "e" THEN END
      RUN
    LOOP
END

F1:  LOCATE 1: PRINT " 1 Knoll"
     FOR X% = -44 TO 44 STEP 4
     X1 = X% - 150: X2 = X% + 60
     XT = X% * X% * .000025 + .001
       FOR Y% = -100 TO 100
        YT = Y% * Y% * .000025
        Z = 100 - 5 / SQR(XT + YT)
        NY = Y% - X1: NZ = Z + X2
        LINE (NY, NZ)-(NY, 199), 0
        IF Y% = -100 THEN
          PSET (NY, NZ)
        ELSE
          LINE (PY, PZ)-(NY, NZ)
        END IF
        PY = NY: PZ = NZ
     NEXT Y%
     NEXT X%
RETURN

F2:  LOCATE 1: PRINT " 2 Letter A"
     FOR X% = -30 TO 130 STEP 5
     X1 = X% * .5 - 80: X2 = X% * .6 + 60
       FOR Y% = 0 TO 200
         GOSUB L2
         NY = INT(Y% - X1): NZ = INT(Z + X2)
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = 0 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L2:  'Function Z(X,Y) for letter A
     Z = Y% * .1: XT = X% * .1
     Y0 = (.06 * (Y% + 120) - 10) * 3.333
     Y1 = Y0 - 10: Y2 = -Y0 + 16
     IF XT < 0 OR XT > 10 THEN GOTO L21
     IF XT < -Y0 + 10 OR XT < Y0 - 16 THEN GOTO L21
     IF XT < Y2 OR XT < Y1 OR (XT > 6 AND XT < 8) THEN Z = -20
L21: RETURN

F3:  LOCATE 1: PRINT "  3 Waves";
     FOR X = -80 TO 70 STEP 4: X2 = X * X
       FOR Y = -100 TO 100
         GOSUB L3
         NY = Y - X * .5 + 150: NZ = Z + X * .7 + 120
         LINE (NY, NZ)-(NY, 199), 0
         IF Y = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y
     NEXT X
RETURN

L3: 'Function Z(X,Y) for waves
     D = SQR(X2 + Y * Y)
     IF D = 0 THEN Z = -60 ELSE Z = -300 * SIN(D / 5) / (D)
RETURN

F4:  LOCATE 1, 5: PRINT "4 House"
     FOR X% = -80 TO 70 STEP 8
        X3 = .5 * X% + 160
       FOR Y% = -100 TO 100
         GOSUB L4
         NY = Y% + X3: NZ = X3 - Z
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L4: 'Function Z(X,Y) for figure house
     IF X% < -40 OR X% > 40 THEN Z = 20: RETURN
     IF Y% < -40 OR Y% > 40 THEN Z = 20: RETURN
     Z = 90 - ABS(Y%)
RETURN

F5:  LOCATE 1: PRINT " 5 Letter O"
     FOR X% = -80 TO 70 STEP 4
       X2 = X% * X%: X3 = .7 * X% - 150
       FOR Y% = -100 TO 100
         GOSUB L5
         NY = Y% - X3: NZ = Z + X%
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L5:  'Function Z(X,Y) for letter O
     YT = .7 * Y%: D = SQR(X2 + YT * YT)
     IF D < 30 OR D > 60 THEN Z = 100: RETURN
     D1 = ABS(45 - D): Z = 100 - 1.5 * SQR(225 - D1 * D1)
RETURN

F6:  LOCATE 1: PRINT "  6 Cross"
     A = .7854: S = SIN(A): C = COS(A): ' A-angle rotation
     FOR X% = -100 TO 100 STEP 5
       X1 = 160 - X% * .6
       X2 = X% * .5
       CX = C * X%: SX = S * X%
       FOR Y% = -100 TO 99
         GOSUB L6
         NY = Y% + X1: NZ = Z + X2
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% > -100 THEN LINE (PY, PZ)-(NY, NZ)
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L6:  'Function Z(X,Y) for cross
     XM = CX + S * Y%: YM = -SX + C * Y%
     IF XM < -80 OR XM > 80 THEN GOTO L61
     IF YM > -30 AND YM < 30 THEN Z = 85: RETURN
     IF YM < -80 OR YM > 80 THEN GOTO L61
     IF XM > -30 AND XM < 30 THEN Z = 85: RETURN
L61: Z = 100 + .1 * Y%
RETURN

F7:  LOCATE 1: PRINT "  7 conus"
     FOR X% = -100 TO 100 STEP 5
       X1 = 170 - X% * .5
       X2 = X% * .6 + 90
       XS = X% * X%
       FOR Y% = -100 TO 99
         GOSUB L7
         NY = Y% + X1: NZ = Z + X2
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L7:  'Function Z(X,Y) for conus
     Z = 0: D = SQR(XS + Y% * Y%)
     IF D < 90 THEN Z = D - 90
RETURN

F8:  LOCATE 1: PRINT "  8 Piramide"
     FOR X% = -100 TO 100 STEP 5
       X1 = 170 - X% * .5
       X2 = X% * .6 + 125
       XS = X% * X%
       FOR Y% = -100 TO 99
         GOSUB L8
         NY = Y% + X1: NZ = Z + X2
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = -100 THEN PSET (NY, NZ) ELSE LINE (PY, PZ)-(NY, NZ)
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L8:  'Function Z(X,Y) for piramide
     Z = .1 * Y%: D = SQR(XS + Y% * Y%)
     IF D > 90 THEN RETURN
     Z = 10 * INT(.1 * D) - 90
RETURN

F9:  LOCATE 1, 28: PRINT "9 Object 1"
     FOR X% = -80 TO 70 STEP 3
       X1 = 150 - X% * .7: XS = X% * X%
       FOR Y% = -100 TO 99
         GOSUB L9
         NY = INT(Y% + X1): NZ = INT(Z + X%)
         LINE (NY, NZ)-(NY, 299), 0
         IF Y% = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
       NEXT Y%
     NEXT X%
RETURN

L9:  'Function Z(X,Y) for object 1
     YT = .85 * Y%: D = SQR(XS + YT * YT)
     IF D < 30 OR D > 60 THEN Z = 100 + Y%: RETURN
     D1 = ABS(45 - D): Z = 100 - 1.5 * SQR(225 - D1 * D1)
RETURN

F10: LOCATE 1: PRINT "  10 Object 2"
     FOR X% = -50 TO 50 STEP 3
       X1 = 160 + X% * .5
       X2 = 90 + X%:
       XS = X% * X% * 4
       FOR Y% = -100 TO 99
         GOSUB L10
         NY = INT(Y% + X1): NZ = INT(Z + X2)
         LINE (NY, NZ)-(NY, 199), 0
         IF Y% = -100 THEN
           PSET (NY, NZ)
         ELSE
           LINE (PY, PZ)-(NY, NZ)
         END IF
         PY = NY: PZ = NZ
      NEXT Y%
     NEXT X%
RETURN

L10: 'Function Z(X,Y) for object 2
     TX = X% * 2: D = SQR(TX ^ 2 + Y% ^ 2)
     IF D < 30 OR D > 80 THEN Z = 0 ELSE Z = 30 - ABS(55 - D)
RETURN

CSEGA:
  'Include CSEGA if this necessary
RETURN

