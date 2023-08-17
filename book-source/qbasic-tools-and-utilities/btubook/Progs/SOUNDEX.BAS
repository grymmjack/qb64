'********** SOUNDEX.BAS - Soundex routines and example

'Copyright (c) 1992 Ethan Winer

DEFINT A-Z

DECLARE FUNCTION ASoundex$ (Word$)
DECLARE FUNCTION ISoundex% (Word$)

CLS
DO
  PRINT "press Enter alone to exit"
  INPUT "What is the first word"; FWord$
  IF LEN(FWord$) = 0 THEN EXIT DO
  INPUT "What is the second word"; SWord$
  PRINT

  'Test by alph-numeric soundex
  PRINT "Alpha-Numeric Soundex: "; FWord$; " and "; SWord$; " do ";
  IF ASoundex$(FWord$) <> ASoundex$(SWord$) THEN PRINT "NOT ";
  PRINT "sound the same."
  PRINT

  'Test by numeric soundex
  PRINT "      Numeric Soundex: "; FWord$; " and "; SWord$; " do ";
  IF ISoundex%(FWord$) <> ISoundex%(SWord$) THEN PRINT "NOT ";
  PRINT "sound the same."
  PRINT
LOOP

FUNCTION ASoundex$ (InWord$) STATIC

  Word$ = UCASE$(InWord$)
  Work$ = LEFT$(Word$, 1) + "000"
  WkPos = 2
  PrevCode = 0

  FOR L = 2 TO LEN(Word$)
    Temp = INSTR("BFPVCGJKQSXZDTLMNR", MID$(Word$, L, 1))
    IF Temp THEN
      Temp = ASC(MID$("111122222222334556", Temp, 1))
      IF Temp <> PrevCode THEN
        MID$(Work$, WkPos) = CHR$(Temp)
        PrevCode = Temp
        WkPos = WkPos + 1
        IF WkPos > 4 THEN EXIT FOR
      END IF
    ELSE
      PrevCode = 0
    END IF
  NEXT

  ASoundex$ = Work$

END FUNCTION

FUNCTION ISoundex% (InWord$) STATIC

  Word$ = UCASE$(InWord$)
  Work$ = "0000"
  WkPos = 1
  PrevCode = 0

  FOR L = 1 TO LEN(Word$)
    Temp = INSTR("BFPVCGJKQSXZDTLMNR", MID$(Word$, L, 1))
    IF Temp THEN
      Temp = ASC(MID$("111122222222334556", Temp, 1))
      IF Temp <> PrevCode THEN
        MID$(Work$, WkPos) = CHR$(Temp)
        PrevCode = Temp
        WkPos = WkPos + 1
        IF WkPos > 4 THEN EXIT FOR
      END IF
    ELSE
      PrevCode = 0
    END IF
  NEXT

  ISoundex% = VAL(Work$)

END FUNCTION
