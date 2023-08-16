'************************************************************
' EXEPATH.BAS = Pfad und Namen der eigenen Programmdatei
' ===========   ermitteln

' Dies Programm enthaelt die beiden Funktionen PATHNAME$
' und EXENAME$. PATHNAME$ ermittelt den Pfad des eigenen
' EXE-Programms und EXENAME$ den Dateinamen des eigenen
' EXE-Programms. PATHNAME ruft selber wiederum EXENAME$
' auf.
' Ablauffaehig unter QBasic und QuickBasic. QuickBasic
' 4.5 muss mit "QB /L" aufgerufen weden, da das Programm
' den CALL ABSOLUTE-Befehl verwendet.
'
' (c) Pawel (www.pkworld.de) 1.2002
'************************************************************
DECLARE FUNCTION EXENAME$ ()
DECLARE FUNCTION PATHNAME$ ()
'
CLS
'
PRINT EXENAME
PRINT PATHNAME

'
'------------ EXENAME$-----------------------------------------------
FUNCTION EXENAME$
DIM MCODE(1 TO 4) AS LONG, OS AS INTEGER, BX AS INTEGER, DUMMY AS LONG
DEF SEG = VARSEG(MCODE(1))
OS = VARPTR(MCODE(1))
POKE OS, &H55 'PUSH BP
POKE OS + 1, &H89: POKE OS + 2, &HE5 'MOV BP,SP
POKE OS + 3, &HB4: POKE OS + 4, &H62 'MOV AH,62
POKE OS + 5, &HCD: POKE OS + 6, &H21 'INT 21
POKE OS + 7, &H8B: POKE OS + 8, &H7E: POKE OS + 9, 6'MOV DI,[BP+6]
POKE OS + 10, &H89: POKE OS + 11, &H1D 'MOV [DI],BX
POKE OS + 12, &H5D 'POP BP
POKE OS + 13, &HCA: POKE OS + 14, 2: POKE OS + 15, 0'RETF 2
CALL ABSOLUTE(BX, OS)
DEF SEG = BX
ENVSM = PEEK(&H2C) + 256 * PEEK(&H2D)
ENVOS = 0
DEF SEG = ENVSM
DUMMY = 0&
WHILE DUMMY <> 65536
DUMMY = PEEK(ENVOS) + 256& * (PEEK(ENVOS + 1) + 256& * (PEEK(ENVOS + 2) + 256& * PEEK(ENVOS + 3)))
ENVOS = ENVOS + 1
WEND
ENVOS = ENVOS + 3
N$ = ""
A = 1
WHILE A <> 0
A = PEEK(ENVOS)
IF A <> 0 THEN N$ = N$ + CHR$(A)
ENVOS = ENVOS + 1
WEND
DEF SEG
EXENAME$ = N$
END FUNCTION

'------------ PATHNAME$ --------------------------------------------
'
FUNCTION PATHNAME$
FOR idx = LEN(EXENAME$) TO 1 STEP -1
  IF MID$(EXENAME$, idx, 1) = "\" THEN EXIT FOR
NEXT idx
PATHNAME$ = LEFT$(EXENAME$, idx - 1)
END FUNCTION

