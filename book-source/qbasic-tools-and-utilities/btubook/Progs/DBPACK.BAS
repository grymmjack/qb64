'*********** DBPACK.BAS - removes deleted records from a DBF file

'Copyright (c) 1992 Ethan Winer

'NOTE: Please make a copy of your .DBF file before running this program.
'      Unlike dBASE that works with a copy of the data file, this program
'      packs, swaps records, and then truncates the original data file.

DEFINT A-Z
'$INCLUDE: 'DBF.BI'
'$INCLUDE: 'DBACCESS.BI'
'$INCLUDE: 'REGTYPE.BI'

DIM Registers AS RegType
DIM Header AS DBFHeadStruc
REDIM FldStruc(1 TO 1) AS FieldStruc

LINE INPUT "Enter the dBASE file name: ", DBFName$
IF INSTR(DBFName$, ".") = 0 THEN
  DBFName$ = DBFName$ + ".DBF"
END IF

CALL OpenDBF(1, DBFName$, Header, FldStruc())

Record$ = SPACE$(Header.RecLen)
GoodRecs& = 0

FOR Rec& = 1 TO Header.TRecs
  GetRecord 1, Rec&, Record$, Header
  IF NOT Deleted%(Record$) THEN
    CALL SetRecord(1, GoodRecs& + 1, Record$, Header)
    GoodRecs& = GoodRecs& + 1
  END IF
NEXT

'This trick truncates the file

RecOff& = (GoodRecs& * Header.RecLen) + Header.FirstRec
Eof$ = CHR$(26)
PUT #1, RecOff&, Eof$
SEEK #1, RecOff& + 1

Registers.AX = &H4000           'service to write to a file
Registers.BX = FILEATTR(1, 2)   'get the DOS handle
Registers.CX = 0                'write 0 bytes to truncate
CALL Interrupt(&H21, Registers, Registers)
CALL CloseDBF(1, GoodRecs&)

PRINT "All of the deleted records were removed from "; DBFName$
PRINT GoodRecs&; "remaining records"
