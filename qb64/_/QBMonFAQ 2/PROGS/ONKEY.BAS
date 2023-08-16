'*****************************************************************************
'
' ONKEY.BAS = QBasic-Programm zur Demonstration der ON KEY Funktion
' =================================================================
' Im Hauptprogramm wird der Anzeigewert mit Hoeher-/Tiefertaste veraendert.
' Die F1- und F2-Taste werden nicht zyklisch abgefragt ("gepollt"), sondern
' ereignisgesteuert (Interrupt-gesteuert) nur bei Tastenbetaetigung mit
' ON KEY... bearbeitet. Die Bearbeitungsroutine "Hilfe" der F1-Taste gibt
' unten auf dem Bildschirm einen Hilfetext aus. Die Bearbeitungsroutine
' "HilfeEnde" der F2-Taste loescht den Hilfetext wieder. Die Tastenbear-
' beitungsroutinen sind lokale Subroutinen.
'
' (c) Thomas Antoni, 03.03.00 - 23.02.04
'       thomas*antonis.de
'
'*****************************************************************************
CLS

'------ Ereignisgesteuerte Bearbeitung der F1- u.F2-Taste aktivieren ------
KEY(1) ON                 'Ereignisverfolgung fuer F1-Taste einschalten
ON KEY(1) GOSUB Hilfe     'Bearbeitung fuer F1-Taste aufrufen

KEY(2) ON                 'Ereignisverfolgung fuer die F2-Taste einschalten
ON KEY(2) GOSUB HilfeEnde 'Bearbeitung fuer F2-Taste aufrufen


'------- Hauptprogramm -------------------------------------------------------
PRINT " ONKEY.BAS - Demoprogramm fuer die ereignisgestuerte Tastenbearbeitung"
LOCATE 16
PRINT " [F1-Taste] ... Hilfe anfordern"
DO
  Taste$ = INKEY$
  IF Taste$ = CHR$(0) + "H" THEN x = x + 1
  IF Taste$ = CHR$(0) + "P" THEN x = x - 1
  LOCATE 7, 1: PRINT x
LOOP WHILE Taste$ <> CHR$(27)
END

'-------- F1-Taste ereignisgesteuert bearbeiten: --------------------------
'-------- Hilfefenster anzeigen
Hilfe:
zeile% = CSRLIN: spalte% = POS(0)
COLOR 12
LOCATE 18, 1
PRINT " ------------ Hilfe-Fenster ------------------ "
PRINT " [F2]-Taste........ schliesst das Hilfe-Fenster"
PRINT " [H”her]-Taste..... erhoeht den Anzeigewert"
PRINT " [Tiefer]-Taste.... reduziert den Anzeigewert"
PRINT " [Esc]-Taste....... beendet das Programm"
LOCATE zeile%, spalte% 'alte Cursorpostion wiederherstellen   
COLOR 7                'alte Textfarbe hellgrau wiederherstellen
RETURN

'-------- F2-Taste ereignisgesteuert bearbeiten: -------------------------
'-------- Hilfefenster loeschen
HilfeEnde:
zeile% = CSRLIN: spalte% = POS(0)
COLOR 12           'Hellroter Text
LOCATE 18, 1
PRINT SPC(70); " " 'Hilfetext loeschen (mit Blanks ueberschreiben)
PRINT SPC(70); " "
PRINT SPC(70); " "
PRINT SPC(70); " "
PRINT SPC(70); " "
LOCATE zeile%, spalte% 'alte Cursorpostion wiederherstellen
COLOR 15               'alte Textfarbe hellgrau wiederherstellen
RETURN






