'Programm ALCM for Q,Quick and Turbo-BASIC Compiler
 'Head Module of program
 ON ERROR GOTO WorkError
DataF:
  'Series of standard frequencies
  DATA 10,20,50,100,200,500,1e3,2e3,5e3
  DATA 1e4,2e4,5e4,1e5,2e5,5e5,1e6,2e6,5e6,1e7,0
KEY OFF: SCREEN 0
  Y = 30: C = 100: ' Y=Nnodes,C=Ncomponents max
  C0 = 0: C1 = 1: C2 = 2: C3 = 3: C4 = 4: C5 = 5
  C6 = 6: C7 = 7: C8 = 8: C10 = 10: C20 = 20
  C26 = 26: C28 = 28: C90 = 90: CDB = 8.685889599999999#
  DIM W(51, C3), C$(C, C4), C(C, C6), D(C), A(Y, Y), B(Y, Y)
  DIM P(Y, Y), Q(Y, Y), R(Y, Y), F(51), B$(C1, C4), Q$(C4, C10)
DO
  GOSUB Menu
  GOSUB ConvSubr
  GOSUB ListComp
  GOSUB ComplMat
LOOP

ListComp:
  'Displaying components sheet
  CLS : PRINT "Circuit "; N$
  FOR A% = C1 TO C: IF C$(A%, C1) = "" THEN GOTO LC2
  LS% = C(A%, C6): PRINT : PRINT C$(A%, C1);
    FOR B% = C1 TO C5
      IF C(A%, B%) = C0 AND B% > LS% THEN GOTO LC1
      ML = B% * C5
      IF B% > C3 AND LS% = C0 THEN ML = (B + C1) * C5
      PRINT TAB(ML); : T = C(A%, B%)
      IF T - INT(T) = 0 THEN
      PRINT T;
      ELSE PRINT USING " #.##^^^^"; T + 1E-12;
    END IF
LC1: NEXT B%
LC2: NEXT A%: PRINT : PRINT : RETURN
InpContr:
  CH = C0
  FOR S% = C1 TO NB - C1
    FOR O% = S% + C1 TO NB
      IF C(Z%, S%) = C(Z%, O%) THEN
        IF NB <> C2 THEN GOSUB IC: CH = C1
      END IF
    NEXT O%
  NEXT S%
  FOR S% = C1 TO NB
    IF C(Z%, S%) < C1 OR C(Z%, S%) > Y THEN
      PRINT "Incorrect input!": CH = C1
    END IF
  NEXT S%
  RETURN
IC:
  IF CH = C1 THEN RETURN
  PRINT "Error nodes (no difference)!"
RETURN

ComplMat:
  'Forming complex matrix
  NB = C3: Z = C: GOSUB InpContr: IF CH = C1 THEN RETURN
  PRINT "Please wait !"
  ERASE P, Q, R: DIM P(Y, Y), Q(Y, Y), R(Y, Y)
  N = C0: Z = N: K = C1
RET:
DO
  Z = Z + C1: Z$ = LEFT$(C$(Z, C1), C1): L = C1
  IF Z$ = "R" THEN GOTO R: 'Resistor
  IF Z$ = "C" THEN GOTO C: 'Capacitor
  IF Z$ = "L" THEN GOTO L: 'Inductor
  IF Z$ = "A" THEN GOTO A: 'Amplifier
  IF Z$ = "F" THEN GOTO F: 'Field-Effect Transistor
  IF Z$ = "Q" THEN GOTO Q: 'Bipolar Transistor
  IF Z$ = "T" THEN GOTO T: 'Transformer
  IF Z$ = "P" THEN GOTO StartAnalysis: 'Input-Output Port
LOOP

'Block of math models of components
R: I = C(Z, C1): J = C(Z, C2): V = C(Z, C3): GOSUB ProcConv
   V = C1 / V: GOSUB PIsum: V = 2E-13: GOSUB Qsum: GOTO RET
C: I = C(Z, C1): J = C(Z, C2): V = C(Z, C3)
   GOSUB ProcConv: GOSUB Qsum: GOTO RET
