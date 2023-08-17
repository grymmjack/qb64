;GETCOLOR.ASM, retrieves the current COLOR settings

;Copyright (c) 1991 Ethan Winer

;Syntax: CALL GetColor(FG%, BG%)


.Model Medium, Basic
.Data
  Extrn B$FBColors:Word

.Code

GetColor Proc, FG:Word, BG:Word

  Mov  DX,B$FBColors    ;load the combined colors
  Mov  AL,DL            ;copy the foreground portion
  Cbw                   ;convert it to a full word
  Mov  BX,FG            ;get the address for FG%
  Mov  [BX],AX          ;assign FG%
  Mov  AL,DH            ;load the background portion
  Mov  BX,BG            ;get the address for BG%
  Mov  [BX],AX          ;assign BG%
  Ret                   ;return to BASIC

GetColor Endp
End
