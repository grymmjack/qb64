'*********** DBF.BI - Record declarations for the dbAccess routines

'Copyright (c) 1992 Ethan Winer

TYPE DBFHeadStruc
  Version  AS INTEGER
  Memo     AS INTEGER
  Year     AS INTEGER
  Month    AS INTEGER
  Day      AS INTEGER
  FirstRec AS INTEGER
  TRecs    AS LONG
  RecLen   AS INTEGER
  TFields  AS INTEGER
END TYPE

TYPE FieldStruc
  FName AS STRING * 10
  FType AS STRING * 1
  FOff  AS INTEGER
  FLen  AS INTEGER
  Dec   AS INTEGER
END TYPE