L: I = C(Z, C1): J = C(Z, C2): V = C(Z, C3)
   GOSUB ProcConv: V = -C1 / V: GOSUB Rsum: GOTO RET
F: I = C(Z, C1): J = C(Z, C2): K = C(Z, C3): V = C(Z, C4)
   GOSUB ProcConv: GOSUB PKsum: GOTO RET
Q: IC = C(Z, C5): HF = C(Z, C4)
   RE = 27 / IC: RI = HF * RE: YI = C1 / RI
   YF = C1 / RE: RO = 10000! * SQR(RE): YO = C1 / RO
   CI = 7E-11: CF = 3E-12: CT = 5E-12
   I = C(Z, C1): J = C(Z, C2): K = C(Z, C3): GOSUB ProcConv
   V = YF: GOSUB PKsum: V = YI: J = K
   GOSUB PIsum: I = P: V = YO: GOSUB PIsum
   V = CF: GOSUB Qsum: J = K: V = CI: GOSUB Qsum
   V = CT: GOSUB Qsum: GOTO RET
A: CI = 2E-12: CD = 2E-12: RD = 1E+10
   RO = 100: UN = 3000000!: GA = 6.28318 * UN / RO
   I = C(Z, C1): J = C(Z, C2): K = C(Z, C3)
   V = C1 / RD: GOSUB ProcConv: GOSUB PIsum
   V = CD: GOSUB Qsum: J = C3: V = CI
   GOSUB Qsum: I = D: V = C1 / RO: GOSUB PIsum
   K = T: J = P: GOSUB RetSum: R(I, J) = R(I, J) - GA
   R(C3, J) = R(C3, J) + GA
   R(I, K) = R(I, K) + GA
   R(C3, K) = R(C3, K) - GA: GOTO RET
T: I = C(Z, C1): J = C(Z, C2)
   K = C(Z, C3): L = C(Z, C4): GOSUB ProcConv
   YK = C1: V = C(Z, C5): V = V * V * YK
   GOSUB PIsum: V = YK: I = D: J = LK: GOSUB PIsum
   V = V * C(Z, C5): P(D, P) = P(D, P) + V
   P(LK, T) = P(LK, T) + V: P(T, LK) = P(T, LK) + V
   P(P, D) = P(P, D) + V: P(T, D) = P(T, D) - V
   P(P, LK) = P(P, LK) - V
   P(D, T) = P(D, T) - V: P(LK, P) = P(LK, P) - V: GOTO RET

StartAnalysis:
  'Start of frequency analysis
  E = C(Z, C1): F = C(Z, C2)
  AMAX = -1.7E-38: AMIN = 1.7E+38: QM = 90
  PRINT "Nnodes="; N: DA = C0: A% = C0: RESTORE DataF
  PRINT "Node input="; E; "   output="; F
SA1: A% = A% + C1: READ F(A%)
  IF F(A%) = 0 THEN GOTO SA2 ELSE GOTO SA1
SA2: ST = F(C1): EN = F(A% - C1)
SA3:  INPUT "Input NFstep(-log) or Data"; W$: S$ = W$
  IF W$ = "" THEN S$ = "10": PRINT "NFstep= 10"
  IF W$ = "D" OR W$ = "d" THEN DG = C1: F2 = A% - C1: GOTO SA6
  DG = C0: SP = VAL(S$)
  IF ABS(SP) > 51 THEN PRINT "Nstep>51. Repeat input!": GOTO SA3
  F2 = ABS(SP): IF F2 < C2 THEN INPUT "Input F1="; ST: GOTO SA5
SA4: INPUT "Input frequencys Fstart,  Ffinish"; ST, EN
  IF ST < C0 OR EN <= C0 OR ST >= EN THEN
    PRINT "Incorrect input!": GOTO SA4
  END IF
  IF ST = C0 THEN ST = .1
  IF SP < C0 THEN DD = -((EN / ST) ^ (-C1 / (SP + C1)))
  IF SP > C1 THEN DD = (EN - ST) / (SP - C1)
SA5: IF SP = C0 OR SP = C1 THEN DD = C0
  F1 = ST: W1 = 6.28319 * F1
