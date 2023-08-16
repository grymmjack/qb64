'********************************************************************
' DATRUECK.BAS = Datumruecksteller zur Verlaengerung der Nutzungs-
' ============   dauer von Sharewareprogrammen
'
' Dieses Q(uick)Basic-Programm umgeht die begrenzte Nutzungsdauer
' von Trial- oder Testversionen einiger Sharewareprogramme.
' Zun„chst gibt der Anwender ein Datum innerhalb der Nutzungsdauer
' ein. Das Programm setzt das Systemdatum auf diesen Wert. Dann gibt
' der Anwender den Pfad des zu startenden Sharewareprogramms ein,
' welches jetzt gestartet wird. Nach Beenden des Sharewareprogramms
' wird das Systemdatum wieder auf den alten Wert zurueckgesetzt.
' Bei einer Programmsitzung ueber Mitternacht hinaus erfolgt keine
' Datumsfortschaltung, und der Anwender muss das System-Datum von
' Hand um einen Tag erhoehen.
'
' (c) Ein Teilnehmer im QB-Forum, ergaenzt von Thomas Antoni, 22.2.06
'*********************************************************************
CLS
PRINT
PRINT
PRINT " Bitte geben Sie das Datum der Installation der Testversion an"
PRINT " und addieren Sie einen Tag dazu (Eingabeformat: MM-TT-JJJ)."
PRINT
PRINT " Beispiel: Testverion installiert am 22.10.2002"
PRINT " Eingabe: 10-23-2002 (NUR IN DIESER FORM EINGEBEN !!)"
PRINT
aktdatum$ = DATE$  'Aktuelles System-Datum merken
INPUT " "; neudatum$    'Eingabe eines Datums innerhalb der Nutzungsdauer
DATE$ = neudatum$  'System-Datum zurücksetzen
PRINT
PRINT " Geben Sie nun den Pfad auf der Festplatte ein"
PRINT " Beispiel: Testversion befindet sich auf C:\spiele\game.exe"
PRINT " Eingabe: C:\spiele\game.exe"
PRINT
INPUT " "; Pfad$
Aufruf$ = "START /W " + Pfad$ '/W laesst den DOS-Prompt erst nach
                              'Beenden der Testversion erscheinen
SHELL Aufruf$       'Testversion aufrufen
DATE$ = aktdatum$   'System-Datum wieder auf aktuelles Datum setzen
PRINT
PRINT "Beenden mit beliebiger Taste"
SLEEP
END

