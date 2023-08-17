;********* SWAPMEM.ASM, swaps two sections of memory

;Copyright (c) 1991 Ethan Winer


.Model Medium, Basic
.Code

SwapMem Proc Uses SI DI DS ES, Var1:DWord, Var2:DWord, NumBytes:Word

    Lds  SI,Var1        ;get the segmented address of the first variable
    Les  DI,Var2        ;and for the second variable too
    Mov  CX,NumBytes    ;get the number of bytes to exchange
    Jcxz Exit           ;we can't swap zero bytes!
    Cld                 ;ensure Lodsb works forward

DoSwap:
    Mov  AL,ES:[DI]     ;get a byte from the second variable
    Xchg AL,[SI]        ;swap it with the first variable
    Stosb               ;complete the swap and also increment DI
    Inc  SI             ;point to the next byte in the first variable
    Loop DoSwap         ;continue until done

Exit:
    Ret                 ;return to BASIC

SwapMem Endp
End
