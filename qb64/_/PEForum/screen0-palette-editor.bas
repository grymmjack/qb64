DefInt A-Z
Dim Shared RGB(0 To 47) As Integer ' Huidige kleurenpalet
Dim Shared oRGB(0 To 47) As Integer 'Oud kleurenpalet
Dim Shared Abc$(4, 6)
Dim Shared Bar$, PLinks$, PRechts$, Bestand$, Map$, ProgNaam$, Versie$, Ikke$
Dim Shared vKleur, Kleur

Randomize Timer

vKleur = 0: Kleur = 0
Bar$ = Chr$(221)
PLinks$ = Chr$(17) + Chr$(196): PRechts$ = Chr$(196) + Chr$(16)

Screen _NewImage(100, 38, 0)
Cls
_Blink Off
LeesABC
LeesRGB
TekenScherm
ZetKader Kleur, 1
ZetRGB Kleur

Terug:
Do
    k$ = InKey$
    Do While _MouseInput
        x = _MouseX: y = _MouseY
        If x >= 3 And x <= 97 And y >= 7 And y <= 18 Then ' Klik op de kleuren
            If _MouseButton(1) Then
                Do: td = _MouseInput: Loop While _MouseButton(1)
                ZetKader Kleur, 0
                r = Fix((y - 7) / 7) * 8: K = Fix((x - 3) / 12): Kleur = r + K
                Color Kleur, 0: vKleur = Kleur
                ZetKader Kleur, 1
                ZetRGB Kleur
            End If
        Else If x >= 9 And x <= 92 And y >= 27 And y <= 35 Then ' Klik op de schuifbalken
                If _MouseButton(1) Then ' Wijzig 1 kleur
                    'DO: td = _MOUSEINPUT: LOOP WHILE _MOUSEBUTTON(1)
                    r = Fix((y - 27) / 3): K = Fix((x * 255) / 83) - 27
                    RGB((Kleur * 3) + r) = K
                    _PaletteColor Kleur, _RGB32(RGB((Kleur * 3)), RGB((Kleur * 3) + 1), RGB((Kleur * 3) + 2))
                    ZetRGB Kleur
                ElseIf _MouseButton(2) Then ' Wijzig alle kleuren samen
                    K = Fix((x * 255) / 83) - 27
                    For xx = 0 To 2: RGB((Kleur * 3) + xx) = K: Next
                    _PaletteColor Kleur, _RGB32(RGB((Kleur * 3)), RGB((Kleur * 3) + 1), RGB((Kleur * 3) + 2))
                    ZetRGB Kleur
                End If
            Else If y = 38 Then ' Klik op onderste balk
                    If _MouseButton(1) Then
                        x = _MouseX
                        If x >= 90 Then k$ = Chr$(27): Exit Do 'ESC
                        If x >= 1 And x <= 10 Then k$ = Chr$(0) + Chr$(59): Exit Do 'F1
                        If x >= 11 And x <= 21 Then k$ = Chr$(0) + Chr$(60): Exit Do 'F2
                        If x >= 22 And x <= 33 Then k$ = Chr$(0) + Chr$(61): Exit Do 'F3
                        If x >= 34 And x <= 45 Then k$ = Chr$(0) + Chr$(62): Exit Do 'F4
                        If x >= 46 And x <= 60 Then k$ = Chr$(0) + Chr$(63): Exit Do 'F5
                        If x >= 61 And x <= 89 Then k$ = Chr$(0) + Chr$(134): Exit Do 'F12
                    End If
                End If
            End If
        End If
    Loop
Loop Until k$ <> ""
MuisLos
Select Case k$
    Case Chr$(27)
        Cls: System
    Case Chr$(0) + Chr$(59) 'F1=View
        F1View
        TekenScherm
    Case Chr$(0) + Chr$(60) 'F2=New
        F2New
    Case Chr$(0) + Chr$(61) 'F3=Load
        F3Load
    Case Chr$(0) + Chr$(62) 'F4=Save
        F4Save
    Case Chr$(0) + Chr$(63) 'F5=Restore
        F5Restore
    Case Chr$(0) + Chr$(134) 'F12=About
        F12About
