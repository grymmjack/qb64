'*******************************************************************
' PASSWRD3.BAS = Passwort-Eingabe mit Sternchenanzeige
' ============
' Das Passwort lautet "abc"
'
' (c) Thomas Antoni, 15.05.2002
'*******************************************************************
CLS
PRINT
FOR i% = 1 TO 3
  y$ = ""
  PRINT " Gib das Passwort ein  ("; i%; "/ 3 )  : ";
  DO:
    LOCATE , , 1  'Cursor anzeigen
    x$ = INKEY$: IF x$ = CHR$(13) THEN EXIT DO  'Exit with Enter Key
    IF x$ <> "" THEN y$ = y$ + x$: PRINT "*";
  LOOP
  IF y$ = "abc" THEN
    CLS
    SYSTEM        'Ende wenn Passwort abc richtig eingegeben
  ELSE
    PRINT "   !!! Das Passwort ist falsch !!!"
    PRINT
    PRINT
  END IF
NEXT i%
WHILE 1: WEND 'Ewige Dauerschleife, wennn 3x falsche Eingabe
              ' ==> Rechner muss neu gestartet werden
              'oder Strg+Pause druecken !!!
END

