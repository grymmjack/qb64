'********************************************************************
' FENTITEL.BAS - Windows-Fenstertitel auslesen und setzen
' ============
' Dieses QuickBasic-Programm setzt einen beliebigen Text als
' Windows-Fenster-Titel ein.
' Da das Programm den Befehl CALL INTERRUPTX verwendet, ist es nur
' unter QuickBasic und nicht unter QBasic ablauffaehig. QuickBasic
' muss mit QB /L aufgerufen werden. Getestet unter Windows 95; unter
' Windows XP Professional funktionierte es nicht.
'
' (c) Andreas Meile ("Dreael"), 27.10.2004
'     qbasic-webmaster*andreas-meile.ch
'*********************************************************************
'
' $INCLUDE: 'qb.bi'
'
DIM dosIntEin AS RegTypeX, dosIntAus AS RegTypeX
DIM titPuf AS STRING * 300
'
' Auslesen (Get Application Title) gemäss
' http://msdn.microsoft.com/library/en-us/win9x/95func_3339.asp
'
dosIntEin.ax = &H168E
dosIntEin.es = VARSEG(titPuf)
dosIntEin.di = VARPTR(titPuf)
dosIntEin.cx = LEN(titPuf)
dosIntEin.dx = 2
CALL INTERRUPTX(&H2F, dosIntEin, dosIntAus)
IF dosIntAus.ax = 1 THEN
	PRINT "Fenstertitel (Application Title):"
	p% = INSTR(titPuf, CHR$(0))
	IF p% > 0 THEN
		PRINT LEFT$(titPuf, p% - 1)
	ELSE
		PRINT titPuf
	END IF
ELSE
	PRINT "Fehler beim Auslesen:"; dosIntAus.ax
END IF
'
' Auslesen (Get Virtual Machine Title) gemäss
' http://msdn.microsoft.com/library/en-us/win9x/95func_1r39.asp
'
dosIntEin.ax = &H168E
dosIntEin.es = VARSEG(titPuf)
dosIntEin.di = VARPTR(titPuf)
dosIntEin.cx = LEN(titPuf)
dosIntEin.dx = 3
CALL INTERRUPTX(&H2F, dosIntEin, dosIntAus)
IF dosIntAus.ax = 1 THEN
	PRINT "Fenstertitel (Virtual Machine Title):"
	p% = INSTR(titPuf, CHR$(0))
	IF p% > 0 THEN
		PRINT LEFT$(titPuf, p% - 1)
	ELSE
		PRINT titPuf
	END IF
ELSE
	PRINT "Fehler beim Auslesen:"; dosIntAus.ax
END IF
'
' Setzen (Set Application Title) gemäss
' http://msdn.microsoft.com/library/en-us/win9x/95func_0t0l.asp
'
LINE INPUT "Neuer Application Title:"; t$
titPuf = t$ + CHR$(0)
dosIntEin.ax = &H168E
dosIntEin.es = VARSEG(titPuf)
dosIntEin.di = VARPTR(titPuf)
dosIntEin.dx = 0
CALL INTERRUPTX(&H2F, dosIntEin, dosIntAus)
IF dosIntAus.ax = 1 THEN
	PRINT "Application Title erfolgreich gesetzt"
ELSE
	PRINT "Fehler beim Setzen:"; dosIntAus.ax
END IF
'
' Setzen (Set Virtual Machine Title) gemäss
' http://msdn.microsoft.com/library/en-us/win9x/95func_0ycl.asp
'
LINE INPUT "Neuer Virtual Machine Title:"; t$
titPuf = t$ + CHR$(0)
dosIntEin.ax = &H168E
dosIntEin.es = VARSEG(titPuf)
dosIntEin.di = VARPTR(titPuf)
dosIntEin.dx = 1
CALL INTERRUPTX(&H2F, dosIntEin, dosIntAus)
IF dosIntAus.ax = 1 THEN
	PRINT "Virtual Machine Title erfolgreich gesetzt"
ELSE
	PRINT "Fehler beim Setzen:"; dosIntAus.ax
END IF