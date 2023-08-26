Dim As Long CircleScreen, LineScreen
$Color:32

Screen _NewImage(640, 480, 32)
_DisplayOrder _Software , _Hardware
CircleScreen = _NewImage(640, 480, 32)
_Dest CircleScreen
For i = 1 To 100
    kolor&& = _RGB32(Rnd * 255, Rnd * 255, Rnd * 255)
    r = Rnd * 100 + 50
    x = Rnd * _Width
    y = Rnd * _Height
    For j = 1 To r
        Circle (x, y), j, kolor&&
    Next
Next
_Dest 0

LineScreen = _NewImage(640, 480, 32)
_Dest LineScreen
For i = 1 To 100
    Line (Rnd * _Width, Rnd * _Height)-(Rnd * _Width, Rnd * _Height), _RGB32(Rnd * 255, Rnd * 255, Rnd * 255), BF
Next
_Dest 0

Do
    Cls , DarkBlue
    Pause
    Rotate 2, Red
    Pause
    Squares 2, Silver
    Pause
    Squares 2, LineScreen
    Pause
    Circles 2, Gold
    Pause
    Circles 2, CircleScreen
    Pause
    FadeTo 2, LineScreen
    Pause
    FadeTo 2, SkyBlue
    Pause
    FadeTo 2, CircleScreen
    Pause
    Transition 4, LineScreen, 1
    Pause
    Transition 0.1, CircleScreen, 2
    Pause
    Transition 2, Pink, 3
    Pause
    Transition 2, Blue, 4
    Pause
Loop

Sub Pause
    If _KeyHit Then System Else _Delay 2: If _KeyHit Then System
End Sub


Sub Rotate (overtime As _Float, toWhat As _Integer64)
    D = _Dest: S = _Source
    A = _AutoDisplay
    tempscreen = _CopyImage(_Display)
    whichScreen = _CopyImage(_Display)
    If toWhat >= 0 Then 'it's a color
        _Dest whichScreen
        Cls , toWhat
        _Dest D
    Else
        _PutImage , toWhat, whichScreen
    End If

    scale! = 1
    Do
        scale! = scale! - .01
        angle! = angle! + 3.6
        Cls , 0
        DisplayImage tempscreen, _Width / 2, _Height / 2, scale!, scale!, angle!, 0
        _Limit 100## / overtime
        _Display
    Loop Until scale! <= 0
    scale! = 0: angle! = 0
    Do
        scale! = scale! + .01
        angle! = angle! - 3.6
        Cls , 0
        DisplayImage whichScreen, _Width / 2, _Height / 2, scale!, scale!, angle!, 0
        _Limit 100## / overtime
        _Display
    Loop Until scale! >= 1
    _Dest D: _Source S
    If A Then _AutoDisplay
    _PutImage , whichScreen, _Display
    _FreeImage whichScreen
End Sub




Sub Squares (overTime As _Float, toWhat As _Integer64)
    Static P(100) As Long
    If P(0) = 0 And P(1) = 0 Then 'initialize our static array on the first run
        For i = 0 To 100: P(i) = i: Next
    End If
    D = _Dest: S = _Source
    A = _AutoDisplay
    whichScreen = _CopyImage(_Display)
    If toWhat >= 0 Then 'it's a color
        _Dest whichScreen
        Cls , toWhat
        _Dest D
    Else
        _PutImage , toWhat, whichScreen
    End If

    For i = 0 To 100: Swap P(i), P(Rnd * 100): Next 'shuffle our restore order
    w = _Width / 10
    h = _Height / 10
    For i = 0 To 100
        x = P(i) \ 10
        y = P(i) Mod 10
        _PutImage (x * w, y * h)-Step(w, h), whichScreen, _Display, (x * w, y * h)-Step(w, h)
        _Limit 100## / overTime
        _Display
    Next

    _Dest D: _Source S
    If A Then _AutoDisplay
    _PutImage , whichScreen, _Display
    _FreeImage whichScreen
