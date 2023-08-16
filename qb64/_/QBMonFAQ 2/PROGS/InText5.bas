'***********************************************************************
' INTEXT5.BAS = Full Line-Editing Routine
' ===========   Komfortable Eingaberoutine, ersetzt den INPUT-Befehl
'
' Deutsche Beschreibung
' ---------------------
' (von Thomas Antoni, 12.3.2006)
' Dieses Q(uick)Basic-Programm enthaelt eine komfortable Eingaberoutine,
' die den INPUT-Befehl ersetzt. Es ermoeglich eine Tastatureingabe mit
' definierter Laenge. Folgende Editeirtasten werden unterstuetzt:
' Cursor rechts/links, Backspace, Entf, Einfg, Esc und Eingabetaste.
' Den Sinn des Parameters Mask$ habe ich nicht verstanden :))
'
' English Description
' -------------------
' Following is a full line-editing subroutine that myself and
' programming partner James Parchen developed and refined over the
' last couple of years.
'
' (c) KELLY MUNDELL, July 29, 1993 - Released into public domain
'************************************************************************
'
DECLARE SUB KeyIn (Ver$, Ln$, Mask$, Fg%, Bg%, p%)
'
CLS
LOCATE 2, 2
CALL KeyIn("ALL", SPACE$(22), "", 0, 15, 0)
'22 Zeichen langes Eingabefeld mit schwarzer Schrift (0) auf weissem
'Hintergrund (15)
'
COLOR 7, 0
LOCATE 10, 2
PRINT "Your input was: "
LOCATE 11, 2
PRINT text$
SLEEP
END

DEFINT A-Z
'
'
SUB KeyIn (Ver$, Ln$, Mask$, Fg, Bg, p)
SHARED text$
'
'----------------------------------------------------------------------
' Parameters:
' Ver$ = "ALL"          All Characters
' Ver$ = "a-z"          Alpha Lower Case
' Ver$ = "A-Z"          Alpha Upper Case
' Ver$ = "a-Z"          Alpha Case off
' Ver$ = "#'s"          Numbers Only
' Ln$  = SPACE$(Number of Characters to accept; max 79)
' Mask$ = ""            i.e. To Enter DOB Mask$ would be "  /  /  "
' Fg/Bg                 ForeGround Color/Background Color
' p                     Screen Page Number
'-----------------------------------------------------------------------
DIM Chk(10)
IF Mask$ <> "" THEN
   Ln$ = Mask$
   FOR Chk = 1 TO LEN(Mask$)
      IF MID$(Mask$, Chk, 1) <> " " THEN Temp$ = Temp$ + STR$(Chk)
   NEXT Chk
   Mask$ = Temp$
END IF
S = POS(0): L = LEN(Ln$): COLOR Fg, Bg: PRINT Ln$; : IF p = 0 THEN p = 1
IF p > L THEN p = L + 1
LOCATE , S + p - 1, 1, 7, 7: Temp$ = ""
Alpha$ = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
Num$ = " 0123456789"
IF UCASE$(LEFT$(Ver$, 4)) = "A-Z#" THEN Ver$ = Alpha$ + Num$ + MID$(Ver$, 5)
SELECT CASE LEFT$(Ver$, 3)
   CASE "ALL": Caps = 0: Ver$ = Alpha$ + Num$ + "!@#$%^&*()-_+=\[]{};':,./<>? "
   CASE "A-Z": Caps = 1: Ver$ = Alpha$ + MID$(Ver$, 4)
   CASE "a-z": Caps = 2: Ver$ = Alpha$ + MID$(Ver$, 4)
   CASE "a-Z": Caps = 0: Ver$ = Alpha$ + MID$(Ver$, 4)
   CASE "#'s": Caps = 0: Ver$ = Num$ + MID$(Ver$, 4)
   CASE ELSE: Caps = 0
END SELECT

