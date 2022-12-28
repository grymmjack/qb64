_Title "Drawing with lines of variable thickness"
'by James D. Jarvis adapted using code by B+
' this uses RotoZoom2 to draw a line of any thickness.
'
'$dynamic
Randomize Timer
Const xmax = 800
Const ymax = 600
Screen _NewImage(xmax, ymax, 32)
_ScreenMove _Middle
Dim Shared w$(0) '<-  must be included for soem of the subds to work well
Dim Shared contX, conty '<- global values that keep track of where the last point was drawn with angline
px = 0: py = 0: t = 0
Do
    Cls
    _Limit 30
    dline 100, 100, 300, 300, _RGB32(100, 200, 200), 20
    dline 100, 300, 300, 300, _RGB32(100, 200, 200), 20
    rotopoly2 300, 300, 150, 90, 0, _RGB32(100, 200, 200), 6.5
    tripoly 300, 300, 50, 90, 0, _RGB32(200, 100, 100)
    rotopoly2 300, 300, 50, 90, 0, _RGB32(100, 200, 200), 1.5
    fillpoly 300, 100, 40, 72, 0, _RGB32(100, 100, 200), _RGB32(80, 0, 0), 1.5, "noise"
    fillpoly 400, 100, 40, 60, 0, _RGB32(180, 180, 0), _RGB32(180, 180, 0), 1.5, "af"
    fillpoly 500, 100, 40, 120, 0, _RGB32(100, 100, 200), _RGB32(250, 250, 0), 4, "VV"
    fillpoly 600, 100, 40, 90, 0, _RGB32(100, 100, 200), _RGB32(0, 180, 180), 6, "hh"
    px = px + 3: py = py + 2: t = t + 1
    If px > _Width Then px = 0
    If py > _Height Then py = 0
    If t > 360 Then t = 1
    fillpoly px, py, 20, 90, t, _RGB32(250, 250, 250), _RGB32(200, 200, 0), 4, "AH"
    _Display
    kk$ = InKey$
Loop Until kk$ = Chr$(27)
Cls

_AutoDisplay
t1 = Timer
For n = 1 To 60000
    dline Rnd * _Width, Rnd * _Height, Rnd * _Width, Rnd * _Height, _RGB32(Rnd * 256, Rnd * 256, Rnd * 256), Int(1 + Rnd * 20)
Next n
t2 = Timer
Print "that took "; t2 - t1; " seconds"
Input " ..."; any$
Cls
m$(1) = "cf": m$(2) = "af": m$(3) = "hh": m$(4) = "vv": m$(5) = "ah": m$(6) = "av"
t3 = Timer
For p = 1 To 20000
    fillpoly Rnd * _Width, Rnd * _Height, 4 + Rnd * 40, 360 / (2 + Int(Rnd * 20)), Rnd * 360, _RGB32(Rnd * 256, Rnd * 256, Rnd * 256), _RGB32(Rnd * 256, Rnd * 256, Rnd * 256), Int(1 + Rnd * 8), m$(1 + Rnd * 6)
Next p
t4 = Timer
Print "20000 random shapes in "; t4 - t3; " seconds"
Input "...", a$
Cls
fillpoly 400, 300, 100, 72, 0, _RGB32(100, 100, 100), _RGB32(200, 200, 0), 4, "V17"
dashedline 5, 5, 300, 5, _RGB32(200, 200, 0), 20, "d40,s12,c8,s12"
dashedline 300, 5, 450, 305, _RGB32(200, 200, 0), 60, "c25,s12,c15,s12"
dashedline 450, 305, 550, 105, _RGB32(200, 200, 0), 2, "d25,s3,d15,s3"
dashedline 10, 205, 300, 405, _RGB32(250, 200, 0), 20, "A42,A42,A45"
dashedline 300, 405, 300, 590, _RGB32(250, 200, 0), 20, "A42,A42,A45"
dashedline 10, 100, 100, 100, _RGB32(250, 0, 0), 16, "A42,A45,A42,A32"

