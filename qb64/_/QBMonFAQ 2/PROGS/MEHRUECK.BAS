'********************************************************************
' MEHRUECK.BAS = Eine SUB/FUNCTION gibt mehr als einen Wert zurueck
' ============
' Dieses Q(uick)Basic-Programm demonstriert, wie eine SUB 2 Werte
' an das aufrufende Hauptprogramm zurueckgeben kann. Die Werte
' werde einfach als Parameter Åbergeben.'
'
' Das Programm berechnet die zweite Potenz n^2 und die dritte
' Potenz n^3 der Zahlen n = 1 ... 10, Die Potenzierung erfolgt
' in der SUB "Potenz"
'
' (c) Thomas Antoni, 28.7.05
'********************************************************************
DECLARE SUB Potenz (n%, nhoch2%, nhoch3%)
'
CLS
nhoch2% = 0
nhoch3% = 0
FOR i% = 1 TO 10
  CALL Potenz(i%, nhoch2%, nhoch3%)
  PRINT i%, nhoch2%, nhoch3%
NEXT i%
SLEEP

SUB Potenz (n%, nhoch2%, nhoch3%)
nhoch2% = n% ^ 2
nhoch3% = n% ^ 3
END SUB

