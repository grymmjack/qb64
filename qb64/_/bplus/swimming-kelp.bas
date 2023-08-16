Dim Shared sw, sh, LHead$, LBody$, LTail$, RHead$, RBody$, RTail$
sw = 1024: sh = 700
LHead$ = "<*": LBody$ = ")": LTail$ = ">{"
RHead$ = "*>": RBody$ = "(": RTail$ = "}<"
Type fish
    LFish As Integer
    X As Integer
    Y As Integer
    DX As Integer
    fish As String
    Colr As _Unsigned Long
End Type

Screen _NewImage(sw, sh, 32)

Color _RGB32(220), _RGB32(0, 0, 60)
Cls
'_PrintMode _KeepBackground
Dim As Integer i, nFish
Dim k$
nFish = 40

'restart:
ReDim Shared school(1 To nFish) As fish, kelp(sw, sh) As _Unsigned Long
growKelp
For i = 1 To nFish
    NewFish i, -1
Next

Do
    Cls
    k$ = InKey$
    'If k$ = "m" Then ' more fish
    '    nFish = nFish * 2
    '    If nFish > 300 Then Beep: nFish = 300
    '    'GoTo restart
    'End If
    'If k$ = "l" Then ' less fish
    '    nFish = nFish / 2
    '    If nFish < 4 Then Beep: nFish = 4
    '    'GoTo restart
    'End If
    For i = 1 To nFish ' draw fish behind kelp
        If _Red32(school(i).Colr) < 160 Then
            Color school(i).Colr
            _PrintString (school(i).X, school(i).Y), school(i).fish 'draw fish
            school(i).X = school(i).X + school(i).DX
            If school(i).LFish Then
                If school(i).X + Len(school(i).fish) * 8 < 0 Then NewFish i, 0
            Else
                If school(i).X - Len(school(i).fish) * 8 > _Width Then NewFish i, 0
            End If
        End If
    Next
    showKelp
    For i = 1 To nFish ' draw fish in from of kelp
        If _Red32(school(i).Colr) >= 160 Then
            Color school(i).Colr
            _PrintString (school(i).X, school(i).Y), school(i).fish 'draw fish
            school(i).X = school(i).X + school(i).DX
            If school(i).LFish Then
                If school(i).X + Len(school(i).fish) * 8 < 0 Then NewFish i, 0
            Else
                If school(i).X - Len(school(i).fish) * 8 > _Width Then NewFish i, 0
            End If
        End If
    Next

    _Display
    _Limit 10
Loop Until _KeyDown(27)

Sub NewFish (i, initTF)
    Dim gray
    gray = Rnd * 200 + 55
    school(i).Colr = _RGB32(gray) ' color
    If Rnd > .5 Then
        school(i).LFish = -1
        school(i).fish = LHead$ + String$(Int(Rnd * 5) + -2 * (gray > 160) + 1, LBody$) + LTail$
    Else
        school(i).LFish = 0
        school(i).fish = RTail$ + String$(Int(Rnd * 5) + -2 * (gray > 160) + 1, RBody$) + RHead$
    End If
    If initTF Then
        school(i).X = _Width * Rnd
    Else
        If school(i).LFish Then school(i).X = _Width + Rnd * 35 Else school(i).X = -35 * Rnd - Len(school(i).fish) * 8
    End If
    If gray > 160 Then
        If school(i).LFish Then school(i).DX = -18 * Rnd - 3 Else school(i).DX = 18 * Rnd + 3
    Else
        If school(i).LFish Then school(i).DX = -6 * Rnd - 1 Else school(i).DX = 6 * Rnd + 1
    End If
    school(i).Y = _Height * Rnd
End Sub

Sub growKelp
    Dim kelps, x, y, r
    ReDim kelp(sw, sh) As _Unsigned Long
    kelps = Int(Rnd * 20) + 20
    For x = 1 To kelps
        kelp(Int(Rnd * sw / 8), (sh - 16) / 16) = _RGB32(0, Rnd * 128, 0)
    Next
    For y = sh / 16 To 0 Step -1
        For x = 0 To sw / 8
            If kelp(x, y + 1) Then
                r = Int(Rnd * 23) + 1
                Select Case r
                    Case 1, 2, 3, 18 '1 branch node
                        If x - 1 >= 0 Then kelp(x - 1, y) = kelp(x, y + 1)
                    Case 4, 5, 6, 7, 8, 9, 21 '1 branch node
                        kelp(x, y) = kelp(x, y + 1)
                    Case 10, 11, 12, 20 '1 branch node
                        If x + 1 <= sw Then kelp(x + 1, y) = kelp(x, y + 1)
                    Case 13, 14, 15, 16, 17, 19 '2 branch node
                        If x - 1 >= 0 Then kelp(x - 1, y) = kelp(x, y + 1)
                        If x + 1 <= sw Then kelp(x + 1, y) = kelp(x, y + 1)
                End Select
            End If
        Next
    Next
End Sub

Sub showKelp
    Dim y, x
    For y = 0 To sh / 16
        For x = 0 To sw / 8
            If kelp(x, y) Then
                Color kelp(x, y)
                _PrintString (x * 8, y * 16), Mid$("kelp", Int(Rnd * 4) + 1, 1)
            End If
        Next
    Next
End Sub