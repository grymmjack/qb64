'checkerboard
Screen _NewImage(800, 600, 32)
PRINT MKL$(12345678)
SLEEP

s = 20 'size of squares (pixels)
cols = 20 'number of columns (X)
rows = 10 'number of rows (Y)

whitesquare& = _NewImage(101, 101, 32)
bluesquare& = _NewImage(101, 101, 32)

Dim c As Long

'create white square
Cls
c = _RGB(255, 255, 255)
Line (1, 1)-(101, 101), c, BF
_PutImage (1, 1)-(101, 101), 0, whitesquare&, (1, 1)-(101, 101)

'create blue square
Cls
c = _RGB(150, 150, 255)
Line (1, 1)-(101, 101), c, BF
_PutImage (1, 1)-(101, 101), 0, bluesquare&, (1, 1)-(101, 101)

'create checker pattern
Cls
For y = 1 To rows
    If y / 2 = Int(y / 2) Then
        For x = 1 To (cols - 1) Step 2
            _PutImage (x * s - s, y * s - s)-Step(s, s), whitesquare&, 0
            sleep
        Next x
        For x = 2 To cols Step 2
            _PutImage (x * s - s, y * s - s)-Step(s, s), bluesquare&, 0
            sleep
        Next x
    Else
        For x = 1 To (cols - 1) Step 2
            _PutImage (x * s - s, y * s - s)-Step(s, s), bluesquare&, 0
            sleep
        Next x
        For x = 2 To cols Step 2
            _PutImage (x * s - s, y * s - s)-Step(s, s), whitesquare&, 0
            sleep
        Next x
    End If
Next y

End