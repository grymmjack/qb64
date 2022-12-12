REM EGA/VGA Graphics Driver
REM \CHAP8\CH8_6.BAS

CopyScr:
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
  NEXT
  CLOSE #1
RETURN

