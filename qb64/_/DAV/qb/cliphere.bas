'============
'CLIPHERE.BAS
'============
'Detects if Windows Clipboard is available and ready for use.
'An alternative method for seeing if windows is running.

'Coded by Dav

'NOTE: CODE DOES NOT WORK UNDER NT

DEFINT A-Z

Clip$ = ""
Clip$ = Clip$ + CHR$(85)                        'push bp
Clip$ = Clip$ + CHR$(137) + CHR$(229)           'mov  bp, sp
Clip$ = Clip$ + CHR$(184) + CHR$(0) + CHR$(23)  'mov ax, 1700h
Clip$ = Clip$ + CHR$(205) + CHR$(47)            'int 2fh
Clip$ = Clip$ + CHR$(139) + CHR$(94) + CHR$(6)  'mov bx, [bp+06]
Clip$ = Clip$ + CHR$(137) + CHR$(7)             'mov [bx], ax
Clip$ = Clip$ + CHR$(93)                        'pop bp
Clip$ = Clip$ + CHR$(202) + CHR$(2) + CHR$(0)   'retf 2

DEF SEG = VARSEG(Clip$)
   CALL ABSOLUTE(huh%, SADD(Clip$))
DEF SEG

IF huh% = &H1700 THEN
  PRINT "Nope, clipboard not ready."
ELSE
  PRINT "Yep, clipboard is ready."
END IF

