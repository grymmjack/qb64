REM Shooting pellets from a shotgun
REM \CHAP8\CH8_20.BAS

CLS : SCREEN 9
 v0 = 70
 g = 9.8
 ym = 0
 LINE (10, 10)-(10, 340)
 LINE (10, 340)-(630, 340)
 LOCATE 1, 1: PRINT "h"
 LOCATE 24, 79: PRINT "x";
 FOR t = 0 TO 13 STEP .04
     a = .78: GOSUB DrawTr
     a = .8:  GOSUB DrawTr
     a = .82: GOSUB DrawTr
     a = .84: GOSUB DrawTr
     a = .86: GOSUB DrawTr
 NEXT
 LOCATE 1, 20
 PRINT "xmax="; INT(x); "     Hmax="; INT(ym)
 LOCATE 20, 63: PRINT "<== Focus"
 f$ = INPUT$(1)
 END

 DrawTr:
 x = v0 * t * COS(A)
 y = v0 * t * SIN(A) - g * t ^ 2 / 2
 IF y > ym THEN ym = y
 IF y > 0 THEN PSET (10 + x, 340 - 2 * y)
 RETURN
