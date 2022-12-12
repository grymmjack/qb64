REM Demonstration of a 3D Bar Chart
REM \CHAP14\CH14_4.BAS
  
DATA 6,20,40,80,100,90,120

SCREEN 1: CLS
 
'Read DATA and draw bars
READ N: DIM A(N): W = 150 / N: W1 = W * .25
FOR I = 1 TO N
    READ Y(I): GOSUB Column3D
NEXT I

'Draw global box and print the axes
LINE (0, 170)-(300, 170)
LINE (0, 170)-(0, 0)
LINE (0, 85)-(3, 85)
LINE (0, 0)-(3, 0)

LOCATE 23: PRINT "1990   1991  1992  1993   1994  1995"
LOCATE 1, 2: PRINT "100%"
LOCATE 11, 2: PRINT "50%"
A$ = INPUT$(1)

END

Column3D:                  				'Subroutine for constructing a 3D-column

X = 5 + 2 * W * (I - 1)    		'Calculate X co-ordinate
PSET (X, 170)              				'Set the basic point
YI = Y(I)                  				'Read height of current column

'Drawing columns
D$ = "U=" + VARPTR$(YI) + "R=" + VARPTR$(W)
D$ = D$ + "D=" + VARPTR$(YI) + "E=" + VARPTR$(W1)
D$ = D$ + "U=" + VARPTR$(YI) + "L=" + VARPTR$(W)
D$ = D$ + "G=" + VARPTR$(W1) + "R=" + VARPTR$(W)
D$ = D$ + "E=" + VARPTR$(W1)
DRAW D$
 
RETURN