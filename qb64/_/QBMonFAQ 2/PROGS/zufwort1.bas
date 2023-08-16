'*******************************************
' ZUFWORT1.BAS = Zufallsworte erzeugen
' ============
' Dieses QBasic-Programm waehlt nach dem
' Zufallsprinzip eines von mehreren
' vorgegebenen Worten aus
' (c) NicTheQuick, 10.2.02
'*******************************************
'
CLS
AnzahlWorte% = 4  'Anzahl der Worte
RANDOMIZE TIMER
ZufallsZahl = FIX(RND * AnzahlWorte%) + 1
'Ganze Zufallszahl zwischen 1 und AnzWorte%
'
SELECT CASE ZufallsZahl
  CASE 1: PRINT "Zufallswort 1"
  CASE 2: PRINT "Zufallswort 2"
  CASE 3: PRINT "Zufallswort 3"
  CASE 4: PRINT "Zufallswort 4"
END SELECT
SLEEP
END