SA6: INPUT "Print results (Y/N) "; E$
  CLS : PRINT " F (HZ)      "; Y$; "      DB      Phase (DEG)"
  IF E$ = "Y" OR E$ = "y" THEN
    LPRINT " F (HZ)      "; Y$; "      DB      Phase (DEG)"
  END IF
  IF ABS(SP) > 20 THEN YM = C3
  FOR R% = C1 TO F2
    IF DG = C1 THEN F1 = F(R%)
    IF F1 = C0 THEN R% = 50: GOTO SA9
    W1 = 6.28319 * F1
    FOR K% = C1 TO N
      FOR L% = C1 TO N
        A(K%, L%) = P(K%, L%)
        B(K%, L%) = W1 * Q(K%, L%) + R(K%, L%) / W1
      NEXT L%
    NEXT K%: GOSUB Sub1
  FA = C0
  IF ABS(D1) < C1 AND ABS(D2) < C1 THEN
    FA = C1: D1 = D1 * 1E+17: D2 = D2 * 1E+17
  END IF
  B1 = SQR(D1 * D1 + D2 * D2)
  IF FA = C1 THEN
    D1 = D1 / 1E+17: D2 = D2 / 1E+17: B1 = B1 / 1E+17
  END IF
  IF D1 <> C0 THEN GOTO SA7
  IF D2 = C0 THEN D3 = C0: RETURN
  IF D2 > C0 THEN D3 = C90: RETURN
  D3 = -C90: GOTO SB
SA7: IF D1 < C0 THEN Q = 180 ELSE Q = C0
  IF D2 < C0 THEN Q = -Q
  D3 = Q + 57.29578 * ATN(D2 / D1)
SB:  V = B1: U = D3: IF U > 180 THEN U = U - 360
  IF U < -180 THEN U = U + 360
  W(R%, C1) = F1: W(R%, C2) = V
  W(R%, C3) = U: DB = CDB * LOG(V)
  IF AMAX < V THEN AMAX = V
  IF AMIN > V THEN AMIN = V
  IF ABS(U) > 95 THEN QM = 180
  PRINT USING "#.###^^^^"; F1;
  PRINT TAB(12); : PRINT USING "##.##^^^^"; V;
  PRINT TAB(24); : PRINT USING "####.##"; DB;
  PRINT TAB(34); : PRINT USING "####.##"; U
  IF E$ <> "Y" THEN GOTO SA8
  LPRINT USING "#.###^^^^"; F1;
  LPRINT TAB(12); : LPRINT USING "##.##^^^^"; V;
  LPRINT TAB(24); : LPRINT USING "####.##"; DB;
  LPRINT TAB(34); : LPRINT USING "####.##"; U
SA8: IF DG = C1 THEN GOTO SA9
  IF SP < C0 THEN F1 = -F1 * DD ELSE F1 = F1 + DD
SA9: NEXT R%
  IF SP = 1 THEN GOTO SA3
  PRINT "Graphics,Frequency or End ?": A$ = INPUT$(1)
  IF A$ = "G" OR A$ = "g" THEN GOSUB Graphics
  IF A$ = "F" OR A$ = "f" THEN CLS : GOSUB SA3
RETURN

'Matrix conversions and operations
PIsum:
  P(I, I) = P(I, I) + V: P(I, J) = P(I, J) - V
  P(J, I) = P(J, I) - V: P(J, J) = P(J, J) + V
RetSum:
  IF I > N THEN N = I
  IF J > N THEN N = J
  IF K > N THEN N = K
RETURN
Qsum:
  Q(I, I) = Q(I, I) + V: Q(I, J) = Q(I, J) - V
  Q(J, I) = Q(J, I) - V: Q(J, J) = Q(J, J) + V
GOTO RetSum
Rsum:
  R(I, I) = R(I, I) + V: R(I, J) = R(I, J) - V
  R(J, I) = R(J, I) - V: R(J, J) = R(J, J) + V
GOTO RetSum
PKsum:
  P(K, K) = P(K, K) + V: P(J, K) = P(J, K) - V
  P(J, I) = P(J, I) + V: P(K, I) = P(K, I) - V
