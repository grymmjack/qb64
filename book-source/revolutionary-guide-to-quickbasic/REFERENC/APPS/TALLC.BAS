'Program ACLM for Quick and Turbo-Basic Compiler
'Head module of the program
  '$DYNAMIC
  DIM F(4), G(50), L(50), C(50), U(50), J(25), I(1), V(1, 1)
  DIM A(25), B(25), E(25), D(25), X(25), Y(25)
  ON ERROR GOTO WorkError
Menu:
  'Outputting and managing main menu
  SCREEN 0: KEY OFF: CLS
  LOCATE 1, 25: PRINT "Transient Analysis"
  LOCATE 2, 25: PRINT "For Linear Ladder Circuits"
  LOCATE 3, 22: PRINT "Prof. Djakonov V.P. Smolensk 1994"
  LOCATE 5, 28: PRINT "Operation Modes:"
  LOCATE 7, 25: PRINT "<1> Load circuit file"
  LOCATE 8, 25: PRINT "<2> New circuit"
  LOCATE 9, 25: PRINT "<3> Correction"
  LOCATE 10, 25: PRINT "<4> Transient analysis"
  LOCATE 11, 25: PRINT "<5> Quit"
  LOCATE 13, 27: PRINT "Press key <1>...<5>"
  M$ = INPUT$(1)
  IF M$ = "1" THEN CLS : GOSUB LoadFile: GOTO Menu
  IF M$ = "2" THEN GOSUB InpDataCircuit
  IF M$ = "3" THEN GOTO CorCircuit
  IF M$ = "4" THEN GOTO Start
  IF M$ = "5" THEN END
GOTO Menu

InpDataCircuit:
  'Table-topological data input
   CLS : INPUT "Input circuit name "; C$: PRINT
   PRINT "Input Gi: Branch(or 0)  Nominal"
   FOR I = 1 TO 51 STEP 2
     INPUT "          B "; G(I): IF G(I) = 0 THEN EXIT FOR
     LOCATE CSRLIN - 1, 25: INPUT "Nom "; G(I + 1)
   NEXT
   PRINT "Input Li: Branch(or 0)  Nominal"; : PRINT
   FOR I = 1 TO 51 STEP 2
     INPUT "          B "; L(I): IF L(I) = 0 THEN EXIT FOR
     LOCATE CSRLIN - 1, 25: INPUT "Nom "; L(I + 1)
   NEXT
  PRINT "Input Ci: Branch(or 0)  Nominal"; : PRINT
  FOR I = 1 TO 51 STEP 2
    INPUT "          B "; C(I): IF C(I) = 0 THEN EXIT FOR
    LOCATE CSRLIN - 1, 25: INPUT "Nom "; C(I + 1)
  NEXT
  PRINT : INPUT "Input number of branch for source "; N%
  INPUT "Input A(V) "; F(1): INPUT "Input W(Rad/s) "; F(2)
  INPUT "Input Q0(Rad) "; F(3): INPUT "Input Ti(s) "; F(4)
  INPUT "Input H(s) "; H: INPUT "Input Tend(s) "; T
  GOSUB ListComponents
  PRINT : INPUT "Save file (Y/N) "; X$
  IF X$ = "Y" OR X$ = "y" THEN GOSUB SaveFile1
RETURN

Start:
  'Recursion algorithm of analysis of ladder circuit
  'with application of method of discrete models
  GOSUB ListComponents: PRINT
  INPUT "For displaying Ui,Ji enter i/All/Enter"; P$
  IF P$ = "" THEN P$ = "0"
  CLS : K4% = INT(T / H + .1)
  ERASE U, A, B, E, D, X, Y, I, V
  DIM A(25), B(25), E(25), D(25), X(25), Y(25), U(50)
  DIM I(K4% + 1), V(N% + 1, K4% + 1)
  FOR J% = 1 TO 3
    FOR I% = 1 TO 51 STEP 2
      I1% = I% + 1
        ON J% GOTO G, L, C
