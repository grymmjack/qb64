'****************************************************************************
' DRIVE.BAS = Funktionen zum Handling von Verzeichnissen und Laufwerken
' =========
' ACHTUNG: Nur unter QuickBASIC, nicht unter QBasic ablauffaehig, weil
'          der Befehl CALL INTERRUPT verwendet wird !!!
'
' (c) TT-Soft - www.East-Power-Soft.de
'*****************************************************************************
DECLARE SUB Directory (Art%)
DECLARE FUNCTION ActivePath$ ()
DECLARE FUNCTION ActiveDrive$ ()
DECLARE FUNCTION FreeDiscSpace& (Drive$)
DECLARE FUNCTION DriveList$ ()
DECLARE SUB DriveArt ()
'
TYPE RegType
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
     ds    AS INTEGER
     es    AS INTEGER
END TYPE
DECLARE SUB INTERRUPT (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)
DIM SHARED Reg AS RegType
'
CLS
COLOR 7: PRINT "verfuegbare Laufwerke: ";
COLOR 14: PRINT DriveList$
PRINT
COLOR 14: DriveArt
PRINT
COLOR 7: PRINT "aktuelles Laufwerk ist: ";
COLOR 14: PRINT ActiveDrive$; ": "; : Directory 2
COLOR 7: PRINT "darauf sind:";
COLOR 14: PRINT USING "############,"; FreeDiscSpace&(ActiveDrive$);
PRINT " Bytes frei"
COLOR 7: PRINT "Der aktuelle Pfad ist: ";
COLOR 14: PRINT ActiveDrive$; ":\"; ActivePath$
COLOR 7: PRINT "Dateien im Pfad:"
COLOR 14
Directory 0

'
FUNCTION ActiveDrive$ STATIC
DEFINT A-Z
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion gibt das aktuell eingestellte Laufwerk zurueck.           |
'|                                                                          |
'+--------------------------------------------------------------------------+
'
   Reg.ax = &H1900
   INTERRUPT &H21, Reg, Reg
   ActiveDrive$ = CHR$(65 + (Reg.ax AND 255))
END FUNCTION

DEFSNG A-Z
'
FUNCTION ActivePath$ STATIC
DEFINT A-Z
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion gibt den aktuell eingestellten Pfad zurück.               |
'|                                                                          |
'+--------------------------------------------------------------------------+
'
   DIM Buffer AS STRING * 255
'
   Reg.ax = &H4700
   Reg.dx = 0
   Reg.ds = VARSEG(Buffer)
   Reg.si = VARPTR(Buffer)
   INTERRUPT &H21, Reg, Reg
   ActivePath$ = LEFT$(Buffer, INSTR(Buffer, CHR$(0)))
'
END FUNCTION

DEFSNG A-Z
'
SUB Directory (Art%) STATIC
DEFINT A-Z
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion gibt, wenn verfuegbar, alle Dateien (Show = 0), alle      |
'| Ordner (Show = 1) oder die Datentraegerbezeichnung (Show = 2) des        |
'| aktuellen Laufwerks bzw. des aktuellen Pfades aus.                       |
'|                                                                          |
'+--------------------------------------------------------------------------+
'
   SELECT CASE Art
      CASE 0: Sh = 7: Mask$ = "*.*"
      CASE 1: Sh = 23: Mask$ = "*"
      CASE 2: Sh = 8: Mask$ = "*.*"
   END SELECT
'
   DIM DTA AS STRING * 64
   DIM FCB AS STRING * 44
'
   Reg.ax = &H2F00                   '---> Adresse der DTA ermitteln
   INTERRUPT &H21, Reg, Reg
'
   DTASeg% = Reg.es                  '---> Neue Adresse fuer die DTA setzen
   DTAOff% = Reg.bx
   Reg.ds = VARSEG(DTA)
   Reg.dx = VARPTR(DTA)
   Reg.ax = &H1A00
   INTERRUPT &H21, Reg, Reg
'
   FCB = CHR$(255) + SPACE$(5) + CHR$(Sh) + CHR$(0) + Mask$
