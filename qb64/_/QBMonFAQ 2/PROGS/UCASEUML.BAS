'****************************************************************************
' UCASEUML.BAS = QBasic UCASE-Funktion, die auch mit Umlauten funktioniert
' ============
' Die in QBasic eingebaute Funktion UCASE$ wandelt Klein- in Grossbuchstaben
' um. Das funktioniert aber nicht bei Umlauten. Hier eine Ersatzfunktion, die
' auch bei den Umlauten ae, oe und ue funktioniert.
' Beim Lesen des Quellspracheprogramms unter Windows ist zu beachten, dass
' die Umlaute im Windows-ANSII-Code anders dargestellt werden als in dem
' von QBasic verwendeten DOS-ASCII-Code.
'
'   \         (c) Thomas Antoni, 07.05.02 - 27.2.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
CLS
PRINT "Gib einen Text in Kleinbuchstaben mit Umlauten ein:"
INPUT "", x$
n% = 1
'
'---- a-Umlaut gross machen
DO
  n% = INSTR(x$, "„")
  IF n% > 0 THEN MID$(x$, n%, 1) = "Ž" ELSE EXIT DO
LOOP
'
'---- o-Umlaut gross machen
n% = 1
DO
  n% = INSTR(n%, x$, "”")
  IF n% > 0 THEN MID$(x$, n%, 1) = "™" ELSE EXIT DO
LOOP
'
'---- u-Umlaut gross machen
n% = 1
DO
  n% = INSTR(x$, "")
  IF n% > 0 THEN MID$(x$, n%, 1) = "š" ELSE EXIT DO
LOOP
'
'---- alle anderen Kleinbuchstaben gross machen
x$ = UCASE$(x$)
'
'---- umgewandelten Text anzeigen
PRINT "Der in Grossbuchstaben umgewandelte Text lautet wie folgt:"
PRINT x$
SLEEP
END

