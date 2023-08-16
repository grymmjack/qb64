'********************************************
' TIMER2.BAS - Selbstanspassender Timer
' ==========
' "Meine Methode, die Schleifen zu messen"
' (c) NicTheQuick (NicolasG*web.de), 2000
'********************************************
ON TIMER(1) GOSUB Test
TIMER ON
k = 0: L2 = 0
DO
  IF k = 1 THEN
    DO
      L2 = L2 + 1
    LOOP UNTIL k = 2
  END IF
LOOP UNTIL k = 2
PRINT "Schleifendurchlaeufe V2:"; L2
'
'Die Zeit, die deine Errechnung spaeter haelt
t1 = TIMER
a = 0: DO: a = a + 1: LOOP UNTIL a = L2
PRINT "Vergangene Zeit V1:"; TIMER - t1
'Die Zeit, die meine Errechnung spaeter haelt
t2 = TIMER
a = 0: DO: a = a + 1: LOOP UNTIL a = L2
PRINT "Vergangene Zeit V2:"; TIMER - t2
SLEEP
END
'
Test: k = k + 1: RETURN

