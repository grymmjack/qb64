REM   PROGRAM CH5_17
REM   **************************************************
REM   *      Constructing a Binary Search Tree         *
REM   *      Searching for Records on the Tree         *
REM   **************************************************
REM   Note: Case sensitive

  DEFINT A-Z      ' Default type integer.
  DECLARE SUB Search ()
  DECLARE SUB Tree ()
  DECLARE SUB InArray ()

  DECLARE SUB PrintArray ()
'Definition of a record
  TYPE TreeType
     Info AS STRING * 14
     Date AS STRING * 8
     Left AS INTEGER
     Richt AS INTEGER
  END TYPE

  DIM SHARED TreeArray(1 TO 1000) AS TreeType
  DIM SHARED MaxRec, i
  DIM SHARED KeyTree AS STRING * 14

   CLS
   InArray
   PRINT "    BUILDING A BINARY SEARCH TREE       "
   PRINT
   PRINT "City-node        left son     right son "
   PRINT "---------------|------------|--------------"
   Tree
   PrintArray
   Search
   END

'Number of records
  DATA  10
'Data for searching
  DATA Moscow,        1147, Magadan,    1931, Novgorod, 859
  DATA Smolensk,       863, Yaroslavl,  1010, Uglitch,   937
  DATA Vologda,       1147, Minsk,      1067
  DATA Veliky Ustyug, 1207, Petersburg, 1703

SUB InArray
'Entering an array of records.   MaxRec - number of records
' A records consists of the fields Info and Date
  READ MaxRec
  FOR i = 1 TO MaxRec
   READ TreeArray(i).Info
   READ TreeArray(i).Date
  NEXT i

END SUB

SUB PrintArray

   FOR i = 1 TO MaxRec
     iL = TreeArray(i).Left: iR = TreeArray(i).Richt
     PRINT i; TreeArray(i).Info;
     IF iL <> 0 THEN
        PRINT TreeArray(iL).Info;
     ELSE PRINT "----------- ";
     END IF
     IF iR <> 0 THEN
        PRINT TreeArray(iR).Info
     ELSE PRINT " ---------- "
     END IF
   NEXT i

END SUB

SUB Search
  PRINT
  PRINT "         SEARCH ON THE TREE"
  INPUT "Name of the city"; KeyTree
  p = 1 ' start value of the index of the minimum key
        DO
          IF KeyTree = TreeArray(p).Info THEN
            PRINT
            PRINT "        Search is successful"
            PRINT p; TreeArray(p).Info;
            PRINT " Year of foundation: "; TreeArray(p).Date;
            EXIT DO
          END IF
          IF KeyTree < TreeArray(p).Info THEN
                 p = TreeArray(p).Left
          ELSE
                 p = TreeArray(p).Richt
          END IF
        LOOP WHILE p

        IF p = 0 THEN
          PRINT "Record not found"
        END IF
END SUB

SUB Tree

  FOR i = 2 TO MaxRec   'i-number of a pass
  q = 1 ' start value of the index of a mimimum key
        DO
          p = q
          IF TreeArray(i).Info < TreeArray(p).Info THEN
                q = TreeArray(p).Left
          ELSE
                q = TreeArray(p).Richt
          END IF
     LOOP WHILE q
          IF TreeArray(i).Info < TreeArray(p).Info THEN
                 TreeArray(p).Left = i
          ELSE
                 TreeArray(p).Richt = i
          END IF
  NEXT i
END SUB

