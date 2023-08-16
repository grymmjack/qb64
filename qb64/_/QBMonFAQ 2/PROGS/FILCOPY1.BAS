''****************************************************************
' FILCOPY1.BAS = Kopieren einer Datei, byteweise ohne SHELL
' ============
' Es wird Byte fuer Byte aus der Datei test1.txt gelesen und
' in die Zieldatei test2.txt geschrieben. test1.txt muss sich im
' Verzeichis c:\temp\ befinden.
'
' (c) Thomas Antoni, 4.2.2004
'*****************************************************************
DIM t AS STRING * 1    'Pufferbyte (feste Laenge = 1 Byte)
OPEN "c:\temp\test1.txt" FOR BINARY AS #1 'Quelldatei oeffnen
OPEN "c:\temp\test2.txt" FOR BINARY AS #2 'Zieldatei oefnen
DO UNTIL LOC(1) = LOF(1)'Schleife ueber alle Bytes der Quelldatei
  GET #1, , t           'ein Byte aus Quelldatei lesen
  PUT #2, , t           '... und in Zieldatei schreiben
LOOP
CLOSE #2
CLOSE #1
PRINT "Fertig!"  
