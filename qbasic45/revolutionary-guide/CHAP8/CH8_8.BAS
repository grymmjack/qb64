REM Demonstration of font manipulation
REM \CHAP8\CH8_8.BAS

 SCREEN 9
 DEFINT X-Y
 LOCATE 25, 1
 PRINT "Hello my friend!";
 FOR Y = 0 TO 11
     Y2 = 2 * Y: Y3 = 3 * Y: Y4 = 4 * Y
     FOR X = 0 TO 319
         Z = POINT(X, 349 - Y)
         IF Z <> 0 THEN
         X2 = 2 * X: X3 = 3 * X
         ' Small font         
         PSET (255 + .86 * X, 10 - .7 * Y), 15
         ' Italics 
         PSET (250 + X + .3 * Y, 30 - Y), 11
         ' Double height and width 
         PSET (200 + X2, 60 - Y2), 12
         ' Even larger font 
         PSET (150 + X3, 110 - Y4), 13
         ' Bulky box font
         LINE (150 + X3, 165 - Y4)-(153 + X3, 169 - Y4), Z, BF
         XI = 150 + X3 + .6 * Y
         ' Large line-based font
         LINE (XI, 230 - Y4)-(XI + 2, 234 - Y4), 14
         ' Chubby rounded font
         CIRCLE (150 + X3, 300 - Y4), 3, 10
         ' Vertical italic font going upwards
         PSET (50 - Y2, 300 - X2), 15
         ' Vertical italic font going downwards
         PSET (530 + Y2 + .6 * X, 50 + X2), 15
         END IF
     NEXT
 NEXT
 F$ = INPUT$(1)



