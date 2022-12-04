REM Demonstration of the WINDOW statement #2
REM \CHAP3\CH3_19.BAS

Declare SUB DrawFigure ()
'DRAW 3 faces in different sizes and locations
SCREEN 1, 0
CALL DrawFigure
WINDOW SCREEN (0, 0)-(900, 600)
CALL DrawFigure
WINDOW SCREEN (-50, 50)-(190, 190)
CALL DrawFigure
f$ = INPUT$(1)

END

SUB DrawFigure
  CIRCLE (160, 80), 20
  PAINT (160, 80), 2, 3
  CIRCLE (150, 76), 2, 0
  CIRCLE (170, 76), 2, 0
  PSET (155, 90), 0
  LINE -(160, 92), 0
  LINE -(165, 90), 0
END SUB

