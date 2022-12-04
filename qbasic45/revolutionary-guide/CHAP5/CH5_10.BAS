REM  PROGRAM CH5_10
REM  ****************************************
REM  *   Demonstration of List Operations   *
REM  ****************************************

DECLARE SUB DeleteNode (P AS INTEGER)
DECLARE SUB RearList (P AS INTEGER)
DECLARE SUB Search (P AS INTEGER, Str AS STRING, Indicator AS INTEGER)
DECLARE SUB AddNode (Z AS ANY, P AS INTEGER)
DECLARE SUB HeadList (P AS INTEGER)
DECLARE SUB NextNode (P AS INTEGER)
DECLARE SUB InitList ()
DECLARE FUNCTION EmptyList! ()
DECLARE FUNCTION EndList! (P AS INTEGER)
DECLARE SUB OnScreen ()
DECLARE SUB OListOnScreen ()

TYPE Node
  Info AS STRING * 15
  Pntr AS INTEGER
END TYPE

CONST True = -1
CONST False = NOT True
CONST Nil = 0

DIM SHARED MaxIndex AS INTEGER 'maximum size of the list
DIM SHARED PntrList AS INTEGER 'pointer of the list
DIM SHARED XP AS Node

'      ***  Initialization of the List  ***
MaxIndex = 6 'maximum size of the list
DIM SHARED OList(-1 TO MaxIndex) AS Node ' array for the list
CALL InitList
CLS
CALL OListOnScreen 'outputting OList array onto the screen

' **************************************************
' * Adding 3 Elements to the Beginning of the List *
' **************************************************
Names:
DATA Ivanov, Sidorov, Petrov
CALL HeadList(PntrList) 'setting the pointer to the start of the list
RESTORE Names:
FOR I = 1 TO 3
  READ XP.Info
  CALL AddNode(XP, PntrList) 'adding an element after the pointer
  CALL NextNode(PntrList) 'moving the pointer forth
NEXT I
PRINT "Adding 3 elements to the beginning of the list "
CALL OListOnScreen 'outputting OList array onto the screen

' ***********************************************
' *  Adding a New Record "Romanov"              *
' *  Next to the Element Containing             *
' *  the Value "Sidorov" in the Info Field      *
' ***********************************************
CALL HeadList(PntrList) 'setting pointer to the beginning of the list
CALL Search(PntrList, "Sidorov", Indicator%) 'searching for the element
IF Indicator% = False THEN
  PRINT "Element of the specified value is not found"
ELSE
  XP.Info = "Romanov"
  CALL AddNode(XP, PntrList)
END IF
PRINT "Adding the element Romanov after the elment Sidorov"
CALL OListOnScreen

'***************************************************************
'* Adding the Element "Voronov"  to the Beginning of the List  *
'***************************************************************
CALL HeadList(PntrList)
XP.Info = "Voronov"
CALL AddNode(XP, PntrList)
PRINT "Adding the element "; Voronov; "  to the beginning of the list"
CALL OListOnScreen

' ********************************************************
' *  Removing the Record Next to the Element Containing  *
' *  the Value "Sidorov" in the Info Field               *
' ********************************************************
CALL HeadList(PntrList)
CALL Search(PntrList, "Sidorov", Indicator%)
IF Indicator% = False THEN
  PRINT "Element of the specified value is not found"
ELSE
  CALL DeleteNode(PntrList)
END IF
PRINT "Removing the element next to Sidorov"
CALL OListOnScreen 'outputting the OList array onto the screen
CALL OnScreen 'outputting the list onto the screen

'******************************************************
'*  Adding the Element "Titov" to the End of the List *
'******************************************************
CALL RearList(PntrList) 'setting pointer to the end of the list
XP.Info = "Titov"
CALL AddNode(XP, PntrList)
PRINT "Adding the element Titov to the end of the list"
CALL OListOnScreen

PRINT : PRINT : PRINT "Outputting the list onto the screen"
CALL OnScreen

END