End Select
k$ = "": MuisLos: GoTo Terug

Sub F1View
    F1_scherm1:
    ZetHoofding
    b$ = String$(12, 219)
    For r = 4 To 20
        fc = 0
        For k = 3 To 87 Step 12
            Locate r, k: Color fc, 0: Print b$;: fc = fc + 1
        Next
    Next
    For r = 21 To 36
        fc = 8
        For k = 3 To 87 Step 12
            Locate r, k: Color fc, 0: Print b$;: fc = fc + 1
        Next
    Next
    fc = 8
    For k = 3 To 87 Step 12
        Locate 37, k: Color fc, 0: Print String$(12, 223);: fc = fc + 1
    Next
    r = 5: k = 7: Color 1, 7
    For n = 0 To 15
        Locate r, k: Print " "; Right$("0" + LTrim$(Str$(n)), 2); " ";
        k = k + 12
        If n = 7 Then k = 7: r = 22
    Next

    ZetInfo "  Press ANY key for next screen", 1
    a$ = AnyKey$
    If a$ = Chr$(27) Then Exit Sub
    F1_Scherm2:
    ZetHoofding
    r = 6: k = 4
    For B = 0 To 15
        Locate r, k: Color 7, 0
        For f = 0 To 15
            bc = B
            fc = f
            If B > 7 Then fc = fc Or 16
            Color 7, 0: Print " ";
            Color fc, bc: Print Right$(" " + Str$(fc), 2); ","; Right$(" " + Str$(bc), 2);
        Next
        r = r + 2
    Next
    Color 0, 3: A = 0: Locate 4, 2: Print Space$(98);
    For k = 6 To 97 Step 6
        Locate 4, k: Print Str$(A);: A = A + 1
    Next
    A = 0
    For r = 5 To 36
        Locate r, 2
        If r And Not -2 Then
            Print "  ";
        Else
            Print Right$(" " + Str$(A), 2);: A = A + 1
        End If
    Next
    ZetInfo "  Press ANY key for next screen", 1
    a$ = AnyKey$
    If a$ = Chr$(27) Then Exit Sub
    ZetHoofding
    Color 15, 0: Locate 5, 2: Print "Foreground Color:";: Locate 13, 2: Print "Background Color:";
    ZetKleurenbar 7: ZetKleurenbar 15
    Center 36, "Move the mouse over the foreground and background colors to see the effect."
    ZetInfo "  Press ANY key for next screen, position the mouse over a color", 1
    fc = 3: bc = 0: ofc = 3: obc = 0
    GoSub F1_Terug1
    eruit = 0
    Do
        k$ = InKey$
        Do While _MouseInput
            x = _MouseX: y = _MouseY
            If x >= 3 And x <= 97 And y >= 7 And y <= 10 Then
                'foreground color
                fc = Fix((x - 3) / 6)
                If bc > 7 Then fc = fc Or 16 Else If fc > 15 Then fc = fc - 16
            End If
            If x >= 3 And x <= 97 And y >= 15 And y <= 18 Then
                'background color
                bc = Fix((x - 3) / 6)
                If bc > 7 Then fc = fc Or 16 Else If fc > 15 Then fc = fc - 16
            End If
            If y = 38 And _MouseButton(1) Then k$ = Chr$(27): Exit Do
            If obc <> bc Or ofc <> fc Then GoSub F1_Terug1
        Loop
    Loop Until k$ <> ""
    If k$ <> Chr$(27) Then GoTo F1_scherm1
    Exit Sub 'ESC gedrukt

    F1_Terug1:
    Color 15, 0: Locate 5, 19: Print fc;: Locate 13, 19: Print bc;
    Color fc, bc
    For r = 21 To 34
        Locate r, 1: Print Space$(100);
    Next

    For A = 1 To 26
        Locate 23, 12 + (A * 2): Print Chr$(64 + A);
        Locate 25, 12 + (A * 2): Print Chr$(96 + A);
    Next
    For A = 0 To 9
        Locate 23, 68 + (A * 2): Print Chr$(48 + A);
        Locate 25, 68 + (A * 2): Print Chr$(38 + A);
    Next
    Locate 27, 14: Print "ÚÄÄÂÄÄ¿                                                          ÉÍÍËÍÍ»"
    Locate 28, 14: Print "³  ³  ³      ÛßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÛ      º  º  º"
    Locate 29, 14: Print "ÃÄÄÅÄÄ´      Û THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG Û      ÌÍÍÎÍÍ¹"
    Locate 30, 14: Print "³  ³  ³      ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛ      º  º  º"
    Locate 31, 14: Print "ÀÄÄÁÄÄÙ                                                          ÈÍÍÊÍÍ¼"
    Locate 33, 14: Print " °°°±±±²²²ÛÛÛ  the quick brown fox jumps over the lazy dog  ÛÛÛ²²²±±±°°°"
    obc = bc: ofc = fc
    Return

