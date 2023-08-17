'*********** CHAP8-3.BAS - demonstrates the Compare and Search functions

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION Compare% (SEG Type1 AS ANY, SEG Type2 AS ANY, NumBytes)
DECLARE FUNCTION Compare2% (SEG Type1 AS ANY, SEG Type2 AS ANY, NumBytes)
DECLARE FUNCTION SearchType% (Array() AS ANY, Sought AS ANY)
DECLARE FUNCTION SearchType2% (Array() AS ANY, Sought AS ANY)
DECLARE FUNCTION SearchType3% (Array() AS ANY, Searched AS ANY)

CLS
TYPE FLen                       'this lets us use SEG
  LastName AS STRING * 15
END TYPE

REDIM Array(1 TO 4000) AS FLen  '4000 is a lot of names
DIM Search AS FLen              'best comparing like data

FOR X = 1 TO 4000 STEP 2        'impart some realism
  Array(X).LastName = "Henderson"
NEXT

Array(4000).LastName = "Henson" 'almost at the end
Search.LastName = "Henson"      'find the same name

'----- first time how long it takes using Compare
Start! = TIMER                  'time how long it takes

FOR X = 1 TO 5                  'search five times
   FoundAt = SearchType%(Array(), Search)
NEXT

IF FoundAt >= 0 THEN
  PRINT "Found at element"; FoundAt
ELSE
  PRINT "Not found"
END IF

Done! = TIMER
PRINT USING "##.## seconds with Compare"; Done! - Start!
PRINT


'----- then time how long it takes using Compare2
Start! = TIMER                  'time how long it takes

FOR X = 1 TO 5                  'search five times
   FoundAt = SearchType2%(Array(), Search)
NEXT

IF FoundAt >= 0 THEN
  PRINT "Found at element"; FoundAt
ELSE
  PRINT "Not found"
END IF

Done! = TIMER
PRINT USING "##.## seconds with Compare2"; Done! - Start!
PRINT


'---- finally, time how long it takes using pure BASIC
Start! = TIMER

FOR X = 1 TO 5
   FoundAt = SearchType3%(Array(), Search)
NEXT

IF FoundAt >= 0 THEN
  PRINT "Found at element"; FoundAt
ELSE
  PRINT "Not found"
END IF

Done! = TIMER
PRINT USING "##.## seconds using straight BASIC"; Done! - Start!

FUNCTION SearchType% (Array() AS FLen, Sought AS FLen) STATIC

SearchType% = -1                'assume not found

FOR X = LBOUND(Array) TO UBOUND(Array)
  IF Compare%(Array(X), Sought, LEN(Sought)) THEN
    SearchType% = X             'save where it was found
    EXIT FOR                    'and skip what remains
  END IF
NEXT

END FUNCTION

FUNCTION SearchType2% (Array() AS FLen, Sought AS FLen) STATIC

SearchType2% = -1               'assume not found

FOR X = LBOUND(Array) TO UBOUND(Array)
  IF Compare2%(Array(X), Sought, LEN(Sought)) THEN
    SearchType2% = X            'save where it was found
    EXIT FOR                    'and skip what remains
  END IF
NEXT

END FUNCTION

FUNCTION SearchType3% (Array() AS FLen, Searched AS FLen) STATIC

SearchType3% = -1               'assume not found

FOR X = LBOUND(Array) TO UBOUND(Array)
  IF Array(X).LastName = Searched.LastName THEN
    SearchType3% = X            'save where it was found
    EXIT FOR                    'and skip what remains
  END IF
NEXT
   
END FUNCTION
