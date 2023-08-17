'*********** CHAP8-6.BAS - illustrates floating point math rounding errors

'Copyright (c) 1992 Ethan Winer

Value! = 1!
Result! = 2!
CLS

FOR X = 1 TO 1000
  Value! = Value! + .001
NEXT

IF Value! = Result! THEN
  PRINT "They are equal"
ELSE
  PRINT "Value! ="; Value!
  PRINT "Result! ="; Result!
END IF
