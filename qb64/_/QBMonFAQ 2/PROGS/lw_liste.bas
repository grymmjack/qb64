'****************************************************************************
' LW_LISTE.BAS = Ermittlung der Laufwerksliste inkl. Typ
' ============
' (c) Andreas Meile
'****************************************************************************
DIM lw$(1 TO 10), typ%(1 TO 10)
'
OPEN ENVIRON$("TEMP") + "\~LWLISTE.VBS" FOR OUTPUT AS 1
PRINT #1, "Option Explicit"
PRINT #1, "Dim oFS, aLW, oLW, oTs"
PRINT #1, "Set oFS = CreateObject(" + CHR$(34) + "Scripting.FileSystemObject" + CHR$(34) + ")"
PRINT #1, "Set oTs = oFS.CreateTextFile(" + CHR$(34) + ENVIRON$("TEMP") + "\~LWLISTE.TXT" + CHR$(34) + ")"
PRINT #1, "Set aLW = oFS.Drives"
PRINT #1, "For Each oLW in aLW"
PRINT #1, "  oTs.WriteLine oLW.DriveLetter & vbTab & oLW.DriveType"
PRINT #1, "Next"
PRINT #1, "oTs.Close"
PRINT #1, "Set oTs = Nothing"
PRINT #1, "Set aLW = Nothing"
PRINT #1, "Set oFS = Nothing"
CLOSE 1
SHELL "cscript //NoLogo " + ENVIRON$("TEMP") + "\~LWLISTE.VBS"
KILL ENVIRON$("TEMP") + "\~LWLISTE.VBS"
'
OPEN ENVIRON$("TEMP") + "\~LWLISTE.TXT" FOR INPUT AS 1
nLw% = 0
WHILE NOT EOF(1)
  nLw% = nLw% + 1
  LINE INPUT #1, z$
  p% = INSTR(z$, CHR$(9))
  lw$(nLw%) = LEFT$(z$, p% - 1)
  typ%(nLw%) = VAL(MID$(z$, p% + 1))
WEND
CLOSE 1
KILL ENVIRON$("TEMP") + "\~LWLISTE.TXT"
'
' Liste ausgeben
PRINT "Gefundene Laufwerke auf diesem Computer:"
FOR i% = 1 TO nLw%
  PRINT lw$(i%); ":\ ";
  SELECT CASE typ%(i%)
  CASE 1
    PRINT "Diskette/Floppy (entfernbar)"
  CASE 2
    PRINT "Festplatte"
  CASE 3
    PRINT "Netzwerk (NET USE)"
  CASE 4
    PRINT "CD-ROM/DVD"
  CASE 5
    PRINT "RAM-Drive (RAMDRIVE.SYS)"
  CASE ELSE
    PRINT "Unbekannt:"; typ%(i%)
  END SELECT
NEXT i%

