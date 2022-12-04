REM Mouse Operation
REM \CHAP4\CH4_15.BAS

DIM SHARED a%(34)

DECLARE SUB MouseInit ()
DECLARE SUB MouseReset ()
DECLARE SUB MouseHide ()
DECLARE SUB MouseShow ()
DECLARE FUNCTION MouseX% ()
DECLARE FUNCTION MouseY% ()
DECLARE FUNCTION MouseButtons% ()
DECLARE FUNCTION MouseChoice% ()
DECLARE SUB DrawMenu (current%, selected%)

'Loading machine codes for working with the mouse
DEF SEG = VARSEG(a%(0))
FOR i% = 0 TO 63
  READ d%
  POKE VARPTR(a%(0)) + i%, d%
NEXT i%
DEF SEG
DATA 00,00
DATA 00,00
DATA 00,00
'    Mashine codes        :        Assembler commands
DATA &HB8,00,00           :       'mov    ax,000h
DATA &HCD,&H33            :       'int    33h
DATA &H3D,&HFF,&HFF       :       'cmp    ax,0FFFFh
DATA &H75,&H0D            :       'jne    @@notPresent
DATA &H0E                 :       'push   cs
DATA &H07                 :       'pop    es
DATA &HBA,&H24,&H00       :       'mov    dx,offset MouseHandler
DATA &HB9,&HFF,&HFF       :       'mov    cx,0FFFFh
DATA &HB8,&H0C,&H00       :       'mov    ax,000Ch
DATA &HCD,&H33            :       'int    33h
			  : '@@NotPresent:
DATA &HCB                 :       'ret
DATA &HB8,00,00           :       'mov    ax,0000h
DATA &HCD,&H33            :       'int    33h
DATA &HCB                 :       'ret
DATA &H2E,&H89,&H0E,00,00 :       'mov    [cs:mouseX],cx
DATA &H2E,&H89,&H16,02,00 :       'mov    [cs:mouseY],dx
DATA &H2E,&H89,&H1E,04,00 :       'mov    [cs:mouseButtons],bx
DATA &HCB                 :       'ret
DATA &HB8,01,00           :       'mov    ax,0001h
DATA &HCD,&H33            :       'int    33h
DATA &HCB                 :       'ret
DATA &HB8,02,00           :       'mov    ax,0002h
DATA &HCD,&H33            :       'int    33h
DATA &HCB                 :       'ret
'Inicial menu and mouse
SCREEN 9: CLS
CALL DrawMenu(1, 1)
CALL MouseInit
CALL MouseShow
curChoice% = 1
curSel% = 1
doRedraw% = 0
LOCATE 1, 1: PRINT "Press Esc to exit ..."
'Mouse and menu active work
DO
  IF (MouseChoice% <> 0) THEN
    IF (curChoice% <> MouseChoice%) THEN
       curChoice% = MouseChoice%
       doRedraw% = 1
    END IF
    IF (MouseButtons% = 1) AND (MouseChoice% <> curSel%) THEN
      curSel% = MouseChoice%
      doRedraw% = 1
    END IF

    IF (doRedraw% = 1) THEN
      CALL MouseHide
      CALL DrawMenu(curChoice%, curSel%)
      CALL MouseShow
      doRedraw% = 0
    END IF
  END IF

   LOCATE 7, 35:  PRINT "Operation 1"
   LOCATE 9, 35:  PRINT "Operation 2"
   LOCATE 11, 35: PRINT "Operation 3"

  'Select menu operations
  IF MouseButtons% = 0 THEN
   LOCATE 14, 30
   SELECT CASE curSel%
     CASE 1: PRINT "This is Operation One  "
     CASE 2: PRINT "This is Operation Two  "
     CASE 3: PRINT "This is Operation Three"
   END SELECT
   END IF

LOOP UNTIL INKEY$ = CHR$(27)
CALL MouseReset  'Reset mouse
SCREEN 0

SUB DrawMenu (selected%, current%)

  IF current% = 1 THEN
    LINE (222, 78)-(418, 103), 2, BF
  ELSE
    LINE (222, 78)-(418, 103), 3, BF
  END IF
IF selected% = 1 THEN
    LINE (220, 76)-(420, 105), 10, B
    LINE (221, 77)-(419, 104), 10, B
  ELSE
    LINE (220, 76)-(420, 105), 15, B
    LINE (221, 77)-(419, 104), 15, B
  END IF

  IF current% = 2 THEN
    LINE (222, 108)-(418, 133), 2, BF
  ELSE
    LINE (222, 108)-(418, 133), 3, BF
  END IF
  IF selected% = 2 THEN
    LINE (220, 106)-(420, 135), 10, B
    LINE (221, 107)-(419, 134), 10, B
  ELSE
    LINE (220, 106)-(420, 135), 15, B
    LINE (221, 107)-(419, 134), 15, B
  END IF

  IF current% = 3 THEN
    LINE (222, 138)-(418, 163), 2, BF
  ELSE
    LINE (222, 138)-(418, 163), 3, BF
  END IF
  IF selected% = 3 THEN
    LINE (220, 136)-(420, 165), 10, B
    LINE (221, 137)-(419, 164), 10, B
  ELSE
    LINE (220, 136)-(420, 165), 15, B
    LINE (221, 137)-(419, 164), 15, B
  END IF

END SUB

FUNCTION MouseButtons%
  MouseButtons% = a%(2)
END FUNCTION

FUNCTION MouseChoice%
  MX% = MouseX%: MY% = MouseY%
  IF (MX% < 220) OR (MY% < 76) OR (MX% >= 420) OR (MY% >= 166) THEN
    MouseChoice% = 0
  ELSEIF (MY% < 106) THEN
    MouseChoice% = 1
  ELSEIF (MY% > 136) THEN
    MouseChoice% = 3
  ELSE
    MouseChoice% = 2
  END IF
END FUNCTION

SUB MouseHide
  DEF SEG = VARSEG(a%(0))
  CALL ABSOLUTE(VARPTR(a%(0)) + &H3A)
  DEF SEG
END SUB

SUB MouseInit
  DEF SEG = VARSEG(a%(0))
  CALL ABSOLUTE(VARPTR(a%(0)) + 6)
  DEF SEG
END SUB

SUB MouseReset
  DEF SEG = VARSEG(a%(0))
  CALL ABSOLUTE(VARPTR(a%(1)) + &H1E)
  DEF SEG
END SUB

SUB MouseShow
  DEF SEG = VARSEG(a%(0))
  CALL ABSOLUTE(VARPTR(a%(0)) + &H34)
  DEF SEG
END SUB

FUNCTION MouseX%
  MouseX% = a%(0)
END FUNCTION

FUNCTION MouseY%
  MouseY% = a%(1)
END FUNCTION

