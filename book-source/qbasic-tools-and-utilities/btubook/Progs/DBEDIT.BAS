'*********** DBEDIT.BAS - edits a record in a DBF file

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'$INCLUDE: 'dbf.bi'
'$INCLUDE: 'dbaccess.bi'

DIM Header AS DBFHeadStruc
REDIM FldStruc(1 TO 1) AS FieldStruc

CLS
LINE INPUT "Enter .DBF file name: ", DBFName$
IF INSTR(DBFName$, ".") = 0 THEN
  DBFName$ = DBFName$ + ".DBF"
END IF

CALL OpenDBF(1, DBFName$, Header, FldStruc())

Record$ = SPACE$(Header.RecLen)
RecNum& = 1
RecChanged = 0

GOSUB GetTheRecord

DO
  PRINT "What do you want to do (Next, Prior, Edit, ";
  PRINT "Delete, Undelete, Add, Quit)? ";
  SELECT CASE UCASE$(INPUT$(1))
    CASE "N"
      IF RecChanged THEN
        CALL SetRecord(1, RecNum&, Record$, Header)
      END IF
      RecNum& = RecNum& + 1
      IF RecNum& > Header.TRecs THEN
        RecNum& = 1
      END IF
      GOSUB GetTheRecord
      
    CASE "P"
      IF RecChanged THEN
        CALL SetRecord(1, RecNum&, Record$, Header)
      END IF
      RecNum& = RecNum& - 1
      IF RecNum& < 1 THEN
        RecNum& = Header.TRecs
      END IF
      GOSUB GetTheRecord
      
    CASE "E"
Edit:
      PRINT
      INPUT "Enter the field number:"; Fld
      DO
        PRINT "New "; FldStruc(Fld).FName;
        INPUT Text$
        IF LEN(Text$) <= FldStruc(Fld).FLen THEN EXIT DO
        PRINT "Too long, only "; FldStruc(Fld).FLen
      LOOP
      CALL SetField(Record$, Text$, Fld, FldStruc())
      RecChanged = -1
      GOSUB DisplayRec
      
    CASE "D"
      MID$(Record$, 1) = "*"
      RecChanged = -1
      GOSUB DisplayRec
      
    CASE "U"
      MID$(Record$, 1, 1) = " "
      RecChanged = -1
      GOSUB DisplayRec

    CASE "A"
      Header.TRecs = Header.TRecs + 1
      RecNum& = Header.TRecs
      LSET Record$ = ""
      GOTO Edit
      
    CASE ELSE
      EXIT DO
  END SELECT
LOOP

IF RecChanged THEN
  CALL SetRecord(1, RecNum&, Record$, Header)
END IF
CloseDBF 1, Header.TRecs
END


GetTheRecord:
  CALL GetRecord(1, RecNum&, Record$, Header)

DisplayRec:
  CLS
  PRINT "Record "; RecNum&; " of "; Header.TRecs;
  IF Deleted%(Record$) THEN PRINT " (Deleted)";

  PRINT
  PRINT
  FOR Fld = 1 TO Header.TFields
    FldText$ = GetField$(Record$, Fld, FldStruc())
    PRINT FldStruc(Fld).FName, FldText$
  NEXT
  PRINT

RETURN
