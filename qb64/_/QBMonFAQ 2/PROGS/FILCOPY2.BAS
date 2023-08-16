'*****************************************************************
' FILCOPY2.BAS = Schnelles Kopieren einer Datei ueber einen Puffer
' ============
' Das Kopieren ueber einen Schreib-/Lesepuffer lauft wesentlich
' schneller als das Kopieren Byte fuer Byte.
'
' (c) Andreas Meile & Thomas Antoni, 3.2.2002 - 4.4.2004
'*****************************************************************
quelle$ = "c:\temp\test1.txt"
ziel$ = "c:\temp\test2.txt"
CONST pufGroe% = 8192  'Pufferlaenge (Anzahl Bytes)
OPEN quelle$ FOR BINARY AS #1
OPEN ziel$ FOR OUTPUT AS #2
FOR i& = 1& TO LOF(1) \ CLNG(pufGroe%)
  p$ = INPUT$(pufGroe%, 1)
  PRINT #2, , p$;
NEXT i&
' Rest noch kopieren
p$ = INPUT$(CINT(LOF(1) MOD CLNG(pufGroe%)), 1)
PRINT #2, p$;
CLOSE #2
CLOSE #1
PRINT " Fertig!"
