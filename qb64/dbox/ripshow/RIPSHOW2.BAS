Const RIP_LS_SOLID = &B1111111111111111
Const RIP_LS_DOTTED = &B0011001100110011
Const RIP_LS_CENTERED = &B0001111000111111
Const RIP_LS_DASHED = &B0001111100011111

'DIM SHARED Num36 AS INTEGER
'DIM SHARED char AS STRING
'DIM SHARED char2 AS STRING
Dim Shared FillPattern As Integer
Dim Shared DrawColor As Integer
Dim Shared FillColor As Integer
Dim Shared LineStyle As Integer
Dim Shared LineThickness As Integer

'DIM SHARED UnCharacter AS INTEGER
'DIM SHARED Picture(30000) AS STRING * 1
'DIM SHARED i AS INTEGER
Dim Shared FontArray(1 To 32767) As Integer
Dim Shared FontWidth As Integer
Dim Shared FontHeight As Integer

Dim Shared clipboard(30000) As Integer
Dim Shared clipwidth As Integer
Dim Shared clipheight As Integer

Dim Shared commands(100) As DrawCommand
Dim Shared cmdIndex As Integer
Type DrawCommand
    dcommand As String
    ddata As String
End Type

Type DPoint
    x As Integer
    y As Integer
End Type

Dim Shared PauseEnabled
PauseEnabled = 0

Screen 9
Width 80, 43
LoadFont "tree.fnt"

Open "debug.log" For Output As #1

'LINE (9, 9)-(199, 199), 15
'LINE (10, 10)-(200, 200), 15
'LINE (11, 11)-(201, 201), 15

'Bezier 19, 10, 100, 0, 150, 29, 199, 10, 14, 50
'Bezier 20, 10, 100, 1, 150, 30, 200, 10, 14, 50
'Bezier 22, 10, 100, 2, 150, 31, 201, 10, 14, 50

'PSET (10, 10)
'DRAW "F300"
'PSET (10, 50)
'DRAW "F300S8"
'INPUT waitforit$

Dim done As Integer
done = 0
While done = 0
    LineStyle = RIP_LS_SOLID

    Cls
    Color 15
    Print "Filename(*.rip): "
    Input ripfile$
    ripfile$ = "RIP\" + ripfile$
    If Not _FileExists(ripfile$) Then
        Print "Invalid filename.  Press ENTER to continue."
        Input badfilename$
        _Continue
    End If
    Print "Flood Fill? (Y/N): "
    Input ffill$
    Print "Debug? (Y/N): "
    Input qdebug$
    If qdebug$ = "Y" Then
        PauseEnabled = 1
    Else
        PauseEnabled = 0
    End If

    Cls

    'READ RIP FILE
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Open ripfile$ For Input As #2
    Do While Not EOF(2)
        Line Input #2, rec$
        'PRINT rec$

        Call GetCmdStrings(rec$)
        'PRINT commands(cmdIndex).dcommand
        'PRINT rec$

        For ci% = 1 To cmdIndex

            dcommand$ = commands(ci%).dcommand
            ddata$ = commands(ci%).ddata
            Debug dcommand$ + ":" + ddata$

            Select Case (dcommand$)
                Case "a": ChangePalette ddata$
                Case "c": ChangeColor ddata$
                Case "S": ChangeFillColor ddata$
                Case "s": ChangeFillPattern ddata$
                Case "L": DrawLine ddata$
                Case "R": DrawRectangle ddata$, 0
                Case "B": DrawRectangle ddata$, 1
                Case "C": DrawCircle ddata$, 0
                Case "o": DrawCircle ddata$, 1
                Case "O": DrawOval ddata$
                Case "V": DrawOvalArc ddata$
                Case "X": DrawDot ddata$
                Case "P": DrawPoly ddata$, 0
                Case "p": DrawPoly ddata$, 1
                Case "F": If ffill$ = "Y" Then FloodFill ddata$
                Case "@": DrawText ddata$
                Case "Q": InitPalette ddata$
                Case "Z": DrawBezier ddata$
                Case "w": ChangeTextWindow ddata$
                Case "=": ChangeLineStyle ddata$
                Case "Y": ChangeFontStyle ddata$
                Case "1C": ClipCopy ddata$
                Case "1P": ClipPaste ddata$
                Case "#":
                    Debug "# command found. Terminate processing."
                    'done = 1
                    Exit For
                Case Else:
                    If Not dcommand$ = "!" Then
                        Debug dcommand$ + ":" + ddata$ + " - Unknown Command               "
                        'DPause
                    End If
            End Select
            DPause

        Next ci%

    Loop
    Close #2

    kpress$ = InKey$
    Do Until (kpress$ = "q" Or kpress$ = "n")
        kpress$ = InKey$
    Loop
    If kpress$ = "q" Then
        done = 1
    End If

