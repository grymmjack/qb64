'********** TYPESORT.BAS - performs a multi-key sort on any TYPE array

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE FUNCTION Compare3% (BYVAL Seg1, BYVAL Adr1, BYVAL Seg2, BYVAL Adr2, NumBytes)
DECLARE SUB SwapMem (BYVAL Seg1, BYVAL Adr1, BYVAL Seg2, BYVAL Adr2, BYVAL Length)
DECLARE SUB TypeSort (Segment, Address, ElSize, Offset, KeySize, NumEls)

CONST NumEls% = 23              'this fits on the screen

TYPE MyType
  LastName  AS STRING * 10
  FirstName AS STRING * 10
  Dollars   AS STRING * 6
  Cents     AS STRING * 2
END TYPE
REDIM Array(1 TO NumEls%) AS MyType

'---- Disable all but one of the following blocks to test

Offset = 27                 'start sorting with Cents
ElSize = LEN(Array(1))      'the length of each element
KeySize = 2                 'sort on the Cents only

Offset = 21                 'start sorting with Dollars
ElSize = LEN(Array(1))      'the length of each element
KeySize = 8                 'sort Dollars and Cents only

Offset = 11                 'start sorting with FirstName
ElSize = LEN(Array(1))      'the length of each element
KeySize = 18                'sort FirstName through Cents

Offset = 1                  'start sorting with LastName
ElSize = LEN(Array(1))      'the length of each element
KeySize = ElSize            'sort based on all 4 fields

FOR X = 1 TO NumEls%        'build the array from DATA
  READ Array(X).LastName
  READ Array(X).FirstName
  READ Amount$              'format the amount into money
  Dot = INSTR(Amount$, ".")
  IF Dot THEN
    RSET Array(X).Dollars = LEFT$(Amount$, Dot - 1)
    Array(X).Cents = LEFT$(MID$(Amount$, Dot + 1) + "00", 2)
  ELSE
    RSET Array(X).Dollars = Amount$
    Array(X).Cents = "00"
  END IF
NEXT

Segment = VARSEG(Array(1))      'show where the array is
Address = VARPTR(Array(1))      '  located in memory
CALL TypeSort(Segment, Address, ElSize, Offset, KeySize, NumEls%)

CLS                             'display the results
FOR X = 1 TO NumEls%
  PRINT Array(X).LastName, Array(X).FirstName,
  PRINT Array(X).Dollars; "."; Array(X).Cents
NEXT

DATA Smith, John, 123.45
DATA Cramer, Phil, 11.51
DATA Hogan, Edward, 296.08
DATA Cramer, Phil, 112.01
DATA Malin, Donald, 13.45
DATA Cramer, Phil, 111.3
DATA Smith, Ralph, 123.22
DATA Smith, John, 112.01
DATA Hogan, Edward, 8999.04
DATA Hogan, Edward, 8999.05
DATA Smith, Bob, 123.45
DATA Cramer, Phil, 11.50
DATA Hogan, Edward, 296.88
DATA Malin, Donald, 13.01
DATA Cramer, Phil, 111.1
DATA Smith, Ralph, 123.07
DATA Smith, John, 112.01
DATA Hogan, Edward, 8999.33
DATA Hogan, Edward, 8999.17
DATA Hogan, Edward, 8999.24
DATA Smith, John, 123.05
DATA Cramer, David, 1908.80
DATA Cramer, Phil, 112

SUB TypeSort (Segment, Address, ElSize, Displace, KeySize, NumEls) STATIC

REDIM QStack(NumEls \ 5 + 10)   'create a stack sufficient for 2500 elements

First = 1                       'initialize working variables
Last = NumEls
Offset = Displace - 1           'make zero-based now for speed later

DO
  DO
    Temp = (Last + First) \ 2   'seek midpoint
    I = First
    J = Last

    DO          'change -1 to 1 and 1 to -1 below to sort descending
      WHILE Compare3%(Segment, Address + Offset + (I - 1) * ElSize, Segment, Address + Offset + (Temp - 1) * ElSize, KeySize) = -1
        I = I + 1
      WEND
      WHILE Compare3%(Segment, Address + Offset + (J - 1) * ElSize, Segment, Address + Offset + (Temp - 1) * ElSize, KeySize) = 1
        J = J - 1
      WEND
      IF I > J THEN EXIT DO
      IF I < J THEN
        CALL SwapMem(Segment, Address + (I - 1) * ElSize, Segment, Address + (J - 1) * ElSize, ElSize)
        IF Temp = I THEN
          Temp = J
        ELSEIF Temp = J THEN
          Temp = I
        END IF
      END IF
      I = I + 1
      J = J - 1
    LOOP WHILE I <= J

    IF I < Last THEN
      QStack(StackPtr) = I             'Push I
      QStack(StackPtr + 1) = Last      'Push Last
      StackPtr = StackPtr + 2
    END IF

    Last = J
  LOOP WHILE First < Last

  IF StackPtr = 0 THEN EXIT DO          'Done
  StackPtr = StackPtr - 2
  First = QStack(StackPtr)              'Pop First
  Last = QStack(StackPtr + 1)           'Pop Last
LOOP

ERASE QStack                    'delete the stack array

END SUB