GOTO RetSum
Sub1:
  IF N < C4 THEN GOTO S4
  FOR D% = N TO C4 STEP -C1
    KA = A(D%, D%): KB = B(D%, D%): X = KA * KA + KB * KB
    IF X = C0 THEN GOTO S3
    FOR G% = C1 TO D% - C1
      KC = A(G%, D%): KD = B(G%, D%)
      IF KC = C0 AND KD = C0 THEN GOTO S2
      FOR H% = C1 TO D% - C1
        KE = A(D%, H%): KF = B(D%, H%)
        IF KE = C0 AND KF = C0 THEN GOTO S1
        YK = KE * KC - KF * KD: ZK = KE * KD + KF * KC
        A(G%, H%) = A(G%, H%) - (YK * KA + ZK * KB) / X
        B(G%, H%) = B(G%, H%) - (ZK * KA - YK * KB) / X
S1:   NEXT H%
S2: NEXT G%
S3: NEXT D%
S4: A00 = A(C1, C1): A10 = A(C2, C1)
A01 = A(C1, C2): A11 = A(C2, C2)
  B00 = B(C1, C1): B10 = B(C2, C1)
  B01 = B(C1, C2): B11 = B(C2, C2)
  ON PA GOTO S5, S6, S7
S5: EK = A11 * A11 + B11 * B11
D1 = -(A10 * A11 + B10 * B11) / EK
    D2 = (A10 * B11 - B10 * A11) / EK: RETURN
S6: CK = A00 * A11 - B00 * B11 + B10 * B01 - A10 * A01
    DK = A11 * B00 + A00 * B11 - A01 * B10 - A10 * B01
    EK = CK * CK + DK * DK: D1 = (CK * A11 + DK * B11) / EK
    D2 = (CK * B11 - DK * A11) / EK: RETURN
S7: EK = A11 * A11 + B11 * B11
D1 = A11 / EK: D2 = -B11 / EK: RETURN

'Subprogram of conversions
ProcConv:
  I = D(I): J = D(J): K = D(K): L = D(L)
  T = I: P = J: D = K: LK = L: RETURN
ConvSubr:
  FOR X% = C1 TO C
    K$ = C$(X%, C1): D$ = LEFT$(K$, C1)
    IF D$ = "P" THEN Z = X%: X = C + C1
  NEXT
  FOR X% = C1 TO Y
    D(X%) = 100
  NEXT
  FOR W% = C1 TO C3
    X = C(Z, W%): D(X) = W%
  NEXT
  W = C4
  FOR X% = C1 TO Y
    IF D(X%) = 100 THEN D(X%) = W: W = W + C1
  NEXT X%
RETURN

Menu:
  'Outputting and managing main menu
  CLS : LOCATE C1, 21
  PRINT "LINEAR ELECTRONICS CIRCUITS ANALYSIS"
  LOCATE C2, C28: PRINT "WITH TOPOLOGIC INPUT"
  LOCATE C3, 24: PRINT "Djakonov V.P.  1994 Smolensk"
  LOCATE C4, 19
  PRINT "Calculate: A(F), Q(F)  Zinp(F)  Zout(F)"
  LOCATE C5, 19
  PRINT "Max Nnodes="; Y; "  Ncomp="; C; "  Fpoint="; 51
  LOCATE C7, C28: PRINT "Input Operation Mode:": PRINT
  LOCATE C8, C26: PRINT "<1> Calculate  A(F)"
  LOCATE 9, C26: PRINT "<2> Calculate  Zinp(F)"
  LOCATE C10, C26: PRINT "<3> Calculate  Zout(F)"
  LOCATE 11, C26: PRINT "<4> Input new circuit"
  LOCATE 12, C26: PRINT "<5> Correct circuit"
  LOCATE 13, C26: PRINT "<6> View circuit data"
  LOCATE 14, C26: PRINT "<7> Load circuit"
  LOCATE 15, C26: PRINT "<8> Save circuit"
  LOCATE 16, C26: PRINT "<9> Quit"
  LOCATE 19, C28: PRINT "Press key <1>...<9>"
  M$ = INPUT$(1): PA = VAL(M$)
  IF M$ = "1" THEN Y$ = "A(F)   ": RETURN
  IF M$ = "2" THEN Y$ = "Zinp(F)": RETURN
  IF M$ = "3" THEN Y$ = "Zout(F)": RETURN
  IF M$ = "4" THEN GOTO InputData
  IF M$ = "5" THEN GOSUB CorCircuit: GOTO Menu
  IF M$ = "6" THEN
    CLS : GOSUB InpFormat: F$ = INPUT$(1): CLS : GOTO Menu
  END IF
  IF M$ = "7" THEN CLS : GOSUB LoadFile: GOTO Menu
  IF M$ = "8" THEN GOSUB SaveFile: GOTO Menu
  IF M$ = "9" THEN END