'
   Reg.ds = VARSEG(FCB)              '---> ersten Directory Eintrag holen
   Reg.dx = VARPTR(FCB)
   Reg.ax = &H1100
   INTERRUPT &H21, Reg, Reg
'
   IF Reg.ax MOD 256 = 0 THEN
      DO: Dir$ = MID$(DTA, 9, 11)
         SELECT CASE Art
            CASE 0: Dir$ = RTRIM$(LEFT$(Dir$, 8)) + "." + RTRIM$(RIGHT$(Dir$, 3))
            CASE 1, 2: Dir$ = RTRIM$(Dir$)
         END SELECT
         PRINT Dir$
         Reg.ds = VARSEG(FCB)        '---> die weiteren Einträge holen
         Reg.dx = VARPTR(FCB)
         Reg.ax = &H1200
         INTERRUPT &H21, Reg, Reg
      LOOP UNTIL Reg.ax MOD 256 = &HFF
   END IF
'
   Reg.ds = DTASeg%                  '---> alte DTA wieder herstellen
   Reg.dx = DTAOff%
   Reg.ax = &H1A00
   INTERRUPT &H21, Reg, Reg
'
END SUB

'
SUB DriveArt
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion ermittelt die Art der Laufwerke.                          |
'|                                                                          |
'+--------------------------------------------------------------------------+
 '
FOR N = 1 TO 26
   Reg.ax = &H4408
   Reg.bx = N
   INTERRUPT &H21, Reg, Reg
   C = Reg.ax
   IF (Reg.flags AND 1) = 1 AND C = 1 THEN PRINT CHR$(64 + N); ": Netzwerk oder CD-ROM": EXIT FOR
   SELECT CASE C
      CASE 0: PRINT CHR$(64 + N); ": (Floppy)    "
      CASE 1: PRINT CHR$(64 + N); ": (Festplatte)"
      CASE 15: PRINT CHR$(64 + N); ": Fehler      "
      CASE ELSE: PRINT CHR$(64 + N); "unbekannt     "
   END SELECT
NEXT
'
END SUB

DEFSNG A-Z
'
FUNCTION DriveList$ STATIC
DEFINT A-Z
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion sucht alle angeschlossenen Laufwerke, wobei erst nach     |
'| verfügbaren Floppy's gesucht wird. Danach wird nach HDD's u.a. Lauf-     |
'| werken gesucht.                                                          |
'|                                                                          |
'+--------------------------------------------------------------------------+
'
   '---> suche nach FDD's
   DEF SEG = 0
   FD% = PEEK(&H410) \ 64
   DEF SEG
'
   IF FD% = 0 THEN D$ = "A" ELSE D$ = "AB"
 ' 
   '---> suche nach HDD's
   FOR I% = 3 TO 26
      Reg.ax = &H4409
      Reg.bx = I%
      INTERRUPT &H21, Reg, Reg
      IF (Reg.flags AND 1) THEN EXIT FOR
      D$ = D$ + CHR$(64 + Reg.bx)
   NEXT
'
   DriveList$ = D$
' 
END FUNCTION

DEFSNG A-Z
'
FUNCTION FreeDiscSpace& (Drive$) STATIC
DEFINT A-Z
'+--------------------------------------------------------------------------+
'|                                                                          |
'| Diese Funktion ermittelt den freien Speicher auf dem angegebenen Laufwerk|
'|                                                                          |
'+--------------------------------------------------------------------------+
'
   IF Drive$ = "" THEN EXIT FUNCTION
   Reg.ax = &H3600
   Reg.dx = ASC(UCASE$(Drive$)) - 64
   INTERRUPT &H21, Reg, Reg
'
   IF Reg.ax = -1 THEN
      FreeDiscSpace& = 0
      EXIT FUNCTION
   END IF
'
   T1 = Reg.ax: T2 = Reg.bx: T3 = Reg.cx
'
   IF T1 < 0 THEN T1& = 65535 + T1 ELSE T1& = T1
   IF T2 < 0 THEN T2& = 65535 + T2 ELSE T2& = T2
   IF T3 < 0 THEN T3& = 65535 + T3 ELSE T3& = T3
'
   FreeDiscSpace& = T1& * T2& * T3&
'
END FUNCTION

