Dim a1(100) As Integer
Dim a2(100) As Integer

' initialize the first array
For i = 1 To 100
    a1(i) = i
Next i

' do the copy
Dim m As _MEM
m = _Mem(a1())
_MemGet m, m.OFFSET, a2()
_MemFree m

' show the results of the copy
For i = 1 To 100
    Print a2(i); " ";
Next i