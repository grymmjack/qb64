;CHAP12-1.ASM, returns "True" or "False" as a near string

;Copyright (c) 1991 Ethan Winer

;Syntax: Answer$ = TrueFalse$(Argument%)

.Model Medium, Basic
.Data
  DescLen DW 0
  DescAdr DW 0
  True    DB "True"
  False   DB "False"

.Code
TrueFalse Proc, Argument:Word

  Mov  DescLen,4            ;assume true
  Mov  DescAdr,Offset True

  Mov  BX,Argument          ;get the address for Argument%
  Cmp  Word Ptr [BX],0      ;is it zero?
  Jne  Exit                 ;no, so we were right

  Inc  DescLen              ;yes, return five characters
  Mov  DescAdr,Offset False ;and the address of "False"

Exit:
  Mov  AX,Offset DescLen    ;show where the descriptor is
  Ret                       ;return to BASIC

TrueFalse Endp
End
