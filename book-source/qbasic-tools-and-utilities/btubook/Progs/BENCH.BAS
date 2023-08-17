'********** BENCH.BAS - simple benchmark program example

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
CLS

X$ = STRING$(80, "X")   'create the test string
Y$ = STRING$(80, "Y")
Z$ = STRING$(80, "Z")


Synch! = TIMER          'synchronize to the system timer
DO
  Start! = TIMER
LOOP WHILE Start! = Synch!

FOR X = 1 TO 1000       '1000 times is sufficient
  LOCATE 1
  PRINT X$; Y$; Z$
NEXT

Done! = TIMER           'calculate elapsed time
Test1! = Done! - Start!

Synch! = TIMER          'as above
DO
  Start! = TIMER
LOOP WHILE Start! = Synch!

FOR X = 1 TO 1000
  LOCATE 1
  PRINT X$ + Y$ + Z$
NEXT

Done! = TIMER
Test2! = Done! - Start!

PRINT USING "##.## seconds using three strings"; Test1!
PRINT USING "##.## seconds using concatenation"; Test2!
