'Program SWJT for Q, Quick, and Turbo-Basic Compiler
  'Head Module
  SCREEN 0: DIM F(20, 20)
  ON ERROR GOTO WorkError
Menu:
  'Main menu output
  CLS : LOCATE 1, 28: PRINT "Switch on Powerful FET"
  LOCATE 2, 28: PRINT "Transient Analysis"
  LOCATE 3, 23: PRINT "with Spline VAC Approximation"
  LOCATE 4, 25: PRINT "V.P.Djakonov 1994 Smolensk"
  LOCATE 6, 30: PRINT "Main Menu:"
  LOCATE 8, 28: PRINT "<1>  Graphics VAC"
  LOCATE 9, 28: PRINT "<2>  Graphics U(t)"
  LOCATE 10, 28: PRINT "<3>  Calculate Id=(Ud,Ug)"
  LOCATE 11, 28: PRINT "<4>  Load  circuit"
  LOCATE 12, 28: PRINT "<5>  Input circuit"
  LOCATE 13, 28: PRINT "<6>  Save, correction"
  LOCATE 14, 28: PRINT "<7>  Quit in MS-DOS"
  LOCATE 16, 29: PRINT "Press key <1>...<7>"
  X$ = INPUT$(1)
  IF X$ = "3" THEN GOSUB CalcId: GOTO Menu
  IF X$ = "1" THEN GOSUB GraphVAC: GOTO Menu
  IF X$ = "2" THEN GOSUB GraphU: GOTO Menu
  IF X$ = "4" THEN CLS : GOSUB LoadFile: GOTO Menu
  IF X$ = "5" THEN GOSUB InpCircuit: GOTO Menu
  IF X$ = "6" THEN GOTO CorMenu
  IF X$ = "7" THEN END
GOTO Menu

InpCircuit:
  'Entering circuit data
  CLS : F1 = 0
  INPUT "Input Mcurve,Npoint "; M, N
  INPUT "Input Udmin,Ugmin "; A, B
  INPUT "Input dUd,dUg "; H, L
  XM = A + H * M: YM = B + L * (N - 1)
  FOR I = 1 TO N
    FOR J = 1 TO M + 1
      PRINT "Input F("; I; ","; J; ") ";
      INPUT F(I, J): IF F1 < F(I, J) THEN F1 = F(I, J)
    NEXT J
  NEXT I
  PRINT : INPUT "Input  C11,C12,C22 "; CC, C2, C3
  INPUT "Input  A,B,C,D "; A1, B1, C1, D1
  INPUT "Input Ed,Rd,Ld,Ri "; EC, RC, LC, R3
  INPUT "Input  Um,T,Ti  "; V1, T1, TI
  INPUT "Input  H,MG,MU  "; HI, MG, MU
  PRINT : INPUT "Save data (Y/N) "; A$
  IF A$ = "Y" OR A$ = "y" THEN GOSUB SaveFile
RETURN

CalcId:
  'Test calculations of Id(Ud,Ug) by specified Ud and Ug
  CLS
  INPUT "Input  Ud,Ug "; X, Y
  GOSUB CalcZ
  PRINT "Id(Ud,Ug)="; Z
  F$ = INPUT$(1)
RETURN

CalcZ:
  'Calculate Z=Id(Ud,Ug) using two-dimensional
  'square approximation
  IF X < 0 OR Y < B THEN Z = 0: RETURN
  IF X > XM THEN X = XM - .0001
  IF Y > YM THEN Y = YM - .0001
  J = INT((X - A) / H): IF J <= 0 THEN J = 1
  I = INT((Y - B) / L): IF I <= 0 THEN I = 1
  P = (X - A - J * H) / H: Q = (Y - B - I * L) / L
  P2 = P * P: Q2 = Q * Q
  I = I - 1: GOSUB C1: C = Z
  I = I + 2: GOSUB C1: E = Z
  I = I - 1: GOSUB C1: D = Z
  Z = ((Q2 - Q) * C + (Q2 + Q) * E) / 2 + (1 - Q2) * D
RETURN
C1:
  Z = ((P2 - P) * F(I + 1, J) + (P2 + P) * F(I + 1, J + 2)) / 2
  Z = Z + (1 - P2) * F(I + 1, J + 1)
RETURN

