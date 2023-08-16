'********************************************************
' FASTFAK.BAS = Schnelle Fakultaetsberechnung
' ===========
' Mit einem gegenueber dem QBasic-Standard stark
' erweiterten Zahlenbereich. Damit wird der normalerweise
' mögliche Wertebereich von 170! auf viele 1000 erhöht
'
' (c) Rocco Lavella ("RockTheShock"), 21.10.2003
'     http://galileo.spaceports.com/~rba/
'********************************************************
DECLARE SUB PrintFak ()
DECLARE SUB fak (n%)
DEFINT A-Z
'
CONST FDI = 10000
CONST FDL = 14000
REDIM SHARED longFeld(FDL) AS LONG
CLS
PRINT "Super-Fast-Faculty (C)Copyright Rocco Lavella 2002"
PRINT
INPUT "Fakult„t von: ", n
PRINT
time1! = TIMER
  fak n
time2! = TIMER
PrintFak
PRINT "Ziffern:"; longFeld(0)
PRINT "Zeit:   "; time2! - time1!; "Sekunden"

SUB fak (n) STATIC
DIM feld(FDI) AS INTEGER
ERASE feld
REDIM longFeld(FDL) AS LONG
'
feld(FDI) = 1
nd% = 1
FOR i = 1 TO n
  FOR k = FDI - nd% TO FDI
    feld(k) = feld(k) * i
  NEXT k
  DO
    k = k - 1
    feld(k - 1) = feld(k - 1) + feld(k) \ 10
    IF feld(k - 1) AND FDI - k + 1 = nd% THEN nd% = nd% + 1
      feld(k) = feld(k) MOD 10
    LOOP UNTIL k = FDI - nd%
    IF i = 3200 THEN EXIT FOR
    LOCATE 5, 1: PRINT i
NEXT i
'
j2 = FDL
FOR j = FDI TO FDI - nd% STEP -1
  longFeld(j2) = feld(j)
  j2 = j2 - 1
NEXT
'
IF n > i THEN
  FOR i = i + 1 TO n
    FOR k = FDL - nd% TO FDL
      longFeld(k) = longFeld(k) * i
    NEXT k
    DO
      k = k - 1
      longFeld(k - 1) = longFeld(k - 1) + longFeld(k) \ 10
      IF longFeld(k - 1) AND FDL - k + 1 = nd% THEN nd% = nd% + 1
      longFeld(k) = longFeld(k) MOD 10
    LOOP UNTIL k = FDL - nd%
    LOCATE 5, 1: PRINT i
 NEXT i
END IF
'
longFeld(0) = nd%
END SUB

SUB PrintFak
FOR j = FDL - longFeld(0) + 1 TO FDL
  PRINT LTRIM$(STR$(longFeld(j)));
NEXT
PRINT
END SUB

