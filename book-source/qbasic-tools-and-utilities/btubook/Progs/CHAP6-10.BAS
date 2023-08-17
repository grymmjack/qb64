'*********** CHAP6-10.BAS

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

OPEN "\DEV\NUL" FOR RANDOM AS #1 LEN = 30
FIELD #1, 10 AS First$, 10 AS Middle$, 10 AS Last$
FIELD #1, 30 AS Entire$
LSET Entire$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234"
Start! = TIMER
FOR X = 1 TO 20000
  Temp = ASC(Middle$)
NEXT
Done! = TIMER
PRINT USING "##.### seconds for FIELD"; Done! - Start!
CLOSE

Entire$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234"
Start! = TIMER
FOR X = 1 TO 20000
  Temp = ASC(MID$(Entire$, 10, 10))
NEXT
Done! = TIMER
PRINT USING "##.### seconds for MID$"; Done! - Start!