End Sub





Sub Circles (overTime As _Float, toWhat As _Integer64)
    Dim As _MEM M, M2, M3
    Dim As _Offset count
    Dim As _Unsigned Long KolorPoint
    D = _Dest: S = _Source
    A = _AutoDisplay: B = _Blend
    tempScreen = _CopyImage(_Display)
    whichScreen = _CopyImage(_Display)
    tempCircleScreen = _CopyImage(_Display)
    If toWhat >= 0 Then 'it's a color
        _Dest whichScreen
        Cls , toWhat
        _Dest D
    Else
        _PutImage , toWhat, whichScreen
    End If
    M = _MemImage(tempCircleScreen)
    M2 = _MemImage(whichScreen)
    M3 = _MemImage(_Display)

    _Dest tempCircleScreen: _Source tempCircleScreen
    _DontBlend
    For i = 1 To 1000
        _PutImage , tempScreen, _Display
        CircleFill Rnd * _Width, Rnd * _Height, _Width / 20, &H12345678&&
        count = 0
        $Checking:Off
        Do
            _MemGet M, M.OFFSET + count, KolorPoint
            If KolorPoint = &H12345678&& Then
                _MemGet M2, M2.OFFSET + count, KolorPoint
                _MemPut M3, M3.OFFSET + count, KolorPoint
            End If
            count = count + 4
        Loop Until count >= M.SIZE
        _Limit 1000## / overTime
        $Checking:On
        _Display
    Next

    _Dest D: _Source S
    If A Then _AutoDisplay
    If B Then _Blend
    _PutImage , whichScreen, _Display
    _FreeImage tempScreen: _FreeImage whichScreen: _FreeImage tempCircleScreen
End Sub


Sub FadeTo (overTime As _Float, toWhat As _Integer64)
    D = _Dest: S = _Source
    A = _AutoDisplay

    For i = 0 To 255
        tempScreen = _CopyImage(_Display)
        _Dest tempScreen
        If toWhat >= 0 Then
            r = _Red32(toWhat)
            g = _Green32(toWhat)
            b = _Blue32(toWhat)
            alpha = _Alpha32(toWhat) / 255 * i
            Cls , _RGBA32(r, g, b, alpha)
        Else
            _PutImage (0, 0)-(_Width, _Height), toWhat, tempScreen
            _SetAlpha i
        End If
        tempHardwareScreen = _CopyImage(tempScreen, 33)
        _PutImage , tempHardwareScreen
        _Display
        _Limit 255## / overTime
        _FreeImage tempHardwareScreen
        _FreeImage tempScreen
    Next
    _Dest D: _Source S
    If toWhat > 0 Then
        Line (0, 0)-(_Width, _Height), toWhat, BF
    Else
        _PutImage , toWhat, _Display
    End If
    If A Then _AutoDisplay
End Sub

