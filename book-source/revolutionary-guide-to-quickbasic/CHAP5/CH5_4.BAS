REM  PROGRAM CH5_4
REM  ********************************
REM  *    Path in a Labyrinth       *
REM  *       New Version            *
REM  ********************************

DECLARE SUB InitMatrix ()
DECLARE FUNCTION EmptyStack! ()
DECLARE SUB InStack (X!, Y!)
DECLARE SUB OutStack (Z AS ANY)
DECLARE SUB Version (Z AS ANY, Flag!)
DECLARE SUB StepForward (XY AS ANY)
DECLARE SUB StepBack (XY AS ANY)

TYPE Coord
  X AS INTEGER
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True

DIM SHARED DeepStack, TopStack, MaxV
DIM SHARED XY AS Coord

' *** Initializing the Labyrinth ***
MaxV = 18 'number of the rooms in the labyrinth
DIM SHARED Matrix(MaxV, MaxV) AS INTEGER
InitMatrix

' *** Initialization of the Array of the Rooms Passed***
DIM SHARED Vertex(1 TO MaxV) AS INTEGER
FOR I = 1 TO MaxV: Vertex(I) = True: NEXT I

'      ***  Initialization of the Stack ***
DeepStack = MaxV 'maximum depth of the stack
DIM SHARED Stack(DeepStack) AS Coord ' array for the stack
TopStack = 0

CLS
PRINT "Search for a path in a labyrinth"
INPUT "Enter the number of the start node (1 - 18) = ", NumberBegin
INPUT "Enter the number of the end node (1 - 18) = ", NumberEnd

' ***   Depth Search    ***
XY.X = NumberEnd                  'initializing the first step
Vertex(XY.X) = False
XY.Y = 0                          'initializing the version
PRINT "List of the nodes detected:"
PRINT XY.X;
Finish = False
DO WHILE Finish = False AND NumberBegin <> XY.X
  CALL Version(XY, Flg)  'selecting a new node
  IF Flg = True THEN     'new node is found
    CALL StepForward(XY) 'step forward
    PRINT XY.X;
  ELSEIF NOT EmptyStack THEN 'deadlock
    CALL StepBack(XY) 'step backward
  ELSE 'all steps are examined
    Finish = True
  END IF
LOOP
PRINT : PRINT "Search is completed"

' *** Result ***
PRINT "Path from node"; NumberBegin; "to node"; NumberEnd; ":"
PRINT NumberBegin;
DO WHILE NOT EmptyStack
  CALL OutStack(XY)
  PRINT XY.X;
LOOP

DataMatrix:
'V = 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
DATA 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
DATA 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
DATA 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0
DATA 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0
DATA 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0

END

FUNCTION EmptyStack
'*** Checking the Stack for Emptiness ***
  IF TopStack = 0 THEN
    EmptyStack = True
  ELSE
    EmptyStack = False
  END IF
END FUNCTION

SUB InitMatrix
' *** Defining an Adjacency Mtrix for the Labyrinth ***
  RESTORE DataMatrix
  FOR Y = 1 TO MaxV
    FOR X = 1 TO MaxV
      READ Matrix(X, Y)
    NEXT X
  NEXT Y
END SUB

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

SUB StepBack (XY AS Coord)
'Step backward
  CALL OutStack(XY)
END SUB

SUB StepForward (XY AS Coord)
' *** Step forward ***
  I = XY.X: J = XY.Y
  CALL InStack(I, J)
  Vertex(J) = False
  XY.X = XY.Y
  XY.Y = 0
END SUB

SUB Version (Z AS Coord, Flag)
' ***      Determining an Admissible Version      ***
' * If an Admissible Version is Found then Flag = True *

  Flag = False
  I = XY.X: J = Z.Y
  WHILE J < MaxV AND Flag = False
    J = J + 1
    IF Matrix(I, J) = 1 THEN
      IF Vertex(J) = True THEN
        Flag = True
        Z.Y = J
      END IF
    END IF
  WEND
END SUB

