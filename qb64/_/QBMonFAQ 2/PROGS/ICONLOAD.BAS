'*********************************************************
' ICONLOAD.BAS = Anzeigeprogramm fuer Windows-Icons
' ============
' (c) Tobias Doerffel ("todo", todosoft*gmx.de ), 29.4.02
'*********************************************************
PRINT "Gib den Pfadnamen des Icons ein"
INPUT "   (mit abschliessendem \)"; pfad$
PRINT
PRINT "Gib den Dateinamen des Icons ein"
INPUT "   (mit abschliessendem .ICO)"; datei$
DEFINT A-Z
FileName$ = pfad$ + datei$
SCREEN 12
OPEN FileName$ FOR BINARY AS #1
SEEK #1, 127
FOR y = 1 TO 32
  FOR x = 1 TO 32 STEP 2
    b$ = " "
    GET #1, , b$
    Col2 = ASC(b$) MOD 16
    Col1 = (ASC(b$) - Col2) / 16
    PSET (x, 32 - y), Col1
    PSET (x + 1, 32 - y), Col2
  NEXT x
NEXT y
CLOSE #1
SLEEP
SCREEN 0
END

 

