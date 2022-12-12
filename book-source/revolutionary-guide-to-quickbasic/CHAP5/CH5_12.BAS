REM   PROGRAM CH5_12
REM   **************************************************
REM   *                Direct Sorting                  *
REM   **************************************************

  DEFINT A-Z                  'Default type: integer
  DECLARE SUB SelectSort ()
  DECLARE SUB BubbleSort ()
  DECLARE SUB InsertionSort ()
  DECLARE SUB ShakerSort ()
  DECLARE SUB InArray ()
  DECLARE SUB PrintArray ()

' Definition of a record
TYPE SortType
   KeySort AS STRING * 14
   Info AS INTEGER
' KeySort AS INTEGER
' Info AS STRING * 14
END TYPE

DIM SHARED SortArray(1 TO 1000) AS SortType
DIM SHARED MaxRec

CLS
InArray
PRINT "I N I T I A L      D A T A"
PRINT "record         key                 information"
PrintArray
   SelectSort
'   BubbleSort
'   InsertionSort
'   ShakerSort
PRINT
PRINT "S O R T E D        D A T A"
PrintArray
RESTORE
END
'Number of records
  DATA  8
'Data for records being sorted, key - string
  DATA Smolensk,       863, Yaroslavl,  1010, Uglitch,   937
  DATA Moscow,        1147, Magadan,    1931, Novgorod,  859
  DATA Veliky Ustyug, 1207, Petersburg, 1703
'Data for records being sorted, key - integer
'  DATA 863, Smolensk,      1010, Yaroslavl,  937, Uglitch
'  DATA 1147,Moscow,        1931, Magadan,    859, Novgorod
'  DATA 1207,Veliky Ustyug, 1703, Petersburg

DEFSNG A-Z

DEFINT A-Z
SUB BubbleSort STATIC
' ***    BubbleSort    ***
' *** Inputs: SortArray,MaxRec
' *** Output: SortArray
' *** SortArray is sorted by the key field KeySort
' *** MaxRec -number of records in the array

   Limit = MaxRec
   DO                            'For passes
      Switch = 0                 'There are, initially, no exchanges in a pass
      FOR i = 1 TO (Limit - 1)   'For each array element
                                 'Compare, swap, and store index
         IF SortArray(i).KeySort > SortArray(i + 1).KeySort THEN
            SWAP SortArray(i), SortArray(i + 1)
            Switch = i
         END IF
      NEXT i

      Limit = Switch
   LOOP WHILE Switch             'Loop whilst no exchanges have occurred

END SUB

SUB InArray
' Input of the array of records. MaxRec - number of records.
' A record consists of Info and KeyS fields
  READ MaxRec
  FOR i = 1 TO MaxRec
   READ SortArray(i).KeySort
   READ SortArray(i).Info
  NEXT i

END SUB

SUB InsertionSort STATIC
' ***      InsertionSort     ***
' *** Inputs: SortArray,MaxRec
' *** Output: SortArray
' *** SortArray is sorted by the key field KeySort
' *** MaxRec -number of records in the array

   DIM Xval AS SortType, x AS SortType
   FOR i = 2 TO MaxRec                   'i-current index of the initial array
      x.KeySort = SortArray(i).KeySort   'taking i-th element for insertion
      Xval = SortArray(i)
      FOR J = i TO 2 STEP -1             'j-current index of the ready array
               'If J-1-th element is less than the element to insert,
               'it is shifted to the right
         IF SortArray(J - 1).KeySort > x.KeySort THEN
            SortArray(J) = SortArray(J - 1)
               'Otherwise, exit the FOR...NEXT loop:
               'as new element is largest in ready array
         ELSE
            EXIT FOR
         END IF
      NEXT J
         SortArray(J) = Xval    'Inserting new element into the ready array

   NEXT i
END SUB

 SUB PrintArray
   PRINT "-------------|-------------|-------------------"
   FOR i = 1 TO MaxRec
     PRINT i, SortArray(i).KeySort, SortArray(i).Info
     ' halt after each ten records
     IF (i \ 10) = (i / 10) THEN
       PRINT " Press Space to continue "
       WHILE INKEY$ <> " ": WEND
       PRINT "-------------|-------------|-------------------"
     END IF
   NEXT i


END SUB

SUB SelectSort
' ***      SelectSort     ***
' *** Inputs: SortArray,MaxRec
' *** Output: SortArray
' *** SortArray is sorted by the key field KeySort
' *** MaxRec - number of records in the array

   FOR i = 1 TO MaxRec
      k = i             'Initial value of the index of the minimum element
      FOR J = i + 1 TO MaxRec   'Minimum search cycle
         IF SortArray(J).KeySort < SortArray(k).KeySort THEN
            k = J               'k-index of the smallest key
         END IF
      NEXT J
' *** k - index of the minimum element selected
' *** Swap elements, if the smallest one is found
      IF k > i THEN
      SWAP SortArray(i), SortArray(k)
      END IF
   NEXT i                       'Go to the next pass
END SUB

SUB ShakerSort
' ***    ShakerSort    ***
' *** Inputs: SortArray,MaxRec
' *** Output: SortArray
' *** SortArray is sorted by the key field KeySort
' *** MaxRec -number of records in the array

   L = 1               'L-starting viewing from left to right
   R = MaxRec - 1      'R-starting viewing from right to left
   DO                  'For passes
      Switch = 0       'Existence of exchanges in a pass
      FOR i = L TO R   'For each element
                       'compare, swap, and store index
         IF SortArray(i).KeySort > SortArray(i + 1).KeySort THEN
            SWAP SortArray(i), SortArray(i + 1)
            Switch = i
         END IF
      NEXT i

      R = Switch
      FOR i = R TO L STEP -1 'For each element
                             'compare, swap, and store index
         IF SortArray(i).KeySort > SortArray(i + 1).KeySort THEN
            SWAP SortArray(i), SortArray(i + 1)
            Switch = i
         END IF
      NEXT i

      L = Switch
   LOOP WHILE Switch         'Loop whilst no exchanges occur

END SUB

