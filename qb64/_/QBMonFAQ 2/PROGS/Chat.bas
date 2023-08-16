'*************************************************************************
' CHAT.BAS = Kleines Chatprogramm fuer eine Verbindung mit Nullmodemkabel
' ========
' Dieses Chatprogramm habe ich in ein paar Stunden schnell
' zusammengezimmert, ist also noch ausbaufähig. Wenn ihr wollt, könnte
' ich noch etwas aehnliches fuers Netzwerk machen, allerdings mit
' Datenaustausch über eine Datei, da TCP/IP unter QB nur mit speziellen
' Treibern funktioniert und das dann für die meisten uninteressant ist.
'
' Gruesse aus Suedtirol
'    Ch@rly
'
' (c) Karl Pircher ("Ch@rly"; karl.pircher*gmx.net ) 15.5.2003 ]
'
'************************************************************************
DECLARE FUNCTION Recieve$ (kanal%)
DECLARE FUNCTION Send% (Rec AS STRING, kanal%)
DECLARE FUNCTION OpenCom% (Comport%, kanal%)
DECLARE SUB PrintStatus (Comport%, PortOpen%, RStatus AS ANY)
DECLARE SUB PrintSend (Rec AS STRING, char AS STRING, Rect AS ANY)
DECLARE SUB PrintRecieve (char AS STRING, Rect AS ANY)
DECLARE SUB Form (left%, Top%, HSend%, HRecieve%, HStatus%)
'
'------------------------------------------------Deklarationen
TYPE Rect
   x1 AS INTEGER
   y1 AS INTEGER
   x2 AS INTEGER
   y2 AS INTEGER
END TYPE
'
'------------------------------------------------Fehlerbehandlung
ON ERROR GOTO ErrorHandler
'
'------------------------------------------------Dimensionierungen
DEFINT A-Z               ' Default alle Variablen als Integer definieren
DIM InRec AS STRING      ' Einlesestring Tastatur
DIM InChar AS STRING     ' Letzte Zeichen von Tastatur
DIM tmp AS STRING        ' tempor„re Variable
DIM RSend AS Rect        ' Koordinaten Empfangsfenster
DIM RRecieve AS Rect     ' Koordinaten SendeFenster
DIM RStatus AS Rect      ' Koordinaten Statusfenster
DIM SHARED fehler        ' letzter aufgetretener Fehler
'
'------------------------------------------------Zuweisungen
Comport = 1              ' Nummer der Com
Top = 1                  ' Oberer Rand
left = 5                 ' linker Rand
HSend = 9                ' Anzahl Zeilen Sendefenster
HRecieve = 9             ' Anzahl Zeilen Empfangsfenster
HStatus = 1              ' Anzahl Zeilen Statusfenster
RSend.x1 = left + 2
RSend.x2 = 80 - (left + 1) * 2 - 1
RSend.y1 = Top + HRecieve + 3
RSend.y2 = HSend - 1
RRecieve.x1 = left + 2
RRecieve.x2 = 80 - (left + 1) * 2 - 1
RRecieve.y1 = Top + 2
RRecieve.y2 = HRecieve - 1
RStatus.x1 = left + 2
RStatus.x2 = 80 - (left + 1) * 2 - 1
RStatus.y1 = Top + HSend + HRecieve + 4
RStatus.y2 = HRecieve - 1
'
'------------------------------------------------Bildschirm
CLS
Form left, Top, HSend, HRecieve, HStatus       ' Anzeige Bildschirmmaske
PrintSend "", "", RSend                        ' Kursor positionieren
'
'------------------------------------------------Port ”ffnen
kanal = FREEFILE
PortOpen = OpenCom(Comport, kanal)
PrintStatus Comport, PortOpen, RStatus
PrintSend "", "", RSend                        ' Kursor positionieren
'
'------------------------------------------------Main
DO
'
'------------------------------------------------Eingabe
   InChar = INKEY$
' 
   IF LEN(InChar) = 2 THEN                     ' Funktionstasten
      SELECT CASE InChar
      CASE CHR$(0) + CHR$(59)                  ' F1
         Comport = 1                           ' Com1 festlegen
         PortOpen = OpenCom(Comport, kanal)    ' Com1 ”ffen
         PrintStatus Comport, PortOpen, RStatus  ' Status aktualisieren
         PrintSend "", "", RSend               ' Kursor positionieren
      CASE CHR$(0) + CHR$(60)                  ' F2
         Comport = 2                           ' Com2 festlegen
         PortOpen = OpenCom(Comport, kanal)    ' Com2 ”ffnen
         PrintStatus Comport, PortOpen, RStatus' Status aktualisieren
         PrintSend "", "", RSend               ' Kursor positionieren
      END SELECT
