'********************************************************
' KEYSTAT2.BAS - Abfrage der Sondertasten mit ON KEY
' ============
' Die Sondertasten Shift, Strg, Alt, NumLock usw. werden
' mit Hilfe des Befehls ON KEY abgefragt. Bei Erkennen
' eines Tastendrucks wird die entsprechende Taste fuer
' 1 sec. auf dem Bildschirm angezeigt.
'
' (c) Thomas Antoni, 24.6.2003
'********************************************************
CLS
PRINT "--------- Druecke eine der folgenden Tasten";
PRINT " (Ende mit Esc)----------"
PRINT "Shift-l | Shift-r | Strg | Alt | Rollen |";
PRINT " Num| ShiftLock | Einfuegen"
'
'***** Benutzerdefinierte Tasten definieren
KEY 15, CHR$(0) + CHR$(42) 'Shift-links-Taste
' Tastennummer 15 (willkürlich gewaehlt)
' Scan-Code 54 (aus der Online-Hilfe zu On KEY)
ON KEY(15) GOSUB shiftlinks 'Behandlungsroutine
KEY(15) ON 'Tastenverfolgung aktivieren
'
KEY 16, CHR$(0) + CHR$(54)  'Shift-Rechts-Taste
ON KEY(16) GOSUB shiftrechts
KEY(16) ON
'
KEY 17, CHR$(0) + CHR$(29)  'Strg-Taste
ON KEY(17) GOSUB strg
KEY(17) ON
'
KEY 18, CHR$(0) + CHR$(56)  'Alt-Taste
ON KEY(18) GOSUB alt
KEY(18) ON
'
KEY 19, CHR$(0) + CHR$(70)  'Rollen-Feststelltaste
ON KEY(19) GOSUB roll
KEY(19) ON
'
KEY 20, CHR$(0) + CHR$(69)  'Num-Feststelltaste
ON KEY(20) GOSUB num
KEY(20) ON'
'
KEY 21, CHR$(0) + CHR$(58)  'Shift-Feststelltaste
ON KEY(21) GOSUB shiftlock
KEY(21) ON'
'
KEY 22, CHR$(0) + CHR$(82)  'Einfuegen
ON KEY(22) GOSUB einfuegen
KEY(22) ON
'
'**** Hauptprogramm, Anzeigen loeschen
'**** wird von den Behandlungsroutinen
'**** unterbrochen
DO
  FOR i% = 4 TO 11   '8 Ausgabe-Zeilen
   LOCATE i%, 1
   PRINT SPACE$(25) 'loeschen (mit Blanks ueberschreiben)
  NEXT i%
LOOP WHILE INKEY$ <> CHR$(27) 'Beenden mit Esc
END
'
'*** Behandlungsroutinen, werden jeweils
'*** bei Tastendruck angesprumgen
shiftlinks:
LOCATE 4, 1
PRINT "Shift-links"
SLEEP 1  'fuer 1 sec anzeigen
RETURN
'
shiftrechts:
LOCATE 5, 1
PRINT "Shift-rechts"
SLEEP 1
RETURN
'
strg:
LOCATE 6, 1
PRINT "Strg-Taste"
SLEEP 1
RETURN
'
alt:
LOCATE 7, 1
PRINT "Alt-Taste"
SLEEP 1
RETURN
'
roll:
LOCATE 8, 1
PRINT "Rollen-Feststelltaste"
SLEEP 1
RETURN
'
num:
LOCATE 9, 1
PRINT "Num-Feststelltaste"
SLEEP 1
RETURN
'
shiftlock:
LOCATE 10, 1
PRINT "Shift-Feststelltaste"
SLEEP 1
RETURN
'
einfuegen:
LOCATE 11, 1
PRINT "Einfuegen-Taste"
SLEEP 1
RETURN

