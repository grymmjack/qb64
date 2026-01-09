Do
    _Limit 30
    k = _KeyHit
    c$ = InKey$
    If k > 0 Then Cls
    InkeyVert b$, k, kp, alt, ctrl
    If alt Then Locate 1, 1: Print "Alt Down...";
    If ctrl Then Locate 1, 1: Print "Ctrl Down...";
    If kp Then Locate 2, 1: Print "Keyhit Value:   "; kp; Space$(15);
    If Len(b$) = 1 Then Locate 3, 1: Print "KeyHit Conversion: "; b$; "  ("; LTrim$(Str$(Asc(b$))); ")"; Space$(15);
    If Len(b$) = 2 Then Locate 3, 1: Print "KeyHit Conversion: "; "Chr$(0) + "; b$; "  ("; LTrim$(Str$(Asc(Right$(b$, 1)))); ")"; Space$(15);
    If Len(c$) = 1 Then Locate 4, 1: Print "Inkey$ Comparison: "; c$; "  ("; LTrim$(Str$(Asc(c$))); ")"; Space$(15);
    If Len(c$) = 2 Then Locate 4, 1: Print "Inkey$ Comparison: "; "Chr$(0) + "; c$; "  ("; LTrim$(Str$(Asc(Right$(c$, 1)))); ")"; Space$(15);
    If Len(c$) And kp And b$ <> c$ Then Locate 15, 1: Print "Mismatch! Enter to resume... KeyHitConvert$ = "; b$; "  Inkey$ = "; c$; "        ";: Sound 100, 1: Do: _Limit 10: Loop Until InKey$ = Chr$(13): _KeyClear: _Delay .5: Cls
Loop
 
