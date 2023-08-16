'***************************************************************************
'
' LAUFSCHR.BAS - QBasic-Programm mit Laufschrift von rechts nach links
' =====================================================================
' Ein Text erscheint Zeichen fuer Zeichen am rechten Bildschirmrand, laeuft
' nach links ueber den Bildschirm und verschwindet dort Zeichen fuer Zeichen.
'
'   \         (c) Thomas Antoni, 6.3.00 - 29.11.02
'    \ /\           thomas*antonis.de
'    ( )            http://www.antonis.de 
'  .( o ).
'              ----==== Hottest QBasic Stuff on Earth !!! ====----
'
'
'***************************************************************************
'
CLS
text$ = "This is the text message I want to scroll across the screen."
FOR k = 1 TO LEN(text$)
  LOCATE 12, 70 - k
  PRINT MID$(text$, 1, k); " ";
  t = TIMER
  DO
    IF INKEY$ = CHR$(27) THEN END 'abort at Enter Key
  LOOP WHILE TIMER < t + .1 'put a pause routine here to slow scrolling
NEXT k
'
'to scroll text off the page include the following also.
FOR k = 1 TO LEN(text$) + 1
  LOCATE 12, 70 - LEN(text$)
  PRINT MID$(text$ + " ", k); SPACE$(k);
  t = TIMER
  DO
    IF INKEY$ = CHR$(27) THEN END 'abort at Enter key
  LOOP WHILE TIMER < t + .1 'put a pause routine here to slow scrolling
  NEXT k
END

