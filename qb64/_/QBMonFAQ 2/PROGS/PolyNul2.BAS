'**************************************************************************
' POLYNUL2.BAS = Polynom-Nullstellenberechnung nach dem Bairstow-Verfahren
' ============
' Dieses Q(uick)Basic-Programm berechnet alle reellen und komplexen
' Nullstellen einer ganzrationalen Funktion, die als Polynom dargestellt
' wird. Das Programm verwendet das Lin-Bairstow-Naeherungsverfahren.
' Weitere Details finden Sie im Kommentar-Kopf der Subroutine PolyRoots().
'
' Das Programm wurde mit folgenden Polynomen getestet und fand die
' angegebenen reelen Nullstellen:
'   y = x^2          -> Nullstelle 0 (doppelte Nullstelle)
'   y = x^3          -> Nullstelle 0 (dreifache Nullstelle)
'   y = x^4          -> Nullstelle 0 (vierfache Nullstelle)
'   y = x^2 + 1      -> keine reelle Nullstelle
'   y = -x^2 + 1     -> Nullstellen -1, 1
'   y = x^2 - 5x + 6 -> Nullstellen 2, 3
'   y = x^3 + 2x^2 -5x - 6      -> Nullstellen -1, 2, -3
'   y = x^4 - x^3 - x^2 - x - 2 -> Nullstellen -1, 2
'   y = 0.025x^5 + 0.05x^4 - 0.6x^3 - 0.55x^2 + 2.575x -1.5
'                    -> Nullstellen -5, -3, 4, 1 (doppelte Nullstelle)
'   y = x^5 -10x^4 + 35x^3 -50x^2 + 24x
'                    -> Nullstellen 0, 1, 2, 3, 4
'
' (c) Thomas Antoni, 23.2.2005 - 6.3.2005
'     thomas*antonis.de -  www.qbasic.de
' unter Verwendung einer Programmidee von Namir C. Shammas
' aus dem Buch "The New BASICs"
'***************************************************************************
'
DECLARE SUB PolyRoots (Coeff#(), RealRoot#(), ImagRoot#(), PolyOrder%, Accuracy#)
DIM Coeff#(20), RealRoot#(20), ImagRoot#(20)
'
'************ Rahmen und Bedienhinweise anzeigen ***************************
WIDTH 80, 50                   'VGA-Bildschirm mit 50 Zeilen
COLOR 0, 7                      'schwarze Schrift auf hellgrau
DO
CLS
PRINT
'
'*********** Koeffizienten eingeben ******************************************
DO
  PRINT "Nullstellenberechnung fuer das Polynom"
  PRINT "y = a_n x^n + a_n-1 x^(n-1) + ... + a_2 x^2 + a_1 x + a_0"
  PRINT
  PRINT SPACE$(80);             'Zeile loeschen
  INPUT "Gib die Ordnung des Polynoms ein (2...10): n = ", PolyOrder%
LOOP UNTIL PolyOrder% >= 2 AND PolyOrder% <= 10
'
PRINT
PRINT "Gib die Koeffizienten a_"; LTRIM$(STR$(PolyOrder%)); " bis a_0 ein"
'
FOR I% = PolyOrder% TO 0 STEP -1
  PRINT "a_"; LTRIM$(STR$(I%)); " = ";
  INPUT "", Coeff#(I%)
  IF Coeff#(PolyOrder%) = 0 THEN
    LOCATE , 8: PRINT "Falsche Eingabe, hoechster Koeffizent muss > 0 sein"
    I% = PolyOrder% + 1
     'Eingabeschleife wiederholen wenn hoechster Koeffizient = 0 (Trick!)
  END IF
NEXT I%
'
'*************** Rechengenauigkeit vorgeben ********************************
Accuracy# = .000000001#     'auf 9 Stellen hinter d.Komma genau rechnen
'
'************** Nullstellen berechnen und anzeigen *************************
CALL PolyRoots(Coeff#(), RealRoot#(), ImagRoot#(), PolyOrder%, Accuracy#)
'
PRINT : PRINT
PRINT "Das Polynom hat die folgenden Nullstellen: "
PRINT
PRINT "    Nullstellen              Realteil               Imaginaerteil"
PRINT "   -----------------     -----------------       --------------------"
Ma$ = "    x0##                 ##########.######       #########.###### * i"
   'Anzeigemaske; die Zahlenwerte werden als Festpunktzahlen angezeigt
   'und auf 6 Nachkommastellen gerundet
'
FOR I% = 1 TO PolyOrder%
  PRINT USING Ma$; I%; RealRoot#(I%); ImagRoot#(I%);
  LOCATE , 13
  IF ABS(ImagRoot#(I%)) > Accuracy# * 10 THEN 'Handelt es sich im Rahmen der
    PRINT "(imaginaer)";                  'Rechengenauigkeit um eine komplexe
  ELSE                                    'Zahl? (Imaginaerteil > "0"?)
    PRINT "(reell)";
  END IF
  PRINT
NEXT I%
'
'********************** Hinweise anzeigen **********************************
LOCATE 41: PRINT "Hinweise:"
PRINT "-Wenn der Imaginaerteil 0 ist, handelt es sich um eine reelle"
PRINT " Nullstelle, bei der der Funktionsgraph die x-Achse schneidet oder"
PRINT " beruehrt"
PRINT "-Bei mehrfachen reellen Nullstellen bildet die x-Achse eine Tangente"
PRINT " des Graphen (z.B. beruehrt der Graph die x-Achse ohne sie zu schneiden)"
'
'********************* Wiederholen / Beenden-Dialog *************************
LOCATE 48, 8
PRINT " Neue Polynom-Eingabe___[Beliebige Taste] .... Beenden___[Esc] "
Taste$ = INPUT$(1)              'Warten bis 1 Taste betaetigt
LOOP UNTIL Taste$ = CHR$(27)    'Beenden bei Esc-Tasten
COLOR 7, 0                      'wieder hellgrau auf schwarz
LOCATE , 20
END

SUB PolyRoots (Coeff#(), RealRoot#(), ImagRoot#(), PolyOrder%, Accuracy#) STATIC
'*****************************************************************************
' PolyRoots by Namir C. Shammas (error fixing by Thomas Antoni)
'--------------------------------------------------------------
' ---- English Description ----
' PolyRoots is a Subroutine that solves all real and complex roots of a
' polynomial with real coeffients. The Lin-Bairstow method is used.
' The solution is returned using the RealRoot#() and ImagRoot#() arrays.
' The first stores the real components of the roots. The second the
' imaginary parts. When the subroutine finds a real root, it stores
' zero in the corresponding imaginary part. Thus, the application program
' should test each member of the ImagRoot#() array to determine whether
' or not the obtained root is real or complex.
' An n-th order polynominal has n roots which are stored into the array
' elements RealRoot#(1...n) and ImagRoot#(1...n).
'
' The solution may be hampered by high accuracy requirements and supplying
' coefficients of an unstable polynominal. If the programm freezes, try
' othe initial guesses of ALFA1# and BETA1#.
'
' *** Parameters
' - Coeff#() is the array of polonominal coefficients [INPUT]
'    They are not altered by the subroutine.
'
'     Polynominal is:
'     Y = Coeff#(0) + Coeff#(1) X + Coeff#(2) X^2 + ... + Coeff#(N%) X^N%
'
' - RealRoot#() is the array of the real parts of the roots [OUTPUT]
' - ImagRoot#() ist the array of the imaginary parts of the root [OUTPUT]
' - PolyOrder% is the order N% of the polynominal [INPUT]
' - Accuracy# is the solution accuracy used       [INPUT]
'
' PolyRoots von Namir C. Shammas (Fehlerbeseitigung von Thomas Antoni)
'---------------------------------------------------------------------
' ---- Deutsche Beschreibung von Thomas Antoni ----
' Diese Q(uick)Basic-Subroutine berechnet alle realen und komplexen
' Nullstellen eines Polynoms, dessen Koeffizienten reelle Zahlen sein
' muessen. Die Subroutine verwendet das Lin-Bairstow-Naeherungsverfahren.
'
' Das Programm sucht in einer Iteration quadratische Faktoren x2 +
' alfa*x + beta des Polynoms und spaltet sie ab. Anschliessend kann man
' die Ordnung des Polynoms um zwei reduzieren. Diesen Algorithmus
' durchlaeuft das Programm so lange, bis das Restpolynom vom Grade 0
' oder 1 ist.
'
' Die Realteile der ermittelten Nullstellen werden im Feld RealRoot#()
' zurückgeliefert, die Imaginaerteile im Feld ImagRoot#(). Bei realen
' Nullstellen wird in ImagRoot#() eine Null eingetragen. Das aufrufende
' Programm sollte fuer jede Nullstelle das entsprechende Feldelement
' von ImagRoot#() abpruefen, um festzustellen, ob die Nullstelle
' reel oder komplex ist.
' Ein Polynom n-ter Ordnung hat n Nullstellen, die die Subroutine in
' die Feldelemente RealRoot#(1...n) und ImagRoot#(1...n) eintraegt.
'
' Bei hohen Genauigkeitsanforderungen (kleiner Wert in Accuracy#) und bei
' "instabilen" Polynomen kann es zu extrem langen Rechenzeiten kommen.
' Wenn sich das Orogramm aufhaengen sollte, muss man andere Startwerte
' ("initial guesses") fuer ALFA1# und BETA1# verwenden. Das war bei meinen
' Tests aber nie erforderlich
'
' *** Parameter
' Coeff#()    - In diesem Feld müssen die Koeffizenten des Polynoms
'               hinterlegt werden [INPUT].
'               Die Subroutine veraendert deren Werte nicht.
'
'                 Das Polynom hat folgende Gleichung:
'                   Y = Coeff#(0) + Coeff#(1) X + Coeff#(2) X^2 + ...
'                        ... + Coeff#(N%) X^N%
'
' RealRoot#() - In dies Feld traegt die Subroutine die Realteile der
'               Nullstellen ein (Feldelemente 1...N%) [OUTPUT]
' ImagRoot#() - In dies Feld traegt die Subroutine die Imaginaerteile der
'               Nullstellen ein (Feldelemente 1...N%) [OUTPUT]
' PolyOrder%  - Hier muss die Ordnung N% d.Polynoms hinterlegt werden [INPUT]
' Accuracy#   - ist die gewuenschte Rechengenauigkeit [INPUT]
'               Beispiel: Die Berechnung soll mit einer Genauigkeit von 3
'               Stellen hinter dem Komma erfolgen => Accuracy# = 0.001
'
'*****************************************************************************
STATIC Count%, N%, I%
STATIC ALFA1#, ALFA2#, BETA1#, BETA2#, DELTA1#, DELTA2#, DELTA3#
'
'$DYNAMIC
DIM CHS%(2)
'
CHS%(1) = 1
CHS%(2) = -1
N% = PolyOrder%
'
DIM A#(N% + 1), B#(N% + 1), D#(N% + 1)
'
FOR I% = 0 TO N%
  A#(N% - I% + 1) = Coeff#(I%)
NEXT I%
'
IF A#(1) <> 1 THEN   'Adjust coefficients if needed:
                     'Normalize to highest-order Coefficient = 1
  FOR I% = N% + 1 TO 1 STEP -1
    A#(I%) = A#(I%) / A#(1)
  NEXT I%
END IF
'
Count% = 0
'
K& = 0 'Iteration Counter
DO ' Start the main Lin-Bairstow iteration Loop
   ' Initialize the counter and guess for the
   ' coefficients of the quadratic factor
   '
   ' p(x) = X^2 + ALFA1# * X + BETA1#
   '
  ALFA1# = 3.1459#: BETA1# = SQR(2#)
   'Initial guesses (=1 in the original program version)
   '
  DO
    B#(0) = 0: D#(0) = 0
    B#(1) = 1: D#(1) = 1
    '
    FOR I% = 2 TO N% + 1
      B#(I%) = A#(I%) - ALFA1# * B#(I% - 1) - BETA1# * B#(I% - 2)
      D#(I%) = B#(I%) - ALFA1# * D#(I% - 1) - BETA1# * D#(I% - 2)
    NEXT I%
    '
    DELTA1# = D#(N% - 1) ^ 2 - (D#(N%) - B#(N%)) * D#(N% - 2)
    ALFA2# = (B#(N%) * D#(N% - 1) - B#(N% + 1) * D#(N% - 2)) / DELTA1#
    BETA2# = (B#(N% + 1) * D#(N% - 1) - (D#(N%) - B#(N%)) * B#(N%)) / DELTA1#
    ALFA1# = ALFA1# + ALFA2#
    BETA1# = BETA1# + BETA2#
  LOOP UNTIL ((ABS(ALFA2#) <= Accuracy#) AND (ABS(BETA2#) <= Accuracy#))
'
  DELTA1# = ALFA1# ^ 2 - 4 * BETA1#
'
  IF DELTA1# < 0 THEN   'Complex roots
    DELTA2# = SQR(ABS(DELTA1#)) / 2
    DELTA3# = ALFA1# / 2
    FOR I% = 1 TO 2    'Error in the original progr.version: DELTA2/3 swapped
      RealRoot#(Count% + I%) = DELTA3#
      ImagRoot#(Count% + I%) = CHS%(I%) * DELTA2#
    NEXT I%
  ELSE                   'Real roots
    FOR I% = 1 TO 2
      ImagRoot#(Count% + I%) = 0
    NEXT I%
    RealRoot#(Count% + 1) = (SQR(DELTA1#) - ALFA1#) / 2
    RealRoot#(Count% + 2) = (SQR(DELTA1#) + ALFA1#) / (-2)
  END IF
'
'Update root counter
  Count% = Count% + 2
'
'Reduce polynominal order
  N% = N% - 2
'
'For N% > 2 calculate coefficients of the new polynominal
  IF N% >= 2 THEN
    FOR I% = 1 TO N% + 1
      A#(I%) = B#(I%)
    NEXT I%
  END IF
'
LOOP UNTIL N% < 2  'Restart the Lin-Bairstow iteration loop
'
IF N% = 1 THEN  'Obtain last single real root
  RealRoot#(Count% + 1) = -B#(2)
  ImagRoot#(Count% + 1) = 0
END IF
'
ERASE A#, B#, D#, CHS%  'Erase local arrays before exciting
                        'the subroutine
END SUB

