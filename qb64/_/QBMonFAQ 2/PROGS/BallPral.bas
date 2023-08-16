'**********************************************************
' BALLPRAL.BAS = Ball bewegen, der an einer Wand abprallt
' ============
' Dieses Q(uick)Basic-Programm bewegt einen Ball ueber
' den Bildschirm, der jeweils beim Erreichen des
' Bildschirmrandes dort abprallt
'
' (c) jb, 9.7.05
'**********************************************************
SCREEN 7, , 0, 1
x = 100
y = 100
xs = 1
ys = 1
DO
  x = x + xs
  y = y + ys
  IF x >= 320 OR x <= 0 THEN xs = -xs
  IF y >= 200 OR y <= 0 THEN ys = -ys
  CIRCLE (x, y), 10, 10
  PCOPY 0, 1 'Bildschirmseite kopieren fuer
             'flimmerfreie Animation
  CLS
LOOP UNTIL INKEY$ <> ""