'*********** CHAP8-7.BAS - shows how to avoid math rounding errors

'Copyright (c) 1992 Ethan Winer

Value! = 1!
Result! = 2!
CLS

FOR X = 1 TO 1000
  Value! = Value! + .001
NEXT

IF ABS(Value! - Result!) < .0001 THEN
  PRINT "They are equal"
ELSE
  PRINT "Value! ="; Value!
  PRINT "Result! ="; Result!
END IF
