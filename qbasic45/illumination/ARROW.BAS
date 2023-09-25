' *********** CHECK README.1ST FIRST *********************

RANDOMIZE TIMER
CLS
SCREEN 13

 X = 50: y = 50
 xx = 75: yy = 50
 xxx = 75: yyy = 25
 Xv = 1: Yv = 1
 XXv = 1: YYv = 1
 XXXv = 1: YYYv = 1

 x2 = 50: y2 = 50
 xx2 = 75: yy2 = 50
 xxx2 = 75: yyy2 = 25
 Xv2 = 0: Yv2 = 0
 XXv2 = 0: YYv2 = 0
 XXXv2 = 0: YYYv2 = 0

    PSET (X, y)
    PSET (xx, yy)
    PSET (xxx, yyy)

  col = 17: coll = 1: mim = 0

Alku:
   
    B = 0
    C = 0
    D = 0
   
    XB = (INT(RND * 100) + 1) * .01
    XC = (INT(RND * 100) + 1) * .01
    XD = (INT(RND * 100) + 1) * .01

FOR col = 1 TO 100
_LIMIT 30
    LINE (X, y)-(xx, yy), col - 1
    LINE (xx, yy)-(xxx, yyy), col - 1
  
    LINE (x2, y2)-(xx2, yy2), 0
    LINE (xx2, yy2)-(xxx2, yyy2), 0
   
    mim = mim + 1
   
    PALETTE col, INT(B * .63) + INT(C * .63) * 256 + INT(D * .63) * 65536
    B = B + XB: C = C + XC: D = D + XD

    IF mim = 50 THEN
      Xv2 = 1: Yv2 = 1
      XXv2 = 1: YYv2 = 1
      XXXv2 = 1: YYYv2 = 1
    END IF

    X = X + Xv: y = y + Yv
    xx = xx + XXv: yy = yy + YYv
    xxx = xxx + XXXv: yyy = yyy + YYYv

    x2 = x2 + Xv2: y2 = y2 + Yv2
    xx2 = xx2 + XXv2: yy2 = yy2 + YYv2
    xxx2 = xxx2 + XXXv2: yyy2 = yyy2 + YYYv2

    IF y > 180 THEN Yv = -1
    IF yy > 180 THEN YYv = -1
    IF yyy > 180 THEN YYYv = -1
   
    IF X > 300 THEN Xv = -1
    IF xx > 300 THEN XXv = -1
    IF xxx > 300 THEN XXXv = -1

    IF y < 20 THEN Yv = 1
    IF yy < 20 THEN YYv = 1
    IF yyy < 20 THEN YYYv = 1
  
    IF X < 20 THEN Xv = 1
    IF xx < 20 THEN XXv = 1
    IF xxx < 20 THEN XXXv = 1

    IF y2 > 180 THEN Yv2 = -1
    IF yy2 > 180 THEN YYv2 = -1
    IF yyy2 > 180 THEN YYYv2 = -1
  
    IF x2 > 300 THEN Xv2 = -1
    IF xx2 > 300 THEN XXv2 = -1
    IF xxx2 > 300 THEN XXXv2 = -1

    IF y2 < 20 THEN Yv2 = 1
    IF yy2 < 20 THEN YYv2 = 1
    IF yyy2 < 20 THEN YYYv2 = 1
 
    IF x2 < 20 THEN Xv2 = 1
    IF xx2 < 20 THEN XXv2 = 1
    IF xxx2 < 20 THEN XXXv2 = 1

    IF INKEY$ <> "" THEN END

NEXT col

  col = 100
 
FOR Lililei = 99 TO 198
_LIMIT 30
   
    LINE (X, y)-(xx, yy), col
    LINE (xx, yy)-(xxx, yyy), col
 
    LINE (x2, y2)-(xx2, yy2), 0
    LINE (xx2, yy2)-(xxx2, yyy2), 0
  
    IF col > 100 THEN col = 100
    IF col < 2 THEN col = 2
    IF mim = 50 THEN
      Xv2 = 1: Yv2 = 1
      XXv2 = 1: YYv2 = 1
      XXXv2 = 1: YYYv2 = 1
    END IF

    PALETTE Lililei, INT(B * .63) + INT(C * .63) * 256 + INT(D * .63) * 65536
    B = B - XB: C = C - XC: D = D - XD
   
    col = col - coll
   
    X = X + Xv: y = y + Yv
    xx = xx + XXv: yy = yy + YYv
    xxx = xxx + XXXv: yyy = yyy + YYYv

    x2 = x2 + Xv2: y2 = y2 + Yv2
    xx2 = xx2 + XXv2: yy2 = yy2 + YYv2
    xxx2 = xxx2 + XXXv2: yyy2 = yyy2 + YYYv2

    IF y > 180 THEN Yv = -1
    IF yy > 180 THEN YYv = -1
    IF yyy > 180 THEN YYYv = -1
  
    IF X > 300 THEN Xv = -1
    IF xx > 300 THEN XXv = -1
    IF xxx > 300 THEN XXXv = -1

    IF y < 20 THEN Yv = 1
    IF yy < 20 THEN YYv = 1
    IF yyy < 20 THEN YYYv = 1
 
    IF X < 20 THEN Xv = 1
    IF xx < 20 THEN XXv = 1
    IF xxx < 20 THEN XXXv = 1

    IF y2 > 180 THEN Yv2 = -1
    IF yy2 > 180 THEN YYv2 = -1
    IF yyy2 > 180 THEN YYYv2 = -1
 
    IF x2 > 300 THEN Xv2 = -1
    IF xx2 > 300 THEN XXv2 = -1
    IF xxx2 > 300 THEN XXXv2 = -1

    IF y2 < 20 THEN Yv2 = 1
    IF yy2 < 20 THEN YYv2 = 1
    IF yyy2 < 20 THEN YYYv2 = 1

    IF x2 < 20 THEN Xv2 = 1
    IF xx2 < 20 THEN XXv2 = 1
    IF xxx2 < 20 THEN XXXv2 = 1

    IF INKEY$ <> "" THEN END

NEXT Lililei

GOTO Alku

