REM  PROGRAM CH5_2
REM  ****************************************
REM  *       Demonstration of a Queue       *
REM  *          Using a Ring Buffer         *
REM  ****************************************

DECLARE SUB QueueOnScreen ()
DECLARE SUB OnScreen ()
DECLARE SUB InQueue (Z AS ANY)
DECLARE FUNCTION NextFR! (FR AS INTEGER)
DECLARE SUB OutQueue (Z AS ANY)
DECLARE FUNCTION EmptyQueue! ()

TYPE Record
  X AS STRING * 15
  Y AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True

DIM SHARED MaxLength AS INTEGER, LengthQueue AS INTEGER
DIM SHARED Front AS INTEGER, Rear AS INTEGER
DIM SHARED Z AS Record

'      ***  Initialization of the Queue  ***
MaxLength = 5 'maximal length of the queue
DIM SHARED Queue(MaxLength) AS Record ' defining the array for the queue
Front = 1: Rear = 0: LengthQueue = 0

' *** Adding Elements to the Queue ***
Records:
DATA Abel, 1942,  Ball, 1934,  Carr, 1953,  Dixon, 1958
DATA Engel, 1902,  Ford, 1975,  Gardner, 1928
RESTORE Records:
FOR I = 1 TO 3
  READ Z.X, Z.Y
  CALL InQueue(Z) 'adding an element to the queue
NEXT I
CLS
PRINT "Adding 3 elements to the queue"
CALL QueueOnScreen 'output the Queue array onto the screen

' *** Removing an Element from the Queue ***
CALL OutQueue(Z)
PRINT "Removing an element from the queue"
CALL QueueOnScreen 'output the Queue array onto the screen

' *** Adding 2 Elements to the Queue ***
FOR I = 1 TO 2
  READ Z.X, Z.Y
  CALL InQueue(Z)
NEXT I
PRINT "Adding 2 elements to the queue"
CALL QueueOnScreen 'output the Queue array onto the screen

' *** Adding an Element to the Queue ***
  READ Z.X, Z.Y
  CALL InQueue(Z)
PRINT "Adding an element to the queue"
CALL QueueOnScreen

' ***   Outputting the Queue onto the Screen   ***
PRINT : PRINT : PRINT "Output of the queue onto the screen"
CALL OnScreen

END

FUNCTION EmptyQueue
'*** Checking the Queue for Emptiness ***
  IF LengthQueue = 0 THEN
    EmptyQueue = True
  ELSE
    EmptyQueu = False
   END IF
END FUNCTION

SUB InQueue (Z AS Record)
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
'*** Number of a Next Element in the Ring Buffer ***
  IF FR < MaxLength THEN
    NextFR = FR + 1
  ELSE
    NextFR = 1
  END IF
END FUNCTION

SUB OnScreen
' *** Outputting the Queue onto the Screen ***
  PRINT : PRINT , "Queue"
  IF EmptyQueue THEN
    PRINT "Queue is empty"
  ELSE
    DO
      CALL OutQueue(Z)
      PRINT Z.X, Z.Y
    LOOP UNTIL EmptyQueue
  END IF
END SUB

SUB OutQueue (Z AS Record)
'*** Removing an Element from the Queue ***
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

SUB QueueOnScreen
' *** Outputting the Queue Array onto the Screen ***
PRINT , "Array Queue"
PRINT "Index", "Z.X", , "Z.Y"
FOR I = 1 TO 5
  PRINT I, Queue(I).X, Queue(I).Y,
  IF (Front = I) AND (Rear = I) THEN
    PRINT "<-- Front, Rear"
  ELSEIF Front = I THEN
    PRINT "<-- Front"
  ELSEIF Rear = I THEN
    PRINT "<-- Rear"
  ELSE
    PRINT
  END IF
NEXT I
PRINT "Press any key to continue"
PRINT : PRINT
A$ = INPUT$(1)
PRINT
END SUB

