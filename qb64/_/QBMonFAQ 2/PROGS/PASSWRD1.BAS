'****************************************************************
' PASSWRD1.BAS - Einfache Passwort-Eingabe mit Sternchenanzeige
' ============
' (c) Thomas Antoni, 15.05.2002
'****************************************************************
CLS
PRINT "Please enter the password: ===> ";
DO:
  LOCATE , , 1   'display Cursor
  x$ = INKEY$: IF x$ = CHR$(13) THEN EXIT DO  'Exit with Enter Key
  IF x$ <> "" THEN y$ = y$ + x$: PRINT "*";
LOOP
PRINT : PRINT "Your Input Was................: "; y$

