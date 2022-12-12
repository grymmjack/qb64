REM  PROGRAM CH5_15.BAS
REM  **************************************
REM  *   Assessment of Sorting Examples   *
REM  **************************************

DEFINT A-Z      ' Default type integer.

' Declare FUNCTION and SUB procedures

  DECLARE SUB BubbleSort ()
  DECLARE SUB HeapSort ()
  DECLARE SUB Initialize ()
  DECLARE SUB InsertionSort ()
  DECLARE SUB PercolateDown (MaxLevel)
  DECLARE SUB PercolateUp (MaxLevel)
  DECLARE SUB PrintArray ()
  DECLARE SUB QuickSort (Low, High)
  DECLARE SUB SelectSort ()
  DECLARE SUB ShellSort ()
  DECLARE SUB SortMenu ()
  DECLARE SUB SpaceEsc ()

  DECLARE FUNCTION RandInt% (Lower, Upper)

' Define the data type
  TYPE SortType
     KeySort AS INTEGER
     Str AS STRING * 40
  END TYPE

' Declare global constants:
  CONST NUMOPTIONS = 7, NUMSORTS = 6

  DIM SHARED SortArray(1 TO 1000) AS SortType
  DIM SHARED OptionTitle(1 TO NUMOPTIONS) AS STRING * 12
  DIM SHARED StartTime AS SINGLE
  DIM SHARED Escape$, Choice, Selection, MaxRec

' Data sort menu:
  DATA Select,Bubble, Insertion, Shell, Heap,Quick,Exit

DO ' Repeat for different arrays' sizes and methods
  CLS
  LOCATE 1, 10
  PRINT "SORTING RECORDS WITH RANDOM KEYS"
  LOCATE 2, 5
  PRINT "Enter the number of key elements N (<=1000) "
  LOCATE 3, 5
  INPUT "in the array to sort =", MaxRec

  Initialize             ' Initialize data values.
    IF (Escape$ = CHR$(27)) THEN EXIT DO    ' exit by Esc
  SortMenu               ' Print sort menu.
   IF (Choice <= 0) OR (Choice >= 7) THEN EXIT DO

  PrintArray             'print results
    IF (Escape$ = CHR$(27)) THEN EXIT DO    ' exit by Esc
  RESTORE
LOOP
  END

SUB BubbleSort STATIC
'                 ***    BubbleSort    ***

'inputs: SortArray,MaxRec
'output: SortArray
'SortArray is sorted by the key field KeySort
'MaxRec -number of records in the array

   Limit = MaxRec
   DO  ' fingering passes
      Switch = 0  'there is (no) exchanges in a pass
      FOR i = 1 TO (Limit - 1) 'fingering elements
                 ' compare, swap, and store index
         IF SortArray(i).KeySort > SortArray(i + 1).KeySort THEN
            SWAP SortArray(i), SortArray(i + 1)
            Switch = i
         END IF
      NEXT i

      Limit = Switch
   LOOP WHILE Switch  'no exchanges occurred


END SUB

SUB HeapSort STATIC
' ***  HeapSort  ***
' inputs: SortArray,MaxRec
' output: SortArray
' SortArray is sorted by the key field KeySort
' MaxRec -number of records in the array

' Building a pyramid (heap)
   FOR i = 2 TO MaxRec
      PercolateUp i
   NEXT i
' Sorting the elements of the heap
   FOR i = MaxRec TO 2 STEP -1
      SWAP SortArray(1), SortArray(i)
      PercolateDown i - 1
   NEXT i
END SUB

SUB Initialize STATIC
' ***   Initializing ***
   MaxIndex = 999

   RANDOMIZE TIMER              ' Seed the random-number generator.
   FOR i = 1 TO MaxRec
