'***************************************************
' ON-PLAY.BAS = Plays long music songs with ON PLAY
' ===========   Spielt lange Musikstuecke mit
'                ON PLAY
'
' Deutsche Beschreibung
' ----------------------
' Dieses Q(uick)Basic-Programm demonstriert, wie
' man laengere Musikstuecke mit ON PLAY abspielt.
' Immer wenn der 'Musikvorrat' im Notenpuffer zur
' Neige geht, wird ereignisgesteuert die Routine
' playMusic angesprungen. Dabei laeuft das
' Hauptprogramm ohne Unterbrechung weiter
'
' English Description
' ---------------------
' This Q(uick)Basic program demoinstrates how to
' play long music songs with ON PLAY. The event-
' driven routine playMusic is started whenever
' the "note buffer" runs empty. The main program
' runs unterruptedly.
'***********************************************
'
ON PLAY(1) GOSUB playMusic
part = 0
PLAY ON
GOSUB playMusic 'start it
CLS
'
DO
   LOCATE 1, 1
   COLOR INT(RND * 16)
   PRINT "Hello"
   k$ = INKEY$
   IF k$ = "a" THEN  'play again
      PLAY ON
      GOSUB playMusic
   END IF
LOOP WHILE k$ <> CHR$(27) 'esc
SLEEP
END
'
playMusic:
part = part + 1
SELECT CASE part
  CASE 1: PLAY "mb o2 edcdeeeddd"
  CASE 2: PLAY "mb effedcdeee"
  CASE 3: PLAY "mb cddedc"
  CASE 4: part = 0: PLAY OFF 'stop calling this routine
END SELECT
RETURN