drect 50, 100, 80, 30, 37, _RGB32(200, 100, 0), 4
fillrect 100, 150, 80, 30, -45, _RGB32(200, 100, 0), _RGB32(200, 200, 0), 4, "B", "Mf1f1f1f1f1f1f1f1fff1f1fff1fff1f1f1f1fff1fff1f1fff1fff1f1f1fff1f1"
fillrect 200, 150, 80, 130, 15, _RGB32(200, 100, 0), _RGB32(0, 200, 0), 4, "B", "M0101010101e1010101e100101010101e001e00001e01e000000001e01e001e00"
bline$ = "t2,r2,d6"
contX = 300: conty = 300
For n = 1 To 30
    _Limit 5
    bbgo = Int(2 + Rnd * 20)
    For b = 1 To bbgo
        bline$ = bline$ + "," + "r" + _Trim$(Str$(2 + Rnd * 90)) + ",d" + _Trim$(Str$(2 + Rnd * 10))
    Next b
    angline contX, conty, _RGB32(200, 50, 0), bline$
    bline$ = ""
    If conty > _Height Then
        contX = 300
        conty = 300
    End If
    _Display
Next n





'=============================================================================
Function Rtan2 (x1, y1, x2, y2)
    'get the angle (in radians) from x1,y1 to x2,y2
    deltaX = x2 - x1
    deltaY = y2 - y1
    rtn = _Atan2(deltaY, deltaX)
    If rtn < 0 Then Rtan2 = rtn + (2 * _Pi) Else Rtan2 = rtn
End Function

Sub fcirc (CX As Long, CY As Long, R As Long, C As _Unsigned Long)
    Dim Radius As Long, RadiusError As Long
    Dim X As Long, Y As Long
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

'====================================================================
' draw a line of color klr and thickness thk
'lines are centered on their coordinates
'====================================================================
Sub dline (x1, y1, x2, y2, klr As _Unsigned Long, thk)
    storeDest& = _Dest
    hyp = Sqr((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) 'detrmine the length of the line
    xx = Int(hyp + .5)
    II& = _NewImage(xx, thk * 2, 32)
    _Dest II&
    Line (0, _Height \ 2 - thk \ 2)-(_Width, _Height \ 2 - thk \ 2 + thk - 1), klr, BF 'draw the line in the temporary image buffer

    _Dest storeDest&
    centerx = (x1 + x2) / 2
    centery = (y1 + y2) / 2

    rotation = Rtan2(x1, y1, x2, y2) 'find the angle of the line in radians as rotozoom2 uses radians
    RotoZoom2fixed centerx, centery, II&, 1, 1, rotation 'copy the line to it's position on the screen using rotozoom2
    _FreeImage II&
End Sub

'This sub gives really nice control over displaying an Image.
Sub RotoZoom2 (centerX As Long, centerY As Long, Image As Long, xScale As Single, yScale As Single, Rotation As Single)
    Dim px(3) As Single: Dim py(3) As Single
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = -W& / 2: py(0) = -H& / 2: px(1) = -W& / 2: py(1) = H& / 2
    px(2) = W& / 2: py(2) = H& / 2: px(3) = W& / 2: py(3) = -H& / 2
    sinr! = Sin(-Rotation): cosr! = Cos(-Rotation)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) * xScale + centerX: y2& = (py(i&) * cosr! - px(i&) * sinr!) * yScale + centerY
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle (0, 0)-(0, H& - 1)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle (0, 0)-(W& - 1, 0)-(W& - 1, H& - 1), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
End Sub

'=================================
'rotozoom2 was stretching evrything a pixel so I canged it, currently only iusing it in dline
'=============================
Sub RotoZoom2fixed (centerX As Long, centerY As Long, Image As Long, xScale As Single, yScale As Single, Rotation As Single)
    Dim px(3) As Single: Dim py(3) As Single
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = -W& \ 2: py(0) = -H& \ 2: px(1) = -W& \ 2: py(1) = H& \ 2
    px(2) = W& \ 2: py(2) = H& \ 2: px(3) = W& \ 2: py(3) = -H& \ 2
    sinr! = Sin(-Rotation): cosr! = Cos(-Rotation)
    For i& = 0 To 3
        x2& = (px(i&) * cosr! + sinr! * py(i&)) * xScale + centerX: y2& = (py(i&) * cosr! - px(i&) * sinr!) * yScale + centerY
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle (0, 0)-(0, H& - 0)-(W& - 0, H& - 0), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle (0, 0)-(W& - 0, 0)-(W& - 0, H& - 0), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
End Sub