a = 0: e = 0
WHILE a <> 13 AND a <> 27 AND a <> 10
   DO
      IF Caps = 0 THEN a$ = INKEY$
      IF Caps = 1 THEN a$ = UCASE$(INKEY$)
      IF Caps = 2 THEN a$ = LCASE$(INKEY$)
   LOOP UNTIL a$ <> ""
   a = ASC(a$): IF a = 0 THEN a = ASC(RIGHT$(a$, 1)) * -1
   p = POS(0) - S + 1: R = POS(0)
   'SCREEN , , 0, 0: COLOR 7, 0: CLS : PRINT a: END
  '
  SELECT CASE a
   CASE -32                                         ' ALT-D For Dos Shell
      SCREEN , , 0, 0: CLS
      SHELL "Type EXIT [ENTER] To Return To Program"
      SHELL
   CASE -77: IF p < L + 1 THEN PRINT CHR$(28);  ELSE BEEP    ' Right arrow
   CASE -75: IF p <> 1 THEN PRINT CHR$(29);                  ' Left arrow
   CASE -71: LOCATE , S                                      ' <Home>
   CASE -119                                                 ' <Ctrl+Home>
      LOCATE , S: Ln$ = SPACE$(L): PRINT Ln$; : LOCATE , S
   CASE -79
      LOCATE , LEN(RTRIM$(Ln$)) + S                          ' <End>
   CASE -117                                                 ' <Ctrl+End>
      Ln$ = LEFT$(Ln$, p - 1) + SPACE$(L - p + 1)
      LOCATE , S, 0: PRINT Ln$; : LOCATE , R, 1
   CASE -116                                           ' <Ctrl+RightArrow>
      IF p <= L THEN
         Chk = INSTR(p, Ln$, " ")
         IF Chk <> 0 THEN
            Temp$ = LEFT$(LTRIM$(MID$(Ln$, Chk)), 1)
            IF Temp$ <> "" THEN LOCATE , S - 1 + INSTR(Chk, Ln$, Temp$), 1
         ELSE
            LOCATE , LEN(RTRIM$(Ln$)) + S
         END IF
      END IF
   CASE -115                                          ' <Ctrl+LeftArrow>
     Temp$ = RTRIM$(LEFT$(Ln$, p - 1))
     IF INSTR(Temp$, " ") THEN
        DO WHILE INSTR(Temp$, " ")
           Chk = INSTR(Temp$, " "): MID$(Temp$, Chk, 1) = "X"
        LOOP
        LOCATE , Chk + S, 1
     ELSE
        LOCATE , S
     END IF
   CASE 8                                              ' <BackSpace>
      IF p <> 1 THEN
         Ln$ = LEFT$(Ln$, p - 2) + MID$(Ln$, p) + " "
         LOCATE , S, 0: PRINT Ln$; : LOCATE , R - 1, 1
      ELSE
         Ln$ = RIGHT$(Ln$, L - 1) + " ": LOCATE , S, 0: PRINT Ln$;
         LOCATE , p + S - 1, 1
      END IF
   CASE 127                                                '<Ctrl+ BckSpc>
      IF p > L THEN p = L
      Ln$ = SPACE$(p) + MID$(Ln$, p + 1)
      LOCATE , S, 0: PRINT Ln$; : LOCATE , R, 1
   CASE -83                                                '<Delete>
      IF p <= L THEN
         Ln$ = LEFT$(Ln$, p - 1) + MID$(Ln$, p + 1) + " "
         LOCATE , S, 0: PRINT Ln$; : LOCATE , R, 1
      END IF
   CASE -82                                                '<Insert>
        IF insert = 0 THEN insert = 1 ELSE insert = 0
        IF insert = 0 THEN LOCATE , , 1, 7, 7
        IF insert = 1 THEN LOCATE , , 1, 4, 7
   CASE ELSE
      IF INSTR(Ver$, a$) AND p <= L THEN                   'Print Character
         IF insert = 1 THEN
            Ln$ = LEFT$(Ln$, p - 1) + a$ + MID$(Ln$, p, L - p + 1)
            LOCATE , , 0: PRINT MID$(Ln$, p, L - p + 1); : LOCATE , R + 1, 1
         ELSE
            PRINT a$; : MID$(Ln$, p, 1) = a$
         END IF
         IF INSTR(Mask$, STR$(p + 1)) THEN PRINT MID$(Ln$, p + 1, 1);
      ELSE IF a <> 13 AND a <> 27 THEN BEEP
      END IF
   END SELECT
WEND
'
IF a = 27 THEN Ln$ = SPACE$(L)
EndKeyIn:
Ln$ = RTRIM$(Ln$)
text$ = Ln$
END SUB

