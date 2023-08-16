'******************************************************************
' STOPUHR2.BAS = Einfache Stoppuhr mit sec u. 1/10 sec Anzeige
' ============
' Dieses Q(uick)Basic-Programm benutzt den System-TIMER zur
' Realisierung einer Stoppuhr, die die vergangenen Minuten und
' Sekunden sowie die 1/10 Sekunden anzeigt.
' Das Nullsetzen des TIMERS um Mitternacht wird nicht
' beruecksichtigt. Daher zeigt das Programm falsche Zeiten an, wenn
' man es um Mitternacht herum benutzt.
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
Sekunden! = 0
StartZeit! = TIMER
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
      StartZeit! = TIMER - Sekunden!
      IF Uhrlaeuft% = 0 THEN Uhrlaeuft% = 1 ELSE Uhrlaeuft% = 0
    CASE "r", "R"        'Ruecksetzen betaetigt
      Sekunden! = 0      'Stoppuhr auf 0 setzen ...
      Uhrlaeuft% = 0     '... und anhalten
    CASE CHR$(27)        'Programm beenden bei Esc-Taste
      END
  END SELECT
'
'******** Zeit ermitteln und anzeigen *****************************
  IF Uhrlaeuft% = 1 THEN
    Sekunden! = TIMER - StartZeit!
  END IF
  LOCATE 4, 2
  PRINT USING "#####.#"; Sekunden!; 'Sec mit 1 Nachkommastelle anz.
  PRINT " sec"
LOOP