'====================================================================
' rotopoly2 draws a  polygon wit variable line thickness
'====================================================================
Sub rotopoly2 (cx, cy, rr, shapedeg, turn, klr As _Unsigned Long, thk)
    x = 0
    y = 0
    For deg = turn To turn + 360 Step shapedeg
        x2 = rr * Cos(0.01745329 * deg)
        y2 = rr * Sin(0.01745329 * deg)
        'If x <> 0 Then Line (cx + x, cy + y)-(cx + x2, cy + y2), klr
        If x <> 0 Then dline cx + x, cy + y, cx + x2, cy + y2, klr, thk
        x = x2
        y = y2
        fcirc (cx + x2), (cy + y2), thk \ 2, klr 'fills in the open gap at polygon line intersections
    Next
End Sub
'====================================================================
' triploy draw a filled polygon by rendereing multiple triangles of the same color
'====================================================================
Sub tripoly (cx, cy, rr, shapedeg, turn, klr As _Unsigned Long)
    storeDest& = _Dest
    I& = _NewImage(3, 3, 32)
    _Dest I&
    Line (0, 0)-(_Width, _Height), klr, BF
    x = 0
    y = 0
    _Dest storeDest&
    For deg = turn To turn + 360 Step shapedeg
        x2 = rr * Cos(0.01745329 * deg)
        y2 = rr * Sin(0.01745329 * deg)
        If x <> 0 Then _MapTriangle (0, 0)-(0, 2)-(2, 2), I& To(cx, cy)-(cx + x, cy + y)-(cx + x2, cy + y2)
        x = x2
        y = y2
    Next
    _FreeImage I&
End Sub

'====================================================================
'fillpoly creates filled polygons
'a temporary image is created and trignels for each segment of that tmeporary image are copied to the screen
'currently   7 modes are defined
'CF- color fill,  HH -  horizontal line fill, VV- vertical line fill
'AF - alternating segment color fill, AH & AV are alternationg horizonatl or vetical
'noise- creaes a fill of randomly colore points
'======================================================================
Sub fillpoly (cx, cy, rr, shapedeg, turn, klr1 As _Unsigned Long, klr2 As _Unsigned Long, thk, mode$)
    storeDest& = _Dest
    siz = (rr * Cos(0.01745329 * deg)) * 2
    sx = siz / 2: sy = siz / 2
    I& = _NewImage(siz, siz, 32)
    _Dest I&
    Select Case UCase$(mode$)
        Case "CF", "AF"
            Line (0, 0)-(siz, siz), klr2, BF
        Case "HH", "AH"
            For y = 0 To siz Step thk
                Line (0, y)-(siz, y - 1 + thk / 2), klr2, BF
            Next
        Case "VV", "AV"
            For x = 0 To siz Step thk
                Line (x, 0)-(x - 1 + thk / 2, siz), klr2, BF
            Next
        Case "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "H11", "H12", "H13", "H14", "H15", "H16", "H17", "H18", "H19", "H20"
            tt = Val(Right$(mode$, Len(mode$) - 1))
            For y = 0 To siz Step (tt * 2)
                Line (0, y)-(siz, y - 1 + tt), klr2, BF
            Next
        Case "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V11", "V12", "V13", "V14", "V15", "V16", "V17", "V18", "V19", "V20"
            tt = Val(Right$(mode$, Len(mode$) - 1))
            For x = 0 To siz Step (tt * 2)
                Line (x, 0)-(x - 1 + tt, siz), klr2, BF
            Next
        Case "NOISE"
            For y = 0 To siz
                For x = 0 To siz
                    PSet (x, y), _RGB32(Rnd * 256, Rnd * 256, Rnd * 256)
                Next x
            Next y
    End Select
    x = 0
    y = 0
    _Dest storeDest&
    sc = 0
    For deg = turn To turn + 360 Step shapedeg
        sc = sc + 1
        x2 = rr * Cos(0.01745329 * deg)
        y2 = rr * Sin(0.01745329 * deg)
        If x <> 0 Then
            Select Case UCase$(mode$)
                Case "AF", "AH", "AV"
                    If (sc Mod 2) <> 0 Then _MapTriangle (sx, sy)-(sx + x, sy + y)-(sx + x2, sy + y2), I& To(cx, cy)-(cx + x, cy + y)-(cx + x2, cy + y2)
                Case Else
                    _MapTriangle (sx, sy)-(sx + x, sy + y)-(sx + x2, sy + y2), I& To(cx, cy)-(cx + x, cy + y)-(cx + x2, cy + y2)
            End Select
        End If
        x = x2
        y = y2
    Next
    _FreeImage I&
    If klr1 <> 0 Then rotopoly2 cx, cy, rr, shapedeg, turn, klr1, thk
