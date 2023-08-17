'********* QSORT.BAS - Quick Sort algorithm demonstration

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB QSort (Array!(), StartEl, NumEls)

RANDOMIZE TIMER         'generate a new series each run

DIM Array!(1 TO 21)             'create an array
FOR X = 1 TO 21                 'fill with random numbers
    Array!(X) = RND(1) * 500    'between 0 and 500
NEXT

FirstEl = 6                     'sort starting here
NumEls = 10                     'sort this many elements

CLS
PRINT "Before Sorting:"; TAB(31); "After sorting:"
PRINT "==============="; TAB(31); "=============="

FOR X = 1 TO 21                 'show them before sorting
    IF X >= FirstEl AND X <= FirstEl + NumEls - 1 THEN
      PRINT "==>";
    END IF
    PRINT TAB(5); USING "###.##"; Array!(X)
NEXT

CALL QSort(Array!(), FirstEl, NumEls)

LOCATE 3
FOR X = 1 TO 21                 'print them after sorting
    LOCATE , 30
    IF X >= FirstEl AND X <= FirstEl + NumEls - 1 THEN
      PRINT "==>";              'point to sorted items
    END IF
    LOCATE , 35
    PRINT USING "###.##"; Array!(X)
NEXT

SUB QSort (Array!(), StartEl, NumEls) STATIC

REDIM QStack(NumEls \ 5 + 10) 'create a stack

First = StartEl               'initialize work variables
Last = StartEl + NumEls - 1

DO
  DO
    Temp! = Array!((Last + First) \ 2)  'seek midpoint
    I = First
    J = Last

    DO     'reverse both < and > below to sort descending
      WHILE Array!(I) < Temp!
        I = I + 1
      WEND
      WHILE Array!(J) > Temp!
        J = J - 1
      WEND
      IF I > J THEN EXIT DO
      IF I < J THEN SWAP Array!(I), Array!(J)
      I = I + 1
      J = J - 1
    LOOP WHILE I <= J

    IF I < Last THEN                    'Done
      QStack(StackPtr) = I              'Push I
      QStack(StackPtr + 1) = Last       'Push Last
      StackPtr = StackPtr + 2
    END IF

    Last = J
  LOOP WHILE First < Last

  IF StackPtr = 0 THEN EXIT DO
  StackPtr = StackPtr - 2
  First = QStack(StackPtr)              'Pop First
  Last = QStack(StackPtr + 1)           'Pop Last
LOOP

ERASE QStack               'delete the stack array

END SUB
