DECLARE SUB PrName ()
DECLARE SUB ResMenu ()
DECLARE SUB GY (t!, YM!, W1!, G!(), Q!(), G1!(), Q1!())
DECLARE SUB GYF (t!, YM!, t!(), Y0!(), Y1!())
DECLARE SUB GYA (t!, YM!)
DECLARE FUNCTION YT! (W1!, t!, G!(), Q!(), G1!(), Q1!())
DECLARE SUB CalcYT (W1!, G!(), Q!(), G1!(), Q1!())
DECLARE SUB InpF (G1!(), Q1!())
DECLARE SUB ResF (G1!(), Q1!())
DECLARE SUB SAPrint (F!, t!, CG!, G!(), Q!())
DECLARE SUB Transl (A!(), B!(), G!(), Q!())
DECLARE SUB GMQ (F!, t!, G!(), Q!())
DECLARE SUB CopyScr ()
DECLARE SUB SARes (F!, t!, CG!, G!(), Q!())
DECLARE SUB InpY (YM!, t!(), Y0!(), Y1!())
DECLARE SUB CalcSC (W1!, t!, t!(), Y0!(), Y1!(), A!(), B!())
DECLARE SUB LTest ()
'$DYNAMIC
CALL PrName
LOCATE 12, 24: INPUT "Run control test (Y/N)"; F$
IF F$ = "Y" OR F$ = "y" THEN
  N = 2: F$ = "Y": CALL LTest
ELSE
  CLS : INPUT "Input number of points Ny="; N
END IF
DIM A(1), B(1), G(1), Q(1), G1(1), Q1(1), t(N), Y0(N), Y1(N)
IF F$ = "Y" THEN
  t(1) = .000001: Y0(1) = 1: Y1(0) = 1: Y1(1) = 0
ELSE
  CALL InpY(YM, t(), Y0(), Y1())
END IF
IF F$ = "Y" THEN
  t = .000004: F = 250000: YM = 1
ELSE
  INPUT "Input global time T="; t
  INPUT "Input frequency f1="; F
END IF
W1 = 6.283185 * F
ChangeM:
IF F$ = "Y" THEN
  M = 10
ELSE
 CLS : INPUT "Input number of harmonics Mf="; M
END IF
ERASE A, B, G, Q, G1, Q1
DIM A(M), B(M), G(M), Q(M), G1(M), Q1(M)
CALL CalcSC(W1, t, t(), Y0(), Y1(), A(), B())
CALL Transl(A(), B(), G(), Q())
CALL ResF(G1(), Q1())
IF F$ <> "Y" THEN
 INPUT "Input Amplitude-Frequency Characteristic (Y/N)"; M$
 IF M$ = "Y" OR M$ = "y" THEN CALL InpF(G1(), Q1())
END IF
DO
  CALL ResMenu
  LOCATE 18, 24: INPUT "Input option number "; M$
  IF M$ = "1" THEN CALL SARes(F, t, CG, G(), Q())
  IF M$ = "2" THEN CALL SAPrint(F, t, CG, G(), Q())
  IF M$ = "3" THEN
    CALL GY(t, YM, W1, G(), Q(), G1(), Q1()): CALL CopyScr
    CALL GYF(t, YM, t(), Y0(), Y1()): CALL CopyScr
  END IF
  IF M$ = "4" THEN CALL GMQ(F, t, G(), Q())
  IF M$ = "5" THEN
     CALL GYA(t, YM): CALL GYF(t, YM, t(), Y0(), Y1())
     CALL CopyScr
  END IF
  IF M$ = "6" THEN CALL CalcYT(W1, G(), Q(), G1(), Q1())
  IF M$ = "7" THEN F$ = "N": GOTO ChangeM
  IF M$ = "8" THEN END
LOOP

REM $STATIC
SUB CalcSC (W1, t, t(), Y0(), Y1(), A(), B())
'Calculate sine-cosine Fourier coefficients
  DEFINT I, K, M-N
  N = UBOUND(t): M = UBOUND(A)
  T0 = t(0): Y0 = Y1(0)
  FOR I = 1 TO N - 1
    T1 = t(I): Y1 = Y0(I): Y2 = Y1(I): Y = Y1 - Y0
    FOR K = 1 TO M
      X0 = W1 * K * T0: X1 = W1 * K * T1: Z = W1 * t / 2
      X2 = Y / (X1 - X0): D = Z * K
      S0 = SIN(X0): S1 = SIN(X1)
      C0 = COS(X0): C1 = COS(X1)
      A(K) = A(K) + (Y1 * S1 - Y0 * S0 + X2 * (C1 - C0)) / D
      B(K) = B(K) + (Y0 * C0 - Y1 * C1 + X2 * (S1 - S0)) / D
    NEXT K
    A(0) = A(0) + (T1 - T0) * (Y0 + Y1) / 2 / t
    Y0 = Y2: T0 = T1
  NEXT I