End Sub


Sub F2New
    MuisLos
    ZetKader vKleur, 0
    For A = 0 To 15
        red = Int(Rnd * 256)
        green = Int(Rnd * 256)
        blue = Int(Rnd * 256)
        RGB(A * 3) = red
        RGB((A * 3) + 1) = green
        RGB((A * 3) + 2) = blue
        _PaletteColor A, _RGB32(red, green, blue)
    Next
    Kleur = 0: vKleur = 0
    ZetKader Kleur, 1
    ZetRGB Kleur
End Sub

Sub F3Load
    Bestand$ = "": MuisLos
    Bestand$ = _OpenFileDialog$("Open File", "", "*.pal", "Palette files", -1)
    If Bestand$ <> "" Then
        ' Lees file in + toepassen
        ff = FreeFile
        Open Bestand$ For Input As #ff
        For A = 0 To 47: Input #ff, RGB(A): Next
        Close ff
        For A = 0 To 15
            red = RGB(A * 3)
            green = RGB((A * 3) + 1)
            blue = RGB((A * 3) + 2)
            _PaletteColor A, _RGB32(red, green, blue)
        Next
        Kleur = 0: vKleur = 0
        ZetKader Kleur, 1
        ZetRGB Kleur
        _MessageBox "Information", "File " + Bestand$ + " loaded."
    End If

End Sub


Sub F4Save
    Bestand$ = "": MuisLos
    Bestand$ = _SaveFileDialog$("Save File", "", "*.pal", "Palette files")
    If Bestand$ <> "" Then
        'Bewaar als .PAL bestand
        ff = FreeFile
        Open Bestand$ For Output As #ff
        For A = 0 To 47: Print #ff, RGB(A): Next
        Close ff
        'Bewaar als .BI bestand
        Bestand1$ = Bestand$ + ".BI": t$ = ""
        ff = FreeFile
        Open Bestand1$ For Output As #ff
        Print #ff, ";"
        Print #ff, ";  Use this file in your BASIC program."
        Print #ff, ";  You can edit the colors in 'Palette', a Palette Editor written by " + Ikke$ + "."
        Print #ff, ";"
        For A = 0 To 15
            red = RGB(A * 3)
            green = RGB((A * 3) + 1)
            blue = RGB((A * 3) + 2)
            t$ = "_PaletteColor" + Str$(A) + ", _RGB32(" + Str$(red) + "," + Str$(green) + "," + Str$(blue) + ")"
            Print #ff, t$
        Next
        Close ff
        _MessageBox "Information", "File will be saved to " + Bestand$ + " (for use with this program)" + Chr$(10) + Chr$(13) + "and is saved to " + Bestand1$ + " to import in your program."
    End If
End Sub



Sub F5Restore
    ZetKader vKleur, 0
    For A = 0 To 47
        RGB(A) = oRGB(A)
    Next
    For A = 0 To 15
        red = RGB(A * 3)
        green = RGB((A * 3) + 1)
        blue = RGB((A * 3) + 2)
        _PaletteColor A, _RGB32(red, green, blue)
    Next
    Kleur = 0: vKleur = 0
    ZetKader Kleur, 1
    ZetRGB Kleur
    MuisLos
