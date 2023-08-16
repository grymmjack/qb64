'****************************************************************************
'
' GERSCHNI.BAS = Schnittpunkt zweier Geraden berechnen
' ============
' Dieses Q(uick)Basic-Programm berechnet den Schnittpunkt zweier Geraden.
' In einem Dialog werden zwei Geraden eingegeben - wahlweise entweder
' durch 2 Punkte oder durch ihre "expliziten Geradengleichung" y = mx * t.
'
' Ist eine der Geraden durch zwei Punkte (z.B. A und B) vorgegeben, so wird
' hieraus zunaechst nach den Formeln
'         m = (y_A - y_B) / (x_B - x_A)
'         t = y_A - m * x_A
' die explizite Form der Geradengleichung  y = m*x + t  gebildet und
' zur Kontrolle angezeigt.
' Der Ausnahmefall x_A = x_B (d.h. die Gerade verlaeuft parallel zur y-Achse)
' wird getrennt betrachtet, um die Division durch Null zu vermeiden. Die Gera-
' dengleichung lautet in diesem Ausnahmefall "x=x_A"
'
' Anschliessend liegen beide Geraden dann in der expliziten Form vor:
'         y1 = m1 * t + t1
'         y2 = m2 * t + t2.
' Hieraus wird anhand folgender Formeln der Schnittpunkt S(x_S | y_S) der
' beiden Geraden gemaess folgender Formeln berechnet und angezeigt:
'         xs = (t2-t1) / m2-m1)
'         ys = m1 * xs + t1
'
' Die folgenden beiden Ausnahmefaelle werden vorher getrennt betrachtet:
' Fall 1: Verlaufen die beiden Geraden parallel zueinander (m1=m2) oder velau-
'         fen beide Geraden parallel zur Y-Achse, so gibt es
'         keinen Schnittpunkt und es erfolgt eine entsprechende Anzeige.
' Fall 2: Verl„uft genau eine der beiden Geraden (z.B. Gerade 1) parallel zur
'         Y-Achse, so ergibt sich der Schnittpunkt durch die Gleichungen
'         x_S = x_A1 und y_S = m2 * x_A1  +  t_2
'
' (c) Thomas Antoni, 18.04.99 - 17.01.06
'***************************************************************************
'
'================== Eingabe der Geraden 1 ===================================
'
'-------------- Eingabeform waehlen ------------------
DO
WIDTH 80, 50                    'Volle VGA-Textaufloesung mit 50 Zeilen
CLS
PRINT "================== Eingabe der Geraden 1 ========================"
PRINT
PRINT "Waehle die Eingabeform:"
PRINT " 1 = explizite Form (y = m*x + t)"
PRINT " 2 = zwei Punkte    (A und B)"
PRINT
PRINT "Gib 1 oder 2 ein"
DO: eingform1$ = INKEY$: LOOP UNTIL eingform1$ = "1" OR eingform1$ = "2"
'
bestimmbar1% = 1                'Vorbesetzung: Geradengleichung 2
                                'bestimmbar (nicht prallel z. Y-Achse)
'
'---------------Gerade 1 eingeben --------------------
PRINT
IF eingform1$ = "1" THEN         'Eingabe in expliziter Form
  PRINT "Gib die Steigung m und den y-Achsenabschnitt m ein:"
  INPUT " m = ", m1#
  INPUT " t = ", t1#
ELSE
  PRINT "Gib die Koordinaten von Punkt A ein:"    'Eingabe durch 2 Punkte
  INPUT " x_A = ", xa1#
  INPUT " y_A = ", ya1#
  PRINT
  PRINT "Gib die Koordinaten von Punkt B ein:"
  INPUT " x_B = ", xb1#
  INPUT " y_B = ", yb1#
  PRINT
  PRINT "Die Geradengleichung 1 lautet:"
  IF xa1# <> xb1# THEN          'explizite Geradengleichung bestimm-
                                'bar, da nicht parallel zur y-Achse
    m1# = (yb1# - ya1#) / (xb1# - xa1#) 'Berechnung der expliziten Form
    t1# = ya1# - m1# * xa1#
    PRINT " y = "; m1#; " * x + "; t1#
  ELSE
    bestimmbar1% = 0            'explizite Form nicht bestimmbar
    PRINT "x = "; xa1#          'Geradengleichung lautet x=xa
  END IF
