'******************************************************************
' ZUFSOUND.BAS = Musik ueber den Zufallsgenerator mit Grundmelodie
' ============
' Dieses QBasic-Programm bringt eine von Zufallsgenerator erzeugt
' Musik ueber den PC-Speaker zu Gehoer, die einer Grundmelodie
' folgt.
' (c) Thomas Antoni, 28.2.2005  -  www.qbasic.de
'     nach einer Programmidee von Gerd Kebschull
'******************************************************************
PLAY "o2" 'aktuelle Oktave
PLAY "c5 d5 e5 f5 g5 a5 b5 >c5"
RANDOMIZE TIMER
PLAY "o2"
DO
  T% = INT(RND * 10 + 1)
  SELECT CASE T%
    CASE 1: PLAY "c"
    CASE 2: PLAY "d t100"
    CASE 3: PLAY "e ml"
    CASE 4: PLAY "gg d2 g5 ff p10cc >ff"
    CASE 5: PLAY "g p10"
    CASE 7: PLAY "b cc p20cdeed cc p20b cc p20cdeed"
    CASE 8: PLAY ">c"
    CASE 9: PLAY "p10"
    CASE 10: PLAY "cc ff gg dd fff cc ff gg ff cc"
  END SELECT
LOOP WHILE INKEY$ = ""  'Benden mit beliebiger Taste
END

