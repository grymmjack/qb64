'*********** CHAP8-4.BAS - Binary search routine

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION BinarySearch% (Array$(), Find$)

CLS
PRINT "Creating test data..."

REDIM Array$(1 TO 1000)         'create a "sorted" array
FOR X = 1 TO 1000
  Array$(X) = "String " + RIGHT$("000" + LTRIM$(STR$(X)), 4)
NEXT

PRINT "Searching array..."

FoundAt = BinarySearch%(Array$(), "String 0987")
IF FoundAt >= 0 THEN
  PRINT "Found at element"; FoundAt
ELSE
  PRINT "Not found"
END IF

FUNCTION BinarySearch% (Array$(), Find$) STATIC

BinarySearch% = -1              'no matching element yet
Min = LBOUND(Array$)            'start at first element
Max = UBOUND(Array$)            'consider through last

DO
  Try = (Max + Min) \ 2         'start testing in middle

  IF Array$(Try) = Find$ THEN   'found it!
    BinarySearch% = Try         'return matching element
    EXIT DO                     'all done
  END IF
 
  IF Array$(Try) > Find$ THEN   'too high, cut in half
    Max = Try - 1
  ELSE
    Min = Try + 1               'too low, cut other way
  END IF
LOOP WHILE Max >= Min


END FUNCTION
