'****************************************************************
' REKURS2.BAS = Demonstriert Rekursion mit Zeichnen von Quadraten
' ===========
' Dieses Q)uick)Basic-Pogramm demonstriert den rekursiven Aufruf
' von Subroutinen. Die SUB rek() zeichnet 4 Quadrate und ruft
' sich solange selbst zum Zeichnen verkleinerter und verschobener
' Quadrate auf bis die Seitenlaenge des Quadrats eine
' untere Grenze erreicht. Daurch erscheint auf dem Bildschirm ein
' interessantes grafisches Muster.
'
' (c) Thomas Antoni, 8.2.2006
' Nach einer Programmidee aus dem Buch
'              "Frank Ostrowski und sein GFA-BASIC"
'****************************************************************
'
DECLARE SUB rek (x!, y!, r!)
'
COMMON SHARED faktor 'faktor als Globalvariable deklarieren (ist
   'auch der SUB bekannt)
SCREEN 12
faktor = .5
CALL rek(300, 225, 115)

SUB rek (x, y, r)
LINE (x - r, y - r)-(x + r, y + r), , B 'Quadrat malen
IF r > 10 THEN
  CALL rek(x + r, y, r * faktor)  'verschobene und ...
  CALL rek(x, y + r, r * faktor)  'verkleinerte ...
  CALL rek(x - r, y, r * faktor)  'Quadrate malen
  CALL rek(x, y - r, r * faktor)
END IF
END SUB

