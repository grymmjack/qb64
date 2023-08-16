'*****************************************************************
' JuliaFra.bas = JULIA FRACTAL generator for Q(uick)Basic
' ============   Fraktalgenerator fuer Julia-Mengen
'
' The Julia set.  A fascinating fractal discovered by Raoul Julia,
' a French mathematician who was born in the 19th century.
' It is defined in the complex plane by the *simple* equation:
' f(Z) = Z^2 +U, where Z and U are complex numbers of the form
' a + bi where i = SQR(-1).
'
' I leave this to my friends in the QuickBASIC conference.
' You'll need a VGA screen.  You'll REALLY appreciate an 80397
' numerical co-processor.
' It might even work with interpreted QBASIC.  Tell me about it.
' It is *highly* recommended that you compile the program first.
'
' You can choose a linear magnification anywhere between 1 and
' 100,000,000,000,000 (1 followed by 14 zeroes).  In practice,
' you should not go beyond 13 zeroes, as we then reach the CPU's
' precision limit.
'
' Choosing successive magnifications of 1, 400, 160000, ...(x 400)
' will give you a screen which represents the *details* included
' in *one* dot of the previous magnification.
'
' At magnification 10^14, the whole screen represents the details
' 'missing' from the original magnification 1 screen which has
' 'grown' to a size of 10 billion kilometers in width!!!
'
' (c) RAYMOND PAQUIN , July 08, 1993
'*******************************************************************
'
'$DYNAMIC
DEFINT A-Z
CONST PI = 3.141592654#
CONST TWOPI = PI * 2#
CONST False = 0, True = NOT False
CONST SPAN = 200  'virtual 200x200 dot screen
'
TYPE Cplex        'Complex type (a + bi) where a & b are reals
  Re AS DOUBLE    'and where i = SQRT(-1)
  Im AS DOUBLE    'Conventionaly, a is the Re(al) part and
END TYPE          'b is the Im(aginary) part.

DECLARE SUB DoPalette (Pal)
DECLARE SUB Julia (U AS Cplex, Mag#)
DECLARE SUB CplexADD (Num1 AS Cplex, Num2 AS Cplex, Answ AS Cplex)
DECLARE SUB CplexMUL (Num1 AS Cplex, Num2 AS Cplex, Answ AS Cplex)
'
DO
  SCREEN 0, 0, 0, 0
  WIDTH 80, 25
  CLS
  LOCATE 12, 2
  PRINT "Julia set, written by Raymond Paquin"
  DO
    LOCATE 14, 2
    INPUT "Magnification (1 to 100000000000000, 0 to abort)"; Mag#
  LOOP UNTIL (Mag# >= 1# AND Mag# <= 100000000000000#) OR Mag# = 0
  IF Mag# = 0# THEN EXIT DO
  DO
    LOCATE 16, 2
    INPUT "Palette, 1 (structure), 2 (artistic), 0 to abort)"; Pal
  LOOP UNTIL Pal = 0 OR Pal = 1 OR Pal = 2
  IF Pal = 0 THEN EXIT DO
  SCREEN 13
  WINDOW (-SPAN, -SPAN)-(SPAN, SPAN)
  DIM U AS Cplex
  U.Re = .138341      'Don't mess with this
  U.Im = .649857      'Don't mess with this
                      'Of course, wou will. but don't come
                      'crying to me !
  DoPalette Pal
  Mag# = Mag# / 1.5#
  Julia U, Mag#
LOOP
END

REM $STATIC
SUB CplexADD (Num1 AS Cplex, Num2 AS Cplex, Answ AS Cplex)
  Answ.Re = Num1.Re + Num2.Re
  Answ.Im = Num1.Im + Num2.Im
END SUB

SUB CplexMUL (a AS Cplex, b AS Cplex, c AS Cplex)
  c.Re = a.Re * b.Re - a.Im * b.Im
  c.Im = a.Re * b.Im + a.Im * b.Re
END SUB

SUB DoPalette (Pal)
  DIM Kolor&(0 TO 255)
  SELECT CASE Pal
    CASE 1
      FOR i = 0 TO 255
        Blue& = (CLNG(i) * 13&) MOD 64&
        Green& = (CLNG(i) * 3&) MOD 64&
        Red& = (CLNG(i) * 7&) MOD 64&
        PALETTE i, Blue& * 65536 + Green& * 256& + Red&
      NEXT i
    CASE 2
      FOR i = 0 TO 255
        b# = SIN(3# * TWOPI * (CDBL(i) / 63#))
        Blue& = CLNG(b# * b# * 63#)
        r# = SIN(2# * TWOPI * (CDBL(i) / 63#))
        Red& = CLNG(r# * r# * 63#)
        g# = SIN((TWOPI + PI) * (CDBL(i) / 63#))
        Green& = CLNG(g# * g# * 63#)
        PALETTE i, Blue& * 65536 + Green& * 256& + Red&
      NEXT i
  END SELECT
END SUB

SUB Julia (U AS Cplex, Mag#)
DIM Z AS Cplex
DIM Z2 AS Cplex
OfX# = -.090010013#     'These two values have been chosen so that
OfY# = -.00002514951#   'successive magnifications would always
                        'yield 'interesting' regions.  Don't mess
                        'with them.  ... but you will ANYWAY ...
  InfX# = -1# / Mag# + OfX#
  SupX# = 1# / Mag# + OfX#
  IncrX# = .006245# / Mag#

  InfY# = -1# / Mag# + OfY#
  SupY# = 1# / Mag# + OfY#
  IncrY# = .01# / Mag#
  
  FOR rz# = InfX# TO SupX# STEP IncrX#
    FOR iz# = InfY# TO SupY# STEP IncrY#
      IF INKEY$ <> "" THEN GOTO NoWaitKey
      Z.Re = rz#
      Z.Im = iz#
      FOR i = 0 TO 32767
        CplexMUL Z, Z, Z2   'The heart: Z <-- Z^2 + U, where
        CplexADD Z2, U, Z   'Z and U are complex numbers.
        IF Z.Re * Z.Re + Z.Im * Z.Im > 10# THEN EXIT FOR
      NEXT i
      i = i AND &HFF
      PRESET ((rz# - OfX#) * SPAN * Mag#, (iz# - OfY#) * SPAN * Mag#), i
    NEXT iz#
  NEXT rz#
  WHILE INKEY$ = ""
  WEND
NoWaitKey:
END SUB

