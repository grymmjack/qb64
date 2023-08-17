'*********** CHAP8-8.BAS - shows how SWAP can be faster than assignments

'Copyright (c) 1992 Ethan Winer

REDIM Array(1 TO 500)
CLS
Element% = 200
InsertValue = 999

Start = TIMER
FOR A% = 1 TO 500
  FOR X% = UBOUND(Array) TO Element% + 1 STEP -1
    Array(X%) = Array(X% - 1)
  NEXT
  Array(Element%) = InsertValue
NEXT
Done = TIMER
PRINT USING "##.## seconds when assigning"; Done - Start

Start = TIMER
FOR A% = 1 TO 500
  FOR X% = UBOUND(Array) TO Element% + 1 STEP -1
    SWAP Array(X%), Array(X% - 1)
  NEXT
  Array(Element%) = InsertValue
NEXT
Done = TIMER
PRINT USING "##.## seconds when swapping"; Done - Start
