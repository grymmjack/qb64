'***************************************************************************
' ESCEREIG.BAS = Ereignisgesteuerter Programmabbruch mit der Esc-Taste
' ============
' Dieses Q(uick)Basic-Programm zeigt, wie man die Esc-Taste unabhaengig
' vom Hauptprogramm ereignisorientiert mit ON KEY abfragen kann. Die
' Ereignisroutine "Beenden" erzwingt ein Beenden des laufenden Programms
' (c) Thomas Antoni, 16.12.05  -  www.qbasic.de
'***************************************************************************
'
'-------------- Esc-Taste als Taste 15 einrichten --------------------------
KEY 15, CHR$(0) + CHR$(1) 'Esc (Scan-Code 1)  ohne Shift (0) als anwender-
                          'definierte Taste 15 setzen
ON KEY(15) GOSUB Beenden  'Sub "Beenden" bei Esc-Taste anspringen
KEY(15) ON                'Ereignisorientierte Bearbeitg.v.Key 15 aktivieren
'
'-------------- Hauptprogramm, aufsteigende Zahlen anzeigen ----------------
DO
i = i + 1
PRINT i
LOOP
'
'--------------- Ereignisroutine -------------------------------------------
Beenden: END

