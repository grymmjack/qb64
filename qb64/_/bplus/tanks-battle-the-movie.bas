_Title "Tanks Battle - The Movie" 'from  bplus 2018-02-03"
'from: Tanks Battle.sdlbas (B+=MGA) 2016-10-29
' let the projectiles fly!
' 2022-05-? fix color const for Sky
' 2022-05-09 Make a Movie / Screen Saver
Randomize Timer

'tank stuff
Const tN = 15 'number of tanks
Const tNm1 = tN - 1 ' for loops and arrays
Const tW = 20 'width of tank
Const tH = 8 'height of tank
Type tank
    x As Single
    y As Single
    da As Single
    v As Single 'velocity
    c As _Integer64 'color
    bx As Single 'barrel
    by As Single
    f As _Byte 'finished
End Type

'hole stuff
Const hR = tW + 3
Const topHole = 1000
Type hole
    x As Integer
    y As Integer
End Type

'projectile stuff
Const rightA = -10
Const leftA = -170
Const lVel = 7
Const hVel = 22
Const SkyC = &HFF848888~& ' try this for Rho
Const pC = &HFFFFFF00~&
Const gravity = .35

Dim Shared SW, SH
SW = _DesktopWidth
SH = _DesktopHeight

Screen _NewImage(SW, SH, 32)
_FullScreen

Dim Shared rad ' yeah don't need these with _D2R and _R2D but this was 4 years ago
rad = _Pi / 180

restart:
ReDim Shared tanks(tNm1) As tank, holes(topHole) As hole

'get holes set up
holeIndex = -1

land& = _NewImage(SW, SH, 32)
_Dest land&
drawLandscape
_Dest 0

initializeTanks
hotTank = tNm1

change = 1
While change 'get tanks landed before start shooting
    change = 0
    Cls
    _PutImage , land&, 0 'land the tanks and reland the tanks if the dirt is shot out under them
    For i = 0 To tNm1
        If Point(tanks(i).x + tW / 2, tanks(i).y + tH + 1) = SkyC Then
            tanks(i).y = tanks(i).y + 2
            change = 1
        End If
        drawTank i
    Next
    _Display
Wend

While _KeyDown(27) = 0 '< main loop start
    Cls
    _PutImage , land&, 0

    'the land with holes
    If holeIndex > -1 Then
        For ii = 0 To holeIndex
            drawHole holes(ii).x, holes(ii).y
        Next
    End If

    'reland the tanks if the dirt is shot out under them
    For i = 0 To tNm1
        If tanks(i).f = 0 Then
            While Point(tanks(i).x + tW / 2, tanks(i).y + tH + 1) = SkyC
                tanks(i).y = tanks(i).y + 2
            Wend

            'repoint barrels and reset velocitys
            If Rnd < .5 Then 'avoid straight up and down  suicide shots
                tanks(i).da = rand(leftA, -92)
            Else
                tanks(i).da = rand(rightA, -88)
            End If
            tanks(i).v = rand(lVel, hVel) 'velocity
            drawTank i
        End If
    Next
    _Display
    _Delay .1


    ''whose turn to shoot
    lastMan = hotTank
    hotTank = hotTank + 1
    hotTank = hotTank Mod tN
    While tanks(hotTank).f = 1 'look for a tank still alive
        hotTank = hotTank + 1 'whose turn to shoot
        hotTank = hotTank Mod tN
        'did we cycle through all the dead tanks?
        If hotTank = lastMan Then 'game over, last man standing
            _Display
            _Delay 5
            GoTo restart
        End If
    Wend

    'setup hotTank's shot
    rAngle = tanks(hotTank).da * rad 'convert here to radians for SIN and COS
    pX = tanks(hotTank).bx
    pY = tanks(hotTank).by
    pX_change = tanks(hotTank).v * Cos(rAngle) 'this is the cuurent  X vector of the projectile
    pY_change = tanks(hotTank).v * Sin(rAngle) ' this is the current Y vector of the projectile
    pActive = 0 ' do not Activate until projectile sees the skyC

    While 1
        pY_change = pY_change + gravity ' pY starts in upward direction but will eventually fall due to gravity
        pX = pX + pX_change
        pY = pY + pY_change

        'show projectile progress, hit or air
        If pX >= 0 And pX <= SW And pY <= SH Then ' still active
            'check for tank hit
            For iTank = 0 To tNm1
                If tanks(iTank).f <> 1 And pActive Then 'tanks can blow up themselves
                    If dist(pX, pY, tanks(iTank).x + tW / 2, tanks(iTank).y + tH / 2) < hR Then
                        tanks(iTank).f = 1
                        Color _RGB32(255, 0, 0)
                        For rr = 1 To hR
                            fcirc pX, pY, rr
                            _Display
                            _Delay .01
                            If rr Mod 2 Then
                                Color _RGB32(128, 255, 0)
                            Else
                                Color _RGB32(255, 0, 0)
                            End If
                        Next
                        If holeIndex < topHole Then
                            holeIndex = holeIndex + 1
                            holes(holeIndex).x = pX
                            holes(holeIndex).y = pY
                            drawHole pX, pY
                            _Display
                        End If
                        pX = SW + 10
                        pY = SH + 10
                        Exit While
                    End If
                End If
            Next

            If Point(pX, pY) = SkyC Then
                pActive = 1
                Color pC
                fcirc pX, pY, 2 ' <<<<<<<<<<<<<<<< to see round projectiles that could be replaced by image
            ElseIf pY < 0 Then
                'still hot but cant see
            ElseIf Point(pX, pY) <> SkyC And Point(pX, pY) <> pC And pActive Then 'hit ground?
                Color _RGB(255, 0, 0)
                For rr = 1 To hR
                    fcirc pX, pY, rr
                    _Display
                    _Delay .01
                    If rr Mod 2 Then
                        Color _RGB32(128, 255, 0)
                    Else
                        Color _RGB32(255, 0, 0)
                    End If
                Next
                If holeIndex < topHole Then
                    holeIndex = holeIndex + 1
                    holes(holeIndex).x = pX
                    holes(holeIndex).y = pY
                    drawHole pX, pY
                    _Display
                End If
                pX = SW + 10
                pY = SH + 10
                Exit While
            End If
        Else 'not active
            Exit While
        End If
        _Display
        _Delay .03
    Wend
