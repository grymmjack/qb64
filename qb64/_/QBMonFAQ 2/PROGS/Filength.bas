'****************************************************************************
' FILENGTH.BAS = Ermittlung der Laenge und Zeilenzahl einer Datei
' ============
' Dieses QBasic-Programm ermittelt die Laenge (Anzahl von Bytes)
' und die Anzahl der Zeilen einer Datei. Das Programm funktioniert auch
' bei Dateien der Laenge 0.
'
' (c) Sebastian Steiner, Andreas Meile und Thomas Antoni, 27.12.04-8.1.05
'****************************************************************************
CLS
INPUT "Wie lautet Pfad und Name der Textdatei "; Datei$
a& = 0'Zeilenzaehler vorbesetzen
OPEN Datei$ FOR INPUT AS #1
Laenge& = LOF(1)
'
IF Laenge& > 0 THEN
  DO
    LINE INPUT #1, TEMP$
    a& = a& + 1
  LOOP UNTIL EOF(1)
END IF
'
CLOSE #1
PRINT "Die Datei ist "; Laenge&; " Bytes lang";
PRINT " und hat "; a&; " Zeilen."
SLEEP

