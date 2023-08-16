'****************************************************************
' INPUESC.BAS = INPUT mit Esc abbrechbar machen (Eingaberoutine)
' ===========
'
' Dieses Q(uick)Basic-Programm demonstriert, wie man eine
' Tastatureingabe mit Exc abbrechbar machen kann. Die enthaltene
' Funktion "Eingabe$()" ersetzt den INPUT-Befehl. Die Esc-Taste
' hat dieselbe Funktion erhalten wie die Eingabetaste: Sie
' beendet die Eingabe und uebergibt den eingebenen Textstring an
' das aufrufende Programm.
'
' Hierzu wird jede Tastenbetaetigung einzeln mit INKEY$ abgefragt.
' Im Gegensatz dazu kann eine Eingabe mit dem INPUT-Befehl nicht
' mit Esc abgebrochen werden. Esc bewirkt hier lediglich ein
' Ruecksetzen der Eingabewertes. Bei INPUT erfolgt der Abbruch
' mit [Strg+C] statt mit Esc. Das erschwert eine durchgaengige
' Bedienphilosophie, bei der ein Abbruch mit Esc in JEDER
' Situation moeglich ist.
'
' (c) jb und Thomas Antoni, 11.2.2006
'********************************************************
DECLARE FUNCTION Eingabe$ ()
CLS
PRINT "Das ist irgendein Text!"
PRINT
t$ = Eingabe$     'Eingaberoutine aufrufen
PRINT
PRINT
PRINT "Du hast Folgendes eingegeben: "; t$
END
 


FUNCTION Eingabe$
e$ = ""             'Eingabestring zuruecksetzen
zeile% = CSRLIN     'Cursorposition retten
spalte% = POS(0)
LOCATE zeile%, spalte%, 1        'Cursor anzeigen
'
DO                  'Zeichen fur Zeichen in Schleife abfragen
DO: taste$ = INKEY$: LOOP UNTIL taste$ <> ""  'warten auf Taste
oldlength = LEN(e$) 'alte Laenge der Eingabe sichern
'
SELECT CASE taste$  'Welche Taste wurde gedrueckt?
  CASE CHR$(8)      'Backspace
    IF LEN(e$) > 0 THEN e$ = LEFT$(e$, LEN(e$) - 1)
  CASE CHR$(13)     'Eingabetaste
    EXIT DO
  CASE CHR$(27)     'Esc-Taste beendet die Eingabe
    EXIT DO         'Hier "END" eintragen, wenn das ganze Programm
                    'mit Esc abgebrochen werden soll
  CASE CHR$(31) TO CHR$(127)  'beliebiges alfanumerisches Zeichen
    e$ = e$ + taste$
END SELECT
'
IF LEN(e$) <> oldlength THEN  'hat sich die Eingabe veraendert?
  IF LEN(e$) > oldlength THEN 'Eingabestring ist laenger geworden
    LOCATE zeile%, spalte%
    PRINT e$;
  ELSE                        'Eingabestring ist kuerzer geworden
    LOCATE zeile%, spalte%
    PRINT STRING$(oldlength, " ");    'alte Anzeige loeschen
    LOCATE zeile%, spalte%
    PRINT e$;      'Neuen Eingabestring anzeigen   
  END IF
END IF
LOOP
Eingabe$ = e$
END FUNCTION