Wend



Close #1
End

Sub Debug (pstring As String)
    'LOCATE 1, 1
    'COLOR 15
    Print #1, pstring
    'COLOR DrawColor
End Sub

Sub DPause
    If PauseEnabled Then
        Do Until (InKey$ = "n")
        Loop
    End If
End Sub


Sub ClipCopy (ddata As String)
    Dim x, y, x0, y0, x1, y2, clipidx As Integer

    x0 = ConvNum(Mid$(ddata, 1, 2))
    y0 = ConvNum(Mid$(ddata, 3, 2))
    x1 = ConvNum(Mid$(ddata, 5, 2))
    y1 = ConvNum(Mid$(ddata, 7, 2))

    clipwidth = x1 - x0
    clipheight = y1 - y0

    debugstr$ = ""
    For y = y0 To y1
        For x = x0 To x1
            clipidx = (y - y0) * clipwidth + (x - x0)
            clipboard(clipidx) = Point(x, y)
            'debugstr$ = debugstr$ + STR$(clipidx) + ":" + STR$(clipboard(clipidx))
            'Debug "y: " + STR$(y) + " x: " + STR$(x) + "clipidx: " + STR$(clipidx) + ":" + STR$(clipboard(clipidx))
        Next x
        'clipheight = clipheight + 1
    Next y

    'LINE (x0, y0)-(x1, y1), 14, B
    'Debug "clipwidth: " + STR$(clipwidth) + " clipheight: " + STR$(clipheight)
    'Debug debugstr$
    'DPause

End Sub

Sub ClipPaste (ddata As String)
    Dim x, y, x0, y0, mode, clipidx As Integer

    x0 = ConvNum(Mid$(ddata, 1, 2))
    y0 = ConvNum(Mid$(ddata, 3, 2))
    mode = ConvNum(Mid$(ddata, 5, 2))

    'clipwidth = x1 - x0
    'clipheight = 0

    debugstr$ = ""
    For y = y0 To y0 + clipheight
        For x = x0 To x0 + clipwidth
            clipidx = (y - y0) * clipwidth + (x - x0)
            'clipboard(clipidx) = POINT(x, y)
            'debugstr$ = debugstr$ + STR$(clipidx) + ":" + STR$(clipboard(clipidx))
            pixel% = clipboard(clipidx)
            If mode = 1 Then
                pixel% = pixel% Xor Point(x, y)
            ElseIf mode = 2 Then
                pixel% = pixel% Or Point(x, y)
            ElseIf mode = 3 Then
                pixel% = pixel% And Point(x, y)
            ElseIf mode = 4 Then
                pixel% = Not pixel%
            End If
            PSet (x, y), pixel%
        Next x
        'clipheight = clipheight + 1
    Next y

    'LINE (x0, y0)-(x0 + clipwidth, y0 + clipwidth), 13, B
    'Debug "clipwidth: " + STR$(clipwidth) + " clipheight: " + STR$(clipheight)
    'Debug debugstr$
    'DPause

End Sub



Sub ChangeColor (ddata As String)

    DrawColor = ConvNum(ddata)
    Color DrawColor

End Sub

Sub ChangeFillColor (ddata As String)

    FillPattern = ConvNum(Mid$(ddata, 1, 2))
    FillColor = ConvNum(Mid$(ddata, 3, 2))

End Sub

Sub ChangeFillPattern (ddata As String)

    ' PAINT command using a pattern is not supported by QB64
    ' So we'll just set the fill color for now
    FillColor = ConvNum(Mid$(ddata, 17, 2))

End Sub

Sub ChangeLineStyle (ddata As String)

    Dim style As Integer
    Dim custom As String
    style = ConvNum(Mid$(ddata, 1, 2))
    custom = Mid$(ddata, 3, 4)

    LineThickness = ConvNum(Mid$(ddata, 7, 2))

    If style = 1 Then
        LineStyle = RIP_LS_DOTTED
    ElseIf style = 2 Then
        LineStyle = RIP_LS_CENTERED
    ElseIf style = 3 Then
        LineStyle = RIP_LS_DASHED
    ElseIf style = 2 Then
        Debug "Custom Style: [" + custom + "]    "
        DPause
        LineStyle = RIP_LS_SOLID
    Else
        LineStyle = RIP_LS_SOLID
    End If

    Debug "Line Thickness: [" + Str$(LineThickness) + "]"
    'DPause
