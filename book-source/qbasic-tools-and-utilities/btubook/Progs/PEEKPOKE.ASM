;PEEKPOKE.ASM, simplifies access to full words

;Copyright (c) 1991 Ethan Winer


.Model Medium, Basic
.Code

PeekWord Proc Uses ES, SegAddr:DWord

    Les  BX,SegAddr     ;load the segment and address
    Mov  AX,ES:[BX]     ;read the word into AX
    Ret                 ;return to BASIC

PeekWord Endp



PokeWord Proc Uses ES, SegAddr:DWord, Value:Word

    Les  BX,SegAddr     ;load the segment and address
    Mov  AX,Value       ;and the new value to store there
    Mov  ES:[BX],AX     ;write the value into memory
    Ret                 ;return to BASIC

PokeWord Endp
End
