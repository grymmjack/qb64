REM   PROGRAM CH5_13
REM   **************************************************
REM   *        Adding Records by Insertion             *
REM   *                                                *
REM   **************************************************

DEFINT A-Z      ' Default type integer.
  DECLARE SUB Appe ()
  DECLARE SUB InRecno ()
  DECLARE SUB PrintArray ()
'Definition of a record. Key field is numeric
  TYPE SortType
     KeySort AS INTEGER
     Info AS STRING * 40
'     KeySort AS STRING * 40
'     Info AS INTEGER
  END TYPE
' Number of records <= 1000
  DIM SHARED SortArray(1 TO 1000) AS SortType
  DIM SHARED MaxRec, AppeRec AS SortType, x AS SortType
   CLS
   MaxRec = 0
DO
   PRINT
   PRINT "PROGRAM  OF  ADDING  DATA"
   PRINT "Print Ctrl-Break to exit"
   InRecno
   PRINT "      SORTED  DATA "
   PrintArray
LOOP
  END
'                       ***

SUB Appe STATIC
'                 *        Appe          *
'inputs: SortArray,MaxRec,AppeRec
'output: SortArray,MaxRec
'Initial array SortArray is sorted by the key KeySort
'MaxRec -number of records in the initial array is increased by one
'AppeRec-a record being added
      x.KeySort = AppeRec.KeySort  ' take the key of i-th record for insertion
      FOR J = MaxRec + 1 TO 2 STEP -1'j-current index of the ready array
         ' If J-1-th element is less than the element to insert,
         ' it is shifted to the right
         IF SortArray(J - 1).KeySort > x.KeySort THEN
            SortArray(J) = SortArray(J - 1)
         ' Otherwise, exit the FOR...NEXT loop:
         ELSE
            EXIT FOR
         END IF
      NEXT J
      ' Inserting the record into SortArray(j)
         SortArray(J) = AppeRec
         MaxRec = MaxRec + 1

END SUB

SUB InRecno
'output: SortArray
'Entering a record into SortArray
' The record consists of the Info and KeySort fields
' Appe adds a record to SortArray
   PRINT USING "You have created  ###  records"; MaxRec
   IF MaxRec <> 0 THEN INPUT " How many records are to be left"; MaxRec

   INPUT "How many records are to be added"; n
   FOR i = 1 TO n
     PRINT "Record"; i; ":";
'KeySort - integer
     INPUT "     Birth Year:"; AppeRec.KeySort
     INPUT "                     Name:"; AppeRec.Info
'KeySort - string
'    INPUT "           Name:"; AppeRec.KeySort
'    INPUT "              Birth  Year:"; AppeRec.Info
     Appe
   NEXT i
   PRINT
END SUB

 SUB PrintArray
'input: MaxRec
'output: SortArray
   PRINT "Record        Key                  Information"
   PRINT "-------------|-------------|------------------------------"
   FOR i = 1 TO MaxRec
     PRINT i, SortArray(i).KeySort, SortArray(i).Info
' stop after each ten records
     IF (i \ 10) = (i / 10) THEN
       PRINT " Press Space bar to continue "
       WHILE INKEY$ <> " ": WEND
     END IF
   NEXT i
   PRINT
END SUB

