 
'=============
'SpaceOrbs4.bas
'=============
'Screesaver of Orbs pulsating in space
'Coded by Dav for QB64-PE, AUGUST/2023
 
'v4 - Interactions: Change cloud size with Mouse Left Click
'                  Change cloud color with Mouse Right Click
'                  SPACE breaks up outer space (and resets everything)
 
Randomize Timer
 
Screen _NewImage(1000, 640, 32)
 
 
'=== orb settings
 
orbs = 60 'number of orbs on screen
OrbSizeMin = 5 'smallest size an orb can get
OrbSizeMax = 60 'largest size an orb can get
 
Dim OrbX(orbs), OrbY(orbs), OrbSize(orbs), OrbGrowth(orbs), OrbDir(orbs)
 
 
'=== generate some random orb values
 
For i = 1 To orbs
    OrbX(i) = Rnd * _Width 'x pos
    OrbY(i) = Rnd * _Height 'y pos
    OrbSize(i) = OrbSizeMin + (Rnd * (OrbSizeMax - OrbSizeMin)) 'orb size
    OrbGrowth(i) = Int(Rnd * 2) 'way orb is changing, 0=shrinking, 1=growing
    OrbDir(i) = Int(Rnd * 4) 'random direction orb can drift (4 different ways)
Next
 
 
'=== make a space background image
 
For i = 1 To 100000
    PSet (Rnd * _Width, Rnd * _Height), _RGBA(0, 0, Rnd * 255, Rnd * 225)
Next
For i = 1 To 1000
    x = Rnd * _Width: y = Rnd * _Height
    Line (x, y)-(x + Rnd * 3, y + Rnd * 3), _RGBA(192, 192, 255, Rnd * 175), BF
Next
 
 
'=== grab screen image for repeated use
 
back& = _CopyImage(_Display)
BackX = 0
 
'======
restart:
'======
 
curtainrod = 1.1
curtaincolor = 1
portal = 0
 
