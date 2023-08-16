'******************************************************************************
' DAT-ZEIT.BAS - QBASIC-Programm zur Ausgabe von Datum und Uhrzeit
' =================================================================
' ... auf den Bildschirm sowie Umwandlung des Datums ins deutsche Format
'
' Verwendete Befehle: DATE$, TIME$, PRINT, INKEY$, MID$, LEFT$, RIGHT$
'
'   \         (c) Thomas Antoni, 4.3.99 - 18.9.99 
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'******************************************************************************

CLS
DO
  LOCATE 1, 1               'Cursor wieder auf Zeile 1, Spalte 1, um alte
                            'Ausgabe zu Ueberschreiben und Zeilenfortschal-
                            'tung zu unterdruecken
'
'---------------- Systemvariablen "Uhrzeit" und "Datum" ausgeben -----------
  PRINT "Datum im Normalformat     : "; DATE$
  PRINT "Uhrzeit                   : "; TIME$
  PRINT
'
'--------- Datum zusaetzlich im deutschen Format dd.mm.jjjj ausgeben --------
'---------           statt in der Form  mm-dd-jjjj          -----------------
  d$ = DATE$
  Datum$ = MID$(d$, 4, 2) + "." + LEFT$(d$, 2) + "." + RIGHT$(d$, 4)
  PRINT "Datum in deutschem Format : "; Datum$
  PRINT
'
'------------- Schlussdialog -----------------------------------------------
'
  PRINT "DrÅcke eine beliebige Taste, um abzubrechen ..."
LOOP WHILE INKEY$ = ""
'END                         ' Controlle an den QBASIC-Editor Åbergeben
SYSTEM                       ' Controlle an DOS Uebergeben



