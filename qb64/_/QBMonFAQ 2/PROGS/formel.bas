'*****************************************************************
' FORMEL.BAS = Formel-Loeser in QBasic
' ==========
' ACHTUNG: Dieses Programm muss im Verzeichnis "C:\TEMP\" stehen.
'          Bei einem anderen Verzeichnis muss man die Pfadvorgabe
'          in der 2. Befehlszeile anpassen!
'
' FORMEL.BAS ist quasi ein wissenschaftlicher Taschenrechner.
' Es nimmt vom Anwender einen beliebigen Formelausdruck entgegen,
' berechnet dessen Ergebnis und zeigt es an.
'
' Der Formelausdruck muss der QBasic-Syntax entsprechen, mit einer
' Ausnahme: Die Eingabe von Winkeln kann auch in Grad statt im
' Bogenmass erfolgen. Dazu muss der Anwender hinter dem Winkel ein
' Gradzeichen "ø" eingeben.
'
' Das Programm funktioniert nur als BAS-Datei und nicht als
' kompilierte EXE-Datei. Programmtechnisch ist das ganze so
' realisiert, dass das Programm den Formelstring in eine zweite
' externe BAS-Datei "Test.bas" schreibt. Ansschliessend wird
' die Kontrolle per CHAIN an Test.bas uebergeben. Test.bas
' berechnet die Formel, zeigt sie an und springt wiederum per
' CHAIN zurueck zum Beginn des Hauptprogramms.
'
' Der vom Windows-ANSI-Code abweichende DOS-ASCII-Zeichencode fuer
' das Grad-Symbol ist zu beachten.(ANSI: "°", ASCII: "ø")
'
' (c) Olaf Deters u. Thomas Antoni, 26.1.2004 - 27.1.2004
'*****************************************************************
DECLARE FUNCTION Ersetze$ (F$)
COLOR 0, 7   'Schwarze Schrift auf hellgrauem Grund
WIDTH 80, 50 'VGA-Aufloesung mit 80 Spalten und 50 Zeilen
CLS
'
'---- Bedienungshinweise anzeigen -------------------------
'
PRINT
PRINT " ------======== F O R M E L - L O E S E R =======--------"
PRINT
PRINT " ________________Unterstuetzte Funktionen________________"
PRINT " a + b ..... Addition"
PRINT " a - b ..... Subtraktion"
PRINT " a * b ..... Multiplikation"
PRINT " a / b ..... Division"
PRINT " sqr(a) .... Quadratwurzel von a"
PRINT " a^b ....... Exponentialfunktion a hoch b"
PRINT " a^(1/b) ... allgemeine Wurzelfunktion b-te Wurzel aus a"
PRINT " log(a) .... Natuerlicher Logarithmus von a (zur Basis e)"
PRINT " sin(a) .... Sinus (a im Bogenmass)"
PRINT " cos(x) .... Cosinus (a im Bogenmass)"
PRINT " tan(a) .... Tangens (a im Bogenmass)"
PRINT " atn(x) .... Arcus Tangens (Winkel im Bogenmass)"
PRINT " aø ........ Winkel im Gradmass"
PRINT " hex$(a) ... Dezimal/Hexadezimal-Wandlung fuer a"
PRINT " val("; CHR$(34); "&ha"; CHR$(34); ")";
PRINT "  Hexadezimal/Dezimalwandlung fuer a"
PRINT " MOD ....... Modulo-Division (liefert d.ganzzahligen Rest)"
PRINT " ========================================================="
PRINT "        Beispielformel : (log(sin(30ø))^2 + 1.4"
PRINT " ========================================================="
'
'---- Formel eingeben -------------------------------------
PRINT
PRINT
PRINT "Gib die gewuenschte Formel ein: "
PRINT
INPUT "y =  ", F$
F1$ = Ersetze$(F$) 'Winkelangaben mit Gradzeichen ins Bogenmass
                   'umrechnen
'
'---- Formel in Datei Test.bas schreiben ------------------
'Es wird der folgende Quellcode geschrieben:
'   PRINT "y = "; Fa$
'   PRINT
'   PRINT "[belieb.Taste]=Wiederholen";
'   PRINT ".....[Esc]=Beenden"
'   t$ = INPUT$(1)
'   IF t$ = CHR$(27) THEN END
'   CHAIN "c:\temp\formel.bas"
'Ausrufezeichen muessen als CHR$(34) geschrieben werden
'
OPEN "c:\temp\Test.bas" FOR OUTPUT AS #1
PRINT #1, "PRINT "; CHR$(34); "y = "; CHR$(34); ";"; F1$
PRINT #1, "PRINT"
PRINT #1, "PRINT "; CHR$(34); "[belieb.Taste]=Wiederholen"; CHR$(34); ";"
PRINT #1, "PRINT "; CHR$(34); ".....[Esc]=Beenden"; CHR$(34)
PRINT #1, "t$=input$(1)"   ' Warten auf beliebige Taste
PRINT #1, "IF t$ = CHR$(27) THEN END"
PRINT #1, "CHAIN "; CHR$(34); "c:\temp\formel.bas"; CHR$(34)
  'Ruecksprung zum Hauptmodul
CLOSE #1
'
'----- Test.bas aufrufen ----------------------------------
CHAIN "c:\temp\test.bas"

'
FUNCTION Ersetze$ (F$)
'----- Umrechnung Grad- in Bogenmass ----------------------
'----- ("Zahlø") -> ("Zahl * 2 * Pi / 360")
'Es wird im Formelstring nach einem Gradzeichen "ø" gesucht.
'Steht davor eine Zahl, so wird das Gradzeichen durch
'den Teilstring "* 3.1415962# / 180" ersetzt.
FOR X = 1 TO LEN(F$)
  IF MID$(F$, X, 1) = "ø" THEN
    Y = X
    DO UNTIL MID$(F$, Y, 1) = "(" OR MID$(F$, Y, 1) = ")": Y = Y - 1
    LOOP
    L$ = LEFT$(F$, Y)
    SELECT CASE VAL(MID$(F$, Y + 1, X - Y - 1))
      CASE IS <> 0
        M$ = STR$(VAL(MID$(F$, Y + 1, X - Y - 1)) * 3.1415962# / 180)
      CASE IS = 0
        M$ = " * 3.1415962# / 180"
    END SELECT
    R$ = RIGHT$(F$, LEN(F$) - X)
    F$ = L$ + M$ + R$
    F$ = Ersetze(F$)
  END IF
NEXT X
Ersetze$ = F$
END FUNCTION

