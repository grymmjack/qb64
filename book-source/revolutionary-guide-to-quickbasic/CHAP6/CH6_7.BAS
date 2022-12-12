REM External Sort
REM \CHAP6\CH6_7.BAS


DEFINT A-Z      ' Default type integer.

' ***   Sorting the file FOOTBALL   ***

' Declare FUNCTION and SUB procedures

  DECLARE SUB Initialize ()
  DECLARE SUB Merge ()
  DECLARE SUB PrintFile (FileName$)
  DECLARE SUB Separate ()
  DECLARE SUB ShellSort ()
  DECLARE SUB StepMerge (Phase%, Ready$)

  DECLARE FUNCTION KeyComparision% (End1%, End2%)

' Data for input file FOOTBALL

  DATA "Manchester United","Blackburn","Newcastle"
  DATA "Arsenal","Leeds","Wimbledon","Sheffield Wednesday"
  DATA "Liverpool","Queens Park Rangers","Aston Villa"
  DATA "Coventry","Norwich","West Ham","Chelsea"
  DATA "Tottenham","Manchester City", "Everton"
  DATA "Southampton"

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

' Size of the portion to be sorted for the partition phase
  CONST SortPortion = 40
' Actual size of the portion to sort
  DIM SHARED MaxRec AS INTEGER, AllRec AS INTEGER
' Maximal size of portion at the recurrent merging stage
  DIM SHARED MergePortion AS INTEGER
' Two variables for reading records from working files
  DIM SHARED WorkRec1 AS FootballType
  DIM SHARED WorkRec2 AS FootballType
' Array for internal sorting at the merging stage
  DIM SHARED SortArray(SortPortion) AS FootballType
  ON ERROR GOTO ErrorHandler
  KILL "C:football"
  CLS
  LOCATE 8, 15
  PRINT "***   SORTING RANDOM ACCESS FILE   ***"
  LOCATE 10, 15
  PRINT "Press any key to continue"
  WHILE INKEY$ = "": WEND

  Initialize                 ' Initialize data values.
  PrintFile "C:football"     ' Printing initial file
  Separate                   ' Partitioning phase
  Merge                      ' Merging phase
  PrintFile "C:Football"     ' Print sorted file
  END
ErrorHandler:
  IF ERR = 53 THEN           ' If the file to be deleted is not found
    RESUME NEXT              ' continue the program,
  ELSE
    PRINT "Error="; ERR      ' otherwise, output error code
    STOP
  END IF

SUB Initialize STATIC
     '    ***  Initializing    ***

  DIM Teams(18) AS STRING * 20
  FOR i = 1 TO 18
    READ Teams(i)
  NEXT i
  OPEN "C:Football" FOR RANDOM AS #1 LEN = LEN(WorkRec1)
  RecNum% = 1
  RANDOMIZE TIMER
  FOR i = 1 TO 10
    FOR j = 1 TO 18
     WorkRec1.Team = Teams(j)
     WorkRec1.Season = 1984 + i
     WorkRec1.Goals.Scored = INT(RND * 20) + 15
     WorkRec1.Goals.Lost = INT(RND * 20) + 15
     PUT #1, RecNum%, WorkRec1
     RecNum% = RecNum% + 1
    NEXT j
  NEXT i
  CLOSE #1
END SUB

FUNCTION KeyComparision (End1%, End2%)

' ***   Keys comparison function  ***
' Returns           е
'     0 - if the record's key of the first working file is not greater
'         than that of the second one,
'     1 - in the reversed case.
' Input parameters End1% and End2% take the value
'     0 - if the recurrent input ordered group or file
'         are not yet finished,
'     1 - otherwise

  IF End1% = 0 AND End2% = 0 THEN
    IF WorkRec1.Team < WorkRec2.Team THEN
      KeyComparision = 0
    ELSEIF WorkRec1.Team = WorkRec2.Team THEN
      IF WorkRec1.Season <= WorkRec2.Season THEN
	KeyComparision = 0
      ELSE
	KeyComparision = 1
      END IF
    ELSE
      KeyComparision = 1
    END IF
  ELSE
    IF End1% = 1 THEN
      KeyComparision = 1
    END IF
    IF End2% = 1 THEN
      KeyComparision = 0
    END IF
  END IF
END FUNCTION

