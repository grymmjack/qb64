'************************************************************
' KOMMAINP.BAS = Zahleneingabe mit Komma statt Dezimalpunkt
' ============
' Dieses QBasic-Programm gestattet eine Eingabe von Zahlen
' mit Komma statt Dezimalpunkt.
'
' Funktionsweise:
' Mit INKEY$ wird ermittelt welche Taste gedrueckt worden
' ist. Wenn keine Taste gedrueckt wurde, dann wird ein
' Leerstring uebergeben. Die eingetippten Textzeichen werden
' wie folgt zu einem String zusammengebaut: Mit SELECT CASE
' wird ausgewertet, was gedrueckt worden ist, und
' dementsprechend die Textvariable veraendert. Ein Komma
' wird sofort in einen Dezimalpunkt umgewandelt. Mit der
' Backspace-Taste ist ein Editieren des Eingabewerts moeglich
' Sobald Enter gedrueckt wurde, wird die Schleife
' verlassen. Danach muss noch der Text mit VAL in eine Zahl
' gewandelt werden.
'
' Momentan wird der Text am Anfang der 2. Bildschirmzeile
' ausgegeben. Man muesste natuerlich die Locate-Befehle
' entsprechend abaendern um die Anzeige an einer anderen
' Stelle zu platzieren
'
' (c) Stefab ( stef_0815*web.de ), 5.3.04
'************************************************************
'
DIM text AS STRING
DIM Eing AS STRING
CLS
'
PRINT "Gib eine Zahl mit Komma ein";
LOCATE 2, 1, 1   'Cursor anzeigen
DO
Eing = INKEY$
'
SELECT CASE Eing
'--- Ziffer ---
CASE "0" TO "9", "d", "D", "e", "E", "-"
  text = text + Eing
  LOCATE 2, 1
  PRINT text;
  LOCATE , , 1    'Cursor anzeigen
'
'--- Komma ---
CASE ".", ","
  text = text + "."
  LOCATE 2, 1
  PRINT text;
  LOCATE , , 1    'Cursor anzeigen
'
'--- Ruecksetztaste (Backspace) ---
'loescht das letzte Zeichen
CASE CHR$(8)
  IF LEN(text) THEN
  text = LEFT$(text, LEN(text) - 1)
  LOCATE 2, 1
  PRINT text + " ";
  LOCATE , POS(0) - 1, 1  'Cursor anzeigen
  END IF
END SELECT
'
LOOP UNTIL Eing = CHR$(13)
'--- Schleife verlassen, wenn Enter gedrueckt worden ist ---
variable = VAL(text) 'String in numerischen Zahlenwert wandeln
PRINT
PRINT
PRINT variable