END SUB

DEFSNG I, K, M-N
SUB CalcYT (W1, G(), Q(), G1(), Q1())
'Calculate y(t)
  CLS
  DO
    INPUT "Input t(or E for end)"; M$
    IF M$ = "E" OR M$ = "e" THEN EXIT DO
    TI = VAL(M$)
    PRINT "y(t)="; YT(W1, TI, G(), Q(), G1(), Q1())
  LOOP
END SUB

SUB CopyScr
LSTART:
M$ = INPUT$(1)
  IF M$ = "C" OR M$ = "c" THEN GOSUB CS: GOTO LSTART
GOTO LEND
CS: 'Copying screen for 640*350 pixels (turbo-mode)
  DEF SEG = &HB000
  OPEN "LPT1:" FOR RANDOM AS #1: WIDTH #1, 255
  PRINT #1, CHR$(27); "3"; CHR$(24);
  FOR Y% = 0 TO 348 STEP 8: PRINT #1, CHR$(24)
    PRINT #1, CHR$(27); "*"; CHR$(4); CHR$(128); CHR$(2);
    Y1% = Y% + 1: Y2% = Y% + 2: Y3% = Y% + 3: Y4% = Y% + 4
    Y5% = Y% + 5: Y6% = Y% + 6: Y7% = Y% + 7
    FOR X% = 0 TO 639
     A% = SGN(POINT(X%, Y7%)): IF Y7% > 350 THEN A% = 0
     IF POINT(X%, Y6%) <> 0 AND Y6% < 349 THEN A% = A% + 2
     IF POINT(X%, Y5%) <> 0 THEN A% = A% + 4
     IF POINT(X%, Y4%) <> 0 THEN A% = A% + 8
     IF POINT(X%, Y3%) <> 0 THEN A% = A% + 16
     IF POINT(X%, Y2%) <> 0 THEN A% = A% + 32
     IF POINT(X%, Y1%) <> 0 THEN A% = A% + 64
     IF POINT(X%, Y%) <> 0 THEN A% = A% + 128
     PRINT #1, CHR$(A%);
    NEXT: PRINT #1, CHR$(10)
  NEXT: DEF SEG = 0: CLOSE #1
RETURN
LEND:
END SUB

SUB GMQ (F, t, G(), Q())
'Drawing spectrograms of module Mi and phase Qi
  DEFINT K, M: M = UBOUND(G)
  CLS : SCREEN 9: LINE (38, 5)-(38, 185): LINE -(638, 185)
  LINE (38, 195)-(38, 335): LINE (38, 265)-(638, 265)
  FOR K = 98 TO 638 STEP 60
    LINE (K, 186)-(K, 187): LINE (K, 266)-(K, 267)
  NEXT
  FOR K = 5 TO 185 STEP 30
    LINE (36, K)-(37, K)
  NEXT
  FOR K = 195 TO 335 STEP 35
    LINE (36, K)-(37, K)
  NEXT
  LOCATE 1, 13: PRINT "GRAPHS Si/S1 AND Qi"
  LOCATE 15, 77: PRINT M; : LOCATE 15, 42: PRINT INT(M / 2)
  LOCATE 14, 4: PRINT "0": LOCATE 20, 4: PRINT "0"
  LOCATE 22, 2: PRINT "-90": LOCATE 24, 1: PRINT "-180";
  LOCATE 17, 3: PRINT "90"
  LOCATE 15, 2: PRINT "180": LOCATE 3, 2: PRINT "1.0"
  LOCATE 11, 2: PRINT "0.2": LOCATE 7, 2: PRINT "0.6"
  DX = 600 / M: DY = 158.33 / G(1): DYQ = 22.28
  LOCATE 1, 37: PRINT "S1="; G(1) * t / 2; "  f1="; F
  PSET (38, 185 - 2 * ABS(G(0)) * DY), 11
  FOR K = 1 TO M
    X = 38 + K * DX: Y = 185 - G(K) * DY
    LINE -(X, Y), 12: LINE (X, 185)-(X, Y), 12
    LINE (X, 265)-(X, 265 - Q(K) * DYQ), 13: PSET (X, Y), 12
  NEXT K
  CALL CopyScr: CLS
