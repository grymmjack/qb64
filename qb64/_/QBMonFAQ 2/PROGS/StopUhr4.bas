'************************************************************************
' STOPUHR4.BAS = Stoppuhr mit Verwendung des ON TIMER-Befehls
' ============
' Dieses Q(uick)Basic-Programm realisiert eine Stoppuhr mit einer
' Genauigkeit und Aufloesung von 1 Sekunde. Dabei wird der ON TIMER-
' Befehl verwendet, um jede Sekunde ereignisorientiert eine Routine zur
' Uhrbearbeitunge anzuspringen. Der maximale Zaehlbereich betraegt 99
' Sunden.
'
' (c) Thomas Antoni, 26.11.05 - 27.11.05
'************************************************************************
'
'-------------- Bedienhinweise anzeigen ---------------------------------
CLS
PRINT
PRINT "     S T O P P U H R"
PRINT " ========================="
PRINT " Start/Stopp...[Leertaste]"
PRINT " Rcksetzen....[Entf]"
PRINT " Beenden.......[Esc]"
COLOR 15, 1              'Uhranzeige Weiss auf Blau
GOSUB Uhranzeige         'Uhr erstmalig anzeigen
'
'------------- Timerbearbeitung aktivieren ------------------------------
ON TIMER(1) GOSUB Uhrbearbeitung 'Jede Sekunde Neuanzeige der Stoppuhr
TIMER ON                'Ereignisorientierte Timer-Bearbeitung aktivieren
'
'------------- Hauptprogramm-Dauerschleife: Tastenbearbeitung -----------
DO                      'Hauptprogramm-Dauerschleife
  Taste$ = INKEY$
  SELECT CASE Taste$
    CASE CHR$(32)       'Leertaste  => Start/Stop wechseln
      Laeuft% = NOT Laeuft%
    CASE CHR$(0) + "S"  'Entf-Taste => Uhr ruecksetzen und anhalten
      Sekunden% = 0
      Minuten% = 0
      Stunden% = 0
      Laeuft% = 0
    CASE CHR$(27)       'Esc-Taste  => Programm beenden
      END
  END SELECT
LOOP
END
'
'------------- Ereignisprozedur "Uhrenbearbeitung" ----------------------
Uhrbearbeitung:          'Stoppuhr weiterzaehlen
  IF Laeuft% THEN Sekunden% = Sekunden% + 1
  GOSUB Uhranzeige
RETURN
'
'------------- Uhr berechnen und anzeigen -------------------------------
Uhranzeige:              'Minuten und Stunden berechnen u. Uhr anzeigen
  IF Sekunden% = 60 THEN
    Sekunden% = 0
    Minuten% = Minuten% + 1
  END IF
  IF Minuten% = 60 THEN
    Minuten% = 0
    Stunden% = Stunden% + 1
  END IF
LOCATE 10, 6
  PRINT USING " ##:##:## "; Stunden%; Minuten%; Sekunden%
RETURN


