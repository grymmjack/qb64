 
'Mouse Tank by SierraKen
'January 21, 2025
 
'Thank you to the QB64 Phoenix Forum, including B+ for the help over the years.
 
_Title "Mouse Tank - by SierraKen"
 
Screen _NewImage(800, 600, 32)
 
Randomize Timer
 
num = 40
 
Dim oldx(100), oldy(100)
Dim d1(100), d2(100), s(100), d(100), t(100)
Dim x(100), y(100), xx(100), yy(100), si(100), red(100), green(100), blue(100)
Dim nox(100), llx(100), lly(100)
 
start:
 
level = 1
score = 0
health = 50
healthp = 100
mw = -90
Cls
_AutoDisplay
 
Locate 3, 25: Print "M O U S E  T A N K"
Locate 5, 25: Print "By SierraKen"
Locate 10, 25: Print "Move your tank around with your mouse."
Locate 11, 25: Print "Turn your cannon turret with your mouse wheel."
Locate 12, 25: Print "Press Space Bar or left mouse button to fire at monsters."
Locate 13, 25: Print "To pause and un-pause, press Esc."
Locate 14, 25: Print "Press Q anytime to quit."
Locate 18, 25: Print "Center Mouse on screen and click left mouse Button to begin."
Do
    If _MouseInput Then mi = 1
Loop Until mi = 1 And _MouseButton(1)
 
start2:
Cls
 
_Title "Score: " + Str$(score) + "    Health: " + Str$(healthp) + "%    Level: " + Str$(level)
 
oldx = 400
oldy = 300
 
hits = 0
 
bx = 1
bx2 = 1
 
r1 = 4
r2 = 30
r3 = 25
loops = 0
For size = 1 To num
    si(size) = (Rnd * 10) + 10
Next size
 
For colors = 1 To num
    red(colors) = Int(Rnd * 100) + 155
    green(colors) = Int(Rnd * 100) + 155
    blue(colors) = Int(Rnd * 100) + 155
Next colors
 
