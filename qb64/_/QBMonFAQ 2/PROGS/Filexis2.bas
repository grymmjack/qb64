'****************************************************************************
' FILEXIS2.BAS - Testet ob eine Datei vorhanden ist (Komfort-Version)
' ============
' Dieses Q(uick)Basic-Programm demonstriert, wie man feststellt, ob eine
' Datei vorhanden ist. Der Pfad- und Dateiname wird vom Anwender sooft
' erfragt bis auf die Datei ohne Fehler zugegriffen werden kann.
'
' (c) Thomas Antoni, 5.4.2006
'****************************************************************************
'
ON ERROR GOTO ErrorHandler     'Bei nicht vorhandener Datei
                               'Fehlerroutine anspringen
Start:    'Wieder-Einsprungstelle bei Fehler (nicht vorhandene Datei)
CLS
IF Fehler% = 1 THEN
  COLOR 12, 0                  'rot auf schwarz
  PRINT "Datei "; path$; " exististiert nicht, bitte richtigen Pfad eingeben!"
  COLOR 7, 0                   'wieder normale Schrift hellgrau auf schwarz
END IF
'
'------------- Pfad- und Dateinamen erfragen und in path$ hinterlegen
LOCATE 3
PRINT "Gib den Pfad- und Dateinamen ein, z.B. C:\text\meintext.txt"
INPUT path$
'
'----------- Datei oeffnen
Fehler% = 0                                'Vorbesetzung: Kein Fehler
OPEN path$ FOR INPUT AS #1
 'ist die Datei nicht vorhanden, erfolgt sofort ein Sprung zum ErrorHandler
CLOSE #1
PRINT "Der Pfad ist korrekt eingegeben."
SLEEP                                      'Warten auf beliebige Taste
END
'
'----------- Fehlerbehandlung falls Datei nicht vorhanden -------------------
ErrorHandler:
Fehler% = 1                                'Fehlermerker setzen
RESUME Start                               'neue Eingabe


