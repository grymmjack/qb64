;********* MEMCOPY.ASM - copies a block of memory from here to there
;
;Copyright (c) 1991 Ethan Winer
;
;
;Usage:
;
; CALL MemCopy(SEG Type1, SEG Type2, NumBytes%)
;or
; CALL MemCopy(BYVAL Seg1%, BYVAL Adr1%, BYVAL Seg2%, BYVAL Adr2%, NumBytes%)


.Model Medium, Basic
.Code

MemCopy Proc Uses DS ES SI DI, FromAdr:DWord, ToAdr:DWord, NumBytes:Word

  Cld                  ;copy in the forward direction

  Mov  SI,NumBytes     ;get the address for NumBytes%
  Mov  CX,[SI]         ;put it into CX for copying below

  Les  DI,ToAdr        ;load ES:DI with the segmented destination address
  Lds  SI,FromAdr      ;load DS:SI with the segmented source address

  Shr  CX,1            ;copy words instead of bytes for speed
  Rep  Movsw           ;do the copy
  Adc  CX,CX           ;this will set CX to either 0 or 1
  Rep  Movsb           ;copy the odd byte if necessary

  Ret                  ;return to BASIC

MemCopy Endp
End
