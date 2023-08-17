'*********** DBCREATE.BAS - creates a DBF file

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

'$INCLUDE: 'DBF.BI'
'$INCLUDE: 'DBACCESS.BI'

CLS
LOCATE , , 1

LINE INPUT "Enter DBF name: "; DBFName$
IF INSTR(DBFName$, ".") = 0 THEN
  DBFName$ = DBFName$ + ".DBF"
END IF

DO
  INPUT "Enter number of fields"; TFields
  IF TFields <= 128 THEN EXIT DO
  PRINT "Only 128 fields are allowed"
LOOP

REDIM FldStruc(1 TO TFields) AS FieldStruc

FOR X = 1 TO TFields
  CLS
  DO
    PRINT "Field #"; X
    LINE INPUT "Enter field name: ", Temp$
    IF LEN(Temp$) <= 10 THEN EXIT DO
    PRINT "Field names are limited to 10 characters"
  LOOP
  FldStruc(X).FName = Temp$

  PRINT "Enter field type (Char, Date, Logical, Memo, ";
  PRINT "Numeric (C,D,L,M,N): ";
  DO
    Temp$ = UCASE$(INKEY$)
  LOOP UNTIL INSTR(" CDLMN", Temp$) > 1
  PRINT
  FldStruc(X).FType = Temp$
  FldType = ASC(Temp$)

  SELECT CASE FldType
    CASE 67                     'Character
      DO
        INPUT "Enter field length: ", FldStruc(X).FLen
        IF FldStruc(X).FLen <= 255 THEN EXIT DO
        PRINT "Character field limited to 255 characters"
      LOOP

    CASE 78                     'Numeric
      DO
        INPUT "Enter field length: ", FldStruc(X).FLen
        IF FldStruc(X).FLen <= 19 THEN EXIT DO
        PRINT "Numeric field limited to 19 characters"
      LOOP
      DO
        INPUT "Enter number of decimal places: ", FldStruc(X).Dec
        IF FldStruc(X).Dec < FldStruc(X).FLen THEN EXIT DO
        PRINT "Too many decimal places"
      LOOP

    CASE 76                     'Logical
        FldStruc(X).FLen = 1

    CASE 68                     'Date
        FldStruc(X).FLen = 8
     
    CASE 77
        FldStruc(X).FLen = 10

    END SELECT
NEXT

CALL CreateDBF(DBFName$, FldStruc())
PRINT DBFName$; " created"