Do
 
    '=== scroll starry background first
 
    _PutImage (BackX, 0)-(BackX + _Width, _Height), back&
    _PutImage (BackX - _Width, 0)-(BackX, _Height), back&
    BackX = BackX + 4: If BackX >= _Width Then BackX = 0
 
    '=== do the space portal
 
    If Int(Rnd * 80) = 1 Then portal = 1 'randomly turn portal on
 
    If portal = 1 Then
        v = Rnd * 50 + 10
        For t = 1 To (_Width / 2)
            x1 = (Cos(t) * z) + (_Width / 2)
            y1 = (Sin(t) * z) + (_Height / 2)
            Line (x1, y1)-(x1 + (z / v), y1 + (z / v)), _RGBA(r, g, b, 25 + Rnd * 50), BF
            Circle (x1, y1), z / 30, _RGBA(r, g, b, 25 + Rnd * 50)
            If Int(Rnd * 2) = 0 Then z = z - 2 Else z = z + 2
            If z > (_Width / 2) Or z < -(_Width / 2) Then z = 1
            r = r + 1: If r > 255 Then r = Rnd * 255
            g = g + 1: If g > 255 Then g = Rnd * 255
            b = b + 1: If b > 255 Then b = Rnd * 255
        Next
        If Int(Rnd * 50) = 1 Then portal = 0 'randomly turn portal off
    End If
 
 
    '=== draw moving plasma curtain next
 
    While _MouseInput: Wend
    If _MouseButton(1) Then curtainrod = (Rnd * 5) + 1
    If _MouseButton(2) Then curtaincolor = Int(Rnd * 3) + 1
 
    t = Timer
 
    For x = 0 To _Width Step 3
        For y = 0 To _Height Step 3
            b = Sin(x / (_Width / 2) + t + y / (_Height / 2))
            b = b * (Sin(curtainrod * t) * (_Height / 2) - y + (_Height / 2))
            b = b * curtaincolor
            Line (x, y)-Step(2, 2), _RGBA(b / 3, 0, b / curtaincolor, 50), BF
        Next: t = t + .085 / curtainrod
    Next
 
 
    '=== now process all the orbs
 
    For i = 1 To orbs
 
        '=== draw orb on screen
        For y2 = OrbY(i) - OrbSize(i) To OrbY(i) + OrbSize(i) Step 3
            For x2 = OrbX(i) - OrbSize(i) To OrbX(i) + OrbSize(i) Step 3
                'make gradient plasma color
                If Sqr((x2 - OrbX(i)) ^ 2 + (y2 - OrbY(i)) ^ 2) <= OrbSize(i) Then
                    clr = (OrbSize(i) - (Sqr((x2 - OrbX(i)) * (x2 - OrbX(i)) + (y2 - OrbY(i)) * (y2 - OrbY(i))))) / OrbSize(i)
                    r = (Sin(x2 / (OrbSize(i) / 4)) + Sin(y2 / OrbSize(i) / 2)) * 128 + 128
                    g = (Sin(x2 / (OrbSize(i) / 6)) + Cos(y2 / (OrbSize(i) / 4))) * 128 + 128
                    b = (Cos(x2 / (OrbSize(i) / 4)) + Sin(y2 / (OrbSize(i) / 6))) * 128 + 128
                    Line (x2, y2)-Step(2, 2), _RGBA(clr * r, clr * g, clr * b, 20 + Rnd * 25), BF
                End If
            Next
        Next
 
        '=== change orb values
 
        'if orb is shrinking, subtract from size, else add to it
        If OrbGrowth(i) = 0 Then OrbSize(i) = OrbSize(i) - 1 Else OrbSize(i) = OrbSize(i) + 1
        'if orb reaches maximum size, switch growth value to 0 to start shrinking now
        If OrbSize(i) >= OrbSizeMax Then OrbGrowth(i) = 0
        'if orb reaches minimum size, switch growth value to 1 to start growing now
        'and reset x/y pos
        If OrbSize(i) <= OrbSizeMin Then
            OrbGrowth(i) = 1
            OrbX(i) = Rnd * _Width
            OrbY(i) = Rnd * _Height
        End If
        'creates the shakiness. randomly adjust x/y positions by +/-3 each
        If Int(Rnd * 2) = 0 Then OrbX(i) = OrbX(i) + 3 Else OrbX(i) = OrbX(i) - 3
        If Int(Rnd * 2) = 0 Then OrbY(i) = OrbY(i) + 3 Else OrbY(i) = OrbY(i) - 3
 
        'drift orb in  1 of 4 directions we generated, and +x,-x,+y,-y to it.
        If OrbDir(i) = 0 Then OrbX(i) = OrbX(i) + 2 'drift right
        If OrbDir(i) = 1 Then OrbX(i) = OrbX(i) - 2 'drift left
        If OrbDir(i) = 2 Then OrbY(i) = OrbY(i) + 2 'drift down
        If OrbDir(i) = 3 Then OrbY(i) = OrbY(i) - 2 'drift up
 
        'below handles if ball goes off screen, let it dissapear completely
        If OrbX(i) > _Width + OrbSize(i) Then OrbX(i) = -OrbSize(i)
        If OrbX(i) < -OrbSize(i) Then OrbX(i) = _Width + OrbSize(i)
        If OrbY(i) > _Height + OrbSize(i) Then OrbY(i) = -OrbSize(i)
        If OrbY(i) < -OrbSize(i) Then OrbY(i) = _Height + OrbSize(i)
 
    Next
 
    '== screen blur trick to make it more misty looking
 
    tmpback& = _CopyImage(_Display)
    _SetAlpha 50, , tmpback&
    _PutImage (-1, 0), tmpback&: _PutImage (1, 0), tmpback&
    _PutImage (0, -1), tmpback&: _PutImage (0, 1), tmpback&
    _PutImage (-1, -1), tmpback&: _PutImage (1, -1), tmpback&
    _FreeImage tmpback&
 
    _Display
 
    _Limit 15
 
    If InKey$ = Chr$(32) Then
        'make black image to use
        snap& = _NewImage(_Width, _Height, 32)
        _Dest snap&: Cls: _Dest 0
        BreakSpace snap&
        _FreeImage snap&
        _KeyClear
        GoTo restart
    End If
 
Loop Until _KeyHit = 27
 
