'*******************************************************************************
'*
'* TABELLE.BAS - Ausgabe einer Tabelle in einem Teilbereich des Bildschirms
'* =======================================================================
'*
'*          
'*   \         (c) Thomas Antoni, 3.6.00 - 25.8.02
'*    \ /\           thomas*antonis.de
'*    ( )            http://www.antonis.de 
'*  .( o ).
'*              ----==== Hottest QBasic Stuff on Earth !!! ====----
'*
'*
'*******************************************************************************
CLS
PRINT "In Zeile 3 bis 24 wird eine Zahl hochgezaehlt"
PRINT "Zeilen 1 und 2 bleiben erhalten !"
VIEW PRINT 3 TO 24
DO
x = x + 1
PRINT x
LOOP WHILE INKEY$ <> CHR$(27) 'Ende mit Esc-Taste
END



