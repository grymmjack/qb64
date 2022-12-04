REM Parametric Figure 6
REM \CHAP9\CH9_16.BAS

'Drawings in Polar Coordinates
   PI = 3.1412
' Clover
   SCREEN 1: CLS
   XM = 319: YM = 199: XC = 160: YC = 100
   FOR r = 20 TO 50 STEP 15
     X1 = XC: Y1 = YC
     FOR A = 0 TO (2 * PI) STEP 1 / r
       R1 = r * SIN(A + A)
       X2 = XC + R1 * COS(A)
       Y2 = YC + R1 * SIN(A)
       LINE (X1, Y1)-(X2, Y2)
       X1 = X2: Y1 = Y2
     NEXT A
    NEXT r

' Draw the ear like shapes
    XL = 60: YC = 100: XR = 260
    FOR r = 15 TO 25 STEP 10
      XL1 = XL: XR1 = XR
      YL1 = YC: YL3 = YC
      YR1 = YC: YR3 = YC
      ' Loop round creating shapes  
      FOR A = 0 TO PI STEP 1 / r
        R1 = r * SIN(A / 2)
        DX = R1 * COS(A): DY = R1 * SIN(A)
        XL2 = XL + DX: YL2 = YC + DY
        YL4 = YC - DY
        LINE (XL1, YL1)-(XL2, YL2)
        LINE (XL1, YL3)-(XL2, YL4)
        XR2 = XR - DX
        YR2 = YC + DY: YR4 = YC - DY
        LINE (XR1, YR1)-(XR2, YR2)
        LINE (XR1, YR3)-(XR2, YR4)
        XL1 = XL2: YL1 = YL2: YL3 = YL4
        XR1 = XR2: YR1 = YR2: YR3 = YR4
      NEXT A
    NEXT r

'Flower patterns
L1: READ XC, YC, r, P'CENTER,RADIUS,NUMBER OF PETALS
    IF XC = 0 GOTO L3
    GOSUB L2: GOTO L1
    GOTO L3

L2: 'Making the flower patterns
    X1 = XC + r: Y1 = YC
    FOR A = 0 TO (2 * PI) STEP 1 / r
      R1 = r * COS(P * A):
      X2 = XC + R1 * COS(A)
      Y2 = YC + R1 * SIN(A)
      LINE (X1, Y1)-(X2, Y2)
      X1 = X2: Y1 = Y2
    NEXT A
RETURN

'BLOCK DATA
    DATA 200,30,15,7,  100,170,15,6,   60,25,15,8
    DATA 40,150,14,5,  230,169,20,8,   230,169,30,4
    DATA 0,0,0,0,0,0,0

L3: M$ = INPUT$(1)
END




