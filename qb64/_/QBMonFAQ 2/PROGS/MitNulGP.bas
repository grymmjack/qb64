'*******************************************************************
' MITNULGP.BAS = Anzeige einer Gleitpunktzahl mit fuehrenden Nullen
' ============
' Dieses Q(uick)Basic-Programm rundet eine Gleitpunktzahl mit Hilfe
' des CLNG()-Befehls auf eine waehlbare Anzahl von Nachkommastellen
' und zeigt sie dann mit einer festen Anzahl von Dezimalstellen an.
' Auch die Anzahl der  angezeigten Vorkommastellen ist waehlbar.
' Nicht vorhandene Ziffern am Anfang der Vorkommastellen werden
' dabei als Nullen statt als Leerzeichen angezeigt
' (Kilometerzaehler-Effekt).
'
' (c) Thomas Antoni, 12.12.2005
'*******************************************************************
DO
CLS
INPUT "Gib eine Zahl mit Dezimalpunkt ein: ", z#
INPUT "Mit wieviel Vorkommastellen soll die Anzeige erfolgen  "; vk%
INPUT "Mit wieviel Nachkommastellen soll die Anzeige erfolgen "; nk%
z$ = RIGHT$(STR$(CLNG(z# * 10 ^ nk%) + 10 ^ (vk% + nk%)), vk% + nk%)
PRINT
PRINT LEFT$(z$, vk%); ","; RIGHT$(z$, nk%)
PRINT
PRINT "Neue Eingabe...[Beliebige Taste  Beenden...[Esc]"
DO: taste$ = INKEY$: LOOP WHILE taste$ = ""
IF taste$ = CHR$(27) THEN END
LOOP

