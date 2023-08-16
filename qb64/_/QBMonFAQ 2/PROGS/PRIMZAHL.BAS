'************************************************************
' PRIMZAHL.BAS = Berechnung der Primzahlen bis 1500
' ============
' Dieses QBasic-Programm prueft fuer alle Zahlen a im
' Intervall von 5 bis 1500 ab, ob sie sich durch durch 2
' oder durch eine der ungeraden Zahlen im Bereich 3 bis
' (Wurzel aus a) ohne Rest teilen laesst. Ist das nicht
' der Fall, so ist a eine Primzahl.
'
' Warum braucht man nur die Teilbarkeit durch die Zahlen bis
' zur Wurzel aus a zu betrachten? Das zeigt folgendes
' Beispiel:  Will man von 1303 feststellen, ob es sich um
' eine Primzahl handelt, braucht man nur zu pruefen, ob 1302
' durch 2, 3, 5, 7,...,37 teilbar ist, denn 38^2 ist bereits
' 1444, und durch Zahlen ueber 37 laesst sich 1302 sowieso
' nicht ohne Rest teilen.
'                            
' (c) Thomas Antoni, 1.2.2004 - 2.2.2004
'************************************************************
WIDTH 80, 50            'grosser Bildschirm mit 50 Zeilen
CLS
PRINT " ________________Primzahlen bis 1500_________________"
PRINT " 2", " 3",  '2 und 3 sind Primzahlen
FOR a% = 4 TO 1500
  prim% = 1             'Vorbesetzung "a ist eine Primzahl"
  IF a% MOD 2 = 0 THEN  'Durch 2 ohne Rest teilbar?
    prim% = 0           'a ist keine Primzahl
  ELSE
    FOR i% = 3 TO SQR(a%) STEP 2 'nur ungerade Teiler
      IF (a% MOD i%) = 0 THEN    'ohne Rest teilbar?
        prim% = 0                'keine Primzahl
        EXIT FOR                 'a% fertig bearbeitet
      END IF
    NEXT i%
    IF prim% = 1 THEN PRINT a%,
  END IF
NEXT a%

