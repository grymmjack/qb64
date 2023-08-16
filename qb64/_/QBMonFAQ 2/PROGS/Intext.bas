'****************************************************************************
' INTEXT.BAS = QBasic-Function zur Tasteneingabe definierter Laenge
' =====================================================================
' Die eigentliche Funktionalität ist in der FUNCTION Intext$ hinterlegt.
' Das Hauptprogramm ist eine kleine Demo für Intext$ .
'
'   \         (c) Thomas Antoni, 12.07.99 - 18.2.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de 
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'
'****************************************************************************
DECLARE FUNCTION Intext$ (length%)
'
DO
  CLS
  LOCATE 4
  PRINT "  -----===== Willkommen zu Intext$! =====-----"
  PRINT
  PRINT "      Gib einen 14 Zeichen langen Text ein:"
  LOCATE 10, 8
'-------------------------
  eingabe$ = Intext$(14)
'-------------------------
  COLOR 15, 0        'Farbe wieder Weiss auf Schwarz
  LOCATE 15, 2
  IF eingabe$ = CHR$(27) THEN
    PRINT "Du hast die Eingabe mit Esc abgebrochen,";
    PRINT "und es wurde CHR(27) zurueckgeliefert"
  ELSE
    PRINT "Du hast folgendes eingegeben:"
    LOCATE 17, 8
    PRINT eingabe$
  END IF
  LOCATE 20, 2
  PRINT "Wiederholung mit beliebiger Taste, Abbruch mit Esc"
  DO: taste$ = INKEY$
  LOOP WHILE taste$ = ""
LOOP WHILE taste$ <> CHR$(27)
  CLS
  LOCATE 12, 8
  PRINT "Danke, dass Du Intext$ ausprobiert hast!"
  SLEEP 1
END

FUNCTION Intext$ (length%)
'*****************************************************************************
' Intext$ (length%) - QBasic Funktion zur Tastatureingabe begrenzter Laenge
' ============================================================================
' Diese Funktion ersetzt den INPUT-Befehl und ermoeglicht Tastatur-Eingaben
' definierter Laenge.
' Die Funktion liefert maximal length% alphanumerische Text-Zeichen zurueck,
' die ber die Tastatur eingeben werden koennen. Die Tastatureingabe wird
' mit der Enter-Taste abgeschlossen. Ein Editieren des Eingabetextes ist
' mit der Backspace-Taste moeglich. šber die Esc-Taste laesst sich eine
' Eingabe abbrechen; in diesem Falle liefert Intext den Wert   CHR(27) zurueck
' (ASCII- Code von Esc).
' Die Cursortasten sowie Delete, Home und End werden nicht ausgewertet.
' Das Eingabefeld erscheint als blauer Kasten auf den Bildschirm. Das Echo
' der eingegebenen Zeichen erfolgt in gelb.
'
' Das aufrufende Programm ist dafuer verantwortlich
'   - den Cursor vor dem Aufruf richtig zu setzen (z.B. mit LOCATE)
'   - nach Abschluss der Funktion die alten Bildschirmfarben wiederher-
'     zustellen
'   - den Abbruch der Eingabe durch die Esc-Taste zu bearbeiten (in diesem
'     Fall ist der Ruecklieferwert CHR$(27) ).
'
' (c) Thomas Antoni, 12.07.99 - 5.11.02
'****************************************************************************

COLOR 14, 3 'gelb auf cyan
begin% = POS(0): row% = CSRLIN           'Cursorposition Spalte/Zeile sichern
text$ = "": key$ = ""

DO
'------------------ Enter- und Esc-Taste bearbeiten -------------------------
  IF key$ = CHR$(13) THEN EXIT DO        'Ende wenn Enter betaetigt
  IF key$ = CHR$(27) THEN                'bei Abbruch ASCII-Zeichen von Esc
    text$ = CHR$(27)                     'zurueckliefern
    EXIT DO
  END IF

'------------------------ Backspace-Taste bearbeiten ------------------------
  IF key$ = CHR$(8) AND LEN(text$) > 0 THEN  'Backspace und Textlaenge > 0 ?
    text$ = LEFT$(text$, LEN(text$) - 1)     'Text um 1 Zeichen kuerzen

'-------------------------- andere Tasten bearbeiten ------------------------
  ELSEIF key$ > CHR$(29) AND key$ < CHR$(255) THEN 'alfanum. Taste?
    IF LEN(text$) = length% THEN             'Text hat schon die volle Laenge
      text$ = LEFT$(text$, LEN(text$) - 1) + key$ 'letztes Zeichen austauschen
    ELSE
      text$ = text$ + key$                   'ansonsten Tastenzeichen anfuegen
    END IF
  END IF
'--------------- text$ und Cursor auf Bildschirm ausgeben -------------------
  LOCATE row%, begin%: PRINT SPACE$(length%); 'Eingabefeld loeschen/blau faerben
  LOCATE , begin%: PRINT text$;              'Text ausgeben
  IF LEN(text$) < length% THEN csrpos% = POS(0) ELSE csrpos% = POS(0) - 1
  LOCATE row%, csrpos%, 1, 1          'Cursor ausgeben
  DO: key$ = INKEY$: LOOP WHILE key$ = ""     'warten bis Taste betaetigt
LOOP
LOCATE , , 0                          'Cursor wieder deaktivieren
Intext$ = text$
END FUNCTION

