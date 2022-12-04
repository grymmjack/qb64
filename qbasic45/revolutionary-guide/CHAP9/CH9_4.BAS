REM Rotating N figures with 4 nodes
REM \CHAP9\CH9_4.BAS

SCREEN 9: CLS
x0 = 320                'Coordinate x0
y0 = 150                					'Coordinate y0
Mx = 1.35             				'Scale x
N = 10                    					'Number of squares
TWO.PI = 6.282            				'Constant 2*PI
'Nodes coordinates:
x1 = 0:    y1 = 50
x2 = -15:  y2 = 80
x3 = 0:    y3 = 110
x4 = 15:   y4 = 80
FOR Q = 0 TO TWO.PI STEP TWO.PI / N
   C = COS(Q): S = SIN(Q)   'Calculating constants C and S
   'Drawing figures
   PSET (Mx * (x1 * C - y1 * S) + x0, y1 * C + x1 * S + y0)
   LINE -(Mx * (x2 * C - y2 * S) + x0, y2 * C + x2 * S + y0)
   LINE -(Mx * (x3 * C - y3 * S) + x0, y3 * C + x3 * S + y0)
   LINE -(Mx * (x4 * C - y4 * S) + x0, y4 * C + x4 * S + y0)
   LINE -(Mx * (x1 * C - y1 * S) + x0, y1 * C + x1 * S + y0)
   FOR PAUSE.LOOP = 1 TO 1000 : NEXT PAUSE.LOOP
NEXT Q
F$ = INPUT$(1)

END 