'
   ELSE                                        ' Andere Tasten
      IF InChar <> "" THEN
         SELECT CASE InChar
         CASE CHR$(8)                          ' Backspace
            IF LEN(InRec) > 0 THEN
               PrintSend InRec, InChar, RSend  ' Zeichen l”schen
            ELSE
               BEEP
            END IF
         CASE CHR$(13)                         ' Enter
            s = Send(InRec, kanal)             ' Zeile senden
            InRec = ""                         ' Eingabe l”schen
            PrintSend InRec, InChar, RSend     ' Neue Zeile
         CASE CHR$(27)   ' Esc
            EXIT DO
         CASE ELSE
            InRec = InRec + InChar             ' Eingabe aktualisieren
            PrintSend InRec, InChar, RSend     ' und anzeigen
         END SELECT
      END IF
   END IF
'
'------------------------------------------------Einlesen
   IF PortOpen = -1 THEN                       ' Wenn Port ge”ffnet
      tmp = Recieve(kanal)                     ' Daten von Com holen
      IF tmp <> "" THEN                        ' Wenn Daten eingetroffen
         PrintRecieve tmp, RRecieve            ' dann anzeigen
         PrintSend "", "", RSend               ' Kursor wieder ins Sendfendter
      END IF
   END IF

LOOP

CLOSE kanal                                    ' Kanal schliessen
SYSTEM                                         ' und beednen
'
'------------------------------------------------Fehlerbehandlung
ErrorHandler:
   fehler = ERR
   RESUME NEXT

'
SUB Form (left, Top, HSend, HRecieve, HStatus)
'-----------------------------------------------
' SUB Form - Anzeige Bildschirmmaske
' =========
' Parameter:
' Left     = Linker Rand in Spalten
' Top      = Rand oben in Zeilen
' HSend    = Hoehe Fenster Senden in Zeilen
' HRecieve = Hoehe Fenster Empfangen in Zeilen
' HStatus  = H”he fenster Status in Zeilen
'-----------------------------------------------
FOR i = 0 TO Top - 1
   PRINT
NEXT
'
PRINT SPACE$(left);
PRINT CHR$(218);                   ' Ú
PRINT STRING$(78 - 2 * left, 196); ' Ä
PRINT CHR$(191)                    ' ¿
FOR i = 1 TO HRecieve
   PRINT SPACE$(left);
   PRINT CHR$(179);                ' ³
   PRINT SPACE$(78 - 2 * left);
   PRINT CHR$(179)                 ' ³
NEXT
PRINT SPACE$(left);
PRINT CHR$(195);                   ' Ã
PRINT STRING$(78 - 2 * left, 196); ' Ä
PRINT CHR$(180)                    ' ´
FOR i = 1 TO HSend
   PRINT SPACE$(left);
   PRINT CHR$(179);                ' ³
   PRINT SPACE$(78 - 2 * left);
   PRINT CHR$(179)                 ' ³
NEXT
'
PRINT SPACE$(left);
PRINT CHR$(195);                   ' Ã
PRINT STRING$(78 - 2 * left, 196); ' Ä
PRINT CHR$(180)                    ' ´
FOR i = 1 TO HStatus
   PRINT SPACE$(left);
   PRINT CHR$(179);                ' ³
   PRINT SPACE$(78 - 2 * left);
   PRINT CHR$(179)                 ' ³
NEXT
'
PRINT SPACE$(left);
PRINT CHR$(192);                   ' À
PRINT STRING$(78 - 2 * left, 196); ' Ä
PRINT CHR$(217);                   ' Ù
'
END SUB

'
FUNCTION OpenCom (Comport, kanal)
'---------------------------------------------
' FUNCTION OpenCom - Com Port oeffnen
' ================
'---------------------------------------------
fehler = 0
'
CLOSE #kanal
OPEN "com" + LTRIM$(STR$(Comport)) + ": 9600,n,8,1,cs0,ds0,cd0" FOR RANDOM AS #kanal
'
IF fehler = 0 THEN
   OpenCom = -1
ELSE
   OpenCom = 0
END IF
'
END FUNCTION