GOTO Menu

InputData:
  'Entering circuit data
  CLS : INPUT "Input circuit name"; N$
  PRINT : GOSUB InpFormat: PRINT
  FOR I% = C1 TO C
ID1:
    INPUT "Component "; W$: X$ = LEFT$(W$, C1)
    LOCATE CSRLIN - 1, 20
    C$(I%, C1) = W$
    IF X$ = "R" THEN
      INPUT " A,B,Nom "; C(I%, C1), C(I%, C2), C(I%, C3)
      C(I%, C6) = C3: GOTO ID2
    END IF
    IF X$ = "C" THEN
      INPUT " A,B, Nom "; C(I%, C1), C(I%, C2), C(I%, C3)
      C(I%, C6) = C3: GOTO ID2
    END IF
    IF X$ = "L" THEN
      INPUT " A,B,Nom "; C(I%, C1), C(I%, C2), C(I%, C3)
      C(I%, C6) = C3: GOTO ID2
    END IF
    IF X$ = "Q" THEN
      PRINT " B,C,E,Hfe,Ic(mA) ";
      INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4), C(I%, C5)
      C(I%, C6) = C5: GOTO ID2
    END IF
    IF X$ = "F" THEN
      PRINT " G,S,I, S0(A/V) ";
      INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4)
      C(I%, C6) = C4: GOTO ID2
    END IF
    IF X$ = "A" THEN
      PRINT " +I,-I,Out ";
      INPUT C(I%, C1), C(I%, C2), C(I%, C3)
      C(I%, C6) = C3: GOTO ID2
    END IF
    IF X$ = "T" THEN
      PRINT " A,B,C,D,Ktr ";
      INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4), C(I%, C5)
      C(I%, C6) = C5: GOTO ID2
    END IF
    IF X$ = "P" THEN
      INPUT " I,O,Com. "; C(I%, C1), C(I%, C2), C(I%, C3)
      C(I%, C6) = C3: GOTO ID2
    END IF
    PRINT W$; " Incorrect component type!": GOTO ID1
ID2:
  IF X$ = "P" THEN NM = I% - C1: I% = C
  NB = C(I%, C6) - C1: Z% = I%: GOSUB InpContr
  IF C(I%, C6) = C3 AND C(I%, C1) = C(I%, C2) THEN CH = C1
  IF CH = C1 THEN PRINT "Error in "; W$: END
  NEXT I%: GOSUB SaveFile: GOSUB LoadFile1
GOTO Menu

