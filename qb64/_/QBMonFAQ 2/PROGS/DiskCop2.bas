'**************************************************
' DISKCOP2.BAS = Kopieren einer Diskette ohne SHEll
' ============   mit BIOS-Interrupt
'
' Dieses Programm benutzt den BIOS-Interrupt &H13
' Das heisst, dass es nicht aufs Betriebssytem
' angewiesen ist. Aber wegen QB braucht es
' natuerlich DOS/WIN.
'
' *** ACHTUNG
' Weil CALL INTERRUPT verwendet wird, ist das
' Programm nur unter QuickBASIC, nicht unter
' QBasic lauffaehig. QuickBASIC muss mit
' "QB /L" aufgefufen werden, um die QLB
' einzubinden.
'
' *** Funktionsweise:
' 1. Diskettenparameter laden
' 2. Diskette 1:1 als Datei speichern
' 3. neue Diskette mit der Datei beschreiben
' 4. FERTIG
'
' *** Anmerkungen:
' - Man sollte NIE in einem funktionierendem
'   Programm etwas veraendern! :-)
' - Getetstet in der DOS-Box von Windows NT4.
'   Für andere Windows-Funktionen kann keine
'   Funktionsgarantie gegeben werden.
'
' (c) Andre Klein ("A.K."), 2003
'**************************************************
DECLARE SUB PUT.SECTOR (sector%, dat$)
DECLARE SUB LOAD.DISK ()
DECLARE SUB GET.SECTOR (sector%, dat$)
TYPE regtypex
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
DIM SHARED reg AS regtypex
DIM SHARED sectorlen%, heads%, sectorsperhead%, sectorspercylinder%
CLS
LOAD.DISK
INPUT "Wie soll die Temporaer-Datei heissen?"; dcfile$
PRINT "Los geht's!"
'
'Diskette 1:1 auf Festplatte als Datei speichern (Temporaer)
OPEN dcfile$ FOR BINARY AS #1
FOR sector% = 1 TO sectorlen%
CALL GET.SECTOR(sector%, dat$)
PUT #1, , dat$
NEXT sector%
CLOSE #1
'
BEEP
PRINT
PRINT "Diskette gespeichert!"
PRINT "Legen sie nun eine neue Diskette ein!"
INPUT "Wollen Sie die Diskette beschreiben(ja/nein)?"; janein$
IF janein$ = "ja" THEN
'Datei 1:1 auf Diskette speichern
LOAD.DISK
OPEN dcfile$ FOR BINARY AS #1
dat$ = STRING$(512, CHR$(0))
FOR sector% = 1 TO sectorlen%
GET #1, , dat$
CALL PUT.SECTOR(sector%, dat$)
NEXT sector%
CLOSE #1
KILL dcfile$
BEEP
PRINT
PRINT "Diskette fertig kopiert"
END IF
'
SUB GET.SECTOR (sector%, dat$)
sector2% = sector%
cylinder% = (sector2% - 1) \ sectorspercylinder%
sector2% = sector2% - cylinder% * sectorspercylinder%
head% = (sector2% - 1) \ sectorsperhead%
sector2% = sector2% - (head% * sectorsperhead%)
dat$ = STRING$(512, CHR$(0))
reg.ax = &H201
reg.dx = 0 + head% * 256
reg.cx = sector2% + (cylinder% * 64)
reg.es = VARSEG(dat$)
reg.bx = SADD(dat$)
CALL interruptx(&H13, reg, reg)
END SUB
'
SUB LOAD.DISK
' CHS 0,0,1
dat$ = STRING$(512, CHR$(0))
reg.ax = &H201
reg.dx = 0
reg.cx = 1
reg.es = VARSEG(dat$)
reg.bx = SADD(dat$)
CALL interruptx(&H13, reg, reg)
sectorlen% = CVI(MID$(dat$, 20, 2))
sectorsperhead% = CVI(MID$(dat$, 25, 2))
heads% = CVI(MID$(dat$, 27, 2))
sectorspercylinder% = heads% * sectorsperhead%
'
END SUB
'
SUB PUT.SECTOR (sector%, dat$)
sector2% = sector%
cylinder% = (sector2% - 1) \ sectorspercylinder%
sector2% = sector2% - cylinder% * sectorspercylinder%
head% = (sector2% - 1) \ sectorsperhead%
sector2% = sector2% - (head% * sectorsperhead%)
reg.ax = &H301
reg.dx = 0 + head% * 256
reg.cx = sector2% + (cylinder% * 64)
reg.es = VARSEG(dat$)
reg.bx = SADD(dat$)
CALL interruptx(&H13, reg, reg)
END SUB