G:      K% = G(I%): IF K% = 0 THEN GOTO E
        R = G(I1%): GOTO S
L:      K% = L(I%): IF K% = 0 THEN GOTO E
        R = H / L(I1%): GOTO S
C:      K% = C(I%): IF K% = 0 THEN GOTO E
        R = C(I1%) / H
S:      Y(K%) = Y(K%) + R
     NEXT I%
E: NEXT J%
   R = 0: S = 1
   FOR I% = 2 TO N% STEP 2
     I1% = I% - 1: E(I1%) = Y(I1%) * S: R = R + E(I1%)
     E(I%) = R: A(I1%) = S: A(I%) = R / Y(I%): S = S + A(I%)
   NEXT
   M = N% / 2 - INT(N% / 2): IF M < .1 THEN GOTO L1
   E(N%) = S * Y(N%): A(N%) = S: S = R + E(N%)
L1:
  K1% = 0
DO
  R = 0: P = 0
  FOR I% = 2 TO N% STEP 2
    I1% = I% - 1: D(I1%) = Y(I1%) * P + X(I1%)
    R = R + D(I1%): D(I%) = R: B(I1%) = P
    B(I%) = (R - X(I%)) / Y(I%): P = P + B(I%)
  NEXT
  IF M < .1 THEN GOTO L2
  D(N%) = P * Y(N%) + X(N%): B(N%) = P: P = R + D(N%)
L2:
  K1% = K1% + 1: W = F(2): T1 = K1% * H: IF W = 0 THEN F1 = F(1)
  IF T1 > F(4) THEN F1 = 0
  IF F(4) < 0 THEN F1 = F(1) * (1 - EXP(T1 / F(4)))
  IF W <> 0 AND T1 < F(4) THEN F1 = F(1) * COS(W * T1 + F(3))
  Z = (F1 - P) / S
  FOR I% = 1 TO N%
    U(I%) = A(I%) * Z + B(I%): J(I%) = E(I%) * Z + D(I%)
  NEXT
  'Outputting current results of simulation onto the screen
  PRINT : T1 = K1% * H: IF T1 > T THEN GOTO MenuResult
  IF P$ = "0" THEN
    LOCATE 1, 1: PRINT "t="; : PRINT USING "#.##^^^^"; T1;
  END IF
  IF P$ = "0" THEN PRINT "  F(t)="; : PRINT USING "#.##^^^^"; F1;
  IF P$ <> "0" THEN PRINT "t="; : PRINT USING "#.##^^^^"; T1;
  IF P$ <> "0" THEN PRINT "  F(t)="; : PRINT USING "#.##^^^^"; F1
  FOR I% = 1 TO N%
    IF P$ = "" THEN GOTO L4
    IF P$ <> "a" AND P$ <> "A" THEN GOTO L3
    PRINT "U"; I%; "="; : PRINT USING "#.###^^^^"; U(I%);
    PRINT TAB(30); "J"; I%; "=";
    PRINT USING "#.###^^^^"; J(I%): GOTO L4
L3:
   I1% = VAL(P$)
   IF I1% = I% THEN
     PRINT "U"; I1%; "=";
     PRINT USING "#.###^^^^"; U(I1%);
   END IF
   IF I1% = I% THEN
     PRINT TAB(30); "J"; I1%; "=";
     PRINT USING "#.###^^^^"; J(I1%)
   END IF
L4:
  I(K1%) = F1: V(I%, K1%) = U(I%)
  NEXT
  FOR I% = 1 TO 51 STEP 2
    K% = L(I%): IF K% = 0 THEN EXIT FOR
    X(K%) = J(K%)
  NEXT
  FOR I% = 1 TO 51 STEP 2
    K% = C(I%): IF K% = 0 THEN EXIT FOR
    X(K%) = -C(I% + 1) / H * U(K%)
  NEXT
LOOP

