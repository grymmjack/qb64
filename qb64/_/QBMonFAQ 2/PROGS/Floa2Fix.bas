'********************************************************
' Floa2Fix.bas = Gleitpunktzahl in Festpunktzahl wandeln
' ============
' ... durch Zerlegen der Gleitpunktzahl
'
' (c) Xaero 22.10.2003 - 24.10.2003
'*********************************************************
'
DIM a AS DOUBLE
DIM zahl AS STRING
DIM ziffern AS STRING
DIM exponent AS INTEGER
CLS
a = 17 ^ 25
'Zuerst den 10er Logarithmus von a bilden
exponent = LOG(a) / LOG(10)
zahl = STR$(a)
'
IF exponent > -1 AND a < 10 ^ 16 THEN
  'Schon normal als Festpunktzahl dargestellt
  ' --> keine Wandlung erforderlich
  PRINT a; "bleibt wie es ist."
  END
ELSEIF exponent < -1 THEN 'Bruch
  'Punkt und alles nach D herausschneiden
  'Für einfache genauigkeit hier "E" einsetzen
  ziffern = LEFT$(zahl, INSTR(zahl, "D") - 1)
  ziffern = LEFT$(ziffern, 2) + RIGHT$(ziffern, LEN(ziffern) - 3)
  '
  'Nun die Nullen einfuegen
  zahl = "0."
  FOR i = 0 TO -exponent - 2 STEP 1 'Exponent ist ja negativ
    zahl = zahl + "0"
  NEXT i
  ziffern = RIGHT$(ziffern, LEN(ziffern) - 1)'Führendes Leerzeichen wegnehmen
  zahl = zahl + ziffern 'zusammensetzten
ELSE 'Exponent groesser als 15
  '
  'Alles nach D und falls vorhanden Punkt herausschneiden
  'Für einfache genauigkeit hier "E" statt "D" einsetzen
  ziffern = LEFT$(zahl, INSTR(zahl, "D") - 1)
  IF NOT INSTR(zahl, ".") = 0 THEN
    ziffern = LEFT$(ziffern, 2) + RIGHT$(ziffern, LEN(ziffern) - 3)
  END IF
  DO
    ziffern = ziffern + "0"
  LOOP WHILE LEN(ziffern) < exponent + 2
   zahl = ziffern
END IF
PRINT a; "wird zu "; zahl
PRINT "Rueckwandlung zur Kontrolle:"; VAL(zahl)
END

