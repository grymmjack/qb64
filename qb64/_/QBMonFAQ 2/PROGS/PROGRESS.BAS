'**********************************************
' PROGRESS.BAS = Fortschrittsbalken anzeigen
' ============
' Dieses Q(uick)Basic-Programm zeigt einen
' Forschrittsbalken (Progress Bar) von 0 bis
' 100% an, der nach jeweils einer Pause um 2%
' verlaengert wird.
'
' (c) ICC, 14.3.2005 - icc*gmx.de
'***********************************************
'
Pause! = .1 'Pausenzeit ind sec,
            ' wird alle 2 % eingelegt
COLOR 7
CLS
LOCATE 23, 2
PRINT STRING$(50, 176)
'
FOR a% = 2 TO 51
 LOCATE 23, a%
 PRINT CHR$(219)
 Zeit = TIMER
 DO: LOOP UNTIL TIMER > Zeit + Pause 'Pause
NEXT a%
SLEEP
END

