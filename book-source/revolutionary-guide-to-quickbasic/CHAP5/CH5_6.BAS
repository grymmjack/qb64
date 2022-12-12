REM  PROGRAM CH5_6
REM  ****************************************************
REM  *  Searching for the Shortest Path in a Labyrinth  *
REM  ****************************************************

DECLARE SUB OnScreen ()
DECLARE SUB Version (Z AS ANY, Flag!)
DECLARE SUB InQueue (Z AS ANY)
DECLARE SUB OutQueue (Z AS ANY)
DECLARE SUB StepBack (Z AS ANY)
DECLARE SUB StepForward (Z AS ANY)
DECLARE SUB InitMatrix ()
DECLARE FUNCTION NextFR! (FR AS INTEGER)
DECLARE FUNCTION EmptyQueue! ()

TYPE Coord
  X AS INTEGER
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True

DIM SHARED MaxLength AS INTEGER, LengthQueue AS INTEGER
DIM SHARED Front AS INTEGER, Rear AS INTEGER
DIM SHARED MaxV AS INTEGER, XY AS Coord

' *** Initialization of the Labyrinth ***
MaxV = 18 'number of the rooms in the labyrinth
DIM SHARED Matrix(MaxV, MaxV) AS INTEGER
InitMatrix

' *** Initialization of the Array of the Rooms Passed ***
DIM SHARED Vertex(1 TO MaxV) AS INTEGER
FOR I = 1 TO MaxV: Vertex(I) = True: NEXT I

DIM Preceding(MaxV) AS INTEGER 'Array of the preceeding rooms

'      ***  Initialization of the Queue  ***
MaxLength = MaxV 'maximal length of the queue
DIM SHARED Queue(MaxLength) AS Coord ' array for the queue
Front = 1: Rear = 0: LengthQueue = 0

CLS : PRINT "Searching for the shortest path in the labyrinth"
INPUT "Number of the start node (1 - 18) = ", NumberBegin
INPUT "Number of the end node (1 - 18) = ", NumberEnd
     

' ***   Breadth Search   ***
XY.X = NumberEnd               'Initializing the first step
Vertex(XY.X) = False
Preceding(XY.X) = -1
XY.Y = 0 'initializing the version
PRINT "List of found nodes:"
PRINT XY.X;
Finish = False
DO WHILE Finish = False
  CALL Version(XY, Flg)  'selecting a new node
  IF Flg = True THEN     'new node is found
    Preceding(XY.Y) = XY.X
    CALL StepForward(XY) 'step forward
    PRINT XY.Y;
    IF XY.Y = NumberBegin THEN
      Finish = True
    END IF
  ELSEIF NOT EmptyQueue THEN 'deadlock
    CALL StepBack(XY) 'step backward
  ELSE 'all steps are examined
    Finish = True
  END IF
LOOP
PRINT : PRINT "Search is completed"
OnScreen
END

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

FUNCTION EmptyQueue
'*** Checking the Queue for Emptiness ***
  IF LengthQueue = 0 THEN
    EmptyQueue = True
  ELSE
    EmptyQueu = False
  END IF
END FUNCTION

SUB InitMatrix
' *** Defining the Adjacency Matrix for the Labyrinth  ***

  RESTORE DataMatrix
  FOR Y = 1 TO MaxV
    FOR X = 1 TO MaxV
      READ Matrix(X, Y)
    NEXT X
  NEXT Y
END SUB

SUB InQueue (Z AS Coord)
'*** Adding an Element to the Queue ***
  IF LengthQueue = MaxLength THEN
    PRINT "Error: Queue is full!"
      STOP
  ELSE
    Rear = NextFR(Rear)
    Queue(Rear).X = Z.X
    Queue(Rear).Y = Z.Y
    LengthQueue = LengthQueue + 1
  END IF
END SUB

FUNCTION NextFR (FR AS INTEGER)
'*** Number of the Next Element in the Ring Buffer ***

  IF FR < MaxLength THEN
    NextFR = FR + 1
  ELSE
    NextFR = 1
  END IF
END FUNCTION

SUB OnScreen
' *** Output of Results  ***
  SHARED Preceding() AS INTEGER
  SHARED NumberBegin, NumberEnd
  PRINT "Path from node"; NumberBegin; "to node"; NumberEnd; ":"
  PRINT NumberBegin;
  I = NumberBegin
  DO WHILE Preceding(I) <> -1
    I = Preceding(I)
    PRINT I;
  LOOP
END SUB

SUB OutQueue (Z AS Coord)
'*** Removing an Element from the Queue***
IF LengthQueue = 0 THEN
    PRINT : PRINT "Error: Queue is empty!"
  STOP
  ELSE
    Z.X = Queue(Front).X
    Z.Y = Queue(Front).Y
    LengthQueue = LengthQueue - 1
    IF LengthQueue <> 0 THEN
      Front = NextFR(Front)
    ELSE
      Front = 1: Rear = 0
    END IF
  END IF
END SUB

SUB StepBack (Z AS Coord)
' *** Step backward ***
  CALL OutQueue(Z)
  Z.X = Z.Y
  Z.Y = 0
END SUB

SUB StepForward (Z AS Coord)
' *** Step forward ***
  CALL InQueue(Z)
  Vertex(Z.Y) = False
END SUB

SUB Version (Z AS Coord, Flag)
' ***      Determining an Admissible Version      ***
' * If an Admissible Version is Found then Flag = True *

  Flag = False
  I = Z.X: J = Z.Y
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

