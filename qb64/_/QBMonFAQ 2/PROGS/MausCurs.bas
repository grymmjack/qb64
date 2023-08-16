'***********************************************************************
' MAUSCURS.BAS = Mausroutine mit veraenderbarem Mauscursor
' ============
' Dieses Q(uick)Basic-Programm enthaelt eine Mausroutine, bei der die
' Form des Mauscursors veraenderbar ist.
' Oben links werden die Mauskoordinaten und die Nummer der betaetigten
' Maustasten angezeigt. Der Mauscursor ist ein im Programm selbsgemaltes
' lila Rechteck, welches sich leicht durch beliebige andere Grafikobjekte
' ersetzen laesst.
' Mit einer beliebigen Taste kann das Programm jederzeit abgebrochen
' werden. Es ist ablauffaehig unter QBasic und QuickBASIC. Weil der CALL
' ABSOLUTE Befehl verwendet wird, muss QuickBASIC mit der Option /L
' aufgerufen werden, also z.B. mit QB.EXE /L MAUSCURS.BAS .
'
' (c) Qbas_T , 17.11.2002
'*************************************************************************
'
DECLARE SUB mausform (softhard%, bmaske%, cmaske%)
DECLARE SUB maus (onoff%)
DECLARE SUB makebutton (x1%, x2%, y1%, y2%, col%, bordercol%, mode%)
DECLARE SUB getmaus (mode%)
DECLARE SUB mausinit ()
DECLARE SUB readdata ()
DECLARE FUNCTION Interr% (num%, ax%, bx%, cx%, dx%)
SCREEN 9
readdata
mausinit
DIM SHARED mausx%, mausy%, mausk%
DIM SHARED MS%(45)
10
getmaus (0)   'Hole die Daten MausX%, MausY%, MausK%
LOCATE 1, 1
PRINT mausx%; mausy%, mausk% 'KONSTANTE ANZEIGE VON X,Y UND KNOPFSTATUS DER MAUS
'
'------- selbstgemalten Mauscursor anzeigen -------------------------------
'Hier kann man seine eigenen Mauscursor hinzufuegen, mit Hilfe von
'Grafikbefehlen
'Beispiel: Einfaches Rechteck
LINE (20 + mausx%, 20 + mausy%)-(30 + mausx%, 30 + mausy%), 5, B  
'
FOR w = 1 TO 1000: NEXT 'Je nach Rechner Pause einbauen
IF INKEY$ <> "" THEN END 'Programm beenden mit beiebiger Taste
'
'------- sebstgemalten Mauscursor wieder loeschen --------------------------
'CURSOR ENTFERNEN BEIM WEGFAHREN, Das selbe wie oben, nur mit Color 0
LINE (20 + mausx%, 20 + mausy%)-(30 + mausx%, 30 + mausy%), 0, B
'Rechteck entfernen beim Wegfahren
' 
'HIER MAUSBEDINGUNGEN EINBAUEN FUER DIESES MENUE. AM BESTEN MIT IF-THEN-ELSE...
'---
GOTO 10
'------- Ende der Mauscursor-Bearbeitung -----------------------------------
'
'---HIER FOLGT DAS MASCHINENPROGRAMM, DAS FUER DIE MAUS NOTWENDIG IST.
MS.data:
DATA 55,8b,ec,56,57
DATA 8b,76,0c,8b,04
DATA 8b,76,0a,8b,1c
DATA 8b,76,08,8b,0c
DATA 8b,76,06,8b,14
DATA cd,21
DATA 8b,76,0c,89,04
DATA 8b,76,0a,89,1c
DATA 8b,76,08,89,0c
DATA 8b,76,06,89,14
DATA 5f,5e,5d
DATA ca,08,00
DATA #

'
'--- DAS SIND DIE SUB'S FUER DIE MAUSEINBINDUNG
SUB getmaus (mode%)
     r% = Interr%(&H33, 3, bx%, cx%, dx%)
     mausk% = bx%
     IF mode% THEN
          mausx% = cx% / 8 + 1
          mausy% = dx% / 8 + 1
     ELSE
          mausx% = cx%
          mausy% = dx%
     END IF
END SUB

'
FUNCTION Interr% (num%, ax%, bx%, cx%, dx%)
     IF MS%(0) = 0 THEN
          COLOR 12
          PRINT "FEHLER! MASCHINENPROGRAMM NICHT EINGELESEN!ABBRUCH!"
          COLOR 7
          END
     END IF
     DEF SEG = VARSEG(MS%(0))
     POKE VARPTR(MS%(0)) + 26, num%
     CALL absolute(ax%, bx%, cx%, dx%, VARPTR(MS%(0)))
     Interr% = ax%
END FUNCTION

'
SUB makebutton (x1%, x2%, y1%, y2%, col%, bordercol%, mode%)
     VIEW (x1%, y1%)-(x2%, y2%), col%, bordercol%
     getmaus mode%
END SUB

'
SUB maus (onoff%)
     IF onoff% = 0 THEN onoff% = 2 ELSE onoff% = 1
     r% = Interr%(&H33, onoff%, bx%, cx%, dx%)
END SUB

'
SUB mausform (softhard%, bmaske%, cmaske%)
     r% = Interr%(&H33, 10, softhard%, bmaske%, cmaske%)
END SUB

'
SUB mausinit
     r% = Interr%(&H33, 0, bx%, cx%, dx%)
END SUB

SUB MausSet (x%, y%)
     r% = Interr%(&H33, 4, bx%, x% * 8 - 8, y% * 8 - 8)
END SUB

'
SUB maustempo (tempo%)
     r% = Interr%(&H33, 15, bx%, speed%, speed% * 2)
END SUB

'
SUB MausXBereich (x1%, x2%)
     r% = Interr%(&H33, 7, 0, x1% * 8 - 8, x2% * 8 - 8)
END SUB

'
SUB mausybereich (y1%, y2%)
     r% = Interr%(&H33, 8, bx%, y1% * 8 - 8, y2% * 8 - 8)
END SUB

'
SUB readdata
     RESTORE MS.data
     DEF SEG = VARSEG(MS%(0))
     FOR i% = 0 TO 99
          READ byte$
          IF byte$ = "#" THEN EXIT FOR
          POKE VARPTR(MS%(0)) + i%, VAL("&H" + byte$)
     NEXT i%
END SUB

'
SUB wartebewegung (mode%)
     getmaus mode%
     x% = mausx%: y% = mausy%: k% = mausk%
     DO
          getmaus mode%
     LOOP UNTIL x% <> mausx% OR y% <> mausy% OR k% <> mausk%
END SUB

'
SUB warteknopflos
     WHILE mausk%
          getmaus 0
     WEND
END SUB