MenuResult:
  'Output and control of results menu
  CLS : LOCATE 2, 29: PRINT "Menu of Results:"
  LOCATE 4, 25: PRINT "<1> Print Circuit Data"
  LOCATE 5, 25: PRINT "<2> Print Results"
  LOCATE 6, 25: PRINT "<3> Display Results"
  LOCATE 7, 25: PRINT "<4> Graphics Results"
  LOCATE 8, 25: PRINT "<5> Exit to Main Menu"
  LOCATE 10, 27: PRINT "Press key <1>...<5>"
  F$ = INPUT$(1)
  IF F$ = "1" THEN GOSUB LprintLC: GOTO MenuResult
  IF F$ = "2" THEN GOSUB DefCur: GOSUB LprintResult
  IF F$ = "3" THEN GOSUB DefCur: GOSUB DisplayResult: GOTO MenuResult
  IF F$ = "4" THEN GOSUB DefCur: GOSUB Graphics: GOTO MenuResult
  GOTO Menu

ListComponents:
  'Displaying components data sheet
  IF G(1) = 0 AND L(I) = 0 AND C(I) = 0 THEN GOTO Menu
  CLS : PRINT "Circuit: "; C$; ":"
  PRINT "Typ", "Branch", "Nominal"
  FOR I = 1 TO 51 STEP 2
    IF G(I) = 0 THEN EXIT FOR
    PRINT "G"; (I + 1) / 2, G(I), G(I + 1); " 1/Ohm"
  NEXT
  FOR I = 1 TO 51 STEP 2
    IF L(I) = 0 THEN EXIT FOR
    PRINT "L"; (I + 1) / 2, L(I), L(I + 1); " H"
  NEXT
  FOR I = 1 TO 51 STEP 2
    IF C(I) = 0 THEN EXIT FOR
    PRINT "C"; (I + 1) / 2, C(I), C(I + 1); " F"
  NEXT
  F$ = " A": IF N% / 2 - INT(N% / 2) < .1 THEN F$ = " V"
  PRINT "A ="; F(1); F$;
  PRINT TAB(30); "W =";
  PRINT USING "#.###^^^^"; F(2); : PRINT " Rad/s"
  PRINT "Q0="; : PRINT USING "#.###^^^^"; F(3);
  PRINT " Rad"; : PRINT TAB(30); "Ti=";
  PRINT USING "#.###^^^^"; F(4); : PRINT " s"
  PRINT "H ="; : PRINT USING "#.###^^^^"; H; : PRINT " s";
  PRINT TAB(30); "Tend=";
  PRINT USING "#.###^^^^"; T; : PRINT " s"
RETURN

LprintLC:
  'Printing components data sheet
  GOSUB ListComponents: LPRINT "Circuit  "; C$; ":"
  LPRINT "Typ", "Branch", "Nominal"
  FOR I = 1 TO 51 STEP 2
    IF G(I) = 0 THEN EXIT FOR
    LPRINT "G"; (I + 1) / 2, G(I), G(I + 1); " 1/Ohm"
  NEXT
  FOR I = 1 TO 51 STEP 2
    IF L(I) = 0 THEN EXIT FOR
    LPRINT "L"; (I + 1) / 2, L(I), L(I + 1); " H"
  NEXT
  FOR I = 1 TO 51 STEP 2
    IF C(I) = 0 THEN EXIT FOR
    LPRINT "C"; (I + 1) / 2, C(I), C(I + 1); " F"
  NEXT
  F$ = " A": IF N% / 2 - INT(N% / 2) < .1 THEN F$ = " V"
  LPRINT "A =";
  LPRINT USING "#.###^^^^"; F(1); : LPRINT F$;
  LPRINT TAB(30); "W =";
  LPRINT USING "#.###^^^^"; F(2); : LPRINT " Rad/s"
  LPRINT "Q0=";
  LPRINT USING "#.###^^^^"; F(3);
  LPRINT " Rad"; : LPRINT TAB(30); "Ti=";
  LPRINT USING "#.###^^^^"; F(4); : LPRINT " s"
  LPRINT "H =";
  LPRINT USING "#.###^^^^"; H; : LPRINT " s";
  LPRINT TAB(30); "Tend=";
  LPRINT USING "#.###^^^^"; T; : LPRINT " s"
