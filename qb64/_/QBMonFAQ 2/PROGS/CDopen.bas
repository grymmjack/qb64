'*****************************************************
' CDOPEN.BAS = Closes and opens the CD-ROM tray
' ==========   Oeffnet und schliesst die Schublade
'                des CD-ROM-Laufwerks
'
' *** Deutsche Beschreibung
' (von Thomas Antoni)
' Dieses QuickBASIC-Programm öffnet und schließt 
' die Schublade des CD-Laufwerks. Unter meinem Windows 
' 95A funktoniert es problemlos.
' 
' Weil das Programm den INTERRUPTX-Befehl verwendet,
' ist es nur unter QuickBASIC, nicht jedoch unter
' QBasic ablauffähig. Aus demselben Grund muss
' QuickBASIC mit der Option /L" gestartet werden,
'  also z.B. mit dem Kommando
' 
'     QB.EXE /L cdopen.bas
' 
' *** English Description
' This QuickBASICprogram opens and closes the
' CD-ROM tray (for QB4.5 or higher)
'
'*****************************************************
'
DECLARE FUNCTION lowbyte% (word%)
DECLARE FUNCTION highbyte% (word%)
DECLARE SUB door (switch%)
'
CONST openIt = 0
CONST closeIt = 5
'
TYPE RegTypeX
   ax AS INTEGER
   bx AS INTEGER
   cx AS INTEGER
   dx AS INTEGER
   bp AS INTEGER
   si AS INTEGER
   di AS INTEGER
   flags AS INTEGER
   ds AS INTEGER
   es AS INTEGER
END TYPE
'
DIM SHARED inregsx AS RegTypeX
DIM SHARED outregsx AS RegTypeX
DIM SHARED drive AS INTEGER
DIM SHARED control AS STRING * 1
DIM SHARED request(1 TO 20) AS STRING * 1
'
request(1) = CHR$(26)
request(2) = CHR$(0)
request(3) = CHR$(12)
request(19) = CHR$(lowbyte(1))
request(20) = CHR$(highbyte(1))
'
inregsx.ax = &H1500
inregsx.bx = &H0
inregsx.cx = &H0
CALL INTERRUPTX(&H2F, inregsx, outregsx)
drive = outregsx.cx
'
CLS
door openIt
LOCATE 1, 1: PRINT "Press any key to close it again."
SLEEP
door closeIt
END
'
SUB door (switch%)
   control = CHR$(switch%)
   request(15) = CHR$(lowbyte(VARPTR(control)))
   request(16) = CHR$(highbyte(VARPTR(control)))
   request(17) = CHR$(lowbyte(VARSEG(control)))
   request(18) = CHR$(highbyte(VARSEG(control)))

   inregsx.ax = &H1510
   inregsx.cx = drive
   inregsx.es = VARSEG(request(1))
   inregsx.bx = VARPTR(request(1))
   CALL INTERRUPTX(&H2F, inregsx, outregsx)
END SUB
'
FUNCTION highbyte% (word%)
   IF word% >= 0 THEN
      highbyte% = word% \ 256
   ELSE
      highbyte% = (65536 + word%) \ 256
   END IF
END FUNCTION
'
FUNCTION lowbyte% (word%)
   IF word% >= 0 THEN
      lowbyte% = word% MOD 256
   ELSE
      lowbyte% = (65536 + word%) MOD 256
   END IF
END FUNCTION
