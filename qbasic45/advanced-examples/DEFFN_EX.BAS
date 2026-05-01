'
' *** DEFFN_EX.BAS - DEF FN function programming example (Converted to QB64PE)
'
INPUT "Enter a number: ", Num
PRINT Num; "factorial is"; Factorial#(Num)

FUNCTION Factorial# (X)
   DIM Tmp AS DOUBLE
   DIM I AS LONG
   Tmp = 1
   FOR I = 2 TO X
      Tmp = Tmp * I
   NEXT I
   Factorial# = Tmp
END FUNCTION
