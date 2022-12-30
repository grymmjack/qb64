Option _Explicit
$Console:Only

Declare Library ".\mappedvar"
    Function mapvar& (name As String, value As String)
    Function getmappedvalue$ (name As String)
    Sub freemappedvar (name As String)
    Sub freemap ()
    Function mapsize~&& ()
End Declare

Dim As Long a

a = mapvar("Test1", "This is a test")
Print mapsize

a = mapvar("Test2", "Another test")
Print mapsize

freemap

Print getmappedvalue("test1")

Print mapsize

a = mapvar("Test3", "A third test")
Print mapsize
Print getmappedvalue("Test3")
