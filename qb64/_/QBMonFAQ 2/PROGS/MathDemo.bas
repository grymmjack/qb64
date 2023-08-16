'*******************************************************
' MathDemo.bas = Kleines QBasic Mathe-Demoprogramm
' ============
' Fuer die Zahlen i=1 bis zwanzig werden folgende
' Berechnungen durchgefuehrt und die Ergebnisse
' angezeigt:
' - Wurzel aus i
' - i hoch 2
' - 2 hoch i
' - sin (i)  ;i im Grad (2*Pi = 360 Grad)
'
' (c) Thomas Antoni, 24.10.2003 - 30.1.2004
'*******************************************************
'
CLS
Pi = 3.1416 ' Kreiskonstante
PRINT " i", "Wurzel(i)", "i^2", "2^i", "sin(i)"
PRINT
FOR i = 1 TO 20
  PRINT i, SQR(i), i ^ 2, 2 ^ i, SIN(i * 2 * Pi / 360)
  'der Klammerausdruck nach SIN rechnet den Winkel
  'i vom Gradmass (0..360 Grad ins Bogenmass (0..2*Pi) um
NEXT i
SLEEP
END

