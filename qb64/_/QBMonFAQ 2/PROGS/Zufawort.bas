'*************************************************
' ZUFAWORT.BAS = Zufallswort erzeugen
' ============
' Dieses QBasic-Programm erzeugt ein Zufalls-
' wort mit 5 Buchstaben, jeweils zwischen A und Z
'
' (c) Thomas Antoni
'*************************************************
CLS
DO
RANDOMIZE TIMER 'Zufallsgenerator initialisieren
FOR i% = 1 TO 5
  PRINT CHR$(INT(RND * (26)) + 65);
  'Zufaelliger ASCII-Code zwischen 65 und 90
NEXT
PRINT
PRINT " Wiederholen...beliebige Taste";
PRINT " Benden...Esc"
taste$ = INPUT$(1) 'Warten bis 1 Taste betaetigt
LOOP UNTIL taste$ = CHR$(27) 'Beenden mit Esc

