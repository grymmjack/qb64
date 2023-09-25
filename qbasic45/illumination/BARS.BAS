' *********** CHECK README.1ST FIRST *********************

bars = 5
kerto = 5

DIM t(bars)

SCREEN 13
RANDOMIZE TIMER

FOR i = 1 TO bars
 t(i) = i / 3
NEXT i

DO
_LIMIT 60
 
 FOR A = bars TO 1 STEP -1
   coll = 3
   col = 18
   t(A) = t(A) - .03
   FOR i = 1 TO 5
   
    y = 50 * SIN(t(A)) + 95
   
    col = col + coll
   
    IF i > 2 THEN coll = -3
   
    LINE (A * kerto, y + i)-(319 - A * kerto, y + i), col
    
   NEXT i
  
   LINE (A, y)-(319 - A, y - 1), 0, BF
   LINE (A, y + 6)-(319 - A, y + 7), 0, BF

  NEXT A

WHILE INP(&H3DA) AND 8 = 8: WEND
WHILE INP(&H3DA) AND 8 <> 8: WEND


LOOP UNTIL INKEY$ <> ""

