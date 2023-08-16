'*************************************************************
' DIR_2.BAS = Inhalt eines Verzeichnisses auflisten mit SHELL
' ==========
' Anzeige des Inhalts eines Verzeichnisses mit Hilfe
' des Befehls SHELL "DIR.."
' Das Programm liest die Dateinamen ein, speichert
' sie dabei mit Hilfe einer Ausgabeumleitung und gibt
' sie auf dem Bildschirm aus.
' Achtung! Ss werden die Ordner wie Dateien angezeigt.
'
' (c) CarlT (CarlT*gmx.net), 15.9.02
'*************************************************************
DEFINT A-Z
CLS
DIM k AS STRING * 80  'String um das Einlesen zu begrenzen
DIM a(1499) AS STRING 'Feld um die Dateinamen zu speichern
ent$ = CHR$(13)
'
SHELL "dir/b *.* >datei.dat"      'Schreiben der Datei
OPEN "datei.dat" FOR BINARY AS #1 'Oeffnen als Binaer-Datei
'
FOR x = 1 TO LOF(1) 'von 1 bis Ende der datei
  GET #1, x, k      'Einlesen
  df = df + 1       'Zaehlen der Dateien
  IF df > 1499 THEN EXIT FOR 'Verhindert Ueberlauf
  gh = INSTR(k, ent$) 'Stellt Position des Zeilenumbruchs fest
  x = x + gh 'positioniert den Datei-Positionszeiger neu ein
  a(df) = LEFT$(k, gh - 1) 'extrahiert u.speicher d.Dateinamen
NEXT x
'
PRINT "Fertig! Druecken Sie zur Anzeige eine beliebige Taste"
SLEEP
df = 0 'Zaehler zuruecksetzen
DO
  df = df + 1 'Zaehlen
  fg$ = a(df) 'zuweisen des gespeicherten Namens
  PRINT fg$   'Ausdrucken dieses Namens
  LOOP WHILE fg$ <> "" 'Kontrolliert ob alle aufgerufen wurden
END

