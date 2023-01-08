$Console:Only

Declare Library
    ' var1 is passed by reference, IE. a pointer
    Function scanf& (format As String, var1 As Long)
    Function printf& (format As String, Byval var1 As Long, Byval var2 As Long)
End Declare

Dim var As Long

Print "input integer: "

result& = scanf("HELLO %d" + Chr$(0), var)
ignore& = printf("return: %d, number: %d" + Chr$(10) + Chr$(0), result&, var)