End Sub

Sub ChangeFontStyle (ddata As String)
    ' TODO: currently only one font is supported
End Sub

Sub ChangeTextWindow (ddata As String)

    'DISABLED - This needs more troubleshooting
    'y1% = ConvNum(MID$(ddata, 3, 2))
    'y2% = ConvNum(MID$(ddata, 7, 2))
    'Debug "Text Window: " + STR$(y1%) + " to " + STR$(y2%)
    'VIEW PRINT y1% TO y2%

End Sub

Sub ChangePalette (ddata As String)

    oldColor% = ConvNum(Mid$(ddata, 1, 2))
    newColor% = ConvNum(Mid$(ddata, 3, 2))

    Palette oldColor%, newColor%

End Sub

Sub DrawCircle (ddata As String, fill As Integer)

    col% = ConvNum(Mid$(ddata, 1, 2))
    row% = ConvNum(Mid$(ddata, 3, 2))
    radius% = ConvNum(Mid$(ddata, 5, 2))

    If LineThickness = 3 Then
        For r% = radius% - 1 To radius% + 1
            Circle (col%, row%), r%, DrawColor
        Next r%
    Else
        Circle (col%, row%), radius%, DrawColor
    End If

    If fill = 1 Then
        'DRAW "P" + STR$(FillColor) + "," + STR$(DrawColor)
        Paint (col%, row%), FillColor, DrawColor
    End If

End Sub

Sub DrawDot (ddata As String)

    col% = ConvNum(Mid$(ddata, 1, 2))
    row% = ConvNum(Mid$(ddata, 3, 2))

    PSet (col%, row%), DrawColor
    'LINE (col%, row%)-(col%, row%)

End Sub

Sub DrawText (ddata As String)

    x% = ConvNum(Mid$(ddata, 1, 2))
    y% = ConvNum(Mid$(ddata, 3, 2))

    dtext$ = Mid$(ddata, 5, Len(ddata) - 4)



    'PRINT "x: "; x%; " y: "; y%; " text: ["; dtext$; "]"

    'CALL BlitString(dtext$, x%, y%, DrawColor)
    _PrintMode _KeepBackground
    _PrintString (x%, y%), dtext$
    _PrintMode _FillBackground

End Sub


Sub DrawLine (ddata As String)

    col1% = ConvNum(Mid$(ddata, 1, 2))
    row1% = ConvNum(Mid$(ddata, 3, 2))
    col2% = ConvNum(Mid$(ddata, 5, 2))
    row2% = ConvNum(Mid$(ddata, 7, 2))

    Dim firstOffset, offset
    If LineThickness = 3 Then
        'firstOffset = -1 'LineThickness < 2 * -1
        'FOR offset = firstOffset TO firstOffset + LineThickness
        For offset = -1 To 1

            If Abs(col2% - col1%) > Abs(row2% - row1%) Then
                Line (col1%, row1% + offset)-(col2%, row2% + offset), DrawColor, , LineStyle
            Else
                Line (col1% + offset, row1%)-(col2% + offset, row2%), DrawColor, , LineStyle
            End If

        Next offset
        'Debug "*** firstOffset: " + STR$(firstOffset) + " lastOffset: " + STR$(firstOffset + LineThickness)
    Else
        Line (col1%, row1%)-(col2%, row2%), DrawColor, , LineStyle
    End If

End Sub

Sub DrawRectangle (ddata As String, fill As Integer)

    col1% = ConvNum(Mid$(ddata, 1, 2))
    row1% = ConvNum(Mid$(ddata, 3, 2))
    col2% = ConvNum(Mid$(ddata, 5, 2))
    row2% = ConvNum(Mid$(ddata, 7, 2))

    If fill = 1 Then
        Line (col1%, row1%)-(col2%, row2%), FillColor, BF
    Else
        Line (col1%, row1%)-(col2%, row2%), DrawColor, B , LineStyle
        If LineThickness = 3 Then
            Line (col1% - 1, row1% - 1)-(col2% + 1, row2% + 1), DrawColor, B , LineStyle
            Line (col1% + 1, row1% + 1)-(col2% - 1, row2% - 1), DrawColor, B , LineStyle
        End If
    End If

End Sub

