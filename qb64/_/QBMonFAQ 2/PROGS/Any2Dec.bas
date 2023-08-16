'***************************************************************
' Any2Dec.bas = Zahlenkonvertierung beliebige Basis -> Dez.
' ============
' Wandlung einer in einer beliebigen Zahlenbasis zwischen 2
' und 35 vorliegenden Eingabe-Zahl in eine Dezimalzahl.
' (die Buchstaben in der Eingabezahl muessen in Grossbuchstaben
' geschrieben werden (z.B. A...F bei Hexa-Zahlen)
'
' (c)Andreas Meile
'     http://dreael.catty.ch/Deutsch/BASIC-Knowhow-Ecke
'***************************************************************
CLS
INPUT "Gib die Eingabe-Zahl ein ................: "; Zahl$
PRINT "Gib die Zahlenbasis der Eingabe-Zahl ein "
INPUT "...(2=binaer, 8=oktal, 16=hex) ..........: "; basis%
z& = 0&
FOR i% = 1 TO LEN(Zahl$)
  ziffer% = ASC(MID$(Zahl$, i%, 1)) - ASC("0")
  IF ziffer% >= 10 THEN
    ziffer% = ziffer% - ASC("A") + ASC("0") + 10
  END IF
  z& = CLNG(basis%) * z& + CLNG(ziffer%)
NEXT i%
PRINT "Ausgabe-Zahl .............................: "; z&