SUB Merge
'     ***   Merging Work Files Phase   ***

  Ready$ = ""     ' Sign of completing the last merging stage
  MergePhase% = 0
  MergePortion = 0 ' Size of portion at the recurrent merging stage
  RecNum% = 1
  CLS
  LOCATE 8, 15
  PRINT "***   Merging Work Files Phase   ***"
  DO
    StepMerge MergePhase%, Ready$
    MergePhase% = (MergePhase% + 1) MOD 2
  LOOP WHILE Ready$ = ""
  ' Copying the sorted file
  FileName$ = "C:Work" + Ready$ + ".TMP"
  OPEN FileName$ FOR RANDOM AS #1 LEN = LEN(WorkRec1)
  OPEN "C:Football" FOR RANDOM AS #2 LEN = LEN(WorkRec1)
  RecNum% = 1
  GET #1, RecNum%, WorkRec1
  DO
    PUT #2, RecNum%, WorkRec1
    RecNum% = RecNum% + 1
    GET #1, RecNum%, WorkRec1
  LOOP UNTIL EOF(1)
  CLOSE #1, #2
  KILL "C:*.TMP"
END SUB

SUB PrintFile (FileName$)
  '  ***   Printing  File   ***
  '  Input parameter contains the name of the output file
  DIM Num AS STRING * 4
  CLS
  PRINT FileName$
  OPEN FileName$ FOR RANDOM AS #1 LEN = LEN(WorkRec1)
  RecNum% = 1
  GET #1, RecNum%, WorkRec1
    DO
     IF RecNum% MOD 21 = 0 THEN
       PRINT "Press any key to continue"
       WHILE INKEY$ = "": WEND
       CLS
       PRINT FileName$
     END IF
     Num = RTRIM$(STR$(RecNum%))
     PRINT Num; " "; WorkRec1.Team, WorkRec1.Season
     LOCATE CSRLIN - 1, 35
     PRINT WorkRec1.Goals.Scored, WorkRec1.Goals.Lost
     RecNum% = RecNum% + 1
     GET #1, RecNum%, WorkRec1
    LOOP UNTIL EOF(1)
  CLOSE #1
  PRINT "Press any key to continue"
  WHILE INKEY$ = "": WEND
END SUB

SUB Separate

'     ***   Separate Input File Phase   ***
  CLS
  LOCATE 8, 15
  PRINT "***   Separating Input File Phase   ***"
  KILL "C:*.TMP"
  OPEN "C:Work1.TMP" FOR RANDOM AS #1 LEN = LEN(WorkRec1)
  OPEN "C:Work2.TMP" FOR RANDOM AS #2 LEN = LEN(WorkRec1)
  OPEN "C:Football" FOR RANDOM AS #3 LEN = LEN(WorkRec1)
  RecNum1% = 0
  RecNum2% = 0
  AllRec = 1
  SepPhase% = 0
  MaxRec = 1
  GET #3, AllRec, SortArray(MaxRec)
  DO
    IF MaxRec = SortPortion THEN
      ShellSort
      FOR i = 1 TO MaxRec
  ' Selecting file for next portion to write to
	SELECT CASE SepPhase%
	  CASE 0
	    RecNum1% = RecNum1% + 1
	    PUT #1, RecNum1%, SortArray(i)
	  CASE 1
	    RecNum2% = RecNum2% + 1
	    PUT #2, RecNum2%, SortArray(i)
	END SELECT
      NEXT i
      MaxRec = 0
      SepPhase% = (SepPhase% + 1) MOD 2
    ELSE
      MaxRec = MaxRec + 1
      AllRec = AllRec + 1
      GET #3, AllRec, SortArray(MaxRec)
    END IF
  LOOP UNTIL EOF(3)
  ' Processing last portion
  MaxRec = MaxRec - 1
  ShellSort
  FOR i = 1 TO MaxRec
    SELECT CASE SepPhase%
      CASE 0
	RecNum1% = RecNum1% + 1
	PUT #1, RecNum1%, SortArray(i)
      CASE 1
	RecNum2% = RecNum2% + 1
	PUT #2, RecNum2%, SortArray(i)
    END SELECT
  NEXT i
  CLOSE #1, #2, #3
END SUB

SUB ShellSort STATIC
'                 ***      ShellSort     ***
'inputs: SortArray,MaxRec
'output: SortArray
'SortArray is sorted by the key field Team
'MaxRec -number of records in the array
' initial step of the method
 h = MaxRec \ 2

 DO WHILE h > 0          ' Loop until offset gets to zero.
'                  **     BubbleSort    **
      L = MaxRec - h
   DO
	 Switch = 0
      FOR i = 1 TO L
	 IF SortArray(i).Team > SortArray(i + h).Team THEN
	    SWAP SortArray(i), SortArray(i + h) 'обмен
	    Switch = i
	 END IF
	 IF SortArray(i).Team = SortArray(i + h).Team THEN
	   IF SortArray(i).Season > SortArray(i + h).Season THEN
	      SWAP SortArray(i), SortArray(i + h) 'swapping
	      Switch = i
	   END IF
	 END IF
      NEXT i

      ' Sort on next pass only to where the last switch was made:
      L = Switch - h
   LOOP WHILE Switch
