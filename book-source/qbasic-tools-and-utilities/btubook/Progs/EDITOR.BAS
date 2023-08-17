'*********** EDITOR.BAS - polled data entry routine

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
DECLARE SUB Editor (Text$, LeftCol, RightCol, KeyCode)

COLOR 7, 1                      'clear to white on blue
CLS

Text$ = "This is a test"        'make some sample text
LeftCol = 20                    'set the left column
RightCol = 60                   'and the right column
LOCATE 10                       'set the line number
COLOR 0, 7                      'set the field color

DO                              'edit until Esc or Enter
   CALL Editor(Text$, LeftCol, RightCol, KeyCode)
LOOP UNTIL KeyCode = 13 OR KeyCode = 27

SUB Editor (Text$, LeftCol, RightCol, KeyCode)

  '----- Find the cursor's size.
  DEF SEG = 0
  IF PEEK(&H463) = &HB4 THEN
     CsrSize = 12               'mono uses 13 scan lines
  ELSE
     CsrSize = 7                'color uses 8
  END IF

  '----- Work with a temporary copy.
  Edit$ = SPACE$(RightCol - LeftCol + 1)
  LSET Edit$ = Text$

  '----- See where to begin editing and print the string.
  TxtPos = POS(0) - LeftCol + 1
  IF TxtPos < 1 THEN TxtPos = 1
  IF TxtPos > LEN(Edit$) THEN TxtPos = LEN(Edit$)
 
  LOCATE , LeftCol
  PRINT Edit$;

  '----- This is the main loop for handling key presses.
  DO
     LOCATE , LeftCol + TxtPos - 1, 1

     DO
       Ky$ = INKEY$
     LOOP UNTIL LEN(Ky$)        'wait for a keypress

     IF LEN(Ky$) = 1 THEN       'create a key code
       KeyCode = ASC(Ky$)       'regular character key
     ELSE                       'extended key
       KeyCode = -ASC(RIGHT$(Ky$, 1))
     END IF

     '----- Branch according to the key pressed.
     SELECT CASE KeyCode

       '----- Backspace: decrement the pointer and the
       '      cursor, and ignore if in the first column.
       CASE 8
         TxtPos = TxtPos - 1
         LOCATE , LeftCol + TxtPos - 1, 0
         IF TxtPos > 0 THEN
           IF InsStatus THEN
             MID$(Edit$, TxtPos) = MID$(Edit$, TxtPos + 1) + " "
           ELSE
             MID$(Edit$, TxtPos) = " "
           END IF
           PRINT MID$(Edit$, TxtPos);
         END IF

       '----- Enter or Escape: this block is optional in
       '      case you want to handle these separately.
       CASE 13, 27
         EXIT DO                'exit the subprogram

       '----- Letter keys: turn off the cursor to hide
       '      the printing, handle Insert mode as needed.
       CASE 32 TO 254
         LOCATE , , 0
         IF InsStatus THEN      'expand the string
           MID$(Edit$, TxtPos) = Ky$ + MID$(Edit$, TxtPos)
           PRINT MID$(Edit$, TxtPos);
         ELSE                   'else insert character
           MID$(Edit$, TxtPos) = Ky$
           PRINT Ky$;
         END IF
         TxtPos = TxtPos + 1    'update position counter

       '----- Left arrow: decrement the position counter.
       CASE -75
         TxtPos = TxtPos - 1

       '----- Right arrow: increment position counter.
       CASE -77
         TxtPos = TxtPos + 1

       '----- Home: jump to the first character position.
       CASE -71
         TxtPos = 1

       '----- End: search for the last non-blank, and
       '      make that the current editing position.
       CASE -79
         FOR N = LEN(Edit$) TO 1 STEP -1
           IF MID$(Edit$, N, 1) <> " " THEN EXIT FOR
         NEXT
         TxtPos = N + 1
         IF TxtPos > LEN(Edit$) THEN TxtPos = LEN(Edit$)

       '----- Insert key: toggle the Insert state and
       '      adjust the cursor size.
       CASE -82
         InsStatus = NOT InsStatus
         IF InsStatus THEN
           LOCATE , , , CsrSize \ 2, CsrSize
         ELSE
           LOCATE , , , CsrSize - 1, CsrSize
         END IF

       '----- Delete: delete the current character and
       '      reprint what remains in the string.
       CASE -83
         MID$(Edit$, TxtPos) = MID$(Edit$, TxtPos + 1) + " "
         LOCATE , , 0
         PRINT MID$(Edit$, TxtPos);

       '---- All other keys: exit the subprogram
       CASE ELSE
         EXIT DO
     END SELECT

  '----- Loop until the cursor moves out of the field.
  LOOP UNTIL TxtPos < 1 OR TxtPos > LEN(Edit$)

  Text$ = RTRIM$(Edit$)         'trim the text

END SUB
