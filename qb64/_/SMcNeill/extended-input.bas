ExtendedInput "{P}Enter your password =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{PL08}Enter your password (max 8 digits) =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{PL05UI}Enter your 5 digit numeric keycode =>", a$
Print
Print "Your keycode was =>"; a$

Print
Print "And without password hiding which makes the * characters:"
ExtendedInput "Enter your password =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{L08}Enter your password (max 8 digits) =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{L05UI}Enter your 5 digit numeric keycode =>", a$
Print
Print "Your keycode was =>"; a$

Print
Print "And now let's clean up after ourselves once we input something!"

ExtendedInput "{H}Enter your password =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{HL08}Enter your password (max 8 digits) =>", a$
Print
Print "Your password was =>"; a$

ExtendedInput "{HL05UI}Enter your 5 digit numeric keycode =>", a$
Print
Print "Your keycode was =>"; a$




Sub ExtendedInput (prompt$, result$) 'Over Engineered Input
    'limit VALUES:
    '1 = Unsigned
    '2 = Integer
    '4 = Float
    '8 = Who cares. It's handled via internal variables and we don't need to know a type for it.
    'Uses {} at the start of the prompt to limit possible input
    'P = Password
    'U = Unsigned
    'I = Integer
    'F = Float
    'L## = Length of max ##
    'X##, Y## = LOCATE before printing
    'D = Disable paste option
    'V = Move CTRL-V to AFTER paste
    'H = Hide Input after finished.  (Won't leave prompt, or user input on the screen.)

    PCopy 0, 1
    A = _AutoDisplay: X = Pos(0): Y = CsrLin
    OX = X: OY = Y 'original x and y positions
    CP = 0: OldCP = 0 'Cursor Position
    _KeyClear
    length_limit = -1 'unlimited length input, by default

    If Left$(prompt$, 1) = "{" Then 'possible limiter
        i = InStr(prompt$, "}")
        If i Then 'yep, we have something!
            limiter$ = UCase$(Mid$(prompt$, 2, i - 2))
            If InStr(limiter$, "U") Then limit = limit Or 1 'Unsigned
            If InStr(limiter$, "I") Then 'can't limit to BOTH an integer AND a float
                limit = limit Or 2 'Integer
            ElseIf InStr(limiter$, "F") Then
                limit = limit Or 4 'Float
                float_before_limit = KB_GetValue(limiter$, "F")
                float_after_limit = KB_GetValue(Mid$(limiter$, InStr(limiter$, "F") + 1), ".")
            End If
        End If
        If InStr(limiter$, "P") Then password_protected = -1: limit = limit Or 8 'don't show passwords.
        If InStr(limiter$, "L") Then 'Length Limitation
            limit = limit Or 8
            length_limit = KB_GetValue(limiter$, "L")
        End If
        If InStr(limiter$, "X") Then 'X position on screen
            limit = limit Or 8
            X = KB_GetValue(limiter$, "X")
        End If
        If InStr(limiter$, "Y") Then 'Y position on scren
            limit = limit Or 8
            Y = KB_GetValue(limiter$, "Y")
        End If
        If InStr(limiter$, "D") Then disable_paste = -1: limit = limit Or 8 'disable paste
        If InStr(limiter$, "V") Then cursor_after_paste = -1: limit = limit Or 8 'disable paste
        If InStr(limiter$, "H") Then clean_exit = -1: limit = limit Or 8 'hide after finished
    End If
    If limit <> 0 Then prompt$ = Mid$(prompt$, i + 1)


    Do
        PCopy 1, 0
        If _KeyDown(100307) Or _KeyDown(100308) Then AltDown = -1 Else AltDown = 0
        k = _KeyHit
        If AltDown Then
            Select Case k 'ignore all keypresses except ALT-number presses
                Case -57 To -48: AltWasDown = -1: alt$ = alt$ + Chr$(-k)
            End Select
        Else
            Select Case k 'without alt, add any keypresses to our input
                Case 8
                    oldin$ = in$
                    If CP > 0 Then OldCP = CP: CP = CP - 1
                    in$ = Left$(in$, CP) + Mid$(in$, CP + 2) 'backspace to erase input
                Case 9
                    oldin$ = in$
                    in$ = Left$(in$, CP) + Space$(4) + Mid$(in$, CP + 1) 'four spaces for any TAB entered
                    OldCP = CP
                    CP = CP + 4
                Case 32 To 128
                    If _KeyDown(100305) Or _KeyDown(100306) Then
                        If k = 118 Or k = 86 Then
                            If disable_paste = 0 Then
                                oldin$ = in$
                                temp$ = _Clipboard$
                                in$ = Left$(in$, CP) + temp$ + Mid$(in$, CP + 1) 'ctrl-v paste
                                'CTRL-V leaves cursor in position before the paste, without moving it after.
                                'Feel free to modify that behavior here, if you want it to move to after the paste.
                                If cursor_after_paste Then CP = CP + Len(temp$)
                            End If
                        End If
                        If k = 122 Or k = 90 Then Swap in$, oldin$: Swap OldCP, CP 'ctrl-z undo
                    Else
                        check_input:
                        oldin$ = in$
                        If limit And 1 Then 'unsigned
                            If k = 43 Or k = 45 Then _Continue 'remove signs +/-
                        End If
                        If limit And 2 Then 'integer
                            If k = 45 And CP = 0 Then GoTo good_input 'only allow a - sign for the first digit
                            If k < 48 Or k > 57 Then _Continue 'remove anything non-numeric
                        End If
                        If limit And 4 Then 'float
                            If k = 45 And CP = 0 Then GoTo good_input 'only allow a - sign for the first digit
                            If k = 46 And InStr(in$, ".") = 0 Then GoTo good_input 'only one decimal point
                            If k < 48 Or k > 57 Then _Continue 'remove anything non-numeric
                            If Left$(in$, 1) = "-" Then temp$ = Mid$(in$, 2) Else temp$ = in$
                            If InStr(in$, ".") = 0 Or CP < InStr(in$, ".") Then
                                If Len(temp$) < float_before_limit Or float_before_limit = -1 Then
                                    in$ = Left$(in$, CP) + Chr$(k) + Mid$(in$, CP + 1) 'add input to our string
                                    OldCP = CP
                                    CP = CP + 1
                                End If
                            Else
                                temp$ = Mid$(in$, InStr(in$, ".") + 1)
                                If Len(temp$) < float_after_limit Or float_after_limit = -1 Then
                                    in$ = Left$(in$, CP) + Chr$(k) + Mid$(in$, CP + 1) 'add input to our string
                                    OldCP = CP
                                    CP = CP + 1
                                End If
                            End If
                            _Continue
                        End If
                        good_input:
                        If CP < length_limit Or length_limit < 0 Then
                            in$ = Left$(in$, CP) + Chr$(k) + Mid$(in$, CP + 1) 'add input to our string

                            OldCP = CP
                            CP = CP + 1
                        End If
                    End If
                Case 18176 'Home
                    CP = 0
                Case 20224 'End
                    CP = Len(in$)
                Case 21248 'Delete
                    oldin$ = in$
                    in$ = Left$(in$, CP) + Mid$(in$, CP + 2)
                Case 19200 'Left
                    CP = CP - 1
                    If CP < 0 Then CP = 0
                Case 19712 'Right
                    CP = CP + 1
                    If CP > Len(in$) Then CP = Len(in$)
            End Select
        End If
        alt$ = Right$(alt$, 3)
        If AltWasDown = -1 And AltDown = 0 Then
            v = Val(alt$)
            If v >= 0 And v <= 255 Then
                k = v
                alt$ = "": AltWasDown = 0
                GoTo check_input
            End If
        End If
        blink = (blink + 1) Mod 30
        Locate Y, X
        p$ = prompt$
        If password_protected Then
            p$ = p$ + String$(Len(Left$(in$, CP)), "*")
            If blink \ 15 Then p$ = p$ + " " Else p$ = p$ + "_"
            p$ = p$ + String$(Len(Mid$(in$, CP + 1)), "*")
        Else
            p$ = p$ + Left$(in$, CP)
            If blink \ 15 Then p$ = p$ + " " Else p$ = p$ + "_"
            p$ = p$ + Mid$(in$, CP + 1)
        End If
        $If FALCON = TRUE Then
                QPrint p$
        $Else
            Print p$
        $End If 

        _Display
        _Limit 30
    Loop Until k = 13

    PCopy 1, 0
    Locate OY, OX
    If clean_exit = 0 Then
        Locate Y, X
        If password_protected Then
            p$ = prompt$ + String$(Len(in$), "*")
        Else
            p$ = prompt$ + in$
        End If
        $If FALCON = TRUE Then
                QPrint p$
        $Else
            Print p$
        $End If 
    End If
    result$ = in$
    If A Then _AutoDisplay
End Sub


Function KB_GetValue (limiter$, what$)
    jstart = InStr(limiter$, what$): j = 0
    If Mid$(limiter$, InStr(limiter$, what$) + 1, 1) = "-" Then
        GetValue = -1 'unlimited
        Exit Function
    End If

    Do
        j = j + 1
        m$ = Mid$(limiter$, jstart + j, 1)
    Loop Until m$ < "0" Or m$ > "9"
    KB_GetValue = Val(Mid$(limiter$, jstart + 1, j - 1))
End Function
