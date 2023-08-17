;********* COMPARE.ASM - compares two ranges of memory
;
;Copyright (c) 1991 Ethan Winer
;
;
;Usage:
;
;   Same = Compare%(SEG Type1, SEG Type2, NumBytes%)
;or
;   Same = Compare%(BYVAL Seg1%, BYVAL Adr1%, BYVAL Seg2%, BYVAL Adr2%, NumBytes%)
;
;Where Same receives -1 if the two type variables or ranges of memory are the
;same, or 0 if they are not.  NumBytes% tells how many bytes to compare.


.Model Medium, Basic
.Code

Compare Proc Uses DS ES DI SI, SegAdr1:DWord, SegAdr2:DWord, NumBytes:Word

    Cld                     ;compare in the forward direction

    Mov  SI,NumBytes        ;get the address for NumBytes%
    Mov  CX,[SI]            ;put it into CX for comparing below
    
    Les  DI,SegAdr1         ;load ES:DI with the first segmented address
    Lds  SI,SegAdr2         ;load DS:SI with the second segmented address

    Repe Cmpsb              ;do the compare
    Mov  AX,0               ;assume the bytes didn't match
    Jne  Exit               ;we were right, skip over
    Dec  AX                 ;wrong, decrement AX down to -1

Exit:
    Ret                     ;return to BASIC

Compare Endp
End