'       Index = MaxIndex   'in decreasing order
'       Index = 999 - MaxIndex 'in increasing order
        Index = RandInt%(1, MaxIndex) 'random
      MaxIndex = MaxIndex - 1
      SortArray(i).KeySort = Index
   NEXT i

   FOR i = 1 TO NUMOPTIONS   ' Read SORT DEMO menu options and store
      READ OptionTitle(i)    ' them in the OptionTitle array.
   NEXT i
PRINT " Random array of key elements before sorting:"
FOR i = 1 TO MaxRec
  PRINT SortArray(i).KeySort;
NEXT i
Choice = 0
SpaceEsc

END SUB

SUB InsertionSort STATIC
'                ***      InsertionSort     ***
'inputs: SortArray,MaxRec
'output: SortArray
'SortArray is sorted by the key field KeySort
'MaxRec -number of records in the array

   DIM Xval AS SortType, x AS SortType
   FOR i = 2 TO MaxRec'i-current index of the initial array
      x.KeySort = SortArray(i).KeySort   'taking i-th element for insertion
      Xval = SortArray(i)
      FOR J = i TO 2 STEP -1 'j-current index of the ready array
         ' If J-1-th element is less than the element to insert,
         ' it is shifted to the right
         IF SortArray(J - 1).KeySort > x.KeySort THEN
            SortArray(J) = SortArray(J - 1)
         ' Otherwise, exit the FOR...NEXT loop:
         ELSE
            EXIT FOR
         END IF
      NEXT J
      ' Inserting SortArray(i) into the ready array
         SortArray(J) = Xval
   NEXT i

END SUB

SUB PercolateDown (MaxLevel) STATIC
' ***   PercolateDown  ***
 i = 1 'number of a layer of the heap
 DO
   Child = 2 * i     ' Get the subscript for the child node.
   IF Child > MaxLevel THEN EXIT DO
   IF Child + 1 <= MaxLevel THEN
     IF SortArray(Child + 1).KeySort > SortArray(Child).KeySort THEN
            Child = Child + 1
     END IF
   END IF
     IF SortArray(i).KeySort < SortArray(Child).KeySort THEN
         SWAP SortArray(i), SortArray(Child)
         i = Child
      ' so exit:
     ELSE
        EXIT DO
     END IF
 LOOP
END SUB

SUB PercolateUp (MaxLevel) STATIC
' ***  PercolateUp   ***
   i = MaxLevel
   DO UNTIL i = 1
      Parent = i \ 2      ' Get the subscript for the parent node.
      IF SortArray(i).KeySort > SortArray(Parent).KeySort THEN
         SWAP SortArray(Parent), SortArray(i)
         i = Parent
      ELSE
         EXIT DO
      END IF
   LOOP
END SUB

SUB PrintArray
CLS
PRINT "    Array of key elements after sorting:    "
FOR i = 1 TO MaxRec
  PRINT SortArray(i).KeySort;
NEXT i
   CONST FORMAT = "&###.### seconds  "
   PRINT
   PRINT "      N = "; MaxRec; "     ";
   PRINT USING FORMAT; OptionTitle(Selection); StartTime
   SpaceEsc

END SUB

SUB QuickSort (Low, High)
' **      QuickSort     **
' inputs: SortArray,MaxRec
' output: SortArray
' SortArray is sorted by the key field KeySort
' MaxRec -number of records in the array
' Low,High - bound indexes of the subarray sorted
   IF Low < High THEN
      IF High - Low = 1 THEN
         IF SortArray(Low).KeySort > SortArray(High).KeySort THEN
            SWAP SortArray(Low), SortArray(High)
         END IF
      ELSE
         RandIndex = RandInt%(Low, High)
         SWAP SortArray(High), SortArray(RandIndex)
         Partition = SortArray(High).KeySort
            i = Low: J = High
         DO

            DO WHILE (i < J) AND (SortArray(i).KeySort <= Partition)
               i = i + 1
            LOOP
            DO WHILE (J > i) AND (SortArray(J).KeySort >= Partition)
               J = J - 1
            LOOP
            IF i < J THEN
               SWAP SortArray(i), SortArray(J)
            END IF
         LOOP WHILE i < J
         SWAP SortArray(i), SortArray(High)
         ' Recursively call the QuickSort procedure
         IF (i - Low) < (High - i) THEN
            QuickSort Low, i - 1
            QuickSort i + 1, High
         ELSE
            QuickSort i + 1, High
            QuickSort Low, i - 1
         END IF
      END IF
   END IF