Wend

Sub drawHole (xx, yy)
    Color SkyC
    For i = yy To 300 Step -1
        fcirc xx, i, hR
    Next
End Sub

Sub drawLandscape
    'the sky
    Line (0, 0)-(SW, SH), SkyC, BF

    'the land
    startH = SH - 100
    rr = 70: gg = 70: bb = 90
    For mountain = 1 To 6
        Xright = 0
        y = startH
        While Xright < SW
            ' upDown = local up / down over range, change along Y
            ' range = how far up / down, along X
            upDown = (Rnd * (.8) - .35) * (mountain * .5)
            range = Xright + rand%(15, 25) * 2.5 / mountain
            For x = Xright - 1 To range
                y = y + upDown
                Line (x, y)-(x + 1, SH), _RGB32(rr, gg, bb), BF
            Next
            Xright = range
        Wend
        rr = rand(rr - 15, rr): gg = rand(gg - 15, gg): bb = rand(bb - 25, bb)
        If rr < 0 Then rr = 0
        If gg < 0 Then gg = 0
        If bb < 0 Then bb = 0
        startH = startH + rand(5, 20)
    Next
End Sub

Sub initializeTanks ' x, y, barrel angle,  velocity, color
    tl = (SW - tW) / tN: tl2 = tl / 2: tl4 = .8 * tl2
    For i = 0 To tNm1
        tanks(i).x = rand%(tl2 + tl * i - tl4 - tW, tl2 + tl * i + tl4 - tW)
        tanks(i).y = 300 '<<<<<<<<<<<<<<<<<<<<<<<<<< for testing
        tanks(i).da = rand%(-180, 0) 'degree Angle
        tanks(i).v = rand%(10, 20) 'velocity
        If tanks(i).da < -90 Then 'barrel  is pointed left
            tanks(i).v = -1 * tanks(i).v
        End If
        tc = i * Int(200 / (3 * tN)) 'maximize color difference between tanks
        tanks(i).c = _RGB32(55 + 2 * tc, 13 + tc, 23 + tc) ' first tank is darkest
    Next
    'shuffle color order
    For i = tNm1 To 1 Step -1
        r = rand%(0, i)
        Swap tanks(i).x, tanks(r).x
    Next
End Sub

