DECLARE SUB bigsub (prompt$, max%, winsiz%, S$)
DECLARE FUNCTION bigfunc$ (prompt$, max%, winsiz%, S$)
PRINT
Path$ = "C:\BAR": p$ = "Please Enter Your Path =>"
Mystr$ = bigfunc$(p$, 32, 16, Path$)
PRINT : PRINT UCASE$(Path$): PRINT Mystr$

FUNCTION bigfunc$ (prompt$, max%, winsiz%, S$)
   bigsub prompt$, max%, winsiz%, S$
   bigfunc$ = S$
END FUNCTION

SUB bigsub (prompt$, max%, winsiz%, S$)
   S$ = LTRIM$(RTRIM$(S$)): Cursor% = LEN(S$) - (Cursor% < max%)
   F$ = CHR$(176): Fill$ = STRING$(max%, F$)
   S$ = LEFT$(S$ + Fill$, max%): INS% = -1: PRINT prompt$; " ";
   Ybase% = POS(0)
   WHILE done$ <> "DONE"
      Sbase% = Cursor% - winsiz% + 1: IF Sbase% < 1 THEN Sbase% = 1
      LOCATE , Ybase%, 0: PRINT MID$(S$ + Fill$, Sbase%, winsiz%); " ";
      LOCATE , Ybase% + Cursor% - Sbase%, 1
      k$ = "": WHILE k$ = "": k$ = INKEY$: WEND
      k% = ASC(k$): IF k% = 0 THEN k% = -ASC(MID$(k$, 2))
      SELECT CASE k%
         CASE 32 TO 127
            IF INS% AND Cursor% < max% THEN
               MID$(S$, Cursor% + 1) = MID$(S$, Cursor%)
               S$ = LEFT$(S$, max%)
            END IF
            MID$(S$, Cursor%, 1) = k$
            Cursor% = Cursor% - (Cursor% < max%)
         CASE 13: IF S$ = Fill$ THEN S$ = ""
            IF INSTR(S$, F$) > 0 THEN S$ = LEFT$(S$, INSTR(S$, F$) - 1)
            EXIT SUB
         CASE 8
            IF Cursor% > 1 THEN
               Cursor% = Cursor% - 1
               MID$(S$, Cursor%) = MID$(S$, Cursor% + 1)
               MID$(S$, max%) = F$
            ELSE
               SOUND 999, .7
            END IF
         CASE 27: S$ = "": EXIT SUB
         CASE -71: Cursor% = 1
         CASE -79: Cursor% = INSTR(S$, F$)
            IF Cursor% = 0 THEN Cursor% = max%
         CASE -82: INS% = -(INS% + 1): SOUND 1500 + 800 * INS%, .5
         CASE -83
            IF Cursor% < max% THEN
               MID$(S$, Cursor%) = MID$(S$, Cursor% + 1)
               MID$(S$, max%) = F$
            ELSE
               SOUND 999, .7
            END IF
         CASE -75: Cursor% = Cursor% - 1
            lim% = INSTR(S$, F$): lim% = lim% - max% * (lim% = 0)
            IF Cursor% < 1 THEN Cursor% = lim%
         CASE -77: Cursor% = Cursor% + 1
            lim% = INSTR(S$, F$): lim% = lim% - max% * (lim% = 0)
            IF Cursor% > lim% THEN Cursor% = 1
      END SELECT
   WEND
END SUB