Graphics:
  'Plotting amplitude-frequency and phase-frequency characteristics
  'on complex plane
  CLS : PRINT "Graphics Linear/DB": Z$ = INPUT$(1)
  IF Z$ = "D" OR Z$ = "d" THEN Z$ = "DB" ELSE Z$ = "ABS"
  SCREEN 9: CLS : LINE (31, 0)-(31, 214): LINE -(386, 214)
  FOR A = 31 TO 387 STEP 356 / (F2 - C1)
  LINE (A, 212)-(A, 213): NEXT A
  FOR A = 0 TO 214 STEP 43
  LINE (32, A)-(33, A): NEXT A
  LOCATE 1, 1: PRINT "max": LOCATE 16, 1: PRINT "min"
  LOCATE 17, 4: PRINT "Fmin": LOCATE 17, 49: PRINT "Fmax"
  LOCATE 18, 1: PRINT QM: LOCATE 22, 3: PRINT "0"
  LOCATE 8, 19: PRINT "Modul "; Y$
  LOCATE 25, 1: PRINT -QM;
  LINE (31, 241)-(31, 344): LINE (31, 293)-(387, 293)
  LINE (32, 241)-(33, 241): LINE (32, 267)-(33, 267)
  LINE (32, 318)-(33, 318): LINE (32, 344)-(33, 344)
  FOR A = 31 TO 387 STEP 356 / (F2 - C1)
  LINE (A, 291)-(A, 292): NEXT A
  IF QM = 90 THEN DQ = C3 ELSE DQ = C6
  LINE (389, 100)-(389, 103)
  LINE -(567, 103): LINE -(567, 100)
  LINE (480, 17)-(478, 17)
  LINE -(478, 189): LINE -(480, 189)
  LOCATE 17, 19: PRINT "Phase "; Y$
  LOCATE 1, 60: PRINT "Y"
  LOCATE 9, 72: PRINT "X";
  LOCATE 17, 61: PRINT "CIRCUIT "; N$
  LOCATE 18, 61: PRINT Y$;
  IF Z$ = "ABS" THEN PRINT " (ABS)"; : GOTO G1
  PRINT " (DB)";
G1: LOCATE 19, 61: PRINT "Amin=";
  IF Z$ = "ABS" THEN PRINT USING "###.##^^^^"; AMIN: GOTO G2
  PRINT USING "###.##"; CDB * LOG(AMIN)
G2: LOCATE 20, 61: PRINT "Amax=";
  IF Z$ = "ABS" THEN PRINT USING "###.##^^^^"; AMAX; : GOTO G3
  PRINT USING "###.##"; CDB * LOG(AMAX);
G3: LOCATE 21, 61: PRINT "Fmin=";
  PRINT USING "#.###^^^^"; ST
  LOCATE 22, 61: PRINT "Fmax=";
  PRINT USING "#.###^^^^"; EN
  DX = 356 / (F2 - C1)
IF Z$ = "ABS" THEN DA = 214 / (AMAX - AMIN): GOTO G4
  DBMAX = CDB * LOG(AMAX): DBMIN = CDB * LOG(AMIN)
  DA = 214 / (DBMAX - DBMIN)
G4: FOR A% = C1 TO F2
  X = 31 + (A% - C1) * DX: V = W(A%, C2)
  IF Z$ = "ABS" THEN YG = 214 - (V - AMIN) * DA: GOTO G5
  V = CDB * LOG(V): YG = 214 - (V - DBMIN) * DA
G5: IF A% = C1 THEN PSET (X, YG), 12 ELSE LINE -(X, YG), 12
  NEXT A%
  FOR A% = C1 TO F2
    X = 31 + (A% - C1) * DX
    YG = 293 - (W(A%, C3) / DQ) * 1.72
    IF A% = C1 THEN PSET (X, YG), 11 ELSE LINE -(X, YG), 11
  NEXT A%
  FOR A% = C1 TO F2
    Q = W(A%, C3) / 57.29578: R = W(A%, C2) / AMAX
    X = 478 + 89 * R * COS(Q): YG = 103 + 86 * R * SIN(Q)
    IF A% = C1 THEN PSET (X, YG), 10 ELSE LINE -(X, YG), 10
  NEXT A%
G6: F$ = INPUT$(1)
  IF F$ = "C" OR F$ = "c" THEN GOSUB CopyScr: GOTO G6
SCREEN 0
RETURN

SaveFile:
  'Saving circuit data on disk
  OPEN N$ + ".ALC" FOR OUTPUT AS #1
  FOR A% = C1 TO C
    WRITE #1, C$(A%, C1)
    IF C$(A%, C1) = "" THEN GOTO SF2
    LS% = C(A%, C6)
    FOR B% = C1 TO C5
      IF C(A%, B%) = C0 AND B% > LS% THEN GOTO SF1
      WRITE #1, C(A%, B%)
SF1: NEXT B%
  NEXT A%
SF2: CLOSE #1: RETURN

LoadFile:
  'Reading circuit data from disk
  INPUT "Input name file <ENTER for catalog>"; N$
  IF N$ = "" THEN CLS : FILES "*.ALC": GOTO LoadFile
