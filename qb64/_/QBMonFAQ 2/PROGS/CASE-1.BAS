'*****************************************************
' CASE-1.BAS - Beispiel 1 fuer den SELECT CASE Befehl
' ==========
' Es wird eine Schulnote als Zahl 1...6 abgefragt
' und in eine Textnote "sehr gut...ungenuegend"
' umgewandelt und angezeigt.
'
' von SM, 22.10.03
'*****************************************************
CLS
INPUT "Gib deine Note ein (1...6): ", Note%
SELECT CASE Note%
  CASE 1: PRINT "sehr gut"
  CASE 2: PRINT "gut"
  CASE 3: PRINT "befriedgend"
  CASE 4: PRINT "ausreichend"
  CASE 5: PRINT "mangelhaft"
  CASE 6
    PRINT "ungenuegend"
    PRINT "Die Versetzung ist gefaehrdet!!!"
  CASE ELSE: PRINT "Diese Note gibt es nicht."
END SELECT