Do
    _Limit 400
    For n = 1 To num
        If nox(n) = 1 Then GoTo skip:
        If d1(n) > d2(n) Then s(n) = s(n) + .1
        If d2(n) > d1(n) Then s(n) = s(n) - .1
        d(n) = d(n) + 1
        If d(n) > t(n) Then
            oldx(n) = oldx(n) + x(n)
            oldy(n) = oldy(n) + y(n)
            bugchange d1(n), d2(n), d(n), t(n)
        End If
        x(n) = Cos(s(n) * _Pi / 180) * d(n)
        y(n) = Sin(s(n) * _Pi / 180) * d(n)
        xx(n) = x(n) + oldx(n)
        yy(n) = y(n) + oldy(n)
        If xx(n) > 750 Then oldx(n) = 50: Cls: bugchange d1(n), d2(n), d(n), t(n)
        If xx(n) < 50 Then oldx(n) = 750: Cls: bugchange d1(n), d2(n), d(n), t(n)
        If yy(n) > 550 Then oldy(n) = 50: Cls: bugchange d1(n), d2(n), d(n), t(n)
        If yy(n) < 50 Then oldy(n) = 550: Cls: bugchange d1(n), d2(n), d(n), t(n)
        fillCircle xx(n), yy(n), si(n), _RGB32(red(n), green(n), blue(n))
        fillCircle xx(n) - (si(n) * .3), yy(n) - (si(n) * .3), si(n) * .2, _RGB32(255, 0, 0)
        fillCircle xx(n) + (si(n) * .3), yy(n) - (si(n) * .3), si(n) * .2, _RGB32(255, 0, 0)
        fillCircle xx(n), yy(n), 3, _RGB32(255, 0, 0)
        For sz = .1 To si(n) * .4 Step .1
            Circle (xx(n), yy(n) + (si(n) * .4)), sz, _RGB32(255, 0, 0), , , .35
        Next sz
        skip:
 
        b$ = InKey$
        If b$ = " " Then
            laser = 1
            lx = mx
            ly = my + 25
        End If
 
        If b$ = Chr$(27) Then
            Do: c$ = InKey$:
            Loop Until c$ = Chr$(27)
        End If
 
        If b$ = "q" Or b$ = "Q" Then End
 
        If _MouseInput Then
            mx = _MouseX
            my = _MouseY
            If _MouseButton(1) Then
                laser = 1
                lx = mx
                ly = my + 25
            End If
            If _MouseWheel Then
                mw = mw + _MouseWheel * 5
            End If
        End If
 
        If laser = 1 Then
            lx2 = Cos(mw * _Pi / 180)
            ly2 = Sin(mw * _Pi / 180)
            lx = lx2 / 2 + lx
            ly = ly2 / 2 + ly
            fillCircle lx, ly, r1, _RGB32(255, 0, 5)
            For chk = 1 To num
 
                distance = Sqr((lx - xx(chk)) ^ 2 + (ly - yy(chk)) ^ 2)
                If distance <= r1 + r2 Then
                    DetectCollision = -1 ' True (collision detected)
                Else
                    DetectCollision = 0 ' False (no collision)
                End If
 
                If DetectCollision And nox(chk) <> 1 Then
                    For explosion = 1 To 100
                        Circle (lx, ly), explosion, _RGB32(255, 0, 0)
                        llx(explosion) = lx
                        lly(explosion) = ly
                    Next explosion
                    Sound 75, .1 '
                    oldx(chk) = -100: nox(chk) = 1
                    score = score + 10
                    _Title "Score: " + Str$(score) + "    Health: " + Str$(healthp) + "%    Level: " + Str$(level)
                    hits = hits + 1
                    laser = 0
                    ly = -3
                    GoTo skip2:
                End If
            Next chk
        End If
 
        skip2:
        If ly < -2 Then
            laser = 0
            ly = 0
        End If
        If hits > num - 1 Then
            Cls
            ly = 0
            laser = 0
            For nn = 1 To num
                nox(nn) = 0
            Next nn
            level = level + 1
            num = num + 2
            If num > 75 Then num = 75
            GoTo start2
        End If
 
        'Draw your tank.
        For mxx = -25 To 25 Step .25
            Line (mx, my - 5)-(mx - mxx, my + 25), _RGB32(127, 255, 127)
        Next mxx
        For mxx2 = 1 To 25 Step .25
            Line (mx, my - 5)-(mx + mxx2, my + 25), _RGB32(127, 255, 127)
        Next mxx2
 
        For mxx = -25 To 25 Step .25
            Line (mx, my + 50)-(mx + mxx, my + 25), _RGB32(127, 255, 127)
        Next mxx
        For mxx2 = 1 To 25 Step .25
            Line (mx, my + 50)-(mx - mxx2, my + 25), _RGB32(127, 255, 127)
        Next mxx2
        fillCircle mx, my + 25, 15, _RGB32(0, 0, 255)
        fillCircle mx, my + 25, 7, _RGB32(127, 255, 127)
 
        'Draw your tank turret cannon.
        s1 = 90 - mw
        x = Int(Sin(s1 / 180 * _Pi) * 30) + mx
        y = Int(Cos(s1 / 180 * _Pi) * 30) + my
        Line (mx, my + 25)-(x, y + 25), _RGB32(255, 0, 0)
        If loops < 1000 Then GoTo skip3
        'Detect collision with monsters.
        For chk = 1 To num
 
            distance = Sqr((mx - xx(chk)) ^ 2 + (my - yy(chk)) ^ 2)
            If distance <= r3 + r2 Then
                DetectCollision = -1 ' True (collision detected)
            Else
                DetectCollision = 0 ' False (no collision)
            End If
            If DetectCollision And nox(chk) <> 1 Then
                health = health - .005
                healthp = Int((health / 50) * 100)
                _Title "Score: " + Str$(score) + "    Health: " + Str$(healthp) + "%    Level: " + Str$(level)
                If health < .01 Then
                    For explosion = 1 To 200
                        Circle (mx, my + 25), explosion, _RGB32(255, 0, 0)
                    Next explosion
                    For snd = 100 To 150 Step 5
                        Sound snd, .1
                    Next snd
                    Locate 20, 30: Print "G A M E    O V E R"
                    Locate 25, 30: Input "Again (Y/N)"; ag$
                    If Left$(ag$, 1) = "y" Or Left$(ag$, 1) = "Y" Then GoTo start
                    End
                End If
            End If
        Next chk
        skip3:
 
        If loops < 1000 Then
            loops = loops + 1
        End If
 
    Next n
    _Display
    Cls
Loop
 
 
Sub bugchange (d1, d2, d, t)
    d1 = Rnd * 360
    d2 = Rnd * 360
    d = 0
    t = Int(Rnd * 360) + 1
End Sub
 
 
 
'from Steve Gold standard
Sub fillCircle (CX As Integer, CY As Integer, R As Integer, C As _Unsigned Long)
    Dim Radius As Integer, RadiusError As Integer
    Dim X As Integer, Y As Integer
    Radius = Abs(R): RadiusError = -Radius: X = Radius: Y = 0
    If Radius = 0 Then PSet (CX, CY), C: Exit Sub
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
 