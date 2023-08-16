'************************************************************
' FileSize.bas = Ermittelt die Groesse einer waehlbaren Datei
' ============
' Dazu wird die LOF-Funktion verwendet (LOF = Length Of File)
' (c) Thomas Antoni, 22.06.2002
'************************************************************
DECLARE FUNCTION FileSize& (Datei$)
CLS
INPUT "Gib den Pfadnamen ohne abschliessendes \ ein "; Pfad$
INPUT "Gib den Dateinamen ein "; Datei$
DateiPfad$ = Pfad$ + "\" + Datei$
PRINT "Die Datei ist "; FileSize&(DateiPfad$); " Bytes lang"
END

'
FUNCTION FileSize& (Datei$)
DNr% = FREEFILE
OPEN Datei$ FOR BINARY AS #DNr%
Byte& = LOF(DNr%)
CLOSE DNr%
FileSize& = Byte&
END FUNCTION

