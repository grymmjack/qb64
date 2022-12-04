REM  PROGRAM CH5_9
REM  *******************************************
REM  *  Arranging 8 Queens on the Chess Board  *
REM  *******************************************

DECLARE FUNCTION EmptyStack! ()
DECLARE SUB InStack (X!, Y!)
DECLARE SUB OutStack (Z AS ANY)
DECLARE SUB Version (Z AS ANY, Flag!)
DECLARE SUB StepForward (XY AS ANY)
DECLARE SUB StepBack (XY AS ANY)
DECLARE SUB Place ()
DECLARE SUB OnScreen ()

TYPE Coord
  X AS INTEGER
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True
CONST NumberFigurs = 8, MaxVersion = 8

DIM SHARED DeepStack, TopStack, MaxX, MaxY
DIM SHARED NextX, NextY
DIM SHARED XY AS Coord

' *** Initialization of the Chess Board  ***
MaxX = 8: MaxY = 8
DIM SHARED ChessBoard(MaxX, MaxY) AS INTEGER

' *** Initialization of Additional Arrays ***
DIM SHARED Horizontal(1 TO 8) AS INTEGER
DIM SHARED Diagonal1(2 TO 16) AS INTEGER
DIM SHARED Diagonal2(-7 TO 7) AS INTEGER
FOR I = 1 TO 8: Horizontal(I) = True: NEXT I
FOR I = 2 TO 16: Diagonal1(I) = True: NEXT I
FOR I = -7 TO 7: Diagonal2(I) = True: NEXT I

'      ***  Initialization of the Stack ***
DeepStack = NumberFigurs 'maximal depth of the stack
DIM SHARED Stack(DeepStack) AS Coord ' array for the stack
TopStack = 0

'       *** Backtrack Searching ***
XY.X = 1 'initializing the first step
XY.Y = 0 'initializing the version
Finish = False
DO WHILE XY.X <= NumberFigurs
  CALL Version(XY, Flg)  'selecting a version
  IF Flg = True THEN     'version is found
    CALL StepForward(XY) 'a step forth
  ELSEIF NOT EmptyStack THEN 'deadlock
    CALL StepBack(XY) 'a step back
  ELSE 'all steps are examined
    Finish = True
    EXIT DO
  END IF
LOOP

' *** Output of Results onto the Screen ***
IF Finish = True THEN
  PRINT "All versions are viewed!"
ELSE
  CALL Place 'arrangement of the queens on the chess board
  CALL OnScreen 'output of the arrangement of the queens to the screen
END IF
END

FUNCTION EmptyStack
'*** Checking the Stack for Emptiness ***
  IF TopStack = 0 THEN
    EmptyStack = True
  ELSE
    EmptyStack = False
  END IF
END FUNCTION

SUB InStack (X, Y)
  IF TopStack = DeepStack THEN
    PRINT "Error: Stack is full!"
    STOP
  ELSE
    TopStack = TopStack + 1
    Stack(TopStack).X = X
    Stack(TopStack).Y = Y
  END IF
END SUB

SUB OnScreen
'Displaying the arrangement of the queens
  CLS
  FOR J = MaxY TO 1 STEP -1
    FOR I = 1 TO MaxX
      PRINT ChessBoard(I, J);
    NEXT I
    PRINT
  NEXT J
END SUB

SUB OutStack (Z AS Coord)
IF TopStack = 0 THEN
    PRINT : PRINT "Error: Stack is empty!"
  STOP
  ELSE
    Z.X = Stack(TopStack).X
    Z.Y = Stack(TopStack).Y
    TopStack = TopStack - 1
  END IF
END SUB

SUB Place
'Arrangement of the queens on the chess board
  WHILE NOT EmptyStack
    CALL OutStack(XY)
    ChessBoard(XY.X, XY.Y) = 1
  WEND
END SUB

SUB StepBack (XY AS Coord)
'Steps Back a Square
  CALL OutStack(XY)
  I = XY.X: J = XY.Y
  Horizontal(J) = True
  Diagonal1(I + J) = True
  Diagonal2(I - J) = True
END SUB

SUB StepForward (XY AS Coord)
'Steps forward a square
  I = XY.X: J = XY.Y
  CALL InStack(I, J)
  Horizontal(J) = False
  Diagonal1(I + J) = False
  Diagonal2(I - J) = False
  XY.X = XY.X + 1          'Increments column for next queen
  XY.Y = 0
END SUB

SUB Version (Z AS Coord, Flag)
' ***      Determining an Admissible Version      ***
' * If an Admissible Version is Found then Flag = True *
  Flag = False
  I = Z.X: J = Z.Y
  WHILE J < MaxVersion AND Flag = False
    J = J + 1
    IF Horizontal(J) AND Diagonal1(I + J) AND Diagonal2(I - J) THEN
      Flag = True
      Z.Y = J
    END IF
  WEND
END SUB

