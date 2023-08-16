'***************************************************************************
' KOMMA2PT.BAS = Zahleneingabe mit Komma statt Dezimalpunkt
' ============
' Dieses QBasic-Programm erfragt vom Anwender eine Zahl mit Dezimalkomma
' und zeigt diese mit Dezimalpunkt an. Ausserdem wird das zusaetzlich da
' Doppelte der Zahl angezeigt.
'
' (c) Thomas Antoni, 19.2.2005  --  www.qbasic.de
'       nach einer Programmidee von H.J.Sacht
'***************************************************************************
CLS
DO
'
'****** Zahleneingabe mit Komma
DO
  LINE INPUT "Gib eine Zahl mit Dezimalkomma ein.........:  "; Z$
  K% = INSTR(1, Z$, ",")       'Zeichenposition des Kommas ermitteln
LOOP UNTIL K% > 0              'Neueingabe falls kein Komma gefunden
'
'****** Komma in Punkt umwandeln
Z$ = LEFT$(Z$, K% - 1) + "." + MID$(Z$, K% + 1)
                               'Komma durch Punkt ersetzen
Z# = VAL(Z$)                   'Zahl-String in numerischen Wert wandeln
'
'****** Zahl und dessen Doppeltes mit Punkt anzeigen
PRINT "Die Zahl in Dezimalpunktschreibweise lautet: "; Z#
PRINT "Zahl mit 2 multipliziert...................: "; Z#; "* 2 = "; Z# * 2
'
'****** "Wiederholen/Beenden"-Dialog
PRINT
PRINT "Neue Eingabe...[Beliebige Taste]  Beenden...[Esc]"
t$ = INPUT$(1)                 'Warten auf beliebige Tastenbetaetigung
LOCATE , , 0
LOOP UNTIL t$ = CHR$(27)
END

