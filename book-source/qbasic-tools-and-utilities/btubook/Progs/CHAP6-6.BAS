'*********** CHAP6-6.BAS - shows how to interpret BSAVE file headers

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

TYPE BHeader
  Header  AS STRING * 1
  Segment AS INTEGER
  Address AS INTEGER
  Length  AS INTEGER
END TYPE
DIM BLHeader AS BHeader

OPEN "ARRAY.DAT" FOR BINARY AS #1
  GET #1, , BLHeader
CLOSE

IF ASC(BLHeader.Header) <> &HFD THEN
  PRINT "Not a valid BSAVE file"
  END
END IF

LongLength& = BLHeader.Length
IF LongLength& < 0 THEN
  LongLength& = LongLength& + 65536
END IF

NumElements = LongLength& \ 2
REDIM Array(1 TO NumElements)

DEF SEG = VARSEG(Array(1))
BLOAD "ARRAY.DAT", VARPTR(Array(1))
