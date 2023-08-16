'*************************************************************
' Dir_1.bas = Inhalt eines Verzeichnisses auflisten ohne SHELL
' =========
' Dies Programm enthält die FUNCTION DIR$, die den Inhalt
' eines Verzeichnisses auflistet - aehnlich dem DIR$-Befehl
' bei QuickBasic 7.1. Die FUNCTION DIR$ wird beispielhaft
' augerufen zum Anzeigen aller *.EXE-Dateien im aktuellen
' Verzeichnis.
'
' Das Programm ist nur unter QuickBASIC 4.5/7.1 und nicht
' unter QBasic ablauffaehig, weil es den CALL INTERRUPT
' Befehl verwendet.
'
' (c) ensugo, 28.6.2002
'*************************************************************
DECLARE FUNCTION dir$ (filespec$)
'
DEFINT A-Z
'--------------------------------
TYPE RegTyp
AX AS INTEGER
BX AS INTEGER
CX AS INTEGER
DX AS INTEGER
BP AS INTEGER
SI AS INTEGER
DI AS INTEGER
Flags AS INTEGER
DS AS INTEGER
ES AS INTEGER
END TYPE
'
' Temp. Suchinfos.
TYPE SBuffer
STemp AS STRING * 21
FAttr AS STRING * 1
FTime AS INTEGER
FDate AS INTEGER
FSize AS LONG
FName AS STRING * 13
END TYPE
'---------------------------------
'
DIM SHARED Regs AS RegTyp
'
CLS
'
' Beispiel
Suchmaske$ = "*.exe" ' Suchmaske (Pfad moeglich).
Anzahl = 0
Datei$ = dir(Suchmaske$)
DO WHILE Datei$ <> ""
Anzahl = Anzahl + 1
PRINT Datei$
Datei$ = dir("") ' Suche fortsetzen.
LOOP
'
PRINT STRING$(25, "-")
PRINT Anzahl; "Dateien gefunden"

'
FUNCTION dir$ (filespec$)
'
DIM TempFSpec AS STRING
STATIC Buffer AS SBuffer
'
' Akt. DTA ermitteln.
Regs.AX = &H2F00 ' Get DTA
CALL interruptx(&H21, Regs, Regs)
OldDTASeg = Regs.ES
OldDtaOffs = Regs.BX
'
' DTA auf Buffer setzen.
Regs.AX = &H1A00
Regs.DS = VARSEG(Buffer)
Regs.DX = VARPTR(Buffer)
CALL interruptx(&H21, Regs, Regs)
' Wenn Suchmaske angegeben, neue Suche starten.
' Sonst fortsetzen.
IF LEN(filespec$) THEN
TempFSpec = filespec$ + CHR$(0)
' FindFirst.
Regs.AX = &H4E00
Regs.CX = 0 ' (39) Dateiattribute.
Regs.DS = VARSEG(TempFSpec)
Regs.DX = SADD(TempFSpec)
CALL interruptx(&H21, Regs, Regs)
'
ELSE
' FindNext.
Regs.AX = &H4F00
CALL interrupt(&H21, Regs, Regs)
END IF
'
IF (Regs.Flags AND 1) = 0 THEN dir$ = LEFT$(Buffer.FName, INSTR(Buffer.FName, CHR$(0)) - 1)
'
' DTA wiederherstellen.
Regs.AX = &H1A00
Regs.DS = OldDTASeg
Regs.DX = OldDtaOffs
CALL interruptx(&H21, Regs, Regs)
'
END FUNCTION

