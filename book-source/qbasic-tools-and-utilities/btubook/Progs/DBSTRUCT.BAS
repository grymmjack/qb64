'*********** DBSTRUCT.BAS - displays the structure of a DBF file

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'$INCLUDE: 'DBF.BI'
'$INCLUDE: 'DBACCESS.BI'

DEF FnTrim$ (DateInfo) = LTRIM$(STR$(DateInfo))
DIM Header AS DBFHeadStruc
REDIM FldStruc(1 TO 1) AS FieldStruc

CLS
LINE INPUT "Enter the DBF file name: ", DBFName$
IF INSTR(DBFName$, ".") = 0 THEN
  DBFName$ = DBFName$ + ".DBF"
END IF

CALL OpenDBF(1, DBFName$, Header, FldStruc())
CLOSE #1

PRINT "Structure of " + DBFName$
PRINT

PRINT "Version:     "; Header.Version
PRINT "Last Update: "; FnTrim$(Header.Month);
PRINT "/" + FnTrim$(Header.Day);
PRINT "/" + FnTrim$(Header.Year)
PRINT "# Records:   "; Header.TRecs
PRINT "Rec Length:  "; Header.RecLen
PRINT "# Fields:    "; Header.TFields
PRINT
PRINT "Name", "Type", "Offset", "Length", "# Decimals"
PRINT "----", "----", "------", "------", "----------"

FOR X = 1 TO Header.TFields
  PRINT FldStruc(X).FName,
  PRINT FldStruc(X).FType,
  PRINT FldStruc(X).FOff,
  PRINT FldStruc(X).FLen,
  PRINT FldStruc(X).Dec
NEXT
