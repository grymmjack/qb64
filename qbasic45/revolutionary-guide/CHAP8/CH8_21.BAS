REM Demonstration of Brownian motion
REM \CHAP8\CH8_21.BAS

CLS : SCREEN 9
 x = 320: y = 175
 PSET (x, y)
 DO
     RANDOMIZE (TIMER)
     dx = 30 * (RND - .5)
     dy = 20 * (RND - .5)
     x = x + dx
     y = y + dy
     IF x > 619 THEN x = x - dx
     IF x < 20 THEN x = x - dx
     IF y > 329 THEN y = y - dy
     IF y < 20 THEN y = y - dy
     LINE -(x, y)
 LOOP
