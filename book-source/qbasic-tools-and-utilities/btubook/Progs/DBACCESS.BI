'********* DBACCESS.BI - Include file containing all dbAccess declaration

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE SUB CloseDBF (FileNum, TRecs&)
DECLARE SUB CreateDBF (FileName$, FldArray() AS FieldStruc)
DECLARE SUB GetRecord (FileNum, RecNum&, Record$, Header AS DBFHeadStruc)
DECLARE SUB OpenDBF (FileNum, FileName$, Header AS DBFHeadStruc, FldArray() AS FieldStruc)
DECLARE SUB SetField (Record$, FText$, FldNum, FldArray() AS FieldStruc)
DECLARE SUB SetRecord (FileNum, RecNum&, Record$, Header AS DBFHeadStruc)

DECLARE FUNCTION PackDate$ ()
DECLARE FUNCTION GetField$ (Record$, FldNum, FldArray() AS FieldStruc)
DECLARE FUNCTION GetFldNum% (FldName$, FldArray() AS FieldStruc)
DECLARE FUNCTION Deleted% (Record$)
DECLARE FUNCTION Padded$ (Fld$, FLen)
