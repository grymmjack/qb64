'**********************************************
' PROGRES2.BAS = Fortschrittsbalken anzeigen
' ============
' Dieses Q(uick)Basic-Programm zeigt einen
' Forschrittsbalken (Progress Bar) im
' VGA Grafikbildschirm Screen 13 an
'
' (c) jb, 14.3.2005
'***********************************************
'
'Pause=.05
SCREEN 13
x = 10
y = 190
'
FOR x = x TO x + 300 STEP 2
  LINE (x, y)-(x, y + 10), 14
  'Zeit = TIMER
  'DO: LOOP UNTIL TIMER > Zeit + Pause 'Pause
  WAIT &H3DA, 8
  WAIT &H3DA, 8, 8
NEXT
'
SLEEP
END


