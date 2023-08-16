DECLARE SUB BubbleSort (Feld%())
DECLARE SUB QuickSort (Feld%(), anfindex%, endindex%)
'****************************************************************************
' SORT.BAS - QBASIC-Sortierprogramme mit den Methoden Bubble- und Quick Sort
' ==========================================================================
' Nach einem Programmvorschlag in Lit. {11/244}
'
' Zu den verwendeten Sortieralgorithmen:
' --------------------------------------
' Dieses Programm beinhaltet die allgemein verwendbaren Subroutinen BubbleSort
' und QuickSort zum Sortieren beliebig vieler in einem Feld hinterlegter Inte-
' gerzahlen:
'    - Bubble-Sort ist ein einfacher und langsamer Algorithmus
'    - Quick-Sort ist ein komplexerer, aber um ein vielfaches schnellerer
'      Algorithmus, der rekursive Unterprogrammaufrufe verwendet, d.h. die
'      Subroutine ruft sich mehrmals selbst auf.
' Mit entsprechenden Typ-�nderungen lassen sich diese Subroutinen auch zum
' Sortieren anderer Datentypen verwenden. Beim Sortieren von Text ist
' jedoch folgendes zu beachten:
'    - Umlaute und "?" werden als Sonderzeichen behandelt und hinter dem
'      "z" eingeordnet
'    - Gro�buchstaben werden vor den Kleinbuchstaben eingeordnet.
' Die Algorithmen sind in den Kommentark�pfen der einzelnen Subroutinen im
' Detail erkl�rt.
'
' Zum Hauptprogramm:
' ------------------
' Das Hauptprogramm demonstriert den Geschwindigkeitsunterschied zwischen den
' beiden Sortieralgorithmen:
' Zun�chst wird ein Feld mit 460 dreistelligen Zufallszahlen erzeugt und
' angezeigt.
' Anschlie�end wird dies Zahlenfeld mit dem gew�nschten Algorithmus sortiert.
' Das sortierte Feld wird ebenfalls engezeigt, ebenso die f�r das Sortieren
' ben�tigte Zeit.
' Bei schnellen Rechnern ab Pentium ist die angezeigte Zeit u.U. zu klein, um
' aussagekr�ftig zu sein. In diesem Fall kann die Feldl�nge durch Vergr��ern
' der Konstanten feldlaenge% am Programmanfang vergr��ert werden. Es sind
' jedoch nur max. 460 Zahlen auf dem Bildschirm ohne Rollen anzeigbar.
'
' Auf einem 486/50MHz Computer ergab sich bei 10000 sortierten Zahlen (CONST
' feldlaenge%=10000) das folgende Ergebnis:
'    - Bubble Sort: Sortierzeit   4,8 s
'    - Quick Sort : Sortierzeit 807,0 s  (= 13:27 min !!)
'
'
'   \         (c) Thomas Antoni, Rosieres/Frankreich  03.09.99 - 06.09.99
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************

CONST feldlaenge% = 460               'Anzahl der zu sortierenden Zahlen
                                      'max anzeigbares feldlaenge%= 460
DIM Feld%(1 TO feldlaenge%)           'Zahlenfeld
WIDTH 80, 50                          'Bildschirm mit 50 Zeilen, je 80 Spalten

'--- Eingangs- und Beenden-Dialog ------------------------------------------
DO
COLOR 0, 7                            'schwarze Schrift auf hellgrauem Grund
CLS
PRINT " Demonstration von zwei Sortieralgorithmen"
PRINT " ========================================="
PRINT
PRINT " W�hle Sortieralgorithmus:"
PRINT "  (1)   = Bubble-Sort"
PRINT "  (2)   = Quick-Sort"
PRINT "  (Esc) = Beenden"
PRINT
PRINT " W�hle gew�nschten Algorithmus (1) bis (2):"

LOCATE 9, 44, 1, 3, 5     'Blink-Cursor an Eingabeposition anzeigen
DO: Taste$ = INKEY$: LOOP UNTIL Taste$ <> ""
LOCATE , , 0              'Blink-Cursor wieder deaktivieren

IF Taste$ = CHR$(27) THEN 'Programmausstieg mit Esc-Taste
  WIDTH 80, 25            'DOS-Bildschirm 25*80 wiederherstellen
  COLOR 15, 0             'Wei� auf schwarz
  CLS
  END
END IF

IF (Taste$ = "1") OR (Taste$ = "2") THEN     'Sortieralgorithmus ausgew�hlt?

'--- Feld mit Zufallszahlen f�llen und anzeigen ------------------------------
  CLS
  COLOR 4, 7                                 'rot auf hellgrau
  LOCATE 2, 1
  PRINT "Zufallszahlen:"
  COLOR 0, 7                                 'Normalfarbe schwarz auf hellgrau
  RANDOMIZE TIMER
  FOR i% = 1 TO feldlaenge%
    Feld%(i%) = INT(RND * 999) + 1
    IF POS(0) > 77 THEN LOCATE CSRLIN + 1, 1 'n�chste Zeile
    PRINT USING "### "; Feld%(i%);
  NEXT i%
 
