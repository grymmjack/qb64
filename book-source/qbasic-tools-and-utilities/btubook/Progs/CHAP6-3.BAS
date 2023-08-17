'*********** CHAP6-3.BAS - random access file demonstration

'Copyright (c) 1992 Ethan Winer

'----- create a data file containing five records
DEFINT A-Z

TYPE MyType
  FirstName AS STRING * 17
  LastName  AS STRING * 14
  DblValue  AS DOUBLE
  IntValue  AS INTEGER
  MiscStuff AS STRING * 20
  SngValue  AS SINGLE
END TYPE
DIM MyVar AS MyType

OPEN "MYFILE.DAT" FOR RANDOM AS #1 LEN = 65
MyVar.FirstName = "Jonathan"
MyVar.LastName = "Smith"
MyVar.DblValue = 123456.7
MyVar.IntValue = 10
MyVar.MiscStuff = "Miscellaneous stuff"
MyVar.SngValue = 14.29
FOR X = 1 TO 5
  PUT #1, , MyVar
  MyVar.DblValue = MyVar.DblValue * 2
  MyVar.IntValue = MyVar.IntValue * 2
  MyVar.SngValue = MyVar.SngValue * 2
NEXT
CLOSE #1


'----- read the data without regard to the TYPE above
READ FileName$, NumFields
REDIM Buffer$(1 TO NumFields)   'holds the FIELD strings
REDIM FieldType(1 TO NumFields) 'the array of data types

RecLength = 0
FOR X = 1 TO NumFields
  READ ThisType
  FieldType(X) = ThisType
  RecLength = RecLength + ABS(ThisType)
NEXT

OPEN FileName$ FOR RANDOM AS #1 LEN = RecLength

PadLength = 0
FOR X = 1 TO NumFields
  ThisLength = ABS(FieldType(X))
  FIELD #1, PadLength AS Pad$, ThisLength AS Buffer$(X)
  PadLength = PadLength + ThisLength
NEXT
CLS
NumRecs = LOF(1) \ RecLength    'calc number of records
FOR X = 1 TO NumRecs            'read each in sequence
  GET #1                        'get the current record
  LOCATE 1, 1
  FOR Y = 1 TO NumFields        'walk through each field
    PRINT "Field"; Y; TAB(15);  'display each field
    SELECT CASE FieldType(Y)    'see what type of data
      CASE -8                   'double precision
        PRINT CVD(Buffer$(Y))   'so use CVD
      CASE -4                   'single precision
        PRINT CVS(Buffer$(Y))   'as above
      CASE -2                   'integer
        PRINT CVI(Buffer$(Y))
      CASE ELSE                 'string
        PRINT Buffer$(Y)
    END SELECT
  NEXT
  LOCATE 20, 1
  PRINT "Press a key to view the next record ";
  WHILE LEN(INKEY$) = 0: WEND
NEXT
CLOSE #1

DATA MYFILE.DAT, 6
DATA 17, 14, -8, -2, 20, -4
