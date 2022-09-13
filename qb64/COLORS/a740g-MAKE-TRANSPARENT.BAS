CANVAS& = _NEWIMAGE(800, 600, 32)
_DEST CANVAS&
CLS ,_RGB(255, 0, 255)
SCREEN CANVAS&

w = 512
h = 256
x = (800-w) \ 2
y = (600-h) \ 2

img& = _LOADIMAGE("STARFIGHTER-RGB32.png", 32)
' _CLEARCOLOR &HFF757575, img&
MakeBitmapTransparent img&, &HFF757575
_PUTIMAGE (x,y), img&, CANVAS&

' Converts image with color key to image with alpha transparency
Sub MakeBitmapTransparent (nImage As Long, nColorKey As Unsigned Long)
    If _PixelSize(nImage) <> 4 Then Exit Sub ' This only works on 32bpp images

    Dim Buffer As _MEM
    Buffer = _MemImage(nImage) 'Get a memory reference to our image

    Dim As Offset O, O_Last
    O = Buffer.OFFSET 'We start at this offset
    O_Last = Buffer.OFFSET + _Width(nImage) * _Height(nImage) * 4 'We stop when we get to this offset

    Dim As Unsigned Byte ckRed, ckGreen, ckBlue, cRed, cGreen, cBlue
    ckRed = _Red(nColorKey)
    ckGreen = _Green(nColorKey)
    ckBlue = _Blue(nColorKey)

    Do
        cBlue = _MemGet(Buffer, O, Unsigned Byte)
        O = O + 1

        cGreen = _MemGet(Buffer, O, Unsigned Byte)
        O = O + 1

        cRed = _MemGet(Buffer, O, Unsigned Byte)
        O = O + 1

        If (ckRed = cRed And ckGreen = cGreen And ckBlue = cBlue) Then
            MemPut Buffer, O, 0 As UNSIGNED BYTE
        End If
        O = O + 1
    Loop Until O = O_Last
    MemFree Buffer
End Sub