'--- Sortieralgorithmus aufrufen ---------------------------------------------
    COLOR 4, 7                               'rot auf hellgrau
    startzeit! = TIMER
    IF Taste$ = "1" THEN
      LOCATE 1, 1
      PRINT "                        Bubble Sort f�r "; feldlaenge%; " Zahlen "
      CALL BubbleSort(Feld%())
    ELSE
      LOCATE 1, 2
      PRINT "                        Quick Sort f�r "; feldlaenge%; " Zahlen "
      CALL QuickSort(Feld%(), 1, feldlaenge%)
    END IF

'--- Sortierte Zahlen und Sortierzeit anzeigen -------------------------------
  zeit! = TIMER - startzeit!                 'Sortierzeit [s] (Aufl�sg. 0.056s)
  LOCATE 26, 1
  PRINT "Sortierte Zahlen:"
  COLOR 0, 7                                 'Normalfarbe schwarz auf hellgrau
  FOR i% = 1 TO feldlaenge%
    IF POS(0) > 77 THEN LOCATE CSRLIN + 1, 1 'n�chste Zeile
    PRINT USING "### "; Feld%(i%);
  NEXT i%

  LOCATE 50, 1
  COLOR 4, 7                                 'rot auf hellgrau
  PRINT "Ben�tigte Zeit ="; zeit!; "s;  ..... Weiter mit beliebiger Taste";
  WHILE INKEY$ = "": WEND
END IF
LOOP

SUB BubbleSort (Feld%())
'****************************************************************************
' BubbleSort - QBasic-Subroutine zum Sortieren beliebiger INTEGER-Felder
' ======================================================================
' - Leicht nachvollziehbarer, aber langsamer Sortieralgorithmus zum Sortieren
'   der Elemente eines Integerfeldes in aufsteigender Reihenfolge
' - Mit entsprechenden Typ-�nderungen l��t sich diese Subroutine auch zum
'   Sortieren anderer Datentypen verwenden. Beim Sortieren von Text ist
'   jedoch folgendes zu beachten:
'    - Umlaute und "?" werden als Sonderzeichen behandelt und hinter dem
'      "z" eingeordnet
'    - Gro�buchstaben werden vor den Kleinbuchstaben eingeordnet.
' - Nacheinander werden alle Feldelemente vom ersten bis zum vorletzten (Indi-
'   ces x%) als "Vergleichsnormal" verwendet.
' - Von unten beginnend werden alle Feldelemente bis zum Element nach dem
'   aktuellen Vergleichsnormal mit dem Vergleichsnormal verglichen. Ist das
'   aktuelle Element feld%(y%) kleiner als das Vergleichsnormal feld%(x%),
'   so werden die beiden Elemente miteinander vertauscht.
' - So wandern die kleineren Zahlen langsam wie Luftblasen im Wasser nach
'   oben, daher der Name BUBBLE SORT.
' - Das Verfahren ist - besonders bei Feldern ab ca. 1000 Elementen - extrem
'   langsam, da sehr viele �berfl�ssige Vergleichsoperationen durchgef�hrt
'   werden m�ssen. Die Gesamtanzahl der Vergleichsoperationen ist proportio-
'   nal zu  ~ (Anzahl Feldelemente)� .
' - F�r gro�e Felder empfiehlt sich eher der um ein Vielfaches schnellere
'   Quick-Sort-Algorithmus.
'
' (c) Thomas Antoni, 04.09.99 - 06.09.99
'****************************************************************************

FOR x% = LBOUND(Feld%) TO UBOUND(Feld%) - 1
  FOR y% = UBOUND(Feld%) TO x% + 1 STEP -1
    IF Feld%(y%) < Feld%(x%) THEN SWAP Feld%(y%), Feld%(x%)
  NEXT y%
NEXT x%
END SUB

