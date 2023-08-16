'**********************************************************
' REKURS.BAS = Eine SUB ruft sich selbst auf ("Rekursion")
' ==========
' (c) Thomas Antoni, 28.7.05
'**********************************************************
DECLARE SUB RekursivAufruf(n%)
'
CALL RekursivAufruf(5)
'
SUB RekursivAufruf(n%)
PRINT "Jetzt sind wir auf Aufrufebene"; n%
IF n% > 0 THEN
CALL RekursivAufruf(n% - 1)
END IF
PRINT "Jetzt sind wir wieder auf Ebene"; n%
END SUB
