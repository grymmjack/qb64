'AtomicSlaughter
'https://qb64phoenix.com/forum/showthread.php?tid=457

Type Sections
    lineNum As Integer
    section As String
End Type

Sub LoadINIFile (FileName As String, iniData() As String, iniSections() As Sections)
    ReDim As String iniData(0)
    ReDim As Sections iniSections(0)
    If _FileExists(FileName) Then
        file = FreeFile
        Open FileName For Binary As #file
        If LOF(file) = 0 Then Exit Sub
        Do
            Line Input #file, iniData(UBound(iniData))
            If InStr(iniData(UBound(iniData)), "[") > 0 Then
                iniSections(UBound(iniSections)).section = iniData(UBound(iniData))
                iniSections(UBound(iniSections)).lineNum = x
                ReDim _Preserve As Sections iniSections(UBound(iniSections) + 1)
            End If
            ReDim _Preserve iniData(UBound(iniData) + 1)
            x = x + 1
        Loop Until EOF(file)
        Close
    End If
    iniSections(UBound(iniSections)).section = "End of File"
    iniSections(UBound(iniSections)).lineNum = x
End Sub

Sub CheckSection (sec() As Sections, check As String, out1 As Single, out2 As Single, Ret As String)
    For i = 0 To UBound(sec)
        If LCase$(sec(i).section) = "[" + LCase$(check) + "]" Then
            out1 = sec(i).lineNum + 1
            out2 = sec(i + 1).lineNum - 1
            Print out1, out2
            Exit Sub
        End If
    Next
    Ret = "New Section"
End Sub

Function ReadINI$ (FileName As String, Section As String, INIKey As String)
    Dim sec(0) As Sections: Dim ini(0) As String
    Dim As Single start, finish
    LoadINIFile "Config.ini", ini(), sec()
    If Section <> "" Then
        CheckSection sec(), Section, start, finish, ret$
        For i = start To finish
            If Left$(LCase$(ini(i)), InStr(ini(i), "=") - 1) = LCase$(INIKey) Then
                ReadINI = Right$(ini(i), (Len(ini(i)) - InStr(ini(i), "=")))
            End If
        Next
    Else
        Do
            If Left$(LCase$(ini(i)), InStr(ini(i), "=") - 1) = LCase$(INIKey) Then
                ReadINI = Right$(ini(i), (Len(ini(i)) - InStr(ini(i), "=")))
            End If
            i = i + 1
        Loop Until ini(i) = ""
    End If
End Function

Sub DelINI (FileName As String, Section As String, INIKey As String)
    Dim sec(0) As Sections: Dim ini(0) As String
    Dim As Single start, finish
    LoadINIFile "Config.ini", ini(), sec()
    If Section <> "" Then
        CheckSection sec(), Section, start, finish, ret$
        For i = start To finish
            If Left$(LCase$(ini(i)), InStr(ini(i), "=") - 1) = LCase$(INIKey) Then
                ReDim temp(UBound(ini) - 1) As String
                For a = 0 To (i - 1)
                    temp(a) = ini(a)
                Next
                For a = i To UBound(temp)
                    temp(a) = ini(a + 1)
                Next

            End If
        Next
    Else
        Do
            If Left$(LCase$(ini(i)), InStr(ini(i), "=") - 1) = LCase$(INIKey) Then
                ReDim temp(UBound(ini) - 1) As String
                For a = 0 To i - 1
                    temp(a) = ini(a)
                Next
                For a = x To UBound(ini)
                    temp(x) = ini(x + 1)
                Next
            End If
            i = i + 1
        Loop Until ini(i) = ""
    End If
    Do
        If temp(UBound(temp)) = "" Then ReDim _Preserve temp(UBound(temp) - 1)
    Loop Until temp(UBound(temp)) <> ""
    f = FreeFile
    Open FileName For Output As #f
    For i = 0 To UBound(temp)
        Print #f, temp(i)
    Next
    Close
End Sub

Sub DelSec (FileName As String, Section As String)
    Dim sec(0) As Sections: Dim ini(0) As String
    Dim As Single start, finish
    LoadINIFile "Config.ini", ini(), sec()
    CheckSection sec(), Section, start, finish, ret$
    Print start, finish
    ReDim Temp(UBound(ini)) As String
    For i = 0 To start
        Temp(i) = ini(i)
    Next

    For i = finish To UBound(ini)
        Temp(i - finish) = ini(i)
    Next
    Do
        If Temp(UBound(Temp)) = "" Then ReDim _Preserve Temp(UBound(Temp) - 1)
    Loop Until Temp(UBound(Temp)) <> ""
    f = FreeFile
    Open FileName For Output As #f
    For i = 0 To UBound(Temp)
        Print #f, Temp(i)
    Next
    Close
End Sub

Sub AddINI (FileName As String, Section As String, INIKey As String, INIData As String)
    Dim sec(0) As Sections: Dim ini(0) As String
    Dim As Single start, finish
    LoadINIFile "Config.ini", ini(), sec()
    CheckSection sec(), Section, start, finish, ret$
    ReDim temp(UBound(ini) + 1) As String
    If ret$ = "New Section" Then
        ReDim temp(UBound(ini) + 3)
        temp(0) = "[" + Section + "]"
        temp(1) = INIKey + "=" + INIData
        temp(2) = ""
        For i = 3 To UBound(ini)
            temp(i) = ini(i - 3)
        Next
    Else

        If Section <> "" Then
            For i = 0 To start
                'Print ini(start): Sleep
                temp(i) = ini(i)
            Next
            temp(start) = INIKey + "=" + INIData
            For i = start + 1 To UBound(ini)
                temp(i) = ini(i - 1)
            Next
        Else
            temp(0) = INIKey + "=" + INIData
            For i = 1 To UBound(ini)
                temp(i) = ini(i - 1)
            Next
        End If

    End If
    Do
        If temp(UBound(temp)) = "" Then ReDim _Preserve temp(UBound(temp) - 1)
    Loop Until temp(UBound(temp)) <> ""
    f = FreeFile
    Open FileName For Output As #f
    For i = 0 To UBound(temp)
        Print #f, temp(i)
        'Print temp(i): _Delay 1
    Next
    Close


End Sub