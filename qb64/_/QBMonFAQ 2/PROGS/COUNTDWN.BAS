'*****************************************************
' COUNTDWN.BAS - Countdown-Timer
' =============
' Nachdem der Anwender die Countdownzeit in Sekunden
' angegeben und den Countdown-Timer durch eine
' beliebige Taste gestartet hat, wird diese Zeitspanne
' abgewartet und anschliessend ein Piepston ueber den
' PC-Speaker ausgegeben.
'
' Man kann das Programm z.B. zum Eierkochen verwenden.
' Gib 300 sec ein, um ein 5-Minuten_Ei zu kochen.
'
' (c) Thomas Antoni, 29.7.2003
'*****************************************************
'
CLS
INPUT "Gib die Countdownzeit in sec ein: "; t
PRINT "Starte den Coundown mit beliebiger Taste"
DO: LOOP WHILE INKEY$ = ""  'warten auf Tastenbetaetigung
'
timeralt = TIMER
DO
LOCATE 12, 35
PRINT INT(t - TIMER + timeralt + 1); 'Restsekunden
LOOP WHILE TIMER < timeralt + t
COLOR 15, 4   'roter Bildschirm
CLS
LOCATE 12, 28
PRINT "Countdown"; t; "sec abgelaufen"
BEEP
SLEEP

