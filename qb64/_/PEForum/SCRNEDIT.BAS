Rem Snall full screen editor for QB v1.0a 08/20/2022 PD.

DECLARE SUB Scrnedit (OutX$)
DECLARE SUB InstrSUB1 (Var!, Var1$, Var2$, VarQ!)
DECLARE FUNCTION IsNumeric! (X$)
DECLARE SUB Back.Space ()
DECLARE SUB Dot.Display (VarA!, VarB!, VarC!)
DECLARE FUNCTION FormatString$ (s#)
DECLARE SUB Amount (Var#, Var$)
DECLARE SUB Edit.Status.Line ()
DECLARE SUB Display.Status.Line (Var!, Var$)

Color 15
Print "Enter filename";
Input X$
If Len(X$) Then
   Call Scrnedit(X$)
End If
Color 7, 0
End

timer1:
X = CsrLin: Y = Pos(0)
TempX$ = "Editor > time: " + Date$ + " " + Time$
TempX$ = Left$(TempX$, 79)
TempX$ = TempX$ + Space$(79 - Len(TempX$))
Call Display.Status.Line(-1, TempX$)
Locate X, Y, 1
Return

Sub Amount (Var#, Var$)
   If Var# = 0# Then
      Var$ = " 0"
   Else
      If InStr(Str$(Var#), "D") Then
         Var$ = Str$(Var#)
      Else
         Var$ = " " + FormatString$(Var#)
      End If
   End If
End Sub

Sub Back.Space
   Locate CsrLin, Pos(0) - 1, 0
   Print " ";
   Locate CsrLin, Pos(0) - 1, 1
End Sub

' display status line
Sub Display.Status.Line (Var, Var$)
   Max.Row = 25
   If Var Then
      Color 14, 1
   Else
      Color 15, 0
   End If
   Locate Max.Row, 1, 0
   Print Var$;
   Locate Max.Row, 80
   If Var Then
      Color 0, 1
   Else
      Color 7, 0
   End If
   Print " ";
   Locate Max.Row - 1, 1, 1
   Color 15, 0
End Sub

Sub Dot.Display (VarA, VarB, VarC!)
   VarG! = Timer - VarC!
   If VarG! >= 1! Then
      VarC! = Timer
      If VarA = False Then
         VarB = VarB + 1
         Print ".";
         If VarB = 5 Then
            VarA = True
            VarB = False
         End If
      Else
         VarB = VarB + 1
         Call Back.Space
         Print " ";
         Call Back.Space
         If VarB = 5 Then
            VarA = False
            VarB = False
         End If
      End If
   End If
End Sub

' display editor status line
Sub Edit.Status.Line
   TempX$ = "Editor > time: " + Date$ + " " + Time$
   TempX$ = Left$(TempX$, 79)
   TempX$ = TempX$ + Space$(79 - Len(TempX$))
   Call Display.Status.Line(-1, TempX$)
End Sub

' formats a double numeric string
Function FormatString$ (s#)
   X$ = ""
   s$ = Str$(s#)
   If InStr(s$, "D") Then ' return string
      FormatString$ = s$
      Exit Function
   End If
   If Left$(s$, 1) = "-" Then ' store sign
      e$ = "-"
      s$ = Mid$(s$, 2)
   End If
   s$ = LTrim$(s$) ' format string
   If InStr(s$, ".") Then
      q$ = Mid$(s$, InStr(s$, "."))
      s$ = Left$(s$, InStr(s$, ".") - 1)
   End If
   For l = Len(s$) To 3 Step -3
      X$ = Mid$(s$, l - 2, 3) + "," + X$
   Next
   If l > 0 Then
      X$ = Mid$(s$, 1, l) + "," + X$
   End If
   If Len(s$) < 3 Then
      X$ = s$
   End If
   If Right$(X$, 1) = "," Then
      X$ = Left$(X$, Len(X$) - 1)
   End If
   X$ = e$ + X$ + q$ ' construct string
   FormatString$ = X$
End Function

' function to match case-sensitive substring with ?, * characters in substring
'  Return Var = -1 if match
'  VarQ = -1 force case-sensitive
'  See if Var1$ exists in Var2$
Sub InstrSUB1 (Var, Var1$, Var2$, VarQ)

   ' store case-sensitive string match variables
   If VarQ Then
      S2$ = Var1$
      S3$ = Var2$
   Else
      S2$ = LCase$(Var1$)
      S3$ = LCase$(Var2$)
   End If

   ' check default instr
   If InStr(S2$, "*") = 0 Then
      If InStr(S2$, "?") = 0 Then
         Var = InStr(S3$, S2$)
         Exit Sub
      End If
   End If

   Var = -1 ' assume match

   ' see if S2$ matches in S3$ with substrings
   For S3 = 1 To Len(S3$)
      S1$ = Mid$(S3$, S3)
      P1 = 1 ' pointer to S1$
      P2 = 1 ' pointer to S2$
      Do
         ' check match
         If P2 > Len(S2$) Then
            Exit Sub
         End If

         ' check character in S2$ at P2
         V$ = Mid$(S2$, P2, 1)
         Select Case V$
            Case "*" ' global character
               ' scan to next char
               If P2 > Len(S2$) Then
                  Exit Do
               End If
               S4$ = Mid$(S2$, P2 + 1, 1)
               Select Case S4$
                  Case "*", "?"
                     P2 = P2 + 1
                  Case Else
                     Do
                        If Mid$(S1$, P1, 1) = S4$ Then
                           Exit Do
                        End If
                        If P1 >= Len(S1$) Then
                           Exit Do
                        End If
                        P1 = P1 + 1
                     Loop
                     P2 = P2 + 1
               End Select
            Case "?" ' wildcard character
               P1 = P1 + 1
               P2 = P2 + 1
            Case Else ' ascii character
               If Mid$(S1$, P1, 1) <> V$ Then ' no match
                  Exit Do
               End If
               P1 = P1 + 1
               P2 = P2 + 1
         End Select
      Loop
   Next
   Var = 0 ' no match
End Sub

Function IsNumeric (X$)
   For V = 1 To Len(X$)
      If Mid$(X$, V, 1) >= "0" And Mid$(X$, V, 1) <= "9" Then
         Eat$ = ""
      Else
         IsNumeric = 0
         Exit Function
      End If
   Next
   IsNumeric = -1
End Function

Sub Make.Format (Var#, Var$)
   Var2# = Var#
   If Var2# <= 0 Then
      Var$ = "0.00 B"
      Exit Sub
   End If
   TempA = False
   Do
      If Var2# < 1024# Then
         Exit Do
      End If
      Var2# = Var2# / 1024#
      TempA = TempA + 1
      If TempA = 8 Then
         Exit Do
      End If
   Loop
   Strng$ = ""
   If TempA >= 1 And TempA <= 8 Then
      Strng$ = Mid$("KMGTPEZY", TempA, 1)
   End If
   Var$ = FormatString$(Var2#) + " " + Strng$ + "B"
End Sub

' main fullscreen editor
Sub Scrnedit (OutX$)
   Const MaxInt = 32766 ' zero-based
   Const MaxLong = 2147483647
   Const Nul = ""
   Dim Debug As Integer
   Dim VarX As String * 1
   Dim VarY As String * 1
   Dim Debug.Mode As Integer
   Dim LineX As String
   Dim Max.Row As Integer
   Dim Temp.ArrayS(1) As String
   Dim Max.Lines As Long
   Dim Max.File As Long
   On Timer(1) GoSub timer1
   Timer On
   Max.Row = 25
   Call Edit.Status.Line
   Cls
   Filename$ = OutX$
   If Left$(Filename$, 1) = Chr$(34) Then
      Filename$ = Mid$(Filename$, 2)
      If Right$(Filename$, 1) = Chr$(34) Then
         Filename$ = Left$(Filename$, Len(Filename) - 1)
      End If
   End If
   File5 = FreeFile
   Close #File5
   ControlBreak = 0
   If Filename$ = "" Then
      Exit Sub
   End If
   If _FileExists(Filename$) Then
      Open Filename$ For Binary As #File5 ' read file in binary
      Max.Lines = 0
      Var& = 0&
      LineX = Nul
      VarD = False
      VarE = False
      VarF! = Timer
      Print "Edit file in Linux binary read mode(y/n)? ";
      Do
         X$ = InKey$
         If LCase$(X$) = "y" Then Print: LINUXLoad = -1: Exit Do
         If LCase$(X$) = "n" Then Print: LINUXLoad = 0: Exit Do
      Loop
      Do
         Call Dot.Display(VarD, VarE, VarF!)
         Var& = Var& + 1&
         If Var& > LOF(File5) Then
            If Len(LineX) Then
               If Max.Lines >= MaxLong Then
                  Print "Out of memory."
                  Close #File5
                  Erase Temp.ArrayS
                  Exit Sub
               End If
               Max.Lines = Max.Lines + 1
               ReDim _Preserve Temp.ArrayS(Max.Lines) As String
               Temp.ArrayS(Max.Lines) = LineX
            End If
            Exit Do
         End If
         Get #File5, Var&, VarX
         If ControlBreak Then
            ControlBreak = False
            Print "Program load halted."
            Close #File5
            Erase Temp.ArrayS
            Exit Sub
         End If
         LineFeed = 0
         If LINUXLoad Then
            If VarX = Chr$(10) Then
               LineFeed = -1
            End If
         End If
         If VarX = Chr$(13) Then
            If Var& + 1& <= LOF(File5) Then
               Get #File5, Var& + 1&, VarY
               If VarY = Chr$(10) Then
                  Var& = Var& + 1&
                  LineFeed = -1
               End If
            End If
         End If
         If LineFeed Then
            If Max.Lines >= MaxLong Then
               Print "Out of memory."
               Close #File5
               Erase Temp.ArrayS
               Exit Sub
            End If
            Max.Lines = Max.Lines + 1
            ReDim _Preserve Temp.ArrayS(Max.Lines) As String
            Temp.ArrayS(Max.Lines) = LineX
            LineX = Nul
         Else
            LineX = LineX + VarX
         End If
      Loop
      Close #File5
      Max.File = Max.Lines
   End If
   Print
   If Max.Lines = 0 Then
      Max.File = 1
      Max.Lines = 1
      Line.Number = 1
      ReDim Temp.ArrayS(Max.Lines) As String
   End If
   Xcoor = 1
   Ycoor = 1
   Column = 1
   Row = 1
   Line.Number = 1
   Line.Length = 78
   GoSub Display.Screen
   Do
      V = Column + Ycoor - 1
      Var# = CDbl(Line.Number)
      If Var# = 0# Then
         Var$ = " 0"
      Else
         Call Amount(Var#, Var$)
      End If
      If V = 0 Then
         Var2$ = " 0"
      Else
         Call Amount(CDbl(V), Var2$)
      End If
      Strng$ = "Row" + Var$ + " Column" + Var2$

      If V > 0 And V <= Len(Temp.ArrayS(Line.Number)) Then
         V2 = Asc(Mid$(Temp.ArrayS(Line.Number), V, 1))
         Strng$ = Strng$ + " Ascii" + Str$(V2)

         Select Case V2
            Case 0
               Strng$ = Strng$ + " (nul)"
            Case 1
               Strng$ = Strng$ + " (soh)"
            Case 2
               Strng$ = Strng$ + " (stx)"
            Case 3
               Strng$ = Strng$ + " (etx)"
            Case 4
               Strng$ = Strng$ + " (eot)"
            Case 5
               Strng$ = Strng$ + " (enq)"
            Case 6
               Strng$ = Strng$ + " (ack)"
            Case 7
               Strng$ = Strng$ + " (bel)"
            Case 8
               Strng$ = Strng$ + " (bs)"
            Case 9
               Strng$ = Strng$ + " (tab)"
            Case 10
               Strng$ = Strng$ + " (lf)"
            Case 11
               Strng$ = Strng$ + " (vt)"
            Case 12
               Strng$ = Strng$ + " (np)"
            Case 13
               Strng$ = Strng$ + " (cr)"
            Case 14
               Strng$ = Strng$ + " (so)"
            Case 15
               Strng$ = Strng$ + " (si)"
            Case 16
               Strng$ = Strng$ + " (dle)"
            Case 17
               Strng$ = Strng$ + " (dc1)"
            Case 18
               Strng$ = Strng$ + " (dc2)"
            Case 19
               Strng$ = Strng$ + " (dc3)"
            Case 20
               Strng$ = Strng$ + " (dc4)"
            Case 21
               Strng$ = Strng$ + " (nak)"
            Case 22
               Strng$ = Strng$ + " (syn)"
            Case 23
               Strng$ = Strng$ + " (etb)"
            Case 24
               Strng$ = Strng$ + " (can)"
            Case 25
               Strng$ = Strng$ + " (em)"
            Case 26
               Strng$ = Strng$ + " (eof)"
            Case 27
               Strng$ = Strng$ + " (esc)"
            Case 28
               Strng$ = Strng$ + " (fs)"
            Case 29
               Strng$ = Strng$ + " (gs)"
            Case 30
               Strng$ = Strng$ + " (rs)"
            Case 31
               Strng$ = Strng$ + " (us)"
            Case 32
               Strng$ = Strng$ + " (spc)"
            Case 255
               Strng$ = Strng$ + " (?)"
            Case Else
               Strng$ = Strng$ + " (" + Chr$(V2) + ")"
         End Select
      End If
      Strng$ = Strng$ + Space$(41 - Len(Strng$))
      Color 14, 1
      Locate Max.Row - 1, 1
      Print Strng$;
      Locate Xcoor, Ycoor
      Color 15, 0
      TempX$ = ""
      Do While TempX$ = ""
         TempX$ = InKey$
      Loop
      Select Case Len(TempX$)
         Case 1
            Select Case TempX$
               Case Chr$(18) ' ctrl-r = searchreplace
                  GoSub Replace.String
               Case Chr$(6) ' search string (ctrl-f)
                  If Max.Lines > 0 Then
                     GoSub Search.String
                     If VarX2 Then
                        Line.Number = Count&
                        If Line.Number <= Max.Row - 2 Then
                           Xcoor = Line.Number
                        Else
                           Xcoor = 1
                        End If
                        Ycoor = 1
                        Column = 1
                     End If
                  End If
                  Color 15, 0
                  GoSub Display.Screen
               Case Chr$(10) ' jump to byte (ctrl-j)
                  If Max.Lines > 0 Then
                     GoSub Jump.Byte
                     If VarX2 Then
                        Line.Number = Count&
                        If Line.Number <= Max.Row - 2 Then
                           Xcoor = Line.Number
                        Else
                           Xcoor = 1
                        End If
                        Ycoor = 1
                        Column = 1
                     End If
                  End If
                  Color 15, 0
                  GoSub Display.Screen
               Case Chr$(7) ' goto to line (ctrl-g)
                  If Max.Lines > 0 Then
                     GoSub Jump.Line
                     If VarX2 Then
                        Line.Number = Count&
                        If Line.Number <= Max.Row - 2 Then
                           Xcoor = Line.Number
                        Else
                           Xcoor = 1
                        End If
                        Ycoor = 1
                        Column = 1
                     End If
                  End If
                  Color 15, 0
                  GoSub Display.Screen
               Case Chr$(13) ' insert line
                  ' always increases array
                  If Max.File < MaxLong Then
                     Max.File = Max.File + 1
                     ReDim _Preserve Temp.ArrayS(Max.File) As String
                     ' above
                     If Column + Ycoor - 1 = 1 Then
                        For Temp1 = Max.Lines To Line.Number Step -1
                           Temp.ArrayS(Temp1 + 1) = Temp.ArrayS(Temp1)
                        Next
                        Temp.ArrayS(Line.Number) = Nul
                        Line.Number = Line.Number + 1
                        Max.Lines = Max.Lines + 1
                        If Xcoor < Max.Row - 2 Then
                           Xcoor = Xcoor + 1
                        End If
                     Else
                        ' below
                        If Column + Ycoor - 1 > Len(Temp.ArrayS(Line.Number)) Then
                           Line.Number = Line.Number + 1 ' below
                           For Temp1 = Max.Lines To Line.Number Step -1
                              Temp.ArrayS(Temp1 + 1) = Temp.ArrayS(Temp1)
                           Next
                           Temp.ArrayS(Line.Number) = Nul
                           If Xcoor < Max.Row - 2 Then
                              Xcoor = Xcoor + 1
                           End If
                           Max.Lines = Max.Lines + 1
                        Else
                           ' split line
                           For Temp1 = Max.Lines To Line.Number + 1 Step -1
                              Temp.ArrayS(Temp1 + 1) = Temp.ArrayS(Temp1)
                           Next
                           T$ = Temp.ArrayS(Line.Number)
                           U$ = Mid$(T$, Column + Ycoor - 1)
                           T$ = Left$(T$, Column + Ycoor - 2)
                           Temp.ArrayS(Line.Number) = T$
                           Line.Number = Line.Number + 1 ' below
                           Temp.ArrayS(Line.Number) = U$
                           If Xcoor < Max.Row - 2 Then
                              Xcoor = Xcoor + 1
                           End If
                           Max.Lines = Max.Lines + 1
                        End If
                     End If
                  End If
                  Column = 1
                  Ycoor = 1
                  GoSub Display.Screen
               Case Chr$(8) ' backspace
                  q = Column + Ycoor - 1
                  If Line.Number <= 1 And q <= 1 Then ' no backspace at 1,1
                     Eat$ = Nul
                  Else
                     ' remove current line
                     If Temp.ArrayS(Line.Number) = Nul Then
                        ' pack array
                        For Temp1 = Line.Number To Max.Lines - 1
                           Temp.ArrayS(Temp1) = Temp.ArrayS(Temp1 + 1)
                        Next
                        If Xcoor > 1 Then
                           Xcoor = Xcoor - 1
                        End If
                        Line.Number = Line.Number - 1
                        Max.Lines = Max.Lines - 1
                        ' position at eol
                        End.Line = Len(Temp.ArrayS(Line.Number))
                        If End.Line >= 80 Then
                           Column = End.Line - 78
                           Ycoor = End.Line - Column + 2
                        Else
                           Ycoor = End.Line - Column + 2
                        End If
                        GoSub Display.Screen
                     Else
                        ' concatenate previous line
                        If Column + Ycoor - 1 <= 1 Then
                           If Line.Number > 1 Then
                              If Line.Number <= Max.Lines Then
                                 Var = 0
                                 If Temp.ArrayS(Line.Number - 1) = Nul Then
                                    If Ycoor = 1 Then
                                       Var = -1
                                    End If
                                 End If

                                 ' position at eol
                                 If Var = 0 Then
                                    End.Line = Len(Temp.ArrayS(Line.Number - 1))
                                 End If

                                 Temp.ArrayS(Line.Number - 1) = Temp.ArrayS(Line.Number - 1) + Temp.ArrayS(Line.Number)
                                 For Temp1 = Line.Number To Max.Lines - 1
                                    Temp.ArrayS(Temp1) = Temp.ArrayS(Temp1 + 1)
                                 Next
                                 If Xcoor > 1 Then
                                    Xcoor = Xcoor - 1
                                 End If
                                 Line.Number = Line.Number - 1
                                 Max.Lines = Max.Lines - 1
                                 Column = 1
                                 Ycoor = 1

                                 ' position at eol
                                 If Var = 0 Then
                                    If End.Line >= 80 Then
                                       Column = End.Line - 78
                                       Ycoor = End.Line - Column + 2
                                    Else
                                       Ycoor = End.Line - Column + 2
                                    End If
                                 End If

                                 GoSub Display.Screen
                              End If
                           End If
                        Else
                           ' backspace 1 character
                           If Column + Ycoor - 2 > False Then
                              T$ = Temp.ArrayS(Line.Number)
                              T$ = Left$(T$, Column + Ycoor - 3) + Mid$(T$, Column + Ycoor - 1)
                              Temp.ArrayS(Line.Number) = T$
                              ' move cursor 1 left
                              If Ycoor > 1 Then
                                 Ycoor = Ycoor - 1
                                 GoSub Display.Screen
                              Else
                                 If Column > 1 Then
                                    Column = Column - 1
                                    GoSub Display.Screen
                                 End If
                              End If
                           End If
                        End If
                     End If
                  End If
               Case Chr$(9) ' tab
                  If Column + Ycoor + 7 <= Len(Temp.ArrayS(Line.Number)) Then
                     If Ycoor + 8 < 80 Then
                        Ycoor = Ycoor + 8
                     Else
                        Column = Column + 8
                        GoSub Display.Screen
                     End If
                  Else ' end
                     End.Line = Len(Temp.ArrayS(Line.Number))
                     If End.Line >= 80 Then
                        Column = End.Line - 78
                        Ycoor = End.Line - Column + 2
                        GoSub Display.Screen
                     Else
                        Ycoor = End.Line - Column + 2
                     End If
                  End If
               Case Chr$(27) ' escape, exit editor
                  Exit Do
               Case Else ' insert character
                  If Line.Number > 0 Then
                     T$ = Temp.ArrayS(Line.Number)
                     T$ = Left$(T$, Column + Ycoor - 2) + TempX$ + Mid$(T$, Column + Ycoor - 1)
                     Temp.ArrayS(Line.Number) = T$
                     If Column + Ycoor - 1 <= Len(Temp.ArrayS(Line.Number)) Then
                        If Ycoor < 80 Then
                           Ycoor = Ycoor + 1
                           GoSub Display.Screen
                        Else
                           Column = Column + 1
                           GoSub Display.Screen
                        End If
                     End If
                  End If
            End Select
         Case 2
            Temp = Asc(Mid$(TempX$, 2, 1))
            Select Case Temp
               Case 96 ' Ctrl-F3 - repeat replace
                  If Search$ = Nul Then
                     GoSub Replace.String
                  Else
                     GoSub Replace.String2
                  End If
               Case 61 ' F3 - continue search
                  If Max.Lines > 0 Then
                     If LastSearchLine& = 0& Then ' init search
                        GoSub Search.String
                     Else
                        GoSub Search.String2
                     End If
                     If VarX2 Then
                        Line.Number = Count&
                        If Line.Number <= Max.Row - 2 Then
                           Xcoor = Line.Number
                        Else
                           Xcoor = 1
                        End If
                        Ycoor = 1
                        Column = 1
                     End If
                  End If
                  Color 15, 0
                  GoSub Display.Screen
               Case 15 ' shift-tab
                  If Column + Ycoor - 8 > 0 Then
                     If Column + Ycoor - 7 > 1 Then
                        Ycoor = Ycoor - 7
                     Else
                        If Column > 8 Then
                           Column = Column - 7
                           GoSub Display.Screen
                        End If
                     End If
                  Else ' home
                     If Column > 1 Then
                        Column = 1
                        Ycoor = 1
                        GoSub Display.Screen
                     Else
                        Column = 1
                        Ycoor = 1
                     End If
                  End If
               Case 83, 147 ' delete/control-delete
                  q = Column + Ycoor - 1
                  ' no delete at 1,1
                  If (Line.Number <= 1 And q < 1) Or Max.Lines < 1 Then
                     Eat$ = Nul
                  Else
                     ' remove line
                     If Temp.ArrayS(Line.Number) = Nul Then
                        If Line.Number = 1 And Max.Lines = 1 Then ' 1,1
                           Eat$ = Nul
                        Else
                           ' pack array
                           For Temp1 = Line.Number To Max.Lines - 1
                              Temp.ArrayS(Temp1) = Temp.ArrayS(Temp1 + 1)
                           Next
                           If Line.Number = Max.Lines Then
                              Line.Number = Line.Number - 1
                              If Xcoor > 1 Then
                                 Xcoor = Xcoor - 1
                              End If
                           End If
                           Max.Lines = Max.Lines - 1
                           Column = 1
                           Ycoor = 1
                           GoSub Display.Screen
                        End If
                     Else
                        ' delete line
                        If Len(Temp.ArrayS(Line.Number)) < 1 Then
                           Temp.ArrayS(Line.Number) = Nul
                           GoSub Display.Screen
                        Else
                           ' concatenate line
                           If Column + Ycoor - 1 > Len(Temp.ArrayS(Line.Number)) Then
                              If Line.Number + 1 <= Max.Lines Then
                                 T$ = Temp.ArrayS(Line.Number)
                                 T$ = T$ + Temp.ArrayS(Line.Number + 1)
                                 Temp.ArrayS(Line.Number) = T$

                                 ' pack array
                                 For Temp1 = Line.Number + 1 To Max.Lines - 1
                                    Temp.ArrayS(Temp1) = Temp.ArrayS(Temp1 + 1)
                                 Next
                                 Max.Lines = Max.Lines - 1

                                 GoSub Display.Screen
                              End If
                           Else
                              ' delete character
                              T$ = Temp.ArrayS(Line.Number)
                              T$ = Left$(T$, Column + Ycoor - 2) + Mid$(T$, Column + Ycoor)
                              Temp.ArrayS(Line.Number) = T$
                              GoSub Display.Screen
                           End If
                        End If
                     End If
                  End If
               Case 71 ' home
                  If Column > 1 Then
                     Column = 1
                     Ycoor = 1
                     GoSub Display.Screen
                  Else
                     Column = 1
                     Ycoor = 1
                  End If
               Case 79 ' end
                  End.Line = Len(Temp.ArrayS(Line.Number))
                  If End.Line >= 80 Then
                     Column = End.Line - 78
                     Ycoor = End.Line - Column + 2
                     GoSub Display.Screen
                  Else
                     Ycoor = End.Line - Column + 2
                  End If
               Case 75, 155 ' left/alt-left
                  If Ycoor > 1 Then
                     Ycoor = Ycoor - 1
                  Else
                     If Column > 1 Then
                        Column = Column - 1
                        GoSub Display.Screen
                     End If
                  End If
               Case 77, 157 ' right/alt-right
                  If Column + Ycoor - 1 <= Len(Temp.ArrayS(Line.Number)) Then
                     If Ycoor < 80 Then
                        Ycoor = Ycoor + 1
                     Else
                        Column = Column + 1
                        GoSub Display.Screen
                     End If
                  End If
               Case 72, 141, 152 ' up/ctrl-up/alt-up
                  Var = 0
                  If Line.Number > 1 Then
                     Line.Number = Line.Number - 1
                     If Xcoor = 1 Then
                        Var = -1
                     Else
                        Xcoor = Xcoor - 1
                     End If
                     End.Line = Len(Temp.ArrayS(Line.Number)) + 1
                     If Column + Ycoor - 1 > End.Line Then
                        Ycoor = End.Line - Column + 1
                        If Ycoor <= 0 Then
                           Ycoor = End.Line
                           If Column > 1 Then
                              Var = -1
                           End If
                           Column = 1
                        End If
                     End If
                     If Var Then
                        GoSub Display.Screen
                     End If
                  End If
               Case 80, 145, 160 ' down/ctrl-dn/alt-dn
                  Var = 0
                  If Line.Number < Max.Lines Then
                     Line.Number = Line.Number + 1
                     If Xcoor >= Max.Row - 2 Then
                        Var = -1
                     Else
                        Xcoor = Xcoor + 1
                     End If
                     End.Line = Len(Temp.ArrayS(Line.Number)) + 1
                     If Column + Ycoor - 1 > End.Line Then
                        Ycoor = End.Line - Column + 1
                        If Ycoor <= 0 Then
                           Ycoor = End.Line
                           If Column > 1 Then
                              Var = -1
                           End If
                           Column = 1
                        End If
                     End If
                     If Var Then
                        GoSub Display.Screen
                     End If
                  End If
               Case 73, 132 ' pageup/ctrl-pageup
                  If Line.Number > 1 Then
                     If Line.Number - 22 > 1 Then
                        Line.Number = Line.Number - 22
                     Else
                        Line.Number = 1
                     End If
                     Xcoor = 1
                     End.Line = Len(Temp.ArrayS(Line.Number)) + 1
                     If Column + Ycoor - 1 > End.Line Then
                        Ycoor = End.Line - Column + 1
                        If Ycoor <= 0 Then
                           Ycoor = End.Line
                           If Column > 1 Then
                              Var = -1
                           End If
                           Column = 1
                        End If
                     End If
                     GoSub Display.Screen
                  End If
               Case 81, 118 ' pagedown/ctrl-pagedn
                  If Line.Number < Max.Lines Then
                     If Line.Number + 22 < Max.Lines Then
                        Line.Number = Line.Number + 22
                        Xcoor = 1
                     Else
                        Line.Number = Max.Lines
                        If Max.Lines < Max.Row - 3 Then
                           Xcoor = Max.Lines
                        Else
                           Xcoor = Max.Row - 3
                        End If
                     End If
                     End.Line = Len(Temp.ArrayS(Line.Number)) + 1
                     If Column + Ycoor - 1 > End.Line Then
                        Ycoor = End.Line - Column + 1
                        If Ycoor <= 0 Then
                           Ycoor = End.Line
                           If Column > 1 Then
                              Var = -1
                           End If
                           Column = 1
                        End If
                     End If
                     GoSub Display.Screen
                  End If
               Case 116 ' control-right
                  If Column + Ycoor - 1 > Len(Temp.ArrayS(Line.Number)) Then ' eol
                     If Line.Number + 1 <= Max.Lines Then
                        Line.Number = Line.Number + 1
                        If Xcoor = Max.Row - 3 Then
                           Var = True
                        Else
                           Xcoor = Xcoor + 1
                        End If
                        Ycoor = 1
                        Column = 1
                        GoSub Display.Screen
                     End If
                  Else
                     P = 0
                     For Temp2 = Column + Ycoor - 1 To Len(Temp.ArrayS(Line.Number))
                        P = P + 1
                        If Mid$(Temp.ArrayS(Line.Number), Temp2, 1) = " " Then
                           If Mid$(Temp.ArrayS(Line.Number), Temp2 + 1, 1) <> " " Then
                              Exit For
                           End If
                        End If
                     Next
                     'shift right
                     For Var3 = 1 To P
                        If Ycoor < 80 Then
                           Ycoor = Ycoor + 1
                        Else
                           Column = Column + 1
                        End If
                     Next
                     GoSub Display.Screen
                  End If
               Case 115 ' control-left
                  If Column + Ycoor - 1 <= 1 Then
                     If Line.Number > 1 Then
                        Line.Number = Line.Number - 1
                        If Xcoor = 1 Then
                           Var = True
                        Else
                           Xcoor = Xcoor - 1
                        End If
                        End.Line = Len(Temp.ArrayS(Line.Number))
                        If End.Line >= 80 Then
                           Column = End.Line - 78
                           Ycoor = End.Line - Column + 2
                        Else
                           Ycoor = End.Line - Column + 2
                        End If
                        GoSub Display.Screen
                     End If
                  Else
                     P = 0
                     V = 0
                     For Temp2 = Column + Ycoor - 3 To 1 Step -1
                        P = P + 1
                        If Mid$(Temp.ArrayS(Line.Number), Temp2, 1) = " " Then
                           If Mid$(Temp.ArrayS(Line.Number), Temp2 + 1, 1) <> " " Then
                              V = -1
                              Exit For
                           End If
                        End If
                     Next
                     If V = 0 Then
                        P = P + 1
                     End If
                     ' shift left
                     For Var3 = 1 To P
                        If Ycoor > 1 Then
                           Ycoor = Ycoor - 1
                        Else
                           If Column > 1 Then
                              Column = Column - 1
                           End If
                        End If
                     Next
                     GoSub Display.Screen
                  End If
               Case 119 ' control-home
                  If Max.Lines > 0 Then
                     Line.Number = 1
                     Xcoor = 1
                     Ycoor = 1
                     Column = 1
                     GoSub Display.Screen
                  End If
               Case 117 ' control-end
                  If Max.Lines > 0 Then
                     Line.Number = Max.Lines
                     If Max.Lines < Max.Row - 3 Then
                        Xcoor = Max.Lines
                     Else
                        Xcoor = Max.Row - 3
                     End If
                     Ycoor = 1
                     Column = 1
                     GoSub Display.Screen
                  End If
               Case 82 ' insert
                  If Line.Number > 0 Then
                     Var = False
                     Ascii$ = Nul
                     GoSub Display.Ascii.Line
                     Do
                        Var$ = Nul
                        Do
                           Var$ = InKey$
                           If Len(Var$) Then
                              Exit Do
                           End If
                        Loop
                        If Len(Var$) = 1 Then
                           If Var$ = Chr$(8) Then
                              If Len(Ascii$) > 0 Then
                                 Ascii$ = Left$(Ascii$, Len(Ascii$) - 1)
                                 GoSub Display.Ascii.Line
                                 Var = Var - 1
                                 Locate Max.Row - 1, 27
                                 Print Ascii$ + " ";
                                 Locate Max.Row - 1, 27
                                 Print Ascii$;
                              End If
                           End If
                           If Var$ = Chr$(13) Then
                              Exit Do
                           End If
                           If LCase$(Var$) = "x" Or LCase$(Var$) = "o" Or LCase$(Var$) = "b" Then
                              If Var = 0 Then
                                 Ascii$ = Ascii$ + LCase$(Var$)
                                 GoSub Display.Ascii.Line
                                 Var = Var + 1
                                 Locate Max.Row - 1, 26 + Var
                                 Strng$ = LCase$(Var$)
                                 Print Strng$;
                              End If
                           End If
                           If LCase$(Var$) >= "a" And LCase$(Var$) <= "f" Then
                              If Var >= 1 And Var < 3 Then
                                 If Left$(Ascii$, 1) = "x" Then
                                    Var = Var + 1
                                    Locate Max.Row - 1, 26 + Var
                                    Strng$ = Var$
                                    Print Strng$;
                                    Ascii$ = Ascii$ + Var$
                                 End If
                              End If
                           End If
                           If Left$(Ascii$, 1) = "o" Then
                              If Var$ >= "0" And Var$ <= "7" Then
                                 If Var < 4 Then
                                    Var = Var + 1
                                    Locate Max.Row - 1, 26 + Var
                                    Strng$ = Var$
                                    Print Strng$;
                                    Ascii$ = Ascii$ + Var$
                                 End If
                              End If
                           Else
                              If Left$(Ascii$, 1) = "b" Then
                                 If Var$ = "0" Or Var$ = "1" Then
                                    If Var < 9 Then
                                       Var = Var + 1
                                       Locate Max.Row - 1, 26 + Var
                                       Strng$ = Var$
                                       Print Strng$;
                                       Ascii$ = Ascii$ + Var$
                                    End If
                                 End If
                              Else
                                 If Var$ >= "0" And Var$ <= "9" Then
                                    If Var < 3 Then
                                       Var = Var + 1
                                       Locate Max.Row - 1, 26 + Var
                                       Print Var$;
                                       Ascii$ = Ascii$ + Var$
                                    End If
                                 End If
                              End If
                           End If
                        End If
                     Loop
                     Color 15, 0

                     ' insert ascii character
                     If Left$(Ascii$, 1) = "x" Then
                        Ascii.Value = Int(Val("&H" + Mid$(Ascii$, 2)))
                     Else
                        If Left$(Ascii$, 1) = "o" Then
                           Ascii.Value = Int(Val("&O" + Mid$(Ascii$, 2)))
                        Else
                           If Left$(Ascii$, 1) = "b" Then ' binary
                              Ascii$ = Mid$(Ascii$, 2)
                              GoSub Binary.String
                           Else
                              Ascii.Value = Int(Val(Ascii$))
                           End If
                        End If
                     End If
                     If Ascii.Value >= 0 And Ascii.Value <= 255 Then
                        TempX$ = Chr$(Ascii.Value)
                        T$ = Temp.ArrayS(Line.Number)
                        T$ = Left$(T$, Column + Ycoor - 2) + TempX$ + Mid$(T$, Column + Ycoor - 1)
                        Temp.ArrayS(Line.Number) = T$
                        If Column + Ycoor - 1 <= Len(Temp.ArrayS(Line.Number)) Then
                           If Ycoor < 80 Then
                              Ycoor = Ycoor + 1
                              GoSub Display.Screen
                           Else
                              Column = Column + 1
                              GoSub Display.Screen
                           End If
                        End If
                     End If
                  End If
            End Select
      End Select
   Loop
   Color 15, 0
   Cls
   Call Edit.Status.Line
   Locate Max.Row - 1, 1
   q = 0
   Print "Write "; Filename$; " to disk(y/n)? ";
   Do
      Char$ = InKey$
      Char$ = UCase$(Char$)
      If Char$ = "Y" Then
         q = -1
         Print "y"
         Exit Do
      End If
      If Char$ = "N" Then
         Print "n"
         Exit Do
      End If
   Loop
   If q Then
      Close #File5
      If _FileExists(Filename$) Then
         Kill Filename$
         'f$ = Filename$ + Chr$(0)
         'x = DeleteFileA%(f$)
      End If
      Print "Save file in Linux binary write mode(y/n)? ";
      Do
         X$ = InKey$
         If LCase$(X$) = "y" Then Print: LINUXSave = -1: Exit Do
         If LCase$(X$) = "n" Then Print: LINUXSave = 0: Exit Do
      Loop
      If LINUXSave Then
         Open Filename$ For Binary As #File5
         Var& = 0&
         For Count& = 1& To Max.Lines
            For Count2 = 1 To Len(Temp.ArrayS(Count&))
               VarX = Mid$(Temp.ArrayS(Count&), Count2, 1)
               Var& = Var& + 1&
               Put File5, Var&, VarX
            Next
            Var& = Var& + 1&
            VarX = Chr$(10)
            Put File5, Var&, VarX
         Next
      Else
         Var& = 0&
         Open Filename$ For Output As #File5
         For Count& = 1& To Max.Lines
            Var& = Var& + Len(Temp.ArrayS(Count&)) + 2&
            Print #File5, Temp.ArrayS(Count&)
         Next
      End If
      Close #File5
      If LINUXSave Then
         Print Str$(Var&) + " binary bytes stored to disk."
      Else
         Print Str$(Var&) + " bytes stored to disk."
      End If
      Print "-more-";
      While InKey$ = "": Wend
   End If
   Erase Temp.ArrayS
   Exit Sub

   Display.Ascii.Line:
   Color 15, 1
   Locate Max.Row - 1, 1, 1
   Color 15, 1
   Strng$ = Space$(41)
   Print Strng$;
   Locate Max.Row - 1, 1, 1
   If Left$(Ascii$, 1) = "x" Then
      Var2$ = "Enter 2-digit ascii code: "
   Else
      If Left$(Ascii$, 1) = "o" Then
         Var2$ = "Enter 3-digit ascii code: "
      Else
         If Left$(Ascii$, 1) = "b" Then
            Var2$ = "Enter 8-digit ascii code: "
         Else
            Var2$ = "Enter 3-digit ascii code: "
         End If
      End If
   End If
   VarC = Len(Var2$) + Len(Ascii$)
   Var2$ = Var2$ + Space$(41 - Len(Var2$))
   Print Var2$;
   Locate Max.Row - 1, VarC, 1
   Return

   Binary.String:
   Ascii.Value = False
   Binary.Power = False
   For Binary.Digit = Len(Ascii$) To 1 Step -1
      OutX2$ = Mid$(Ascii$, Binary.Digit, 1)
      Select Case OutX2$
         Case "0"
            ' nul
         Case "1"
            Ascii.Value = Ascii.Value + 2 ^ Binary.Power
      End Select
      Binary.Power = Binary.Power + 1
   Next
   Return

   Jump.Line:
   Color 15, 1
   Locate Max.Row - 1, 1
   Strng$ = Space$(80)
   Print Strng$;
   Color 14, 1
   Locate Max.Row - 1, 1
   prompt$ = "Enter line number(1-" + LTrim$(Str$(Max.Lines)) + ")? "
   'X$ = KeyboardLine3$(prompt$)
   Print prompt$;
   Line Input X$

   VarX2 = -1
   If Len(X$) = 0 Then
      VarX2 = 0
   Else
      If Len(X$) > 7 Then
         VarX2 = 0
      Else
         VarX2 = IsNumeric(X$)
      End If
   End If
   Count& = 0&
   If VarX2 Then
      If Val(X$) > 0 And Val(X$) <= Max.Lines Then
         Count& = Val(X$)
      Else
         VarX2 = 0
      End If
   End If
   Return

   Jump.Byte:
   ' count bytes in edit array
   X# = 0#
   For X& = 1 To Max.Lines
      X# = X# + Len(Temp.ArrayS(X&))
   Next

   Color 15, 1
   Locate Max.Row - 1, 1
   Strng$ = Space$(80)
   Print Strng$;
   Color 14, 1
   Locate Max.Row - 1, 1
   prompt$ = "Enter byte number(1-" + LTrim$(Str$(X#)) + ")? "
   'X$ = KeyboardLine3$(prompt$)
   Print prompt$;
   Line Input X$

   VarX2 = -1
   If Len(X$) = 0 Then
      VarX2 = 0
   Else
      If Len(X$) > 15 Then
         VarX2 = 0
      Else
         VarX2 = IsNumeric(X$)
      End If
   End If
   T# = 0#
   If VarX2 Then
      Count# = Val(X$)
      If Count# > 0 And Count# <= X# Then
         For Count& = 1 To Max.Lines
            If T# + Len(Temp.ArrayS(Count&)) >= Count# Then
               Exit For
            End If
            T# = T# + Len(Temp.ArrayS(Count&))
         Next
      Else
         VarX2 = 0
      End If
   End If
   Return

   Replace.String:
   If Max.Lines > 0 Then
      Color 15, 1
      Locate Max.Row - 1, 1
      Strng$ = Space$(80)
      Print Strng$;
      Color 14, 1
      Locate Max.Row - 1, 1
      Line Input ; "Enter search string? "; Search$

      Color 15, 1
      Locate Max.Row - 1, 1
      Strng$ = Space$(80)
      Print Strng$;
      Color 14, 1
      Locate Max.Row - 1, 1
      Line Input ; "Enter replace string? "; Replace$

      Replace.String2:

      Color 15, 1
      Locate Max.Row - 1, 1
      Strng$ = Space$(80)
      Print Strng$;
      Color 14, 1
      Locate Max.Row - 1, 1
      Print "Enter (R)eplace, Replace(A)ll, (C)ancel? ";
      Do
         X$ = InKey$
         X = 0
         If UCase$(X$) = "R" Then X = 1: Exit Do
         If UCase$(X$) = "A" Then X = 2: Exit Do
         If UCase$(X$) = "C" Then X = 0: Exit Do
      Loop
      If X Then
         Color 15, 1
         Locate Max.Row - 1, 1
         Strng$ = Space$(80)
         Print Strng$;
         Color 14, 1
         Locate Max.Row - 1, 1
         Print "Case-sensitive(y/n)? ";
         Do
            Y$ = InKey$
            If UCase$(Y$) = "Y" Then SensitiveSelect = -1: Exit Do
            If UCase$(Y$) = "N" Then SensitiveSelect = 0: Exit Do
         Loop
      End If

      If X = 1 Then ' replace
         ' store current screen
         Store1 = Xcoor
         Store2 = Ycoor
         Store3 = Column
         Store& = Line.Number
         ' start replace
         Count& = 0&
         If Len(Search$) Then
            For X& = Store& To Max.Lines
               S1 = 1
               Text$ = Temp.ArrayS(X&)
               Do
                  If SensitiveSelect Then
                     P1 = InStr(S1, Text$, Search$)
                  Else
                     P1 = InStr(S1, UCase$(Text$), UCase$(Search$))
                  End If
                  If P1 Then
                     ' jump to line
                     Ycoor = 1
                     Column = 1
                     Line.Number = X&
                     If Line.Number <= 23 Then
                        Xcoor = Line.Number
                     Else
                        Xcoor = 1
                     End If
                     ' display screen
                     Color 15, 0
                     GoSub Display.Screen

                     ' display text to replace
                     If P1 + Len(Search$) < 80 Then
                        Locate Xcoor, P1
                        Color 12, 1
                        Var1$ = Mid$(Text$, P1, Len(Search$))
                        Print Var1$;
                        Color 15, 0
                     End If

                     ' z=-1 replace, z=1 skip
                     Color 15, 1
                     Locate Max.Row - 1, 1
                     Strng$ = Space$(80)
                     Print Strng$;
                     Color 14, 1
                     Locate Max.Row - 1, 1
                     Print "Enter (R)eplace, (S)kip, (C)ancel? ";
                     Do
                        X$ = InKey$
                        Z = 0
                        If UCase$(X$) = "R" Then Z = -1: Exit Do
                        If UCase$(X$) = "S" Then Z = 1: Exit Do
                        If UCase$(X$) = "C" Then Z = 0: Exit Do
                     Loop
                     If Z = 0 Then ' cancel
                        Exit For
                     End If
                     If Z = -1 Then
                        Text$ = Left$(Text$, P1 - 1) + Replace$ + Mid$(Text$, P1 + Len(Search$))
                        Temp.ArrayS(X&) = Text$
                        Count& = Count& + 1&
                     End If
                  Else
                     Exit Do
                  End If
                  S1 = P1 + Len(Replace$)
               Loop
            Next
         End If
         ' restore current screen
         Color 15, 0
         GoSub Display.Screen

         Xcoor = Store1
         Ycoor = Store2
         Column = Store3
         Line.Number = Store&

         Color 15, 1
         Locate Max.Row - 1, 1
         Strng$ = Space$(80)
         Print Strng$;
         Color 14, 1
         Locate Max.Row - 1, 1
         ' display replacements
         If Count& = 0& Then
            Print "Text not found. Press any key.";
         Else
            Print "Replaced" + Str$(Count&) + " strings. Press any key.";
         End If
         While InKey$ = ""
         Wend
         Color 15, 0
         GoSub Display.Screen
      End If
      If X = 2 Then ' replaceall
         Count& = 0&
         If Len(Search$) Then
            For X& = 1& To Max.Lines
               Text$ = Temp.ArrayS(X&)
               Flag = 0
               S1 = 1
               Do
                  If SensitiveSelect Then
                     P1 = InStr(S1, Text$, Search$)
                  Else
                     P1 = InStr(S1, UCase$(Text$), UCase$(Search$))
                  End If
                  If P1 Then
                     Flag = -1
                     Text$ = Left$(Text$, P1 - 1) + Replace$ + Mid$(Text$, P1 + Len(Search$))
                     Count& = Count& + 1&
                  Else
                     Exit Do
                  End If
                  S1 = P1 + Len(Replace$)
               Loop
               If Flag Then
                  Temp.ArrayS(X&) = Text$
               End If
            Next
         End If
         Color 15, 0
         GoSub Display.Screen
         Color 15, 1
         Locate Max.Row - 1, 1
         Strng$ = Space$(80)
         Print Strng$;
         Color 14, 1
         Locate Max.Row - 1, 1
         ' display replacements
         If Count& = 0& Then
            Print "Text not found. Press any key.";
         Else
            Print "Replaced" + Str$(Count&) + " strings. Press any key.";
         End If
         While InKey$ = ""
         Wend
         Color 15, 0
         GoSub Display.Screen
      End If
   End If
   Return

   ' init search
   Search.String:

   Color 15, 1
   Locate Max.Row - 1, 1
   Strng$ = Space$(80)
   Print Strng$;
   Color 14, 1
   Locate Max.Row - 1, 1
   Line Input ; "Enter search string? "; X$

   Color 15, 1
   Locate Max.Row - 1, 1
   Strng$ = Space$(80)
   Print Strng$;
   Color 14, 1
   Locate Max.Row - 1, 1
   Line Input ; "Case-sensitive(y/n)? "; Y$
   If UCase$(Y$) = "Y" Then CaseSensitive = -1
   If UCase$(Y$) = "N" Then CaseSensitive = 0

   Color 15, 1
   Locate Max.Row - 1, 1
   Strng$ = Space$(80)
   Print Strng$;
   Color 14, 1
   Locate Max.Row - 1, 1
   Line Input ; "Use wildcards(y/n)? "; Z$
   If UCase$(Z$) = "Y" Then WildCards = -1
   If UCase$(Z$) = "N" Then WildCards = 0

   LastSearchLine& = 0&
   LastSearchString$ = X$
   VarX2 = 0
   If Len(X$) = 0 Then
      Return
   End If
   For Count& = 1 To Max.Lines
      If WildCards Then
         VarX1$ = Temp.ArrayS(Count&)
         VarX2$ = X$
         Call InstrSUB1(VarX2, VarX2$, VarX1$, CaseSensitive)
         If VarX2 Then
            LastSearchLine& = Count&
            Exit For
         End If
      Else
         If CaseSensitive Then
            If InStr(Temp.ArrayS(Count&), X$) Then
               LastSearchLine& = Count&
               VarX2 = -1
               Exit For
            End If
         Else
            VarX1$ = UCase$(Temp.ArrayS(Count&))
            VarX2$ = UCase$(X$)
            If InStr(VarX1$, VarX2$) Then
               LastSearchLine& = Count&
               VarX2 = -1
               Exit For
            End If
         End If
      End If
   Next
   Return

   ' continue search
   Search.String2:
   X$ = LastSearchString$
   VarX2 = 0
   If Len(X$) Then
      For Count& = LastSearchLine& + 1& To Max.Lines
         If WildCards Then
            VarX1$ = Temp.ArrayS(Count&)
            VarX2$ = X$
            Call InstrSUB1(VarX2, VarX2$, VarX1$, CaseSensitive)
            If VarX2 Then
               LastSearchLine& = Count&
               Exit For
            End If
         Else
            If CaseSensitive Then
               If InStr(Temp.ArrayS(Count&), X$) Then
                  LastSearchLine& = Count&
                  VarX2 = -1
                  Exit For
               End If
            Else
               VarX1$ = UCase$(Temp.ArrayS(Count&))
               VarX2$ = UCase$(X$)
               If InStr(VarX1$, VarX2$) Then
                  LastSearchLine& = Count&
                  VarX2 = -1
                  Exit For
               End If
            End If
         End If
      Next
   End If
   Return

   ' redisplay editor screen
   Display.Screen:
   Color 15, 0
   Cls
   Locate 1, 1
   Count = 0
   Do
      Count = Count + 1
      If Count = Max.Row - 1 Then
         Exit Do
      End If
      If Count + Line.Number - Xcoor > Max.Lines Then
         Exit Do
      End If
      Locate Count, 1
      Strng$ = Mid$(Temp.ArrayS(Count + Line.Number - Xcoor), Column)
      If Len(Strng$) > 80 Then
         Strng$ = Left$(Strng$, 80)
      End If
      _ControlChr Off
      Print Strng$;
      _ControlChr On
   Loop
   If Count < Max.Row - 1 Then
      Locate Count, 1
      Color 12, 0
      Print "<end of file>";
   End If
   Color 14, 1
   Locate Max.Row - 1, 1
   Print Space$(78);
   Color 0, 1
   Locate Max.Row - 1, 79, 0
   Print " ";
   Locate Max.Row - 1, 80, 0
   Print " ";
   Color 15, 0
   Call Edit.Status.Line
   Return
End Sub

