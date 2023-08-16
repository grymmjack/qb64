'***************************************************************
' INTEXT6.BAS = Line Editor with adjustable input length
' ===========   Eingaberoutine - Zeileneditor mit einstellbarer
'                 Eingabelaenge
'
'  (c) by BRIAN MCLAUGHLIN, Dec. 2, 1993
'****************************************************************
DECLARE FUNCTION LineEdit$ (Row%, Col%, EntryLen%, Prompt$)

Row% = 4: Col% = 4
EntryLen% = 55           'number of spaces the entry can occupy
Prompt$ = "Write here: "

CLS
OutString$ = LineEdit$(Row%, Col%, EntryLen%, Prompt$)
LOCATE CSRLIN + 2, 4
PRINT "You said:   "; OutString$
END

'====================================================
 FUNCTION LineEdit$ (Row%, Col%, EntryLen%, Prompt$)
'====================================================
'
  CONST TRUE = -1, FALSE = 0
'
  DO: LOOP WHILE LEN(INKEY$)  'clears any impending keys
  LOCATE Row%, Col%
'
  PRINT Prompt$;
  Col% = POS(0)
  AllLength% = Col% + EntryLen%
  IF AllLength% > 79 THEN EntryLen% = EntryLen% - (AllLength% - 80)
'
  SHOW$ = STRING$(EntryLen%, CHR$(176))   'use squares
  PRINT SHOW$;
  LOCATE Row%, Col%, 1, 7, 1              'a big cursor
'
' -----------------------------
' START OF MAIN PROCEDURE LOOP
' -----------------------------
'
 DO                                   'it keeps going and going and going
      DO
        Akey$ = INKEY$                ' wait for some kind of input
      LOOP UNTIL LEN(Akey$)

      IF LEN(Akey$) = 1 THEN
         Ky% = ASC(Akey$)
      ELSE                       'it must be an extended key like F1
         Char2$ = RIGHT$(Akey$, 1)
         Ky% = ASC(Char2$) * -1  'convert the keycode to a negative number
      END IF

      SELECT CASE Ky%
        CASE 13                       'on ENTER break out of LOOP
           EXIT DO
        CASE -75                      ' on LEFT ARROW move left one position
          IF (Cpos% > 0) THEN
             Cpos% = Cpos% - 1
             LOCATE Row%, Col% + Cpos%
          END IF
        CASE -77                      ' on RIGHT ARROW move right
          IF (Cpos% < length%) THEN
             Cpos% = Cpos% + 1
             LOCATE Row%, Col% + Cpos%
          END IF
        CASE -79                      ' on END go to end of line
          Cpos% = length%
          LOCATE Row%, Col% + Cpos%
        CASE -71                      ' on HOME go to start of line
          Cpos% = 0
          LOCATE Row%, Col% + Cpos%
        CASE -83                      ' on a DEL keypress
          IF (length% > 0) AND (Cpos% < length%) THEN
             Temp1$ = LEFT$(OutPut$, Cpos%)
             Temp2$ = RIGHT$(OutPut$, length% - Cpos% - 1)
             OutPut$ = Temp1$ + Temp2$
             length% = length% - 1
             LOCATE Row%, Col%
             PRINT OutPut$ + CHR$(176);
             LOCATE Row%, Col% + Cpos%
          END IF
        CASE 8                        ' on BACKSPACE
          IF (length% > 0) AND (Cpos% > 0) THEN
             Temp1$ = LEFT$(OutPut$, Cpos% - 1)
             Temp2$ = RIGHT$(OutPut$, (length% - Cpos%))
             OutPut$ = Temp1$ + Temp2$
             length% = length% - 1
             Cpos% = Cpos% - 1
             LOCATE Row%, Col%
             PRINT OutPut$ + CHR$(176);
             LOCATE Row%, Col% + Cpos%
          END IF
        CASE 32 TO 126              'our "printable" characters
          IF (length% < EntryLen%) THEN
             Temp1$ = LEFT$(OutPut$, Cpos%)
             Temp2$ = RIGHT$(OutPut$, length% - Cpos%)
             OutPut$ = Temp1$ + CHR$(Ky%) + Temp2$
             length% = length% + 1
             Cpos% = Cpos% + 1
             LOCATE Row%, Col%
             PRINT OutPut$;
             LOCATE Row%, Col% + Cpos%
          END IF
      END SELECT
 LOOP
'
  LOCATE , , 0           'turns the cursor off
  LineEdit$ = OutPut$
END FUNCTION

