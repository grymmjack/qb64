;********* COMPARE2.ASM - compares two ranges of memory case-insensitive
;
;Copyright (c) 1991 Ethan Winer
;
;
;Usage:
;
;   Same = Compare2%(SEG Type1, SEG Type2, NumBytes%)
;or
;   Same = Compare2%(BYVAL Seg1%, BYVAL Adr1%, BYVAL Seg2%, BYVAL Adr2%, NumBytes%)
;
;Where Same receives -1 if the two type variables or ranges of memory are the
;same, or 0 if they are not.  NumBytes% tells how many bytes to compare.


.Model Medium, Basic
.Code

Compare2 Proc Uses DS ES DI SI, SegAdr1:DWord, SegAdr2:DWord, NumBytes:Word

    Cld                     ;compare in the forward direction
    Mov  BX,-1              ;assume the ranges are the same

    Mov  SI,NumBytes        ;get the address for NumBytes%
    Mov  CX,[SI]            ;put it into CX for comparing below
    Jcxz Exit               ;if zero bytes were given, they're the same

    Les  DI,SegAdr1         ;load ES:DI with the first segmented address
    Lds  SI,SegAdr2         ;load DS:SI with the second segmented address

Do:
    Lodsb                   ;load the current character from DS:SI into AL
    Call Upper              ;capitalize as necessary
    Mov  AH,AL              ;copy the character to AH
    
    Mov  AL,ES:[DI]         ;load the current character from ES;DI into AL
    Inc  DI                 ;point at the next character for later
    Call Upper              ;capitalize as necessary

    Cmp  AL,AH              ;now, are they the same?
    Jne  False              ;no, exit now and show that
    Loop Do                 ;yes, continue
    Jmp  Short Exit         ;if we get this far, the bytes are all the same

False:
    Inc  BX                 ;increment BX up to zero to return False
    
Exit:
    Mov  AX,BX              ;assign the function output
    Ret                     ;return to BASIC

Upper:
    Cmp  AL,"a"             ;is the character below an "a"?
    Jb   Done               ;yes, so we can skip it
    Cmp  AL,"z"             ;is the character above a "z"?
    Ja   Done               ;yes, so we can skip that too
    Sub  AL,32              ;convert to upper case

Done:
    Retn                    ;do a near return to the caller

Compare2 Endp
End
