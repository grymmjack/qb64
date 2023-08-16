'**************************************************
' MAUS2.BAS = Einfache Mausroutine fuer QuickBASIC
' =========
' Dieses Programm realisert eine Mausunter-
' stuetzung in QuickBASIC. Unter QBasic ist es
' nicht ablauffaehig. Es werden der Maustasten-
' Status und die Mauskoordinaten engezeigt.
' Durch Druecken einer beliebigen Taste wird das
' Programm beendet.
'
' Weil das Programm den INTERRUPT-Befehl
' verwendet, muss QuickBASIC muss mit der
' Option /L gestartet werden, z.B. mit
'     QB.EXE /L MAUS2.BAS
'
' (c) Herbert Hackelsberger, 7.10.2001
'***************************************************
'
REM $INCLUDE: 'qb.bi'
DIM indat AS REGTYPE, ausdat AS REGTYPE
SCREEN 12
indat.ax = &H0
CALL INTERRUPT(&H33, indat, ausdat)
indat.ax = &H1
CALL INTERRUPT(&H33, indat, ausdat)
indat.ax = &H3
DO
  CALL INTERRUPT(&H33, indat, ausdat)
  LOCATE 1, 1
  PRINT ausdat.bx, ausdat.cx, ausdat.dx
  'Tastenstatus und Mauskoordinaten anzeigen
LOOP UNTIL INKEY$ <> ""
ausdat.bx = 1

