'SCREEN MODE 0 "Graphics"
' by James D. Jarvis
'
'a set of text mode "drawing" routines for text mode screens
'
'===========================================================================
' Global variables and Main Program setup
'===========================================================================
Screen _NewImage(160, 40, 0) '<- routines will work in any size text screen
Dim Shared kbg, kff, aspect '<- need these for the subs
Dim Shared tpointr, tl$ '<- needs these for the subs
aspect = _Width / (_Height * 2) '<- needed in the subs
kbg = 0: kff = 15 'main bachground color and main foreground color
'===========================================================================
' Simple Demo of the drawing routines
'===========================================================================
_FullScreen
circlechr 50, 20, 6, 8, Chr$(219)
circlechr 50, 20, 4, 8, Chr$(178)
chrline 3, 3, 30, 30, 0.5, 3, Chr$(219)
chrpoly 60, 20, 10, 90, 45, 3, 0.5, "*"
chrrect 124, 4, 156, 16, 11, "X", "X"
chrrect 124, 18, 156, 22, 11, "@", "b"
vprint 70, 4, "Therefore"
color_print 125, 33, 12, 4, "Hello there"
color_vprint 123, 32, 0, 4, "Hello there"
textline 11, 11, 40, 21, 19, 12, "*-AA"
textline 100, 20, 3, 5, 12, 0, "theline"
textline 80, 10, 80, 33, 12, 0, "theline"
Input "Press ENTER to continue", A$
tx = 1: ty = 1
turn = 0
cl$ = "*"
Do
    _Limit 5 'sorry that's so slow but even at 30 fps it's too fast to really see what going on
    Cls
    n = 0
    For y = 1 To 40
        chrline 1, y, _Width, y, 0.5, n, Chr$(176)
        n = n + 1
        If n = 16 Then n = 0
    Next
    Locate 1, 1: Print "TEXTSPRITE demo and some rotating polygons using textpoly"
    Locate 3, 1: Print "press <esc> to exit>"
    Locate 2, 1: Print "Have to slow this down on modern machines so you can see it."
    circletext 50, 20, 10, 12, "I'M A CIRCLE OF TEXT! "
    chrpoly 50, 20, 10, 3, 0, 13, 0, Chr$(219) 'make an unfilled pseudo-circle using chrpoly ortextpoly
    textpoly 100, 20, 10, 60, turn, 12, 10, cl$
    textpoly 100, 20, 5, 90, -turn, 12, 10, cl$
    turn = turn + 3: cl$ = cl$ + Chr$(33 + Int(Rnd * 200)): If Len(cl$) > 200 Then cl$ = "*"
    If turn > 360 Then turn = turn - 360
    textsprite tx, ty, "0---0 ###  # # ", 5, 11
    _Display
    tx = tx + 2
    ty = ty + 1
    If ty > _Height Then ty = 1
    If tx > _Width Then tx = 1
    kk$ = InKey$
Loop Until kk$ = Chr$(27)
End

'===========================================================================
' Text "Drawing" routines to draw lines, circles, rectangles, and polygons
'===========================================================================
Sub vprint (x, y, st$)
    'print vertically down
    slen = Len(st$)
    n = 0
    For yy = y To y + slen - 1
        n = n + 1
        If yy > 0 And yy <= _Height Then _PrintString (x, yy), Mid$(st$, n, 1)
    Next
End Sub
Sub color_print (x, y, tfk, tbk, st$)
    'printstring st$ at location x,y   with foreground color tfk and background color tbk
    Color tfk, tbk
    _PrintString (x, y), st$
    Color kff, kbg
End Sub
Sub color_vprint (x, y, tfk, tbk, st$)
    'print vertically down with  with foreground color tfk and background color tbk
    Color tfk, tbk
    vprint x, y, st$
    Color kff, kbg
End Sub

Sub circlechr (cx As Long, cy As Long, r As Long, klr As _Unsigned Long, cc$)
    'draw a filled circle using a ascii charcater of color klr
    'the  width is adjusted to be closer visibly to a circle as opposed to a oval due the size of charcaers  displayed in text mode
    rsqrd = (r + .3) * (r + .3)
    Color klr, kbg
    y = -r
    While y <= r
        x = Int(Sqr(rsqrd - y * y)) * aspect 'ascpect is global value created in the main program , yuo may have to change it for some screens
        For tx = cx - x To cx + x
            If tx > 0 And tx <= _Width And cy + y > 0 And cy + y <= _Height Then _PrintString (tx, cy + y), cc$
        Next tx
        y = y + 1
    Wend
    Color kff, kbg
