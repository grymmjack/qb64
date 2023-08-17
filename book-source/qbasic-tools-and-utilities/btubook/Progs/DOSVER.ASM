;DOSVER.ASM, retrieves the DOS version number

;Copyright (c) 1991 Ethan Winer

;Syntax: CALL DOSVer(Version%)
;Where Version% receives the version times 100


.Model Medium, Basic
.Code

DOSVer Proc, Version:Word

  Mov  AH,30h      ;service 30h gets the version
  Int  21h         ;call DOS to do it

  Push AX          ;save a copy of the version for later
  Mov  CL,100      ;prepare to multiply AL by 100
  Mul  CL          ;AX is now 300 if running DOS 3.xx

  Pop  BX          ;retrieve the version, but in BX
  Mov  BL,BH       ;put the minor part into BL for adding
  Mov  BH,0        ;clear BH, we don't want it anymore
  Add  AX,BX       ;add the major and minor portions

  Mov  BX,Version  ;get the address for Version%
  Mov  [BX],AX     ;assign Version% from AX
  Ret              ;return to BASIC

DOSVer Endp
End
