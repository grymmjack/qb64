'****************************************************
' BLOKSATZ.BAS = Text in Blocksatz formatieren
' ============
' Dieses QBasic-Programm formatiert einen
' kleinen text im Blocksatz
' (c) ZaPPa (dc-ware*onlinehome.de) , 7.3.-8.12.2003
'
'****************************************************
DECLARE FUNCTION Block$ (A$)
CLS
PRINT Block$("Dies wird ein grosser Test der BLOCKsatz-Funktion.");
PRINT
PRINT Block$("Hoffentlich klappt es ohne Probleme.");
PRINT
PRINT Block$("Mann is das lustig, soviel zu tippen.");
PRINT
PRINT Block$("Ich hab keinen Bock mehr!");
PRINT
PRINT Block$("Jetzt reichts aber so langsam!");
PRINT
PRINT Block$("Jetzt is endlich Schluss.");

'
FUNCTION Block$ (A$)
Laenge = LEN(A$)
FOR L = 1 TO Laenge
  IF MID$(A$, L, 1) = " " THEN Leerzeichen = Leerzeichen + 1
NEXT
Nur.Zeichen = Laenge - Leerzeichen
Rest.Zeichen = 80 - Nur.Zeichen
Tab.Zeichen = INT(Rest.Zeichen / Leerzeichen)
DIM Zeichen(81) AS STRING
A = 1
L = 0
DO
  L = L + 1
  SIGN$ = MID$(A$, L, 1)
  IF SIGN$ = " " THEN A = A + 1: GOTO NeuesWort
  IF SIGN$ <> " " THEN Zeichen(A) = Zeichen(A) + SIGN$
NeuesWort:
LOOP UNTIL L >= Laenge
FOR L = 1 TO A
  End.String$ = End.String$ + Zeichen(L) + SPACE$(Tab.Zeichen)
NEXT

End.String$ = MID$(End.String$, 1, 80)
End.String$ = RTRIM$(LTRIM$(End.String$))
LOL = LEN(End.String$)
IF LOL <> 80 THEN
 RestLaenge = 80 - LOL - 1
 BreakPos = INSTR(1, End.String$, " ")
 P1$ = LEFT$(End.String$, BreakPos + 1)
 P2$ = RIGHT$(End.String$, LEN(End.String$) - BreakPos)
 End.String$ = P1$ + SPACE$(RestLaenge) + P2$
END IF

Block$ = End.String$
END FUNCTION

