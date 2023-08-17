;FIXUPS.ASM, fixup values needed to service floating point interrupts

;Copyright (c) 1991 Ethan Winer
;deciphered by Paul Passarelli

  FIARQQ  Equ 0FE32h
  FJARQQ  Equ 04000h
  FICRQQ  Equ 00E32h
  FJCRQQ  Equ 0C000h
  FIDRQQ  Equ 05C32h
  FIERQQ  Equ 01632h
  FISRQQ  Equ 00632h
  FJSRQQ  Equ 08000h
  FIWRQQ  Equ 0A23Dh

  Public  FIARQQ
  Public  FJARQQ
  Public  FICRQQ
  Public  FJCRQQ
  Public  FIDRQQ
  Public  FIERQQ
  Public  FISRQQ
  Public  FJSRQQ
  Public  FIWRQQ

End
