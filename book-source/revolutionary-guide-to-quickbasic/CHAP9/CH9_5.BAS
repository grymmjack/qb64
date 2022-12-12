REM Rotating N circles
REM \CHAP9\CH9_5.BAS

SCREEN 9: CLS
x0 = 320          'Coordinate x0
y0 = 150          'Coordinate y0
d = 50            'Displacement
Mx = 1.35         'Scale x
N = 16            'Number of circles
R = 80            'Radius of a circle
TWO.PI = 6.282    'Constant 2*PI
FOR Q = 0 TO TWO.PI STEP TWO.PI / N
   C = COS(Q): S = SIN(Q)   'Calculating constants C and S
   'Drawing circles
   CIRCLE (Mx * (d * C - d * S) + x0, d * C + d * S + y0), R
   FOR PAUSE.LOOP = 1 TO 1000: NEXT PAUSE.LOOP
NEXT Q
F$ = INPUT$(1)

END  
