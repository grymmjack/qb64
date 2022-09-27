'$INCLUDE:'../../../QB64_GJ_LIB/_GJ_LIB.BI'
SCREEN _NEWIMAGE(1024, 768, 256)
DIM gif~%%(511)
OPEN "ASSETS/test.gif" FOR BINARY AS #1
GET #1, , gif~%%()
CLOSE #1
PRINT dump_unsigned_byte_array_as_ascii(gif~%%(), "DATA")
' PRINT dump_unsigned_byte_array_as_hex(gif~%%(), "DATA")
'$INCLUDE:'../../../QB64_GJ_LIB/_GJ_LIB.BM'
