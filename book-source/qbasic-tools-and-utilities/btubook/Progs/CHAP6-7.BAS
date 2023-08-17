'*********** CHAP6-7.BAS - shows how to load/save huge arrays

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
'NOTE: This program must be compiled with the /ah option.

DECLARE SUB BigLoad (FileName$, Segment, Address, NumBytes&)
DECLARE SUB BigSave (FileName$, Segment, Address, NumBytes&)
DECLARE SUB BCGet ALIAS "B$Get3" (BYVAL FileNum, BYVAL Segment, BYVAL Address, BYVAL NumBytes)
DECLARE SUB BCPut ALIAS "B$Put3" (BYVAL FileNum, BYVAL Segment, BYVAL Address, BYVAL NumBytes)

CONST NumEls% = 20000
REDIM Array&(1 TO NumEls%)
NumBytes& = LEN(Array&(1)) * CLNG(NumEls%)

FOR X = 1 TO NumEls%            'fill the array
  Array&(X) = X
NEXT

Segment = VARSEG(Array&(1))     'save the array
Address = VARPTR(Array&(1))
CALL BigSave("ARRAY.DAT", Segment, Address, NumBytes&)

REDIM Array&(1 TO NumEls%)      'clear the array

Segment = VARSEG(Array&(1))     'reload the array
Address = VARPTR(Array&(1))
CALL BigLoad("ARRAY.DAT", Segment, Address, NumBytes&)

FOR X = 1 TO NumEls%            'prove this all worked
  IF Array&(X) <> X THEN
    PRINT "Error in element"; X
  END IF
NEXT

SUB BigLoad (FileName$, DataSeg, Address, Bytes&) STATIC
 
  FileNum = FREEFILE
  OPEN FileName$ FOR BINARY AS #FileNum
  NumBytes& = Bytes&            'work with copies to
  Segment = DataSeg             'protect the parameters

  DO
    IF NumBytes& > 16384 THEN
      CurrentBytes = 16384
    ELSE
      CurrentBytes = NumBytes&
    END IF
    CALL BCGet(FileNum, Segment, Address, CurrentBytes)
    NumBytes& = NumBytes& - CurrentBytes
    Segment = Segment + &H400
  LOOP WHILE NumBytes&

  CLOSE #FileNum
  
END SUB

SUB BigSave (FileName$, DataSeg, Address, Bytes&) STATIC

  FileNum = FREEFILE
  OPEN FileName$ FOR BINARY AS #FileNum
  NumBytes& = Bytes&            'work with copies to
  Segment = DataSeg             'protect the parameters

  DO
    IF NumBytes& > 16384 THEN
      CurrentBytes = 16384
    ELSE
      CurrentBytes = NumBytes&
    END IF
    CALL BCPut(FileNum, Segment, Address, CurrentBytes)
    NumBytes& = NumBytes& - CurrentBytes
    Segment = Segment + 1024
  LOOP WHILE NumBytes&

  CLOSE #FileNum

END SUB