RETURN

DefCur:
  'Setting status of curves to be plotted
  CLS : PRINT "Press key Y or N"
  FOR I% = 0 TO N%
    PRINT "Curve"; I%; : F$ = INPUT$(1)
    IF F$ = "N" OR F$ = "n" THEN
      PRINT "No": A(I%) = 0
      ELSE PRINT "Yes": A(I%) = 1
    END IF
  NEXT
RETURN

LprintResult:
  'Printing analysis results
  LPRINT : LPRINT C$
  FOR I% = 1 TO K4%
    LPRINT : LPRINT "t=";
    LPRINT USING "#.###^^^^"; I% * H;
    LPRINT TAB(20); "F(t)=";
    LPRINT USING " #.###^^^^"; I(I%)
    FOR J% = 1 TO N%
      IF A(J%) = 0 THEN EXIT FOR
      LPRINT "U"; MID$(STR$(J%), 2); "=";
      LPRINT USING "#.###^^^^"; V(J%, I%); : LPRINT "  ";
    NEXT J%
  NEXT I%
RETURN

DisplayResult:
  'Outputting simulation results onto the screen
  PRINT : PRINT C$
  FOR I% = 1 TO K4%
    PRINT : PRINT "t=";
    PRINT USING "#.###^^^^"; I% * H;
    PRINT TAB(20); "F(t)=";
    PRINT USING " #.###^^^^"; I(I%)
    FOR J% = 1 TO N%
      IF A(J%) = 0 THEN EXIT FOR
      PRINT "U"; MID$(STR$(J%), 2); "=";
      PRINT USING "#.###^^^^"; V(J%, I%); : PRINT "  ";
    NEXT J%
  NEXT I%: F$ = INPUT$(1)
RETURN

Graphics:
  'Plotting transients
  F$ = "  Input text"
  F$ = F$ + "--------------------------------------------------"
  PRINT F$: LINE INPUT F$
  CLS : SCREEN 9: LOCATE 2, 69: PRINT "Circuit:"
  LOCATE 3, 68 + (8 - LEN(C$)) / 2: PRINT C$;
  LOCATE 4, 69: PRINT "ANALYSIS"
  LOCATE 5, 70: PRINT "OF LADDER"
  LOCATE 6, 70: PRINT "LINEAR"
  LOCATE 7, 69: PRINT "CIRCUITS"
  LOCATE 8, 67: PRINT "V.P.Djakonov"
  LOCATE 9, 67: PRINT "T="; : PRINT USING "#.###^^^^"; T
  LOCATE 10, 67: INPUT ; "Vmin=", YB
  LOCATE 11, 67: INPUT ; "Vmax=", YT
  L% = 0: XG = 535
  FOR I% = 0 TO N%
    IF A(I%) = 0 THEN GOTO LG ELSE L% = L% + 1
    YG = 161 + L% * 14
    ON L% - 1 GOSUB M1, M2, M3, M4, M5, M6, M7, M8, M9
    LINE (532, 174)-(539, 174), 1
    LOCATE 12 + L%, 69: PRINT "M"; MID$(STR$(I%), 2); "=";
    INPUT "", A(I%)
LG:
  NEXT
  LOCATE 25: PRINT F$;
  GOSUB Grid: GOSUB Graph
CS: M$ = INPUT$(1)
  IF M$ = "C" OR M$ = "c" THEN GOSUB CopyScr: GOTO CS
  SCREEN 0
RETURN