'                  **   end  BubbleSort  **
      ' No switches at last offset, try one half as big:
      h = h \ 2
 LOOP
END SUB

SUB StepMerge (Phase%, Ready$)
  '   ***   Merging stages   ***

  '  Setting input and output files
  IF Phase% = 0 THEN
    FileName1$ = "C:Work1.TMP"
    FileName2$ = "C:Work2.TMP"
    FileName3$ = "C:Work3.TMP"
    FileName4$ = "C:Work4.TMP"
    KILL "C:Work3.TMP"
    KILL "C:Work4.TMP"
  ELSE
    FileName1$ = "C:Work3.TMP"
    FileName2$ = "C:Work4.TMP"
    FileName3$ = "C:Work1.TMP"
    FileName4$ = "C:Work2.TMP"
    KILL "C:Work1.TMP"
    KILL "C:Work2.TMP"
  END IF
  OPEN FileName1$ FOR RANDOM AS #1 LEN = LEN(WorkRec1)
  OPEN FileName2$ FOR RANDOM AS #2 LEN = LEN(WorkRec1)
  OPEN FileName3$ FOR RANDOM AS #3 LEN = LEN(WorkRec1)
  OPEN FileName4$ FOR RANDOM AS #4 LEN = LEN(WorkRec1)
  RecNum1% = 1
  RecNum2% = 1
  RecNum3% = 0
  RecNum4% = 0
  MergePortion = MergePortion + SortPortion
  OutPutSwitch% = 0   ' Switch of the output file
  ' Flags of ending the source portions
  EndGroup1% = 0
  EndGroup2% = 0
  GET #1, RecNum1%, WorkRec1        'Read first records
  i = 1
  GET #2, RecNum2%, WorkRec2
  j = 1
  DO UNTIL EOF(1) AND EOF(2)
    IF KeyComparision(EndGroup1%, EndGroup2%) = 0 THEN
      IF OutPutSwitch% = 0 THEN
	RecNum3% = RecNum3% + 1
	PUT #3, RecNum3%, WorkRec1
      ELSE
	RecNum4% = RecNum4% + 1
	PUT #4, RecNum4%, WorkRec1
      END IF
      i = i + 1
      IF i > MergePortion OR EOF(1) THEN
	EndGroup1% = 1
      ELSE
	RecNum1% = RecNum1% + 1
	GET #1, RecNum1%, WorkRec1
	IF EOF(1) THEN
	  EndGroup1% = 1
	END IF
      END IF
    ELSE
      IF OutPutSwitch% = 0 THEN
	RecNum3% = RecNum3% + 1
	PUT #3, RecNum3%, WorkRec2
      ELSE
	RecNum4% = RecNum4% + 1
	PUT #4, RecNum4%, WorkRec2
      END IF
      j = j + 1
      IF j > MergePortion OR EOF(2) THEN
	EndGroup2% = 1
      ELSE
	  RecNum2% = RecNum2% + 1
	  GET #2, RecNum2%, WorkRec2
	  IF EOF(2) THEN
	    EndGroup2% = 1
	  END IF
      END IF
    END IF
    ' End of merging a recurrent pair of portions
    IF EndGroup1% = 1 AND EndGroup2% = 1 THEN
      i = 1
      j = 1
      OutPutSwitch% = (OutPutSwitch% + 1) MOD 2
      IF NOT EOF(1) THEN
	RecNum1% = RecNum1% + 1
	GET #1, RecNum1%, WorkRec1        'Read first records
	IF EOF(1) THEN
	  EndGroup1% = 1
	ELSE
	  EndGroup1% = 0
	END IF
      END IF
      IF NOT EOF(2) THEN
	RecNum2% = RecNum2% + 1
	GET #2, RecNum2%, WorkRec2        'next portions
	IF EOF(2) THEN
	  EndGroup2% = 1
	ELSE
	  EndGroup2% = 0
	END IF
      END IF
    END IF
  LOOP
  CLOSE #1, #2, #3, #4
  IF Phase% = 0 THEN        ' Setting resulting file
    IF RecNum3% = 0 THEN
      Ready$ = "4"
    ELSEIF RecNum4% = 0 THEN
      Ready$ = "3"
    END IF
  ELSE
    IF RecNum3% = 0 THEN
      Ready$ = "2"
    ELSEIF RecNum4% = 0 THEN
      Ready$ = "1"
    END IF
  END IF
END SUB