END IF
'
'================== Eingabe der Geraden 2 ===================================
'-------------- Eingabeform waehlen ------------------
PRINT
PRINT "================== Eingabe der Geraden 2 ========================"
PRINT
PRINT "Waehle die Eingabeform:"
PRINT " 1 = explizite Form (y = m*x + t)"
PRINT " 2 = zwei Punkte    (A und B)"
PRINT
PRINT "Gib 1 oder 2 ein"
DO: eingform2$ = INKEY$: LOOP UNTIL eingform2$ = "1" OR eingform2$ = "2"
'
bestimmbar2% = 1                'Vorbesetzung: Geradengleichung 2
                                'bestimmbar (nicht prallel z. Y-Achse)
'
'---------------Gerade 2 eingeben --------------------
PRINT
IF eingform2$ = "1" THEN       'Eingabe in expliziter Form
  PRINT "Gib die Steigung m und den y-Achsenabschnitt m ein:"
  INPUT " m = ", m2#
  INPUT " t = ", t2#
ELSE
  PRINT "Gib die Koordinaten von Punkt A ein:"    'Eingabe durch 2 Punkte
  INPUT " x_A = ", xa2#
  INPUT " y_A = ", ya2#
  PRINT
  PRINT "Gib die Koordinaten von Punkt B ein:"
  INPUT " x_B = ", xb2#
  INPUT " y_B = ", yb2#
  PRINT
  PRINT "Die Geradengleichung 2 lautet:"
  IF xa2# <> xb2# THEN          'explizite Geradengleichung bestimm-
                                'bar, da nicht parallel zur y-Achse
    m2# = (yb2# - ya2#) / (xb2# - xa2#) 'Berechnung der expliziten Form
    t2# = ya2# - m2# * xa2#
    PRINT " y = "; m2#; " * x + "; t2#
  ELSE
    bestimmbar2% = 0            'explizite Form nicht bestimmbar
    PRINT "x = "; xa2#          'Geradengleichung lautet x=xa
  END IF
END IF
'
'============= Schnittpunkt S (x_S ; y_S) berechnen und ausgeben =============
PRINT
PRINT "======================== Ergebnis ==============================="
parallel% = 0                          'Vorbesetzg, keine parallelen Geraden
IF bestimmbar1% = 0 AND bestimmbar2% = 0 THEN
   parallel% = 1                       'beide Geraden sind parallel z.Y-Achse
ELSEIF bestimmbar1% = 0 THEN           'Gerade 1 ist parallel zur Y-Achse
   xs# = xa1#
   ys# = m2# * xa1# + t2#
ELSEIF bestimmbar2% = 0 THEN           'Gerade 2 ist parallel zur Y-Achse
   xs# = xa2#
   ys# = m1# * xa2# + t1#
ELSE
   IF m1# = m2# THEN                   'parallele Geraden => kein Schnittpunkt
      parallel% = 1                    'Division durch Null unterdrcken
   ELSE                                '"Normalfall": beide Geraden schief
      xs# = (t2# - t1#) / (m1# - m2#)
      ys# = m1# * xs# + t1#
   END IF
END IF
'
PRINT
IF parallel% = 0 THEN
  PRINT "Die Geraden 1 und 2 schneiden sich im folgenden Schnittpunkt";
  PRINT "S (x_s ³ y_s): "
  PRINT " S = ( x_s = "; xs#; " ³ y_s = "; ys#; ")"
ELSE
  PRINT "Die Geraden sind zueinander parallel => Es gibt keinen Schnittpunkt ! "
END IF
'
'------------------ Wiederholen/Benden-Dialog ------------------
PRINT
PRINT "Neue Schnittpunktberechnung...[Beliebige Taste]   Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
LOOP

