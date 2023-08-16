'*****************************************************
' TERMINAL.BAS = Chat ueber Nullmodemkabel
' ============
' Dies ist das offizielle Terminalprogramm von
' Microsoft, das QuickBASIC 4.5 beiliegt.
'*****************************************************
DEFINT A-Z
DECLARE SUB Filter (InZeichKett$)
COLOR 7, 1                 ' Setze Bildschirmfarbe.
CLS
Ende$ = CHR$(0) + CHR$(48) ' Von INKEY$ angegebener
			   ' Wert, wenn Alt+b betaetigt
			   ' wird.
' Gib Anfrage in unterster Bildschirmzeile aus und
' schalte den Cursor ein:
LOCATE 24, 1, 1
PRINT STRING$(80, "_");
LOCATE 25, 1
PRINT TAB(30); "Druecke Alt+b zum Beenden";
VIEW PRINT 1 TO 23    ' Ausgaben zwischen den Zeilen 1
		      ' & 23.
' Eroeffne Kommunikation (1200 Baud, keine Paritaet,
' 8-Bit fuer Daten, 1 Stopbit, 256-Byte
' Eingabepuffer):
OPEN "COM1:1200,N,8,1" FOR RANDOM AS #1 LEN = 256
DO            ' Hauptschleife der Datenuebertragung.
   TastEingab$ = INKEY$  ' ueberpruefe Tastatur.
   IF TastEingab$ = Ende$ THEN   ' Verlasse die
				 ' Schleife, wenn der
				 ' Benutzer Alt+q
      EXIT DO                    ' betaetigt hat.
   ELSEIF TastEingab$ <> "" THEN ' Andernfalls, wenn
				 ' der Benutzer eine
				 ' Taste betaetigt hat,
				 ' sende das einge-
      PRINT #1, TastEingab$;     ' tippte Zeichen zum
   END IF                        ' Modem.
   ' ueberpruefe das Modem. Wenn Zeichen warten (EOF(1)
   ' ist wahr), hole diese und gib sie auf den
   ' Bildschirm aus:
   IF NOT EOF(1) THEN
     'LOC(1) gibt die Anzahl der wartenden Zeichen an:
      ModemEingab$ = INPUT$(LOC(1), #1)
      Filter ModemEingab$ ' Filtere ZeilenvorschÅbe
			  ' und Rueckschritte aus,
      PRINT ModemEingab$; ' schreibe dann.
   END IF
LOOP
CLOSE            ' Ende der Datenuebertragung.
CLS
END
'
' ===================== FILTER =======================
'     Filtert Zeichen einer eingegebenen Zeichenkette
' ====================================================
'
SUB Filter (InZeichKett$) STATIC
 ' Suche nach Rueckschrittzeichen (CHR$(8)) und
 ' kodiere diese in CHR$(29) um (die Cursor-Taste
 ' nach links):
DO
  RueckSchr = INSTR(InZeichKett$, CHR$(8))
  IF RueckSchr THEN
    MID$(InZeichKett$, RueckSchr) = CHR$(29)
  END IF
LOOP WHILE RueckSchr
   ' Suche nach Zeilenvorschubzeichen (CHR$(10)) und
   ' entferne alle gefundenen:
DO
  ZeilVor = INSTR(InZeichKett$, CHR$(10))
  IF ZeilVor THEN
    InZeichKett$ = LEFT$(InZeichKett$, ZeilVor - 1) + MID$(InZeichKett$, ZeilVor + 1)
  END IF
LOOP WHILE ZeilVor
END SUB

