'******************************************************************
' STOPUHR1.BAS = Einfache Stoppuhr mit Sekunden- und Minutenanzeige
' ============
' Dieses Q(uick)Basic-Programm benutzt die Systemfunktion TIME$ zur
' Realisierung einer Stoppuhr, die die vergangenen Minuten und
' Sekunden anzeigt
'
' (c) Thomas Antoni, 6.4.2005
'******************************************************************
'
'******** Vorbesetzungen und Anzeige der Bedienhinweise ***********
CLS
PRINT " Stoppuhr"
PRINT " ========"
LOCATE 7
PRINT " [S]=Start/Stopp...[R]=Reset...[Esc]=Beenden"
TimeAlt$ = ""
Min% = 0
Sek% = 0
Uhrlaeuft% = 0           'Uhr ist angehalten
'
'******** Tasten abfragen *****************************************
DO
  Taste$ = INKEY$
  '
  SELECT CASE Taste$
    CASE "s", "S"        'Start/Stopp betaetigt
      IF Uhrlaeuft% = 0 THEN Uhrlaeuft% = 1 ELSE Uhrlaeuft% = 0
    CASE "r", "R"        'Ruecksetzen betaetigt
      Min% = 0: Sek% = 0 'Stoppuhr auf 0 setzen ...
      Uhrlaeuft% = 0     '... und anhalten
    CASE CHR$(27)        'Programm beenden bei Esc-Taste
      END
  END SELECT
'
'******** Zeit weiterzaehlen wenn eine Sec vergangen **************
  IF Uhrlaeuft% = 0 THEN
    TimeAlt$ = TIME$
  ELSE
    IF TimeAlt$ <> TIME$ THEN  '1 Sek vergangen?
      Sek% = Sek% + 1
      IF Sek% > 59 THEN Sek% = 0: Min% = Min% + 1
      TimeAlt$ = TIME$
    END IF
  END IF
'
'******** Zeit anzeigen *******************************************
  LOCATE 4, 2: PRINT Min%; ":"; Sek%;
  LOCATE , 10: PRINT "Minuten"
LOOP

