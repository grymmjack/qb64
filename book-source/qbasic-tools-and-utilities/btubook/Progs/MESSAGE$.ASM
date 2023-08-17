;MESSAGE$.ASM, returns a specified string as a function

;Copyright (c) 1991 Ethan Winer

;Syntax:
;
;   DECLARE FUNCTION Message$(BYVAL MsgNumber%)
;   PRINT Message$(AnyInt%)


.Model Medium, Basic
  Extrn B$ASSN:Proc         ;BASIC's assignment routine

.Data
  Descriptor DD 0           ;the output string descriptor
  Null$      DD 0           ;use this to return a null
  
.Code

Message Proc Uses SI, MsgNumber:Word

  Mov  SI,Offset Messages   ;point to start of messages
  Xor  AX,AX                ;assume an invalid value
  
  Mov  CX,MsgNumber         ;load the message number
  Cmp  CX,NumMsg            ;does this message exist?
  Ja   Null                 ;no, return a null string
  Jcxz Null                 ;ditto if they pass a zero

Do:                         ;walk through the messages
  Lods Word Ptr CS:0        ;load and skip over this
                            ;  message length
  Dec  CX                   ;show that we read another
  Jz   Done                 ;this is the one we want
  
  Add  SI,AX                ;skip over the message text
  Jmp  Short Do             ;continue until we're there

Done:
  Or   AX,AX                ;are we returning a null?
  Jz   Null                 ;yes, handle that differently
  Push CS                   ;no, pass the source segment
  
Done2:
  Push SI                   ;and the source address
  Push AX                   ;and the source length

  Push DS                   ;pass the destination segment
  Mov  AX,Offset Descriptor ;and the destination address
  Push AX
  Xor  AX,AX                ;0 means assign a descriptor
  Push AX                   ;pass that as well
  
  Call B$ASSN               ;let B$ASSN do the dirty work
  Mov  AX,Offset Descriptor ;show where the output is
  Ret                       ;return to BASIC

Null:
  Push DS                   ;pass the address of Null$
  Mov  SI,Offset Null$
  Jmp  Short Done2

Message Endp


;----- DefMsg macro that defines messages
;
;Usage:
;  DefMsg "This is the message text."
;
;  You may also pass a mix of character values and quoted text by enclosing
;  the entire string in angled brackets like this:
;
;     DefMsg <34, "This is quoted text", 34>
;
;  Using DefMsg with no arguments lets you have a null message, perhaps
;  as a placeholder for an unused message number.
;
DefMsg Macro Message
  Local MsgStart, MsgEnd    ;; local address labels
  NumMsg = NumMsg + 1       ;; show we made another one
  IFB <Message>             ;; if no text is defined
    DW 0                    ;; just create an empty zero
  ELSE                      ;; else create the message
    DW MsgEnd - MsgStart    ;; first write the length
    MsgStart:               ;; identify starting address
      DB Message            ;; define the message text
    MsgEnd Label Byte       ;; this marks the end
  ENDIF
Endm


Messages Label Byte         ;the messages begin here
NumMsg = 0                  ;tracks number of messages

DefMsg "Sunday"
DefMsg "Monday"
DefMsg "Tuesday"
DefMsg "Wednesday"
DefMsg "Thursday"
DefMsg "Friday"
DefMsg "Saturday"

End
