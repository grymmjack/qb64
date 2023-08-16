'****************************************************************************
' SREENR2.BAS - QBASIC-Programm zum Auslesen des Text-Bildschirms mit PEEK
' ===========
' Zun„chst wird der kurze Text "Thomas Antoni" auf den Bildschirm ausgegeben.
' Anschlieáend wird der gesamte Bildschirm mit PEEK direkt aus dem Bildschirm-
' Speicher ausgelesen SL$ eingetragen.
' Die ersten 20 Zeichen des gespeicherten Bildschirminhalte wird anschlies-
' send wieder in die 24. Bildschirmzeile ausgegeben.
'
' Verwendete Befehle: DEF SEG, POKE
'
' Credits: Das Prinzip diese Programms wurde der sehr guten Unterprogramm-
'          sammlung QSUBFUN.BAS von Matthew R. Usner entnommen, die man
'          auf http://www.antonis.de downloaden kann.
'          Thanks a lot, Matthew!
'
'
'   \         (c) Thomas Antoni, 04.03.00 - 25.2.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
'
CLS : SL$ = ""
PRINT "Thomas Antoni"
'
'------ Gesamten Bildschirm auslesen und in die Variable SL$ ablegen -------
DEF SEG = &HB800      'Bildschirmspeicher-Segment bei Farbmonitor
FOR Row% = 1 TO 25    'alle 25*80=2000 Bildschirmzeichen in SL$ einlesen
'  SL$ = ""
  FOR Col% = 1 TO 80
    SL$ = SL$ + CHR$(PEEK((Row% - 1) * 160 + ((Col% - 1) * 2)))
    LOCATE Row%, Col%
  NEXT Col%
'  PRINT #F%, SL$
NEXT Row%
DEF SEG
'
'------- Bildschirm loeschen und die ersten 20 Zeichen wieder anzeigen -----
SLEEP
CLS
PRINT "Druecke eine beliebige Taste"
SLEEP
CLS
LOCATE 24
PRINT LEFT$(SL$, 20)
SLEEP
END


