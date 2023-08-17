;********* COMPARE3.ASM - compares memory case-insensitive, greater/less than
;
;Copyright (c) 1991 Ethan Winer
;
;
;Usage:
;
;   Result = Compare3%(SEG Type1, SEG Type2, NumBytes%)
;or
;   Result = Compare3%(BYVAL Seg1%, BYVAL Adr1%, BYVAL Seg2%, BYVAL Adr2%, NumBytes%)
;
;Where Result receives 0 if the two type variables or ranges of memory are
;the same, -1 if the first TYPE or range is less when compared as strings,
;or 1 if the first TYPE or range is greater.  NumBytes% tells Compare3 how
;many bytes to compare.


.Model Medium, Basic
.Code

Compare3 Proc Uses DS ES DI SI, SegAdr1:DWord, SegAdr2:DWord, NumBytes:Word

    Cld                  ;compare in the forward direction
    Xor  BX,BX           ;assume the ranges are the same

    Mov  SI,NumBytes     ;get the address for NumBytes%
    Mov  CX,[SI]         ;put it into CX for comparing below
    Jcxz Exit            ;if zero bytes were given, they're the same

    Les  DI,SegAdr1      ;load ES:DI with the first segmented address
    Lds  SI,SegAdr2      ;load DS:SI with the second segmented address

Do:
    Lodsb                ;load the current character from DS:SI into AL
    Call Upper           ;capitalize as necessary, remove for case-sensitive
    Mov  AH,AL           ;copy the character to AH

    Mov  AL,ES:[DI]      ;load the current character from ES:DI into AL
    Inc  DI              ;point at the next character for later
    Call Upper           ;capitalize as necessary, remove for case-sensitive

    Cmp  AL,AH           ;now, are they the same?
    Loope Do             ;yes, continue
    Je   Exit            ;we exhausted the data and they're the same

    Mov  BL,1            ;assume block 1 was "greater"
    Ja   Exit            ;we assumed correctly
    Dec  BX              ;wrong, bump BX down to -1
    Dec  BX

Exit:
    Mov  AX,BX           ;assign the function output
    Ret                  ;return to BASIC

Upper:
    Cmp  AL,"a"          ;is the character below an "a"?
    Jb   Done            ;yes, so we can skip it
    Cmp  AL,"z"          ;is the character above a "z"?
    Ja   Done            ;yes, so we can skip that too
    Sub  AL,32           ;convert to upper case

Done:
    Retn                 ;do a near return to the caller

Compare3 Endp
End
