;MOUSEINT.ASM - dedicated mouse interrupt calling routine

;Copyright (c) 1991 Ethan Winer


.Model Medium, Basic

MouseRegs Struc
  RegAX  DW ?
  RegBX  DW ?
  RegCX  DW ?
  RegDX  DW ?
  Segmnt DW ?
MouseRegs Ends

.Code

MouseInt Proc Uses SI DS ES, MRegs:Word

  Mov  SI,MRegs          ;get the address of MouseRegs
  Mov  AX,[SI+RegAX]     ;load each register in turn
  Mov  BX,[SI+RegBX]
  Mov  CX,[SI+RegCX]
  Mov  DX,[SI+RegDX]

  Mov  SI,[SI+Segmnt]    ;see what the segment is
  Or   SI,SI             ;is it zero?
  Jz   @F                ;yes, skip ahead and use default

  Cmp  SI,-1             ;is it -1?
  Je   @F                ;yes, skip ahead

  Mov  DS,SI             ;use the segment specified

@@:
  Push DS                ;either way, assign ES=DS
  Pop  ES
  Int  33h               ;call the mouse driver

  Push SS                ;regain access to MouseRegs
  Pop  DS

  Mov  SI,MRegs          ;access MouseRegs again
  Mov  [SI+RegAX],AX     ;save each register in turn
  Mov  [SI+RegBX],BX
  Mov  [SI+RegCX],CX
  Mov  [SI+RegDX],DX

  Ret                    ;return to BASIC

MouseInt Endp
End
