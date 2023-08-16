'*****************************************************************
' SPLINE.BAS = Zeichnet eine Spline-Kurve durch 4 Punkte
' ==========
' Dieses Q(uick)Basic-Programm ermoeglicht dem Anwender, auf dem
' Bildschirm 4 Punkte mit Pfeiltasten zu platzieren und jeweils
' mit <Enter> zu uebergeben.
' Dann zeichnet das Programm eine Spline-Kurvenlinie durch die
' 4 Punkte. Ein Spline ist die Nachbildung einer gebogenen
' Kurve durch Polynome (Ganzrationale Funktionen).
'
' (c) Andreas Meile, 7.4.06  -   www.dreael.ch
'*****************************************************************
'
TYPE Punkt
  x AS SINGLE
  y AS SINGLE
END TYPE
'
CONST Aufloesung% = 100
'
DECLARE SUB HolePunkt (prompt$, p AS Punkt)
DECLARE SUB ZeichneCursor (x%, y%)
DECLARE SUB ParamTeil (p1 AS Punkt, p2 AS Punkt, fakt!, p AS Punkt)
'
DIM SHARED x1%, y1%, kr%(961)
'
DIM p1 AS Punkt, p2 AS Punkt, p3 AS Punkt, p4 AS Punkt
DIM p12 AS Punkt, p23 AS Punkt, p34 AS Punkt, p1223 AS Punkt, p2334 AS Punkt
DIM p AS Punkt
'
FOR i% = 2 TO 961
  kr%(i%) = -1
NEXT i%

SCREEN 12
x1% = 320
y1% = 240
HolePunkt "Startpunkt", p1
HolePunkt "1. Kontrollpunkt", p2
HolePunkt "2. Kontrollpunkt", p3
HolePunkt "Endpunkt", p4

PSET (p1.x, p1.y), 15

FOR i% = 1 TO Aufloesung%
  fa! = CSNG(i%) / CSNG(Aufloesung%)
  ParamTeil p1, p2, fa!, p12
  ParamTeil p2, p3, fa!, p23
  ParamTeil p3, p4, fa!, p34
  ParamTeil p12, p23, fa!, p1223
  ParamTeil p23, p34, fa!, p2334
  ParamTeil p1223, p2334, fa!, p
  LINE -(p.x, p.y), 15
NEXT i%

d$ = INPUT$(1)
SCREEN 0
WIDTH 80, 25
'
SUB HolePunkt (prompt$, p AS Punkt)
  LOCATE 1, 1
  PRINT prompt$;
  DO
    ZeichneCursor x1%, y1%
    DO
      t$ = INKEY$
    LOOP WHILE t$ = ""
    ZeichneCursor x1%, y1%
    SELECT CASE t$
    CASE CHR$(0) + "H"
      IF y1% > 0 THEN
        y1% = y1% - 1
      END IF
    CASE CHR$(0) + "K"
      IF x1% > 0 THEN
        x1% = x1% - 1
      END IF
    CASE CHR$(0) + "M"
      IF x1% < 639 THEN
        x1% = x1% + 1
      END IF
    CASE CHR$(0) + "P"
      IF y1% < 479 THEN
        y1% = y1% + 1
      END IF
    END SELECT
  LOOP UNTIL t$ = CHR$(13)
  LOCATE 1, 1
  PRINT SPACE$(LEN(prompt$));
  LINE (x1% - 3, y1%)-(x1% + 3, y1%), 6
  LINE (x1%, y1% - 3)-(x1%, y1% + 3), 6
  p.x = CSNG(x1%)
  p.y = CSNG(y1%)
END SUB
'
SUB ParamTeil (p1 AS Punkt, p2 AS Punkt, fakt!, p AS Punkt)
  p.x = p1.x + fakt! * (p2.x - p1.x)
  p.y = p1.y + fakt! * (p2.y - p1.y)
END SUB
'
SUB ZeichneCursor (x%, y%)
  kr%(0) = 640
  kr%(1) = 1
  PUT (0, y%), kr%, XOR
  kr%(0) = 1
  kr%(1) = 480
  PUT (x%, 0), kr%, XOR
END SUB

