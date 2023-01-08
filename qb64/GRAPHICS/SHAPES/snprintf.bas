Declare Library
    Function snprintf& (str As String, Byval length As _Offset, format As String, Byval var1 As Long, Byval var2 As Long)
End Declare

Dim s As String

s = Space$(254)

ignore& = snprintf(s, 254, "width: %d, height: %d" + Chr$(0), 20, 50)

Print s