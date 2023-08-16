'***********************************************
' LOTTO.BAS = Lottozahlengenerator (6 aus 49)
' =========
'
' (c) Skilltronic, 16.7.2003
'***********************************************
'
FOR ziehung = 1 TO 6
  DO
    RANDOMIZE TIMER
    zahl(ziehung) = FIX(RND * 49) + 1
    test = 0
    FOR alte = 1 TO ziehung - 1
      IF zahl(ziehung) = zahl(alte) THEN test = 1
    NEXT
  LOOP WHILE test = 1
  PRINT zahl(ziehung)
NEXT
END

