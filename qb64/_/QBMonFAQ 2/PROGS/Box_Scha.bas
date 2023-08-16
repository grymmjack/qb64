'******************************************************************
' BOX_SCHA.BAS = Zeichnen eines Kastens im Textmodus mit Schatten
' ============
' Dieses QBasic-Programm enthaelt die SUB DrawSBox, die einen
' Kasten aus Liniensymbolen mit Schatteneffekt auf den Bildschirm
' zeichnet.
' Der linke obere Eckpunkt (x1|y1) und der rechte untere Eckpunkt
' (x2|y2) sind waehlbar. Die Farbe des Kasten-Vorder- und
' -Hintergrundes muss bzw. kann im Anwenderprogramm gewÑhlt
' werden.
'
' (c) Thomas Antoni, 4.3.2004
'******************************************************************
DECLARE SUB DrawBox (x1%, y1%, x2%, y2%)
CLS
INPUT "Mit welcher Spalte soll der Kasten beginnen (1...80) ", x1%
INPUT "Mit welcher Zeile soll der Kasten beginnen  (1...25) ", y1%
INPUT "Mit welcher Spalte soll der Kasten enden    (1...80) ", x2%
INPUT "Mit welcher Zeile soll der Kasten enden     (1...25) ", y2%
COLOR 9, 11                      'hellblau auf tÅrkis
CALL DrawBox(x1%, y1%, x2%, y2%) 'Kasten zeichnen
COLOR 7, 0    'hellgrau auf schwarz wieder herstellen

'
SUB DrawBox (x1%, y1%, x2%, y2%)
'***************************************************************
' SUB DrawBox - Zeichnet einen Kasten mit Schatten im Textmodus
' ===========
' Uebergeben werden die Koordinaten des linken oberen Eckpunktes
' (x1% | y1%) und des rechten unteren Eckpunktes (x2% | y2%)
'
' (c) Thomas Antoni, 3.4.2004
'***************************************************************
'
'---- ASCII-Zeichen fuer die Doppel-Kastensymbole
LO$ = CHR$(218)  'Linke obere Ecke
LU$ = CHR$(192)  'Linke untere Ecke
RO$ = CHR$(191)  'Rechte obere Ecke
RU$ = CHR$(217)  'Rechte untere Ecke
WA$ = CHR$(196)  'Waagerechter Strich
SE$ = CHR$(179)  'Senkrechter Strich
SCH$ = CHR$(219) 'Schatten
'
'---- oberen Kastenrand anzeigen
LOCATE y1%, x1%
PRINT LO$; STRING$(x2% - x1% - 1, WA$); RO$
'
'---- seitliche Kastenraender anzeigen
FOR y% = y1% + 1 TO y2% - 1
  LOCATE y%, x1%
  PRINT SE$; SPACE$(x2% - x1% - 1); SE$; SCH$; SCH$
NEXT
'
'---- unteren Kastenrand anzeigen
LOCATE y2%, x1%
PRINT LU$; STRING$(x2% - x1% - 1, WA$); RU$; SCH$; SCH$
'
'---- Unteren Schatten anzeigen
LOCATE , x1% + 2
PRINT STRING$(x2% - x1% + 1, SCH$)
END SUB

