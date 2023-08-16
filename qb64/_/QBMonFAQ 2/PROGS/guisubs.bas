'*************************************************************************
' GUISUBS.BAS = GUI Subroutines for drawing dialog boxes and generating
' ===========     menus
'               Subroutinen zur Erzeugung von Bedienungsoberflaechen
'                 mit Dialogboxen und Menues
'
' (c) by JOHN WOODGATE, Sept. 18, 1993
'*************************************************************************
'
DEFINT A-Z
'
DECLARE SUB DrawBox (TOPROW%, LFTCOL%, BOTROW%, RTCOL%, BORDER%)
DECLARE SUB CloseBox (TOPROW%, LFTCOL%, BOTROW%, RTCOL%)
DECLARE SUB PokeChar (row%, col1, col2, segmnt)
DECLARE SUB SBox (title$, bstyle%, lgnth%, Selections$(), selec%)
DECLARE SUB YesNoBox (Message$, Answer%)
DECLARE SUB NewInput (Message$, bstyle%, mask%, Answer$)
'
DIM SHARED chars%(1 TO 4000), box%, lastchar%
DIM SHARED colors%(1 TO 4000), boxstart%
DIM SHARED boxes%(1 TO 30), ends%(1 TO 30)
DIM SHARED Selections$(1 TO 20), FG%, BG%
DIM SHARED COLORDISPLAY%
'
FG% = 15: BG% = 0
COLORDISPLAY% = 0
'
' Start of Demo...
'
COLOR FG%, BG%
FOR a = 1 TO 25
  LOCATE a, 1
  PRINT STRING$(80, CHR$(176));
NEXT a
CALL DrawBox(9, 12, 13, 67, 2)
LOCATE 11, 14: PRINT "User Interface Routines, Written By: John Woodgate"
SLEEP 3
CALL CloseBox(9, 12, 13, 67)
'
FOR a = 1 TO 10
  Selections$(a) = "     Selection #" + LTRIM$(STR$(a))
NEXT a
CALL SBox("Pick One", 2, 25, Selections$(), selec)
CALL DrawBox(9, 20, 13, 60, 1)
LOCATE 11, 27: PRINT "You Picked Selection #"; LTRIM$(STR$(selec))
SLEEP 4
CALL CloseBox(9, 20, 13, 60)
'
CALL NewInput("Enter anything :", 1, 0, Answer$)
CALL DrawBox(9, 15, 13, 65, 2)
LOCATE 11, 17: PRINT "You can also mask your input, like this"
SLEEP 3
CALL CloseBox(9, 15, 13, 65)
CALL NewInput("Enter anything :", 1, 33, Answer$)
'
CALL YesNoBox("Do You like this program", Answer%)
IF Answer% = 0 THEN
 Msg$ = "Aw, Too bad..."
ELSEIF Answer% = 2 THEN
 Msg$ = "Aw, Too bad..."
ELSE
 Msg$ = "I'm glad you like em..."
END IF
CALL DrawBox(9, 20, 13, 60, 2)
LOCATE 11, 28: PRINT Msg$
SLEEP 3
CALL CloseBox(9, 20, 13, 60)

'
SUB CloseBox (TOPROW%, LFTCOL%, BOTROW%, RTCOL%)
DEF SEG = 0
IF PEEK(&H463) = &HB4 THEN
  DEF SEG = &HB000
ELSE
  DEF SEG = &HB800
END IF
IF box% = 0 THEN EXIT SUB
z = boxes%(box%)
FOR a = TOPROW% TO BOTROW%
  row% = a: col1% = LFTCOL%: col2% = RTCOL%: segmnt% = z
  CALL PokeChar(row%, col1%, col2%, segmnt%)
  z = z + (RTCOL% - LFTCOL% + 1)
NEXT a
box% = box% - 1
IF box% = 0 THEN
  lastchar% = 0: boxstart% = 0
ELSE
  boxstart% = boxes%(box%): lastchar% = ends%(box%)
END IF
DEF SEG
END SUB

'
SUB DrawBox (TOPROW%, LFTCOL%, BOTROW%, RTCOL%, BORDER%)
z = lastchar%
IF z >= 3900 THEN EXIT SUB
boxstart% = z + 1: box% = box% + 1: boxes%(box%) = lastchar% + 1
FOR a = TOPROW% TO BOTROW%
   FOR b = LFTCOL% TO RTCOL%
      z = z + 1
      chars%(z) = SCREEN(a, b, 0): colors%(z) = SCREEN(a, b, 1)
   NEXT b
NEXT a
lastchar% = z: ends%(box%) = z
'
IF BORDER% = 0 THEN
 lt$ = CHR$(32): lb$ = CHR$(32): rt$ = CHR$(32): rb$ = CHR$(32)
 v$ = CHR$(32): h$ = CHR$(32)
END IF
IF BORDER% = 1 THEN
 lt$ = CHR$(218): lb$ = CHR$(192): rt$ = CHR$(191): rb$ = CHR$(217)
 v$ = CHR$(179): h$ = CHR$(196)
