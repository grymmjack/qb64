;********* COMPAREF.ASM, compares floating point numbers

;Copyright (c) 1991 Ethan Winer

;NOTE: Assemble this file with MASM 5.1 using the /e (emulator) switch.


.Model Medium, Basic
  Extrn B$FCMP:Proc         ;this is BASIC's floating point compare routine

.8087                       ;allow coprocessor instructions
.Code

CompareSP Proc, Var1:Word, Var2:Word

  Mov  BX,Var2              ;get the address of Var1
  Fld  DWord Ptr [BX]       ;load it onto the 8087 stack
  Mov  BX,Var1              ;same for Var2
  Fld  DWord Ptr [BX]
  FWait                     ;wait until the 8087 says it's okay
  Call B$FCMP

  Mov  AX,0                 ;assume they're the same
  Je   Exit                 ;we were right
  Mov  AL,1                 ;assume Var1 is greater
  Ja   Exit                 ;we were right
  Dec  AX                   ;Var1 must be less than Var2
  Dec  AX                   ;decrement AX to -1

Exit:
  Ret                       ;return to BASIC

CompareSP Endp



CompareDP Proc, Var1:Word, Var2:Word

  Mov  BX,Var2              ;as above
  Fld  QWord Ptr [BX]
  Mov  BX,Var1
  Fld  QWord Ptr [BX]
  FWait
  Call B$FCMP

  Mov  AX,0
  Je   Exit
  Mov  AL,1
  Ja   Exit
  Dec  AX
  Dec  AX

Exit:
  Ret

CompareDP Endp
End
