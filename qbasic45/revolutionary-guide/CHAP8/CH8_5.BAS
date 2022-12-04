REM Demonstration of QBasic Graphics Drivers
REM \CHAP8\CH8_5.BAS

SUB CS3

DO
M$ = INPUT$(1)
  IF M$ = "S" OR M$ = "s" THEN GOSUB CS3
  IF M$ = "C" OR M$ = "c" THEN GOSUB CS3N
  IF M$ = "Q" OR M$ = "q" THEN GOTO LEND
LOOP

CS3: 'Copy-screen for 720*348 pixels (turbo-mode)
  DEF SEG = &HB000 'Start address of video-RAM
  OPEN "LPT1:" FOR RANDOM AS #1: WIDTH #1, 255
  PRINT #1, CHR$(27); "3"; CHR$(24);
  FOR X% = 0 TO 89
    PRINT #1, CHR$(27); "*"; CHR$(0); CHR$(92); CHR$(1);
    FOR S% = 0 TO 7830 STEP 90: SX% = X% - S%
      FOR Y% = 32316 TO 0 STEP -8192
        A% = PEEK(Y% + SX%)
        PRINT #1, CHR$(A%);
      NEXT
    NEXT: PRINT #1, CHR$(10)
  NEXT: DEF SEG = 0: CLOSE #1
RETURN

CS3N: 'Copy-screen for 720*348 pixels (NLQ-mode)
 WIDTH "LPT1:", 255: LPRINT CHR$(27); "3"; CHR$(24);
 FOR Y% = 0 TO 344 STEP 8
   LPRINT CHR$(27); "*"; CHR$(1); CHR$(207); CHR$(2);
   Y1% = Y% + 1: Y2% = Y% + 2: Y3% = Y% + 3: Y4% = Y% + 4
   Y5% = Y% + 5: Y6% = Y% + 6: Y7% = Y% + 7
   FOR X% = 0 TO 719
     A% = 16 * POINT(X%, Y3%) + 32 * POINT(X%, Y2%)
     A% = A% + 64 * POINT(X%, Y1%) + 128 * POINT(X%, Y%)
     IF Y% < 344 THEN
       A% = A% + 8 * POINT(X%, Y4%) + 4 * POINT(X%, Y5%)
       A% = A% + 2 * POINT(X%, Y6%) + POINT(X%, Y7%)
     END IF
     IF A% = 13 OR A% = 9 THEN A% = 0
     LPRINT CHR$(A%);
   NEXT X%: LPRINT
 NEXT Y%
RETURN

LEND:
END SUB

