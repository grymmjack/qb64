;NOREBOOT.ASM, traps Ctrl-Alt-Del within a BASIC program

;Copyright (c) 1991 Ethan Winer


;Syntax: CALL NoReboot(BYVAL InstallFlag%)
;
;Where InstallFlag is non-zero to install the TSR, or zero to deinstall it.


.Model Medium, Basic
.Code

NoReboot Proc Uses DS, InstallFlag:Word

  Cmp  InstallFlag,0     ;do they want to install the routine?
  Je   Deinstall         ;no, go deinstall it
  
  Cmp  CS:Old9Seg,0      ;yes, but have we already been installed?
  Jne  Exit              ;yes, and don't do that again!

  Mov  AX,3509h          ;ask DOS for the existing Int 9 vector address
  Int  21h               ;DOS returns the segment:address in ES:BX
  Mov  CS:Old9Adr,BX     ;save it locally
  Mov  CS:Old9Seg,ES

  Mov  AX,2509h          ;point Interrrupt 9 to our own handler
  Mov  DX,Offset NewInt9
  Push CS                ;copy CS into DS
  Pop  DS
  Int  21h

Exit:
  Ret                    ;return to BASIC


;-- Control comes here each time a key is pressed or released.
NewInt9:
  Sti                    ;enable further interrupts
  Push AX                ;save the registers we'll be using
  Push DS

  In   AL,60h            ;get the scan code from the keyboard
  Cmp  AL,83             ;is it the Delete key?
  Jnz  Continue          ;no, continue on to BIOS interrupt 9

  Xor  AX,AX             ;see if the Alt and Ctrl keys are down
  Mov  DS,AX             ;by looking at address 0:417h

  Mov  AL,DS:[417h]      ;get the shift status at 0000:0417h
  Test AL,8              ;is Alt key depressed?
  Jz   Continue          ;no, continue on to BIOS interrupt
  Test AL,4              ;is Ctrl key depressed?
  Jz   Continue          ;no, continue on to BIOS interrupt

  In   AL,61h            ;send an acknowledge to keyboard
  Mov  AH,AL             ;otherwise the Ctrl-Alt-Del keystroke
  Or   AL,80h            ;  will still be hanging around the
  Out  61h,AL            ;  next time a program goes to get a key
  Mov  AL,AH
  Out  61h,AL
  Mov  AL,20h            ;indicate end of interrupt to 8259
  Out  20h,AL            ;  interrupt controller chip

  Pop  DS                ;ignore, and simply return to caller
  Pop  AX
  Iret                   ;use this special form of Ret instruction
                         ;  when returning from an interrupt routine

Continue:
  Pop  DS                ;restore the saved registers
  Pop  AX
  Jmp  DWord Ptr CS:Old9Adr   ;continue on to BIOS interrupt 9
                              ;  by jumping to the address that
                              ;  was saved during initialization

DeInstall:
  Mov  AX,2509h          ;restore the original Int 9 handler
  Mov  DX,CS:Old9Adr     ;from the segment and address saved earlier
  Mov  DS,CS:Old9Seg
  Int  21h               ;DOS does this for us
  Mov  CS:Old9Seg,0      ;clear this so we can tell we're not installed
  Jmp  Short Exit        ;and then exit back to BASIC

NoReboot Endp

  Old9Adr   DW 0         ;these remember the original Int 9 address
  Old9Seg   DW 0         ;they must be in the code segment because
                         ;  DS is undefined when NewInt9 gets control
End
