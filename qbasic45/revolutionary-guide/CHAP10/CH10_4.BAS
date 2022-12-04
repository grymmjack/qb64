REM Constructing a 3-D Surface applying the FH algorithm
REM \CHAP10\CH10_4.BAS

 SCREEN 9: CLS
 DIM U(424), L(424): XC = 320: YC = 50
 XR = 175: ZR = 120: XA = 107
 FOR I% = 1 TO 424
     U(I%) = 0: L(I%) = 1000
 NEXT I%
 FOR Z = -ZR + 1 TO ZR - 1 STEP 5
     Z2 = Z * Z
     XL% = INT(XR * SQR(1 - Z2 / (ZR * ZR)) + .5)
     X = -XL%
     GOSUB Func
     XZ = XC + Z: X1 = X + XZ
     Y1 = INT(199 - (YC + Y + Z / 2) + .5)
     YZ = 199.5 - YC - .5 * Z
     FOR X = -XL% + 1 TO XL% - 1
         GOSUB Func
         X2 = XZ + X: Y2 = INT(YZ - Y)
         N = X2 - XA
         DO UNTIL Y2 >= L(N)
         L(X2 - XA) = Y2
         IF U(N) = 0 THEN U(N) = Y2
         GOTO Lab
         LOOP
         DO UNTIL Y2 <= U(N)
         U(N) = Y2
 Lab:    LINE (X1, Y1)-(X2, Y2)
         LOOP
         X1 = X2: Y1 = Y2
     NEXT X
 NEXT Z
 F$ = INPUT$(1)

 END

 Func: Y = 40 * SIN(.043 * SQR(X * X + Z2))
 RETURN

