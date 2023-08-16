'****************************************************************************
' HAPYNUM2.BAS =  Berechnung von Happy Numbers (froehlichen Zahlen)
' ============
' Die einzelnen Dezimalstellen der Startzahl werden quadriert und die
' Ergebnisse addiert. Anschliessend fuehrt das Programm mit d.resultierenden
' Zahl denselben Rechengang durch usw. Strebt das Ergebnis dem Wert 1 zu, dann
' ist die Startzahl eine Happy Number. Werden die Ergebnisse nach einer Reihe
' von Durchlaeufen periodisch (sich wiederholende Zahlenreihe), dann handelt
' es sich um eine Unhappy Number (Nichtfroehliche Zahl).
'
' (c) Thomas Antoni, 7.1.2005
'****************************************************************************
'
CLS
INPUT "Startzahl (max. 2 Milliarden)...: "; z&
INPUT "Schritte........................: "; n%
Erg& = z&                       'Zwischenergebnis vorbesetzen
'
FOR s% = 1 TO n%                'Schleife ueber alle Schritte
  ZErg& = 0                     'Zwischenergebnis vorbesetzen
  Zahl$ = STR$(Erg&)            'Zahl in Zeichenkette (String) umwandeln
  FOR i% = 1 TO LEN(Zahl$)      'Schleife ueber alle Zeichen
    ZErg& = ZErg& + (VAL(MID$(Zahl$, i%, 1))) ^ 2
                                'aktuelles Dezimal-Zeichen isolieren, in
                                'Zahlenwert ueckwandeln, quadrieren und
                                'aufsummieren
  NEXT i%
  Erg& = ZErg&
  PRINT Erg&
  IF Erg& = 1 THEN
    PRINT z&; " ist eine Froehliche Zahl (Happy number) !!!"
    SLEEP
    END
  END IF
NEXT s%
'
PRINT "Periodische Zwischenergebnisse? ==> Unhappy Number !!!"
SLEEP
END



