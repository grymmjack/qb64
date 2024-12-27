 
'Snowflakes - My best so far!
'By SierraKen
'December 12, 2024
 
Screen _NewImage(800, 600, 32)
 
_Title "Snowflakes by SierraKen - Space Bar For Random Background. Mouse Wheel to change speed."
 
nSnow = 100
 
Dim y(nSnow), speed(nSnow), x(nSnow), s(nSnow)
 
Dim xx(nSnow)
Dim yy(nSnow)
Dim oldxx(nSnow)
Dim oldyy(nSnow)
Dim tt(nSnow)
Dim dir(nSnow)
Dim size(nSnow)
Dim height(10)
 
Randomize Timer
 
 
For i = 1 To nSnow
    x(i) = Rnd * 800 + 1
    y(i) = 0
    speed(i) = (Rnd * 4) + 1
    s(i) = Rnd * 5
    If s(i) < 1 Then s(i) = 1
    If s(i) > 5 Then s(i) = 1
 
    xx(i) = Rnd * 800 + 1
    yy(i) = 0
    tt(i) = -360
    dir(i) = 1
    size(i) = Int(Rnd * 20) + 5
Next
 
more:
For h = 1 To 10
    height(h) = Rnd * 100
Next h
Do
    Do While _MouseInput
        sp = sp + (_MouseWheel / 2)
        If sp < -4 Then sp = -4
        If sp > 60 Then sp = 60
        If _MouseWheel Then tim = Timer
    Loop
    _Limit 100
    Paint (2, 2), _RGB32(0, 0, 155)
 
    tim2 = Timer
    If tim2 < tim + 3 Then
        Locate 1, 1: Print sp
    End If
 
    Line (0, 500)-(800, 600), _RGB32(255, 255, 255), BF
    hc = 0
    For hills = 1 To 1000 Step 100
        hh = hh + 1
        For sz = .25 To 125 Step .25
            hc = hc + .25
            Circle (hills, height(hh) + 350), sz, _RGB32(100, 155 - hc, 150), 2 * _Pi, _Pi, 2
        Next sz
        hc = 0
    Next hills
    hh = 0
    For hills = 1 To 800 Step 150
        For sz = .25 To 125 Step .25
            hc = hc + .25
            Circle (hills, 400), sz, _RGB32(100, 255 - hc, 150), 2 * _Pi, _Pi, .5
        Next sz
        hc = 0
    Next hills
    For hills = 1 To 800 Step 150
        For sz = .25 To 125 Step .25
            hc = hc + .25
            Circle (hills, 500), sz, _RGB32(0, 255 - hc, 0), 2 * _Pi, _Pi
        Next sz
        hc = 0
    Next hills
 
    For i = 1 To nSnow
        y(i) = y(i) + speed(i) + sp
        For sze = .25 To s(i) Step .25
            Circle (x(i), y(i)), sze, _RGB32(255, 255, 255)
        Next
    Next
 
    For bb = 1 To nSnow
        If tt(bb) > 0 Then
            tt(bb) = tt(bb) + .2
        End If
        If tt(bb) < 0 Or tt(bb) = 0 Then
            tt(bb) = tt(bb) - .2
        End If
        If tt(bb) > 360 Then
            tt(bb) = 0
        End If
        If tt(bb) < -360 Then
            tt(bb) = 0
        End If
 
        For t = 0 To 360
            xx(bb) = Sin(t) * size(bb) + x(bb)
            yy(bb) = Cos(t) * size(bb) + y(bb)
            If t = 0 Then
                oldxx(bb) = xx(bb)
                oldyy(bb) = yy(bb)
            End If
            If t / 4 = Int(t / 4) Then
                Line (xx(bb), yy(bb))-(oldxx(bb), oldyy(bb)), _RGB32(255, 255, 255)
                oldxx(bb) = xx(bb)
                oldyy(bb) = yy(bb)
            End If
 
        Next t
    Next bb
    _Display
    Cls
    For i = 1 To nSnow
        ' is x or y off screen?
        If x(i) > _Width Or x(i) < 0 Then s(i) = Rnd * 5 + 1: y(i) = 0: x(i) = Rnd * 800 + 1: speed(i) = (Rnd * 5 + 1.5)
        If y(i) > _Height Or y(i) < 0 Then s(i) = Rnd * 5 + 1: y(i) = 0: x(i) = Rnd * 800 + 1: speed(i) = (Rnd * 5 + 1.5) + sp
        If xx(i) > _Width Or xx(i) < 0 Then s(i) = Rnd * 5 + 1: yy(i) = 0: xx(i) = Rnd * 800 + 1: speed(i) = (Rnd * 5 + 1.5)
        If yy(i) > _Height Or yy(i) < 0 Then s(i) = Rnd * 5 + 1: yy(i) = 0: xx(i) = Rnd * 800 + 1: speed(i) = Rnd * 5 + 1.5
        size(i) = Int(Rnd * 10) + 5
        xx(i) = Rnd * 800 + 1
        yy(i) = 0
        tt(i) = -360
        dir(i) = 1
    Next
    a$ = InKey$
    If a$ = " " Then GoTo more:
    If a$ = Chr$(27) Then End
Loop