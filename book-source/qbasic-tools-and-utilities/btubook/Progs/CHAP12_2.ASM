;CHAP12-2.ASM, returns "True" or "False" as a far string

;Copyright (c) 1991 Ethan Winer

;Syntax: Answer$ = TrueFalse$(Argument%)

.Model Medium, Basic
  Extrn MakeString:Proc        ;this is in FAR$.ASM

.Data
  Descriptor DW 0, 0           ;the output string descriptor

  True       DB "True"
  TrueLen = $ - Offset True

  False      DB "False"
  FalseLen = $ - Offset False

.Code
TrueFalse Proc Uses ES DS SI DI, Argument:Word

  Mov  CX,4             ;assume true
  Mov  AX,Offset True

  Mov  BX,Argument      ;get the address for Argument%
  Cmp  Word Ptr [BX],0  ;is it zero?
  Jne  @F               ;no, so we were right

  Inc  CX               ;yes, assign five characters
  Mov  AX,Offset False  ;and use the address of "False"

@@:
  Mov  DX,DS                ;assign segment and address
  Mov  DI,Offset Descriptor ;  of destination descriptor
  Xor  BX,BX                ;assign to a descriptor
  Call MakeString           ;let MakeString do the work
  
  Mov  AX,DI            ;address of output descriptor
  Ret                   ;return to BASIC

TrueFalse Endp
End
