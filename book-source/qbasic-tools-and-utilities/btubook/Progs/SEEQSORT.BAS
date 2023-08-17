'********* SEEQSORT.BAS - Quick Sort algorithm visual demonstration

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB SeeQSort (Array!())

RANDOMIZE TIMER         'generate a new series each run

CONST MaxElements = 23  'the size of the text array
CONST Delay! = 1!       'pause delay, change to suit
CONST FG = 7            'the foreground color
CONST BG = 1            'the background color
CONST Hi = 15 + 16      'high-intensity flashing

DIM Array!(1 TO MaxElements)    'create an array
FOR X = 1 TO MaxElements        'fill with random numbers
  Array!(X) = RND(1) * 500      'between 0 and 500
NEXT

COLOR FG, BG
CLS
LOCATE 25, 1
PRINT "Press Escape to end the program early"; TAB(80);
CALL SeeQSort(Array!())

SUB SeeQSort (Array!()) STATIC

REDIM QStack(10)        'create a stack big enough for this example

First = LBOUND(Array!)  'initialize work variables
Last = UBOUND(Array!)

DO
  DO
    Temp! = Array!((Last + First) \ 2)  'seek midpoint
    I = First
    J = Last

    DO     'reverse both < and > below to sort descending
      WHILE Array!(I) < Temp!
        I = I + 1
        GOSUB UpdateScreen
        GOSUB Pause
      WEND
      WHILE Array!(J) > Temp!
        J = J - 1
        GOSUB UpdateScreen
        GOSUB Pause
      WEND
      IF I > J THEN EXIT DO
      IF I < J THEN
        LOCATE 1, 60
        COLOR BG, FG
        PRINT " About to swap ";
        COLOR Hi, BG
        LOCATE I, 39
        PRINT USING "####.## "; Array!(I);
        LOCATE J, 39
        PRINT USING "####.## "; Array!(J);
        COLOR FG, BG
        GOSUB Pause
        SWAP Array!(I), Array!(J)
        GOSUB UpdateScreen
        LOCATE 1, 60
        COLOR BG, FG
        PRINT "    Swapped    ";
        GOSUB Pause
      END IF

      I = I + 1
      J = J - 1
    LOOP WHILE I <= J

    IF I < Last THEN                    'Done
      LOCATE 1, 60
      COLOR BG, FG
      PRINT " About to push ";
      GOSUB Pause
      QStack(StackPtr) = I              'Push I
      QStack(StackPtr + 1) = Last       'Push Last
      StackPtr = StackPtr + 2
      GOSUB UpdateScreen
      LOCATE 1, 60
      COLOR BG, FG
      PRINT "     Pushed    ";
      GOSUB Pause
    END IF

    Last = J
  LOOP WHILE First < Last

  IF StackPtr = 0 THEN EXIT DO

  LOCATE 1, 60
  COLOR BG, FG
  PRINT " About to pop ";
  GOSUB Pause
  StackPtr = StackPtr - 2
  First = QStack(StackPtr)              'Pop First
  Last = QStack(StackPtr + 1)           'Pop Last
  GOSUB UpdateScreen
  LOCATE 1, 60
  COLOR BG, FG
  PRINT "    Popped    ";
  GOSUB Pause
LOOP

ERASE QStack               'delete the stack array
COLOR FG, BG
EXIT SUB

UpdateScreen:
  COLOR FG, BG
  LOCATE 1, 60
  PRINT SPC(15);

  FOR X = 1 TO MaxElements
    LOCATE X, 24
    IF X = (Last + First) \ 2 THEN
      COLOR BG, FG
      PRINT " Midpoint ==> "
      COLOR FG, BG
    ELSE
      PRINT SPC(14);
    END IF
  
    LOCATE X, 1
    IF X = First THEN
      COLOR BG, FG
      PRINT " First ==> "
      COLOR FG, BG
    ELSE
      PRINT SPC(11);
    END IF
   
    LOCATE X, 13
    IF X = Last THEN
      COLOR BG, FG
      PRINT " Last ==> "
      COLOR FG, BG
    ELSE
      PRINT SPC(11);
    END IF


    LOCATE X, 39
    PRINT USING "####.## "; Array!(X);
    PRINT SPC(17);
    COLOR BG, FG
    LOCATE X, 48

    IF X = I THEN
      PRINT " <== I "
    END IF
    IF X = J THEN
      LOCATE X, 56
      PRINT " <== J "
    END IF

    COLOR FG, BG
  NEXT
RETURN


Pause:
  Start! = TIMER
  DO
  LOOP WHILE Start! + Delay! > TIMER

  IF INKEY$ = CHR$(27) THEN END

  RETURN

END SUB
