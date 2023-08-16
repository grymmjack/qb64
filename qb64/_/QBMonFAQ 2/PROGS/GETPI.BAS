'***********************************************************
' GETPI.BAS - Calculates Pi with 1000 decimal digits
' =========   Berechnet Pi auf 1000 Dezimalstellen genau
'
' Calculates the first thousand digits of PI. It is
' possible to calculate more, but for some weird
' unknown reason all digits after about 2400 are bogus.
' Uses 4096-bit numbers! (And it's possible to use more.)
'
' This programm also provides Add, Subtract, Muliply
' and Divide for vera long numbers!!!
'
' (c) someone42 - www.angelfire.com/tx5/someone42/
'************************************************************
DECLARE SUB BigMul (op1 AS STRING, op2 AS INTEGER)
DECLARE SUB BigAdd (op1 AS STRING, op2 AS STRING)
DECLARE SUB BigSub (op1 AS STRING, op2 AS STRING)
DECLARE SUB BigDiv (op1 AS STRING, op2 AS INTEGER)
DIM SHARED x AS STRING * 512
DIM SHARED x2 AS STRING * 512
DIM SHARED x3 AS STRING * 512
DIM SHARED x4 AS STRING * 512
CLS
x = CHR$(1) + CHR$(0) + STRING$(510, 0)
BigDiv x, 5
x3 = x
PRINT "Calculating atn(1/5):";
FOR a = 0 TO 878
  LOCATE 1, 22: PRINT a + 1; "/ 879"
  BigDiv x, 25
  x2 = x
  BigDiv x2, a * 2 + 3
  IF a AND 1 THEN
    BigAdd x3, x2
  ELSE
    BigSub x3, x2
  END IF
NEXT a
'
x = CHR$(1) + CHR$(0) + STRING$(510, 0)
BigDiv x, 239
x4 = x
'
PRINT "Calculating atn(1/239):";
FOR a = 0 TO 257
  LOCATE 2, 24: PRINT a + 1; "/ 258"
  BigDiv x, 239
  BigDiv x, 239
  x2 = x
  BigDiv x2, a * 2 + 3
  IF a AND 1 THEN
    BigAdd x4, x2
  ELSE
    BigSub x4, x2
  END IF
NEXT a
'
BigMul x3, 4
BigSub x3, x4
BigMul x3, 4
'
PRINT "PI = ";
FOR t% = 1 TO 1000
  PRINT LTRIM$(STR$(ASC(MID$(x3, 1, 1)) MOD 10));
  IF t% = 1 THEN PRINT ".";
  MID$(x3, 1, 1) = CHR$(0)
  BigMul x3, 10
NEXT t%
'
SUB BigAdd (op1 AS STRING, op2 AS STRING)
  carry& = 0
  FOR c% = 511 TO 1 STEP -2
    add1& = CVL(MID$(op1, c%, 2) + CHR$(0) + CHR$(0))
    add2& = CVL(MID$(op2, c%, 2) + CHR$(0) + CHR$(0))
    thing& = add1& + add2& + carry&
    IF thing& > 65536 THEN
      thing& = thing& - 65536
      carry& = 1
    ELSE
      carry& = 0
    END IF
    IF thing& > 32767 THEN thing& = thing& - 65536
    MID$(op1, c%, 2) = MKI$(thing&)
  NEXT c%
END SUB

SUB BigDiv (op1 AS STRING, op2 AS INTEGER)
  numq& = CVL(MID$(op1, 1, 2) + CHR$(0) + CHR$(0)) \ op2
  numr& = CVL(MID$(op1, 1, 2) + CHR$(0) + CHR$(0)) MOD op2
  MID$(op1, 1, 1) = CHR$(numq& AND 255)
  MID$(op1, 2, 1) = CHR$(numq& \ 256)
  nextval$ = CHR$(numr& AND 255) + CHR$(numr& \ 256)
  FOR c% = 3 TO 511 STEP 2
    numq& = CVL(MID$(op1, c%, 2) + nextval$) \ op2
    numr& = CVL(MID$(op1, c%, 2) + nextval$) MOD op2
    MID$(op1, c%, 1) = CHR$(numq& AND 255)
    MID$(op1, c% + 1, 1) = CHR$(numq& \ 256)
    nextval$ = CHR$(numr& AND 255) + CHR$(numr& \ 256)
  NEXT c%
END SUB

SUB BigMul (op1 AS STRING, op2 AS INTEGER)
  carry& = 0
  FOR c% = 511 TO 1 STEP -2
    mul& = CVL(MID$(op1, c%, 2) + CHR$(0) + CHR$(0))
    thing& = mul& * op2 + carry&
    carry& = thing& \ 65536
    thing& = thing& AND 65535
    IF thing& > 32767 THEN thing& = thing& - 65536
    MID$(op1, c%, 2) = MKI$(thing&)
  NEXT c%
END SUB

SUB BigSub (op1 AS STRING, op2 AS STRING)
  borrow& = 0
  FOR c% = 511 TO 1 STEP -2
    sub1& = CVL(MID$(op1, c%, 2) + CHR$(0) + CHR$(0))
    sub2& = CVL(MID$(op2, c%, 2) + CHR$(0) + CHR$(0))
    thing& = sub1& - sub2& - borrow&
    IF thing& < 0 THEN
      thing& = thing& + 65536
      borrow& = 1
    ELSE
      borrow& = 0
    END IF
    IF thing& > 32767 THEN thing& = thing& - 65536
    MID$(op1, c%, 2) = MKI$(thing&)
  NEXT c%
END SUB

