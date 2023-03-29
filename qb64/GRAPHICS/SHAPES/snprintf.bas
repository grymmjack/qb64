' Declare Library
'     Function snprintf& (str As String, Byval length As _Offset, format As String, Byval var1 As Long, Byval var2 As Long)
' End Declare

' Dim s As String

' s = Space$(254)

' ignore& = snprintf(s, 254, "width: %d, height: %d" + Chr$(0), 20, 50)

' Print s



DECLARE LIBRARY
    FUNCTION snprintf& (str AS STRING, BYVAL LENGTH AS _OFFSET, FORMAT AS STRING, BYVAL VAR1 AS LONG, BYVAL VAR2 AS LONG, BYVAL VAR3 AS LONG)
END DECLARE

DIM s AS STRING : s$ = SPACE$(254)
DIM z AS LONG

z& = snprintf(s$, 254, "WIDTH: %d   HEIGHT: %d" + CHR$(0), 300, 200, 0)

PRINT s$