Sub Transition (overTime As _Float, toWhat As _Integer64, Direction As Long)
    'Direction is: 1 = Left, 2 = Right, 3 = Up, 4 = Down
    If Direction < 1 Or Direction > 4 Then Exit Sub
    D = _Dest: S = _Source
    A = _AutoDisplay
    tempScreen = _CopyImage(_Display)
    whichScreen = _CopyImage(_Display)
    If toWhat >= 0 Then 'it's a color
        _Dest whichScreen
        Cls , toWhat
        _Dest D
    Else
        _PutImage , toWhat, whichScreen
    End If
    Select Case Direction
        Case 1
            For x = _Width To 0 Step -1
                Cls , 0
                _PutImage (0, 0)-(x, _Height), tempScreen, _Display, (_Width - x, 0)-(_Width, _Height)
                _PutImage (x, 0)-(_Width, _Height), whichScreen, _Display, (0, 0)-(_Width - x, _Height)
                _Limit _Width / overTime
                _Display
            Next
        Case 2
            For x = 0 To _Width
                Cls , 0
                _PutImage (x, 0)-(_Width, _Height), tempScreen, _Display, (0, 0)-(_Width - x, _Height)
                _PutImage (0, 0)-(x, _Height), whichScreen, _Display, (_Width - x, 0)-(_Width, _Height)
                _Limit _Width / overTime
                _Display
            Next
        Case 3
            For y = _Height To 0 Step -1
                Cls , 0
                _PutImage (0, y)-(_Width, _Height), whichScreen, _Display, (0, 0)-(_Width, _Height - y)
                _PutImage (0, 0)-(_Width, y), tempScreen, _Display, (0, _Height - y)-(_Width, _Height)
                _Limit _Height / overTime
                _Display
            Next
        Case 4
            For y = 0 To _Height
                Cls , 0
                _PutImage (0, y)-(_Width, _Height), tempScreen, _Display, (0, 0)-(_Width, _Height - y)
                _PutImage (0, 0)-(_Width, y), whichScreen, _Display, (0, _Height - y)-(_Width, _Height)
                _Limit _Height / overTime
                _Display
            Next

    End Select
    _Dest D: _Source S
    If A Then _AutoDisplay
    _FreeImage tempScreen
    _FreeImage whichScreen
End Sub



Sub CircleFill (CX As Long, CY As Long, R As Long, C As Long)
    Dim Radius As Long, RadiusError As Long
    Dim X As Long, Y As Long

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


Sub DisplayImage (Image As Long, x As Integer, y As Integer, xscale As Single, yscale As Single, angle As Single, mode As _Byte)
    'Image is the image handle which we use to reference our image.
    'x,y is the X/Y coordinates where we want the image to be at on the screen.
    'angle is the angle which we wish to rotate the image.
    'mode determines HOW we place the image at point X,Y.
    'Mode 0 we center the image at point X,Y
    'Mode 1 we place the Top Left corner of oour image at point X,Y
    'Mode 2 is Bottom Left
    'Mode 3 is Top Right
    'Mode 4 is Bottom Right


    Dim px(3) As Integer, py(3) As Integer, w As Integer, h As Integer
    Dim sinr As Single, cosr As Single, i As _Byte
    w = _Width(Image): h = _Height(Image)
    Select Case mode
        Case 0 'center
            px(0) = -w \ 2: py(0) = -h \ 2: px(3) = w \ 2: py(3) = -h \ 2
            px(1) = -w \ 2: py(1) = h \ 2: px(2) = w \ 2: py(2) = h \ 2
        Case 1 'top left
            px(0) = 0: py(0) = 0: px(3) = w: py(3) = 0
            px(1) = 0: py(1) = h: px(2) = w: py(2) = h
        Case 2 'bottom left
            px(0) = 0: py(0) = -h: px(3) = w: py(3) = -h
            px(1) = 0: py(1) = 0: px(2) = w: py(2) = 0
        Case 3 'top right
            px(0) = -w: py(0) = 0: px(3) = 0: py(3) = 0
            px(1) = -w: py(1) = h: px(2) = 0: py(2) = h
        Case 4 'bottom right
            px(0) = -w: py(0) = -h: px(3) = 0: py(3) = -h
            px(1) = -w: py(1) = 0: px(2) = 0: py(2) = 0
    End Select
    sinr = Sin(angle / 57.2957795131): cosr = Cos(angle / 57.2957795131)
    For i = 0 To 3
        x2 = xscale * (px(i) * cosr + sinr * py(i)) + x: y2 = yscale * (py(i) * cosr - px(i) * sinr) + y
        px(i) = x2: py(i) = y2
    Next
    _MapTriangle (0, 0)-(0, h - 1)-(w - 1, h - 1), Image To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle (0, 0)-(w - 1, 0)-(w - 1, h - 1), Image To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
End Sub