END IF
IF BORDER% = 2 THEN
 lt$ = CHR$(201): lb$ = CHR$(200): rt$ = CHR$(187): rb$ = CHR$(188)
 v$ = CHR$(186): h$ = CHR$(205)
END IF
IF BORDER% = 3 THEN
 lt$ = CHR$(213): lb$ = CHR$(212): rt$ = CHR$(184): rb$ = CHR$(190)
 v$ = CHR$(179): h$ = CHR$(205)
END IF
IF BORDER% = 4 THEN
 lt$ = CHR$(214): lb$ = CHR$(211): rt$ = CHR$(183): rb$ = CHR$(189)
 v$ = CHR$(186): h$ = CHR$(196)
END IF
'
top$ = lt$ + STRING$((RTCOL% - LFTCOL%) - 1, h$) + rt$
md$ = v$ + SPACE$((RTCOL% - LFTCOL%) - 1) + v$
bot$ = lb$ + STRING$((RTCOL% - LFTCOL%) - 1, h$) + rb$
LOCATE TOPROW%, LFTCOL%: PRINT top$;
FOR a = TOPROW% + 1 TO BOTROW% - 1
 LOCATE a, LFTCOL%: PRINT md$;
NEXT a
LOCATE BOTROW%, LFTCOL%: PRINT bot$;
END SUB

'
SUB NewInput (Message$, bstyle%, mask%, Answer$)
Answer$ = "": buffer$ = ""
IF mask% > 255 THEN mask% = 0
IF mask% < 0 THEN mask% = 0
CALL DrawBox(9, 35 - LEN(Message$), 13, LEN(Message$) + 45, bstyle%)
srt% = 35 - LEN(Message$) + (LEN(Message$) + 2)
LOCATE 11, 35 - LEN(Message$) + 2
PRINT Message$;
COLOR 0, 15
LOCATE 11, srt%
bxlen% = (LEN(Message$) + 45) - (35 - LEN(Message$))
PRINT SPACE$(bxlen% - LEN(Message$) - 2)
last% = LEN(Message$) + 45 - 1
strt% = 35 - LEN(Message$) + LEN(Message$) + 2
LOCATE 11, strt%, 1
curr% = strt%
COLOR 0, 15
bffer$ = ""
'
   WHILE NOT finished
   GOSUB GetKeys
   SELECT CASE Kbd$
    CASE CHR$(13)
     CALL CloseBox(9, 35 - LEN(Message$), 13, LEN(Message$) + 45)
     Answer$ = bffer$
     LOCATE , , 0
     COLOR 15, 0
     EXIT SUB
    CASE CHR$(27)
     Answer$ = ""
     CALL CloseBox(9, 35 - LEN(Message$), 13, LEN(Message$) + 45)
     LOCATE , , 0
     COLOR 15, 0
     EXIT SUB
    CASE CHR$(8)
     IF curr% > strt% THEN
      bffer$ = LEFT$(bffer$, LEN(bffer$) - 1)
      LOCATE , , 0
      curr% = curr% - 1
      LOCATE 11, curr%
      PRINT " ";
      LOCATE 11, curr%, 1
     END IF
    CASE CHR$(32) TO CHR$(126)
     IF curr% < last% THEN
      IF mask% = 0 THEN
       bffer$ = bffer$ + Kbd$
       LOCATE 11, curr%
       PRINT Kbd$;
       curr% = curr% + 1
       LOCATE 11, curr%
      ELSE
       bffer$ = bffer$ + Kbd$
       LOCATE 11, curr%
       PRINT CHR$(mask%)
       curr% = curr% + 1
       LOCATE 11, curr%
      END IF
     END IF
   END SELECT
   WEND
EXIT SUB

GetKeys:
Kbd$ = ""
WHILE Kbd$ = "":
      Kbd$ = INKEY$
WEND
RETURN
END SUB

'
SUB PokeChar (row%, col1%, col2%, segmnt%)
segment = row% * 160 - 160: segment = segment + col1% * 2 - 2
colorseg% = segment + 1
FOR c = segmnt% TO segmnt% + (col2% - col1%)
  POKE segment, chars%(c): POKE colorseg, colors%(c)
  segment = segment + 2: colorseg = colorseg + 2
NEXT c
END SUB

'
SUB SBox (title$, bstyle%, lgnth%, Selections$(), selec%)
start% = 1
FOR a = 1 TO 20
  IF Selections$(a) = "" THEN
   last% = a - 1
   EXIT FOR
  END IF
NEXT a
IF last% = 0 THEN last% = 20
numrows% = last%
firstrow% = 12 - (last% \ 2) - 1
lastrow% = firstrow% + numrows% + 1
firstcol% = 40 - (lgnth% \ 2)
tmp% = LEN(Selections$(1))
COLOR FG%, BG%
CALL DrawBox(firstrow%, firstcol%, lastrow%, firstcol% + lgnth%, bstyle%)
LOCATE firstrow%, firstcol% + 2
PRINT SPACE$(1); title$; SPACE$(1);
srt% = firstrow% + 1
FOR a = 1 TO last%
  IF a = 1 THEN
   COLOR BG%, FG%
   LOCATE srt%, firstcol% + 1
   PRINT Selections$(a); SPACE$(lgnth% - LEN(Selections$(a)) - 1)
  ELSE
   COLOR FG%, BG%
   LOCATE srt%, firstcol% + 1
   PRINT Selections$(a); SPACE$(lgnth% - LEN(Selections$(a)) - 1)
  END IF
  srt% = srt% + 1
