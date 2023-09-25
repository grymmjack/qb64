' *********** CHECK README.1ST FIRST *********************

SCREEN 13

DIM sd(29), cd(29)

FOR i = 1 TO 28
  OUT (&H3C8), i
  OUT (&H3C9), 63 - i * 2.25
  OUT (&H3C9), 63 - i * 2.25
  OUT (&H3C9), 63 - i * 2.25
NEXT i

DO
_LIMIT 30
  d = d + .5
  f = -1
  
  xp2 = xp
  yp2 = yp
  xp = (sd(6) * 190)
  yp = (cd(6) * 190)

  FOR z = 7.5 TO 1.25 STEP -.25
   
      f = f + 1
      
      xx = (sd(f) * 190 + xp2) / z
      yy = (cd(f) * 190 + yp2) / z

      CIRCLE (INT(xx) + 160, INT(yy) + 100), 260 / z, 0
     
      cd(f) = COS(d / 2.6 + z / 1.5)
      sd(f) = SIN(d / 3.7 + z / 1.5)

      xx = (sd(f) * 190 + xp) / z
      yy = (cd(f) * 190 + yp) / z

      CIRCLE (INT(xx) + 160, INT(yy) + 100), 260 / z, z * 3

  NEXT z

LOOP UNTIL INKEY$ <> ""

