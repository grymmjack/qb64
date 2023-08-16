'*******************************************************
' MERGE.BAS = Merger & Demerger v2.0
' ==========
' Mergen und de-mergen von Dateien
' Dies QBasic-Programm fasst mehrere Dateien zu einer
' Gesamtdatei zusammen (mergen). Ueber das Menue laesst
' sich auch die Umkehrfunktion dazu anwaehlen, naemlich
' das Teilen der durch den Merge-Vorgang erstellten
' Gesamtdatei zu den Ursprungsdateien (de-mergen)
'
' (c) JoePopo, 2.9.2003 - 3.9.2003
'*******************************************************
'
DIM filenames$(99)
DIM filelength(99)
DIM gotten AS STRING * 1
'
DO
  CLS
  LOCATE 1, 29: PRINT "Merger & Demerger v2.0"
  LOCATE 2, 31: PRINT "(w) 2003 by JoePopo": PRINT
  INPUT "(m)ergen, (d)emergen oder e(x)it "; eingabe$
  IF eingabe$ = "m" OR eingabe$ = "M" THEN GOSUB merge
  IF eingabe$ = "d" OR eingabe$ = "D" THEN GOSUB demerge
  IF eingabe$ = "x" OR eingabe$ = "X" THEN END
LOOP
'
'-------- Merge-Routine ---------------------------------
merge:
CLS
LOCATE 1, 37: PRINT "Mergen": PRINT
PRINT " Bitte gib die Namen der zu mergenden Dateien an (max. 99). Die Pfade"
PRINT " MUESSEN angegeben werden! Druecke 2x ENTER, wenn Du fertig bist."
PRINT
'
schleife% = 0
DO
  schleife% = schleife% + 1
  PRINT schleife%; ". Datei "; : INPUT filenames$(schleife%)
LOOP UNTIL filenames$(schleife%) = ""
filecount = schleife% - 1
'
PRINT
INPUT " Bitte gib den Namen - UND den Pfad - der Paketdatei ein "; mergefile$
PRINT
PRINT "Ich merge - Bitte warten!"
'
OPEN mergefile$ FOR APPEND AS #1
PRINT #1, filecount
FOR j = 1 TO filecount
  OPEN filenames$(j) FOR BINARY ACCESS READ AS #2
  filelength(i) = LOF(2)
  PRINT #1, filenames$(j)
  PRINT #1, filelength(i)
  CLOSE #2
NEXT j
CLOSE #1
'
OPEN mergefile$ FOR BINARY ACCESS WRITE AS #1
FOR j = 1 TO filecount
  OPEN filenames$(j) FOR BINARY ACCESS READ AS #2
  l = 0
  k = LOF(1)
  DO WHILE NOT EOF(2)
    l = l + 1
    k = k + 1
    GET #2, l, gotten
    PUT #1, k, gotten
  LOOP
  CLOSE #2
NEXT j
CLOSE #1
RETURN
'
'
'-------- De-Merge-Routine ------------------------------
demerge:
CLS
LOCATE 1, 36: PRINT "Demergen": PRINT
'
PRINT "Bitte gib die Namen - UND den Pfad - der zu demergenden Paketdatei an."
INPUT mergefile$: PRINT
PRINT "Unter welchem Pfad sollen die zu demergenden Dateien gespeichert werden?"
PRINT "(Der Pfad MUá existieren)"
INPUT path$: PRINT
'
IF RIGHT$(path$, 1) <> "\" THEN path$ = path$ + "\"
'
PRINT "Ich demerge - Bitte warten!"
'
OPEN mergefile$ FOR INPUT AS #4
LINE INPUT #4, filecount$
filecount = VAL(filecount$)
FOR i = 1 TO filecount
  LINE INPUT #4, filenames$(i)
  LINE INPUT #4, filelength$: filelength(i) = VAL(filelength$)
NEXT i
CLOSE #4
'
headerlength = 5
FOR i = 1 TO filecount
  headerlength = headerlength + LEN(filenames$(i)) + LEN(STR$(filelength(i))) + 5
NEXT i
'
OPEN mergefile$ FOR BINARY ACCESS READ AS #5
l = headerlength
FOR j = 1 TO filecount
  FOR schl = 1 TO LEN(filenames$(j))
    po = INSTR(schl, mergefile$, "\")
    IF po > 0 THEN posi = po
  NEXT schl
  filenames$(j) = path$ + MID$(filenames$(j), posi + 1, LEN(filenames$(j)) - posi)
  OPEN filenames$(j) FOR BINARY ACCESS WRITE AS #6
  FOR k = 1 TO filelength(j)
    l = l + 1
    GET #5, l, gotten
    PUT #6, k, gotten
  NEXT k
  l = l + 1
  CLOSE #6
NEXT j
CLOSE #5
RETURN

