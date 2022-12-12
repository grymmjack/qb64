REM The Parachute Jump
REM \CHAP8\CH8_18.BAS


'The Dynamic Graphic Example
'Define figures for DRAW
Chute$ = "BM165,115 E5 R3 F5 G9 D2 R5 U2 H9"
Ground$ = "BM0,170 R35 E10 F10 E5 R40 E10 R10 D2 F5 R30 F10                                R15 E10 R30 U5 E10 F20 R50 E10 D40 L310 U27"
Plane$ = "BM145,100 R30 E4 H4 L4 H2 G2 L14 H6 L2 D14"
Wing$ = "BM165,96 L5"

'Define Tables
DIM Plane%(70)            'Table for airplane
DIM Chute%(36)            'Table for parachute
DIM Pack%(7)              'Table for pack

ControlModule:
  GOSUB SetUpGraphicsArea
  GOSUB DrawLogo
  GOSUB GetImages
  GOSUB Animation
  GOSUB ReturnTextScreen
END

SetUpGraphicsArea:
  SCREEN 1
  COLOR 1, 0
RETURN

DrawLogo:
  LOCATE 8, 11: PRINT "The Dynamic Graphic"
  DRAW Plane$: DRAW Wing$: PAINT (160, 98), 2, 3
  DRAW Chute$: PAINT (175, 115), 2, 2
  CIRCLE (150, 120), 2, 2
  LOCATE 20, 8: PRINT "Press any key to continue"
  F$ = INPUT$(1)
RETURN

GetImages:
  GET (145, 100)-(179, 86), Plane%
  GET (165, 126)-(179, 110), Chute%
  GET (148, 122)-(152, 118), Pack%
RETURN

Animation:
  CLS
  CIRCLE (200, 15), 10       'Draw & paint the sun.
  PAINT (200, 15), 3
  DRAW Ground$               'Draw & paint the ground.
  PAINT (55, 180), 1, 3
  FOR X = 1 TO 120      'Start moving plane across the screen.
      PUT (X, 36), Plane%    'Draw plane at current position.
      FOR Pause = 1 TO 200: NEXT Pause
      PUT (X, 36), Plane%    'Remove plane from current position.
  NEXT X
  PUT (X + 10, 36), Plane%   'Move plane and dump pack.
  PUT (X, 50), Pack%
  PUT (X + 10, 36), Plane%   'Remove plane & pack.
  PUT (X, 50), Pack%
  X1 = X                     'Set x coordinate for drop.
  Y = 60                     'Set y coordinate for drop.
  FOR X = 121 TO 300     'Finish moving plane and chute.
      Y = Y + 1
      PUT (X, 36), Plane%     'Draw plane at current position.
      PUT (X1, Y), Chute%     'Draw chute at current position.
      FOR Pause = 1 TO 200: NEXT Pause
      PUT (X, 36), Plane%     'Remove plane.
      PUT (X1, Y), Chute%     'Remove chute.
      IF Y > 180 THEN RETURN  'Check if chute landed
  NEXT X
  FOR Pause = 1 TO 1000: NEXT Pause
RETURN

ReturnTextScreen:
  WIDTH 40
  LOCATE 10, 10
  PRINT "Program finished"
RETURN

