'*****************************************************
' ShowDir.bas = Inhalt eines Ordners anzeigen mit DIR$
' ===========
' Directory-Anzeige fuer QuickBasic 7.1, FirstBASIC
' und PowerBASIC. Zeigt den Inhalt eines waehlbaren
' Verzeichnisses mit Hilfe des DIR$-Befehls an.
' Den DIR$-Befehl gibt es nicht bei QBasic und
' QuickBasic 4.5, sondern nur bei QuickBaic 7.1
' (PDS), FirstBASIC und PowerBASIC
'
' (c) Thomas Antoni, 1.9.02 - 25.2.04
'*****************************************************
CLS
PRINT "Gib den Pfadnamen ein"
INPUT " ...mit abschliessendem \  : ", path$
PRINT DIR$(path$)
DO
  d$ = DIR$
  IF d$ = "" THEN EXIT DO
  PRINT d$
LOOP


