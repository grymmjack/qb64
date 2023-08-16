'***********************************************************************
' DEC2BIN4.BAS = Zahlenkonvertierung Dezimal -> Binaer
' ============
' Dezimalzahl in Binaerzahl wandeln und ein Bit extrahieren
' Convert A Number To Binary And Extract A Bit From It
'***********************************************************************
DECLARE FUNCTION tobin$ (n%) ' integer to binary string
DECLARE FUNCTION todec% (n$) ' binary string to integer
DECLARE FUNCTION getbit% (btg%, n%) ' extract a bit from integer
' These three functions are result of very little work, and have probably
' been written by most programmers at some time, and then forgotten.
' Feel free to use, modify, or convert in any way :)
' (But don't blame me for any damage, whether physical, mental or
' emotional!)
'
CLS
num% = 0
'
DO
   PRINT
   INPUT "Decimal Number (Abort with 0) ", num%
   IF num% = 0 THEN END
   INPUT "Bit to get ", bittoget%
      IF bittoget% > 0 THEN
         bin$ = tobin$((num%))
         PRINT "Binary Number is  "; bin$
         bit% = getbit%(bittoget%, num%)
         PRINT "Getbit is "; bit%
         dec% = todec%(bin$)
         PRINT "Todec is  "; dec%
      END IF
LOOP WHILE num% > 0
END

'
FUNCTION getbit% (btg%, n%)
' return the value of a single bit ( 1/0 ) from a decimal value/variable
' btg% = the bit position to check
' n% = the decimal number to extract the bit from
   IF (n% AND (2 ^ (btg% - 1))) > 0 THEN getbit% = 1
END FUNCTION

'
FUNCTION tobin$ (n%)
' convert an integer value into a binary string, e.g 4 becomes "100"
' nm% is the value to convert.
a$ = ""
'n% = nm%: ' needed because despite what Help says, num% will be changed
   WHILE n% > 0
      bit% = n% MOD 2
      n% = INT(n% / 2)
      a$ = RIGHT$(STR$(bit%), 1) + a$
   WEND
tobin$ = a$
END FUNCTION

'
'
FUNCTION todec% (b$)
' convert a string of 1's and 0's into it's decimal equivilant
' could be tweaked for speed, but not a lot
'
   FOR k% = LEN(b$) TO 1 STEP -1
      IF MID$(b$, k%, 1) = "1" THEN d% = d% + (2 ^ (LEN(b$) - k%))
   NEXT
todec% = d%
END FUNCTION

