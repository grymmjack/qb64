'*****************************************************************************
'
' DIRMAKNO.BAS - QBasic-Programm zum Erstellen von max 1000 Verzeichnissen
'                mit durchnummerierten Verzeichnisnamen
' =========================================================================
'
' Der vordere Namensbestandteil und die erste und letzte Nummer werden vom
' Anwender eingegeben. In den Verzeichnisnamen erscheint die Nummer
' jeweils dreistellig und mit fuehrenden Nullen.
'
' Beispiel:
' - vorderer Namensbestandteil: anna
' - erste Nummer: 9
' - letzte Nummer: 121
' ==> Es werden die leeren Verzeichnisse anna009 ... anna121 erstellt
'
' (c) Thomas Antoni, 24.4.03 - 28.01.04
'     thomas*antonis.de
'     www.qbasic.de - Hottest QBasic Stuff on Earth
'
'*****************************************************************************
'
CLS
PRINT
PRINT "     Erstellen von nummerierten Verzeichnissen namexxx ... nameyyy"
PRINT "     ============================================================="
PRINT
INPUT "Gib den vorderen Namensbestandteil ein (0...5 Zeichen): name = "; name$
INPUT "Gib die erste  Nummer ein                    (0...999):  xxx = "; a%
INPUT "Gib die letzte Nummer ein                    (0...999):  yyy = "; z%
PRINT
FOR i% = a% TO z%
  nummer$ = RIGHT$(STR$(i% + 1000), 3) 'Nummer in String wandeln
                                       'und fuehrende Nullen einfuegen
  SHELL "MD " + name$ + nummer$
  PRINT name$ + nummer$
  IF INKEY$ <> "" THEN PRINT "Abgebrochen": SLEEP: END 'Abbruch mit Esc
NEXT i%
PRINT
PRINT "FERTIG!"
PRINT z% - a% + 1; " Verzeichnisse erstellt... weiter mit beliebiger Taste"
SLEEP
END