Graph:
  XA = 444 / K4%: YA = 300 / YD: L% = 0
  FOR I% = 0 TO N%: F = 0
    IF A(I%) = 0 THEN GOTO G2 ELSE L% = L% + 1
    FOR J% = 0 TO K4%
      W = J% / 8: W = W - INT(W)
      IF I% = 0 THEN Y = I(J%) ELSE Y = V(I%, J%)
      XG = 58 + J% * XA
      YG = 315 - (Y * A(I%) - YB) * YA
      IF YG < 3 THEN F = 0: YG = 3
      IF YG > 344 THEN F = 0: YG = 344
      IF L% >= 8 THEN W% = L% + 1 ELSE W% = L%
      IF J% = 0 OR F = 0 THEN F = 1: PSET (XG, YG), W%: GOTO G1
      IF F = 1 THEN LINE -(XG, YG), W%
      IF W = 0 THEN
        ON L% - 1 GOSUB M1, M2, M3, M4, M5, M6, M7, M8, M9
      END IF
G1: NEXT J%
G2:
  NEXT I%
RETURN

'Subprograms of plotting labels on transient curves
M1:
  CIRCLE (XG, YG), 3, 2: PRESET (XG, YG), 2: RETURN
M2:
  LINE (XG - 2, YG - 2)-(XG + 2, YG + 2), 3
  LINE (XG - 2, YG + 2)-(XG + 2, YG - 2), 3
  PSET (XG, YG), 3: RETURN
M3:
  LINE (XG - 2, YG)-(XG, YG + 2), 4: LINE -(XG + 2, YG), 4
  LINE -(XG, YG - 2), 4: LINE -(XG - 2, YG), 4
  PRESET (XG, YG), 4: RETURN
M4:
  LINE (XG - 2, YG - 2)-(XG + 2, YG + 2), 5, B
  PRESET (XG, YG), 5: RETURN
M5:
  LINE (XG - 2, YG - 2)-(XG + 2, YG + 2), 6, BF
  PSET (XG, YG), 6: RETURN
M6:
  LINE (XG - 2, YG + 2)-(XG, YG - 2), 7
  LINE -(XG + 2, YG + 2), 7: LINE -(XG - 2, YG + 2), 7
  PRESET (XG, YG), 7: RETURN
M7:
  LINE (XG, YG + 2)-(XG - 2, YG - 2), 9
  LINE -(XG + 2, YG - 2), 9: LINE -(XG, YG + 2), 9
  PRESET (XG, YG), 9: RETURN
M8:
  LINE (XG - 2, YG + 2)-(XG - 2, YG - 2), 10
  LINE -(XG + 2, YG), 10: LINE -(XG - 2, YG + 2), 10
  PRESET (XG, YG), 10: RETURN
M9:
  LINE (XG - 2, YG)-(XG + 2, YG - 2), 11
  LINE -(XG - 2, YG + 2), 11: LINE -(XG - 2, YG), 11
  PRESET (XG, YG), 11: RETURN

Grid:
  'Constructing scales grid
  FOR Y% = 15 TO 315 STEP 60: LINE (58, Y%)-(503, Y%): NEXT
    FOR X% = 58 TO 503 STEP 89: LINE (X%, 15)-(X%, 315): NEXT
      XD = XR - XL: YD = YT - YB: R = 23
      FOR K% = 0 TO 5
        LOCATE R, 1: S = YB + YD * K% / 5
        PRINT USING "####.##"; S; : R = R - 4.2
      NEXT K%: C = 5
   FOR K% = 0 TO 5
     LOCATE 24, C: S = K% / 5:
     PRINT USING "####.##"; S; : C = C + 11
   NEXT
 RETURN

CopyScr:
  'Copying screen by printer of Epson (9 pins) class
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

LoadFile:
  'Reading circuit file from disk
LF1:
  INPUT "Input file name <Enter for Catalog>"; C$
  IF C$ = "" THEN CLS : FILES "*.ACL": GOTO LF1
  OPEN C$ + ".ACL" FOR INPUT AS #1
  FOR I = 1 TO 51 STEP 2
    INPUT #1, G(I): IF G(I) = 0 THEN EXIT FOR
    INPUT #1, G(I + 1)
  NEXT
  FOR I = 1 TO 51 STEP 2
    INPUT #1, L(I): IF L(I) = 0 THEN EXIT FOR
    INPUT #1, L(I + 1)
  NEXT
  FOR I = 1 TO 51 STEP 2
    INPUT #1, C(I): IF C(I) = 0 THEN EXIT FOR
    INPUT #1, C(I + 1)
  NEXT
  INPUT #1, N%, F(1), F(2), F(3), F(4), H, T
  CLOSE #1
