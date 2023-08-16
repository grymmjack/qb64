'**********************************************************************
' DESKTOP.BAS = Desktop-Verknuepfung fuer ein QB-EXE-Programm mit Icon
' ===========   erzeugen
'
' Dieses Q(uick)Basic-Programm erzeugt fuer ein beliebiges DOS-EXE-
' Programm auf dem Desktop eine Verknuepfung und bewirkt, dass es dort
' mit einem waehlbaren Icon angezeigt wird. Somit ist das EXE-Programm
' aehnlich einem Windows-Programm mit einem Mausklick auf das Desktop-
' Icon startbar. DESKTOP.BAS verwendet den Windows Scriptin Host und
' wurde unter Windows NT4 erfolgreich getestet. Unter Windows XP
' muesste es ebenfalls funktionieren.
'
' (c) Andreas Meile
'**********************************************************************

LINE INPUT "Name der Verknuepfung? ", n$
LINE INPUT "Ort (Pfadname ohne abschliessendes\) d.ausfuehrbaren Datei? "; v$
LINE INPUT "Name der ausfuehrbaren Datei (ohne Pfad)? "; d$
LINE INPUT "Kommentar? "; k$
LINE INPUT "Datei, von der dasIcon uebernommen werden soll (mit Pfad)? "; q$
'
OPEN ENVIRON$("TEMP") + "\~SHORTC.VBS" FOR OUTPUT AS 1
PRINT #1, "Option Explicit"
PRINT #1, "Dim oSh, oLnk"
PRINT #1, "Set oSh = WScript.CreateObject(" + CHR$(34) + "WScript.Shell" + CHR$(34) + ")"
PRINT #1, "Set oLnk = oSh.CreateShortcut(oSh.SpecialFolders(" + CHR$(34) + "Desktop" + CHR$(34) + ") & " + CHR$(34) + "\" + n$ + ".lnk" + CHR$(34) + ")"
PRINT #1, "oLnk.TargetPath = " + CHR$(34) + v$ + "\" + d$ + CHR$(34)
PRINT #1, "oLnk.IconLocation = " + CHR$(34) + q$ + ", 0" + CHR$(34)
PRINT #1, "oLnk.Description = " + CHR$(34) + k$ + CHR$(34)
PRINT #1, "oLnk.WorkingDirectory = " + CHR$(34) + v$ + CHR$(34)
PRINT #1, "oLnk.Save"
PRINT #1, "Set oLnk = Nothing"
PRINT #1, "Set oSh = Nothing"
CLOSE 1
SHELL "cscript //NoLogo " + ENVIRON$("TEMP") + "\~SHORTC.VBS"
KILL ENVIRON$("TEMP") + "\~SHORTC.VBS"