GraphVAC:
  'Plotting family of output VAC
  'of powerful field-effect transistor
  CLS : INPUT "Input Mgraph,MUd "; W, X3
  CLS : SCREEN 9
  LOCATE 25, 40: PRINT ".5"; : LOCATE 25, 73: PRINT "Ud  1";
  LOCATE 25, 2: PRINT "0";
  LOCATE 1, 1: PRINT "Id    MUd="; X3; "   MId=";
  PRINT USING "###.###"; F1
  LOCATE 2, 1: PRINT "1": LOCATE 13, 1: PRINT ".5"
  X2 = 680 / W: GOSUB AxisGraph
  FOR K = 1 TO N
    Y1 = 180 * F(K, 1): PSET (27, 334 - Y1)
    FOR T = 2 TO W
      X = A + T * X3 / (W + 1): IF T = W + 1 THEN X = X - .00001
      Y = B + (K - 1) * L: Y2 = Y: IF K = N THEN Y = Y - .00001
      GOSUB CalcZ: Y = 180 * Z / F1
      LINE -(X2 * (T - 1) * .88 + 27, (190 - Y) * 1.76), 10
    NEXT T
    LOCATE 25 - (Y + 8) / 8.25, 78: PRINT INT(Y2);
  NEXT K
GV:
  M$ = INPUT$(1)
  IF M$ = "C" OR M$ = "c" THEN GOSUB CopyScr: GOTO GV
SCREEN 0
RETURN

GraphU:
  'Plotting voltage of input signal source, drain voltage,
   'and gate voltage
  X2 = 650 / MG: X1 = 0
  CLS : SCREEN 9: GOSUB AxisGraph
  LOCATE 25, 2: PRINT "0";
  LOCATE 22, 14: PRINT "Ug"
  LOCATE 24 - (10 + V1 * 9) / 9, 14: PRINT "Ui"
  H2 = HI * MG + 1E-15
  LOCATE 1, 18: PRINT "MUd="; MU; "  MUg,Ui="; MU / 2; "  MT=";
  PRINT USING "#.###^^^^"; H2
  LOCATE 3, 14: PRINT "Us"
  LOCATE 25, 40: PRINT ".5"; : LOCATE 25, 76: PRINT "1";
  LOCATE 13, 1: PRINT ".5": LOCATE 2, 2: PRINT "1";
  W(1) = 0: W(2) = EC: W(3) = 0
  M1 = 320 / MU: M2 = 2 * M1: H1 = HI * .5

StartAnalysis:
  'Setting initial conditions
  Y(1) = W(1): Y(2) = W(2): Y(3) = W(3): O5 = 0
SA:
  'Implementation of Runge-Kutta method of fourth order
  O5 = O5 + 1: GOSUB CalcUi
  W1 = HI * P(1): W2 = HI * P(2): W3 = HI * P(3)
  W4 = .5 * W1: W5 = .5 * W2: W6 = .5 * W3
  W7 = W1 + W1: W8 = W2 + W2: W9 = W3 + W3
  K(1) = W1: Y(1) = W(1) + W4: K(2) = W2
  Y(2) = W(2) + W5: K(3) = W3: Y(3) = W(3) + W6
  X1 = X1 + H1: GOSUB CalcUi
  K(1) = K(1) + W7: Y(1) = W(1) + W4
  K(2) = K(2) + W8: Y(2) = W(2) + W5
  K(3) = K(3) + W9: Y(3) = W(3) + W6
  GOSUB CalcUi
  K(1) = K(1) + W7: Y(1) = W(1) + W1
  K(2) = K(2) + W8: Y(2) = W(2) + W2
  K(3) = K(3) + W9: Y(3) = W(3) + W3
  X1 = X1 + H1: GOSUB CalcUi
  Y(1) = W(1) + (K(1) + W1) / 6
  Y(2) = W(2) + (K(2) + W2) / 6
  Y(3) = W(3) + (K(3) + W3) / 6
  W(1) = Y(1): W(2) = Y(2): W(3) = Y(3)
  'Set point for graphics Ui
  X3 = 30 + O5 * X2: PSET (X3 * .88, 334 - Y(1) * M2), 13
  PSET (X3 * .88, 334 - Y(2) * M1), 10
  PSET (X3 * .88, 334 - U1 * M2), 14
  IF X3 < 685 THEN GOTO SA
SB:
  M$ = INPUT$(1)
  IF M$ = "C" OR M$ = "c" THEN GOSUB CopyScr: GOTO SB
CLS : SCREEN 0
RETURN

