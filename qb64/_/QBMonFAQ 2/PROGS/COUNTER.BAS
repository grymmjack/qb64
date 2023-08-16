'*****************************************************
' COUNTER.BAS - Countdown-Timer
' ===========
' Countdown-Timer, der das Nullsetzen des
' System-TIMERs um Mitternacht abfaengt.
'
' Nachdem der Anwender die Countdownzeit in Sekunden
' angegeben und den Countdown-Timer durch eine
' beliebige Taste gestartet hat, wird diese Zeitspanne
' abgewartet und anschliessend ein Piepston ueber den
' PC-Speaker ausgegeben.
'
' Ds Programm fragt den TIMER nur auf Aenderungen
' ab und kuemmert sich nicht um dessen absoluten Wert.
' Daran, dass sich die Vorkommastelle geaendert hat,
' erkennt es, dass eine Sekunde vergangen ist und
' zaehlt den Counter um 1 herunter
'
' Man kann das Programm z.B. zum Zaehneputzen
' verwenden. Gib 240 sec ein, um 5 Minuten lang
' die Zaehne zu putzen  :-))
'
' (c) Thomas Antoni, 29.7.2003
'*****************************************************
'
CLS
INPUT "Gib die Countdownzeit in sec ein: "; t!
PRINT "Starte den Coundown mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""  'warten auf Tastenbetaetigung
'
counter! = t!             'Restsekunden vorbesetzen
timeralt& = CLNG(TIMER)   'System-Timer auf Ganzzahl runden
DO
  LOCATE 12, 37
  PRINT counter!;         'Restsekunden anzeigen
  DO: LOOP WHILE CLNG(TIMER) = timeralt& '1 ms warten
  timeralt& = CLNG(TIMER) 'ganze Sekunden d.Systemtimers merken
  counter! = counter! - 1
LOOP WHILE counter! <> 0
COLOR 15, 4   'roter Bildschirm
CLS
LOCATE 12, 28
PRINT "Countdown"; t!; "sec abgelaufen"
BEEP
SLEEP

