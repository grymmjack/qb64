'****************************************************************************
' SREENR3.BAS - QBASIC-Programm z.Abspeichern des Text-Bildschirms mit BSAVE
' ===========
' Zunaechst wird der kurze Text "Thomas Antoni" auf den Bildschirm ausgegeben.
' Anschlie·end wird der gesamte Bildschirm mit BSAVE direkt in die Datei
' ~TEXT.TMP abgespeichert.
' Nach Druecken einer beliebigen Taste wird der Bildschirm geloescht. Wird
' nochmals eine beliebige Taste gedrueckt, wird der in ~TEXT.TMP abgelegte
' Bildschirminhalt wieder in den Bildschirmspeicher transferiert und auf
' diese Weise wieder zur Anzeige gebracht.
'
' Verwendete Befehle: DEF SEG, BSAVE
'
' Credits: Das Prinzip dieses Programms wurde der sehr guten Unterprogramm-
'          sammlung QSUBFUN.BAS von Matthew R. Usner entnommen, die man
'          auf http://www.antonis.de downloaden kann.
'          Thanks a lot, Matthew!
'
'
'   \         (c) Thomas Antoni, 04.03.00
'    \ /\           Mailto:thomas*antonis.de
'    ( )            http://www.antonis.de   
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'****************************************************************************
'
CLS : SL$ = ""
PRINT "Thomas Antoni"
'
'------ Gesamten Bildschirm auslesen und in die Datei ~TEXT.TMP ablegen -----
DEF SEG = &HB800             'Bildschirmspeicher-Segment bei Farbmonitor
BSAVE "~TEXT.TMP", 0, 4000   'Bildschirmspeicher (4000 Bytes) in Datei lesen
'
'------- Bildschirm loeschen wieder anzeigen --------------------------------
SLEEP
CLS
PRINT "DrÅcke eine beliebige Taste"
SLEEP
CLS
BLOAD "~TEXT.TMP"
SLEEP
END


