REM Rotating N figures with 4 nodes
REM \CHAP9\CH9_6.BAS

SCREEN 9: CLS
x0 = 320          'Coordinate x0
y0 = 150          'Coordinate y0
Mx = 1.35         'Scale factor x
N = 40            'Number of figures
TWO.PI = 6.282    'Constant 2*PI
d = 120

FOR Q = 0 TO TWO.PI STEP TWO.PI / N
   'Nodes coordinates:
   x1 = d:    y1 = d
   x2 = -d:   y2 = d
   x3 = -d:   y3 = -d
   x4 = d:    y4 = -d
   C = COS(Q): S = SIN(Q)   'Calculating constants C and S
   'Drawing figures
   PSET (Mx * (x1 * C - y1 * S) + x0, y1 * C + x1 * S + y0)
   LINE -(Mx * (x2 * C - y2 * S) + x0, y2 * C + x2 * S + y0)
   LINE -(Mx * (x3 * C - y3 * S) + x0, y3 * C + x3 * S + y0)
   LINE -(Mx * (x4 * C - y4 * S) + x0, y4 * C + x4 * S + y0)
   LINE -(Mx * (x1 * C - y1 * S) + x0, y1 * C + x1 * S + y0)
   d = d / 1.1
   FOR PAUSE.LOOP = 1 TO 1000: NEXT PAUSE.LOOP
NEXT Q
F$ = INPUT$(1)

END 
  
