'*********************************
' SIRENE2.BAS = Polizei-Sirene
' ===========
' (c) Thomas Antoni, 10.4.2005
'*********************************
DO
FOR a% = 150 TO 1000 STEP 10
  SOUND a%, .3
  IF INKEY$ <> "" THEN END
NEXT
FOR a% = 1000 TO 150 STEP -10
  SOUND a%, .3
  IF INKEY$ <> "" THEN END
NEXT
LOOP