END SUB

DEFSNG K, M
SUB GY (t, YM, W1, G(), Q(), G1(), Q1())
'Drawing function y(t)
  DEFINT I, K, M-N: M = UBOUND(G)
  CLS : INPUT "Input number of graphics points Ng="; NG
  CALL GYA(t, YM)
  DT = t / NG: DX = 600 / NG: DY = 160 / YM
  FOR I = 0 TO NG
    V = I * DT
    Y = YT(W1, V, G(), Q(), G1(), Q1()): X = 20 + I * DX
    IF I = 0 THEN
      PSET (X, 180 - Y * DY), 12
    ELSE
      LINE -(X, 180 - Y * DY), 12
    END IF
  NEXT I
  LOCATE 1, 50: PRINT "  M="; M; "   Ng="; NG;
END SUB

DEFSNG I, K, M-N
SUB GYA (t, YM)
'Drawing axis for y(t/T)
DEFINT K: SCREEN 9: CLS
  LOCATE 13, 2: PRINT "0"
  LOCATE 2, 2: PRINT "1";
  LOCATE 1, 1: PRINT "Y/Ym"
  LOCATE 25, 1: PRINT "-1";
  LOCATE 14, 40: PRINT ".5"
  LOCATE 14, 78: PRINT "1"
  LOCATE 15, 76: PRINT "t/T"
  LOCATE 1, 25: PRINT "Ymax="; YM; "  T="; t;
  LINE (20, 20)-(20, 340): LINE (20, 180)-(620, 180)
  FOR K = 20 TO 620 STEP 60
    LINE (K, 181)-(K, 182)
  NEXT
  FOR K = 20 TO 340 STEP 32
    LINE (18, K)-(19, K)
  NEXT
END SUB

DEFSNG K
SUB GYF (t, YM, t(), Y0(), Y1())
'Drawing basic y(t)
 DEFINT I, N: N = UBOUND(t)
  KY = 160 / YM: DX = 600 / t
  FOR I = 0 TO N - 1
    X = DX * t(I) + 20
    IF I = 0 THEN
      PSET (X, 180 - Y1(0) * KY), 11
    ELSE
      LINE -(X, 180 - Y0(I) * KY), 11
      LINE -(X, 180 - Y1(I) * KY), 11
    END IF
  NEXT I
END SUB

DEFSNG I, N
SUB InpF (G1(), Q1())
'Input Amplitude-Frequency characteristics
  DEFINT K, M: M = UBOUND(G1)
  FOR K = 0 TO M
    IF K = 0 THEN INPUT "Input G 0="; G1(0)
    IF K > 0 THEN
      PRINT "Input G"; K; ", Q"; K; "deg  ";
      INPUT G1(K), Q: Q1(K) = .0174533 * Q
    END IF
  NEXT
END SUB

DEFSNG K, M
SUB InpY (YM, t(), Y0(), Y1())
'Input jump for basic y(t)
  DEFINT I, N: N = UBOUND(t)
  INPUT "Input t 0 , F(t+0)="; T0, Y0
  t(0) = T0: Y1(0) = Y0
  YM = 0: IF ABS(Y0) > YM THEN YM = ABS(Y0)
  FOR I = 1 TO N - 1
    PRINT "Input t"; I; ", F(t-0) , F(t+O) =";
    INPUT T1, Y1, Y2: Y = Y1 - Y0
    t(I) = T1: Y0(I) = Y1: Y1(I) = Y2
    IF ABS(Y1) > YM THEN YM = ABS(Y1)
    IF ABS(Y2) > YM THEN YM = ABS(Y2)
  NEXT
END SUB

DEFSNG I, N
SUB LTest
'Displaying control test
  CLS : PRINT "CONTROL TEST:"
  PRINT "Calculating spectrum for a square impulse"
  PRINT "with jump 0,1 for t 0 = 0 and"
  PRINT "jump 1,0 for t 1 = 1e-6 sec."
  PRINT : PRINT "INPUT EXAMPLE:"
  PRINT "Input number of points N= 2"
  PRINT "Input t 0, F(t+0)? 0,1"
  PRINT "Input t 1, F(t-0), F(t+0)? 1e-6,1,0"
  PRINT "Input global time T=? 4e-6"
  PRINT "Input frequency f1=? 250000"
  PRINT "Input number of harmonics M= 10"
  PRINT : PRINT "For graphics CopyScreen"
  PRINT "press key C, for menu press Q"
  PRINT "Press any key to continue!"
  M$ = INPUT$(1)
END SUB

