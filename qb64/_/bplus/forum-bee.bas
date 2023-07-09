_Title "All Eyes on the Bee"
' B+ 2019-03-06
' 2020-05-13 add smile
' 2023-07-09 multiply and avoid!

Const smile = 1 / 3 * _Pi
Screen _NewImage(1280, 720, 12)
_FullScreen
Dim Shared mx, my, maxDist
maxDist = _Hypot(_Width / 2, _Height / 2)
nFaces = 40
Dim Shared fx(1 To nFaces), fy(1 To nFaces), fdx(1 To nFaces), fdy(1 To nFaces)
Dim Shared fsz(1 To nFaces), fc(1 To nFaces)
For i = 1 To nFaces
    fx(i) = Rnd * _Width: fy(i) = Rnd * _Height
    fdx(i) = Rnd * 6 - 3: fdy(i) = Rnd * 6 - 3
    fsz(i) = Rnd * 60 + 20: fc(i) = Int(Rnd * 15)
Next

Color , 15
_MouseHide
While _KeyDown(27) = 0 'until esc keypress
    Cls
    For i = 1 To nFaces
        fx(i) = fx(i) + fdx(i)
        fy(i) = fy(i) + fdy(i)
        If fx(i) < 0 Then fx(i) = fx(i) + _Width
        If fx(i) > _Width Then fx(i) = fx(i) - _Width
        If fy(i) < 0 Then fy(i) = fy(i) + _Height
        If fy(i) > _Height Then fy(i) = fy(i) - _Height

        drawFace i
    Next
    While _MouseInput: Wend
    mx = _MouseX: my = _MouseY
    ' bee body
    For i = 1 To 8
        If i Mod 2 Then bc = 0 Else bc = 14
        FillCircle mx + i * 3, my + i * 3, 5, bc
    Next
    ' bee wings
    FillCircle mx - 15 + 20, my + 10, 8, 7
    FillCircle mx + 8 + 20, my + 5, 8, 7
    _Display 'prevent flicker
    _Limit 30 'save CPU fan
Wend

Sub drawFace (i)
    If _Hypot(fx(i) - mx, fy(i) - my) < 100 Then
        avoid = _Atan2(fy(i) - my, fx(i) - mx)
        speed = 103 - _Hypot(fx(i) - mx, fy(i) - my)
        fdx(i) = speed * Cos(avoid)
        fdy(i) = speed * Sin(avoid)
    End If

    angle = _Atan2(my - fy(i), mx - (fx(i) - .45 * fsz(i)))
    angle2 = _Atan2(my - fy(i), mx - (fx(i) + .45 * fsz(i)))
    FillCircle fx(i), fy(i), fsz(i), fc(i)

    FEllipse fx(i) - .45 * fsz(i), fy(i), .35 * fsz(i), .25 * fsz(i), 15
    FEllipse fx(i) + .45 * fsz(i), fy(i), .35 * fsz(i), .25 * fsz(i), 15
    x1 = fx(i) - .45 * fsz(i) + .125 * fsz(i) * Cos(angle)
    y1 = fy(i) + .10 * fsz(i) * Sin(angle)
    x2 = fx(i) + .45 * fsz(i) + .125 * fsz(i) * Cos(angle2)
    y2 = fy(i) + .10 * fsz(i) * Sin(angle2)
    FillCircle x1, y1, .17 * fsz(i), 9
    FillCircle x2, y2, .17 * fsz(i), 9
    FillCircle x1, y1, .09 * fsz(i), 0
    FillCircle x2, y2, .09 * fsz(i), 0

    mw = _Hypot(mx - fx(i), my - fy(i)) * 100 / _Hypot(_Width, _Height) + 2
    arc fx(i), fy(i), .73 * fsz(i), _Pi / 2 - smile * mw / 100, _Pi / 2 + smile * mw / 100, 15
End Sub

'fill circle
Sub FillCircle (CX As Integer, CY As Integer, R As Integer, C As _Unsigned Long)
    Dim Radius As Integer, RadiusError As Integer
    Dim X As Integer, Y As Integer

    Radius = Abs(R)
    RadiusError = -Radius
    X = Radius
    Y = 0

    If Radius = 0 Then PSet (CX, CY), C: Exit Sub

    ' Draw the middle span here so we don't draw it twice in the main loop,
    ' which would be a problem with blending turned on.
    Line (CX - X, CY)-(CX + X, CY), C, BF

    While X > Y
        RadiusError = RadiusError + Y * 2 + 1
        If RadiusError >= 0 Then
            If X <> Y + 1 Then
                Line (CX - Y, CY - X)-(CX + Y, CY - X), C, BF
                Line (CX - Y, CY + X)-(CX + Y, CY + X), C, BF
            End If
            X = X - 1
            RadiusError = RadiusError - X * 2
        End If
        Y = Y + 1
        Line (CX - X, CY - Y)-(CX + X, CY - Y), C, BF
        Line (CX - X, CY + Y)-(CX + X, CY + Y), C, BF
    Wend
End Sub

'use radians
Sub arc (x, y, r, raStart, raStop, c As _Unsigned Long)
    Dim al, a
    'x, y origin, r = radius, c = color

    'raStart is first angle clockwise from due East = 0 degrees
    ' arc will start drawing there and clockwise until raStop angle reached

    If raStop < raStart Then
        arc x, y, r, raStart, _Pi(2), c
        arc x, y, r, 0, raStop, c
    Else
        ' modified to easier way suggested by Steve
        'Why was the line method not good? I forgot.
        al = _Pi * r * r * (raStop - raStart) / _Pi(2)
        For a = raStart To raStop Step 1 / al
            Circle (x + r * Cos(a), y + r * Sin(a)), 1, c '<<< modify for smile
        Next
    End If
End Sub

Sub FEllipse (CX As Long, CY As Long, xr As Long, yr As Long, C As _Unsigned Long)
    If xr = 0 Or yr = 0 Then Exit Sub
    Dim h2 As _Integer64, w2 As _Integer64, h2w2 As _Integer64
    Dim x As Long, y As Long
    w2 = xr * xr: h2 = yr * yr: h2w2 = h2 * w2
    Line (CX - xr, CY)-(CX + xr, CY), C, BF
    Do While y < yr
        y = y + 1
        x = Sqr((h2w2 - y * y * w2) \ h2)
        Line (CX - x, CY + y)-(CX + x, CY + y), C, BF
        Line (CX - x, CY - y)-(CX + x, CY - y), C, BF
    Loop
End Sub