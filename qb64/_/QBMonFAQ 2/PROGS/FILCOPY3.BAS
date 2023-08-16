'*****************************************************************
' FILCOPY3.BAS = Schnelles Kopieren einer Datei ueber einen Puffer
' ============
' Das Kopieren ueber einen Schreib-/Lesepuffer lauft wesentlich
' schneller als das Kopieren Byte fuer Byte.
'
' (c) NicTheQuick, 5.1.02
'*****************************************************************
teil% = 8192
Dat1$ = "c:\temp\test1.txt"
Dat2$ = "c:\temp\test2.txt"
OPEN Dat1$ FOR BINARY AS #1
OPEN Dat2$ FOR OUTPUT AS #2
c1$ = "": c2$ = ""
DO UNTIL LOC(1) = LOF(1) OR INKEY$ = CHR$(27)
  IF LOF(1) - LOC(1) < teil% THEN
    c1$ = SPACE$(LOF(1) - LOC(1))
  ELSE
    c1$ = SPACE$(teil%)
  END IF
  GET #1, , c1$
  PRINT #2, c1$;
LOOP
CLOSE #1, #2