'
SUB PrintRecieve (printstring AS STRING, Rect AS Rect)
'--------------------------------------------------------
' SUB PrintRecieve - Anzeige e.Strings im Empfangsfenster
' ================
'--------------------------------------------------------
'
STATIC XPos
STATIC YPos
DIM char AS STRING
'
LOCATE Rect.y1 + YPos, Rect.x1 + XPos, 0
'
FOR k = 1 TO LEN(printstring)
   char = MID$(printstring, k, 1)
   SELECT CASE char
   CASE CHR$(13)
      IF YPos < Rect.y2 THEN
         YPos = YPos + 1
      ELSE
         VIEW PRINT Rect.y1 TO Rect.y1 + Rect.y2
         FOR i = 1 TO Rect.y2
            PRINT
         NEXT
         PRINT
         PRINT SPACE$(Rect.x1 - 2);
         PRINT CHR$(179);
         PRINT SPACE$(Rect.x2 + 1);
         PRINT CHR$(179);
         VIEW PRINT
      END IF
      XPos = 0
      LOCATE Rect.y1 + YPos, Rect.x1 + XPos
   CASE ELSE
      PRINT char;
      IF XPos < Rect.x2 THEN
         XPos = XPos + 1
      ELSEIF XPos = Rect.x2 THEN
         IF YPos < Rect.y2 THEN
            YPos = YPos + 1
         ELSE
            VIEW PRINT Rect.y1 TO Rect.y1 + Rect.y2
            FOR i = 1 TO Rect.y2
               PRINT
            NEXT
            PRINT
            PRINT SPACE$(Rect.x1 - 2);
            PRINT CHR$(179);
            PRINT SPACE$(Rect.x2 + 1);
            PRINT CHR$(179);
            VIEW PRINT
         END IF
         XPos = 0
      END IF
   END SELECT
NEXT
'
END SUB

'
SUB PrintSend (Rec AS STRING, char AS STRING, Rect AS Rect)
'--------------------------------------------------------
' SUB PrintSend - Anzeige eines Zeichens im Sendfenster
' =============
'--------------------------------------------------------
'
STATIC XPos
STATIC YPos
'
LOCATE Rect.y1 + YPos, Rect.x1 + XPos, 1
IF char <> "" THEN
   SELECT CASE char
   CASE CHR$(13)
      IF YPos < Rect.y2 THEN
         YPos = YPos + 1
      ELSE
         VIEW PRINT Rect.y1 TO Rect.y1 + Rect.y2
         FOR i = 1 TO Rect.y2
            PRINT
         NEXT
         PRINT
         PRINT SPACE$(Rect.x1 - 2);
         PRINT CHR$(179);
         PRINT SPACE$(Rect.x2 + 1);
         PRINT CHR$(179);
         VIEW PRINT
      END IF
      XPos = 0
      LOCATE Rect.y1 + YPos, Rect.x1 + XPos
   CASE CHR$(8)
      IF XPos > 0 THEN
         XPos = XPos - 1
         LOCATE Rect.y1 + YPos, Rect.x1 + XPos
         PRINT " ";
         LOCATE Rect.y1 + YPos, Rect.x1 + XPos
         Rec = LEFT$(Rec, LEN(Rec) - 1)
      ELSE
         BEEP
      END IF
   CASE ELSE
      PRINT char;
      IF XPos < Rect.x2 THEN
         XPos = XPos + 1
      ELSEIF XPos = Rect.x2 THEN
         IF YPos < Rect.y2 THEN
            YPos = YPos + 1
         ELSE
            VIEW PRINT Rect.y1 TO Rect.y1 + Rect.y2
            FOR i = 1 TO Rect.y2
               PRINT
            NEXT
            PRINT
            PRINT SPACE$(Rect.x1 - 2);
            PRINT CHR$(179);
            PRINT SPACE$(Rect.x2 + 1);
            PRINT CHR$(179);
            VIEW PRINT
         END IF
         XPos = 0
         LOCATE Rect.y1 + YPos, Rect.x1 + XPos, 1
      END IF
   END SELECT
END IF
'
END SUB

'
SUB PrintStatus (Comport, PortOpen, RStatus AS Rect)
'---------------------------------------------------------
' SUB PrintStatus - Anzeige Status
' ===============
'---------------------------------------------------------
'
DIM Status AS STRING
'
LOCATE RStatus.y1, RStatus.x1
Status = "F1 = Com1:  F2 = Com2:  ESC = Ende   "
IF PortOpen = -1 THEN
   Status = Status + "Parameter: Com" + LTRIM$(STR$(Comport)) + ": 9600,n,8,1 "
ELSE
   Status = Status + "Fehler beim ™ffnen der Com" + LTRIM$(STR$(Comport)) + ":"
END IF
Status = LEFT$(Status + SPACE$(80), RStatus.x2 + 1)
PRINT Status
'
END SUB

'
FUNCTION Recieve$ (kanal)
'---------------------------------------------
' FUNCTION Recieve$ - Zeichen empfangen
' =================
'---------------------------------------------
'
IF NOT EOF(kanal) THEN
   Recieve$ = INPUT$(LOC(kanal), kanal)
END IF
'
END FUNCTION

'
FUNCTION Send (Rec AS STRING, kanal)
'-----------------------------------------------
' FUNCTION Send - Senden der eingegeben Daten.
' =============
'-----------------------------------------------
'
PRINT #kanal, Rec
'
END FUNCTION