Sub InkeyVert (b$, k, kp, alt, ctrl)
    Static initiate, AltNumMap$, AltShiftNumMap$
    If initiate = 0 Then
        initiate = _TRUE
        _ControlChr Off
        AltNumMap$ = "œ®¬žŸ ¡•¢£¤°¯–—Ž‘’”­«“ª      œ®¬žŸ ¡•¢£¤°¯–—Ž‘’”­«“ª"
        AltShiftNumMap$ = "!@#$%^&*()"
    End If
    b$ = ""
    Select Case k
        Case -100306 To -100305, 100305 To 100306 ' Ctrl
            If k > 0 Then ctrl = 1 Else ctrl = 0: Locate 1, 1: Print Space$(15);
        Case -100308 To -100307, 100307 To 100308 ' Alt
            If k > 0 Then alt = 1 Else alt = 0: Locate 1, 1: Print Space$(15);
        Case -255 To -32, 32 To 255
            If k > 0 Then kp = k Else kp = 0
            If kp Then b$ = Chr$(kp)
        Case Else
            If k > 0 Then kp = k Else kp = 0
            If kp Then
                If kp \ 256 < 255 Then
                    If kp < 10000 Then
                        b$ = Chr$(kp) ' Example: Tab key.
                    Else
                        b$ = Chr$(0) + Chr$(kp \ 256)
                    End If
                Else
                    Locate 3, 1: Print Space$(_Width * 2); ' CapsLock
                End If
            End If
    End Select
    If alt And kp <> 0 And kp < 100000 Then
        Select Case kp
            Case 65 To 90, 97 To 122 '                               A - Z and a - z
                x$ = Chr$(Asc(Mid$(AltNumMap$, kp - 64, 1)) - 126)
                b$ = Chr$(0) + x$
            Case 15104 To 17408 '                                    F1 - F10
                b$ = Chr$(0) + Chr$(kp \ 256 + 45)
            Case 34048, 34304 '                                      F11 and F12
                b$ = Chr$(0) + Chr$(kp \ 256 + 6)
            Case 48
                b$ = Chr$(0) + Chr$(129) '                           0
            Case 49 To 57 '                                          1 - 9
                b$ = Chr$(0) + Chr$(kp + 71)
            Case 33, 64, 35, 36, 37, 94, 38, 42, 40, 41
                x$ = AltShiftNumMap$
                b$ = Chr$(0) + Chr$(119 + InStr(x$, Chr$(kp)))
            Case 18176 To 21248 '                                    Insert, Delete, Home, End, Page and Arrow Keys.
                b$ = Chr$(0) + Chr$(kp \ 256 + 80)
            Case 8: b$ = Chr$(0) + Chr$(14) '                        Backspace
            Case 32: b$ = "" '                                       (Space) with and without Shift has no conversion.
            Case 126, 96: b$ = Chr$(0) + Chr$(41) '                  ~ `
            Case 95, 45: b$ = Chr$(0) + Chr$(130) '                  _ -
            Case 43, 61: b$ = Chr$(0) + Chr$(131) '                  + =
            Case 123, 91: b$ = Chr$(0) + Chr$(26) '                  { [
            Case 125, 93: b$ = Chr$(0) + Chr$(27) '                  } ]
            Case 124, 92: b$ = Chr$(0) + Chr$(43) '                  | \
            Case 58, 59: b$ = Chr$(0) + Chr$(39) '                   : ;
            Case 34, 39: b$ = Chr$(0) + Chr$(40) '                   " '
            Case 60, 44: b$ = Chr$(0) + Chr$(51) '                   < ,
            Case 62, 46: b$ = Chr$(0) + Chr$(52) '                   > .
            Case 63, 47: b$ = Chr$(0) + Chr$(53) '                   ? /
            Case Else
                Locate 7, 1: Print "Pete missed something! Enter to resume... k =", k: Sound 100, 1: Do: _Limit 10: Loop Until InKey$ = Chr$(13): _KeyClear: _Delay .5: Cls
        End Select
    End If
    If ctrl And kp <> 0 And kp < 100000 Then
        Locate 1, 1: Print "Ctrl Down...";
        Select Case kp
            Case 0 To 12, 14 To 32
                b$ = Chr$(kp) '                      Example: Ctrl + "{" or "[".
            Case 13 '                                Examples: Ctrl + J or Ctrl + Enter.
                b$ = Chr$(10)
            Case 65 To 90, 97 To 122 '               Example: Most Ctrl combos.
                b$ = Chr$(kp Mod 32)
            Case 15000 To 17408
                b$ = Chr$(0) + Chr$(kp \ 256 + 35) ' F1 - F10
            Case 34048 To 34304 '                    F11 - F12
                b$ = Chr$(0) + Chr$(kp \ 256 + 4)
            Case 18176 '                             Home
                b$ = Chr$(0) + Chr$(119)
            Case 18688 '                             PgUp
                b$ = Chr$(0) + Chr$(132)
            Case 20224 '                             End
                b$ = Chr$(0) + Chr$(117)
            Case 20736 '                             PgDn
                b$ = Chr$(0) + Chr$(118)
            Case 20992 '                             Insert
                b$ = Chr$(0) + Chr$(146)
            Case 18432 '                             Arrow Up
                b$ = Chr$(0) + Chr$(141)
            Case 19200 '                             Arrow Lt
                b$ = Chr$(0) + Chr$(115)
            Case 19712 '                             Arrow Rt
                b$ = Chr$(0) + Chr$(116)
            Case 20480 '                             Arrow Dn
                b$ = Chr$(0) + Chr$(145)
            Case 21248 '                             Example: Ctrl + Backspace or Ctrl + Delete - Both are 21248.
                b$ = Chr$(0) + Chr$(kp \ 256 + 64)
            Case Else
                Locate 7, 1: Print "Pete missed something! Enter to resume... k =", k: Sound 100, 1: Do: _Limit 10: Loop Until InKey$ = Chr$(13): _KeyClear: _Delay .5: Cls
        End Select
    End If
End Sub