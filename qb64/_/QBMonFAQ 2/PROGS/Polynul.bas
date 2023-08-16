'*************************************
' POLYNUL.BAS = Nullstellen eines
' ===========   Polynoms berechnen
'
' Es werden die Nullstellen des fol-
' genden Polynoms 4. Grades berechnet
' x^4-7*x^3+8*x^2+28*x-48 .
' Das Programm ist leicht fuer andere
' Polynome beliebiger Grades
' erweiterbar.
'
' (c) Andreas Meile 18.1.2004
'*************************************
DECLARE FUNCTION Poly! (x!, koeff!())
DIM pk!(4)
FOR i% = 4 TO 0 STEP -1
  READ pk!(i%)
NEXT i%
'Hier stehen die Koeffizenten
'a4, a3, a2, a1 und a0:
DATA 1!, -7!, 8!, 28!, -48!
'
FOR x! = -10! TO 48! STEP .5
  IF Poly!(x!, pk!()) = 0! THEN
    PRINT x!
  END IF
NEXT x!
'
FUNCTION Poly! (x!, koeff!())
  w! = 0!
  FOR i% = UBOUND(koeff!) TO LBOUND(koeff!) STEP -1
    w! = x! * w! + koeff!(i%)
  NEXT i%
  Poly! = w!
END FUNCTION

