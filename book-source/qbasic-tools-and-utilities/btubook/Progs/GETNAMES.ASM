;********** GETNAMES.ASM - loads a group of matching file names into an array
;
;Copyright (c) 1991 Ethan Winer
;
;
;Usage:
;
;   DECLARE FUNCTION GetNames%(Array$())
;   REDIM Array$(1 TO 1)            'be sure to use REDIM and not DIM
;   Array$(1) = "*.*"               'or any other valid file specification
;   NumFiles = GetNames%(Array$())  'load all the names in one operation
;   FOR X = 1 TO NumFiles           'for each file that was found
;     PRINT Array$(X)               'print each name
;   NEXT
;   PRINT NumFiles; "matching files were found"


.Model Medium, Basic
    Extrn B$RDIM:Proc       ;this internal routine redimensions an array
    Extrn B$ASSN:Proc       ;this internal routine assigns a string
    Extrn B$FLEN:Proc       ;this internal routine returns a string's length

    DTAType Struc           ;define the DOS Disk Transfer Area structure
      Intern  DB 21 Dup (?) ;this is used by DOS internally
      FAttr   DB ?          ;this holds the file attribute
      FTime   DW ?          ;this holds the file time
      FDate   DW ?          ;this holds the file date
      FSize   DD ?          ;this holds the file size
      FName   DB 13 Dup (?) ;this holds the file name and extension
    DTAType Ends

.Data
    DTA DB Size DTAType Dup (?) ;DOS will place each file's information here
    NumFiles   DW 0             ;this tracks how many file names were read
    SpecLength DW 0             ;this remembers the length of the file spec

.Code

GetNames Proc Uses SI DI, Array:Word

    Local Buffer[80]:Byte   ;we'll copy the file spec here to add a CHR$(0)

;-- Create a local Disk Transfer Area for our own use.
    Lea  DX,DTA             ;show DOS where the new DTA is to be located
    Mov  AH,1Ah             ;set DTA service
    Int  21h                ;call DOS to do it

;-- Read the array descriptor and get the search spec from the first element,
;   then copy it to the stack appending a CHR$(0) byte (ASCIIZ string).
    Mov  SI,Array           ;get the address of the string array descriptor
    Mov  BX,[SI+0Ah]        ;now BX holds the adjusted offset value
    Mov  AX,4               ;each element is four bytes long
    Mul  Word Ptr [SI+10h]  ;multiply that by the first element number
    Add  BX,AX              ;now BX holds the address of the first element
    
    Push DS                 ;push the source string's segment and address
    Push BX                 ;  in anticipation of calling B$ASSN below
    Xor  AX,AX              ;a zero means that the source is a descriptor
    Push AX                 ;pass that on as well
    
    Push BX                 ;now pass the descriptor address to B$FLEN
    Call B$FLEN             ;this returns the length in AX
    Mov  SpecLength,AX      ;save the length locally for a moment
    
    Lea  AX,Buffer          ;get the destination address on the stack
    Push SS                 ;pass the segment to assign into
    Push AX                 ;and then the address
    Push SpecLength         ;non-zero means we're assigning to a fixed-length
    Call B$ASSN             ;copy the file spec to the stack

    Lea  BX,Buffer          ;retrieve the starting address of the stack spec
    Mov  DX,BX              ;copy that to DX where DOS expects it below
    Add  BX,SpecLength      ;point just past the end of the string
    Mov  Byte Ptr [BX],0    ;and append the trailing zero byte

;-- Count the number of names that match the search specification.
    Mov  AH,4Eh             ;specify the DOS Find First matching name service
    Mov  CX,00100111b       ;this attribute will match any type of file
    Xor  BX,BX              ;BX will accumulate the number of names we find

CountNames:
    Int  21h                ;call DOS to see if there's a matching name
    Jc   DoneCount          ;if the carry is set there's no more names
    Inc  BX                 ;otherwise, show we found another one
    Mov  AH,4Fh             ;tell DOS to find the next matching name
    Jmp  CountNames         ;and continue until there are no more

DoneCount:
    Mov  NumFiles,BX        ;remember how many files we found for later
    Or   BX,BX              ;did the search fail on the first name?
    Jz   Exit               ;yes, exit and return a count of zero

;-- Now that we know how many file names there are, REDIM the string array.
    Mov  AX,1               ;specify an LBOUND of 1
    Push AX                 ;pass that on to B$RDIM
    Push BX                 ;and pass on the new UBOUND value
    Mov  AL,4               ;each element descriptor comprises four bytes
    Push AX                 ;pass that on too (knowing AH = 0 saves a byte)
    
    Mov  BX,Array           ;get the array descriptor address again
    Push [BX+08]            ;pass the existing array Features word
    Push BX                 ;show where the array descriptor is located
    Call B$RDIM             ;finally, redimension the array as appropriate

;-- This is the main processing loop that reads and assigns each name found.
    Mov  AH,4Eh             ;specify the DOS Find First matching name service
    Lea  DX,Buffer          ;load the address of the file spec again for DOS
    Mov  BX,Array           ;get the array descriptor address again too
    Mov  BX,[BX+0Ah]        ;reload the adjusted offset value
    Add  BX,4               ;now BX holds the address of the first descriptor

Do:
    Mov  CX,00100111b       ;specify the attribute for any type of file again
    Int  21h                ;call DOS to see if there's a matching name
    Jc   Exit               ;if the carry is set there's no more names
    Push BX                 ;otherwise, save the current descriptor address

    Mov  DI,Offset DTA.FName;search for a zero that marks the end of the name
    Push DS                 ;push DS in anticipation of calling B$ASSN below
    Push DI                 ;and DI too while we have the address handy

    Push DS                 ;ensure that ES=DS
    Pop  ES
    Mov  CL,13              ;search up to 13 characters
    Repne Scasb             ;do the search
    Mov  AL,CL              ;save the remainder in AL
    
    Mov  CL,13              ;calculate the number of characters to copy
    Sub  CL,AL              ;and the answer is now in CX
    Dec  CX                 ;except we don't want to include the zero byte
    Push CX                 ;pass that on to B$ASSN

    Push DS                 ;show where the destination string descriptor is
    Push BX                 ;by passing the segment and then the address
    Xor  AX,AX              ;a value of zero shows B$ASSN that it's assigning
    Push AX                 ;  to a conventional (not fixed-length) string
    Call B$ASSN             ;assign the current array element to the name

    Pop  BX                 ;retrieve the current descriptor address
    Add  BX,4               ;point to the next string array element
    Mov  AH,4Fh             ;specify the DOS Find Next matching name service
    Jmp  Do                 ;continue until there are no more files

Exit:
    Mov  AX,NumFiles        ;assign the function output
    Ret                     ;return to BASIC

GetNames Endp
End
