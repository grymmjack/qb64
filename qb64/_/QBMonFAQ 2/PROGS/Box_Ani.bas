'********************************************************
' BOX_ANI.BAS - Animierte Box auf d. Bildschirm ausgeben
' ===========
' Dies Programm zeigt einen Kasten mit Randlinien an,
' die aus wandernden Punkten bestehen.
'
' (c) "xeno on" ( f_landau*gmx.ch ), 19.11.2002
'********************************************************
SCREEN 12
CLS
oben% = 100
unten% = 200
links% = 100
rechts% = 200
'
DO
LINE (links%, oben%)-(rechts%, oben%), 15, B, &H8888
LINE (rechts%, oben%)-(rechts%, unten%), 15, B, &H8888
LINE (links%, unten%)-(rechts%, unten%), 15, B, &H1111
LINE (links%, unten%)-(links%, oben%), 15, B, &H8888
WAIT &H3DA, 8
LINE (links%, oben%)-(rechts%, oben%), 0, B, &H8888
LINE (rechts%, oben%)-(rechts%, unten%), 0, B, &H8888
LINE (links%, unten%)-(rechts%, unten%), 0, B, &H1111
LINE (links%, unten%)-(links%, oben%), 0, B, &H8888
LINE (links%, oben%)-(rechts%, oben%), 15, B, &H4444
LINE (rechts%, oben%)-(rechts%, unten%), 15, B, &H4444
LINE (links%, unten%)-(rechts%, unten%), 15, B, &H2222
LINE (links%, unten%)-(links%, oben%), 15, B, &H4444
WAIT &H3DA, 8 'Warten auf Bildschirm-Neuaufbau
LINE (links%, oben%)-(rechts%, oben%), 0, B, &H4444
LINE (rechts%, oben%)-(rechts%, unten%), 0, B, &H4444
LINE (links%, unten%)-(rechts%, unten%), 0, B, &H2222
LINE (links%, unten%)-(links%, oben%), 0, B, &H4444
LINE (links%, oben%)-(rechts%, oben%), 15, B, &H2222
LINE (rechts%, oben%)-(rechts%, unten%), 15, B, &H2222
LINE (links%, unten%)-(rechts%, unten%), 15, B, &H4444
LINE (links%, unten%)-(links%, oben%), 15, B, &H2222
WAIT &H3DA, 8
LINE (links%, oben%)-(rechts%, oben%), 0, B, &H2222
LINE (rechts%, oben%)-(rechts%, unten%), 0, B, &H2222
LINE (links%, unten%)-(rechts%, unten%), 0, B, &H4444
LINE (links%, unten%)-(links%, oben%), 0, B, &H2222
LINE (links%, oben%)-(rechts%, oben%), 15, B, &H1111
LINE (rechts%, oben%)-(rechts%, unten%), 15, B, &H1111
LINE (links%, unten%)-(rechts%, unten%), 15, B, &H8888
LINE (links%, unten%)-(links%, oben%), 15, B, &H1111
WAIT &H3DA, 8
LINE (links%, oben%)-(rechts%, oben%), 0, B, &H1111
LINE (rechts%, oben%)-(rechts%, unten%), 0, B, &H1111
LINE (links%, unten%)-(rechts%, unten%), 0, B, &H8888
LINE (links%, unten%)-(links%, oben%), 0, B, &H1111
LOOP UNTIL INKEY$ <> ""
END

