'******************************************************************
' ZALINPUT.BAS - Auf Zahlen beschraenkte Tasteneingabe
' ============
' Dieses Programm ist ein Ersatz fuer den INPUT-Befehl und
' unterdrueckt Fehleingaben: Es werden nur die Tasten 0...9
' angenommen. Drueckt der Anwender eine andere Taste, passiert -
' gar nichts. Die Enter-Taste beendet die Eingabe.
'
' (c) Thomas Antoni, 25.8.02 - 2.3.04
'*******************************************************************
CLS
PRINT "Gib eine Zahl bis 32000 ein"
PRINT "...Abschluss mit Eingabe-Taste"
DO
LOCATE , , 1                    'Cursor anzeigen
t$ = INKEY$
IF t$ <> "" THEN
  IF t$ = CHR$(13) THEN EXIT DO 'Abschluss der Eingabe Enter
  IF t$ >= "0" AND t$ <= "9" THEN
    Eingabe$ = Eingabe$ + t$
    PRINT t$;
  ELSE
  BEEP
  END IF
END IF
LOOP
'
eingabezahl% = VAL(Eingabe$) 'Eingabezahl in Integer-Wert umwandeln
PRINT
PRINT "Du hast "; eingabezahl%; " eingegeben."