END SUB

FUNCTION RandInt% (Lower, Upper) STATIC
'                    ***   RandInt%  ***
'   Returns a random integer greater than
'   or equal to the Lower parameter
'   and less than or equal to the Upper parameter.
  RandInt% = INT(RND * (Upper - Lower + 1)) + Lower
END FUNCTION

SUB SelectSort
'                 ***      SelectSort     ***
'inputs: SortArray,MaxRec
'output: SortArray
'SortArray is sorted by the key field KeySort
'MaxRec -number of records in the array
   FOR i = 1 TO MaxRec
      k = i ' initial value of the index of the minimum element
'     minimum search cycle
      FOR J = i + 1 TO MaxRec
         IF SortArray(J).KeySort < SortArray(k).KeySort THEN
            k = J         'k-index of the smallest key
         END IF
      NEXT J
' k - index of the minimum element selected
' swap elements, if the smallest one is found
      IF k > i THEN
      SWAP SortArray(i), SortArray(k)
      END IF
   NEXT i   'go to the next pass
END SUB

SUB ShellSort STATIC
' ***      ShellSort     ***
' Inputs: SortArray,MaxRec
' Output: SortArray
' SortArray is sorted by the key field KeySort
' MaxRec -number of records in the array
' Initial step of the method

 h = MaxRec \ 2
 DO WHILE h > 0          ' Loop until offset gets to zero.
' **     BubbleSort    **
      L = MaxRec - h
   DO
         Switch = 0
      FOR i = 1 TO L
         IF SortArray(i).KeySort > SortArray(i + h).KeySort THEN
            SWAP SortArray(i), SortArray(i + h) 'Swap elements
            Switch = i
         END IF
      NEXT i

      ' Sort on next pass only to where the last switch was made:
      L = Switch - h
   LOOP WHILE Switch
' **   end  BubbleSort  **
' No switches at last offset, try one half as big:
      h = h \ 2     'Integer division
 LOOP
END SUB

'                ***  SortMenu ***
'
SUB SortMenu STATIC
   CLS
   LOCATE 3, 18
   PRINT "SELECT THE NUMBER OF THE METHOD";
   LOCATE 5
   FOR i = 1 TO NUMOPTIONS
      LOCATE , 29: PRINT i; OptionTitle(i)
   NEXT i
      LOCATE 3, 51, 1
      INPUT Choice
      Selection = Choice   ' if it's one of the menu options.
      IF Choice <= 6 AND Choice >= 1 THEN
        LOCATE 16, 15
        PRINT "Please, wait for the end of sorting "
      END IF
         StartTime = TIMER      ' Record the starting time.
        SELECT CASE Choice
         CASE 1
            SelectSort
         CASE 2
            BubbleSort
         CASE 3
            InsertionSort
         CASE 4
            ShellSort
         CASE 5
            HeapSort
         CASE 6
            QuickSort 1, MaxRec
      END SELECT

      StartTime = TIMER - StartTime

END SUB

SUB SpaceEsc
'                     ***  SpaseEsc  ***
  PRINT
  IF Choice = 0 THEN
    PRINT "  Press Space bar to select a sort method,"
    PRINT "         ESC - to exit "
  ELSE
    PRINT "  Press Space bar to restart the program,  "
    PRINT "         ESC - to exit "
  END IF
 DO
  Escape$ = INKEY$
  IF Escape$ = " " OR Escape$ = CHR$(27) THEN EXIT DO
 LOOP
END SUB

