'*****************************************************
' LOOP.BAS = 5 Möglichkeiten, die Zahlen von
' ========   0 bis 100 anzuzeigen
' (c) Thomas Antoni, 7.11.03 - 30.1.2004
'*****************************************************
'
'------- Zaehlschleife mit FOR...NEXT ---------------
'Bei jedem Durchlauf wird i% um 1 erhöht
FOR i% = 1 TO 100  'Zaehlschleife: 
  PRINT i%
NEXT
'
'------ Fussgesteuerte DO...LOOP WHILE Schleife -----
SLEEP
COLOR 13
i% = 0
DO
  i% = i% + 1
  PRINT i%
LOOP WHILE i% < 100 'Ruecksprung nach DO, wenn die
                    'Fortsetzbedingung erfuellt
'------ Fussgesteuerte DO...LOOP UNTIL Schleife ------
SLEEP
COLOR 14
i% = 0
DO
  i% = i% + 1
  PRINT i%
LOOP UNTIL i% = 100 'Ruecksprung nach DO solange bis
                    'die Abbruchbedingung erfuellt ist
'------ Kopfgesteuerte DO UNTIL...LOOP Schleife ------
SLEEP
COLOR 8
i% = 0
DO UNTIL i% = 100   'Schleife durchlaufen bis die
  i% = i% + 1       'Abbruchbedingung erfuellt ist
  PRINT i%
LOOP
'
'------ Kopfgesteuerte DO WHILE...LOOP Schleife ------
SLEEP
COLOR 10
i% = 0
DO WHILE i% < 100  'Schleife solange durchlaufen bis 
  i% = i% + 1      'die Abbruchbedingung erfuellt ist
  PRINT i%
LOOP

