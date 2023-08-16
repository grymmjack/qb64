'*****************************************************************************
' MITNULL.BAS = Anzeige einer Ganzzahl mit fuehrenden Nullen und fester Laenge
' ===========
' Dieses QBasic-Programm demonstration die FUNCTION MitNull$ und zeigt eine
' Ganzzahl (INTEGER) mit einer festen Laenge und fuehrenden Nullen an ' ("Kilometerzaehler-Effekt").
'
' Es liegt folgendes Prinzip zugrunde:
' Darstellung einer max n-stelligen Zahl ==> Es wird '10 hoch n' zur Zahl
' hinzuaddiert. Das Ergebnis wird in einen String umgewandelt und dessen
' linke Stelle ("1") ausgeblendet.
'
' Eine andere, eventuell schnelle Variante ( (c) Hawkynt) lautet:
'  MitNull$=right$(string$(stellen%,"0")+ltrim$(rtrim$(str$(zahl%))),stellen%)
'
'
'   \         (c) Thomas Antoni, 3.11.99 - 20.2.04
'    \ /\           Mailto:thomas*antonis.de
'    ( )            www.antonis.de 
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'******************************************************************************
DECLARE FUNCTION MitNull$ (Zahl&, stellen%)
DO
CLS
PRINT
INPUT " Welche Zahl soll mit fuehrenden Nullen angezeigt werden:"; Zahl&
PRINT
INPUT " Mit wievielen Stellen soll die Zahl angezeigt werden:   "; stellen%
PRINT
PRINT
PRINT " Die mit fuehrenden Nullen versehene Zahl lautet:";
COLOR 14, 1
LOCATE , 55: PRINT MitNull(Zahl&, stellen%)
COLOR 15, 0
PRINT
PRINT
PRINT " ----==== Wiederholen...[beliebige Taste]     Beenden...[Esc] ====----"
DO: taste$ = INKEY$: LOOP UNTIL taste$ <> ""
LOOP UNTIL taste$ = CHR$(27)
END
'
FUNCTION MitNull$ (Zahl&, stellen%)
'****************************************************************************
' MitNull = QBasic-Function zum Erzeugen von fuehrenden Nullen
' =====================================================================
' Aus der uebergebenen zahl& wird eine Zeichenkette mit der gewuenschten
' Anzahl von stellen% erzeugt. Nicht vorhandene Dezimalstellen werden
' mit Nullen aufgefuellt.
'
' Beispiel: MitNull$(123, 6) ==> "000123
'
' Thomas.Antoni, 03.11.99 - 20.2.04
'   thomas*antonis.de
'***************************************************************************+

MitNull$ = RIGHT$(STR$(Zahl& + 10 ^ stellen%), stellen%)
END FUNCTION

