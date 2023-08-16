'************************************************************************
' KEYESC.BAS - Tastatureingabe, die mit Esc abbrechbar ist
' =============================================================
' Diese Routine ersetzt den INPUT-Befehl und ermoeglicht es im Gegensatz
' zu diesem, die Eingabe mittendrin mit der Esc-Taste abzubrechen.
' Beim INPUT-Befehl hingegen bricht die Esc-Taste nicht die ganze Eingabe
' ab, sondern loescht nur die bis dahin erfolgte Eingabe und wartete auf
' eine erneute Eingabe. Ein laufender INPUT laesst sich nur mit [Strg+C]
' abbrechen.
'
' Der Anwender wird aufgefordert, einen Text einzugeben. Esc bricht die
' Tasteneingabe ab und uebergibt einen Leerstring. Der eingegebene Text
' laesst sich mit der Backspace-Taste ("Zurueck") editieren.
'
' Von Lebostein (Lebostein*gmx.de), 19.5.2003
'************************************************************************
CLS
Eingabe$ = ""
PRINT "Eingabe: ";
DO
LOCATE , , 1 'blinkenden Cursor anzeigen
DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""
'
SELECT CASE Taste$
CASE CHR$(32) TO CHR$(255) 'darstellbares ASCII-Zeichen
  Eingabe$ = Eingabe$ + Taste$
CASE CHR$(8) 'Backspace-Taste
  IF LEN(Eingabe$) > 0 THEN Eingabe$ = LEFT$(Eingabe$, LEN(Eingabe$) - 1)
  'Backspace-Taste loescht den letzten Buchstaben
CASE CHR$(13) 'Enter beendet die Eingabe
  EXIT DO
CASE CHR$(27) 'Esc loescht die Eingabe und bricht sie ab
  Eingabe$ = ""
  EXIT DO
END SELECT
'
LOCATE 1, 11: PRINT SPACE$(69);
'Anzeigebereich loeschen (mit Blanks Åberschreiben)
LOCATE 1, 11: PRINT Eingabe$;
LOOP
LOCATE 10, 1
PRINT "Du hast Folgendes eingegeben: "; Eingabe$
SLEEP

