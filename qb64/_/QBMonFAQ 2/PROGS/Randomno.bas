'****************************************************************************
' RANDOMNO.BAS = QBasic-Programm, erzeugt Zufallszahlen ohne Doubletten
' =====================================================================
'
' Beschreibung des Hauptprogramms:
' Das Hauptprogramm stellt eine Demo der eigenstaendigen Subroutine RandomNo
' dar: Im Dialog wird die gewuenschte Anzahl von Zufallszahlen festgelegt.
' Dann wird ein Feld zum Ablegen dieser Zahlen dynamisch (mit REDIM) dimensio-
' niert. Dies Feld wird an die jetzt aufgerufene Subfunktion RandomNo
' uebergeben, die es mit Zufallszahlen von 1 bis <Anzahl> ohne Doubletten
' fuellt, d.h. jede Zahl kommt genau einmal vor.
'
' Verwendete Befehle: RANDOMIZE TIMER, RND, SHARED, REDIM, PRINT USING
'
'
'   \         (c) Thomas Antoni, 26.09.99 - 24.2.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
DECLARE SUB RandomNo (randomfield%())
WIDTH 80, 50   '50-Zeilen-Modus
COLOR 0, 7     'schwarz auf hellgrau
DO
  CLS
  PRINT "Erzeugung von Zufallszahlen ohne Doubletten (jede Zahl kommt nur 1x vor)"
  PRINT "========================================================================"
  INPUT "Wieviele Zufallszahlen sollen erzeugt werden (1-32000): "; rananz%
  REDIM randomfield%(1 TO rananz%)  'dynam.Feld: L„nge zur Laufzeit festgelegt
  PRINT "Die Zufallszahlen von 1 bis"; rananz%; "(jede kommt genau 1x vor) lauten:"
  CALL RandomNo(randomfield%())
  FOR n% = 1 TO rananz%: PRINT USING " #####  "; randomfield%(n%); : NEXT n%
  PRINT "[[[[[[[  Wiederholen... [beliebige Taste]      Beenden... [Esc]  ]]]]]]]";
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""  'Warten auf Tastenbetaetigung
LOOP WHILE taste$ <> CHR$(27)
COLOR 15!: CLS                     'Schwarz/Weiss-Bildschirm wiederherstellen
END
'
SUB RandomNo (randomfield%())
'*****************************************************************************
' RandomNo = QBasic-Subroutine  zum Erzeugen von Zufallszahlen ohne Doubletten
' ============================================================================
' šbergabeparameter:
'   randomfield()= Feld das mit Zufallszahlen gefuellt werden soll. Die Feld-
'   l„nge ist beliebig. Das Feld kann im aufrufenden Programm statisch oder
'   dynamisch deklariert sein.
'
' Beschreibung:
'    RandomNo erwartet, daá die Indices des Feldes von 1 bis <Anzahl Zufalls-
'    zahlen> lauuft. Das Feld wird mit den Ganzzahlen 1 bis <Anzahl Zufalls-
'    zahlen> in zufaelliger Reihenfolge gefuellt. Jede der Zahlen kommt also
'    genau einmal vor.
'    RandomNo ist ideal geeignet fuer CD-Player (Shuffle-Funktion), Quiz-Pro-
'    gramme, Vokabeltrainer und Mathe-Trainer, bei denen die zu haeufige Wie-
'    derholung von Musikstuecken bzw. Fragen unerwuenscht ist.
'
' (c) Thomas Antoni, 26.09.99 - 24.2.04
'*****************************************************************************
RANDOMIZE TIMER
rananz% = UBOUND(randomfield%) - LBOUND(randomfield%) + 1 'Anz. Feldelemente
FOR i% = 1 TO rananz%
  DO
    ranno% = INT(RND * rananz%) + 1     'Zufallszahl zwischen 1 und rananz%
    fertig% = -1                        'Vorbesetzung: keine Doublette (TRUE)
    FOR k% = 1 TO i% - 1                'bereits erzeugte

      IF ranno% = randomfield%(k%) THEN 'Doubletten ausschlieáen
        fertig% = 0                     'FALSE: ranno%=Doublette
        EXIT FOR
      END IF
    NEXT k%
  LOOP UNTIL fertig%
randomfield%(i%) = ranno%
NEXT i%
END SUB

