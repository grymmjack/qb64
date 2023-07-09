DEFINT A-Z
DIM c(7, 25), d
DIM t AS SINGLE
DIM mb, mx, my
SCREEN 0
CLS

d = 4
d = d - 1
x = 1
y = 2 * (d + 1)
a = 1
b = 1

SCREEN , , 2, 0
CLS
PRINT
PRINT SPACE$(3);
FOR j = 0 TO d
FOR i = 0 TO 7
   IF b(i, d) = 0 THEN PRINT STRING$(8, 177) + " ";
NEXT
PRINT
PRINT
PRINT SPACE$(3);
NEXT

SCREEN , , 1, 0
VIEW PRINT 1 TO 25
'CALL absolute(2, mb, mx, my, VARPTR(m(0)))
DO
   t = TIMER
   'CALL absolute(3, mb, mx, my, VARPTR(m(0)))
   do 
        mx = _mousex
        my = _mousey
   loop while _mouseinput
   'mx = (mx \ 8) + 1
   mx = mx + 1
  
   x = x + a
   y = y + b

   a = a XOR (2 * ((x > 79) XOR (x < 2)))
   b = b XOR (2 * (y < 2))
   FOR j = 0 TO d
      IF y = 2 * (j + 1) + 1 THEN
         FOR i = 0 TO 7
            IF b(i, j) = 0 AND x >= 4 + (i * 9) AND x <= 11 + (i * 9) THEN
               b(i, j) = &HFFFF
               SCREEN , , 2, 0
               LOCATE 2 * (j + 1), 4 + (i * 9)
               PRINT SPACE$(8)
               SCREEN , , 1, 0
               b = b XOR -2
               l = l + 1
            END IF
         NEXT
      END IF
   NEXT

   IF y < 25 THEN 2
   IF mx <= x AND (mx + 7) >= x THEN b = b XOR -2 ELSE SYSTEM
2  PCOPY 2, 1

   LOCATE y, x
   PRINT CHR$(2);
   LOCATE 25, mx
   IF mx > 74 THEN LOCATE , 74
   PRINT STRING$(7, 8);
   PCOPY 1, 0
1 IF TIMER < t + .01 THEN 1
    _limit 10
LOOP UNTIL INP(&H60) = 1
SYSTEM