;SUMARRAY.ASM, adds the elements in a long integer array

;Copyright (c) 1991 Ethan Winer

;Syntax: CALL SumArray(SEG Array&(1), NumElements%, Sum&)

.Model Medium, Basic
.Code

SumArray Proc Uses SI, Array:DWord, NumEls:Word, Sum:Word

  Push DS          ;save DS manually so we can restore it later
                   ;  within this routine
  Xor  AX,AX       ;clear AX and DX which will accumulate
  Mov  DX,AX       ; the total

  Mov  BX,NumEls   ;get the address for NumElements%
  Mov  CX,[BX]     ;assign NumElements% to CX
  Lds  SI,Array    ;load the address of the first element
  Jcxz Exit        ;exit if NumElements = 0

Do:
  Add  AX,[SI]     ;add the value of the low word
  Adc  DX,[SI+2]   ;and then add the high word
  Add  SI,4        ;point to the next array element

  Or   SI,SI       ;are we beyond a 32k boundary?
  Jns  More        ;no, continue

  Sub  SI,8000h    ;yes, subtract 32k from the address
  Mov  BX,DS       ;copy DS into BX
  Add  BX,800h     ;adjust the segment to compensate
  Mov  DS,BX       ;copy BX back into DS

More:
  Loop Do          ;loop until done

Exit:
  Pop  DS          ;restore DS and gain access to Sum&
  Mov  BX,Sum      ;get the DGROUP address for Sum&
  Mov  [BX],AX     ;assign the low word
  Mov  [BX+2],DX   ;and then the high word

  Ret              ;return to BASIC

SumArray Endp
End