Sub drawTank (i)
    'ink(tanks(i, "c"))
    Color tanks(i).c
    'turret
    fEllipse tanks(i).x + tW / 2, tanks(i).y + tH / 3, tW / 4 + 1, tH / 4 + 1
    bX = tW / 2 * Cos(rad * tanks(i).da)
    bY = tW / 2 * Sin(rad * tanks(i).da)
    Line (tanks(i).x + tW / 2, tanks(i).y + tH / 3)-(tanks(i).x + tW / 2 + bX, tanks(i).y + tH / 4 + bY)
    Line (tanks(i).x + tW / 2 + 1, tanks(i).y + tH / 3 + 1)-(tanks(i).x + tW / 2 + bX + 1, tanks(i).y + tH / 4 + bY + 1)
    tanks(i).bx = tanks(i).x + tW / 2 + bX
    tanks(i).by = tanks(i).y + tH / 4 + bY
    fEllipse tanks(i).x + tW / 2, tanks(i).y + .75 * tH, tW / 2, tH / 4
    Color _RGB32(0, 0, 0)
    ellipse tanks(i).x + tW / 2, tanks(i).y + .75 * tH, tW / 2 + 1, tH / 4 + 1
    ellipse tanks(i).x + tW / 2 + 1, tanks(i).y + .75 * tH, tW / 2 + 1, tH / 4 + 1
End Sub

Function rand% (lo%, hi%)
    rand% = (Rnd * (hi% - lo% + 1)) \ 1 + lo%
End Function

Function rdir% ()
    If Rnd < .5 Then rdir% = -1 Else rdir% = 1
End Function

Function dist# (x1%, y1%, x2%, y2%)
    dist# = ((x1% - x2%) ^ 2 + (y1% - y2%) ^ 2) ^ .5
End Function

'Steve McNeil's  copied from his forum   note: Radius is too common a name
Sub fcirc (CX As Long, CY As Long, R As Long)
    Dim subRadius As Long, RadiusError As Long
    Dim X As Long, Y As Long

    subRadius = Abs(R)
    RadiusError = -subRadius
    X = subRadius
    Y = 0

    If subRadius = 0 Then PSet (CX, CY): Exit Sub

    ' Draw the middle span here so we don't draw it twice in the main loop,
    ' which would be a problem with blending turned on.
    Line (CX - X, CY)-(CX + X, CY), , BF

    While X > Y
        RadiusError = RadiusError + Y * 2 + 1
        If RadiusError >= 0 Then
            If X <> Y + 1 Then
                Line (CX - Y, CY - X)-(CX + Y, CY - X), , BF
                Line (CX - Y, CY + X)-(CX + Y, CY + X), , BF
            End If
            X = X - 1
            RadiusError = RadiusError - X * 2
        End If
        Y = Y + 1
        Line (CX - X, CY - Y)-(CX + X, CY - Y), , BF
        Line (CX - X, CY + Y)-(CX + X, CY + Y), , BF
    Wend
End Sub

Sub fEllipse (CX As Long, CY As Long, xRadius As Long, yRadius As Long)
    Dim scale As Single, x As Long, y As Long
    scale = yRadius / xRadius
    Line (CX, CY - yRadius)-(CX, CY + yRadius), , BF
    For x = 1 To xRadius
        y = scale * Sqr(xRadius * xRadius - x * x)
        Line (CX + x, CY - y)-(CX + x, CY + y), , BF
        Line (CX - x, CY - y)-(CX - x, CY + y), , BF
    Next
End Sub

Sub ellipse (CX As Long, CY As Long, xRadius As Long, yRadius As Long)
    Dim scale As Single, xs As Long, x As Long, y As Long
    Dim lastx As Long, lasty As Long
    scale = yRadius / xRadius: xs = xRadius * xRadius
    PSet (CX, CY - yRadius): PSet (CX, CY + yRadius)
    lastx = 0: lasty = yRadius
    For x = 1 To xRadius
        y = scale * Sqr(xs - x * x)
        Line (CX + lastx, CY - lasty)-(CX + x, CY - y)
        Line (CX + lastx, CY + lasty)-(CX + x, CY + y)
        Line (CX - lastx, CY - lasty)-(CX - x, CY - y)
        Line (CX - lastx, CY + lasty)-(CX - x, CY + y)
        lastx = x: lasty = y
    Next
End Sub