'***********************************************************************
' PRIMFAK.BAS = Primfaktorzerlegung
' ===========
' b# ist der Primfaktor, wenn teilbar
' e  ist der Exponent der Zahl b# oder von 2
'
' (c) Philipp Schr”ter (philipp_schroeter*web.de), 26.1.2004
'***********************************************************************
10 CLS : INPUT "Zahl (max.15 Stellen):", z#
IF z# = 0 OR z# = 1 OR z# > 999999999999999# THEN GOTO 10
e = 0
GOTO 25
20 e = e + 1: z# = z# / 2
IF z# = 1 THEN
  IF e > 1 THEN PRINT 2; "^"; e: e = 0: GOTO 90 ELSE PRINT 2: GOTO 90
END IF
25 IF INT(z# / 2) - (z# / 2) = 0 THEN GOTO 20
     'Teilbarkeit durch 2 pruefen
IF e <> 0 THEN IF e > 1 THEN PRINT 2; "^"; e ELSE PRINT 2
e = 0
b# = 3
30 c# = SQR(z#) + 1
40 IF b# - c# >= 0 THEN GOTO 80
'Teilbarkeit durch b# pruefen
IF INT(z# / b#) - (z# / b#) = 0 THEN e = e + 1: z# = z# / b#: GOTO 30
IF e <> 0 THEN
  IF e > 1 THEN PRINT b#; "^"; e: e = 0 ELSE PRINT b#: e = 0
END IF
b# = b# + 2: GOTO 40
80 IF b# = z# THEN e = e + 1
IF e <> 0 THEN IF e > 1 THEN PRINT b#; "^"; e ELSE PRINT b#
IF b# = z# THEN GOTO 90
PRINT z#
90 PRINT "Fertig...Wiederholung mit beliebiger Taste...Beenden mit Esc"
DO
k$ = UCASE$(INKEY$)
LOOP UNTIL k$ <> ""
IF k$ = CHR$(27) THEN CLS : END
GOTO 10



