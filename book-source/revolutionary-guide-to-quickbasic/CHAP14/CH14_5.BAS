REM Constructing Two Bar Charts
REM \CHAP14\CH14_5.BAS
  
DIM M$(12), S(12), T(12)
FOR I = 1 TO 12: READ M$(I): NEXT I
DATA Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec
 
'Initializing the Data to be used
MINS = 1: MAXS = 1: MINT = 1: MAXT = 1
FOR I = 1 TO 12
    PRINT "For the month of "; M$(I); " Input Number1, Number2 ";
    INPUT S(I), T(I)
    IF T(I) < T(MINT) THEN MINT = I
    IF S(I) < S(MINS) THEN MINS = I
    IF S(I) > S(MAXS) THEN MAXS = I
    IF T(I) > T(MAXT) THEN MAXT = I
NEXT I

'Setup the screen
CLS : SCREEN 1: COLOR 16
LINE (20, 0)-(20, 170): LINE (20, 170)-(319, 170)
FOR I = 1 TO 12
    FOR J = 1 TO 3
        LOCATE 22 + J, 2 + 3 * I
        PRINT MID$(M$(I), J, 1);
    NEXT J
NEXT I
 
'Drawing columns
LOCATE 1, 1
DS = S(MAXS) - S(MINS): DT = T(MAXT) - T(MINT)
FAKS = 160 / DS: FAKT = 160 / DT
FOR I = 1 TO 12
    XTEMP = 5 + I * 24
    YT = 165 - (T(I) - T(MINT)) * FAKT
    YS = 165 - (S(I) - S(MINS)) * FAKS
    X = XTEMP + 6: Y = YT: COL.FLAG = 1  'Do the first column
    GOSUB Column3d2
    X = XTEMP - 1: Y = YS: COL.FLAG = 2  'Do the second column
    GOSUB Column3d2
NEXT I
W$ = INPUT$(1)

END

'Subroutine for drawing two columns
Column3d2:

'Check colors 
 FOR K = 0 TO 3
     LINE (X + K, Y - K)-(X + 10 + K, 170), 0, BF
     IF COL.FLAG = 1 THEN COL = 2 ELSE COL = 1
NEXT K

'Draw lines
LINE (X, Y)-(X + 10, 170), COL, BF
LINE (X, Y)-(X + 10, 170), 3, B
LINE (X + 3, Y - 3)-(X + 13, Y - 3), 3
LINE (X, Y)-(X + 3, Y - 3), 3
LINE (X + 10, Y)-(X + 13, Y - 3), 3
PAINT (X + 2, Y - 1), 3, 3
LINE (X + 13, Y - 3)-(X + 13, 169), 3
LINE (X, 170)-(X + 13, 170), 3
PAINT (X + 12, 168), 0, 3
RETURN