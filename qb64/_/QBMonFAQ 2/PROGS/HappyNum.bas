'****************************************************************************
' HAPPYNUM.BAS =  Berechnung von Happy Numbers (froehlichen Zahlen)
' ============
' Die einzelnen Dezimalstellen der Startzahl werden hoch drei genommen
' und die Ergebnisse addiert. Anschliessend fuehrt das Programm mit der
' resultierenden Zahl denselben Rechengang durch usw. Die Anzahl der
' Durchlaeufe ist waehlbar. Strebt das Ergebnis einem festen Wert zu, dann
' ist die Startzahl eine Happy Number. Werden die Ergebnisse nach einer Reihe
' von Durchlaeufen periodisch (sich wiederholende Zahlenreihe), dann handelt
' es sich um eine Unhappy Number (Nichtfroehliche Zahl).
'
' (c) Andreas Meile, 18.12.2004 (Kommentar von Thomas Antoni)
'****************************************************************************
'
INPUT "Startzahl"; z&
INPUT "Anzahl Durchlaeufe"; n%
FOR i% = 1 TO n%
  z1& = z&
  z2& = 0&
  WHILE z1& > 0&
    z2& = z2& + (z1& MOD 10&) * (z1& MOD 10&) * (z1& MOD 10&)
    z1& = z1& \ 10&
  WEND
  PRINT z2&
  z& = z2&
NEXT i%

