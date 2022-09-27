'===========
'13toCOM.BAS
'===========
' Converts SCREEN 13 image to self-displaying COM executable
' Coded by Dav
'
' 13toCOM.BAS saves the currently showing SCREEN 13 image and pallette
' to a self-displaying .COM executable. When it's run, the .COM file
' sets the screen mode, displays the image, waits for a keypress and
' then restores the screen to mode 0. These .COM files contain all of
' the image and pallette data and can be compressed by PKLITE. They
' display at BLOAD speed!
'
' This is *great* for intros or ads. Convert your favorite BMP's!
' You don't need to use an image loader SUB, just SHELL your COM file!
'===================================================================

'===================================================================
' NOTE: THIS DEMO CREATES 13.COM FILE IN THE CURRENT DIRECTORY
'===================================================================
' The following Demo created a 64814 byte .COM file on my computer.
' PKLITE compressed it down to 1978 bytes. It still runs perfectly.
' The COM file that this demo creates is named -------> 13.COM
' After creating it, drop to DOS or use SHELL to run and display it.
'===================================================================

'===========
' BEGIN DEMO
'===========

DEFINT A-Z

SCREEN 13

'=== Draw a pretty screen

FOR A% = 0 TO 319
   LINE (A%, 0)-(A%, 199), A%
NEXT

'=== name and open the file to make

OPEN "13.COM" FOR OUTPUT AS 1

'=== Write the ASM assembled COM header first

ASM$ = ""
ASM$ = ASM$ + CHR$(184) + CHR$(19) + CHR$(0)  'mov ax, 13h
ASM$ = ASM$ + CHR$(205) + CHR$(16)            'int 10h 
ASM$ = ASM$ + CHR$(184) + CHR$(18) + CHR$(16) 'mov ax, 1012h
ASM$ = ASM$ + CHR$(187) + CHR$(0) + CHR$(0)   'mov bx, 0
ASM$ = ASM$ + CHR$(185) + CHR$(0) + CHR$(1)   'mov cx, 100h
ASM$ = ASM$ + CHR$(186) + CHR$(46) + CHR$(1)  'mov dx, 12eh 
ASM$ = ASM$ + CHR$(205) + CHR$(16)            'int 10h 
ASM$ = ASM$ + CHR$(252)                       'cld
ASM$ = ASM$ + CHR$(190) + CHR$(46) + CHR$(4)  'mov si, 42eh 
ASM$ = ASM$ + CHR$(43) + CHR$(255)            'sub di, di 
ASM$ = ASM$ + CHR$(184) + CHR$(0) + CHR$(160) 'mov ax, 0a000h 
ASM$ = ASM$ + CHR$(142) + CHR$(192)           'mov es, ax
ASM$ = ASM$ + CHR$(185) + CHR$(0) + CHR$(125) 'mov cx, 7d00h 
ASM$ = ASM$ + CHR$(243) + CHR$(165)           'repe movsw
ASM$ = ASM$ + CHR$(180) + CHR$(0)             'mov ah, 0h 
ASM$ = ASM$ + CHR$(205) + CHR$(22)            'int 16h 
ASM$ = ASM$ + CHR$(184) + CHR$(3) + CHR$(0)   'mov ax, 3h 
ASM$ = ASM$ + CHR$(205) + CHR$(16)            'int 10h 
ASM$ = ASM$ + CHR$(205) + CHR$(32)            'int 20h 

PRINT #1, ASM$;

'=== Now save the current pallette

OUT 967, 0
FOR c% = 1 TO 768
   PRINT #1, CHR$(INP(969));
NEXT

'=== Now save the screen...pixel by pixel

FOR y% = 0 TO 199
   FOR x% = 0 TO 319
     PRINT #1, CHR$(POINT(x%, y%)); 'Save the pixels.
   NEXT
   LINE (0, y%)-(319, y%), 0 'Erase them for show.
NEXT

CLOSE

PRINT "13.COM saved!" 'CLOSE & Show what we did.

END

'=========
' END DEMO
'=========