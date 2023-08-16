'************************************************************
' MOUSETXT.BAS = Mausroutine fuer den Textbildschirm SCREEN 0
' =============
'
' Nur unter QuickBASIC, nicht unter QBasic ablauffaehig, da
' der Befehl CALL INTERRUPT verwendet wird. QuickBASIC muss
' deswegen auch mit der Option "/L" aufgerufen werden, also
' z.B. mit "QB.EXE /L MOUSETXT.BAS" .
'
' Das Programm zeigt die Mauskoordinaten und den Zustand der
' Maustasten an. Zum Beenden eine beliebige Taste auf der
' Tastatur betaetigen.
'
' 14.10.2002 - 26.2.2006
'*************************************************************
'
DECLARE FUNCTION MXText% ()
DECLARE FUNCTION MYText% ()
DECLARE SUB MGeschw (xs%, ys%)
DECLARE SUB MStatus (lmb%, rmb%, mmb%, x%, y%)
DECLARE SUB MSetze (x%, y%)
DECLARE SUB MReset ()
DECLARE SUB MKnopfDeaktivieren (Nr%)
DECLARE SUB MKnopfAktivieren (Nr%)
DECLARE SUB MBereich (x1%, y1%, x2%, y2%)
DECLARE SUB MAn ()
DECLARE SUB MAus ()
DECLARE SUB MAenderFeld (Nr%, x1%, y1%, x2%, y2%)
DECLARE FUNCTION MFeldPruef% (Maux%, Mauy%)
DECLARE FUNCTION MNeuFeld% (x1%, y1%, x2%, y2%)
DECLARE FUNCTION MX% ()
DECLARE FUNCTION MY% ()
DECLARE FUNCTION MTaste% (Nr%)
'
DEFINT A-Z
'
TYPE RegType
        AX AS INTEGER
        BX AS INTEGER
        CX AS INTEGER
        DX AS INTEGER
        bp AS INTEGER
        si AS INTEGER
        flags AS INTEGER
        ds AS INTEGER
        es AS INTEGER
END TYPE
'
DIM SHARED Regs AS RegType
DIM SHARED MFeld(30, 4)         'Mausfeld (x1,y1,x2,y2,aktiv[0=ja,1 = neyin])
DIM SHARED FeldAnz
'
MAn
'SLEEP
'MSetze 1, 100
'SLEEP
'
DO
  LOCATE 1, 1
  PRINT MX, MY, MTaste(1), MTaste(2), MTaste(3)
  PRINT MXText, MYText

LOOP UNTIL LEN(INKEY$)

'
SUB MAn
Regs.AX = 1
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MAus
Regs.AX = 2
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MBereich (x1, y1, x2, y2)
Regs.AX = 7
Regs.CX = x1
Regs.DX = x2
CALL interrupt(&H33, Regs, Regs)
Regs.AX = 8
Regs.CX = y1
Regs.DX = y2
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MGeschw (xs, ys)
Regs.AX = 15
Regs.CX = xs
Regs.DX = ys
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MReset
Regs.AX = 0
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MSetze (x, y)
Regs.AX = 4
Regs.CX = x
Regs.DX = y
CALL interrupt(&H33, Regs, Regs)
END SUB

'
SUB MStatus (lmb, rmb, mmb, x, y)
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
lmb = Regs.BX AND 1
rmb = (Regs.BX AND 2) \ 2
mmb = (Regs.BX AND 4) \ 4
x = Regs.DX
y = Regs.CX
END SUB

'
FUNCTION MTaste (Nr)
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
Wert = Regs.BX
IF Nr = -1 THEN
 IF Wert THEN MTaste = -1
ELSE
 IF (Wert AND 2 ^ (Nr - 1)) THEN MTaste = -1
END IF
END FUNCTION

'
FUNCTION MX
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
MX = Regs.CX
END FUNCTION

'
FUNCTION MXText
   MXText = MX \ 8 + 1
END FUNCTION

'
FUNCTION MY
Regs.AX = 3
CALL interrupt(&H33, Regs, Regs)
MY = Regs.DX
END FUNCTION

'
FUNCTION MYText
   MYText = MY \ 8 + 1
END FUNCTION

