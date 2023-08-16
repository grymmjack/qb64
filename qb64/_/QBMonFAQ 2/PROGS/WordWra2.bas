'***************************************************************************
' WORDWRA2.BAS = Wordwrapping a long text to a selectable line length
' ============   Text mit Zeilenumbruch und waehlbarer Zeilenlaenge anzeigen
'
' (c) Released to Public Domain, 1993, by R.A. Coates
'***************************************************************************
'
DECLARE SUB WordWrap (strvar$, linelen%)
'
CLS
strvar$ = "This is a very long text that shoould be word wrapped to a nice"
strvar$ = strvar$ + " short lined format and then displayed on the screen"
'
CALL WordWrap(strvar$, 16) 'wrap to max. 16 characters per line
'
SLEEP
END

'
'---------------------------------------------------------------------------
' The procedure prints a string variable to screen, wrapping the words to a
' maximum length specified.  Error handling must be done in the calling
' program.
'
' CALL: WordWrap(strvar$, linelen%)
'
' ARG:  strvar$   - name of the string variable to be 'wrapped.
'       linelen%  - maximum length of the line
'
' COMP: MS QBasic 1.1, QuickBASIC 4.5, 7.1
'
'
'
SUB WordWrap (strvar$, linelen%)
  strlen% = LEN(strvar$)
  maxlen% = strlen% + 1
  ptr% = 1
'
  WHILE ptr% <= strlen%
    FOR x% = (ptr% + linelen%) TO ptr% STEP -1
      IF MID$(strvar$, x%, 1) = " " OR x% = maxlen% THEN
        PRINT MID$(strvar$, ptr%, x% - ptr%);
        ptr% = x% + 1
'
        WHILE MID$(strvar$, ptr%, 1) = " "
          ptr% = ptr% + 1
        WEND
        x% = 0
        IF POS(0) > 1 THEN PRINT
      END IF
    NEXT x%
  WEND
END SUB 'WordWrap()

