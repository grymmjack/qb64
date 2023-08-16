'****************************************************************************
' MAUS.BAS = Einfach zu verwendende Mausroutine fuer QuickBASIC
' ========
' Die Einbindung der Maus in QuickBASIC ist ganz einfach! Das zeigt die
' in diesem Programm integrierte Subroutine "treiber". In diesem Beispiel-
' programm werden die Mauskoordinaten und Klicks angezeigt. Das Programm
' eignet sich sowohl fuer Grafik-Screens als auch fuer den textbvildschirm
' SCREEN 0.
'
' HINWEISe
' - Dieses Beispiel funktioniert nur in QuickBASIC 4.5, nicht in QBasic,
'   da der INTERRUPT-Befehl verwendet wird.
' - QuickBASIC muss mit der Option /l qb.qlb gestartet werden.
' - Wenn etwas "unter" die Maus gezeichnet werden soll, dann muss diese
'   kurz deaktiviert werden. Im Beispiel würde dieses Deaktivieren etwa
'   so aussehen:
'     treiber 2, 0, 0, 0
'     ... Hier kommen Befehle zum Zeichnen auf den Bildschirm
'     treiber 1, 0, 0, 0
'****************************************************************************
DEFINT A-Z
TYPE RegType
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE
DECLARE SUB INTERRUPT (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)
DECLARE SUB treiber (ax, bx, cx, dx)
'
SCREEN 12
'
LOCATE 1, 1
PRINT "Links", "Mitte", "Rechts", "x (Spalte)", "y (Zeile)"
'
treiber 1, 0, 0, 0
'
DO
treiber 3, bx, cx, dx
'
LOCATE 2, 1
PRINT ((bx AND 1) <> 0), ((bx AND 4) <> 0), ((bx AND 2) <> 0), cx, dx
LOOP UNTIL INKEY$ <> ""

'
SUB treiber (ax, bx, cx, dx)
DIM regs AS RegType
regs.ax = ax
regs.bx = bx
regs.cx = cx
regs.dx = dx
INTERRUPT &H33, regs, regs
ax = regs.ax
bx = regs.bx
cx = regs.cx
dx = regs.dx
END SUB

