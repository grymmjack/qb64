'*********** EMS.BAS - demonstrates the EMS memory services

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE FUNCTION Compare% (BYVAL Seg1, BYVAL Adr1, BYVAL Seg2, BYVAL Adr2, NumBytes)
DECLARE FUNCTION EMSErrMessage$ (ErrNumber)
DECLARE FUNCTION EMSError% ()
DECLARE FUNCTION EMSFree& ()
DECLARE FUNCTION EMSThere% ()
DECLARE FUNCTION PeekWord% (BYVAL Segment, BYVAL Address)

DECLARE SUB EMSInt (EMSRegs AS ANY)
DECLARE SUB EMSStore (Segment, Address, ElSize, NumEls, Handle)
DECLARE SUB EMSRetrieve (Segment, Address, ElSize, NumEls, Handle)
DECLARE SUB MemCopy (BYVAL FromSeg, BYVAL FromAdr, BYVAL ToSeg, BYVAL ToAdr, NumBytes)

TYPE EMSType                    'similar to DOS Registers
  AX AS INTEGER
  BX AS INTEGER
  CX AS INTEGER
  DX AS INTEGER
END TYPE

DIM SHARED EMSRegs AS EMSType   'so all the subs can get at them
DIM SHARED ErrCode
DIM SHARED PageFrame


CLS
IF NOT EMSThere% THEN           'ensure that EMS is present
  PRINT "No EMS is installed"
  END
END IF

PRINT "This computer has"; EMSFree&;
PRINT "kilobytes of EMS available"

PRINT "Initializing array ";
REDIM Array#(1 TO 20000)
FOR X = 1 TO 20000
  Array#(X) = X
  IF X MOD 1000 = 0 THEN PRINT ".";
NEXT
PRINT

