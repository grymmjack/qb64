REM  PROGRAM CH5_11
REM  ***************************************************
REM  *       Demonstration of a Cycle List             *
REM  *    Program "Counting" (Children's game)         *
REM  ***************************************************

DECLARE SUB AddNode (NI AS INTEGER, Z AS ANY, P AS INTEGER)
DECLARE SUB NextNode (P AS INTEGER)
DECLARE SUB CListOnScreen ()
DECLARE SUB InitList ()
DECLARE SUB DeleteNode (NI AS INTEGER, P AS INTEGER)
DECLARE SUB Selection (K AS INTEGER)

TYPE Node
  Info AS STRING * 19
  Pntr AS INTEGER
END TYPE

TYPE Head
  L AS INTEGER
  Pntr AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True
CONST Nil = 0

DIM SHARED MaxIndex AS INTEGER 'maximal size of the array
DIM SHARED NumberList AS INTEGER 'number of lists
DIM SHARED PntrList AS INTEGER 'poiter of the list
DIM SHARED XP AS Node

NumberList = 1  'number of lists
DIM SHARED Lst(NumberList) AS Head ' array of external pointers

'      ***  Initialization of the Lists  ***
MaxIndex = 14 'maximum size of the array
DIM SHARED CList(MaxIndex) AS Node ' array for the list
CALL InitList

' ***********************************
' * Creating a List of 10 Elements  *
' ***********************************
Names:
DATA Jumping Jeremy, Ethel Frogkiller, Arthur Loosenoose, Admirable Adrian
DATA Eddy Mophead, Gurgling Gither, Gregory Flapperback
DATA Technical Tim, Gorgeous Graham, Cycling Sally
RESTORE Names:
READ XP.Info
CALL AddNode(1, XP, PntrList)
PntrList = Lst(1).Pntr
FOR I = 1 TO 9
  READ XP.Info
  CALL AddNode(1, XP, PntrList) 'adding an element
  CALL NextNode(PntrList) 'moving the pointer forward
NEXT I
CLS
CALL CListOnScreen 'outputting the CList array onto the screen

PRINT "Enter the ordinal number of the element to be removed (K >= 2)";
INPUT " ", K%

CALL Selection(K%)

END

SUB AddNode (NI AS INTEGER, Z AS Node, P AS INTEGER)
' ** Add the Element Z to the List number NI, Next to the Pointer P **
' ** If the NI List is Empty, P is not used     **
  IF Lst(0).Pntr = 0 THEN 'array CList is filled
    PRINT "Error: no room!"
    STOP
  ELSE 'there is room in the CList array
    'removing an element from the list 0
    Pntr1 = Lst(0).Pntr 'pointing to a free element
    Lst(0).L = Lst(0).L - 1
    Lst(0).Pntr = CList(Pntr1).Pntr
    'adding an element to the list NI
    CList(Pntr1).Info = Z.Info
    IF Lst(NI).L = 0 THEN
      Lst(NI).Pntr = Pntr1
      CList(Pntr1).Pntr = Pntr1
    ELSE
      CList(Pntr1).Pntr = CList(P).Pntr
      CList(P).Pntr = Pntr1
    END IF
    Lst(NI).L = Lst(NI).L + 1
  END IF
END SUB

SUB CListOnScreen
PRINT , "Array CList"
PRINT "Index", "Info", , "Pntr"
FOR I = 1 TO MaxIndex
  PRINT I, CList(I).Info, CList(I).Pntr
NEXT I
PRINT
END SUB

SUB DeleteNode (NI AS INTEGER, P AS INTEGER)
'*** Remove the Element Next to the P Pointer in the List NI ***
  IF Lst(NI).L = 0 THEN
    PRINT "Error: list "; NI; " is empty!"
    STOP
  ELSE
    'Removing an element from the list NI
    Q = CList(P).Pntr 'pointer to the element to be removed
    R = CList(Q).Pntr
    CList(P).Pntr = R
    IF Lst(NI).Pntr = Q THEN
       Lst(NI).Pntr = R
    END IF
    Lst(NI).L = Lst(NI).L - 1
    'Adding an element that has became free to the list 0
    CList(Q).Pntr = Lst(0).Pntr
    Lst(0).Pntr = Q
    Lst(0).L = Lst(0).L + 1
  END IF
END SUB

SUB InitList
' *** Initialization of the Lists ***
  FOR I = 1 TO NumberList
    Lst(I).Pntr = Nil 'poiter of the head of the list I
    Lst(I).L = 0 'number of elements in the list I
  NEXT I
  Lst(0).Pntr = 1 'pointer of the list of free nodes
  Lst(0).L = MaxIndex 'number of elements in the list of free nodes
  FOR I = 1 TO MaxIndex - 1
    CList(I).Pntr = I + 1
  NEXT I
  CList(MaxIndex).Pntr = Nil
END SUB

SUB NextNode (P AS INTEGER)
' *** Move the Pointer P Forward  ***
    P = CList(P).Pntr
END SUB

SUB Selection (K AS INTEGER)
' *  Removing Kth element from the List (K >= 2)  *
PRINT "Order in which the elements are removed:"
PntrList = Lst(1).Pntr
WHILE Lst(1).L > 1
  FOR I = 1 TO K - 2
    CALL NextNode(PntrList)
  NEXT I
  Pntr1 = CList(PntrList).Pntr
  PRINT CList(Pntr1).Info; " ";
  CALL DeleteNode(1, PntrList)
  CALL NextNode(PntrList)
WEND
PRINT : PRINT "Element left is:"
PRINT CList(PntrList).Info
END SUB

