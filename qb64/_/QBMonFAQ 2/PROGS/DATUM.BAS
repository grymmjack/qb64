'***************************************************
' DATUM.BAS - Abfrage des Datums und Anspringen
' =========   einer Tages-abhaengigen Routine
'
' (c) Thomas Antoni, 2.5.2003
'***************************************************
CLS
PRINT DATE$
Monat$ = LEFT$(DATE$, 2)
Tag$ = MID$(DATE$, 4, 2)
PRINT "Monat: "; Monat$
PRINT "Tag: "; Tag$
SELECT CASE Monat$
CASE "05"
  SELECT CASE Tag$
  CASE "02": PRINT "Heute ist der 2.  Mai"
  END SELECT
END SELECT
SLEEP