PRINT "Storing the array in EMS"
CALL EMSStore(VARSEG(Array#(1)), VARPTR(Array#(1)), 8, 20000, Handle)
IF EMSError% THEN
  PRINT EMSErrMessage$(EMSError%)
  END
END IF

PRINT "Retrieving the array from EMS"
REDIM Array#(1 TO 20000)
CALL EMSRetrieve(VARSEG(Array#(1)), VARPTR(Array#(1)), 8, 20000, Handle)
IF EMSError% THEN
  PRINT EMSErrMessage$(EMSError%)
  END
END IF

PRINT "Testing the data ";
FOR X = 1 TO 20000
  IF Array#(X) <> X THEN PRINT "ERROR! ";
  IF X MOD 1000 = 0 THEN PRINT ".";
NEXT

FUNCTION EMSErrMessage$ (ErrNumber) STATIC
 
  SELECT CASE ErrNumber
    CASE 128
      EMSErrMessage$ = "Internal error"
    CASE 129
      EMSErrMessage$ = "Hardware malfunction"
    CASE 131
      EMSErrMessage$ = "Invalid handle"
    CASE 133
      EMSErrMessage$ = "No handles available"
    CASE 135, 136
      EMSErrMessage$ = "No pages available"
    CASE ELSE
      IF PageFrame THEN
        EMSErrMessage$ = "Undefined error: " + STR$(ErrNumber)
      ELSE
        EMSErrMessage$ = "EMS not loaded"
      END IF
  END SELECT

END FUNCTION

FUNCTION EMSError% STATIC
 
  Temp& = ErrCode
  IF Temp& < 0 THEN Temp& = Temp& + 65536
  EMSError% = Temp& \ 256

END FUNCTION

FUNCTION EMSFree& STATIC

  EMSFree& = 0                  'assume failure
  IF PageFrame = 0 THEN EXIT FUNCTION

  EMSRegs.AX = &H4200
  CALL EMSInt(EMSRegs)
  ErrCode = EMSRegs.AX          'save possible error from AH

  IF ErrCode = 0 THEN EMSFree& = EMSRegs.BX * 16

END FUNCTION

SUB EMSRetrieve (Segment, Address, ElSize, NumEls, Handle) STATIC

  IF PageFrame = 0 THEN EXIT SUB

  LocalSeg& = Segment           'work with copies we can change
  LocalAdr& = Address

  BytesNeeded& = NumEls * CLNG(ElSize)
  PagesNeeded = BytesNeeded& \ 16384
  Remainder = BytesNeeded& MOD 16384
  IF Remainder THEN PagesNeeded = PagesNeeded + 1

  NumBytes = 16384              'assume we're copying a complete page
  ThisPage = 0                  'start copying to page 0

  FOR X = 1 TO PagesNeeded      'copy the data
    IF X = PagesNeeded THEN     'watch out for the last page
      IF Remainder THEN NumBytes = Remainder
    END IF
  
    IF LocalAdr& > 32767 THEN   'watch out for segment boundaries
      LocalAdr& = LocalAdr& - &H8000&
      LocalSeg& = LocalSeg& + &H800
      IF LocalSeg& > 32767 THEN LocalSeg& = LocalSeg& - 65536
    END IF

    EMSRegs.AX = &H4400         'map physical page 0 to the
    EMSRegs.BX = ThisPage       '  current logical page
    EMSRegs.DX = Handle         '  for the given handle
    CALL EMSInt(EMSRegs)        'then copy the data there
    ErrCode = EMSRegs.AX        'save possible error from AH
    IF ErrCode THEN EXIT SUB
    CALL MemCopy(PageFrame, Zero, CINT(LocalSeg&), CINT(LocalAdr&), NumBytes)

    ThisPage = ThisPage + 1
    LocalAdr& = LocalAdr& + NumBytes
  NEXT

  EMSRegs.AX = &H4500           'release memory service
  EMSRegs.DX = Handle
  CALL EMSInt(EMSRegs)
  ErrCode = EMSRegs.AX          'save possible error

END SUB

SUB EMSStore (Segment, Address, ElSize, NumEls, Handle) STATIC

  IF PageFrame = 0 THEN EXIT SUB

  LocalSeg& = Segment           'work with copies we can change
  LocalAdr& = Address

  BytesNeeded& = NumEls * CLNG(ElSize)
  PagesNeeded = BytesNeeded& \ 16384
  Remainder = BytesNeeded& MOD 16384
  IF Remainder THEN PagesNeeded = PagesNeeded + 1

  EMSRegs.AX = &H4300           'allocate memory service
  EMSRegs.BX = PagesNeeded
  CALL EMSInt(EMSRegs)
 
  ErrCode = EMSRegs.AX          'save possible error from AH
  IF ErrCode THEN EXIT SUB
  Handle = EMSRegs.DX           'save the handle returned

  NumBytes = 16384              'assume we're copying a complete page
  ThisPage = 0                  'start copying to page 0

  FOR X = 1 TO PagesNeeded      'copy the data
    IF X = PagesNeeded THEN     'watch out for the last page
      IF Remainder THEN NumBytes = Remainder
    END IF
   
    IF LocalAdr& > 32767 THEN   'watch out for segment boundaries
      LocalAdr& = LocalAdr& - &H8000&
      LocalSeg& = LocalSeg& + &H800
      IF LocalSeg& > 32767 THEN LocalSeg& = LocalSeg& - 65536
    END IF

    EMSRegs.AX = &H4400         'map physical page 0 to the
    EMSRegs.BX = ThisPage       '  current logical page
    EMSRegs.DX = Handle         '  for the given handle
    CALL EMSInt(EMSRegs)        'then copy the data there
    ErrCode = EMSRegs.AX        'save possible error from AH
    IF ErrCode THEN EXIT SUB
    CALL MemCopy(CINT(LocalSeg&), CINT(LocalAdr&), PageFrame, Zero, NumBytes)

    ThisPage = ThisPage + 1
    LocalAdr& = LocalAdr& + NumBytes
  NEXT

END SUB

FUNCTION EMSThere% STATIC

  EMSThere% = 0                 'assume the worst
  DIM DevName AS STRING * 8
  DevName = "EMMXXXX0"          'search for this below

  '---- Try to find the string "EMMXXXX0" at offset 10 in the EMS handler.
  '     If it's not there then EMS cannot possibly be installed.
  Int67Seg = PeekWord%(0, (&H67 * 4) + 2)
  IF NOT Compare%(Int67Seg, 10, VARSEG(DevName$), VARPTR(DevName$), 8) THEN
    EXIT FUNCTION
  END IF

  EMSRegs.AX = &H4100           'get Page Frame Segment service
  CALL EMSInt(EMSRegs)
  ErrCode = EMSRegs.AX          'save possible error from AH
 
  IF ErrCode = 0 THEN
    EMSThere% = -1
    PageFrame = EMSRegs.BX
  END IF

END FUNCTION

