'************************************************************
' PRIMZERL.BAS = Primfaktorzerlegung
' ============
' Dieses QBasic-Programm zerlegt die eingegebene Zahl x in
' ihre Primfaktoren. Fuer jede Primzahl im Bereich von 1 bis
' zur Wurzel aus z wird festgestellt, ob und wie oft die
' Restzahl dadurch teilbar ist. Der Test, ob eine Zahl eine
' Primzahl ist, erfolgt in der FUNCTION Prim% .
'
' (c) Thomas Antoni, 1.2.2004 - 2.2.2004
'************************************************************
DECLARE FUNCTION Prim% (a&)  'Liefert "1", wenn a& eine Prim-
                             'zahl ist
CLS
DO
PRINT
INPUT " Gib eine Zahl ein (1...2 147 483 647) : x = ", x&
PRINT
PRINT " Primfaktoren: x = ";
erstlauf% = 1 'Vorbesetzung: noch kein Primfaktor angezeigt
'
FOR i& = 1 TO SQR(x&)
  IF Prim%(i&) = 1 THEN 'ist i& eine Primzahl?
    p% = 0 'Potenz = 0 vorbesetzen
    DO
      IF (x& MOD i&) = 0 THEN 'x durch i ohne Rest teilbar?
        x& = x& / i&          'Teilung
        p% = p% + 1           'sooft tritt i als Teiler auf
      ELSE                    'i ist kein Teiler von x
        EXIT DO               'zur naechsten Zahl i gehen
      END IF
    LOOP
    '
    IF p% > 0 THEN            'ist i ein Teiler von z ?
      IF erstlauf% = 1 THEN
        erstlauf% = 0  'vor 1. Primfaktor kein "*" anzeigen
      ELSE
        PRINT " * ";
      END IF
      '
      IF p% = 1 THEN       'i kommt nur 1 x vor
        PRINT i&;
      ELSE                 'i kommt mehrmals vor
        PRINT i&; "^"; p%;
      END IF
    END IF
  END IF
NEXT
'
IF x& > 1 THEN PRINT " * "; x& ELSE PRINT 'letzt.Rest anzeig.
PRINT
PRINT "...Wiederholen mit belieb.Taste...Beenden mit Esc"
t$ = INPUT$(1)   '1 Tastendruck abwarten + Taste einlesen
IF t$ = CHR$(27) THEN END
LOOP

'
FUNCTION Prim% (a&)
'************************************************************
' Prim(a&) = liefert 1 zurueck, wenn a& eine Primzahl ist
' =========  und 0 wenn a& keine Primzahl ist
'
' Diese Funktion prueft ab, ob sich die Zahl a durch 2 oder
' durch eine der ungeraden Zahlen im Bereich (3...Wurzel aus
' a) ohne Rest teilen laesst. Ist das nicht der Fall, so ist
' a eine Primzahl.
' Warum braucht nur die Teilbarkeit durch Zahlen bis (Wurzel
' aus a) zu betrachten? Das zeigt folgendes Beispiel:
' Will man von 1303 feststellen, ob es sich um eine Primzahl
' handelt, braucht man nur zu pruefen, ob 1302 durch 2, 3,
' 5, 7,..., 37 teilbar ist, denn 38^2 ist ja bereits 1444,
' und durch Zahlen ueber 37 ist 1303 sowieso nicht ohne Rest
' teilbar.
'************************************************************
Prim% = 1                 'Vorbesetzung: a ist eine Primzahl
'
SELECT CASE a&
  CASE 1: Prim% = 0       '1 ist keine Primzahl
  CASE 2: Prim% = 1       '2 ist eine  Primzahl
  CASE ELSE
    IF a& MOD 2 = 0 THEN  'ist a eine gerade Zahl?
      Prim% = 0           'a ist keine Primzahl
    ELSE                  'a ist eine ungerade Zahl
      FOR i& = 3 TO SQR(a&) STEP 2 'nur ungerade Teiler
        IF (a& MOD i&) = 0 THEN 'a/i ohne Rest teilbar?
          Prim% = 0             'keine Primzahl!
          EXIT FOR              'fertig -> Schleife abbrechen
        END IF
      NEXT
    END IF
END SELECT
'
END FUNCTION

