'************************************************************
' PCNAME.BAS = Findet den Namen des eigenen Computers heraus
' ==========
' Dieses QuickBASIC-Programm ermittelt den Namen des eigenen
' Computers und zeigt ihn an.
' Das Pogramm ist nur unter QuickBASIC, nicht unter QBasic
' ablauffaehig, weil es den INTERRUPTX-Befehl verwendet.
' Aus demselben Grunde muss QuickBASIC mit der Option "/L"
' aufgerufen werden, z.B. ueber "QB.EXE /L pcname.bas".
'
' (c) Karl Pircher ("Ch*rly"), 5.11.2002
'*************************************************************
'
DECLARE FUNCTION GetPCName$ ()
DEFINT A-Z
'
TYPE RegTypeX
    AX    AS INTEGER
    bx    AS INTEGER
    cx    AS INTEGER
    DX    AS INTEGER
    BP    AS INTEGER
    SI    AS INTEGER
    DI    AS INTEGER
    flags AS INTEGER
    DS    AS INTEGER
    ES    AS INTEGER
END TYPE
'
CLS
PRINT "Dein Computername ist "; GetPCName$
'

FUNCTION GetPCName$
'
' Name PC holen
'
' Version 1.0  02/05/2002  Autor : Pircher Karl
'
'
'----------------------------------------Dimensionierungen
DIM Regs AS RegTypeX
DIM a(7) AS INTEGER
'
'----------------------------------------Main
Regs.AX = &H5E00
Regs.DX = VARPTR(a(0))
Regs.DS = VARSEG(a(0))
'
CALL INTERRUPTX(&H21, Regs, Regs)
'
DEF SEG = VARSEG(a(0))
Pointer = VARPTR(a(0))
'
b$ = ""
FOR i = 0 TO 14
   b$ = b$ + CHR$(PEEK(Pointer + i))
NEXT
'
GetPCName$ = RTRIM$(b$)
'
END FUNCTION

