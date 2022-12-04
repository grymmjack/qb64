REM Mandel Fractals
REM \CHAP9\CHAP9_20.BAS

DEFINT A-Z
DECLARE SUB ShiftPalette ()
DECLARE SUB ScreenTest (EM%, CR%, VL%, VR%, VT%, VB%)
CONST FALSE = 0, TRUE = NOT FALSE
CONST MAXLOOP = 30, MAXSIZE = 1000000
DIM PaletteArray(15)
FOR I = 0 TO 15: PaletteArray(I) = I: NEXT I
'Set size of window and graphic mode control
WLeft = -1000: WRight = 250: WTop = 625: WBottom = -625
ScreenTest EgaMode, ColorRange, VLeft, VRight, VTop, VBottom
VIEW (VLeft, VTop)-(VRight, VBottom), 0, ColorRange
WINDOW (WLeft, WTop)-(WRight, WBottom)
'Drawing mandel
LOCATE 24, 10: PRINT "Press any key to quit.";
XLength = VRight - VLeft: YLength = VBottom - VTop
ColorWidth = MAXLOOP \ ColorRange
FOR Y = 0 TO YLength
  LogicY = PMAP(Y, 3): PSET (WLeft, LogicY): OldColor = 0
  FOR X = 0 TO XLength
    LogicX = PMAP(X, 2)
    MandelX& = LogicX: MandelY& = LogicY
    FOR I = 1 TO MAXLOOP
      RealNum& = MandelX& * MandelX&
      ImagNum& = MandelY& * MandelY&
      IF (RealNum& + ImagNum&) >= MAXSIZE THEN EXIT FOR
      MandelY& = (MandelX& * MandelY&) \ 250 + LogicY
      MandelX& = (RealNum& - ImagNum&) \ 500 + LogicX
    NEXT I
    PColor = I \ ColorWidth
    IF PColor <> OldColor THEN
      LINE -(LogicX, LogicY), (ColorRange - OldColor)
      OldColor = PColor
    END IF
    IF INKEY$ <> "" THEN END
  NEXT X
  LINE -(LogicX, LogicY), (ColorRange - OldColor)
  IF EgaMode THEN ShiftPalette
NEXT Y
DO
   IF EgaMode THEN ShiftPalette
LOOP WHILE INKEY$ = ""
SCREEN 0, 0: WIDTH 80: END

BadScreen:
   EgaMode = FALSE
RESUME NEXT

SUB ScreenTest (EM, CR, VL, VR, VT, VB) STATIC
  EM = TRUE
  ON ERROR GOTO BadScreen
  SCREEN 8, 1
  ON ERROR GOTO 0
  IF EM THEN            ' No error, so SCREEN 8 is OK
    VL = 110: VR = 529: VT = 5: VB = 179
    CR = 15             ' 16 colors (0 - 15)
  ELSE                  ' Error, so use SCREEN 1
    SCREEN 1, 1
    VL = 55: VR = 264: VT = 5: VB = 179
    CR = 3              ' 4 colors (0 - 3)
  END IF
END SUB

SUB ShiftPalette STATIC
  SHARED PaletteArray(), ColorRange
  FOR I = 1 TO ColorRange
    PaletteArray(I) = (PaletteArray(I) MOD ColorRange) + 1
  NEXT I
  PALETTE USING PaletteArray(0)
END SUB

