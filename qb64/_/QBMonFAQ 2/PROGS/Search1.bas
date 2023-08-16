'**************************************************************
' Search1.BAS = Nach Dateien suchen in einem waehlbaren Pfad
' ============
' Q(uick)Basic-Programm zur Suche nach nach Dateien.
' Alle Dateien mit dem angegebenen Namen in dem angegebenen
' Pfad werden angezeigt. Platzhalter "*" und "?" sind erlaubt
'
' 26.9.01
'**************************************************************
'
DEFINT A-Z
DECLARE FUNCTION SearchFile$ (File$,Path$,SubDirs)
'
CLS
INPUT "Suchen nach (Dateiname): ", Datei$
INPUT "Suchen in (Pfadname; ohne abschliessendes \): ", Pfad$
DO
  INPUT "Unterverzeichnisse: (J/N) ", Wahl$
  Wahl$ = UCASE$(Wahl$)
  SELECT CASE Wahl$
    CASE "J"
      SubDirs = 1
      EXIT DO
    CASE "N"
      SubDirs = 0
      EXIT DO
  END SELECT
LOOP
'
PRINT "Bitte warten!"
Dateiliste$ = SearchFile(Datei$, Pfad$, SubDirs)
'
PRINT
OPEN Dateiliste$ FOR INPUT AS 1
DO
  FOR I = 1 TO 22
    IF EOF(1) THEN EXIT DO
    LINE INPUT #1, Datei$
    PRINT Datei$
  NEXT I
'
  PRINT "Weiter mit Taste..."
  DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""
  IF Taste$ = CHR$(27) THEN EXIT DO
LOOP
CLOSE
'
KILL Dateiliste$
'
FUNCTION SearchFile$ (File$, Path$, SubDirs)
'SubDirs=0 oder 1
'
IF Path$ <> "" THEN
  IF MID$(Path$, LEN(Path$), 1) <> "\" THEN Path$ = Path$ + "\" ' "\" Anhaengen, wenn fehlt
END IF
'
TempFile$ = ENVIRON$("TEMP") + "\DIR.TXT" 'Ausgabedatei
IF SubDirs <> 0 THEN S$ = "/S "
SHELL "DIR /A " + S$ + "/B " + Path$ + File$ + " >" + TempFile$ 'Suchen
SearchFile$ = TempFile$
'
END FUNCTION



