REM Indexation
REM \CHAP6\CH6_10.BAS

DEFINT A-Z      ' Default type integer.

' ***   Indexing the FOOTBALL file  ***

' Declare SUB procedures

  DECLARE SUB BiSearch ()
  DECLARE SUB Search (FileName$)
  DECLARE SUB Init (FileName$)

' Define the data type
  TYPE GoalsType
    Scored AS INTEGER
    Lost AS INTEGER
  END TYPE
  TYPE FootballType
     Team AS STRING * 20
     Season AS INTEGER
     Goals AS GoalsType
  END TYPE
  TYPE IndexRecType
     Team AS STRING * 20
     Season AS INTEGER
  END TYPE
  CONST ZoneSize = 6  ' Sixe of index zone
  DIM SHARED SearchRec AS IndexRecType
  DIM SHARED IndexArray(1 TO 1000) AS IndexRecType
  DIM SHARED MaxRec, Index

' Variables for reading the records of the Football file
  DIM SHARED WorkRec AS FootballType

  CLS
  LOCATE 8, 15
  PRINT "***   INDEXING TYPED FILE   ***"
  LOCATE 10, 15
  PRINT "Press any key to continue"
  WHILE INKEY$ = "": WEND
  Init "C:Football"
  R$ = ""
  DO
    BiSearch
    Search "C:Football"
    INPUT "Do you want to repeat the request [Y/N]"; R$
  LOOP WHILE UCASE$(R$) = "Y"
END

SUB BiSearch

  '*** Binary Search for the number of a zone by the key ***

  CLS
  PRINT
  INPUT "Team: ", SearchRec.Team       ' Input search pattern
  INPUT "Season: ", SearchRec.Season
  Index = 1  ' initial values of the variables
  R = MaxRec ' for binary search
  DO
    i = (Index + R) \ 2
    IF SearchRec.Team < IndexArray(i).Team THEN
	   R = i
    END IF
    IF SearchRec.Team > IndexArray(i).Team THEN
	   Index = i
    END IF
    IF SearchRec.Team = IndexArray(i).Team THEN
      IF SearchRec.Season < IndexArray(i).Season THEN
	   R = i
      ELSE
	   Index = i
      END IF
    END IF
  LOOP WHILE R - Index - 1
  ' Variable Index contains the number of a zone
  '  with the record sought for
END SUB

  SUB Init (FileName$)

  '  ***  Creating indices for the Football file ***
  '  Input parameter contains the name of a file

  DIM Num AS STRING * 4
  CLS
  PRINT FileName$
  OPEN FileName$ FOR RANDOM AS #1 LEN = LEN(WorkRec)
  RecNum% = 1
  i = 1
  ' Reading the first record of a file
  GET #1, RecNum%, WorkRec
  PRINT " Array of indices is being created"
  j = 0
  DO
   Num = RTRIM$(STR$(RecNum%))
   j = j + 1
   IF j > 20 THEN
     PRINT "Press any key to continue"
     WHILE INKEY$ = "": WEND
     j = 0
   END IF
   PRINT i; Num; " "; WorkRec.Team; WorkRec.Season
   IndexArray(i).Team = WorkRec.Team
   IndexArray(i).Season = WorkRec.Season
   RecNum% = RecNum% + ZoneSize
   i = i + 1
   ' Reading the first record of a next zone
   GET #1, RecNum%, WorkRec
  LOOP UNTIL EOF(1)
  MaxRec = i - 1
  CLOSE #1
  PRINT "Press any key to continue"
  WHILE INKEY$ = "": WEND

END SUB

SUB Search (FileName$)

  '  ***  Search in an indexed file  ***

  DIM Num AS STRING * 4
  NoFound = 1
  CLS
  PRINT FileName$
  OPEN FileName$ FOR RANDOM AS #1 LEN = LEN(WorkRec)
  ' Calculating the number of the first record in a zone
  RecNum% = ZoneSize * (Index - 1) + 1
  i = 1
		 ' Searching for a record by the key
  DO
   GET #1, RecNum%, WorkRec
   IF SearchRec.Team = WorkRec.Team AND SearchRec.Season = WorkRec.Season THEN
     NoFound = 0
     LOCATE CSRLIN - 1, 35
     PRINT "	    Search is successful"
     PRINT RecNum%; " "; WorkRec.Team; WorkRec.Season;
     PRINT WorkRec.Goals.Scored; WorkRec.Goals.Lost
     EXIT DO
   ELSE
     RecNum% = RecNum% + 1
     i = i + 1
   END IF
  LOOP WHILE 7 - i
  CLOSE #1
  IF NoFound = 1 THEN
    PRINT " Record not found "
  END IF
END SUB

