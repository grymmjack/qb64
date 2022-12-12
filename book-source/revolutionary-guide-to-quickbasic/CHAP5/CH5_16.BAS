REM   PROGRAM CH5_16
REM   **************************************************
REM   * Searching for Records in a Sorted Array        *
REM   * by Way of its Sequential Bisection             *
REM   **************************************************

  DEFINT A-Z      ' Default type integer
  DECLARE SUB BiSearch ()
  DECLARE SUB InArray ()
  DECLARE SUB PrintArray ()
'Definition of a record, its key - Info
  TYPE SortType
     Info AS STRING * 14
     Date AS STRING * 8
  END TYPE

  DIM SHARED SortArray(1 TO 1000) AS SortType
  DIM SHARED MaxRec
  DIM SHARED KeySearch AS STRING * 14

   CLS
   InArray
   PRINT "SEQUENTIAL BISECTION SEARCH OF SORTED DATA"
   PRINT
   PRINT "               City"
   PrintArray
   BiSearch
   END

  'Number of records
  DATA  10

  'Ordered data
  DATA Magadan,      1931
  DATA Minsk,        1067
  DATA Moscow,       1147
  DATA Novgorod,      859
  DATA Petersburg,   1703
  DATA Smolensk,      863
  DATA Uglitch,       937
  DATA Veliky Ustyug,1207
  DATA Vologda,      1147
  DATA Yaroslavl,    1010

SUB BiSearch
  PRINT
  INPUT "Name of the city"; KeySearch
  L = 1: R = MaxRec: p = 0' start value
        DO
          i = (R + L) \ 2
          IF KeySearch = SortArray(i).Info THEN
            PRINT
            PRINT "        Search is successful"
            PRINT i; SortArray(i).Info;
            PRINT " Year of foundation: "; SortArray(i).Date;
            p = 1
            EXIT DO
          END IF
          IF KeySearch < SortArray(i).Info THEN
                 R = i - 1
          ELSE
                 L = i + 1
          END IF
        LOOP WHILE R - L + 1
        IF p = 0 THEN
          PRINT " Record not found "
        END IF
END SUB

SUB InArray

'Entering an array of records.   MaxRec - number of records
' A record consists of the fields Info and Date

  READ MaxRec
  FOR i = 1 TO MaxRec
   READ SortArray(i).Info
   READ SortArray(i).Date
  NEXT i

END SUB

 SUB PrintArray
   PRINT
   FOR i = 1 TO MaxRec
     PRINT i, SortArray(i).Info
   NEXT i

END SUB

