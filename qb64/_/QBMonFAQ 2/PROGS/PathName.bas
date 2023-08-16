'***************************************************************
' PATHNAME.BAS = Retrieves path and filename of the actually
' ===========     executed compiled QB Program
'               Ermittelt Pfad und Dateinamen des gerade ausge-
'                 gefuehrten mit QB compilierten EXE-Programms
'
' Deutsche Beschreibung
' -----------------------
' (von Thomas Antoni, 14.3.2006)
' Dieses QuickBASIC-Programm ermittelt den Pfadnamen und den
' Dateinamen des gerade ausgefuehrten EXE-Programms. Wenn Du
' diese Programm z.B. zu der ausfuerhrbaren Datei PATHNAME.XE
' kompilierst und im Laufwerk C: im Verzeichnis "Test" ablaufen
' laesst, dann wird "C:\Test\PATHNAME.EXE" zurueckgemeldet.
' Im Interpeter-Modus meldet das Programm den Pfadnamen der
' QuickBASIC-Entwicklungsumgebung zurueck, also z.B.
' "C:\BASIC\QB.EXE". Das Programm ist unter QuickBASIC 4.5 und
' 7.1 ablauffaehig, nicht jedoch unter QBasic, weil der
' Befehl CALL Interrupt verwendet wird. Aus demselben Grund
' muss QuickBASIC mit der Option "/L" gestartet werden, also
' z.B. mit "QB.EXE /L PATHNAME.BAS". Bei QB 7.1 muss der Name
' der .BI-Datei angepasst werden; siehe unten im Listing.
'
' English Description
' -------------------
' This program will read the environment to find the TRUE file
' name of the actually executed EXE-file - not just the name,
' but the PATH in which it was executed from. You can use it
' for QuickBASIC programs compiled with QB 4.5 and 7.1.
' When intepreted, the program will deliver' the path and filename
' of the QB IDE .
'
'(c) by Paul Sullivan, Nov 23, 1991
'****************************************************************
'
'
REM *************************************************************
REM **                                                         **
REM **  This program will read the TRUE program name from the  **
REM **  Environment.  If you are executing a program called    **
REM **  HELLO.EXE, and only typed HELLO at the command line,   **
REM **  It would return the ENTIRE PATH of where HELLO.EXE is  **
REM **  located.  If HELLO.EXE is in C:\DOS\BASIC\QB, the      **
REM **  line returned from this program would be               **
REM **  c:\dos\basic\qb\HELLO.EXE instead of just HELLO        **
REM **                                                         **
REM **  This program is basically a reprint from a very early  **
REM **  Cobb Inside Microsoft Basic Journal, but can be used   **
REM **  freely.  It is in the Public Domain.  No credit or     **
REM **  other compensation is necessary or expected.           **
REM **                                                         **
REM **  This program should work with BOTH QuickBasic 4.5 and  **
REM **  the Basic Professional Development System 7.xx         **
REM **                                                         **
REM *************************************************************

REM ****  Below is the main program module  ************

DECLARE FUNCTION ProgramName$ ()
DEFINT A-Z

CONST FALSE = 0
CONST TRUE = -1
'
'PDS users should change the next line to include the QBX.BI file
'$INCLUDE: 'QB.BI'
'
CLS
PRINT "Program name = "; ProgramName$
SLEEP
END
'
REM ****  Below is a FUNCTION that should be parsed by the QB ***
REM ****  or QBX Environments.  *********************************

'=================== Function ProgramName$ ======================
'== INPUT: None                                                ==
'== RETURNS: Name of currently executing program               ==
'================================================================
'
FUNCTION ProgramName$
DIM Regs AS RegType
'
'Get PSP address
'
   Regs.ax = &H6200
   CALL Interrupt(&H21, Regs, Regs)
   PSPSegment = Regs.bx
'
'Find environment address from PSP
'
   DEF SEG = PSPSegment
   EnvSegment = PEEK(&H2D) * 256 + PEEK(&H2C)
'
'Find the filename
'
   DEF SEG = EnvSegment
   EOT = FALSE                 'Set end of environment table flag
   Offset = 0

   WHILE NOT EOT
      Byte = PEEK(Offset)       'Get table character
      IF Byte = 0 THEN          'End of environment string?
'        PRINT                   'Uncomment to print environment
	 Offset = Offset + 1
	 Byte = PEEK(Offset)
	 IF Byte = 0 THEN        'End of environment?
	    Offset = Offset + 3   'Yes - Skip over nulls & tbl info
	    C% = PEEK(Offset)
	    WHILE C% <> 0                   'Assemble filename string
	       FileN$ = FileN$ + CHR$(C%)    '  from individual
	       Offset = Offset + 1           '  characters
	       C% = PEEK(Offset)
	    WEND
	    EOT = TRUE              'Set flag to exit while/wend loop
	 END IF
      ELSE                        'No-Read more environment string
'        PRINT CHR$(Byte);         'Uncomment to print environment
	 Offset = Offset + 1
      END IF
   WEND
   ProgramName$ = FileN$
   DEF SEG
END FUNCTION

