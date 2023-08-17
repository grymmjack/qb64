;FAR$.ASM, support routines for use with PDS far strings

;Copyright (c) 1991 Ethan Winer
;with special thanks to Jay Munro


;StringInfo
;
;StringInfo returns the length, segment, and address of a
;PDS far string, and preserves all necessary registers.
;
;   Input:
;       DS:SI = address of string descriptor
;
;   Output:
;       AX = address of string data
;       DX = segment of string data
;       CX = length of string
 
.Model Medium, Basic

    Extrn StringAddress:Proc    ;these are part of PDS
    Extrn StringLength:Proc
    Extrn StringAssign:Proc

.Code
 
StringInfo Proc Uses SI DI BX ES
 
  Pushf                   ;we can't include Flags in Uses

  Push ES                 ;save ES for later
  Push SI                 ;pass incoming descriptor
  Call StringAddress      ;call the PDS routine

  Pop  ES                 ;retrieve ES for StringLength
  Push AX                 ;save offset and segment
  Push DX                 ;  returned by StringAddress

  Push SI                 ;pass incoming descriptor
  Call StringLength       ;get the length
  Mov  CX,AX              ;copy the length to CX

  Pop  DX                 ;retrieve the saved Segment
  Pop  AX                 ;and address

  Popf                    ;restore flags
  Ret                     ;return to caller

StringInfo Endp



;MakeString
;
;MakeString creates a string descriptor for far strings
;by setting up and calling the routines that come with
;BASIC PDS.  This subroutine merely consolidates the code
;that is needed to create a string.  If the destination
;length is non-zero, then the assigned string is actually
;placed at the address pointed to by DS:DI.
;
;   Input:
;       DX = segment of source data
;       AX = address of source data
;       CX = length of source string
;       DS = segment of destination
;       DI = address of destination
;       BX = length of destination, or zero to assign
;            a variable length string
;
;   Output:
;       If BX was 0, DS:[DI] holds the string descriptor
;       If non-zero, DS:[DI] is the start of the new copy
 
.Model Medium, BASIC
.Code 
 
MakeString Proc Uses DS 
 
  Push DX            ;push the segment of the source string
  Push AX            ;push the address of the source string
  Push CX            ;push the string length
  Push DS            ;push the segment of the destination string
  Push DI            ;push the address of the destination string
  Push BX            ;push the destination string length

  Call StringAssign  ;call BASIC to assign the string
  Ret                ;return to caller
 
MakeString Endp
End
