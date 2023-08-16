'*******************************************************
' RECHNER.BAS = Taschenrechner in QBasic
' ===========
' Einfacher Taschenrechner fuer die vier
' Grundrechenarten
'
' (c) Thomas Antoni, 19.1.2004
'*******************************************************
CLS
DO
PRINT "Gib die 1. Zahl ein:";
LOCATE , 50
INPUT "a = ", a#
DO
  PRINT "Gib die Operation ein (+, -, *, /):";
  LOCATE , 54, 1 'Blinkenden Cursor in Spalte 54 anzeig.
  r$ = INPUT$(1) 'Ein Textzeichen von d. Tastatur lesen
  IF r$ = CHR$(27) THEN END  'Abbruch mit Esc
LOOP UNTIL r$ = "+" OR r$ = "-" OR r$ = "*" OR r$ = "/"
LOCATE , 54: PRINT r$
PRINT "Gib die 2. Zahl ein:";
LOCATE , 50
INPUT "b = ", b#
LOCATE , 48
SELECT CASE r$
  CASE "+": PRINT "a+b ="; a# + b#
  CASE "-": PRINT "a-b ="; a# - b#
  CASE "*": PRINT "a*b ="; a# * b#
  CASE "/": PRINT "a/b ="; a# / b#
END SELECT
PRINT "... wiederholen mit beliebiger Taste";
PRINT ", beenden mit Esc"
PRINT
DO: t$ = INKEY$: LOOP WHILE t$ = ""
IF t$ = CHR$(27) THEN END
LOOP