End Sub

Sub chrpoly (cx, cy, rr, shapedeg, turn, klr As _Unsigned Long, thk, cc$)
    'draw a polygon using character cc$ in color klr
    'the  width is adjusted to be closer visibly to a circle as opposed to a oval due the size of charcaers  displayed in text mode
    'cx,cy is polygon center   rr is the radius of the outermost points shapedeg is the angles to form the polygon turn
    'turn is the degrees to rotate the whole shape klr is the kolor of the line thk is the thickness of the line 0.5 for 1 character thick lines (it's a radius)
    'cc$ is the character to be used
    For deg = turn To turn + 360 Step shapedeg
        x2 = cx + (rr * Cos(0.01745329 * deg)) * aspect 'ascpect is global value created in the main program , yuo may have to change it for some screens
        y2 = cy + rr * Sin(0.01745329 * deg)
        If x > 0 Then chrline x, y, x2, y2, thk, klr, cc$
        x = x2
        y = y2
    Next
End Sub


Sub chrrect (x1, y1, x2, y2, klr, cc$, mode$)
    'draw a rectangle using character cc$ in color klr
    ' mode$ allows different sorts of rectangles F will be a filled rectangle, X and outline with diagonals from corener to corner and anyhtign else will be an outline
    Select Case UCase$(mode$)
        Case "F"
            For y = y1 To y2
                _PrintString (x1, y), String$((x2 + 1 - x1), Asc(cc$))
            Next y
        Case "X"
            chrline x1, y1, x2, y1, 0.5, klr, cc$
            chrline x1, y2, x2, y2, 0.5, klr, cc$
            chrline x1, y1, x1, y2, 0.5, klr, cc$
            chrline x2, y1, x2, y2, 0.5, klr, cc$
            chrline x1, y1, x2, y2, 0.5, klr, cc$
            chrline x1, y2, x2, y1, 0.5, klr, cc$
        Case Else
            chrline x1, y1, x2, y1, 0.5, klr, cc$
            chrline x1, y2, x2, y2, 0.5, klr, cc$
            chrline x1, y1, x1, y2, 0.5, klr, cc$
            chrline x2, y1, x2, y2, 0.5, klr, cc$
    End Select
End Sub

Sub chrline (x0, y0, x1, y1, r, klr, cc$)
    'draw a line with a charcter CC$ in color klr in thickness r (it's a radius) use 0.5 for 1 character thick lines.
    If Abs(y1 - y0) < Abs(x1 - x0) Then
        If x0 > x1 Then
            lineLow x1, y1, x0, y0, r, klr, cc$
        Else
            lineLow x0, y0, x1, y1, r, klr, cc$
        End If
    Else
        If y0 > y1 Then
            lineHigh x1, y1, x0, y0, r, klr, cc$
        Else
            lineHigh x0, y0, x1, y1, r, klr, cc$
        End If
    End If
End Sub
Sub lineLow (x0, y0, x1, y1, r, klr, cc$)
    'internal routine used with  chrline
    dx = x1 - x0
    dy = y1 - y0
    yi = 1
    If dy < 0 Then
        yi = -1
        dy = -dy
    End If
    d = (dy + dy) - dx
    y = y0
    For x = x0 To x1
        circlechr x, y, r, klr, cc$
        If d > 0 Then
            y = y + yi
            d = d + ((dy - dx) + (dy - dx))
        Else
            d = d + dy + dy
        End If
    Next x
End Sub
Sub lineHigh (x0, y0, x1, y1, r, klr, cc$)
    'internal routine used with  chrline
    dx = x1 - x0
    dy = y1 - y0
    xi = 1
    If dx < 0 Then
        xi = -1
        dx = -dx
    End If
    D = (dx + dx) - dy
    x = x0
    For y = y0 To y1
        circlechr x, y, r, klr, cc$

        If D > 0 Then
            x = x + xi
            D = D + ((dx - dy) + (dx - dy))
        Else
            D = D + dx + dx
        End If
    Next y
End Sub

