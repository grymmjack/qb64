'**********************************************************************
'
' MENU1.BAS - ein kleines Beispiel fuer ein textbasiertes Auswahlmenue
' =========
'
'   \         (c) Thomas Antoni, 17.12.01 - 30.7.05
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de  --- www.qbasic.de
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'**********************************************************************
DO
CLS
PRINT
PRINT "  (1) aufraeumen"
PRINT "  (2) schlafen"
PRINT "  (3) ins Kino gehen"
PRINT "  (4) Beenden"
PRINT
PRINT " Waehle gewuenschte Funktion (1) bis (4)"
'
taste$ = INPUT$(1)   'Warten bis 1 Taste von d.Tastatur eingelesen
SELECT CASE taste$
  CASE "1"
    CLS : PRINT "aufraeumen": SLEEP
  CASE "2"
    CLS : PRINT "schlafen": SLEEP
  CASE "3"
    CLS : PRINT "ins Kino gehen": SLEEP
  CASE "4", CHR$(27) 'Beenden mit "4" oder mit Esc
    END
END SELECT
LOOP