SUB QuickSort (Feld%(), anfindex%, endindex%)
'****************************************************************************
' QuickSort - QBasic-Subroutine zum Sortieren beliebiger INTEGER-Felder
' =====================================================================
' - Etwas schwerverst�ndlicher, aber extrem schneller Sortieralgorithmus zum
'   Sortieren der Elemente eines Integerfeldes in aufsteigender Reihenfolge.
'   Der Algorithmus ist um ein Vielfaches schneller als Bubble Sort und
'   empfihlt sich besonders f�r gro�e Felder mit mehr als ab ca. 1000 Elemen-
'   ten.
' - Mit entsprechenden Typ-�nderungen l��t sich diese Subroutine auch zum
'   Sortieren anderer Datentypen verwenden. Beim Sortieren von Text ist
'   jedoch folgendes zu beachten:
'    - Umlaute und "?" werden als Sonderzeichen behandelt und hinter dem
'      "z" eingeordnet
'    - Gro�buchstaben werden vor den Kleinbuchstaben eingeordnet.
' - Erster Sortierlauf:
'    - Das zu sortierende Feld wird zun�chst in zwei H�lften geteilt.
'    - Alle Elemente der oberen H�lfte werden - von oben beginnend - mit dem
'      Mittelelement verglichen. Ebenso werden alle Elemente der unteren
'      H�lfte - von unten beginnend - mit dem Mittelfeld verglichen.
'    - Ist ein oberes Feldelement gr��er als das Mittelelement und ein unteres
'      Feldelement kleiner als das mittelelement, so werden unteres und oberes
'    - Feldelement miteinander vertauscht.
'    - Hat der Vergleichslauf das Mittelelement erreicht, so sind in der unte-
'      ren H�lfte des Feldes alle Elemente versammelt, die >= dem Mittelele-
'      ment sind. In der oberen H�lfte tummeln sich alle anderen (gr��eren)
'      Elemente.
' - Weitere Sortierl�ufe:
'    - Damit ist der Sortiervorgang noch nicht beendet, denn jetzt haben wir
'      zwei jeweils ungeordnete Teilfelder, die nach dem gleichen Prinzip
'      durchgeackert werden m�ssen wie vorher das Gesamtfeld. Und ist das
'      �berstanden, so warten schon vier Felder auf ihre "Bestellung". Dieser
'      Zerlegungsproze� geht solange weiter bis kein Teilfeld aus mehr als
'      einem Element besteht!
'    - Die Zerlegung der Teilfelder erfolgt durch rekursive Aufrufe der
'      Subroutine, d.h. die Subroutine ruft sich selbst fortw�hrend auf.
'    - Hierbei ist zu beachten, da� bei jedem Selbstaufruf die R�cksprunga-
'      dresse und die lokalen Variablen auf den Stack abgeleget und neue
'      Kopien (Instanzen) der lokalen Variablen angelegt werden.
'      Nach einem R�cksprung aus einem rekursiv angesprungenem Subroutinen-
'      -Durchlauf werden die alten Lokalvariablen wieder restauriert.
'    - Bei rekursiven Subroutinen ist eine eindeutige Abbruchbedingung essenti-
'      ell. Bei der QuickSort ist diese dadurch gegeben, da� der Sortier-
'      proze� zuende ist, wenn der Anfangsindex des Restfeldes gr��er wird
'      als der Endindex.-
'      holen des Endindes
' - Die Anzahl der Sortierl�ufe ist proportional zu
'               ~ (Anzahl Feldelemente) * ld (Anzahl Feldelemente)
'   (ld = Logarithmus Dualis; d.h. Logarithmus zur Basis 2; z.B. ld (1024)=10)
' - Nachteile des hier verwendeten QickSort-Algorithmus:
'    - Bei jedem Aufruf wird die R�cksprungadresse sowie die Parameter und
'      lokalen Variablen auf dem Stack abgelegt und beanspruchen dort einen
'      Speicherplatz, der proportional der Anzahl der Rekursions-Schachtel-
'      tiefe ist. In der Voreinstellung steht f�r den Stack ein Bereich von
'      lediglich 1200 Bytes zur Vef�gung. Die Gr��e des Stackbereichs kann
'      mit  "CLEAR ,, <Anz.Bytes>"  erh�ht und mit "FRE(-2) abgefragt werden.
'    - Der Algorithmus ist aufgrund der Rekursionen etwas schwer nachzuvoll-
'      ziehen. Es gibt QuickSort auch als iterative statt rekursive Variante.
'      Diese arbeitet mit Schleifen im Hauptprogramm, ist allerding sehr
'      komplex
'    
' (c) Thomas Antoni, Rosieres/ Frankreich   04.09.99 - 06.09.99
'****************************************************************************

'--- Bereichsgrenzen und Mittelelement festlegen ----------------------------
von% = anfindex%
bis% = endindex%
mittelelement% = Feld%((anfindex% + endindex%) \ 2)
DO

'--- von oben beginnend das Feldelement >= Mittelelement suchen -------------
  WHILE Feld%(von%) < mittelelement%: von% = von% + 1: WEND

'--- von unten beginnend das Feldelement <= Mittelelement suchen ------------
  WHILE Feld%(bis%) > mittelelement%: bis% = bis% - 1: WEND

'--- gegebenenfalls Feldelemente vertauschen --------------------------------
  IF von% <= bis% THEN             'liegt oberes gefundenes Feldelement �ber
    SWAP Feld%(von%), Feld%(bis%)  'dem unteren gefundenen Feldelement?
    von% = von% + 1
    bis% = bis% - 1
  END IF

'--- ann�hernde Suche wiederholen bis die Indices sich �berholen ------------
LOOP UNTIL von% > bis%

'--- f�r die 2 noch vorhandenen Teilfelder jeweils die Subroutine -----------
'--- rekursiv erneut aufrufen
IF anfindex% < bis% THEN CALL QuickSort(Feld%(), anfindex%, bis%)
IF endindex% > von% THEN CALL QuickSort(Feld%(), von%, endindex%)

END SUB