End Sub


'====================================================================
' draw a dashed line of color klr and thickness thk
' dashed lines are drawn by following simple comands in a comm sperated list
' d# for dash # pixels long s# for space # pixels long
'c# for a cricle of radius #.... note circles larger than line thichness will be cut off
'====================================================================
Sub dashedline (x1, y1, x2, y2, klr As _Unsigned Long, thk, dash$)
    storeDest& = _Dest
    hyp = Sqr((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) 'determine the length of the line
    yy = 1 * thk
    xx = Int(hyp + .9)
    II& = _NewImage(xx, Int(yy + .5), 32)
    _Dest II&
    dw = safewords(dash$, ",", w$())
    _Dest II&
    ll = 0
    s = 0
    Do
        For s = 1 To dw
            dd$ = _Trim$(Left$(w$(s), 1))
            Select Case dd$
                Case "D", "d"
                    sl = Val(_Trim$(Right$(w$(s), Len(w$(s)) - 1)))
                    Line (ll, 0)-(ll + sl, yy), klr, BF
                    ll = ll + sl
                Case "S", "s"
                    sl = Val(_Trim$(Right$(w$(s), Len(w$(s)) - 1)))
                    ll = ll + sl
                Case "C", "c"
                    sl = Val(_Trim$(Right$(w$(s), Len(w$(s)) - 1)))
                    cx = ll + sl
                    cy = yy / 2
                    fcirc cx, cy, sl, klr
                    ll = ll + (sl * 2)
                Case "A", "a"
                    Color klr
                    ch = Val(_Trim$(Right$(w$(s), Len(w$(s)) - 1)))
                    _PrintString (ll, yy / 2 - _FontHeight / 2), Chr$(ch)
                    ll = ll + _FontWidth
            End Select
        Next s
    Loop Until ll >= xx
    ' Line (0, 0)-(xx, yy), klr, BF 'draw the line in the temporary image buffer
    centerx = (x1 + x2) / 2
    centery = (y1 + y2) / 2
    _Dest storeDest&
    rotation = Rtan2(x1, y1, x2, y2) 'find the angle of the line in radians as rotozoom2 uses radians
    RotoZoom2 centerx, centery, II&, 1, 1, rotation 'copy the line to it's position on the screen using rotozoom2
    _FreeImage II&
End Sub

Function wordcount (txt$, sep$)
    'count the words in string txt$ using sep$ as the separator in the string
    ex = 0
    Do
        c = InStr(cc, txt$, sep$)
        If c Then
            wCount = wCount + 1
            cc = c + 1
        Else
            If tmpLng2 < (Len(txt$) + 1) Then wCount = wCount + 1
            ex = 1
        End If
    Loop Until ex = 1
    wordcount = wCount
End Function
Function safewords (txt$, sep$, w$())
    'same as gwords but it does not clean up punctuation
    wc = wordcount(txt$, sep$)
    If wc > 0 Then
        ReDim w$(wc)
        cc = 1
        parsedCount = 0
        Do
            c = InStr(cc, txt$, sep$)
            If c > 0 Then
                parsedCount = parsedCount + 1
                w$(parsedCount) = Mid$(txt$, cc, c - cc)
                cc = c + 1
            Else
                If cc < (Len(txt$) + 1) Then
                    parsedCount = parsedCount + 1
                    w$(parsedCount) = Mid$(txt$, cc)
                End If
                Exit Do
            End If
        Loop
    End If
    For w = 1 To wc
        w$(w) = _Trim$(w$(w))
    Next w
    safewords = wc
End Function

Sub drect (xa, ya, WW, HH, ang, klr As _Unsigned Long, thk)
    storeDest& = _Dest
    Ir& = _NewImage(WW + thk, HH + thk, 32)
    _Dest Ir&
    dline 0, thk / 2, WW + thk / 2, thk / 2, klr, thk
    dline 0, HH + thk / 2, WW + thk / 2, HH + thk / 2, klr, thk
    dline thk / 2, 0, thk / 2, HH + thk / 2, klr, thk
    dline WW + thk / 2, 0, WW + thk / 2, HH + thk / 2, klr, thk
    _Dest storeDest&
    RotoZoom2 xa + WW / 2, ya + HH / 2, Ir&, 1, 1, _D2R(ang)
    _FreeImage Ir&
End Sub



Sub fillrect (xa, ya, WW, HH, ang, klr1 As _Unsigned Long, klr2 As _Unsigned Long, thk, lmode$, fmode$)
    lm$ = UCase$(Left$(_Trim$(lmode$), 1))
    fm$ = UCase$(Left$(_Trim$(fmode$), 1))

    storeDest& = _Dest
    Ir& = _NewImage(WW + thk, HH + thk, 32)
    _Dest Ir&
    Select Case fm$
        Case "H"
            h$ = _Trim$(fmode$)
            hv = Val(Right$(h$, Len(h$) - 1))
            For y = thk / 2 To HH - thk / 2 Step (hv * 2)
                Line (thk / 2, y)-(thk / 2 + WW, y + hv), klr2, BF
            Next

        Case "V"
            v$ = _Trim$(fmode$)
            cv = Val(Right$(v$, Len(v$) - 1))
            For x = thk / 2 To WW - thk / 2 Step (cv * 2)
                Line (x, thk / 2)-(x + cv, thk / 2 + HH), klr2, BF
            Next
        Case "M"
            tile$ = _Trim$(fmode$)
            tile$ = Right$(tile$, Len(tile$) - 1)
            bb$ = bpad$(tile$)
            For y = thk / 2 To thk / 2 + HH Step 16
                For x = thk / 2 To thk / 2 + WW Step 16
                    monotile16 x, y, bb$, klr2
                Next
            Next

        Case Else
            Line (thk / 2, thk / 2)-(thk / 2 + WW, thk / 2 + HH), klr2, BF


    End Select
    Select Case lm$
        Case "B"
            dline 0, thk / 2, WW + thk / 2, thk / 2, klr1, thk
            dline 0, HH + thk / 2, WW + thk / 2, HH + thk / 2, klr1, thk
            dline thk / 2, 0, thk / 2, HH + thk / 2, klr1, thk
            dline WW + thk / 2, 0, WW + thk / 2, HH + thk / 2, klr1, thk
        Case "D"
            dash$ = _Trim$(lmode$)
            dash$ = Right$(dash$, Len(dash$) - 1)
            dashedline 0, thk / 2, WW + thk / 2, thk / 2, klr1, thk, dash$
            dashedline 0, HH + thk / 2, WW + thk / 2, HH + thk / 2, klr1, thk, dash$
            dashedline thk / 2, 0, thk / 2, HH + thk / 2, klr1, thk, dash$
            dashedline WW + thk / 2, 0, WW + thk / 2, HH + thk / 2, klr1, thk, dash$

    End Select
    _Dest storeDest&
    RotoZoom2 xa + WW / 2, ya + HH / 2, Ir&, 1, 1, _D2R(ang)
    _FreeImage Ir&
End Sub
'================================================
'    bpad$ returns a padded string of bits
'=================================================
Function bpad$ (tile$)
    bb$ = ""
    For r = 1 To Len(tile$)
        htile$ = Mid$(tile$, r, 1)
        b$ = _Bin$(Val("&H" + htile$))
        Select Case Len(b$)
            Case 1
                b$ = "000" + b$
            Case 2
                b$ = "00" + b$
            Case 3
                b$ = "0" + b$
        End Select
        bb$ = bb$ + b$
    Next r
    bpad$ = bb$
End Function
'=========================================================
'   renders a string of bits as a tile 16 bits wide
'========================================================
Sub monotile16 (xx, YY, bb$, klr As _Unsigned Long)
    'renders a string of bits as a tile 16 bits wide
    x = 0
    Y = 0
    For r = 1 To Len(bb$)

        If Mid$(bb$, r, 1) = "1" Then PSet (xx - 1 + x, YY - 1 + Y), klr
        x = x + 1
        If x = 16 Then
            Y = Y + 1
            x = 0
        End If

    Next r
End Sub
'====================================================
' angline  draw a line with multiple angle and spacing changes
' similar to dashedline
'N = set angle         R= rotate angle, change in degrees to the angle
'D- draw this many pixels    s= skip this many pixels
'C= draw a circle (for conistency with dashed line)
'====================================================
Sub angline (xx, yy, klr, adraw$)
    dw = safewords(adraw$, ",", w$())
    x1 = xx: y1 = yy
    thk = 1
    ang = 0
    For n = 1 To dw
        ac$ = UCase$(Left$(_Trim$(w$(n)), 1))
        Select Case ac$
            Case "N"
                av = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                ang = av
                If ang > 360 Then ang = ang - 360
                If ang < 0 Then ang = ang + 360
            Case "R"
                rv = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                ang = ang + rv
                If ang > 360 Then ang = ang - 360
                If ang < 0 Then ang = ang + 360
            Case "D"
                dv = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                x2 = x1 + dv * Cos(0.01745329 * ang)
                y2 = y1 + dv * Sin(0.01745329 * ang)
                dline x1, y1, x2, y2, klr, thk
                x1 = x2
                y1 = y2
            Case "C"
                'doesn't advance spacing on the line
                rr = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                fcirc x1, y1, rr, klr
            Case "S"
                dv = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                x1 = x1 + dv * Cos(0.01745329 * ang)
                y1 = y1 + dv * Sin(0.01745329 * ang)
            Case "T"
                thk = Val(Right$(_Trim$(w$(n)), Len(w$(n)) - 1))
                If thk < 0.5 Then thk = 0.5
            Case "k" 'color change doesn't seem to work yet
                k$ = Right$(_Trim$(w$(n)), Len(w$(n)) - 1)
                kc$ = UCase$(Left$(k$, 1))
                kv = Val(Right$(_Trim$(k$), Len(k$) - 1))
                kred = _Red(klr)
                kgreen = _Green(klr)
                kblue = _Blue(klr)
                Select Case kc$
                    Case "R"
                        kred = kv
                    Case "G"
                        kgreen = kv
                    Case "B"
                        kblue = kv
                End Select
                klr = _RGB32(kred, kgreen, kblue)
        End Select
    Next n
    contX = x1
    conty = y1
End Sub
Sub trapa (xx, yy, base1, base2, h, rtn, kk, thk)
    storeDest& = _Dest
    ww = base2
    If base1 > base2 Then ww = base1
    ww = (ww + thk) * 2
    hh = (h + thk) * 2
    ti& = _NewImage(ww, hh)
    cx = ww / 2
    cy = hh / 2
    y1 = (hh - h) / 2
    y2 = (hh + h) / 2
    x1 = (cx - base1 / 2): x2 = (cx + base1 / 2)
    x3 = (cx - base2 / 2): x4 = (cx + base2 / 2)
    _Dest ti&
    dline x1, y1, x2, y1, kk, thk
    dline x2, y1, x4, y2, kk, thk
    dline x3, y2, x4, y2, kk, thk
    dline x1, y1, x3, y2, kk, thk
    _Dest storeDest&
    rotation = _D2R(rtn)
    RotoZoom2fixed xx, yy, ti&, 1, 1, rotation
    _FreeImage ti&
End Sub