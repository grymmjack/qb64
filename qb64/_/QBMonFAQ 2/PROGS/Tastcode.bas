'****************************************************************************
' TASTCODE.BAS - QBasic-Programm zur Ermittlung d.Tastaturcodes einer Taste
' ==========================================================================
'
' Anmerkung 1: Der Tastaturcode einiger Sondertasten besteht aus 2 Bytes
'              und werden so angezeigt: "(CHR$(<1.Byte>) + CHR(<2.Byte>)"
' Anmerkung 2: Die Tastaturcodes werden in der Form "CHR$(x)" ausgegeben.
'              In dieser Form koennen sie direkt in einer Tastenabfrage
'                  z.B.  'taste$=inkey$: IF taste$= xxx THEN ...'
'              verwendet werden.
'    
'
'
'   \         (c) Thomas Antoni, 01.08.99 - 24.02.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de 
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
COLOR , 1: CLS                 'Bildschirm blau einfaerben
PRINT " Ermittlung des Tastencodes fuer eine beliebige Taste"
PRINT " ===================================================="
PRINT
PRINT " Druecke eine beliebige Taste! ...(beenden mit Esc)"
PRINT
VIEW PRINT 6 TO 25             'die weiteren Ausgaben erfolgen rollierend in
                               'den Bildschirmzeilen 6 bis 25
  COLOR 0, 7                   'Schwarz auf Hellgrau
  CLS                          'Diesen Bereich Hellgrau einfaerben
DO
  DO: taste$ = INKEY$: LOOP WHILE taste$ = ""   'auf Tastenbetaetigung warten
  PRINT " Die Taste hat den dezimalen Tastencode ";
  COLOR 14, 1                                   'gelb auf blau
  PRINT "CHR$("; ASC(taste$); ")";
  IF LEN(taste$) = 2 THEN PRINT " + CHR$("; ASC(RIGHT$(taste$, 1)); ")";
                                'Sondertaste mit 2 Zeichen langem Tastencode
  COLOR 0, 7                    'Schwarz auf Hellgrau
LOOP UNTIL taste$ = CHR$(27)
SLEEP 2                         '2 sec warten vor dem Beenden
END

