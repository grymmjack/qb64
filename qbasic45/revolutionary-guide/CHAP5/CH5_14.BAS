REM   PROGRAM CH5_14
REM   **************************************************
REM   *                 ShellSort                      *
REM   *               by Insertion                     *
REM   **************************************************

DECLARE SUB ShellInsertSort ()
DECLARE SUB InArray ()
DECLARE SUB PrintArray ()

' Numeric array A of N size is sorted
DIM SHARED A(1 TO 100) AS INTEGER
DIM SHARED N

CLS
PRINT "        S H E L L S O R T (step = 5,3,1)"
InArray
PRINT " Initial data:"
PrintArray
ShellInsertSort
PRINT
PRINT " Result of sorting: "
PrintArray
END

'Number of numbers being sorted
  DATA 8

'Numeric data to sort
DATA 71,32,98,17,56,79,13,44

SUB InArray
'                  *** InArray ***
   READ N
   FOR i = 1 TO N
     READ A(i)
   NEXT i

END SUB

SUB PrintArray
'               *** PrintArray ***
   FOR i = 1 TO N
     PRINT A(i);
   NEXT i
   PRINT
END SUB

SUB ShellInsertSort
'                    ***  ShellInsertSort  ***
' h-array of sort steps of the size Num
  Num = 3
  DIM h(1 TO Num)
    h(1) = 5
    h(2) = 3
    h(3) = 1

    FOR k = 1 TO Num                'k- number of iteration
      h = h(k)                      'h- current sep of sorting

'                    *   InsertionSort  *
      FOR i = h + 1 TO N            'i- index of initial array
        x = A(i)   'taking i-th element to insert
        FOR J = i TO h + 1 STEP -h  'j- index of the ready array
         ' If J-1-th element is less than the element to insert,
         ' it is shifted to the right
          IF A(J - h) > x THEN
            A(J) = A(J - h)
            ' Otherwise, exit the FOR...NEXT loop:
          ELSE
            EXIT FOR
          END IF
        NEXT J
         ' Insert a(i) into the ready array
         A(J) = x
      NEXT i
      PRINT
      PRINT USING " Result of iteration##( step=#):"; k; h
      PrintArray
      PRINT " Press Space bar to continue "
'                       end InsertSort

      WHILE INKEY$ <> " ": WEND
    NEXT k            'pass to next iteration and to new step

END SUB

