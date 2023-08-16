'***************************************************************************
' SCRENLES.BAS = Inhalt des Textbildschirms SCREEN 0 mit PEEK in Datei lesen
' ============
' Dieses Q(uick)Basic-Programm liest den Textbereich des Bildschirmspeichers
' aus dem Speichersegment mit Hilfe des PEEK-Befehls aus und schreibt ihn
' in eine Datei. Die Anzahl der Spalten wird in xres uebergeben (typ. 80),
' die Anzahl der Zeilen in yres (typ. 25).
'
' (c) jb, 18.12.2005
'****************************************************************************
DECLARE SUB SaveScreen (Dateiname$, xres%, yres%)
CLS
FOR i% = 1 TO 25
  LOCATE i%, i% * 2
  PRINT "Thomas Antoni"; i%;     'Bildschirm mit Text fuellen
NEXT
Dateiname$ = "C:\tmp.txt"        'Temporaere Datei zum Eintragen des
                                 'Bildschirminhalts
CALL SaveScreen(Dateiname$, 80, 25) 'Bildschirminhalt 80 Spalten u.25 Zeilen
                                 'auslesen und in Datei eintragen
END
'
SUB SaveScreen (Dateiname$, xres AS INTEGER, yres AS INTEGER)
DIM Zeichen AS STRING * 1        'Variable fuer ein Zeichen
DIM Zeile$
F = FREEFILE
OPEN Dateiname$ FOR OUTPUT AS #F ' Datei oeffnen
DEF SEG = &HB800                 'Segment setzen
FOR Z% = 1 TO yres STEP 1        'Schleife ueber alle Zeilen
  Zeile$ = ""                    'Zeile ruecksetzen
  FOR Spalte = 1 TO xres STEP 1
    Zeichen = CHR$(PEEK((Z% - 1) * 160 + ((Spalte - 1) * 2)))
                                 'Aktuelles Zeichen isolieren
    Zeile$ = Zeile$ + Zeichen    'Und zur Zeile hinzufügen
  NEXT Spalte
  PRINT #F, Zeile$               'Zeile in die Datei schreiben
NEXT Z%
DEF SEG                          'Segment wieder zuruecksetzen
CLOSE #F                         'Datei wieder schliessen
END SUB