CalcUi:
  'Calculating Ui at each i-th step of transient
  U1 = V1
  IF X1 <= TI AND T1 <> 0 THEN UI = V1 * (1 - EXP(-X1 / T1))
  U1 = UI
  'Calculating parameters of model at step of analysis
  IF X1 > TI AND T1 <> 0 THEN U1 = UI * EXP(-(X1 - TI) / T1)
  IF X1 > TI AND T1 = 0 THEN U1 = 0
  C4 = C2: IF A1 <> 0 THEN C4 = C2 + A1 * EXP(-B1 * Y(2))
  C5 = C3: IF C1 <> 0 THEN C5 = C3 + C1 * EXP(-D1 * Y(2))
  I1 = (U1 - Y(1)) / R3: C0 = (1 / C4 + 1 / C5 + 1 / CC)
  X = Y(2): Y = Y(1): Z = 0: IF Y > B THEN GOSUB CalcZ
  I2 = ((Y(3) - Z) / C5 - I1 / CC) / C0: I3 = Y(3) - Z - I2
  P(1) = (I1 + I2) / CC: P(2) = I3 / C5
  P(3) = (EC - Y(3) * RC - Y(2)) / LC
RETURN

SaveFile:
  'Saving circuit file into the current directory
  CLS : INPUT "Input file name "; N$
  OPEN N$ + ".ASW" FOR OUTPUT AS #1
  WRITE #1, M, N, A, B, H, L, F1
  FOR I = 1 TO N
    FOR J = 1 TO M + 1
    WRITE #1, F(I, J)
  NEXT J, I
  WRITE #1, CC, C2, C3, A1, B1, C1, D1
  WRITE #1, EC, RC, LC, R3, V1, T1, TI, HI, MG, MU
  CLOSE #1
RETURN

LoadFile:
  'Reading circuit file from current directory
  INPUT "Input file name <ENTER for catalog>"; N$
  IF N$ = "" THEN CLS : FILES "*.ASW": GOTO LoadFile
  OPEN N$ + ".ASW" FOR INPUT AS #1
  INPUT #1, M, N, A, B, H, L, F1
  FOR I = 1 TO N
    FOR J = 1 TO M + 1
      INPUT #1, F(I, J)
  NEXT J, I
  INPUT #1, CC, C2, C3, A1, B1, C1, D1
  INPUT #1, EC, RC, LC, R3, V1, T1, TI, HI, MG, MU
  CLOSE #1: XM = A + H * M: YM = B + L * (N - 1)
RETURN

CorMenu:
  'Outputting and managing Corrections Menu
  CLS : LOCATE 5, 26: PRINT "Data Save and Correction"
  LOCATE 7, 25: PRINT "<1> Correction circuit data"
  LOCATE 8, 25: PRINT "<2> Correction VAC data"
  LOCATE 9, 25: PRINT "<3> Save circuit data"
  LOCATE 10, 25: PRINT "<4> Return to main menu"
  LOCATE 12, 26: PRINT "Press key <1>...<4>"
DO
  P$ = INPUT$(1)
  IF P$ = "1" THEN GOTO CorData
  IF P$ = "2" THEN GOTO DataVAC
  IF P$ = "3" THEN GOSUB SaveFile: GOTO CorMenu
  IF P$ = "4" THEN GOTO Menu
LOOP

CorData:
  'Correcting circuit data
  CLS : LOCATE 1, 21: PRINT "Circuit data:": PRINT
  PRINT "C11="; : PRINT USING "#.##^^^^"; CC;
  PRINT "  C12="; : PRINT USING "#.##^^^^"; C2;
  PRINT "  C22="; : PRINT USING "#.##^^^^"; C3
  PRINT "A="; : PRINT USING "#.##^^^^"; A1;
  PRINT "    B="; : PRINT USING "#.##^^^^"; B1;
  PRINT "    C="; : PRINT USING "#.##^^^^"; C1;
  PRINT "    D="; : PRINT USING "#.##^^^^"; D1
  PRINT "Es="; EC, "Rs="; RC, "Ri="; R3,
  PRINT "Ls="; : PRINT USING "#.##^^^^"; LC
  PRINT "Um="; V1, : PRINT "T=";
  PRINT USING "#.##^^^^"; T1;
  PRINT "    Ti="; : PRINT USING "#.##^^^^"; TI;
  PRINT "   H="; : PRINT USING "#.##^^^^"; HI
  PRINT "MG="; MG, "MU="; MU: PRINT : PRINT
  INPUT "Data correction (Y/N) "; W$
  IF W$ = "Y" OR W$ = "y" THEN GOTO CD1
  GOTO CorMenu
