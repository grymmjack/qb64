'*************************************************************************
' ONTIMER.BAS = Uhrzeitanzeige mit ON TIMER unabhaengig vom Hauptprogramm
' ===========
' (c)Hawkynt, 1999
'*************************************************************************
CLS
ON TIMER(1) GOSUB TIRQ1   'Timer-Interruptrogrammbearbeitung scharfmachen
TIMER ON
GOTO TIMEBRK:             'Uhrzeitbearbeitung ueberspringen
'
TIRQ1:
X% = POS(0)               'Cursorposition sichern
Y% = CSRLIN
LOCATE 1, 50
PRINT STRING$(8, 32);
LOCATE 1, 50
PRINT TIME$;
LOCATE Y%, X%              'Cursorposition wieder herstellen
RETURN
'
TIMEBRK: 'Hauptprogramm: Zahlenkolonne anzeigen
DO: i = i + 1: LOCATE 1, 1: PRINT i: LOOP WHILE INKEY$ = ""
         'Abbruch mit beliebiger Tastenbetaetigung