RETURN

SaveFile:
  'Saving circuit file on disk
  CLS : INPUT "Input name file "; C$
SaveFile1:
  OPEN C$ + ".ACL" FOR OUTPUT AS #1
  FOR I = 1 TO 51 STEP 2
    WRITE #1, G(I): IF G(I) = 0 THEN EXIT FOR
    WRITE #1, G(I + 1)
  NEXT
  FOR I = 1 TO 51 STEP 2
    WRITE #1, L(I): IF L(I) = 0 THEN EXIT FOR
    WRITE #1, L(I + 1)
  NEXT
  FOR I = 1 TO 51 STEP 2
    WRITE #1, C(I): IF C(I) = 0 THEN EXIT FOR
    WRITE #1, C(I + 1)
  NEXT
  WRITE #1, N%, F(1), F(2), F(3), F(4), H, T
  CLOSE #1
RETURN

CorCircuit:
  'Correcting circuit data
  CLS : GOSUB ListComponents: PRINT
DO
  PRINT "Correct Components, Source or End (C,S or E)? ";
  X$ = INPUT$(1): PRINT X$
  IF X$ = "C" OR X$ = "c" THEN GOTO CorCom
  IF X$ = "S" OR X$ = "s" THEN GOTO CorSours
  IF X$ = "E" OR X$ = "e" THEN GOTO SFRetMenu
LOOP
SFRetMenu:
  PRINT
  PRINT "Save file (Y/N)? "; : B$ = INPUT$(1)
  IF B$ = "Y" OR B$ = "y" THEN GOSUB SaveFile
  GOTO Menu
CorCom:
  PRINT : PRINT "Input component name (G,C,L or End)?";
  A$ = INPUT$(1)
  IF A$ = "G" OR A$ = "g" THEN GOTO CorG
  IF A$ = "L" OR A$ = "l" THEN GOTO CorL
  IF A$ = "C" OR A$ = "c" THEN GOTO CorC
  IF A$ = "E" OR A$ = "e" THEN GOTO SFRetMenu
  GOTO CorCom
CorG:
  PRINT
  FOR I = 1 TO 51 STEP 2
    INPUT "B (or 0)"; G(I): IF G(I) = 0 THEN GOTO CorCom
    LOCATE CSRLIN - 1, 25: INPUT "Nom "; G(I + 1)
 NEXT: GOTO CorCom
CorL:
  PRINT
  FOR I = 1 TO 51 STEP 2
    INPUT "B (or 0)"; L(I): IF L(I) = 0 THEN GOTO CorCom
    LOCATE CSRLIN - 1, 20: INPUT "Nom "; L(I + 1)
  NEXT: GOTO CorCom
CorC:
  PRINT
  FOR I = 1 TO 51 STEP 2
    INPUT "B (or 0)"; C(I): IF C(I) = 0 THEN GOTO CorCom
    LOCATE CSRLIN - 1, 20: INPUT "Nom "; C(I + 1)
  NEXT: GOTO CorCom
CorSours:
  PRINT : INPUT "Input A(V) "; F(1)
  INPUT "Input W(Rad/s) "; F(2)
  INPUT "Input Q0(Rad) "; F(3): INPUT "Input Ti(s) "; F(4)
  INPUT "Input H(s) "; H: INPUT "Input Tend(s) "; T
  GOTO CorCircuit

WorkError:
  'Error processing
   IF ERR <> 53 THEN RUN
   PRINT "File not found !"
   PRINT "Press any key to return to main menu": M$ = INPUT$(1)
RUN


