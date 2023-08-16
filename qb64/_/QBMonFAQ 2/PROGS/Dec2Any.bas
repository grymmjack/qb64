'*****************************************************************
' Dec2Any.bas = Zahlenkonvertierung Dez. -> beliebige Basis
' ===========
' Routine die eine Dezimalzahl in jede andere Zahlenbasis
' zwischen 1 und 35 umrechnet
'
' (c) Andreas Meile
'       http://dreael.catty.ch/Deutsch/BASIC-Knowhow-Ecke
'*****************************************************************
CLS
INPUT "Eingabe-Zahl (Dezimal)......................: ", Zahl%
PRINT "Zahlenbasis der Ausgabe-Zahl"
PRINT " (2-Binaer, 8-Octal, 16-Hexadezimal ...) ...: ";
INPUT "", Basis%
NeueZahl$ = ""
Ziffern$ = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DO
  a% = Zahl% MOD Basis%
  NeueZahl$ = MID$(Ziffern$, a% + 1, 1) + NeueZahl$
  Zahl% = INT(Zahl% / Basis%)
LOOP UNTIL Zahl% = 0
PRINT
PRINT "Ausgabe-Zahl im"; Basis%;
PRINT "-er-System................: "; NeueZahl$


