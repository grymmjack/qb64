'**************************************************************
' SHOWTXT3.BAS - Text mit automatischem Zeilenumbruch anzeigen
' ============
' von Peter Vollenweider (peter.vollenweider*gmx.ch), 11.7.2001
'==============================================================
DECLARE SUB zeilenUmbruchPrint (text$)
CLS
PRINT "gib einen mehrzeiligen Text ein, bestehend aus Worten!"
PRINT "... max 3 Zeilen: "
INPUT ; text$
PRINT
PRINT
PRINT "Der umgebrochene Text sieht so aus: "
PRINT
CALL zeilenUmbruchPrint(text$)

DEFINT A-Z
'
SUB zeilenUmbruchPrint (text$)
ort = INSTR(text$, CHR$(13))
laenge = LEN(text$)
IF ort THEN
  zeilenUmbruchPrint LEFT$(text$, ort)
  zeilenUmbruchPrint RIGHT$(text$, laenge - ort)
  EXIT SUB
END IF
IF laenge > 80 THEN
  FOR x = 80 TO 1 STEP -1
    IF MID$(text$, x, 1) = " " THEN
      PRINT LEFT$(text$, x)
      zeilenUmbruchPrint RIGHT$(text$, laenge - x)
      EXIT SUB
    END IF
  NEXT
  FOR x = 80 TO 1 STEP -1
    IF MID$(text$, x, 1) = "." THEN
      PRINT LEFT$(text$, x)
      zeilenUmbruchPrint RIGHT$(text$, laenge - x)
      EXIT SUB
    END IF
  NEXT
  FOR x = 80 TO 1 STEP -1
    ascii = ASC(MID$(text$, x, 1))
    IF NOT ((ascii > 64 AND ascii < 91) OR (ascii > 96 AND ascii < 123)) THEN
      PRINT LEFT$(text$, x): zeilenUmbruchPrint RIGHT$(text$, laenge - x)
      EXIT SUB
    END IF
  NEXT
  PRINT LEFT$(text$, 80): zeilenUmbruchPrint RIGHT$(text$, laenge - 80)
ELSE PRINT text$
END IF
END SUB