SUB PrName
'Displaying program title
SCREEN 0: KEY OFF: CLS : LOCATE 5, 15
PRINT "PARALLEL SPECTRAL ANALYSIS AND TRIGONOMETRIC"
LOCATE 6, 18: PRINT "INTERPOLATION WITH GRAPHICS OUTPUT"
LOCATE 7, 21: PRINT "FOR PIECEWISE LINEAR FUNCTIONS"
LOCATE 8, 22: PRINT "V.P. Djakonov 1994 Smolensk"
LOCATE 9, 25: PRINT "(c)1995 Wrox Press Ltd.": PRINT
END SUB

SUB ResF (G1(), Q1())
'Initial array G1 and Q1
  DEFINT K, M: M = UBOUND(G1)
  FOR K = 0 TO M
    G1(K) = 1: Q1(K) = 0
  NEXT
END SUB

DEFSNG K, M
SUB ResMenu
'Displaying options menu
  SCREEN 0: CLS
  LOCATE 5, 28: PRINT " OPTIONS MENU"
  LOCATE 7, 28: PRINT "1 Display results"
  LOCATE 8, 28: PRINT "2 Print results"
  LOCATE 9, 28: PRINT "3 Drawing y(t)"
  LOCATE 10, 28: PRINT "4 Spectrogram G,Q"
  LOCATE 11, 28: PRINT "5 Drawing F(t)"
  LOCATE 12, 28: PRINT "6 Calculate y(t)"
  LOCATE 13, 28: PRINT "7 Set M garmonics"
  LOCATE 14, 28: PRINT "8 End of work"
END SUB

SUB SAPrint (F, t, CG, G(), Q())
'Print results
  DEFINT K, M: M = UBOUND(G)
  CLS : LPRINT " f             M(f)             ";
    LPRINT "S(f)             Q(f),DEG"
    LPRINT " 0"; : LPRINT TAB(15); G(0);
    LPRINT TAB(32); G(0) * t: M = UBOUND(G): E = 0
    FOR K = 1 TO M
      IF K = 1 THEN G1 = G(1)
      IF K > 1 THEN E = E + G(K) * G(K)
      LPRINT F * K; : LPRINT TAB(15); G(K);
      LPRINT TAB(32); G(K) * t / 2;
      LPRINT TAB(50); Q(K) * 57.29578
    NEXT K
    CG = SQR(E) / G1: LPRINT "Kg="; CG
END SUB

DEFSNG K, M
SUB SARes (F, t, CG, G(), Q())
'Displaying results
  DEFINT K, M: M = UBOUND(G)
  CLS : PRINT " f             M(f)             ";
    PRINT "S(f)             Q(f),DEG"
    PRINT " 0"; : PRINT TAB(15); G(0);
    PRINT TAB(32); G(0) * t: M = UBOUND(G): E = 0
    FOR K = 1 TO M
      IF K = 1 THEN G1 = G(1)
      IF K > 1 THEN E = E + G(K) * G(K)
      PRINT F * K; : PRINT TAB(15); G(K);
      PRINT TAB(32); G(K) * t / 2;
      PRINT TAB(50); Q(K) * 57.29578
    NEXT K
    CG = SQR(E) / G1: PRINT "Kg="; CG
    F$ = INPUT$(1)
END SUB

DEFSNG K, M
SUB Transl (A(), B(), G(), Q())
'Translating sine-cosine coefficients
 DEFINT K, M: M = UBOUND(A): G(0) = A(0)
 FOR K = 1 TO M
    G(K) = SQR(A(K) * A(K) + B(K) * B(K))
    IF G(K) > .0000001 THEN
      QQ = A(K) / G(K)
      Q = -1.570796 + ATN(QQ / SQR(1 - QQ * QQ + 1E-35))
      IF B(K) < 0 THEN Q = -Q
      Q(K) = Q
    ELSE
      Q(K) = 0
    END IF
 NEXT
END SUB

DEFSNG K, M
FUNCTION YT (W1, t, G(), Q(), G1(), Q1())
'Calculate Y=f(t)
  IF G1(0) = 1 THEN Y = G(0) ELSE Y = G(0) * G1(0)
  P = W1 * t
  FOR K% = 1 TO UBOUND(G)
    IF G1(K%) = 1 THEN G = G(K%) ELSE G = G(K%) * G1(K%)
    IF Q1(K%) = 0 THEN Q = Q(K%) ELSE Q = Q(K%) + Q1(K%)
    Y = Y + G * COS(P * K% + Q)
  NEXT K%
  YT = Y
END FUNCTION