Sub textline (x0, y0, x1, y1, Fklr, Bklr, cc$)
    'use a string to write a line not just a single character. The string will be repeated until the line is finished
    tl$ = cc$
    tpointr = 0
    If Abs(y1 - y0) < Abs(x1 - x0) Then
        If x0 > x1 Then
            tlinelow x1, y1, x0, y0, Fklr, Bklr
        Else
            tlinelow x0, y0, x1, y1, Fklr, Bklr
        End If
    Else
        If y0 > y1 Then
            tlineHigh x1, y1, x0, y0, Fklr, Bklr
        Else
            tlineHigh x0, y0, x1, y1, Fklr, Bklr
        End If
    End If
    Color kff, kfg
End Sub
Sub tlinelow (x0, y0, x1, y1, Fklr, Bklr)
    'internal routine used with  textline
    dx = x1 - x0
    dy = y1 - y0
    yi = 1
    If dy < 0 Then
        yi = -1
        dy = -dy
    End If
    d = (dy + dy) - dx
    y = y0
    For x = x0 To x1
        tpointr = tpointr + 1
        If tpointr > Len(tl$) Then tpointr = 1
        Color Fklr, Bklr
        If x > 0 And x <= _Width And y > 0 And y <= _Height Then _PrintString (x, y), Mid$(tl$, tpointr, 1)
        If d > 0 Then
            y = y + yi
            d = d + ((dy - dx) + (dy - dx))
        Else
            d = d + dy + dy
        End If
    Next x
End Sub
Sub tlineHigh (x0, y0, x1, y1, Fklr, bklr)
    'internal routine used with  textline
    dx = x1 - x0
    dy = y1 - y0
    xi = 1
    If dx < 0 Then
        xi = -1
        dx = -dx
    End If
    D = (dx + dx) - dy
    x = x0
    For y = y0 To y1
        tpointr = tpointr + 1
        If tpointr > Len(tl$) Then tpointr = 1
        Color Fklr, bklr
        If x > 0 And x <= _Width And y > 0 And y <= _Height Then _PrintString (x, y), Mid$(tl$, tpointr, 1)
        If D > 0 Then
            x = x + xi
            D = D + ((dx - dy) + (dx - dy))
        Else
            D = D + dx + dx
        End If
    Next y
End Sub
Sub textsprite (x, y, sp$, wid, klr)
    'print a single color text sprite
    ' chr$(32) or <space> is  used in the empty spots in the sprite becaseu _printmode doesn't allow for the trasnparent backgrounds
    'in text mode
    'SP$ the sprite a normal spring
    'wid the width of each line in the sprite
    Color klr, kbg
    siz = Len(sp$)
    p = 0
    For sy = 1 To siz
        For sx = 1 To wid
            p = p + 1
            If (x - 1 + sx) > 0 And (x - 1 + sx) <= _Width And (y - 1 + sy) > 0 And (y - 1 + sy) <= _Height Then
                If Mid$(sp$, p, 1) <> " " Then _PrintString (x - 1 + sx, y - 1 + sy), Mid$(sp$, p, 1)
            End If
        Next sx
    Next sy
    Color kff, kbg
End Sub
Sub circletext (cx As Long, cy As Long, r As Long, klr As _Unsigned Long, cc$)
    'draw a filled circle using a string of color klr
    'the  width is adjusted to be closer visibly to a circle as opposed to a oval due the size of charcaers  displayed in text mode
    rsqrd = (r + .3) * (r + .3)
    tl = Len(cc$)
    Color klr, kbg
    p = 0
    y = -r
    While y <= r
        x = Int(Sqr(rsqrd - y * y)) * aspect 'ascpect is global value created in the main program , yuo may have to change it for some screens
        For tx = cx - x To cx + x
            If tx > 0 And tx <= _Width And cy + y > 0 And cy + y <= _Height Then
                p = p + 1
                If p > tl Then p = 1
                _PrintString (tx, cy + y), Mid$(cc$, p, 1)
            End If
        Next tx
        y = y + 1
    Wend
    Color kff, kbg
End Sub
Sub textpoly (cx, cy, rr, shapedeg, turn, fklr, bklr, cc$)
    'draw a polygon using character cc$ in color klr
    'the  width is adjusted to be closer visibly to a circle as opposed to a oval due the size of charcaers  displayed in text mode
    For deg = turn To turn + 360 Step shapedeg
        x2 = cx + (rr * Cos(0.01745329 * deg)) * aspect 'ascpect is global value created in the main program , yuo may have to change it for some screens
        y2 = cy + rr * Sin(0.01745329 * deg)
        If x > 0 Then textline x, y, x2, y2, fklr, bklr, cc$
        x = x2
        y = y2
    Next
End Sub