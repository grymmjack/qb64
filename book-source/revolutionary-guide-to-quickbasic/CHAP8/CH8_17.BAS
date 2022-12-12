REM Bouncing a ball (realistically)
REM \CHAP8\CH8_17.BAS

 DECLARE FUNCTION GetArraySize (WLeft, WRight, WTop, WBottom)
 'Define VIEW and WINDOW
 SCREEN 2: : CLS : CONST Pi = 3.141592653589#
 VIEW (20, 10)-(620, 190), , 1
 WINDOW (-3.15, -.14)-(3.56, 1.01)
 '$DYNAMIC

 'Drawing and getting ball
 WLeft = -.18: WRight = .18
 WTop = .05: WBottom = -.05
 ArraySize% = GetArraySize(WLeft, WRight, WTop, WBottom)
	DIM Ball%(1 TO ArraySize%) AS INTEGER
 CIRCLE (0, 0), .18: PAINT (0, 0)
 GET (WLeft, WTop)-(WRight, WBottom), Ball%

 'Drawing arena
 CLS : LINE (-3, .8)-(3.4, .2), , B
 Pattern$ = CHR$(126) + CHR$(0) + CHR$(126) + CHR$(126)
 PAINT (0, .5), Pattern$
 LOCATE 21, 29: PRINT "Press any key to end"

 'Jumping ball
 StepSize = .02: StartLoop = -PI: Decay = 1
 DO
     EndLoop = -StartLoop
     FOR x = StartLoop TO EndLoop STEP StepSize
         y = ABS(COS(X)) * Decay - .14
         PUT (x, y), Ball%, PSET                     'Put 1
         FOR i = 1 TO 5: NEXT i
         IF y < -.13 THEN Decay = Decay * .9
         Esc$ = INKEY$
         IF Esc$ <> "" OR Decay < .01 THEN EXIT FOR
         PUT (x, y), Ball%, XOR                       'Put 2
     NEXT x
     StepSize = -StepSize: StartLoop = -StartLoop
 LOOP UNTIL Esc$ <> "" OR Decay < .01
 Pause$ = INPUT$(1)

 FUNCTION GetArraySize (WLeft, WRight, WTop, WBottom) STATIC
 VLeft = PMAP(WLeft, 0): VRight = PMAP(WRight, 0)
 VTop = PMAP(WTop, 1): VBottom = PMAP(WBottom, 1)
 RectHeight = ABS(VBottom - VTop) + 1
 RectWidth = ABS(VRight - VLeft) + 1
 ByteSize = 4 + RectHeight * INT((RectWidth + 7) / 8)
 GetArraySize = ByteSize \ 2 + 1
 END FUNCTION