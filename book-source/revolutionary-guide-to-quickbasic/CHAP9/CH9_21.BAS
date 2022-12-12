REM SineCurve
REM \CHAP9\CHAP9_21.BAS

DO
  SCREEN 0: CLS : WIDTH 80: 'Text mode
  'Specifying the Number of Cycles and Screen Mode
  INPUT "Input Number of Cycles (0 for END)=", Cycles
  IF Cycles = 0 THEN END
  INPUT "Input Screen Mode (1,2,9,12)="; Mode

  'Selecting Screen Mode
  SELECT CASE Mode
    CASE 1: SCREEN 1: VIEW (20, 2)-(310, 172), , 1
    CASE 2: SCREEN 2: VIEW (20, 2)-(620, 172), , 1
    CASE 9: SCREEN 9: VIEW (20, 2)-(620, 300), , 1
    CASE 12: SCREEN 12: VIEW (20, 2)-(620, 420), , 1
  END SELECT

  CONST PI = 3.141592653589#
  ' Making window large enough to graph sine wave from
  ' 0 radians to ã radians:
  WINDOW (0, -1.1)-(2 * PI, 1.1)

  Style% = &HFF00                 ' Use to make dashed line.
  CLS
  LINE (2 * PI, 0)-(0, 0), , , Style%' Draw the x (horizontal) axis.

  'Plotting the sinusoidal function
    IF Cycles > 0 THEN
    'Start at (0,0) and plot the graph:
     FOR X = 0 TO 2 * PI STEP .02
       Y = SIN(Cycles * X)    ' Calculate the y coordinate.
       LINE -(X, Y)           ' Draw a line from the last
                              ' point to the new point.
     NEXT X
    'Circle
     CIRCLE (.3, -.3), .25
   END IF

   'Print Mode comments
   IF Mode = 12 THEN LOCATE 28, 3 ELSE LOCATE 23, 3
   SELECT CASE Mode
     CASE 1: PRINT "CGA MODE 320*200 Graphic sin(x)"
     CASE 2: PRINT "CGA MODE 640*200 Graphic sin(x)"
     CASE 9: PRINT "EGA MODE 640*350 Graphic sin(x)"
     CASE 12: PRINT "VGA MODE 640*480 Graphic sin(x)"
   END SELECT
   A$ = INPUT$(1)  'Stop program
   CLS
LOOP WHILE Cycles > 0
