'****************************************************************************
' SEQFILE.BAS - Demonstration der Bearbeitung einer sequentiellen Datei
' ===========
' Dieses kleine Demoprogramm zeigt, wie man  einfach und bequem in QBasic
' Daten in eine sequentielle Datei abspeichern und wieder zuruecklesen
' kann:
' - Zunaechst werden 2 Adressen abgefragt
' - Diese werden dann in die kleine sequentielle Datei "test.dat" eingetragen
' - Anschliessend werden diese 2 "Datensaetze" aus der Datei zurueckgelesen
'   und in einzeiliger Darstellung auf dem Bildschirm angezeigt.
' Die Datei c:\test.dat muss von Hand geloescht werden
'
' (c) Thomas Antoni, 16.5.2002  ---  thomas*antonis.de
'****************************************************************************
CLS
OPEN "c:\test.dat" FOR OUTPUT AS #1
FOR I = 1 TO 2
  PRINT "Entry of Data Set "; I
  INPUT "Name.... "; NAM$
  INPUT "City.... "; CITY$
  INPUT "Age..... "; AGE
  INPUT "Phone... "; PHONE$
  WRITE #1, NAM$
  WRITE #1, CITY$
  WRITE #1, AGE
  WRITE #1, PHONE$
NEXT
CLS
CLOSE #1
OPEN "c:\test.dat" FOR INPUT AS #1
FOR I = 1 TO 2
  INPUT #1, NAM$
  INPUT #1, CITY$
  INPUT #1, AGE
  INPUT #1, PHONE$
  PRINT I; NAM$; " "; CITY$; AGE; PHONE$
NEXT
CLOSE #1
SLEEP
END

