REM  PROGRAM CH5_8
REM  *************************************************
REM  *               Geographic Map                  *
REM  *             Building a Sea Port               *
REM  *************************************************
DECLARE SUB Mark (X!, Y!)
DECLARE SUB Wave (X!, Y!, L!)
DECLARE SUB InStack2 (X!, Y!)
DECLARE SUB OutStack2 (Z AS ANY)
DECLARE FUNCTION EmptyStack2! ()
DECLARE SUB Path (X!, Y!, L!)
DECLARE FUNCTION EmptyStack! ()
DECLARE SUB InStack (X!, Y!)
DECLARE SUB OutStack (Z AS ANY)
DECLARE SUB InitMap ()
DECLARE SUB MapOnScreen (X!, Y!, M() AS INTEGER)

TYPE Coord
  X AS INTEGER
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True

DIM SHARED DeepStack, TopStack, TopStack2, MaxX, MaxY
DIM SHARED NextX, NextY
DIM SHARED Port1X, Port1Y, Port2X, Port2Y
DIM SHARED A0, B0
DIM SHARED XY AS Coord

' *** Initializing the map Map(MaxX, MaxY) ***
RESTORE DataMap
READ MaxX, MaxY
DIM SHARED Map(MaxX + 1, MaxY + 1) AS INTEGER
InitMap

' *** Mounting the Map with the Squares Carrying -2 Values ***
FOR X = 0 TO MaxX + 1
  Map(X, 0) = -2
  Map(X, MaxY + 1) = -2
NEXT X
FOR Y = 0 TO MaxY + 1
  Map(0, Y) = -2
  Map(MaxX + 1, Y) = -2
NEXT Y

DataMap:
  '   MaxX  MaxY
  DATA  50,   16
  '     0        1         2         3         4         5
  'X =  12345678901234567890123456789012345678901234567890
  DATA "00000000000000000000000000000000000000000000000000"
  DATA "00010011000000000000000000000000000000000111110000"
  DATA "00011111000000000000000000000000001100000001110000"
  DATA "00000111000000000000000000001111111111111000000000"
  DATA "00000011100111000000000000001100000000000000000000'
  DATA "01110011100001100000000000001100000000000000000000"
  DATA "00110011100001110000000000001100000000000000000000"
  DATA "00100011100000110000000011111100000111111000000000"
  DATA "00001110000000110000000011111100011111000000000000"
  DATA "00000100000000110000000010001100001111100000000000"
  DATA "00111100000111110000000110000111100000000000000000"
  DATA "00111100000111100000000110000000111111111111110000"
  DATA "00001100001110000001100000000010000000001111000000"
  DATA "01101100000000000001111111110011100000111100000000"
  DATA "00100000000000000000000001110000000000000000000000"
  DATA "00000000000000000000000000000000000000000000000000"

'      ***  Initialization of the Stacks ***
DeepStack = MaxX * MaxY 'maximum depth of the stacks
DIM SHARED Stack(DeepStack) AS Coord ' array for the stacks
TopStack = 0
TopStack2 = DeepStack

'***     Array of Coordinates Increments     ***
'***     to Determine the Next Version       ***

DIM SHARED Delta(4) AS Coord
RESTORE VersionData
FOR I = 1 TO 4
  READ Delta(I).X, Delta(I).Y
NEXT I

VersionData:
DATA -1, 0, 0, -1, 1, 0, 0, 1

Port1X = 4    'Coordinates of the port
Port1Y = 7    'on the first island

CLS
CALL MapOnScreen(MaxX, MaxY, Map())
COLOR 7, 0
PRINT "The first port is marked with the symbol "; CHR$(34); "░"; CHR$(34)
PRINT "Enter two coordinates of a point from the island for the second port:";
INPUT " ", IslandX, IslandY

'Marking the points of the second island with the number (-3)
CALL Mark(IslandX, IslandY)

' ***  Plotting Isometric Lines on the Map   ***
' *** and Calculating the Distance to the Second Island ***
CALL Wave(Port1X, Port1Y, Length)

' *** Plotting the Second Port on the Map ***
LOCATE A0 + Port2Y, B0 + Port2X
COLOR 15
PRINT CHR$(177)
LOCATE A0 + MaxY + 1, 1
PRINT "The port should be built in the point ("; Port2X; ","; Port2Y; ")"
PRINT STRING$(80, " ")
LOCATE A0 + MaxY + 2, 1
PRINT "The distance between the ports equals"; Length - 1

'*** Calculating the Shortest Path between the Ports  ***
' ***       and Plotting It on the Map          ***
PRINT "The path between the ports is marked by"; CHR$(34); "*"; CHR$(34)
CALL Path(Port2X, Port2Y, Length)

END

FUNCTION EmptyStack
'*** Checking the Stack for Emptiness ***
  IF TopStack = 0 THEN
    EmptyStack = True
  ELSE
    EmptyStack = False
  END IF
END FUNCTION

FUNCTION EmptyStack2
'*** Проверка пустоты стека ***
  IF TopStack2 = DeepStack THEN
    EmptyStack2 = True
  ELSE
    EmptyStack2 = False
  END IF
END FUNCTION

