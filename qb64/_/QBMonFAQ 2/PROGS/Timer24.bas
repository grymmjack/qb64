'***************************************************************************
' TIMER24.BAS = erzeugt Wartezeiten, die auch um Mitternacht funktionieren
' ===========
' Dieses Q(uick)Basic-Programm erzeugt Wartezeiten mit einer
' zeitlichen Aufloesung von 0,056 sec, die auch um Mitternacht herum
' funktionieren. Das Programm verwendet den System-TIMER, der die ab
' Mitternacht verstrichenen Sekunden zaehlt und alle 0.055556 sec erhoeht
' wird. Der Anwender gibt eine Wartezeit in sec ein. Das Programm
' berechnet hieraus und aus dem momentanen Stand des System-TIMERs den
' in der Zukunft liegenden TIMER-Stand nach Ablauf der Wartezeit. Dabei
' wird auch der Ruecksprung ("Rollover") des TIMERs um Mitternacht von
' 86399.944 auf 0 beruecksichtigt. Wenn die Wartezeit abgelaufen ist,
' erfolgt eine entspechende Anzeige und es ertoent ein Piepston.
'
' (c) Thomas Antoni, 12.3.2005
'**************************************************************************
DECLARE SUB Pause24 (Wartezeit!)
DO
CLS
PRINT "Gib eine Wartezeit in [sec] ein ";
PRINT "(Dezimalpunkt erlaubt)"
INPUT "t = ", t!
IF t! = 0 THEN END                'Programm beenden wenn "0" eingegeben
CALL Pause24(t!)
PRINT "Wartezeit ist abgelaufen"
BEEP
PRINT
PRINT "Wiederholen...[beliebige Taste] Beenden...[Esc]"
DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""'Warten auf Tastenbetaetigung
IF Taste$ = CHR$(27) THEN END
LOOP

SUB Pause24 (Wartezeit!)
'******************************************************************
' Pause24 = Q(uick)Basic-Subroutine zur Erzeugung von Pausen von
' =======   max. 24h , die auch um Mitternacht herum funktionieren
'******************************************************************
'
'----  Start und Endezeit ermitteln
Startzeit! = TIMER
Endezeit! = Startzeit! + Wartezeit!
'
'---- Warteschleife, wenn kein Ueberlauf erfolgt
IF Endezeit! <= 86399.94 THEN
  DO: LOOP WHILE TIMER < Endezeit!
'
'---- Warteschleife wenn Ueberlauf des Timers
'---- um Mitternacht von 86399.94 auf 0 erfolgt
ELSE
  DO
  LOOP WHILE (TIMER >= Startzeit!) OR (TIMER < (Endezeit! - 86400))
END IF
'
END SUB

