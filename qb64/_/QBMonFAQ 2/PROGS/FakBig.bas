'***************************************************************************
' FakBig.BAS -  QBasic-Programm zum Berechnen von sehr grossen Fakultaeten
' ==========================================================================
'  Meines Wissens ist dies das schnellste (reine) Qbasic-Programm
'  zum berechnen von Fakultaeten.
'  Es basiert auf der Zerlegung der immens langen Fakultaet, die ja rekursiv
'  immer weiter gerechnet werden muss. Die Zahl wird so oft wie noetig in
'  ein doppelt genaue Flieákommazahlen zerlegt, die 16 Zeichen aufnehmen
'  koenn. Mit diesen Zahlen kann der Computer noch rechnen, deshalb gibt es
'  theoretisch keine Grenze.
'  Praktisch begrenzt nur der Speicher (oder die Zeit) die Groeáe der
'  Fakultaet.
'
'  (c) Tomtitom - Thomas.Sperling*gmx.net, Version 2.0, 24.10.2003
'***************************************************************************
'
DECLARE SUB multip (faktor%)
DECLARE SUB zahlindatei (z$)
DIM SHARED anz, maxzahl  AS DOUBLE, zx AS DOUBLE, ll, null%, anf%, dimmax
'
'dimmax bestimmt wieviele "Doubles" a' 16 Zeichen benutzt werden koennen
'd.h. mit dimmax = 1 kann man hoechsten eine Zahl mit 16 Zeichen anzeigen!
'Bei grossen Zahlen muss die Kapazitaet von Double etwas gesenkt werden,
'd.h. es passen nur noch 15, oder sogar nur noch 10 Zeichen hinein
'bei dimmax = 2000 kann man immerhin noch 6509! mit knapp 22000 Zeichen
'berechnen. Wenn man QB "normal" aufruft, kann man dimmax nur bis etwa 8190
'einstellen, wer mehr will, muss QB mit /ah aufrufen, da kann man dimmax auf
'ber 32000 stellen, was bis ueber 80000! reicht und das wuerde bei meinen
'1 GHz bestimmt mehre Tage dauern
'
dimmax = 8000
DIM SHARED zahl(dimmax) AS DOUBLE
'
CLS
INPUT "Fuer welche Zahl soll die Fakultaet berechnet werden n= "; fak%
'
ll = 17 - LEN(STR$(fak% - 1))
'Berechnen, wieviel Ziffern in das Double passen
maxzahl = VAL(STRING$(ll, "9"))
'
'Anfangswerte einstellen
zx = maxzahl + 1
anf% = 1
null% = 1
z$ = "1"
anz = 1
ON ERROR GOTO fehler
'
'Um die Zahl zu zerlegen, muss sie erstmal in
zahl(LEN(z$) \ ll + 1) = VAL(LEFT$(z$, LEN(z$) MOD ll))
'
'string2zahl z$
t = TIMER 'Zeit merken zum Ermitteln der Rechenzeit
'
'Die Hauptschleife zum Berechnen der Fakultaet
FOR faktor% = 2 TO fak%
multip faktor%
IF TIMER - t > 240 THEN faktor% = faktor% + 1: EXIT FOR
'nach 4 min den Rechenvorgang abbrechen
NEXT
zeit = TIMER - t
zahlindatei z$
'
'Hier wird die Zahl aus der Datei gelesen und angezeigt
PRINT "n! = ";
aa$ = " "    'Zahl aus Datei laden
OPEN "fak.txt" FOR BINARY AS #1
DO
  GET #1, , aa$
LOOP UNTIL aa$ <> "0"
PRINT aa$;            'Wer die ganze Zahl nicht angezeigt haben will,
gpz$ = aa$ + "."
DO UNTIL EOF(1)
  GET #1, , aa$
  PRINT aa$;            'muss nur diese beiden Zeilen loeschen
  IF qqq < 15 THEN gpz$ = gpz$ + aa$
  qqq = qqq + 1
LOOP
CLOSE
KILL "fak.txt" 'Datei loeschen
'
PRINT "Zeichen:"; qqq; " Zeit:"; zeit; faktor% - 1
gpzahl# = VAL(gpz$)                  'wer mit der Zahl weiterrechnen will,
expzahl = qqq - 1                    'kann das mit diesen beiden Zahlen
PRINT "n! als Gleitpunktzahl:"; gpzahl#; " E+"; expzahl
'
SLEEP
END
'
fehler: 
IF ERR = 9 THEN
  PRINT "!!! FEHLER !!! Du musst dimmax erhoehen!"
ELSE
  PRINT "Aehm, irgendwie ist ein Fehler aufgetreten."
  PRINT "Wenn es schwerwiegend ist, benachrichtige mich bitte!"
END IF
END

SUB multip (faktor%)
LOCATE 2, 2: PRINT faktor%
LOCATE 3, 2: PRINT "Ziffern (ca.):"; ll * anf%
'                             ^ die genaue Berechnung w„re zu kompliziert
'Rechnung
'Das System ist so aehnlich, wie wenn man schriftlich multipliziert
'Bei šbertragen, die auf eine Double-Zahl nicht mehr passen, werden
'auf die naechste geschrieben
'
FOR i% = anf% TO null% STEP -1
zahl(i%) = zahl(i%) * faktor%
IF zahl(i%) > maxzahl THEN
xz = INT(zahl(i%) / zx)
zahl(i% + 1) = zahl(i% + 1) + xz
zahl(i%) = zahl(i%) - xz * zx
IF i% = anf% THEN anf% = anf% + 1
END IF
NEXT
'
'Die Nullen werden abgeschnitten und extra gespeichert, das spart etwas Zeit
IF zahl(null%) = 0 THEN null% = null% + 1
'
END SUB

SUB zahlindatei (z$)
'Hier werden die einzelnen Zahlenpakete zusammengefuegt und in eine
'Datei geschrieben, so kann man die Zahl besser handhaben und man kann sie
'in kompletter Groesse sehen ;-)
'Es wuerde auch ausreichen, wenn man nur die beiden Zahlen mit den ersten 32
'Stellen nimmt und sich den Exponenten ausrechnet.
'
z$ = ""
FOR j = dimmax TO 1 STEP -1
  IF zahl(j) > 0 THEN EXIT FOR
NEXT
'
OPEN "fak.txt" FOR OUTPUT AS #1
FOR i = j TO 1 STEP -1
  p$ = RIGHT$(STR$(zahl(i)), LEN(STR$(zahl(i))) - 1)
  a$ = STRING$(ll, "0")
  MID$(a$, ll + 1 - LEN(p$), LEN(p$)) = p$
  PRINT #1, a$;
NEXT
CLOSE
END SUB

