;EMSINT.ASM - dedicated EMS interrupt calling routine

;Copyright (c) 1991 Ethan Winer


.Model Medium, Basic

EMSRegs Struc
  RegAX DW ?
  RegBX DW ?
  RegCX DW ?
  RegDX DW ?
EMSRegs Ends

.Code

EMSInt Proc Uses SI, ERegs:Word

  Mov  SI,ERegs          ;get the address of EMSRegs
  Mov  AX,[SI+RegAX]     ;load each register in turn
  Mov  BX,[SI+RegBX]
  Mov  CX,[SI+RegCX]
  Mov  DX,[SI+RegDX]

  Int  67h               ;call the EMS driver

  Mov  SI,ERegs          ;access EMSRegs again
  Mov  [SI+RegAX],AX     ;save each register in turn
  Mov  [SI+RegBX],BX
  Mov  [SI+RegCX],CX
  Mov  [SI+RegDX],DX

  Ret                    ;return to BASIC

EMSInt Endp
End
