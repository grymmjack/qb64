REM Constructing a Planar Bar Chart
REM \CHAP14\CH14_3.BAS
  
CLS : SCREEN 0: 'Clear screen and set text mode
 
Get.Number:
INPUT "Input number of bars between 1 and 12 "; N
IF N > 12 OR N < 1 THEN GOTO Get.Number

DIM X(N)
XMAX = 0

'Input DATA
FOR I = 1 TO N
    PRINT "Input X"; I; "="; : INPUT X(I)
    IF X(I) > XMAX THEN XMAX = X(I)
NEXT I

'Clear screen, set graphic's mode and draw axis
CLS : SCREEN 1
LINE (20, 0)-(20, 170)
LINE (20, 170)-(300, 170)
LOCATE 22, 1: PRINT "0"
LOCATE 1, 1: PRINT XMAX

'Drawing bars (columns)
DX = 142 / N
FOR I = 1 TO N
    X = 30 + (I - 1) * 2 * DX	' Calculate X co-ordinate
    Y = 170 - X(I) * 160 / XMAX	' Calculate Y co-ordinate
    LINE (X, 170)-(X + DX, Y), , B	' Drawing Bars
    PAINT (X + 1, Y + 1), CHR$(97 - I)	' Paint Bars
    LOCATE 23, INT(100 * X / 800) - (I < 10)
    PRINT I;
NEXT I
 
M$ = INPUT$(1):                       ' Pause

END 
