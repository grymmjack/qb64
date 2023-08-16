'*******************************************************************
' ZAL2WORT.BAS = Wandelt eine max.4-stellige Zahl in Wörter um
' ============
' Dieses QBasic-Programm wandelt eine Zahl bis 9999 korrekt
' in Textdarstellung um. Aus 4215 wird z.B. "viertausendzweihundert-
' fuenfzehn.
' (c) Thomas Antoni, 18.2.2005
'       nach einem Programmvorschlag von H.J. Sacht
'*******************************************************************
CLS
DIM W$(2, 9)
'
'****** Zahlwoerter einlesen aus DATA-Zeilen in Feld W
FOR K = 0 TO 2
  FOR J = 0 TO 9
    READ W$(K, J)
  NEXT
NEXT
'
'****** Zahl abfragen und in String A$ wandeln
DO
PRINT "Gib eine Zahl ein (1...9999): "
INPUT "", Zahl%
Z$ = ""
A$ = MID$(STR$(Zahl%), 2)
'
'****** A$ fals noetig mit vorlaufenden Nullen auffuellen
FOR K = LEN(A$) TO 4
  A$ = "0" + A$
NEXT
'
'****** Tausender-  und Hunderter-Stellen bearbeiten
J = VAL(MID$(A$, 2, 1))
IF J > 0 THEN Z$ = Z$ + W$(0, J) + "tausend"
J = VAL(MID$(A$, 3, 1))
IF J > 0 THEN Z$ = Z$ + W$(0, J) + "hundert"
K$ = RIGHT$(A$, 1)
K = VAL(K$)
IF K$ > "0" THEN K$ = W$(0, K) ELSE K$ = ""
J = VAL(MID$(A$, 4, 1))
'
'****** Zehner- und Einser-Stellen bearbeiten
IF J = 0 THEN                'vorletzte Stelle=0 -> Zahl=0...9
  Z$ = Z$ + K$
ELSEIF J = 1 THEN            'vorletzte Stelle=1 -> Zahl=10...19
  Z$ = Z$ + W$(1, K)
ELSEIF Z$ + K$ = "" THEN     'Zahl=20, 30,... oder 90
  Z$ = W$(2, J)              ' -> "und" weglassen
ELSE
  Z$ = Z$ + K$ + "und" + W$(2, J)
END IF
'
'****** Zahl in Worten anzeigen
PRINT "*** "; Z$; " ***"
'
'****** Wiederholung bei Tastenbetaetigung ungleich Esc-Taste
PRINT
PRINT "Wiederholen...[beliebige Taste]   Beenden...[Esc]"
DO: Taste$ = INKEY$: LOOP WHILE Taste$ = ""
LOOP UNTIL Taste$ = CHR$(27)
END
'
'******Zahlwoerter als Konstante definieren
DATA null,ein,zwei,drei,vier,fuenf,sechs
DATA sieben,acht,neun,zehn,elf,zwoelf
DATA dreizehn,vierzehn,fuenfzehn,sechzehn
DATA siebzehn,achtzehn,neunzehn,null
DATA zehn,zwanzig,dreissig,vierzig,fuenfzig
DATA sechzig,siebzig,achtzig,neunzig