CD1:
  INPUT "Input name of element "; S$
  IF S$ = "C11" THEN
    PRINT "C11="; : PRINT USING "#.##^^^^"; CC;
    INPUT CC: GOTO CorData
  END IF
  IF S$ = "C12" THEN
    PRINT "C12="; : PRINT USING "#.##^^^^"; C2;
    INPUT C2: GOTO CorData
  END IF
  IF S$ = "C22" THEN
    PRINT "C22="; : PRINT USING "#.##^^^^"; C3;
    INPUT C3: GOTO CorData
  END IF
  IF S$ = "A" THEN
    PRINT "A="; : PRINT USING "#.##^^^^"; A1;
    INPUT A1: GOTO CorData
  END IF
  IF S$ = "B" THEN
    PRINT "B="; : PRINT USING "#.##^^^^"; B1;
    INPUT B1: GOTO CorData
  END IF
  IF S$ = "C" THEN
    PRINT "C="; : PRINT USING "#.##^^^^"; C1;
    INPUT C1: GOTO CorData
  END IF
  IF S$ = "D" THEN
    PRINT "D="; : PRINT USING "#.##^^^^"; D1;
    INPUT D1: GOTO CorData
  END IF
  IF S$ = "Es" THEN
    PRINT "Es="; EC, : INPUT EC: GOTO CorData
  END IF
  IF S$ = "Rs" THEN PRINT "Rs="; RC, : INPUT RC: GOTO CorData
  IF S$ = "Ri" THEN PRINT "Ri="; R3, : INPUT R3: GOTO CorData
  IF S$ = "Ls" THEN
    PRINT "Ls="; : PRINT USING "#.##^^^^"; LC;
    INPUT LC: GOTO CorData
  END IF
  IF S$ = "Um" THEN PRINT "Um="; V1, : INPUT V1: GOTO CorData
  IF S$ = "T" THEN
    PRINT "T="; : PRINT USING "#.##^^^^"; T1;
    INPUT T1: GOTO CorData
  END IF
  IF S$ = "Ti" THEN
    PRINT "Ti="; : PRINT USING "#.##^^^^"; TI;
    INPUT TI: GOTO CorData
  END IF
  IF S$ = "H" THEN
    PRINT "H="; : PRINT USING "#.##^^^^"; HI;
    INPUT HI: GOTO CorData
  END IF
  IF S$ = "MG" THEN PRINT "MG="; MG, : INPUT MG: GOTO CorData
  IF S$ = "MU" THEN PRINT "MU="; MU, : INPUT MU: GOTO CorData
GOTO CD1

DataVAC:
  'Inputting and correcting VAC data
  CLS : LOCATE 1, 22: PRINT "Data VAC:": PRINT
  PRINT "        Us min ="; A, " dUs ="; H
  PRINT "        Ug min ="; B, " dUg ="; L
  FOR I = 1 TO N: FOR J = 1 TO M + 1
  PRINT "        F("; I; ","; J; ")=";
  PRINT USING "##.##"; F(I, J);
  NEXT J, I: PRINT : PRINT
  INPUT "Correct VAC (Y/N) "; W$
  IF W$ = "Y" OR W$ = "y" THEN GOTO DV
  GOTO CorMenu
DV:
  CLS : F1 = 0: INPUT "Input M,N "; M, N
  INPUT "Input Usmin,Ug min "; A, B
  INPUT "Input dUs,dUg "; H, L
  XM = A + H * M: YM = B + L * (N - 1)
  FOR I = 1 TO N
    FOR J = 1 TO M + 1
      PRINT "Input Is("; I; ","; J; ") ";
      INPUT F(I, J): IF F1 < F(I, J) THEN F1 = F(I, J)
  NEXT J, I
GOTO DataVAC

CopyScr:
  'Copying screen by Epson-compatible printer
  DEF SEG = &HB000
  OPEN "LPT1:" FOR RANDOM AS #1
  WIDTH #1, 255: PRINT #1, CHR$(27); "3"; CHR$(24);
  FOR Y% = 0 TO 348 STEP 8: PRINT #1, CHR$(24);
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
   NEXT
   PRINT #1, CHR$(10)
  NEXT: DEF SEG = 0: CLOSE #1
RETURN

AxisGraph:
  'Plotting coordinate axes
  LINE (27, 14)-(27, 334): LINE -(607, 334)
  FOR O = 27 TO 607 STEP 58
    LINE (O, 332)-(O, 333)
  NEXT
  FOR O = 14 TO 334 STEP 32
    LINE (28, O)-(30, O)
  NEXT
RETURN

WorkError:
   'Error processing
   IF ERR <> 53 THEN RUN
   PRINT "File not found !"
   PRINT "Press any key for main menu !": M$ = INPUT$(1)
RUN

