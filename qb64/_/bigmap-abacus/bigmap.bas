'Example by: Abacus 2022

Dim KeyPress As String
Dim x As _Float
Dim y As _Float

x = -1
y = -1

ystop1 = -1
ystop2 = -478

xstop1 = -1
xstop2 = -638



_AllowFullScreen Off
_Title "Big Map Example by: Abacus"
i& = _LoadImage("bigmap_icon.png", 32) '<<<<<<< use your image file name here

If i& < -1 Then
    _Icon i&
    _FreeImage i& ' release image handle after setting icon
End If


'Make Screen Size
Screen _NewImage(640, 480, 32)

'handle ImageFile&. Image file handles are always of type LONG.
ImageFile& = _LoadImage("bigmap.png")


Do
    _Display
    _Limit 60
    Cls 1

    KeyPress = UCase$(InKey$)

    If _KeyDown(CVI(Chr$(0) + "H")) And y < ystop1 Then
        y = y + 1.5
    ElseIf _KeyDown(CVI(Chr$(0) + "P")) And y > ystop2 Then
        y = y - 1.5

    ElseIf _KeyDown(CVI(Chr$(0) + "K")) And x < xstop1 Then
        x = x + 1.5
    ElseIf _KeyDown(CVI(Chr$(0) + "M")) And x > xstop2 Then
        x = x - 1.5
    End If

    'Placing the image on screen is just as easy as loading it.
    _PutImage (x, y), ImageFile&

    _PrintMode _KeepBackground

    Print "X = " x
    Print "Y = " y

    'used to stop flickering
    
Loop Until KeyPress$ = Chr$(27)
Cls
_FreeImage ImageFile&
_KeyClear
System