LoadFile1:
  ERASE C$, C: DIM C$(C, C4), C(C, C6)
  OPEN N$ + ".ALC" FOR INPUT AS #1
  FOR A% = C1 TO C
    INPUT #1, C$(A%, C1)
    B$ = LEFT$(C$(A%, C1), C1)
    IF B$ = "" THEN GOTO LF2
    IF B$ = "R" OR B$ = "C" OR B$ = "L" OR B$ = "A" OR B$ = "P" THEN
      C(A%, C6) = C3: GOTO LF1
    END IF
    IF B$ = "F" THEN C(A%, C6) = C4: GOTO LF1
    IF B$ = "Q" OR B$ = "T" THEN C(A%, C6) = C5: GOTO LF1
    PRINT "Error in file "; N$: STOP
LF1: FOR B% = C1 TO C(A%, C6)
       INPUT #1, C(A%, B%)
     NEXT B%
     NB = C(A%, C6) - 1: Z% = A%: GOSUB InpContr
     IF B$ = "P" THEN GOTO LF2
   NEXT A%
LF2: CLOSE #1
RETURN

CorCircuit:
  'Correcting circuit data
GOSUB ListComp
CC0:
  DO
    INPUT "What component (or End) "; D$
    IF D$ = "E" THEN RETURN
    FOR I% = C1 TO C
      IF C$(I%, C1) = D$ THEN GOTO CC1
    NEXT I%
  PRINT "Error, no component !"
LOOP
CC1:
  LOCATE CSRLIN - 1, 32
  FOR B% = C1 TO C(I%, C6)
    T = C(I%, B%)
    IF T - INT(T) = 0 THEN
      PRINT T;
        ELSE PRINT USING " #.##^^^^"; T + 1E-12;
    END IF
  NEXT B%
  PRINT : PRINT "Component "; D$: X$ = LEFT$(D$, C1)
  LOCATE CSRLIN - 1, 22
  IF X$ = "R" THEN
    INPUT " A,B,Nom "; C(I%, C1), C(I%, C2), C(I%, C3): GOTO CC2
  END IF
  IF X$ = "C" THEN
    INPUT " A,B,Nom "; C(I%, C1), C(I%, C2), C(I%, C3): GOTO CC2
  END IF
  IF X$ = "L" THEN
    INPUT " A,B,Nom "; C(I%, C1), C(I%, C2), C(I%, C3): GOTO CC2
  END IF
  IF X$ = "Q" THEN
    PRINT " B,C,E,Hfe,Ic(mA) ";
    INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4), C(I%, C5)
    GOTO CC2
  END IF
  IF X$ = "F" THEN
    PRINT " G,S,I,S0(A/V) ";
    INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4)
    GOTO CC2
  END IF
  IF X$ = "A" THEN
    INPUT " +I,-I,Out "; C(I%, C1), C(I%, C2), C(I%, C3)
    GOTO CC2
  END IF
  IF X$ = "T" THEN
    PRINT " A,B,C,D,Ktr ";
    INPUT C(I%, C1), C(I%, C2), C(I%, C3), C(I%, C4), C(I%, C5)
    GOTO CC2
  END IF
  IF X$ = "P" THEN
    INPUT " I,O,Com. "; C(I%, C1), C(I%, C2), C(I%, C3)
    GOTO CC2
  END IF
CC2:
GOTO CC0

InpFormat:
  'Outputting components format
  PRINT "Rn, Cn, Ln                  A  B  Nom"
  PRINT "Fn (Field Transistor)       G  D  S  S0(A/V)"
  PRINT "Qn (Bipolar Transistor)     B  C  E  Hfe  Ic(mA)"
  PRINT "An (Amplifier)             +I -I  Out"
  PRINT "Tn (Transformer)            A  B  C  D  Ktr"
  PRINT "P  (Port Inp/Output/Common) I  O  C"
RETURN

CopyScr:
  'Copying screen by Epson-compatible printer
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

WorkError:
  'Error processing
  IF ERR <> 53 THEN RUN
  PRINT "File not found !"
  PRINT "Press any key for main menu !": M$ = INPUT$(1)
RUN

