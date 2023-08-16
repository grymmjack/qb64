'********************************************************
' SYSINFO.BAS - Anzeige der Systeminfos
' ===========
' Dieses Programm zeigt den konventionellen Speicher,
' Hardwareaustattung (Low), Festplatteninfos und die
' DOS-Version  an.
'
' Weil CALL INTERRUPT verwendet wird, ist das Programm
' nur unter QuickBasic, nicht unter QBasic lauffaehig.
' QB muss mit "QB.EXE /L SYSIN FO.BAS" aufgerufen
' werden, um die QLB einzubinden.
'
' Getestet unter Windows 95. Nicht funktionsfaehig
' unter Windows NT4.
'
' (c) von Andre Klein (A.K.), 27.5.2003
'********************************************************
DECLARE SUB SHOW.PARTITIONS ()
DECLARE SUB NUM2BS (num%, bs$)
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

DIM SHARED reg AS regtypex

CLS

'konventionellen Speicher rausfinden
CALL interruptx(&H12, reg, reg) 'BIOS-INT
COLOR 12: PRINT "Speicher"
COLOR 7, 0
PRINT "Konventioneller Speicher:"; reg.ax; "KB"
PRINT

COLOR 12: PRINT "Hardware-Ausstattung"
COLOR 7, 0

'Equipment-Check
CALL interruptx(&H11, reg, reg) 'BIOS-INT
DIM ax2 AS LONG
ax2 = CVL(MKI$(reg.ax) + CHR$(0) + CHR$(0))
PRINT "Disks installiert? :"; ((ax2 AND 1)) 'Bit 0
PRINT "80287 installiert(AT):"; ((ax2 AND 2) \ 2) 'Bit 1
PRINT "SpeicherbÑnke(in KB) :"; (((ax2 AND 12) \ 4) + 1) * 16 'Bits 2-3
PRINT "Video-Modus :"; ((ax2 AND 48) \ 16) 'Bits 4-5
PRINT "Diskettenlaufwerke :"; ((ax2 AND 192) \ 64) + 1 'Bits 6-7
PRINT "ser. Schnittstellen :"; ((ax2 AND 3584) \ 512) 'Bits 9-11
PRINT "Game-Adapter? :"; ((ax2 AND 4096) \ 4096) 'Bit 12
PRINT "par. Schnittstellen :"; ((ax2 AND 49152) \ 16384) 'Bits 14-15
PRINT

COLOR 12: PRINT "Festplatten-Infos"
COLOR 7, 0
'Festplatteninfos
SHOW.PARTITIONS

'DOS-Version ermitteln
reg.ax = &H3001
CALL interruptx(&H21, reg, reg)
major$ = LTRIM$(STR$((reg.ax AND 255)))
minor$ = LTRIM$(STR$((reg.ax \ 256)))
PRINT "DOS-Version: "; major$; "."; minor$

SUB NUM2BS (num%, bs$)
'Wandelt die Betriebssystem-Nummer in den BS-Text um
bs$ = ""
IF num% = 0 THEN bs$ = "keins"
IF num% = 1 THEN bs$ = "DOS 12-Bit FAT"
IF num% = 2 THEN bs$ = "XENIX root file system"
IF num% = 3 THEN bs$ = "XENIX /usr file system"
IF num% = 4 THEN bs$ = "DOS 16-Bit FAT (max. 32MB)"
IF num% = 5 THEN bs$ = "DOS 3.3+ extended partition"
IF num% = 6 THEN bs$ = "DOS 3.31+ 16-Bit FAT (>32MB)"
IF num% = 7 THEN bs$ = "OS/2 HPFS * UNIX * WIN NT NTFS"
IF num% = 8 THEN bs$ = "AIX boot partition, Splitdrive"
IF num% = 9 THEN bs$ = "AIX Data partition"
IF num% = 10 THEN bs$ = "OS/2 Boot Manager * OPUS"
IF bs$ = "" THEN bs$ = "Vorhanden aber unbekannt"

END SUB

SUB SHOW.PARTITIONS

'Master-Boot-Record der Festplatte lesen (MBR)
dat$ = STRING$(512, CHR$(0))
reg.ax = &H201
reg.dx = &H80 ' &H80 = 1. Harddisk, &H81 = 2. Harddisk...
reg.cx = &H1
reg.es = VARSEG(dat$)
reg.bx = SADD(dat$)
CALL interruptx(&H13, reg, reg)

'Informationen fÅr einzelne Partitionen rausfiltern
p1$ = MID$(dat$, 447, 16)
p2$ = MID$(dat$, 463, 16)
p3$ = MID$(dat$, 479, 16)
p4$ = MID$(dat$, 495, 16)

'Aktive Partition rausfinden
IF ASC(MID$(p1$, 1, 1)) = 128 THEN bo1$ = " JA" ELSE bo1$ = "NEIN"
IF ASC(MID$(p2$, 1, 1)) = 128 THEN bo2$ = " JA" ELSE bo2$ = "NEIN"
IF ASC(MID$(p3$, 1, 1)) = 128 THEN bo3$ = " JA" ELSE bo3$ = "NEIN"
IF ASC(MID$(p4$, 1, 1)) = 128 THEN bo4$ = " JA" ELSE bo4$ = "NEIN"

'Betriebssystemkennung in Text umwandeln
NUM2BS ASC(MID$(p1$, 5, 1)), bs$: bs1$ = bs$
NUM2BS ASC(MID$(p2$, 5, 1)), bs$: bs2$ = bs$
NUM2BS ASC(MID$(p3$, 5, 1)), bs$: bs3$ = bs$
NUM2BS ASC(MID$(p4$, 5, 1)), bs$: bs4$ = bs$

'Grî·e der Partitionen berechnen
pl1# = CVL(MID$(p1$, 13, 4)) * 512
pl2# = CVL(MID$(p2$, 13, 4)) * 512
pl3# = CVL(MID$(p3$, 13, 4)) * 512
pl4# = CVL(MID$(p4$, 13, 4)) * 512

'Informationen auf den Bildschirm schreiben
row% = 14
LOCATE 1 + row%, 1: PRINT "Partition Boot Betriebssystem Grî·e(Byte)"
LOCATE 2 + row%, 1: PRINT " 1"
LOCATE 3 + row%, 1: PRINT " 2"
LOCATE 4 + row%, 1: PRINT " 3"
LOCATE 5 + row%, 1: PRINT " 4"
LOCATE 2 + row%, 13: PRINT bo1$: LOCATE 2 + row%, 20: PRINT bs1$: LOCATE 2 + row%, 52: PRINT pl1#
LOCATE 3 + row%, 13: PRINT bo2$: LOCATE 3 + row%, 20: PRINT bs2$: LOCATE 3 + row%, 52: PRINT pl2#
LOCATE 4 + row%, 13: PRINT bo3$: LOCATE 4 + row%, 20: PRINT bs3$: LOCATE 4 + row%, 52: PRINT pl3#
LOCATE 5 + row%, 13: PRINT bo4$: LOCATE 5 + row%, 20: PRINT bs4$: LOCATE 5 + row%, 52: PRINT pl4#
PRINT

END SUB

