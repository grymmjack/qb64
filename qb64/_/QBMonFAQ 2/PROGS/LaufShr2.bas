'***************************************************************************
'
' LAUFSHR2.BAS - QBasic-Programm mit Laufschrift, die aus der Mitte heraus
'                nach aussen "waechst", u. zwar nach links und nach rechts
' =====================================================================
' Ein Text erscheint Zeichen fuer Zeichen in der Zeilenmitte und laeuft
' nach links und rechts ueber den Bildschirm und bleibt dort stehen.
'
'   \         (c) Thomas Antoni, 10.10.00 - 25.8.02
'    \ /\           thomas*antonis.de
'    ( )            http://www.antonis.de  
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'
'***************************************************************************
'
DECLARE SUB Spread (text$, Row%, Col%, Delay!)
CLS
CALL Spread("Thomas Antoni - The Wild One - Welcomes You", 12, 40, 1)
SLEEP

SUB Spread (text$, Row%, Col%, Delay)
'*******************************************************************************
'*  Spreads text on the screen in both directions starting from the specified  *
'*  coordinates.  Delay is measured in 100ths of a second (c) Matthew R. Usner                      *
'*******************************************************************************
d! = Delay                  'convert delay to single precision
IF d! < 1 THEN d! = 5       'always have at least 1/20 sec. delay
d! = d! / 100               'change to 100ths
IF text$ = "" THEN EXIT SUB 'if null, get out
Txt$ = text$
IF LEN(Txt$) MOD 2 = 1 THEN Txt$ = Txt$ + " "  'make text length even if odd
LeftSide$ = LEFT$(Txt$, LEN(Txt$) \ 2) 'divide text into left and right sides
RightSide$ = RIGHT$(Txt$, LEN(Txt$) \ 2)
FOR X% = 1 TO LEN(RightSide$)
  LOCATE Row%, Col%
  PRINT RIGHT$(RightSide$, X%);            'print a letter from the left side
    IF (Col% - X%) >= 1 THEN
      LOCATE Row%, Col% - X%
      PRINT LEFT$(LeftSide$, X%);
    END IF
  CurrentTimer! = TIMER
  WHILE TIMER < (CurrentTimer! + d!): WEND 'Wait for timer to increase by d!
  IF INKEY$ <> "" THEN d! = 0              'if a key is pressed, stop delaying
NEXT X%
END SUB

