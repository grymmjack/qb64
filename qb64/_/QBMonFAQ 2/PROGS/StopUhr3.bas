'******************************************************************
' STOPUHR3.BAS = Komfort-Stoppuhr mit min, sec u. 1/10 sec Anzeige
' ============
' Dieses Q(uick)Basic-Programm nutzt den System-TIMER zur
' Realisierung einer Stoppuhr, die die vergangenen Minuten und
' Sekunden sowie die 1/10 Sekunden anzeigt.
' Das Nullsetzen des TIMERS um Mitternacht wird beruecksichtigt,
' so dass das Programm auch um Mitternacht herum richtig
' funktioniert. Dies habe ich getestet, indem ich die PC-Zeit auf
' einen Wert kurz vor Mitternacht gestellt und dann die Stoppuhr
' gestartet habe. Die maximal messbare Zeit betraegt 24h.
'
' (c) Thomas Antoni, 6.4.2005
'******************************************************************
'
'******** Vorbesetzungen und Anzeige der Bedienhinweise ***********
CLS
PRINT " STOPPUHR -  (c) Thomas Antoni"
PRINT "==============================="
LOCATE 7
PRINT " [S]  = Start/Stopp"
PRINT " [R]  = Reset"
PRINT " [Esc]= Beenden"
Sekunden! = 0
StartZeit! = TIMER
Uhrlaeuft% = 0           'Uhr ist angehalten
COLOR 0, 7               'Zeitanzeige schwarz auf hellgrau
'
'******** Tasten abfragen *****************************************
DO
Taste$ = INKEY$
'
SELECT CASE Taste$
  CASE "s", "S"          'Start/Stopp betaetigt
    StartZeit! = TIMER - Sekunden!
    IF Uhrlaeuft% = 0 THEN Uhrlaeuft% = 1 ELSE Uhrlaeuft% = 0
  CASE "r", "R"          'Ruecksetzen betaetigt
    Sekunden! = 0        'Stoppuhr auf 0 setzen ...
    Uhrlaeuft% = 0       '... und anhalten
  CASE CHR$(27)          'Programm beenden bei Esc-Taste
    END
END SELECT
'
'******** Zeit in Sekunden ermitteln ******************************
IF Uhrlaeuft% = 1 THEN
  IF StartZeit! > TIMER THEN  'Ist des Ruecksetzen des TIMERs
                              'um Mitternacht erfolgt?
    Sekunden! = TIMER + 86400 - StartZeit!
                              'Ruecksetzen kompensieren
  ELSE
    Sekunden! = TIMER - StartZeit! 'kein Mitternachtssprung
  END IF
END IF
'
'******** Stunden:Minuten:Sekunden fuer Anzeige ermitteln *********
'DOUBLE-Gleitpunktformat verwenden, um die Rundungsfehler klein zu
'halten. Die Ganzzahldivision "\" kann wegen Genauigkeitsproblemen
'nicht verwendet werden und ist durch INT ersetzt.
'
Sekunden# = CDBL(Sekunden!)       'Typumwandlung in DOUBLE
Stunden# = INT(Sekunden# / 3600#)
Minuten# = INT((Sekunden# - Stunden# * 3600#) / 60#)
Sekundenanzeige# = Sekunden# - INT(Sekunden# / 60#) * 60#
'
'******** Zeit anzeigen  ******************************************
LOCATE 4, 2
PRINT USING "##:"; Stunden#;        'Stunden 2-stellig anzeigen
PRINT USING "##:"; Minuten#;        'Minuten 2-stellig anzeigen
PRINT USING "##.#"; Sekundenanzeige#  'Sekunden 3-stellig anzeigen
LOOP

