'***********************************************************
' ERSTPROG.BAS - erstes kleines Programm fuer SelfQB
' ============
' (c) by Triton 2001/2002 *g*
'***********************************************************
CLS           'Bildschirm loeschen
texta$ = "Ich sitze hier am Computer und..."
textb$ = "...schreibe Programme, die keinen Sinn machen."
textc$ = "Doch sie sind cool - sie sind ja auch von mir!"
'
COLOR 1, 15   'blaue Schrift (=1) auf weissem Grund (=15)
LOCATE 8, 20  'Ausgabe ab Zeile 8, Spalte 20
PRINT texta$  'Inhalt von texta$ anzeigen
'
SLEEP 2       '2 sec warten
LOCATE 10, 20
COLOR 4, 6    'rote Schrift auf braunem Grund
PRINT textb$
'
SLEEP 3
COLOR 15, 1   'weisse Schrift auf blauem Grund
PRINT         'Leerzeile anzeigen
LOCATE 12, 20
PRINT textc$
SLEEP 5
END