'************************************************************
' PRIMTEST.BAS = Testet, ob eine Zahl eine Primzahl ist
' ============
' Dieses QBasic-Programm prueft ab, ob sich die Zahl a
' durch 2 oder durch eine der ungeraden Zahlen im  Bereich
' (3...Wurzel aus a) ohne Rest teilen laesst. Ist das nicht
' der Fall, so ist a eine Primzahl.
'
' Warum braucht nur die Teilbarkeit durch Zahlen bis (Wurzel
' aus a) zu betrachten? Das zeigt folgendes Beispiel:
' Will man von 1303 feststellen, ob es sich um eine Primzahl
' handelt, braucht man nur zu pruefen, ob 1302 durch 2, 3,
' 5, 7,..., 37 teilbar ist, denn 38^2 ist bereits 1444, und
' 1303 ist daher durch alle Zahlen über 37 sowieso nicht
' mehr ohne Rest teilbar.
'                             
' (c) Thomas Antoni, 1.2.2004 - 2.2.2004
'************************************************************
CLS
DO
PRINT
INPUT " Gib eine Zahl ein (1...2 147 483 647) : a = ", a&
prim% = 1                 'Vorbesetzung: a& ist eine Primzahl
'
SELECT CASE a&
  CASE 1: prim% = 0       '1 ist keine Primzahl
  CASE 2: prim% = 1       '2 ist eine  Primzahl
  CASE ELSE
    IF a& MOD 2 = 0 THEN  'ist a eine gerade Zahl?
      prim% = 0           'a ist keine Primzahl
    ELSE                  'a ist eine ungerade Zahl
      FOR i& = 3 TO SQR(a&) STEP 2 'nur ungerade Teiler
        IF (a& MOD i&) = 0 THEN    'a/i ohne Rest teilbar
          prim% = 0       'keine Primzahl!
          EXIT FOR        'fertig -> Schleife abbrechen
        END IF
      NEXT
    END IF
END SELECT
'
IF prim% THEN
  PRINT "  a ist eine Primzahl"
ELSE
  PRINT "  a ist keine Primzahl"
END IF
PRINT
PRINT "...Wiederholen mit belieb.Taste...Beenden mit Esc"
t$ = INPUT$(1)   '1 Tastendruck abwarten + Taste einlesen
IF t$ = CHR$(27) THEN END
LOOP

