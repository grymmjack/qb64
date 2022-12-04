REM Rotating N quadrates (var.1)
REM \CHAP9\CH9_3.BAS

 SCREEN 9: CLS
 x0 = 320          'Coordinate x0
 y0 = 150          'Coordinate y0
 d = 100           'Size of squares
 Mx = 1.35         'Scale x
 N = 11            'Number of squares
 TWO.PI = 6.282    'Constant 2*PI
 FOR Q = 0 TO TWO.PI STEP TWO.PI / N
   C = COS(Q): S = SIN(Q)   'Calculating constants C and S
   'Drawing squares
   PSET (Mx * (0 * C + 0 * S) + x0, 0 * C + 0 * S + y0)
   LINE -(Mx * (0 * C - d * S) + x0, d * C + 0 * S + y0)
   LINE -(Mx * (d * C - d * S) + x0, d * C + d * S + y0)
   LINE -(Mx * (d * C - 0 * S) + x0, 0 * C + d * S + y0)
   LINE -(Mx * (0 * C - 0 * S) + x0, 0 * C + 0 * S + y0)
   'Pause loop
   FOR PAUSE.LOOP = 1 TO 1000
   NEXT PAUSE.LOOP
 NEXT Q
 F$ = INPUT$(1)

 END
