'***********************************************************
' DEC2BIN1.BAS = Zahlenkonvertierung Dezimal -> Binaer
'***********************************************************
DO
  INPUT "Gib die Dezimalzahl ein.....: ", decimal&
  Bin$ = ""
  h$ = HEX$(decimal&)
  FOR i% = 1 TO LEN(h$)
    digit% = INSTR("0123456789ABCDEF", MID$(h$, i%, 1)) - 1
    IF digit% < 0 THEN Bin$ = "": EXIT FOR
    j% = 8: k% = 4
    DO
      Bin$ = Bin$ + RIGHT$(STR$((digit% \ j%) MOD 2), 1)
      j% = j% - (j% \ 2): k% = k% - 1
      IF k% = 0 THEN EXIT DO
    LOOP WHILE j%
  NEXT i%
PRINT "Die Binaerzahl lautet.......: "; Bin$
PRINT
PRINT "...Wiederholen mit belieb. Taste ...Beenden mit Esc"
PRINT
t$ = INPUT$(1)            'eine Taste einlesen
IF t$ = CHR$(27) THEN END 'beenden bei Esc-Taste
LOOP