Sub DrawOval (ddata As String)

    x% = ConvNum(Mid$(ddata, 1, 2))
    y% = ConvNum(Mid$(ddata, 3, 2))
    ostart# = ConvNum(Mid$(ddata, 5, 2)) / 6.283185307#
    oend# = ConvNum(Mid$(ddata, 7, 2)) / 6.283185307#
    xradian% = ConvNum(Mid$(ddata, 9, 2))
    yradian% = ConvNum(Mid$(ddata, 11, 2))

    aspect# = yradian% / xradian%
    'aspect# = xradian% / yradian%

    'PRINT "x: "; x%; " y: "; y%; " ostart: "; ostart#; " oend: "; oend#;
    'PRINT " xr: "; xradian%; " yr: "; yradian%; " aspect: "; aspect#
    If LineThickness = 3 Then
        For r% = xradian% - 1 To xradian% + 1
            Circle (x%, y%), r%, DrawColor, , , aspect#
        Next r%
    Else
        Circle (x%, y%), xradian%, DrawColor, , , aspect#
    End If

End Sub

Sub DrawOvalArc (ddata As String)

    x% = ConvNum(Mid$(ddata, 1, 2))
    y% = ConvNum(Mid$(ddata, 3, 2))
    ostart# = ConvNum(Mid$(ddata, 5, 2)) / 6.283185307#
    oend# = ConvNum(Mid$(ddata, 7, 2)) / 6.283185307#
    'ostart# = ConvNum(MID$(ddata, 5, 2))
    'oend# = ConvNum(MID$(ddata, 7, 2))
    xradian% = ConvNum(Mid$(ddata, 9, 2))
    yradian% = ConvNum(Mid$(ddata, 11, 2))

    aspect# = yradian% / xradian%

    'PRINT "x: "; x%; " y: "; y%; " ostart: "; ostart#; " oend: "; oend#;
    'PRINT " xr: "; xradian%; " yr: "; yradian%; " aspect: "; aspect#
    Debug "DrawOvalArc x%:" + Str$(x%) + " y%: " + Str$(y%) + " ostart: " + Str$(ostart#) + " oend: " + Str$(oend#) + " xradian: " + Str$(xradian%) + " yradian: " + Str$(yradian%) + " aspect: " + Str$(aspect#)
    DPause
    If ostart% = oend% Then
        Debug "start and ending angles are the same"
        'CIRCLE (x%, y%), xradian%, DrawColor, ostart#, oend#, aspect#
    Else
        Circle (x%, y%), xradian%, DrawColor, ostart#, oend#, aspect#
    End If
    DPause

End Sub

Sub DrawBezier (ddata As String)

    Dim x1, y1, x2, y2, x3, y3, x4, y4, cnt As Integer
    x1 = ConvNum(Mid$(ddata, 1, 2))
    y1 = ConvNum(Mid$(ddata, 3, 2))
    x2 = ConvNum(Mid$(ddata, 5, 2))
    y2 = ConvNum(Mid$(ddata, 7, 2))
    x3 = ConvNum(Mid$(ddata, 9, 2))
    y3 = ConvNum(Mid$(ddata, 11, 2))
    x4 = ConvNum(Mid$(ddata, 13, 2))
    y4 = ConvNum(Mid$(ddata, 15, 2))
    cnt = ConvNum(Mid$(ddata, 17, 2))

    Dim firstOffset, offset
    If LineThickness = 3 And 1 = 2 Then
        ' firstOffset = LineThickness < 2 * -1
        For offset = -1 To 1 'firstOffset TO firstOffset + LineThickness

            If Abs(x4% - x1%) > Abs(y4% - y1%) Then
                Bezier x1, y1 + offset, x2, y2 + offset, x3, y3 + offset, x4, y4 + offset, DrawColor, cnt
            Else
                Bezier x1 + offset, y1, x2 + offet, y2, x3 + offset, y3, x4 + offset, y4, DrawColor, cnt
            End If

        Next offset
    Else
        Bezier x1, y1, x2, y2, x3, y3, x4, y4, DrawColor, cnt
    End If
    'Bezier x1, y1, x2, y2, x3, y3, x4, y4, DrawColor, cnt
    Debug "FirstOffset: " + Str$(firstOffset)
End Sub


Sub DrawPoly (ddata As String, fill As Integer)

    Dim minx, miny, maxx, maxy As Integer
    Dim scanx, scany As Integer
    Dim points(200) As DPoint
    Dim pcount As Integer
    count% = ConvNum(Mid$(ddata, 1, 2))
    col1% = ConvNum(Mid$(ddata, 3, 2))
    row1% = ConvNum(Mid$(ddata, 5, 2))
    col2% = 0
    row2% = 0
    firstx% = col1%
    firsty% = row1%

    points(1).x = firstx%
    points(1).y = firsty%
    pcount = 1

    ddataIdx% = 7
    'ddataIdx% = 3
    'drawcmd$ = "B" + STR$(col1%) + "," + STR$(row1%)

    minx = col1%
    miny = row1%
    maxx = col1%
    maxy = row1%

    If fill Then
        drawcmd$ = "C" + Str$(FillColor)
    Else
        drawcmd$ = "C" + Str$(DrawColor)
    End If

    PReset (col1%, row1%)
    For i% = 2 To count%
        'FOR i% = 1 TO count%
        col2r$ = Mid$(ddata, ddataIdx%, 2)
        row2r$ = Mid$(ddata, ddataIdx% + 2, 2)
        col2% = ConvNum(Mid$(ddata, ddataIdx%, 2))
        row2% = ConvNum(Mid$(ddata, ddataIdx% + 2, 2))
        'PRINT i%; ": "; col2r$; ","; row2r$; " - "; col1%; ","; row1%; "-"; col2%; ","; row2%
        'LINE (col1%, row1%)-(col2%, row2%)
        'col1% = col2%
        'row1% = row2%
        drawcmd$ = drawcmd$ + "M" + Str$(col2%) + "," + Str$(row2%)
        ddataIdx% = ddataIdx% + 4

        If col2% < minx Then minx = col2%
        If col2% > maxx Then maxx = col2%
        If row2% < miny Then miny = row2%
        If row2% > maxy Then maxy = row2%

        pcount = pcount + 1
        points(i%).x = col2%
        points(i%).y = row2%
    Next i%

    pcount = pcount + 1
    points(pcount).x = firstx%
    points(pcount).y = firsty%

    '    PRINT "N: "; col1%; ","; row1%; " - "; firstx%; ","; firsty%
    ' LINE (col1%, row1%)-(firstx%, firsty%)
    drawcmd$ = drawcmd$ + "M" + Str$(col1%) + "," + Str$(row1%)

    If fill Then

        ' CALCULATE OFFSET
        '----------------------------------------------------------------
        Dim fys(100) As Integer
        Dim fycount As Integer
        fycount = 0
        scanx = _Round(minx + (maxx - minx) / 2)
        'debugColor% = 10
        Dim fillOn As Integer

        'FOR scanx = minx TO maxx
        'fillOn = 0
        For scany = miny To maxy
            Dim found As Integer
            found = 0

            'PSET (scanx, scany), 14

            For pi% = 2 To pcount
                isInLine% = inLine(points(pi% - 1).x, points(pi% - 1).y, points(pi%).x, points(pi%).y, scanx, scany)
                'Debug "inLine result[" + STR$(pi%) + "]: " + STR$(isInLine%)
                'LINE (points(pi% - 1).x, points(pi% - 1).y)-(points(pi%).x, points(pi%).y), debugColor%

                If isInLine% = 1 Then
                    found = 1
                    'PSET (scanx, scany), 12
                    'CIRCLE (scanx, scany), 3, 12
                    'EXIT FOR
                    fycount = fycount + 1
                    fys(fycount) = scany
                End If
                'PSET (scanx, scany), 12
                'DPause

                'IF fillOn = 1 THEN PSET (scanx, scany), FillColor

                'IF isInLine% = 1 THEN
                '    IF fillOn = 0 THEN
                '        fillOn = 1
                '    ELSE
                '        fillOn = 0
                '    END IF
                'END IF

            Next pi%
            'debugColor% = debugColor% + 1
            'IF debugColor% > 15 THEN debugColor% = 10
        Next scany
        'NEXT scanx

        '----------------------------------------------------------------
        If fycount > 1 Then
            'Debug "fys(2): " + STR$(fys(2)) + " fys(1): " + STR$(fys(1))
            filly% = fys(1) + ((fys(2) - fys(1)) / 2)
            'Debug "filly: " + STR$(filly%)
            'PSET (scanx, filly%), 12
            'DPause
            'PAINT (scanx, filly%), FillColor, FillColor
            drawcmd$ = drawcmd$ + "BM" + Str$(scanx) + "," + Str$(filly%)
        End If


        drawcmd$ = drawcmd$ + "P" + Str$(FillColor) + "," + Str$(FillColor)
    End If

    Debug "DrawPoly: " + drawcmd$
    Draw drawcmd$


    'LINE (minx, miny)-(maxx, maxy), 14, B



End Sub


Function inLineOLD (ax As Double, ay As Double, bx As Double, by As Double, cx As Double, cy As Double)
    Debug "inLine ax=[" + Str$(ax) + "] ay=[" + Str$(ay) + "] bx=[" + Str$(bx) + "] by=[" + Str$(by) + "] cx=[" + Str$(cx) + "] cy=[" + Str$(cy) + "]"

    If ax = cx Then
        ' if AC is vertical
        If (bx = cx) Then
            inLineOLD = 1
            Exit Function
        End If
    End If
    If ay = cy Then
        ' if AC is horizontal
        If (by = cy) Then
            inLineOLD = 1
            Exit Function
        End If
    End If

    ' match the gradients
    If ((ax - cx) * (ay - cy) = (cx - bx) * (cy - by)) Then
        inLineOLD = 1
        Exit Function
    End If

    inLineOLD = 0

End Function

Function inLine (x1 As Double, y1 As Double, x2 As Double, y2 As Double, x3 As Double, y3 As Double)
    'Debug "inLine x1=[" + STR$(x1) + "] y1=[" + STR$(y1) + "] x2=[" + STR$(x2) + "] y2=[" + STR$(y2) + "] x3=[" + STR$(x3) + "] y3=[" + STR$(y3) + "]"

    'calculating slope of first two points
    Dim slope As Double
    slope = (y2 - y1) / (x2 - x1)

    'checking conditions for `pt3` to be on line
    Dim pt3_on As Integer
    pt3_on = 0
    If (y3 - y1) = _Round(slope * (x3 - x1)) Then pt3_on = 1

    Dim pt3_between As Integer
    pt3_between = 0
    If (min(x1, x2) <= x3 And x3 <= max(x1, x2)) And (min(y1, y2) <= y3 And y3 <= max(y1, y2)) Then
        pt3_between = 1
    End If

    If pt3_on = 1 And pt3_between = 1 Then
        inLine = 1
    Else
        inLine = 0
    End If

End Function

Function min (num1 As Double, num2 As Double)

    If num1 < num2 Then
        min = num1
    Else
        min = num2
    End If

End Function

Function max (num1 As Double, num2 As Double)

    If num1 > num2 Then
        max = num1
    Else
        max = num2
    End If

End Function

Sub FloodFill (ddata As String)

    col% = ConvNum(Mid$(ddata, 1, 2))
    row% = ConvNum(Mid$(ddata, 3, 2))
    fillborder% = ConvNum(Mid$(ddata, 5, 2))

    Debug "col:" + Str$(col%) + " row:" + Str$(row%) + " fillcolor:" + Str$(FillColor) + " fillborder:" + Str$(fillborder%)
    pixel% = Point(col%, row%)
    PSet (col%, row%), 15
    DPause
    PSet (col%, row%), pixel%
    Paint (col%, row%), FillColor, fillborder%
    DPause

End Sub

Function ConvNum (numstr As String)

    Dim nchar As String
    nchar = Left$(numstr, 1)

    Num36a% = Asc(nchar)


    Num36a% = Num36a% - 48

    If (Num36a% > 15) Then
        Num36a% = Num36a% - 7
    End If


    nchar = Right$(numstr, 1)
    'IF ((char2 = "|") OR (char2 = CHR$(13))) THEN
    'Num36 = Num36a%
    'GOTO 100
    'END IF

    Num36b% = Asc(nchar)

    Num36b% = Num36b% - 48

    If (Num36b% > 15) Then
        Num36b% = Num36b% - 7
    End If

    Num36a% = Num36a% * 36
    ConvNum = Num36a% + Num36b%

End Function

'SUB GetNum

'    i = i + 1
'    char2 = Picture(i)
'    Num36a% = ASC(char2)


'    Num36a% = Num36a% - 48

'    IF (Num36a% > 15) THEN
'        Num36a% = Num36a% - 7
'    END IF


'    i = i + 1
'    char2 = Picture(i)
'    IF ((char2 = "|") OR (char2 = CHR$(13))) THEN
'        Num36 = Num36a%
'        GOTO 100
'    END IF

'    Num36b% = ASC(char2)

'    Num36b% = Num36b% - 48

'    IF (Num36b% > 15) THEN
'        Num36b% = Num36b% - 7
'    END IF

'    Num36a% = Num36a% * 36
'    Num36 = Num36a% + Num36b%

'    100
'END SUB

Sub InitPalette (ddata As String)

    Dim doffset
    doffset = 1
    For count% = 0 To 15
        Palette count%, ConvNum(Mid$(ddata, doffset, 2))
        doffset = doffset + 2
    Next count%

End Sub

Sub GetCmdStrings (cmdLine As String)

    Dim charIndex As Integer
    Dim currChar As String
    'DIM currCmd AS DrawCommand

    While Right$(cmdLine, 1) = "\"
        Line Input #2, nextLine$
        cmdLine = Left$(cmdLine, Len(cmdLine) - 1) + nextLine$
    Wend

    cmdIndex = 1
    commands(cmdIndex).dcommand = ""
    commands(cmdIndex).ddata = ""
    For charIndex = 1 To Len(cmdLine)
        currChar = Mid$(cmdLine, charIndex, 1)
        If currChar = "|" Then
            'PRINT commands(cmdIndex).dcommand + ":" + commands(cmdIndex).ddata
            'commands(cmdIndex) = currCmd
            If Not commands(cmdIndex).dcommand = "!" Then
                cmdIndex = cmdIndex + 1
            End If
            commands(cmdIndex).dcommand = ""
            commands(cmdIndex).ddata = ""
        ElseIf commands(cmdIndex).dcommand = "1" Then
            commands(cmdIndex).dcommand = commands(cmdIndex).dcommand + currChar
        ElseIf currChar = "\" And Not Mid$(cmdLine, charIndex + 1, 1) = "\" Then
            'Ignore escape character
        Else
            If commands(cmdIndex).dcommand = "" Then
                commands(cmdIndex).dcommand = currChar
            Else
                commands(cmdIndex).ddata = commands(cmdIndex).ddata + currChar
            End If
        End If
    Next charIndex

    'lastLine$ = commands(cmdIndex).ddata
    'WHILE RIGHT$(lastLine$, 1) = "\"
    '    LINE INPUT #2, nextLine$
    '    lastLine$ = LEFT$(lastLine$, LEN(lastLine$) - 1) + nextLine$
    'WEND
    'commands(cmdIndex).ddata = lastLine$

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub Bezier (x0 As Integer, y0 As Integer, x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer, x3 As Integer, y3 As Integer, bcolor As Integer, cnt As Integer)
    Dim x
    Dim y
    Dim i
    Dim t
    Dim xtemp As Integer
    Dim ytemp As Integer
    Dim xprev As Integer
    Dim yprev As Integer
    Dim firstOffset, offset, xoffset, yoffset As Integer
    't = .03
    't = .001
    t = 1! / cnt
    Debug "cnt=" + Str$(cnt) + " t=" + Str$(t)
    'DPause

    i = 0
    xprev = x0
    yprev = y0

    While (i <= 1!)
        x = (((1 - i) * (1 - i) * (1 - i)) * x0) + (3 * i * ((1 - i) * (1 - i)) * x1) + (3 * (i * i) * (1 - i) * x2) + ((i * i * i) * x3)
        y = (((1 - i) * (1 - i) * (1 - i)) * y0) + (3 * i * ((1 - i) * (1 - i)) * y1) + (3 * (i * i) * (1 - i) * y2) + ((i * i * i) * y3)
        xtemp = x
        ytemp = y

        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        xoffset = 0
        yoffset = 0
        If LineThickness = 3 Then
            '    firstOffset = LineThickness < 2 * -1
            For offset = -1 To 1 'firstOffset TO firstOffset + LineThickness

                If Abs(xtemp - xprev) > Abs(ytemp - yprev) Then
                    yoffset = offset
                Else
                    xoffset = offset
                End If
                Line (xprev + xoffset, yprev + yoffset)-(xtemp + xoffset, ytemp + yoffset), bcolor, , LineStyle
            Next offset
        Else
            Line (xprev, yprev)-(xtemp, ytemp), bcolor, , LineStyle
        End If
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        'LINE (xprev, yprev)-(xtemp, ytemp), bcolor, , LineStyle

        xprev = xtemp
        yprev = ytemp
        i = i + t
    Wend

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub BlitChar (char As String, x As Integer, y As Integer, ccolor As Integer)

    Dim index As Integer
    Dim index2 As Integer
    Dim offset As Integer

    offset = x

    index = ((Asc(char) - 32) * FontWidth * FontHeight)
    index2 = index + FontHeight * FontWidth

    Color ccolor

    For index = index To index2

        If FontArray(index) = 1 Then
            PSet (x, y)
        End If

        x = x + 1

        If x > (offset + FontWidth - 1) Then
            x = offset
            y = y + 1
        End If

    Next index

End Sub

Sub BlitString (sdata As String, x As Integer, y As Integer, ccolor As Integer)
    'PRINT "Start BlitString - x: "; x; " y: "; y; " text: ["; sdata; "]"

    ytemp% = y
    slength% = Len(sdata)
    For i% = 1 To slength%
        char$ = Left$(sdata, i%)
        char$ = Right$(char$, 1)

        If Asc(char$) > 32 And Asc(char$) < 126 Then
            Call BlitChar(char$, x, y, ccolor)
        End If

        y = ytemp%
        x = x + FontWidth + FontXSpacing
    Next i%

    'PRINT "End BlitString - x: "; x; " y: "; y; " text: ["; sdata; "]"
End Sub

Sub LoadFont (filename As String)
    Dim index As Integer

    Open filename For Input As #1
    Input #1, FontHeight, FontWidth
    For index = 1 To FontHeight * FontWidth * 95
        Input #1, FontArray(index)
    Next index
    Close #1

End Sub





'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'OPEN ripfile$ FOR INPUT AS #1
'EndOfFile = 0
'i = 1
'DO UNTIL (EndOfFile = 2)
'    Picture(i) = INPUT$(1, 1)
'    IF Picture(i) = "#" THEN EndOfFile = EndOfFile + 1
'    i = i + 1
'LOOP
'max = i
'CLOSE
''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'DISPLAY RIP GRAPHIC
'FOR i = 1 TO max
'    char = Picture(i)

'    SELECT CASE (char)

'        CASE "#": EndOfFile = EndOfFile + 1
'CASE "c": ChangeColorOLD
'CASE "X": DrawDotOLD
'CASE "L": DrawLineOLD
'CASE "C": DrawCircleOLD
'CASE "S": ChangeFColorOLD
'CASE "F": FillOLD
'CASE "l": DrawPolyOLD
'CASE "a": ChangePaletteOLD
'CASE "Q": InitPaletteOLD
'CASE "O": DrawOvalOLD
'            CASE "o": DrawFCircleOLD
'        CASE ELSE:
'PRINT "unknown command found: `"; char; "`"
'EndOfFile = 2
'    END SELECT
'NEXT i


'SUB ChangeColorOLD

'    GetNum
'    COLOR Num36

'END SUB

'SUB ChangeFColorOLD

'    GetNum
'    GetNum

'    FillColor = Num36

'END SUB

'SUB ChangePaletteOLD

'    GetNum
'    OldColor% = Num36
'    GetNum
'    NewColor% = Num36

'    PALETTE OldColor%, NewColor%

'END SUB

'SUB DrawCircleOLD

'    GetNum
'    col% = Num36
'    GetNum
'    row% = Num36
'    GetNum
'    radius% = Num36

'    CIRCLE (col%, row%), radius%

'END SUB

'SUB DrawDotOLD

'    UnCharacter = 1
'    GetNum
'    column% = Num36
'    GetNum
'    row% = Num36

'    LINE (column%, row%)-(column%, row%)

'    UnCharacter = 0
'END SUB

'SUB DrawFCircleOLD

'    GetNum
'    x% = Num36
'    GetNum
'    y% = Num36
'    GetNum
'    radius% = Num36
'    GetNum
'    unknown% = Num36

'    CIRCLE (x%, y%), radius%
'    PAINT (x%, y%), FillColor, FillColor

'END SUB

'SUB DrawLineOLD

'    GetNum
'    col1% = Num36
'    GetNum
'    row1% = Num36
'    GetNum
'    col2% = Num36
'    GetNum
'    row2% = Num36

'    LINE (col1%, row1%)-(col2%, row2%)

'END SUB


'SUB DrawOvalOLD

'    DIM aspect AS DOUBLE

'    GetNum
'    x% = Num36
'    GetNum
'    y% = Num36
'    GetNum
'    Ostart% = Num36
'    GetNum
'    Oend% = Num36 * (3.141592654# / 180)
'    GetNum
'    radius% = Num36
'    GetNum
'    IF (radius% = 0) THEN
'        aspect = 0
'    ELSE
'        aspect = (Num36 / radius%)
'    END IF

'    CIRCLE (x%, y%), radius%, , 0, 6.283185307#, aspect

'END SUB

'SUB DrawPolyOLD

'    GetNum
'    count% = Num36

'    GetNum
'    col1% = Num36
'    GetNum
'    row1% = Num36
'    count% = count% - 1

'    DO UNTIL (count% = 0)
'        GetNum
'        col2% = Num36
'        GetNum
'        row2% = Num36
'        LINE (col1%, row1%)-(col2%, row2%)
'        count% = count% - 1
'        col1% = col2%
'        row1% = row2%
'    LOOP

'END SUB

'SUB FillOLD

'    GetNum
'    col% = Num36
'    GetNum
'    row% = Num36
'    GetNum
'    fillborder% = Num36

'    PAINT (col%, row%), FillColor, fillborder%

'END SUB

'SUB InitPaletteOLD


'    FOR count% = 0 TO 15
'        GetNum
'        PALETTE count%, Num36
'    NEXT count%

'END SUB


