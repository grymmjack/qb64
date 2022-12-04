REM  PROGRAM CH5_7
REM  *************************************************
REM  *              Geographic Map                   *
REM  *  Searching for an Island of the Largest Area  *
REM  *************************************************

DECLARE FUNCTION Area! (X!, Y!)
DECLARE FUNCTION EmptyStack! ()
DECLARE SUB InStack (X!, Y!)
DECLARE SUB Version (X!, Y!, K!)
DECLARE SUB OutStack (Z AS ANY)
DECLARE SUB InitMap ()
DECLARE FUNCTION OnMap! (X!, Y!)

TYPE Coord
  X AS INTEGER
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True

DIM SHARED DeepStack, TopStack, MaxX, MaxY
DIM SHARED NextX, NextY
DIM SHARED Z AS Coord

RESTORE DataMap
' *** Initializing the map Map(MaxX, MaxY) ***
READ MaxX, MaxY
DIM SHARED Map(MaxX, MaxY) AS INTEGER
InitMap

' ***  Initialization of the Stack  ***
DeepStack = MaxX * MaxY 'maximum depth of the stack
DIM SHARED Stack(DeepStack) AS Coord ' array for the stack
TopStack = 0

' *** Searching for an Island of the Largest Area ***
AreaIsland = 0 'Area of the island
IslandX = 0    'Coordinates of a point
IslandY = 0    'which belongs to the island

FOR Y = 1 TO MaxY
  FOR X = 1 TO MaxX
    IF Map(X, Y) = -1 THEN
      S = Area((X), (Y))
      IF S > AreaIsland THEN
        AreaIsland = S
        IslandX = X
        IslandY = Y
      END IF
    END IF
  NEXT X
NEXT Y
CLS
PRINT "The island which contains the point ("; IslandX; ","; IslandY; ")"
PRINT "is of the largest area  S ="; AreaIsland; "."

DataMap:
  '   MaxX  MaxY
  DATA  18,   16
  'X = 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
  DATA 0, 0, 0, 0, 0, 0,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0,-1, 0, 0,-1,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0,-1,-1,-1,-1,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0,-1,-1,-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0, 0,-1,-1,-1, 0, 0,-1,-1,-1, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0,-1,-1,-1,-1, 0, 0, 0, 0,-1,-1, 0, 0, 0
  DATA 0, 0, 0, 0, 0, 0,-1,-1,-1, 0, 0, 0, 0,-1,-1,-1, 0, 0
  DATA 0, 0, 0, 0, 0, 0,-1,-1,-1, 0, 0, 0, 0, 0,-1,-1, 0, 0
  DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-1,-1, 0, 0
  DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-1,-1, 0, 0
  DATA 0, 0,-1,-1,-1,-1, 0, 0, 0, 0, 0,-1,-1,-1,-1,-1, 0, 0
  DATA 0, 0,-1,-1,-1,-1, 0, 0, 0, 0, 0,-1,-1,-1,-1, 0, 0, 0
  DATA 0, 0, 0, 0,-1,-1, 0, 0, 0, 0,-1,-1,-1, 0, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  DATA 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

END

FUNCTION Area (X, Y)
'** Calculating the area of the island containing the point (X, Y). **
'** Changing the value Map(U, V) to 1  **
'** for each square (U, V) of the island **
  IF Map(X, Y) = 0 THEN
    Area = 0
    EXIT FUNCTION
  END IF
  CALL InStack(X, Y)
  Map(X, Y) = 1
  S = 1
  WHILE NOT EmptyStack
    CALL OutStack(Z)
    X1 = Z.X: y1 = Z.Y
    FOR I = 1 TO 4
      CALL Version(X1, y1, I)
      IF OnMap(NextX, NextY) AND Map(NextX, NextY) = -1 THEN
        S = S + 1
        CALL InStack(NextX, NextY)
        Map(NextX, NextY) = 1
      END IF
    NEXT I
  WEND
  Area = S
END FUNCTION

FUNCTION EmptyStack
'** Checking  the Stack for Emptiness **
  IF TopStack = 0 THEN
    EmptyStack = True
  ELSE
    EmptyStack = False
  END IF
END FUNCTION

SUB InitMap
'** Defining an Array for the Geographic Map **
  FOR Y = 1 TO MaxY
    FOR X = 1 TO MaxX
      READ Map(X, Y)
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

FUNCTION OnMap (X, Y)
'** Checking the Point (X, Y) for Belonging to the Map **
OnMap = False
IF NextX >= 1 AND NextX <= MaxX THEN
  IF NextY >= 1 AND NextY <= MaxY THEN
    OnMap = True
  END IF
END IF
END FUNCTION

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

SUB Version (X, Y, K)
'** Defining the Version to Look through **
  SELECT CASE K
  CASE 1
   NextX = X - 1
   NextY = Y
  CASE 2
   NextX = X
   NextY = Y - 1
  CASE 3
   NextX = X + 1
   NextY = Y
  CASE 4
   NextX = X
   NextY = Y + 1
  END SELECT
END SUB

