'*************************************************************
' BIN2DEC2.BAS = Binaerzahl in Dezimalzahl wandeln
' ============
'*************************************************************
PRINT "Gib eine aus Nullen und Einsen bestehende"
PRINT "Binaerzahl ein (max. 32 Bits)"
INPUT bin$
a& = 0
FOR n% = 1 TO LEN(bin$)
  IF MID$(bin$, 1 + LEN(bin$) - n%, 1) = "1" THEN
    a& = a& + 2 ^ (n% - 1)
  END IF
NEXT n%
PRINT "die umgewandelte Zahl lautet"; a& '32 bit Double Word



