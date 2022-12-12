REM   PROGRAM CH5_18
REM   ****************************************************
REM   *      Hashing the Array of Records.               *
REM   *      Searching for a Record by Its Hash-Function *
REM   ****************************************************

  DEFINT A-Z      ' Default type integer
  DECLARE FUNCTION HashKey% (x$)
  DECLARE SUB HashSearch ()
  DECLARE SUB HashInArray ()
  DECLARE SUB PrintArray ()
'Definition of a record, its key is a number
  TYPE RecType
     Info AS STRING * 14
     Date AS STRING * 8
  END TYPE
  CONST ConstHash = 20
  DIM SHARED HashArray(1 TO 1000) AS RecType
  DIM SHARED MaxRec   '<=50
  DIM SHARED KeyH AS STRING * 14
CLS
   PRINT "        H A S H I N G     "
   PRINT
   PRINT "   City            Hash-function"
   HashInArray
   PrintArray
   HashSearch
  END
  'Number of records <=50
  DATA  10
  'Data for records
  DATA Moscow,        1147, Magadan,    1931, Novgorod, 859
  DATA Smolensk,       863, Yaroslavl,  1010, Uglitch,   937
  DATA Vologda,       1147, Minsk,      1067
  DATA Veliky Ustyug, 1207, Petersburg, 1703

'==================================================

DEFSNG A-Z

DEFINT A-Z
SUB HashInArray
'Entering an array of records.   MaxRec - number of records.
' A record consists of the fields Info and KeyS
  READ MaxRec
  FOR i = 1 TO ConstHash * MaxRec
    HashArray(i).Info = "              "
  NEXT i
  FOR i = 1 TO MaxRec
   READ Info$
   READ Dat$
   k = HashKey%(Info$)
    HashArray(k).Info = Info$
    HashArray(k).Date = Dat$
  NEXT i

END SUB

FUNCTION HashKey% (x$)
 IF LEN(x$) >= 5 THEN
   L1$ = MID$(x$, 1, 1)   'Takes first, third and fifth characters of city name
   L2$ = MID$(x$, 3, 1)   'for the hash key
   L3$ = MID$(x$, 5, 1)
   Hundred% = ASC(L1$) MOD 2  'Calculates value of Hundreds, Tens and Units using
   Ten% = ASC(L2$) MOD 10     'the remainder from MOD division
   One% = ASC(L3$) MOD 10
   HashKey% = 100 * Hundred% + 10 * Ten% + One% + 1
 ELSE
   HashKey% = ConstHash * MaxRec
 END IF
END FUNCTION

SUB HashSearch
  PRINT
  PRINT "    SEARCH IN A HASHED ARRAY OF RECORDS"
  PRINT
          INPUT "Name of the city"; Info$
          k = HashKey%(Info$)

          IF RTRIM$(HashArray(k).Info) = Info$ THEN
            PRINT
            PRINT "        Search is successful "
            PRINT k; HashArray(k).Info;
            PRINT " Year of foundation: "; HashArray(k).Date;
          ELSE
            PRINT " Record not found "
          END IF
END SUB

 SUB PrintArray
   PRINT
   FOR i = 1 TO ConstHash * MaxRec
   IF HashArray(i).Info <> "              " THEN
     PRINT HashArray(i).Info,
     PRINT i
   END IF
   NEXT i

END SUB

