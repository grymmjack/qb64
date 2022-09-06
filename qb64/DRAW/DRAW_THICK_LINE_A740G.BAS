Option _Explicit
Screen _NewImage(320, 200, 32)
_FullScreen _SquarePixels

' LineThick 0, 0, _Width - 1, _Height - 1, &HFFFFFFFF, 7

LineThick 0, 0, 120, 100,   &HFFFFFFFF, 5 ' \
LineThick 0, 100, 120, 0,   &HFFFFFFFF, 5 ' /
LineThick 0, 50, 120, 50,   &HFFFFFFFF, 5 ' -
LineThick 60, 0, 60, 100,   &HFFFFFFFF, 5 ' |

LineThick 30, 0, 90, 100,   &HFFFFFFFF, 5 ' \
LineThick 30, 100, 90, 0,   &HFFFFFFFF, 5 ' /

LineThick 0, 30, 120, 70,   &HFFFFFFFF, 5 ' \
LineThick 0, 70, 120, 30,   &HFFFFFFFF, 5 ' / 


Sleep
End

Sub LineThick (xstart As Integer, ystart As Integer, xend As Integer, yend As Integer, c As _Unsigned Long, t As _Unsigned _Byte)
    Dim As Long xstep, ystep, change
    Dim As Long xdelta, ydelta, x1, y1, x2, y2
    Dim As Single bt

    x1 = xstart
    y1 = ystart
    x2 = xend
    y2 = yend
    xdelta = x2 - x1
    ydelta = y2 - y1
    bt = t / 4

    If xdelta < 0 Then
        xdelta = -xdelta
        xstep = -1
    Else
        xstep = 1
    End If

    If ydelta < 0 Then
        ydelta = -ydelta
        ystep = -1

    Else
        ystep = 1
    End If

    If xdelta > ydelta Then
        change = _ShR(xdelta, 1)
        Do While x1 <> x2
            Line (CSng(x1) - bt, CSng(y1) - bt)-(CSng(x1) + bt, CSng(y1) + bt), c, BF
            x1 = x1 + xstep
            change = change + ydelta
            If change > xdelta Then
                y1 = y1 + ystep
                change = change - xdelta
            End If
        Loop
    Else
        change = _ShR(ydelta, 1)
        Do While y1 <> y2
            Line (CSng(x1) - bt, CSng(y1) - bt)-(CSng(x1) + bt, CSng(y1) + bt), c, BF
            y1 = y1 + ystep
            change = change + xdelta
            If change > ydelta Then
                x1 = x1 + xstep
                change = change - ydelta
            End If
        Loop
    End If
End Sub