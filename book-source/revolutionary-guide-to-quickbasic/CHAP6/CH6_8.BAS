REM Averaging Random Access Files
REM \CHAP6\CH6_8.BAS

DEFINT A-Z      ' Default type integer.
DECLARE SUB SumGoals (TGoals AS ANY, CGoals AS ANY)
DECLARE SUB PrintAV ()
DECLARE SUB Total ()

' Define the data types
  TYPE GoalsType
    Scored AS INTEGER
    Lost AS INTEGER
  END TYPE
  TYPE FootballType       'Type of FOOTBALL file record
     Team AS STRING * 20
     Season AS INTEGER
     Goals AS GoalsType
  END TYPE
  TYPE TotalType          'Type of TOTAL record
     Team AS STRING * 20
     Goals AS GoalsType
  END TYPE
' Define the variables
  DIM SHARED TotalRec AS TotalType, CurrRec AS FootballType
  CLS
  LOCATE 8, 15
  PRINT "***   AVERAGING TYPED FILE   ***"
  LOCATE 10, 15
  PRINT "Press any key to continue"
  WHILE INKEY$ = "": WEND
  Total
  END

SUB PrintAV

'***  Calculating Mean Values and Outputting the Summarizing Line  ***

   AverScored = TotalRec.Goals.Scored / 10
   AverLost = TotalRec.Goals.Lost / 10
   PRINT TotalRec.Team, AverScored, AverLost
END SUB

SUB SumGoals (TGoals AS GoalsType, CGoals AS GoalsType)

'   *** Calculating Scored and Lost Goals ***
  TGoals.Scored = TGoals.Scored + CGoals.Scored
  TGoals.Lost = TGoals.Lost + CGoals.Lost
END SUB

SUB Total

' *** Controlling File Sequential Processing ***
  CONST SubLine$ = "________________", FileName$ = "Football"
  DIM Num AS STRING * 4
  CLS
  PRINT FileName$
  OPEN FileName$ FOR RANDOM AS #1 LEN = LEN(CurrRec)
  RecNum% = 1
  GET #1, RecNum%, CurrRec      ' Reading first record of file
  TotalRec.Team = CurrRec.Team  ' Setting up initial values
  TotalRec.Goals.Scored = 0     ' of summarizing variables
  TotalRec.Goals.Lost = 0       ' for first group
  PRINT "     Team", "", "Goals"
  PRINT "", "  " + SubLine$ + SubLine$
  PRINT "", "      Scored", "               Lost"
  PRINT SubLine$ + SubLine$ + SubLine$
    DO
     IF TotalRec.Team = CurrRec.Team THEN
       SumGoals TotalRec.Goals, CurrRec.Goals
       RecNum% = RecNum + 1
       GET #1, RecNum%, CurrRec
     ELSE
       PrintAV
       TotalRec.Team = CurrRec.Team 'Setting up initial values
       TotalRec.Goals.Scored = 0    'of summarizing variables
       TotalRec.Goals.Lost = 0      'for the next in turn group
     END IF
    LOOP UNTIL EOF(1)
  PrintAV
  CLOSE #1
END SUB