SUB AddNode (Z AS Node, P AS INTEGER)
' ** Add the Element Z Next to the Pointer P ***
  IF OList(0).Pntr = Nil THEN 'array OList is filled
    PRINT "Error: List is full!"
    STOP
  ELSE 'array OList is not filled
    Pntr1 = OList(0).Pntr
    OList(0).Pntr = OList(Pntr1).Pntr
    OList(Pntr1).Pntr = OList(P).Pntr
    OList(Pntr1).Info = Z.Info
    OList(P).Pntr = Pntr1
  END IF
END SUB

SUB DeleteNode (P AS INTEGER)
'*** Remove the element Pointed by P ***
  IF EndList(P) THEN
    PRINT : PRINT "Error: Pointer is at the end of the list!"
    STOP
  ELSE
    Q = OList(P).Pntr
    OList(P).Pntr = OList(Q).Pntr
    OList(Q).Pntr = OList(0).Pntr
    OList(0).Pntr = Q
  END IF
END SUB

FUNCTION EmptyList
'     *** List is Empty ***
  IF OList(-1).Pntr = Nil THEN
    EmptyList = True
  ELSE
    EmptyList = False
  END IF
END FUNCTION

FUNCTION EndList (P AS INTEGER)
'*** Pointer at the End of the List ***
  IF OList(P).Pntr = Nil THEN
    EndList = True
  ELSE
    EndList = False
  END IF
END FUNCTION

SUB HeadList (P AS INTEGER)
' *** Set the pointer at the Beginning of the List ***
    P = -1
END SUB

SUB InitList
' *** Make the list Empty ***
  OList(-1).Pntr = Nil 'head of the list
  OList(0).Pntr = 1 'head of the list of free nodes
  FOR I = 1 TO MaxIndex - 1
    OList(I).Pntr = I + 1
  NEXT I
  OList(MaxIndex).Pntr = Nil
END SUB

SUB NextNode (P AS INTEGER)
' *** Move the List's Pointer Forth ***
  IF EndList(P) THEN
    PRINT "Error: Pointer is at the end of the list!"
    STOP
  ELSE
    P = OList(P).Pntr
  END IF
END SUB

SUB OListOnScreen
'*** Output of the OList Array to the Screen ***
PRINT , "Array OList"
PRINT "Index", "Info", , "Pntr"
PRINT -1, OList(-1).Info, OList(-1).Pntr; " <-- Head1"
PRINT 0, OList(0).Info, OList(0).Pntr; " <-- Head2"
FOR I = 1 TO 6
  PRINT I, OList(I).Info, OList(I).Pntr
NEXT I
PRINT "Press any key to continue"
A$ = INPUT$(1)
PRINT
END SUB

SUB OnScreen
' *** Output of the List to the Screen ***
  PRINT : PRINT , "List"
  CALL HeadList(PntrList)
  IF EmptyList THEN
    PRINT "List is empty"
  ELSE
    WHILE OList(PntrList).Pntr <> Nil
      CALL NextNode(PntrList)
      PRINT OList(PntrList).Info
    WEND
  END IF
PRINT "Press any key to continue"
A$ = INPUT$(1)
END SUB

SUB RearList (P AS INTEGER)
'***  Setting the Pointer to the End of the List ***
  CALL HeadList(P)
  WHILE OList(P).Pntr <> Nil
    CALL NextNode(P)
  WEND
END SUB

SUB Search (P AS INTEGER, Str AS STRING, Indicator AS INTEGER)
'*********************************************************
'***  Searching for the element with the value Str     ***
'***  in the Info Field, Beginning from the Position P ***

' Indicator = False, if the element with the Str value is not found,
' otherwise Indicator = True and P points to the detected element

  IF EmptyList THEN
    Indicator = False
  ELSE
    Indicator = 2
    DO WHILE Indicator = 2
      IF RTRIM$(OList(P).Info) = Str THEN
        Indicator = True
        EXIT DO
      END IF
      IF EndList(P) THEN
        Indicator = False
      ELSE
        CALL NextNode(P)
      END IF
    LOOP
  END IF
END SUB

SUB TakeNode (Z AS Node, P AS INTEGER)
' *** Retrieve the Element Z Pointed by P ***
  IF EndList(P) THEN
    PRINT : PRINT "Error: Pointer is at the end of the list!"
    STOP
  ELSE
    Z.Pntr = OList(P).Pntr
    Z.Info = OList(P).Info
  END IF
END SUB

