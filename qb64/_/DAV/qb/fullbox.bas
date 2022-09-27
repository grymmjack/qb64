'===========
'FULLBOX.BAS
'===========
'Here's a small but effective way to force a full-screen DOS box 
'when a Qbasic program is executed while running under windows.

'=================================================
'WARNING!! ONLY CALL THIS ROUTINE UNDER WINDOWS!!
'IF CALLED FROM PURE DOS YOUR COMPUTER WILL CRASH!
'THIS CODE FAILS UNDER NT.
'=================================================

'=== Make the compiled ASM routine

ASM$ = ""
ASM$ = ASM$ + CHR$(184) + CHR$(139) + CHR$(22) 'MOV AX, 168BH
ASM$ = ASM$ + CHR$(43) + CHR$(219) 'SUB BX, BX
ASM$ = ASM$ + CHR$(205) + CHR$(47) 'INT 2FH
ASM$ = ASM$ + CHR$(203) 'RETF

'=== Now call the ASM routine

DEF SEG = VARSEG(ASM$)
  CALL ABSOLUTE(SADD(ASM$))
DEF SEG