SUB InitMap
'** Defining an Array for the Geographic Map **

  FOR Y = 1 TO MaxY
    READ M$
    FOR X = 1 TO MaxX
      Map(X, Y) = -VAL(MID$(M$, X, 1))
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

SUB InStack2 (X, Y)
  IF TopStack2 = 1 THEN
    PRINT "Error: Stack is full!"
    STOP
  ELSE
    TopStack2 = TopStack2 - 1
    Stack(TopStack2).X = X
    Stack(TopStack2).Y = Y
  END IF
END SUB

SUB MapOnScreen (X, Y, M() AS INTEGER)
  LOCATE 1, 1
  PRINT "   Geographic map"
  A0 = 2
  B0 = 3
  FOR I = 1 TO X
    LOCATE A0, B0 + I
    PRINT CHR$(48 + (I MOD 10))
  NEXT I
  FOR J = 1 TO Y
    LOCATE A0 + J, B0
    PRINT CHR$(48 + (J MOD 10))
  NEXT J
  FOR I = 1 TO X
    FOR J = 1 TO Y
      LOCATE A0 + J, B0 + I
      IF Map(I, J) = -1 THEN
        COLOR 2
        PRINT CHR$(219)  'Solid of island
      ELSE
        COLOR 9
        PRINT CHR$(126)  'Tilde of the waves
      END IF
    NEXT J
  NEXT I
  COLOR 15
  LOCATE A0 + Port1Y, B0 + Port1X
  PRINT CHR$(177)
  LOCATE A0 + MaxY + 1, 1
END SUB

SUB Mark (X, Y)
'** Changing the value Map(U, V) to -3  **
'** for each square (U, V) of the island **

  IF Map(X, Y) = 0 THEN
    PRINT "The point does not belong to the island!"
     STOP
  END IF
  CALL InStack(X, Y)
  Map(X, Y) = -3
  WHILE NOT EmptyStack
    CALL OutStack(XY)
    X1 = XY.X: Y1 = XY.Y
    FOR I = 1 TO 4
      NextX = X1 + Delta(I).X
      NextY = Y1 + Delta(I).Y
      IF Map(NextX, NextY) = -1 THEN
        CALL InStack(NextX, NextY)
        Map(NextX, NextY) = -3
      END IF
    NEXT I
  WEND
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

SUB OutStack2 (Z AS Coord)
IF TopStack2 = DeepStack THEN
    PRINT : PRINT "Error: Stack is empty!"
  STOP
  ELSE
    Z.X = Stack(TopStack2).X
    Z.Y = Stack(TopStack2).Y
    TopStack2 = TopStack2 + 1
  END IF
END SUB

SUB Path (X, Y, L)
' *** Searching for a Path of the L Length from the point (X, Y) ***
' ***  to the First Port  ***

  TopStack = 0
  L = L - 1
  WHILE L > 0
    FOR I = 1 TO 4
      NextX = X + Delta(I).X
      NextY = Y + Delta(I).Y
      IF Map(NextX, NextY) = L THEN
        CALL InStack(NextX, NextY)
        X = NextX
        Y = NextY
        EXIT FOR
      END IF
    NEXT I
    L = L - 1
  WEND

' *** Displaying the Path from the First Port to the Second One ***
  WHILE NOT EmptyStack
    CALL OutStack(XY)
    X1 = XY.X: Y1 = XY.Y
    LOCATE A0 + Y1, B0 + X1
    COLOR 15
    PRINT "*"
  WEND
END SUB

SUB Wave (X, Y, L)
' ***           Wave Algorithm                   ***
' *** Plotting Isometric Lines on the Map        ***
' *** Beginning from the point (X, Y)            ***
' *** L is the distance from the point (X, Y)    ***
' *** to the island marked by the number (-3)    ***

TopStack = 0           'clearing the first stack
TopStack2 = DeepStack  'clearing the second stack
CALL InStack(X, Y)
St = 1
L = 1
Flag = False
WHILE Flag = False
  IF St = 1 THEN
    DO WHILE NOT EmptyStack
      CALL OutStack(XY)
      X1 = XY.X
      Y1 = XY.Y
      FOR I = 1 TO 4
        NextX = X1 + Delta(I).X
        NextY = Y1 + Delta(I).Y
        IF Map(NextX, NextY) = -3 THEN
          Flag = True
          Port2X = NextX
          Port2Y = NextY
          EXIT DO
        END IF
        IF Map(NextX, NextY) = 0 THEN
          Map(NextX, NextY) = L
          CALL InStack2(NextX, NextY)
        END IF
      NEXT I
    LOOP
    St = 2
  ELSE
    DO WHILE NOT EmptyStack2
      CALL OutStack2(XY)
      X1 = XY.X
      Y1 = XY.Y
      FOR I = 1 TO 4
        NextX = X1 + Delta(I).X
        NextY = Y1 + Delta(I).Y
        IF Map(NextX, NextY) = -3 THEN
          Flag = True
          Port2X = NextX
          Port2Y = NextY
          EXIT DO
        END IF
        IF Map(NextX, NextY) = 0 THEN
          Map(NextX, NextY) = L
          CALL InStack(NextX, NextY)
        END IF
      NEXT I
    LOOP
    St = 1
  END IF
  L = L + 1
WEND
END SUB

