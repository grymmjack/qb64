;DOSINT.ASM, "short-cut" routine replaces CALL INTERRUPT

;Copyright (c) 1991 Ethan Winer


.Model Medium, Basic

Registers Struc
  RegAX  DW ?
  RegBX  DW ?
  RegCX  DW ?
  RegDX  DW ?
  RegBP  DW ?
  RegSI  DW ?
  RegDI  DW ?
  Flags  DW ?
  RegDS  DW ?
  RegES  DW ?
Registers Ends

.Code

DOSInt Proc Uses SI DI DS, Regs:Word

  Mov  SI,Regs            ;get the address of the Registers TYPE or array

  Mov  AX,[SI+RegAX]      ;load each register in succession
  Mov  BX,[SI+RegBX]
  Mov  CX,[SI+RegCX]
  Mov  DX,[SI+RegDX]
  Mov  BP,[SI+RegBP]
  Mov  DI,[SI+RegDI]
  Mov  ES,[SI+RegES]

  Push [SI+RegSI]         ;save the incoming SI register for a moment

  Cmp  [SI+RegES],-1      ;do they want the default for ES?
  Jne  @F                 ;no, use what we loaded
  Push DS                 ;yes, move DS into ES
  Pop  ES

@@:
  Cmp  [SI+RegDS],-1      ;do they want the default for DS?
  Je   @F                 ;yes, leave DS alone
  Mov  DS,[SI+RegDS]      ;no, assign DS from the incoming table

@@:
  Pop  SI                 ;finally, retrieve SI
  Int  21h                ;and call DOS

  Push BP                 ;save BP and then setup access to the stack
  Mov  BP,SP
  Push DS                 ;save these too because we need them to
  Push SI                 ;address the table

  Mov  DS,[BP+2]          ;reload DS from where it was originally stored
  Mov  SI,[BP+0EH]        ;and SI too

  Mov  [SI+RegAX],AX      ;now assign the values back to the caller
  Mov  [SI+RegBX],BX
  Mov  [SI+RegCX],CX
  Mov  [SI+RegDX],DX

  Pop  [SI+RegSI]
  Pop  [SI+RegDS]
  Pop  [SI+RegBP]

  Mov  [SI+RegDI],DI
  Mov  [SI+RegES],ES

  Pushf
  Pop  [SI+Flags]

  Ret

DOSInt Endp
End
