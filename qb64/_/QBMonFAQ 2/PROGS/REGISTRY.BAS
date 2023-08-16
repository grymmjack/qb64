'*******************************************************************************
' REGISTRY.BAS - Zugriff auf Windows Registry
' ============
' Dieses QBasic-Programm schreibt beispielhaft einen Eintrag in die Windows
' Registry und liest ihn wieder aus. Dazu wird auf VBScript und den Windows
' Scripting Host zur¸ckgegriffen
'
' (c) Andreas Meile ( qbasicde*dreael.ch - www.dreael.ch ) , 10.1.2004
'*******************************************************************************
DECLARE SUB SchreibeInRegistry (Schluessel$, Wert$, Typ$)
DECLARE SUB LoescheInRegistry (Schluessel$)
DECLARE FUNCTION LeseRegistry$ (Schluessel$)
'
' Demonstration
SchreibeInRegistry "HKCU\Software\ACME\FortuneTeller\MindReader", "Goocher!", "REG_SZ"
PRINT LeseRegistry("HKCU\Software\ACME\FortuneTeller\MindReader")
LoescheInRegistry "HKCU\Software\ACME\FortuneTeller\MindReader"
'
FUNCTION LeseRegistry$ (Schluessel$)
  OPEN ENVIRON$("TEMP") + "\~REGREAD.VBS" FOR OUTPUT AS 1
  PRINT #1, "Set oSh = WScript.CreateObject(" + CHR$(34) + "WScript.Shell" + CHR$(34) + ")"
  PRINT #1, "Set oFS = WScript.CreateObject(" + CHR$(34) + "Scripting.FileSystemObject" + CHR$(34) + ")"
  PRINT #1, "Set oTs = oFS.CreateTextFile(" + CHR$(34) + ENVIRON$("TEMP") + "\~REGROUT.TXT" + CHR$(34) + ", True)"
  PRINT #1, "oTs.WriteLine oSh.RegRead(" + CHR$(34) + Schluessel$ + CHR$(34) + ")"
  PRINT #1, "oTs.Close"
  PRINT #1, "Set oTs = Nothing"
  PRINT #1, "Set oFS = Nothing"
  PRINT #1, "Set oSh = Nothing"
  CLOSE 1
  ' Generiertes Script ausfuehren
  SHELL "cscript //NoLogo " + ENVIRON$("TEMP") + "\~REGREAD.VBS"
  ' die .VBS brauchen wir bereits nicht mehr
  KILL ENVIRON$("TEMP") + "\~REGREAD.VBS"
  ' Wert auslesen
  OPEN ENVIRON$("TEMP") + "\~REGROUT.TXT" FOR INPUT AS 1
  LINE INPUT #1, w$
  CLOSE 1
  ' Ausgabedatei ebenfalls lîschen
  KILL ENVIRON$("TEMP") + "\~REGROUT.TXT"
  LeseRegistry$ = w$
END FUNCTION

SUB LoescheInRegistry (Schluessel$)
  OPEN ENVIRON$("TEMP") + "\~REGWRI.VBS" FOR OUTPUT AS 1
  PRINT #1, "Set oSh = WScript.CreateObject(" + CHR$(34) + "WScript.Shell" + CHR$(34) + ")"
  PRINT #1, "oSh.RegDelete " + CHR$(34) + Schluessel$ + CHR$(34)
  PRINT #1, "Set oSh = Nothing"
  CLOSE 1
  ' Soeben generiertes Script ausfuehren
  SHELL "cscript //NoLogo " + ENVIRON$("TEMP") + "\~REGWRI.VBS"
  ' Und gleich wieder loeschen nach Gebrauch
  KILL ENVIRON$("TEMP") + "\~REGWRI.VBS"
END SUB

SUB SchreibeInRegistry (Schluessel$, Wert$, Typ$)
  OPEN ENVIRON$("TEMP") + "\~REGWRI.VBS" FOR OUTPUT AS 1
  PRINT #1, "Set oSh = WScript.CreateObject(" + CHR$(34) + "WScript.Shell" + CHR$(34) + ")"
  PRINT #1, "oSh.RegWrite " + CHR$(34) + Schluessel$ + CHR$(34) + ", " + CHR$(34) + Wert$ + CHR$(34) + ", " + CHR$(34) + Typ$ + CHR$(34)
  PRINT #1, "Set oSh = Nothing"
  CLOSE 1
  ' Soeben generiertes Script ausfÅhren
  SHELL "cscript //NoLogo " + ENVIRON$("TEMP") + "\~REGWRI.VBS"
  ' Und gleich wieder loeschen nach Gebrauch
  KILL ENVIRON$("TEMP") + "\~REGWRI.VBS"
END SUB

