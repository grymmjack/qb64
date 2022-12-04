REM Rotating a 3D figure
REM \CHAP10\CH10_6.BAS

 DIM X(100), Y(100), Z(100)
 k = 1: sk = 15: pi = 3.141: alfa = .8
 kx = k * COS(alfa): ky = k * SIN(alfa): n = 0
 DEF FNX (a) = 320 + 1.5 * (sk * (X(a) + kx * Y(a)))
 DEF FNY (a) = 175 - sk * (Z(a) + ky * Y(a))

 DO
     READ Q
     IF Q = 1E+37 THEN EXIT DO
     n = n + 1
     X(n) = Q
     READ Y(n), Z(n)
 LOOP

 bx = 0: by = 0: bz = 0
 DO
     SCREEN 9: CLS
     RESTORE L1
     DO
         READ a
         IF a = 0 THEN EXIT DO
         READ b
         xe = FNX(a): ye = FNY(a)
     PSET (xe, ye)
     LINE -(FNX(b), FNY(b))
 LOOP
 M$ = INKEY$
 ' Quit program
 IF M$ = "q" OR M$ = "Q" THEN END
 ' Move around x-axis
 IF M$ = "x" OR M$ = "X" THEN
 IF M$ = "x" THEN bx = bx - .001 ELSE bx = bx + .001
 sx = SIN(bx): cx = COS(bx)
 FOR i = 1 TO n
     y1 = Y(i): z1 = Z(i)
     Y(i) = y1 * cx + z1 * sx
     Z(i) = -y1 * sx + z1 * cx
 NEXT
 END IF
 ' Moves around y-axis
 IF M$ = "y" OR M$ = "Y" THEN
 IF M$ = "y" THEN by = by - .001 ELSE by = by + .001
 sy = SIN(by): cy = COS(by)
 FOR i = 1 TO n
     x1 = X(i): z1 = Z(i)
     X(i) = x1 * cy + z1 * sy
     Z(i) = -x1 * sy + z1 * cy
 NEXT
 END IF
 ' Moves around z-axis
 IF M$ = "z" OR M$ = "Z" THEN
 IF M$ = "z" THEN bz = bz - .001 ELSE bz = bz + .001
 sz = SIN(bz): cz = COS(bz)
 FOR i = 1 TO n
     x1 = X(i): y1 = Y(i)
     X(i) = x1 * cz + y1 * sz
     Y(i) = -x1 * sz + y1 * cz
 NEXT
 END IF
 PRINT "x="; : PRINT USING "#.###"; bx;
 PRINT "    y="; : PRINT USING "#.###"; by;
 PRINT "    z="; : PRINT USING "#.###"; bz
 PSET (20, 30): LINE -(20, 60): LINE -(70, 60)
 LINE (20, 60)-(60, 35)
 LOCATE 3, 2: PRINT "Z"
 LOCATE 6, 9: PRINT "X"
 LOCATE 3, 6: PRINT "Y"
 SLEEP
 LOOP

 DATA -5,-5,-5,   -5,5,-5,   5,5,-5,    5,-5,-5
 DATA -5,-5,5,    -5,5,5,    5,5,5,     5,-5,5
 DATA 1e37

 L1:
 DATA 1,2,  2,3,  3,4,  4,1,  5,6,  6,7,  7,8,  8,5
 DATA 1,5,  2,6,  3,7,  4,8,  1,6,  2,7,  2,5
 DATA 0