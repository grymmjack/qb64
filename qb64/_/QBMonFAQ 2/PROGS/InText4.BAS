'**************************************************************
' INTEXT4.BAS = Komfortable Eingaberoutine mit Editierfunktion
' ===========
' Q(uick)Basic-Programm fuer eine komfortable Texteingabe mit
' Laengenbegrenzung und Editierfunktion. Die enthaltene
' Function EINGABE ersetzt die INPUT-Funktion von QBasic und
' ist flexibel bequem anzuwenden.
'
' (c) 2.7.2005 nach einer Programmidee von Juergen Hueckstaedt
'***************************************************************
'
DECLARE FUNCTION eingabe$ (ze%, sp%, lg%, alt$)
'
'****** Hauptprogramm (Testrahmen) *****************************
DEFINT A-Z
CLS
'y$ = ""        'Variante wenn kein Vorbesetzungstext erwuenscht
y$ = "Vorbesetzung"
zeile = 10: spalte = 20
laenge = 26
w$ = eingabe$(zeile, spalte, laenge, y$)
'
LOCATE 23, 1
COLOR 7, 0'Farbe hellgrau auf schwarz wieder herstellen
PRINT "Du hast Folgendes eingegeben:"
PRINT "  "; w$
END
'

FUNCTION eingabe$ (ze, sp, lg, alt$)
'*************************************************************
' EINGABE = Funktion fuer eine komfortable Texteingabe in eine
' -------   feste Maske mit Editierfunktion
'
' Uebergabeparameter:
'   - ze    = Bildschirmzeilen-Nr. des Eingabefeldes
'   - sp    = Spalten-Nr. fuer Eingabebeginn
'   - lg    = hoechstzulaessige Eingabe-Zeichenzahl
'   - alt$  = Textstring, der als Vorbesetzung im Eingabefeld
'             erscheint
'
' Unterstuetzte Editiertasten
'  - Cursor links  (CHR&(0) + CHR$(75))
'  - Cursor rechts (CHR&(0) + CHR$(77))
'  - Backspace     (CHR$(8))
'  - Entf          (CHR(0) + CHR$(83))
'  - Einf          (CHR(0) + CHR$(82))
'*************************************************************
'
spt = sp: l = 1:
ins = 1
COLOR 0, 7          'schwarz auf hellgrau
f$ = " "            'Maskenhintergrund = Leerzeichen
'f$ = "_"
LOCATE ze, sp: PRINT STRING$(lg, f$)
LOCATE ze, sp: PRINT alt$;
LOCATE ze, sp, 1
'
'****** Tastenbetaetigung abwarten und auswerten *************
'****** bis Eingabe betaetigt
DO
  a$ = ""
  DO WHILE a$ = ""
    a$ = INKEY$
  LOOP
  a = ASC(LEFT$(a$, 1))
  IF a = 13 THEN EXIT DO 'Eing.taste -> Eingabe abschliessen
  IF a = 0 THEN          'Spezialtaste da 1.Zeichen = CHR$(0)
    b = ASC(RIGHT$(a$, 1))
    GOSUB spezial
  ELSEIF a = 8 THEN      'Backspace-Taste
    GOSUB spezial
  ELSEIF a >= &H20 THEN  'normales anzeigbares Zeichen...
    GOSUB normal         '... CHR$(32...255)
  END IF
LOOP
'
'****** Eingabe abschliessen wenn Eingabetaste betaetigt *****
i = sp + lg - 1
s$ = ""
z1 = ASC(f$)
'
DO WHILE i >= sp
  z = SCREEN(ze, i)
  IF z <> z1 THEN s$ = CHR$(z) + s$
    i = i - 1
LOOP
'
eingabe$ = s$
EXIT FUNCTION
'
'****** "Normale" anzeigbare Zeichen bearbeiten **************
normal:
'
'------ Insert-Modus aus
IF ins = 0 THEN
  LOCATE ze, spt, 1
  PRINT a$;
  spt = spt + 1
  l = l + 1
'
'------ Insert-Modus ein
ELSEIF ins = 1 AND l < lg THEN 'Eingabelaenge auf lg begrenzen
  i = sp + lg - 2
  DO WHILE i >= spt
    z = SCREEN(ze, i)
    LOCATE ze, i + 1
    PRINT CHR$(z);
    i = i - 1
  LOOP
  LOCATE ze, spt
  PRINT a$;
  spt = spt + 1
  l = l + 1
  LOCATE ze, spt
END IF
RETURN
'
'****** Spezialtasten bearbeiten (Editiertasten) ***************
spezial:
'
'------ Entf-Taste -> Zeichen unter Cursor loeschen
IF b = 83 THEN
flag = 0
i = spt + 1
DO UNTIL i = sp + lg
  IF i > sp + lg - 1 THEN flag = 1: EXIT DO
  z = SCREEN(ze, i)
  LOCATE ze, i - 1
  PRINT CHR$(z);
  i = i + 1
LOOP
IF flag = 0 THEN LOCATE ze, sp + lg - 1: PRINT f$;
LOCATE ze, spt
'
'------ Backspace-Taste -> Zeichen links vom Cursor loeschen
ELSEIF a = 8 AND i > 1 THEN
  IF spt > sp THEN
    spt = spt - 1
    l = l - 1
    i = spt + 1
  END IF
  DO UNTIL i = sp + lg
    z = SCREEN(ze, i)
    LOCATE ze, i - 1
    PRINT CHR$(z);
    i = i + 1
  LOOP
  LOCATE ze, sp + lg - 1: PRINT f$;
  LOCATE ze, spt
'
'------ Cursor-links-Taste
ELSEIF b = 75 AND l > 1 THEN
  l = l - 1
  spt = spt - 1
  LOCATE ze, spt
'
'------ Cursor-rechts-Taste
ELSEIF b = 77 AND l < lg THEN
  l = l + 1
  spt = spt + 1
  LOCATE ze, spt
'
'------ Insert-Taste -> Insertmodus Ein/Aus
ELSEIF b = 82 THEN
  ins = ins XOR 1
END IF
RETURN
'
END FUNCTION

