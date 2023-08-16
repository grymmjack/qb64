'*****************************************************************************
' TEXTBEAR.BAS = Textbearbeitung mit QBasic - die wichtigsten Befehle
' ============
' Dies Programm demonstriert die wichtigsten QBasic-Befehle zum
' Manipulieren von Zeichenketten (Strings). Als Beispiel-String dient das
' Wort "Wiesel". Nach der Erklaerung des jeweiligen Befehls folgt
' immer jeweils ein Anwendungsbeispiel.
'
' (c) Thomas Antoni, 7.1.2004 - 12.2.2004
'*****************************************************************************
CLS
t$ = "Wiesel" 'Die Befehle sind sowohl auf String-Konstanten (z.B. "Wiesel")
              'als auch auf String-Variablen (z.B. t$) anwendbar
'
'---- t$ = t1$ + t2$ -> Strings zusammenfuegen
c$ = "Wie" + "sel"
PRINT c$                  'Ergebnis: "Wiesel"
'
'---- LEFT$(String$, n) -> Liefert n Zeichen links aus einem String zurueck
PRINT LEFT$("Wiesel", 5)  'Ergebnis: "Wiese"
'
'---- RIGHT$(String$, n) -> Liefert n Zeichen rechts aus einem String zurueck
PRINT RIGHT$(t$, 4)       ' Ergebnis: "Esel"
'
'---- MID$(String$, m, n) -> Liefert n Zeichen ab dem m-ten Zeichen zurueck
PRINT MID$("Wiesel", 3, 2) 'Ergebnis: "se"; das m-te Zeichen zaehlt mit
'
'---- MID$(String$, m, n) = Ersatzstring$ -> n Zeichen eines Strings ab
'---- Zeichenposition m durch einen Ersatzstring ersetzen; ideal zum Ersetzen
'---- von Textpassagen durch einen anderen Text!
a$ = "Wiesel"
MID$(a$, 3, 2) = "rb"      'MID$ steht hierbei links von e. Gleichheitszeichen
PRINT a$                   'Ergebnis: "Wirbel"; "es" wird durch "rb" ersetzt
'
'---- LTRIM$(String$)  -> Entfernt fuehrende Leerzeichen aus einem String
PRINT LTRIM$("   Wiesel")  'Ergebnis: "Wiesel" ohne Leerzeichen
'
'---- RTRIM$(String$) -> Entfernt am Ende e.Strings stehende Leerzeichen
PRINT RTRIM$("Wiesel   ")  'Ergebnis: "Wiesel" ohne Leerzeichen
'
'---- INSTR(m, String$, Suchstring$) -> Sucht einen Suchstring in einem String
'------ ab dem m-ten Zeichen und meldet die Zeichenposition des ersten
'------ gefundenen Strings zurueck bzw. 0, wenn der Suchstring nicht gefunden
'------ wurde; ideal zum Suchen von Text!
PRINT INSTR(1, "Wiesel", "sel")  'Ergebnis: "4" = Zeichenposition von "sel"
'
'---- LCASE$ -> Gross- in Kleinbuchstaben umwandeln (nicht für Umlaute)
PRINT LCASE$("Wiesel")      'Ergebnis: "wiesel"
'
'---- UCASE$ -> Klein- in Grossbuchstaben umwandeln (nicht für Umlaute)
PRINT UCASE$("Wiesel")      'Ergebnis: "WIESEL"
'
'---- STR$ -> Numerischen Wert in String umwandeln
b$ = STR$(1 / 3)
PRINT "Ergebnis: "; b$      'Ergebnis: .3333333
'
'---- VAL -> String in numerischen Wert umwandeln
PRINT VAL(".5") * 4         'Ergebnis: 2 (4 x 0,5)
'
'---- SPACE$(n) -> Liefert einen String mit n Leerzeichen
PRINT "Wie"; SPACE$(2); "sel"  'Ergebnis: "Wie__sel" mit 2 Leerzeichen
'
'---- STRING$(n, Text$) -> Liefert einen String, der n mal das erste Zeichen
'------- des angegebenen Textes enthaelt
PRINT STRING$(5, "Wiesel")      'Ergebnis: "WWWWW"
'
'---- LEN(String$) -> Liefert die Zeichenanzahl des angegebenen Strings
PRINT LEN("Wiesel")             'Ergebnis: 6
'
'---- ASC(String$) -> Liefert den ASCII-Code des ersten String-Zeichens
PRINT ASC("Wiesel")             'Ergebnis: 87 = ASCII-Code von "W"

