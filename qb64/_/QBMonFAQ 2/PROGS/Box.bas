'******************************************************************
' BOX.BAS = Zeichnen eines Kastens aus Doppelstrichen im Textmodus
' =======
' Dieses QBasic-Programm enthaelt die SUB DrawBox, die einen einen
' Kasten aus Doppelliniensymbolen auf den Bildschirm  zeichnet.
' Der linke obere Eckpunkt (x1|y1) und der rechte untere Eckpunkt
' (x2|y2) sind waehlbar.
'
' (c) Thomas Antoni, 4.3.2004
'******************************************************************
DECLARE SUB DrawBox (x1%, y1%, x2%, y2%)
CLS
INPUT "Mit welcher Spalte soll der Kasten beginnen (1...80) ", x1%
INPUT "Mit welcher Zeile soll der Kasten beginnen  (1...25) ", y1%
INPUT "Mit welcher Spalte soll der Kasten enden    (1...80) ", x2%
INPUT "Mit welcher Zeile soll der Kasten enden     (1...25) ", y2%
COLOR 10
CALL DrawBox(x1%, y1%, x2%, y2%) 'gruenen Kasten zeichnen
COLOR 7 'Hellgraue Vordergrundfarbe wieder herstellen

SUB DrawBox (x1%, y1%, x2%, y2%)
'---- ASCII-Zeichen fuer die Doppel-Kastensymbole
LO$ = CHR$(201)  'Linke obere Ecke
LU$ = CHR$(200)  'Linke untere Ecke
RO$ = CHR$(187)  'Rechte obere Ecke
RU$ = CHR$(188)  'Rechte untere Ecke
WA$ = CHR$(205)  'Waagerechter Doppelstrich
SE$ = CHR$(186)  'Senkrechter Doppelstrich
'---- oberen Kastenrand anzeigen
LOCATE y1%, x1%
PRINT LO$; STRING$(x2% - x1% - 1, WA$); RO$
'---- seitliche Kastenraender anzeigen
FOR y% = y1% + 1 TO y2% - 1
  LOCATE y%, x1%: PRINT SE$
  LOCATE y%, x2%: PRINT SE$
NEXT
'---- unteren Kastenrand anzeigen
LOCATE y2%, x1%
PRINT LU$; STRING$(x2% - x1% - 1, WA$); RU$
END SUB

