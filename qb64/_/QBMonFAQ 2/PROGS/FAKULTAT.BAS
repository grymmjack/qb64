'*********************************************************
' FAKULTAT.BAS = Berechnung der Fakultaet n! einer Zahl n
' =============
' Es wird der Datentyp DOUBLE verwendet (Doppelt lange
' 64-Bit-Gleitpunktzahl). Damit sind Zahlen bis ca.
' 1,8 * 10^308 darstellbar.
'
' Dieser Zahlenbereich ermoegtlicht es, Fakultaeten bis
' zu 170! zu berechnen. Die meisten Taschenrechner gehen
' nur bis 10^99 enstpricht maximal 69!
'
' (c) Marc Antoni, 28.6.2003
'*********************************************************
'
CLS
PRINT
PRINT " Berechnung der Fakultaet n! einer Zahl n"
PRINT " ----------------------------------------"
DO
INPUT " Gib n ein: ", n#
fak# = 1
FOR i# = 1 TO n#
  fak# = fak# * i#
NEXT i#
PRINT " n! = "; fak#
'
'*******Wiederholen/Beenden-Dialog
PRINT
PRINT " Wiederholen...[beliebige Taste]   Beenden...[Esc]"
'warten auf Tastenbetaetigung"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END              'Beenden mit Esc
PRINT
LOOP