NEXT a
row% = firstrow% + 1
selec% = 1
'
   WHILE NOT finished
   GOSUB GKS
   SELECT CASE Kbd$
    CASE CHR$(0) + "P"
     GOSUB Scroll2Down
    CASE CHR$(0) + "H"
     GOSUB Scroll2Up
    CASE CHR$(27)
     CALL CloseBox(firstrow%, firstcol%, lastrow%, firstcol% + lgnth%)
     COLOR FG%, BG%
     selec% = 0
     EXIT SUB
    CASE CHR$(13)
     CALL CloseBox(firstrow%, firstcol%, lastrow%, firstcol% + lgnth%)
     COLOR FG%, BG%
     EXIT SUB
   END SELECT
   WEND
EXIT SUB
'
GKS:
Kbd$ = ""
WHILE Kbd$ = "":
      Kbd$ = INKEY$
WEND
RETURN
'
Scroll2Up:
 COLOR FG%, BG%
 LOCATE row%, firstcol% + 1
 PRINT Selections$(selec%); SPACE$(lgnth% - LEN(Selections$(selec%)) - 1)
 IF selec% = 1 THEN
  row% = lastrow% - 1
  selec% = last%
 ELSE
  row% = row% - 1
  selec% = selec% - 1
 END IF
 COLOR BG%, FG%
 LOCATE row%, firstcol% + 1
 PRINT Selections$(selec%); SPACE$(lgnth% - LEN(Selections$(selec%)) - 1)
 RETURN
'
Scroll2Down:
 COLOR FG%, BG%
 LOCATE row%, firstcol% + 1
 PRINT Selections$(selec%); SPACE$(lgnth% - LEN(Selections$(selec%)) - 1)
 IF selec% = last% THEN
  row% = firstrow% + 1
  selec% = 1
 ELSE
  row% = row% + 1
  selec% = selec% + 1
 END IF
 COLOR BG%, FG%
 LOCATE row%, firstcol% + 1
 PRINT Selections$(selec%); SPACE$(lgnth% - LEN(Selections$(selec%)) - 1)
 RETURN
END SUB

'
SUB YesNoBox (Message$, Answer%)
sl% = 1
IF COLORDISPLAY% THEN
  COLOR 2, 15
ELSE
  COLOR 15, 0
END IF
CALL DrawBox(9, 15, 15, 65, 1)
IF COLORDISPLAY% THEN
  COLOR 2, 15
ELSE
  COLOR 15, 0
END IF
LOCATE 10, 18
PRINT "Confirm:"

LOCATE 12, 18
PRINT Message$; " ?"
LOCATE 13, 15
PRINT CHR$(195); STRING$(49, CHR$(196)); CHR$(180);
LOCATE 14, 18
PRINT "Action:"
IF COLORDISPLAY% THEN
  COLOR 15, 0
ELSE
  COLOR 0, 15
END IF
LOCATE 14, 51
PRINT " Yes "
IF COLORDISPLAY% THEN
  COLOR 2, 15
ELSE
  COLOR 15, 0
END IF
LOCATE 14, 58
PRINT " No "
  DO
    GOSUB GetK
    IF Kbd$ = CHR$(13) THEN
      Answer% = sl%
      COLOR 15, 0
      CALL CloseBox(9, 15, 15, 65)
      EXIT SUB
    END IF
    IF Kbd$ = CHR$(0) + "M" THEN
      IF sl% = 1 THEN
        IF COLORDISPLAY% THEN
          COLOR 2, 15
        ELSE
          COLOR 15, 0
        END IF
        LOCATE 14, 51
        PRINT " Yes "
        IF COLORDISPLAY% THEN
          COLOR 15, 0
        ELSE
          COLOR 0, 15
        END IF
        LOCATE 14, 58
        PRINT " No "
        sl% = 2
      END IF
    END IF
    IF Kbd$ = CHR$(0) + "K" THEN
      IF sl% = 2 THEN
        IF COLORDISPLAY% THEN
          COLOR 15, 0
        ELSE
          COLOR 0, 15
        END IF
        LOCATE 14, 51
        PRINT " Yes "
        IF COLORDISPLAY% THEN
          COLOR 2, 15
        ELSE
          COLOR 15, 0
        END IF
        LOCATE 14, 58
        PRINT " No "
        sl% = 1
      END IF
    END IF
    IF Kbd$ = CHR$(27) THEN
      CALL CloseBox(9, 15, 15, 65)
      Answer% = 0
      EXIT SUB
    END IF
  LOOP
'
GetK:
Kbd$ = ""
Kbd$ = INKEY$
RETURN
END SUB