End Sub

Sub F12About
    MuisLos
    'Normale kleuren herstellen
    For A = 0 To 15
        red = oRGB(A * 3)
        green = oRGB((A * 3) + 1)
        blue = oRGB((A * 3) + 2)
        _PaletteColor A, _RGB32(red, green, blue)
    Next
    Color 7, 0: Cls
    For r = 0 To 4
        For k = 0 To 6
            Locate r + 11, 24 + (k * 8)
            For t = 1 To 7
                c$ = Mid$(Abc$(r, k), t, 1)
                If c$ = Chr$(222) Then Color 8, 0 Else Color 9 + k, 0
                Print c$;
            Next
            Print " ";
        Next
    Next
    Color 15, 0: Center 17, ProgNaam$ + ", version " + Versie$
    Center 18, "Written by " + Ikke$ + ", Bruges, Belgium"
    Color 7, 0: Center 23, "Palette was developed in QB64. To save or read the files I wanted to use the"
    Center 24, "standard Windows Open/Save interface. Therefore, the project was continued in QB64PE."
    Center 25, "The reason was also that I suddenly didn't feel like programming everything"
    Center 26, "with retrieving files etc. I have no idea if this program will ever be used,"
    Center 27, "but I had fun programming it again."
    Center 28, "The design of the screens was done in advance with Moebius, an ANSI and ASCII Editor."
    Center 31, "Press [S] to switch between fullscreen or window"
    Center 32, "Settings are saved in " + _CWD$ + "\palette.cfg"
    Color 14, 0: Center 38, "Press ANY key to continue..."
    a$ = AnyKey$
    If a$ = "s" Or a$ = "S" Then
        If _FullScreen = 0 Then
            _FullScreen _Stretch , _Smooth
        Else
            _FullScreen _Off
        End If
        ff = FreeFile
        Open _CWD$ + "\palette.cfg" For Output As #ff
        Print #ff, _FullScreen
        Close ff
    End If

    'Naar huidig palet
    For A = 0 To 15
        red = RGB(A * 3)
        green = RGB((A * 3) + 1)
        blue = RGB((A * 3) + 2)
        _PaletteColor A, _RGB32(red, green, blue)
    Next
    TekenScherm
    ZetKader Kleur, 1
    ZetRGB Kleur
    MuisLos

End Sub




Sub ZetKader (co, t)
    '
    ' Teken kader rond kleur
    ' co = kleur
    ' t = 0: spaties, anders dubbele lijn
    '
    sKleur = co
    If sKleur < 8 Then r = 6 Else r = 13: sKleur = sKleur - 8
    K = Fix(sKleur * 12) + 3
    Locate r, K: Color 7, 0
    If t = 0 Then
        Print Space$(12);
        Locate r + 6, K: Print Space$(12);
    Else
        Print Chr$(201); String$(10, 205); Chr$(187);
        Locate r + 6, K: Print Chr$(200); String$(10, 205); Chr$(188);
    End If
    For A = r + 1 To r + 5
        Locate A, K
        If t = 0 Then
            Print " ";: Locate A, K + 11: Print " ";
        Else
            Print Chr$(186);: Locate A, K + 11: Print Chr$(186);
        End If
    Next
    Color Kleur, 0
    For r = 21 To 25
        Locate r, 28: Print String$(49, 219);
    Next

End Sub

