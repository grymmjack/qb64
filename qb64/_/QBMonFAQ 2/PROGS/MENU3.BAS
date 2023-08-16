'***************************************************
' MENU3.BAS = Bildschirmmenü mit Scrollfunktion
' =========
' (c) von Andreas Meile ("Dreael", andreas*hofen.ch )
'     www.hofen.ch/~andreas/
'------------------------------------------------
CONST n% = 6 ' Total 6 Optionen
'
' Die Menuepunkte muessen als Array vorliegen
DIM mp$(0 TO n% - 1)
'
' Hier laden wir die Menuepunktdaten
FOR i% = 0 TO n% - 1
READ mp$(i%)
NEXT i%
DATA "Apfel", "Birne", "Pflaume", "Aprikose"
DATA "Ananas", "Pfirsich"
'
' Bildschirmmaske aufbauen
DO
COLOR 7, 0
CLS
LOCATE 2, 10
PRINT "Bitte waehle eine Frucht aus:"
'
' Menu ausgeben
FOR i% = 0 TO n% - 1
  LOCATE 4 + i%, 10
  PRINT mp$(i%);
NEXT i%
'
a% = 1              'a% zeigt auf den Vorgabewert, in diesem
                    'Fall also auf mp$(1), d.h. Birne
'
DO
  COLOR 0, 7        'Wir muessen die "hervorgehoben"
                    'Farbkombination waehlen
  LOCATE 4 + a%, 10 'und den Menuepunkt damit
  PRINT mp$(a%);    'darstellen
DO
  t$ = INKEY$       'hier wird eine Taste abgefragt
LOOP WHILE t$ = ""
' Vor der Auswertung muss die Hervorhebung
LOCATE 4 + a%, 10   ' wieder geloescht werden
COLOR 7, 0
PRINT mp$(a%);
' Ab hier werden die Tasten ausgewertet
SELECT CASE t$
CASE CHR$(0) + "H"  '=Cursor hoch (Tabelle!)
' Im Prinzip a% = a% - 1, aber der Balken soll
' einfach wieder unten herauskommen, d.h. kein
' "Anschlag", deswegen der Modulo, denn dieser
' bewirkt hier, dass aus a% = 0 wieder a% = 5
' wird
  a% = (a% + n% - 1) MOD n%
CASE CHR$(0) + "P"  'Dasselbe mit Cursor unten
  a% = (a% + 1) MOD n%
END SELECT
LOOP UNTIL t$ = CHR$(13) 'Solange drinbleiben
' bis man <Enter> gedrueckt hat
'
' Auswahl ausgeben
LOCATE 5 + n%, 1
PRINT "Es wurde "; mp$(a%); " gewaehlt."
PRINT
PRINT "  Wiederholen...[beliebige Taste]   Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
     'Warten auf Tastenbetaetigung
  IF taste$ = CHR$(27) THEN END
     'Beenden mit Esc
LOOP