End
 
 
Sub BreakSpace (image1&)
 
    tempback& = _CopyImage(_Display)
 
    _Display
 
    row = 10: col = 10
    xsize = _Width / row: ysize = _Height / col
    Dim piece&(row * col), piecex(row * col), piecey(row * col)
    Dim rotatespeed(row * col)
    Dim xwobble(row * col), xwobblespeed(row * col)
 
    bc = 1
    For c = 1 To col
        For r = 1 To row
 
            'int x/y values for each piece
            x1 = (r * xsize) - xsize: x2 = x1 + xsize
            y1 = (c * ysize) - ysize: y2 = y1 + ysize
            piecex(bc) = x1: piecey(bc) = y1
 
            'make pieces images from tempback& screen
            piece&(bc) = _NewImage(Abs(x2 - x1) + 1, Abs(y2 - y1) + 1, 32)
            _PutImage (0, 0), tempback&, piece&(bc), (x1, y1)-(x2, y2)
 
            'int random values for each piece
            rotatespeed(bc) = Rnd * .5
 
            xwobble(bc) = Int(Rnd * 3) + 1 'x move piece (1=none,2=left,3=right)
            xwobblespeed(bc) = Int(Rnd * 2) + 1 'how fast to wobble it
 
            bc = bc + 1
 
        Next
    Next
 
 
    wob = 0
    scale = 1
    alp = 255
 
    Do
 
        _PutImage (0, 0), image1& 'background image
 
        'show 1st image breaking up
        For t = 1 To row * col
            tx = piecex(t): tx2 = piecex(t) + xsize
            ty = piecey(t): ty2 = piecey(t) + ysize
            Select Case xwobble(t)
                Case 1
                    RotoZoom3 piecex(t) + (xsize / 2), piecey(t) + (ysize / 2), piece&(t), scale, scale, (ang * (rotatespeed(t) / 6))
                Case 2
                    RotoZoom3 piecex(t) + (xsize / 2) - wob, piecey(t) + (ysize / 2), piece&(t), scale, scale, (ang * (rotatespeed(t) / 6))
                    wob = wob - xwobblespeed(t)
                Case 3
                    RotoZoom3 piecex(t) + (xsize / 2) + wob, piecey(t) + (ysize / 2), piece&(t), scale, scale, (ang * (rotatespeed(t) / 6))
                    wob = wob + xwobblespeed(t)
            End Select
 
            ang = ang + .1
 
            _Limit 1500
 
            alp = alp - .03
            If alp > 0 Then _SetAlpha alp, , piece&(t)
 
        Next
 
        If scale > 0 Then scale = scale + .03
 
        _Display
 
 
    Loop Until alp <= 0
 
    'make sure image is shown full
    _PutImage (0, 0), image1&: _Display
 
    'release pieces from memory
    For p = 1 To row * col
        _FreeImage piece&(p)
    Next
 
    _FreeImage tempback&
 
End Sub
 
Sub RotoZoom3 (X As Long, Y As Long, Image As Long, xScale As Single, yScale As Single, radianRotation As Single)
    ' This assumes you have set your drawing location with _DEST or default to screen.
    ' X, Y - is where you want to put the middle of the image
    ' Image - is the handle assigned with _LOADIMAGE
    ' xScale, yScale - are shrinkage < 1 or magnification > 1 on the given axis, 1 just uses image size.
    ' These are multipliers so .5 will create image .5 size on given axis and 2 for twice image size.
    ' radianRotation is the Angle in Radian units to rotate the image
    ' note: Radian units for rotation because it matches angle units of other Basic Trig functions
    '      and saves a little time converting from degree.
    '      Use the _D2R() function if you prefer to work in degree units for angles.
 
    Dim px(3) As Single: Dim py(3) As Single ' simple arrays for x, y to hold the 4 corners of image
    Dim W&, H&, sinr!, cosr!, i&, x2&, y2& '  variables for image manipulation
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = -W& / 2: py(0) = -H& / 2 'left top corner
    px(1) = -W& / 2: py(1) = H& / 2 ' left bottom corner
    px(2) = W& / 2: py(2) = H& / 2 '  right bottom
    px(3) = W& / 2: py(3) = -H& / 2 ' right top
    sinr! = Sin(-radianRotation): cosr! = Cos(-radianRotation) ' rotation helpers
    For i& = 0 To 3 ' calc new point locations with rotation and zoom
        x2& = xScale * (px(i&) * cosr! + sinr! * py(i&)) + X: y2& = yScale * (py(i&) * cosr! - px(i&) * sinr!) + Y
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle _Seamless(0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle _Seamless(0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
End Sub