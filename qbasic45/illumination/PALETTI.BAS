' *********** CHECK README.1ST FIRST *********************

SCREEN 13

FOR i = 1 TO 255
 OUT &H3C8, i

 OUT &H3C9, i     ' RED 0 - 63
 OUT &H3C9, 0     ' GREEN 0 - 63
 OUT &H3C9, i     ' BLUE 0 - 63
NEXT

x = 0

FOR i = 40 TO 160
 LINE (i, 1)-(i, 199), x
 x = x + .5
NEXT

x = 60

FOR i = 160 TO 280
 LINE (i, 1)-(i, 199), x
 x = x - .5
NEXT

