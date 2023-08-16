'*****************************************************************
' ZINSEN2.BAS = Kapital-Verdopplung mit Zinseszinz berechnen
' ===========
' Dieses Programm zeigt das von Jahr zu Jahr wachsende Guthaben
' an, das zu einem bestimmten Zinssatz angelegt wurde. Es werden
' die Jahresguthaben solange angezeigt, bis sich das Kapital
' verdoppelt hat. Dabei werden Zinseszinsen einberechnet.
'
' (c) z0mbie, 7.10.2003
'*****************************************************************
WIDTH 80, 50 'doppelte Zeilenzahl (50 Zeilen) aktivieren
CLS
INPUT " Anfangskapital...........:"; anfangskapital
INPUT " Zinssatz.................:"; zinssatz
kapital = anfangskapital
i = 0  'Jahre vorbesetzen
WHILE NOT kapital >= anfangskapital * 2
kapital = kapital + kapital * zinssatz / 100
i = i + 1
PRINT USING " Kapital nach ## Jahren....: #######.## Euro"; i; kapital
WEND
SLEEP