Sub TekenScherm
    '
    ' Teken het hoofdscherm
    '
    ZetHoofding
    Color 7, 0
    Center 4, "Click with the mouse on the color, then you can change the color with the 3 sliders."
    Center 5, "Use the right mouse button to move all sliders together."

    For r = 7 To 11
        c = 0
        For K = 4 To 98 Step 12
            Locate r, K: Color c, 0: Print String$(10, 219);
            c = c + 1
        Next
    Next
    For r = 14 To 18
        c = 8
        For K = 4 To 98 Step 12
            Locate r, K: Color c, 0: Print String$(10, 219);
            c = c + 1
        Next
    Next

    Color 15, 0: Locate 28, 2: Print "  Red";: Locate 31, 2: Print "Green";: Locate 34, 2: Print " Blue";
    Color 7, 0
    For r = 28 To 34 Step 3
        Locate r, 8: Print Chr$(204); String$(84, 205); Chr$(185); " 123 "; Chr$(186);
        Locate r - 1, 93: Print Chr$(201); String$(5, 205); Chr$(187);
        Locate r + 1, 93: Print Chr$(200); String$(5, 205); Chr$(188);
    Next
    Locate 20, 27: Print Chr$(218); String$(49, 196); Chr$(191);
    For r = 21 To 25
        Locate r, 27: Print Chr$(179); Space$(49); Chr$(179);
    Next
    Locate 26, 27: Print Chr$(192); String$(49, 196); Chr$(217);
    ZetInfo " #F1#=View  +  #F2#=RND  +  #F3#=Load  +  #F4#=Save  +  #F5#=Restore  +        #F12#=About", 0

End Sub

Sub ZetHoofding
    Color 7, 0: Cls
    Color 0, 7: Print String$(100, 223);
    Locate 2, 1: Print Space$(100);: Locate 2, 39: Color 1, 7: Print "*** P A L E T T E  ***";
    Locate 3, 1: Color 0, 7: Print String$(100, 220);
End Sub


Sub LeesRGB
    '
    ' Lees huidig kleurenpalet en plaats ze in RGB() en in oRGB()
    '
    For c& = 0 To 15
        value32& = _PaletteColor(c&, 0) 'sets color value to read of an image page handle.
        red% = _Red32(value32&)
        green% = _Green32(value32&)
        blue% = _Blue32(value32&)
        RGB(c& * 3) = red%: RGB((c& * 3) + 1) = green%: RGB((c& * 3) + 2) = blue%
        oRGB(c& * 3) = red%: oRGB((c& * 3) + 1) = green%: oRGB((c& * 3) + 2) = blue%
    Next
End Sub

Sub ZetRGB (sKleur)
    '
    ' Zet de RGB kleuren nummers op scherm en pas de schuifbars aan
    '
    Color 7, 0: Kl = sKleur * 3
    Locate 28, 94: Print "    ";: Locate 28, 94: Print Str$(RGB(Kl));
    Locate 31, 94: Print "    ";: Locate 31, 94: Print Str$(RGB(Kl + 1));
    Locate 34, 94: Print "    ";: Locate 34, 94: Print Str$(RGB(Kl + 2));
    Color 7, 0: Locate 28, 9: Print String$(84, 205);: Color 15, 0: Locate 28, 9 + Fix((RGB(Kl) / 256) * 84): Print Chr$(219);
    Color 7, 0: Locate 31, 9: Print String$(84, 205);: Color 15, 0: Locate 31, 9 + Fix((RGB(Kl + 1) / 256) * 84): Print Chr$(219);
    Color 7, 0: Locate 34, 9: Print String$(84, 205);: Color 15, 0: Locate 34, 9 + Fix((RGB(Kl + 2) / 256) * 84): Print Chr$(219);
End Sub

Sub ZetInfo (t$, l)
    '
    ' Zet info op onderste rij
    ' t$= string met commando's
    '    # switch van zwart naar rood
    '    + scheidingsbar plaatsen (ascii nr 221)
    '    tekst = tekst
    ' l = 0: op kolom 90 komt | ESC=Quit
    ' l = 1: op kolom 90 komt | ESC=Back
    '
    zko = 1 'kolom
    zkl = 0 'kleur
    Locate 38, 1: Color 0, 3: Print Space$(89); Bar$; " ";: Color 4, 3: Print "ESC";: Color 0, 3
    If l = 0 Then Print "=Quit "; Else Print "=Back ";
    For A = 1 To Len(t$)
        Locate 38, zko
        c$ = Mid$(t$, A, 1)
        If c$ = "+" Then c$ = Chr$(221)
        If c$ = "#" Then If zkl = 0 Then zkl = 4 Else zkl = 0
        If c$ <> "#" Then Color zkl, 3: Print c$;: zko = zko + 1
    Next
