;********** SQUARE.ASM - squares a double precision value

;Copyright (c) 1991 Ethan Winer

;Syntax: DECLARE FUNCTION Square#(Variable#)
;        Result = Square#(Value#)


;WARNING: This file must be assembled using /e (emulator)

.Model Medium, Basic
.Code
.8087                   ;allow 8087 instructions

Square Proc, InValue:Word, OutValue:Word

  Mov  BX,InValue       ;get the address for InValue
  Fld  QWord Ptr [BX]   ;load InValue on the 8087 stack
  Fmul QWord Ptr [BX]   ;multiply InValue by itself

  Mov  BX,OutValue      ;get the address for OutValue
  Fstp QWord Ptr [BX]   ;store the result there
  Fwait                 ;wait for the 8087 to finish

  Mov  AX,BX            ;return DX:AX holding the full
  Mov  DX,DS            ;  address of the output value
  Ret                   ;return to BASIC

Square Endp
End
