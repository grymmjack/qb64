'*********** DBACCESS.BAS - support module for access to .DBF files

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE FUNCTION Deleted% (Record$)
DECLARE FUNCTION GetField$ (Record$, FldNum, FldArray() AS ANY)
DECLARE FUNCTION GetFldNum% (FieldName$, FldArray() AS ANY)
DECLARE FUNCTION PackDate$ ()
DECLARE FUNCTION Padded$ (Fld$, FLen)

'$INCLUDE: 'DBF.BI'
'$INCLUDE: 'DBACCESS.BI'

SUB CloseDBF (FileNum, TRecs&) STATIC

  Temp$ = PackDate$
  PUT #FileNum, 2, Temp$
  PUT #FileNum, 5, TRecs&
  CLOSE #FileNum

END SUB

SUB CreateDBF (FileName$, FieldArray() AS FieldStruc) STATIC

  TFields = UBOUND(FieldArray)
  HLen = TFields * 32 + 33
  Header$ = STRING$(HLen + 1, 0)
  Memo = 0

  FldBuf$ = STRING$(32, 0)
  ZeroStuff$ = FldBuf$
  FldOff = 33
  RecLen = 1

  FOR X = 1 TO TFields
    MID$(FldBuf$, 1) = FieldArray(X).FName
    MID$(FldBuf$, 12) = FieldArray(X).FType
    MID$(FldBuf$, 17) = CHR$(FieldArray(X).FLen)
    MID$(FldBuf$, 18) = CHR$(FieldArray(X).Dec)
    MID$(Header$, FldOff) = FldBuf$
    LSET FldBuf$ = ZeroStuff$
    FldOff = FldOff + 32
    IF FieldArray(X).FType = "M" THEN Memo = -1
    RecLen = RecLen + FieldArray(X).FLen
  NEXT

  IF Memo THEN Version = 131 ELSE Version = 3
  MID$(Header$, 1) = CHR$(Version)
  Today$ = DATE$
  Year = VAL(RIGHT$(Today$, 2))
  Day = VAL(MID$(Today$, 4, 2))
  Month = VAL(LEFT$(Today$, 2))

  MID$(Header$, 2) = PackDate$
  MID$(Header$, 5) = MKL$(0)
  MID$(Header$, 9) = MKI$(HLen)
  MID$(Header$, 11, 2) = MKI$(RecLen)
  MID$(Header$, FldOff) = CHR$(13)
  MID$(Header$, FldOff + 1) = CHR$(26)

  OPEN FileName$ FOR BINARY AS #1
  PUT #1, 1, Header$
  CLOSE #1

END SUB

FUNCTION Deleted% (Record$) STATIC

  Deleted% = 0
  IF LEFT$(Record$, 1) = "*" THEN Deleted% = -1

END FUNCTION

FUNCTION GetField$ (Record$, FldNum, FldArray() AS FieldStruc) STATIC

  GetField$ = MID$(Record$, FldArray(FldNum).FOff, FldArray(FldNum).FLen)

END FUNCTION

FUNCTION GetFldNum% (FieldName$, FldArray() AS FieldStruc) STATIC

  FOR X = 1 TO UBOUND(FldArray)
    IF FldArray(X).FName = FieldName$ THEN
      GetFldNum = X
      EXIT FUNCTION
    END IF
  NEXT

END FUNCTION

SUB GetRecord (FileNum, RecNum&, Record$, Header AS DBFHeadStruc) STATIC

  RecOff& = ((RecNum& - 1) * Header.RecLen) + Header.FirstRec
  GET FileNum, RecOff&, Record$

END SUB

SUB OpenDBF (FileNum, FileName$, Header AS DBFHeadStruc, FldArray() AS FieldStruc) STATIC

  OPEN FileName$ FOR BINARY AS FileNum
  GET FileNum, 9, HLen
  Header.FirstRec = HLen + 1
  Buffer$ = SPACE$(HLen)

  GET FileNum, 1, Buffer$
  Header.Version = ASC(Buffer$)
  IF Header.Version = 131 THEN
    Header.Version = 3
    Header.Memo = -1
  ELSE
    Header.Memo = 0
  END IF

  Header.Year = ASC(MID$(Buffer$, 2, 1))
  Header.Month = ASC(MID$(Buffer$, 3, 1))
  Header.Day = ASC(MID$(Buffer$, 4, 1))
  Header.TRecs = CVL(MID$(Buffer$, 5, 4))
  Header.RecLen = CVI(MID$(Buffer$, 11, 2))
  Header.TFields = (HLen - 33) \ 32

  REDIM FldArray(1 TO Header.TFields) AS FieldStruc
  OffSet = 2
  BuffOff = 33
  Zero$ = CHR$(0)

  FOR X = 1 TO Header.TFields
    FTerm = INSTR(BuffOff, Buffer$, Zero$)
    FldArray(X).FName = MID$(Buffer$, BuffOff, FTerm - BuffOff)
    FldArray(X).FType = MID$(Buffer$, BuffOff + 11, 1)
    FldArray(X).FOff = OffSet
    FldArray(X).FLen = ASC(MID$(Buffer$, BuffOff + 16, 1))
    FldArray(X).Dec = ASC(MID$(Buffer$, BuffOff + 17, 1))
    OffSet = OffSet + FldArray(X).FLen
    BuffOff = BuffOff + 32
  NEXT

END SUB

FUNCTION PackDate$ STATIC

  Today$ = DATE$
  Year = VAL(RIGHT$(Today$, 2))
  Day = VAL(MID$(Today$, 4, 2))
  Month = VAL(LEFT$(Today$, 2))

  PackDate$ = CHR$(Year) + CHR$(Month) + CHR$(Day)

END FUNCTION

FUNCTION Padded$ (Fld$, FLen) STATIC

  Temp$ = SPACE$(FLen)
  LSET Temp$ = Fld$
  Padded$ = Temp$

END FUNCTION

SUB SetField (Record$, FText$, FldNum, FldArray() AS FieldStruc) STATIC

  FText$ = Padded$(FText$, FldArray(FldNum).FLen)
  MID$(Record$, FldArray(FldNum).FOff, FldArray(FldNum).FLen) = FText$

END SUB

SUB SetRecord (FileNum, RecNum&, Record$, Header AS DBFHeadStruc) STATIC

  RecOff& = ((RecNum& - 1) * Header.RecLen) + Header.FirstRec
  PUT FileNum, RecOff&, Record$

END SUB
