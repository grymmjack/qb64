'********** CHAP2-1.BAS - shows how to find a near string from its descriptor

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z
Test$ = "BASIC Power Tools"
Descr = VARPTR(Test$)
Length = PEEK(Descr) + 256 * PEEK(Descr + 1)
Addr = PEEK(Descr + 2) + 256 * PEEK(Descr + 3)

PRINT "The length is"; Length
PRINT "The address is"; Addr
PRINT "The string contains ";
FOR X = Addr TO Addr + Length - 1
  PRINT CHR$(PEEK(X));
NEXT