End Sub

Sub ZetKleurenbar (rij)
    For r = rij To rij + 3
        zKL = 0
        For k = 4 To 94 Step 6
            Locate r, k: Color zKL, 0: Print String$(4, 219);
            zKL = zKL + 1
        Next
    Next
End Sub


Sub Center (rij, txt$)
    Locate rij, 50 - (Len(txt$) \ 2): Print txt$;
End Sub

Sub LeesABC
    Dim xyz$(5)
    xyz$(0) = "1222222122222212200001222222122222212222221222222"
    xyz$(1) = "1220122122012212200001220000001220000122001220000"
    xyz$(2) = "1222222122222212200001222200001220000122001222200"
    xyz$(3) = "1220000122012212200001220000001220000122001220000"
    xyz$(4) = "1220000122012212222221222222001220000122001222222"
    xyz$(5) = "1120029906042100041719150011041919040112100120122"
    Versie$ = "1.0": ProgNaam$ = "": Ikke$ = ""
    For r = 0 To 4
        For k = 1 To Len(xyz$(r))
            c$ = Mid$(xyz$(r), k, 1)
            If c$ = "0" Then c$ = Chr$(32)
            If c$ = "1" Then c$ = Chr$(222)
            If c$ = "2" Then c$ = Chr$(219)
            Mid$(xyz$(r), k, 1) = c$
        Next
    Next
    For r = 0 To 4
        For k = 1 To 43 Step 7
            Abc$(r, Fix((k - 1) / 7)) = Mid$(xyz$(r), k, 7)
        Next
    Next
    c$ = "": r = 0
    For a = 1 To 11
        If a = 1 Or a = 5 Then r = 65 Else r = 97
        c$ = c$ + Chr$(r + Val(Mid$(xyz$(5), (a * 2) - 1, 2)))
    Next
    Mid$(c$, 4, 1) = " ": Ikke$ = c$
    c$ = "": r = 0
    For a = 1 To 7
        If a = 1 Then r = 65 Else r = 97
        c$ = c$ + Chr$(r + Val(Mid$(xyz$(5), 21 + (a * 2), 2)))
    Next
    ProgNaam$ = c$
    For r = 0 To 4
        For k = 0 To 6
            Locate r + 13, 24 + (k * 8)
            For t = 1 To 7
                c$ = Mid$(Abc$(r, k), t, 1)
                If c$ = Chr$(222) Then Color 8, 0 Else Color 9 + k, 0
                Print c$;
            Next
            Print " ";
        Next
    Next
    '*** fullscreen?
    a$ = _CWD$ + "\palette.cfg"
    If _FileExists(a$) Then
        ff = FreeFile
        Open a$ For Input As #ff
        Input #ff, r
        Close ff
        If r <> 0 Then
            _FullScreen _Stretch , _Smooth
        Else
            _FullScreen _Off
        End If
    End If
    _Title "*** " + ProgNaam$ + " ***"
    Center 22, "*** " + ProgNaam$ + " ***"
    Center 23, "Version " + Versie$
    Center 24, "This is a VGA palette editor"
    Center 25, "Written in 2022 by " + Ikke$
    Center 38, "Press ANY key to start"
    a$ = AnyKey$
End Sub

Sub MuisLos
    Do While _MouseInput '      Check the mouse status
        Do:
            tmp = _MouseInput
        Loop Until Not _MouseButton(1)
    Loop
End Sub

Function AnyKey$ ()
    MuisLos
    Do
        xx$ = InKey$
        Do While _MouseInput
            If _MouseButton(1) Then xx$ = " ": Exit Do
        Loop
    Loop Until xx$ <> ""
    MuisLos
    AnyKey$ = xx$
End Function