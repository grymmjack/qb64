'**************************************************
' COUNT.BAS = Einfacher Countdown-Timer in QBasic
' ==========
' (c) FatalError, 1.9.2003
'**************************************************
CLS
INPUT "Countdown-Zeit in sec"; time
FOR y = time TO 0 STEP -1
LOCATE 2, 1
PRINT "... noch:"; y; "sec"
t = TIMER
DO: LOOP UNTIL t + 1 <= TIMER
NEXT y
BEEP
PRINT "Timer abgelaufen"
SLEEP

