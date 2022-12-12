REM Searching in a Hash File
REM \CHAP6\CH6_9.BAS

DEFINT A-Z      ' Default type integer
'   *********************************************************
'   *           Creating a hash-file                        *
'   *           Searching for a record by its hash-function *
'   *********************************************************
  DECLARE FUNCTION HashKey% (x$)
  DECLARE SUB HashSearch ()
  DECLARE SUB CreateHashFile ()
  DECLARE SUB PrintFile ()
'Definition of a record, its key is the Town field
  TYPE RecType
     Town AS STRING * 14
     Date AS STRING * 8
  END TYPE
  CONST MaxHash = 13 'Max value of hash-function
  CONST RpZ = 3      'Records per zone

  DIM SHARED HashRec AS RecType
  DIM SHARED Num, NumRec, InData, Info$, ErrorCall

   CLS
   LOCATE 10, 20
   PRINT "*** ORGANIZING A HASH-FILE AND SEARCHING FOR RECORDS IN IT *** "
   LOCATE 12, 20
   PRINT "Press any key to continue"
   WHILE INKEY$ = "": WEND
   CLS
   CreateHashFile
   PrintFile
   HashSearch
   CLOSE 1
  END

ErrorHandler:
  IF ERR = 5 AND ErrorCall = 0 THEN
    PRINT "Can't build hash-key for "; Info$
    ErrorCall = 1
  END IF
  RESUME NEXT

  'Number of input data
  DATA  16
  'Data for records
  DATA Moscow,     1147, Magadan,   1931, Novgorod,       859
  DATA Smolensk,    863, Yaroslavl, 1010, Uglitch,        937
  DATA Vologda,    1147, Minsk,     1067, New Orlean,    1718
  DATA Novy Afon,  1875, New York,  1626, Magnitogorsk,  1931
  DATA Newcastle,  1045, Newark,    1626, Veliky Ustyug, 1207
  DATA Petersburg, 1703

SUB CreateHashFile
'   ***   Creating a hash-file and entering records in it  ***

  OPEN "town.hsh" FOR RANDOM AS #1 LEN = LEN(HashRec)
  ' Creating an empty file
  FOR i = 1 TO MaxHash * RpZ
    HashRec.Town = "              "
    HashRec.Date = "        "
    PUT #1, i, HashRec
  NEXT i
  ' Filling a file with records
  READ InData
  FOR i = 1 TO InData                  'Reading input data
    READ Info$
    READ Dat$
    Num = RpZ * HashKey%(Info$)
    ZoneTrashing = 1
    FOR j = 1 TO RpZ         ' Looking for a free place in a zone
       GET #1, Num + j, HashRec
       IF HashRec.Town = "              " THEN
          HashRec.Town = Info$
          HashRec.Date = Dat$
          PUT #1, Num + j, HashRec  'Outputting a record
          ZoneTrashing = 0          'on an free location
          EXIT FOR
       END IF
    NEXT j
    IF ZoneTrashing = 1 THEN '  Zone is overfilled,
                             '  no record output
       PRINT Info$, " - Number of collisions > ", RpZ
    END IF
   NEXT i
END SUB

FUNCTION HashKey% (x$)

'   ***  Calculating a hash-function  ***

   ON ERROR GOTO ErrorHandler
   ErrorCall = 0
   L1$ = MID$(x$, 1, 1)
   L2$ = MID$(x$, 2, 1)
   L3$ = MID$(x$, 3, 1)
   Hundred% = ASC(L1$) MOD 2
   Ten% = ASC(L2$) MOD 10
   One% = ASC(L3$) MOD 10
   HashKey% = (100 * Hundred% + 10 * Ten% + One% + 1) MOD MaxHash
   ON ERROR GOTO 0
END FUNCTION

SUB HashSearch

'   ***   Search in a hash-file   ***

  PRINT
  PRINT "    Search in a Hash-File "
  VIEW PRINT 21 TO 23
  R$ = "Y"
  DO
  CLS 2
  INPUT "Town: "; Info$   ' Enter the required key
  Num = RpZ * HashKey%(Info$)
  NoFound = 1
  FOR j = 1 TO RpZ
     GET #1, Num + j, HashRec
     IF RTRIM$(UCASE$(HashRec.Town)) = UCASE$(Info$) THEN
       PRINT "        Search is successful"
       PRINT HashRec.Town; " Year of foundation"; HashRec.Date
       NoFound = 0
       EXIT FOR
     END IF
  NEXT j
  IF NoFound = 1 THEN
    PRINT " Record not found  "
  END IF
  INPUT "Do you want to repeat the request [Y/N]"; R$
 LOOP WHILE UCASE$(R$) = "Y"
END SUB

 SUB PrintFile
   PRINT "_____________________________________________"
   FOR i = 1 TO MaxHash * RpZ
     GET #1, i, HashRec
     IF HashRec.Town <> "              " THEN
       PRINT HashRec.Town, HashKey%(HashRec.Town), i
     END IF
   NEXT i
END SUB

