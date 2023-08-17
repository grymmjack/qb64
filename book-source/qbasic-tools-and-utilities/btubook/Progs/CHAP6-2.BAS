'*********** CHAP6-2.BAS - proves that all files are really binary access

'Copyright (c) 1992 Ethan Winer

OPEN "File1" FOR OUTPUT AS #1
  PRINT #1, "Testing"; SPC(13);
CLOSE

OPEN "File2" FOR BINARY AS #1
  Work$ = "Testing" + SPACE$(13)
  PUT #1, , Work$
CLOSE

OPEN "File3" FOR RANDOM AS #1 LEN = 20
  FIELD #1, 20 AS Temp$
  LSET Temp$ = "Testing"
  PUT #1
CLOSE
END
