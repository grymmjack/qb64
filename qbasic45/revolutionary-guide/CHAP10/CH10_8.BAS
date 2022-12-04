 REM Drawing Contour 3-D diagrams
 REM \CHAP10\CH10_8.BAS

 DECLARE FUNCTION ZF! (X!, Y!)
 SCREEN 9: CLS
 DEFINT I
 LOCATE 10, 34
 PRINT "Please wait!"
 'Calculate matrix Z for points 3-D surface Z(X,Y)
 DIM H(15), X(60), XP(4), Y(60), YP(4), Z(60, 60)
 NH = 15
 NX = 0: Zmin = 1E+30: Zmax = -1E+30
 FOR X0 = -5 TO 5 STEP .2
     NX = NX + 1: NY = 0: X(NX) = X0
     FOR Y0 = -5 TO 5 STEP .2
         NY = NY + 1: Y(NY) = Y0
         Z0 = ZF(X0, Y0): Z(NX, NY) = Z0
         IF Z0 < Zmin THEN Zmin = Z0
         IF Z0 > Zmax THEN Zmax = Z0
     NEXT Y0
 NEXT X0
 'Calculate values for heights H
 M = Zmax - Zmin
 FOR I = 1 TO NH
     H(I) = Zmin + .98 * (I - 1) * M / (NH - 1) + .01 * M
 NEXT I
 'Window define
 CLS
 LINE (0, 0)-(639, 328), 8, B
 WINDOW SCREEN (X(1), Y(1))-(X(NX), 1.137 * Y(NY))
 'Drawing contour lines
 FOR IH = 1 TO NH
     HV = H(IH)
     FOR IX = 2 TO NX
         FOR IY = 2 TO NY
             IP = 0
             Z1 = HV - Z(IX - 1, IY - 1)   'Calculate
             Z2 = HV - Z(IX - 1, IY)       'height
             Z3 = HV - Z(IX, IY)           'differences
             Z4 = HV - Z(IX, IY - 1)
             IF SGN(Z1) <> SGN(Z2) THEN
             IP = IP + 1: XP(IP) = X(IX - 1)
             YP(IP) = Y(IY - 1) + (Y(IY) - Y(IY - 1)) * Z1 / (Z1 - Z2)
             END IF
             IF SGN(Z2) <> SGN(Z3) THEN
             IP = IP + 1: YP(IP) = Y(IY)
             XP(IP) = X(IX - 1) + (X(IX) - X(IX - 1)) * Z2 / (Z2 - Z3)
             END IF
             IF SGN(Z3) <> SGN(Z4) THEN
             IP = IP + 1: XP(IP) = X(IX)
             YP(IP) = Y(IY - 1) + (Y(IY) - Y(IY - 1)) * Z4 / (Z4 - Z3)
             END IF
             IF SGN(Z4) <> SGN(Z1) THEN
             IP = IP + 1: YP(IP) = Y(IY - 1)
             XP(IP) = X(IX - 1) + (X(IX) - X(IX - 1)) * Z1 / (Z1 - Z4)
             END IF
             IF IP = 2 THEN LINE (XP(1), YP(1))-(XP(2), YP(2)), IH
         NEXT IY
     NEXT IX
 NEXT IH
 LOCATE 25, 1
 FOR C = 1 TO NH
     COLOR C
     PRINT INT(100 * H(C)) / 100;
 NEXT C
 F$ = INPUT$(1)

 DEFSNG I
 FUNCTION ZF (X, Y)
 ZF = (X * Y) + (X * X)
 END FUNCTION 