'***********************************************************
' SELCLS  = Bildschirmbereich selektiv loeschen
' ======
' Dieses QBasic-Programm loescht einen Teilbereich des
' Bildschirms. Dieser wird mit dem VIEW-Befehl definiert
'
' (c) Thomas Antoni, 29.3.2004
'***********************************************************
SCREEN 12
CLS
LINE (10, 10)-(630, 470), 14, BF 'gelben Kasten malen
VIEW (50, 50)-(590, 420)         'Anzeigefenster definieren
CLS                              'Anzeigefenster loeschen
SLEEP

