 REM Drawing 3-D Figures using one array
 REM \CHAP10\CH10_5.BAS

 DECLARE FUNCTION z! (x!, y!)
 SCREEN 9: CLS
 DEFINT I
 a = 155: k1 = 39
 w = 75: k = .65
 Xe0 = 320: Ye0 = 175
 bm = 3.141 / 180
 c = k * COS(w * bm)
 s = k * SIN(w * bm)
 dx = 2: dy = 7: af = a / 200
 DIM H(640)
 FOR I = 1 TO 640
     H(I) = -1E+30
 NEXT I
 FOR q = -160 TO 160 STEP dy
     y = q * af
     cq = Xe0 + c * q + .5
     sq = Ye0 + s * q + .5
     FOR m = -210 TO 210 STEP dx
         x = m * af
         Xe = INT(m + cq)
         Ye = INT(sq + z(m * af, y))
         IF m = -210 THEN
         f1 = 0: I = INT(Xe / dx)
         IF Ye >= H(I + 1) THEN F = 1: H(I + 1) = Ye
         x1 = Xe: y1 = Ye
         ELSE
         f2 = 0: I = INT(Xe / dx)
         IF Ye >= H(I + 1) THEN f2 = 1: H(I + 1) = Ye
         x2 = Xe: y2 = Ye
         IF f1 * f2 = 1 THEN LINE (x1, 350 - y1)-(x2, 350 - y2)
         x1 = x2: y1 = y2: f1 = f2
         END IF
     NEXT m
 NEXT q

 F$ = INPUT$(1)
 END

 FUNCTION z (x, y)
 r = SQR(x ^ 2 + y ^ 2) * .017
 z1 = (COS(r) - COS(3 * r) / 3 + COS(5 * r) / 5 - COS(7 * r) / 7)
 z = 40 * z1 + 50
 END FUNCTION