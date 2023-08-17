'*********** CHAP8-5.BAS - indexed Binary search routine

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION BinaryISearch% (Array$(), Index(), Find$)

CLS
PRINT "Creating test data..."

REDIM Array$(1 TO 1000)         'create a "sorted" array
REDIM Index(1 TO 1000)
FOR X = 1 TO 1000
  Array$(X) = "String " + RIGHT$("000" + LTRIM$(STR$(1000 - X)), 4)
  Index(X) = 1000 - X
NEXT

PRINT "Searching array..."

FoundAt = BinaryISearch%(Array$(), Index(), "String 0999")
IF FoundAt >= 0 THEN
  PRINT "Found at element"; FoundAt
ELSE
  PRINT "Not found"
END IF

FUNCTION BinaryISearch% (Array$(), Index(), Find$) STATIC

BinaryISearch% = -1             'assume not found
Min = LBOUND(Array$)            'start at first element
Max = UBOUND(Array$)            'consider through last

DO
  Try = (Max + Min) \ 2         'start testing in middle

  IF Array$(Index(Try)) = Find$ THEN    'found it!
    BinaryISearch% = Try        'return matching element
    EXIT DO                     'all done
  END IF
 
  IF Array$(Index(Try)) > Find$ THEN    'too high, cut
    Max = Try - 1
  ELSE
    Min = Try + 1               'too low, cut other way
  END IF
LOOP WHILE Max >= Min

END FUNCTION
