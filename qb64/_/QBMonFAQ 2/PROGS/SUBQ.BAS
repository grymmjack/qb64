'********************************************
' SUBQ.BAS - Subroutine zur Quadratbildung
' ========
' (c) Thomas Antoni, 29.10.2003
'********************************************
DECLARE SUB Quadrat (i%) 'SUB deklarieren
'
CLS
FOR i% = 1 TO 20
  CALL Quadrat(i%)  'Subroutine aufrufen
NEXT
SLEEP
END

'
SUB Quadrat (i%)    'Subroutine dedefinieren
  PRINT i% ^ 2
END SUB             'Rueckkehr zum Hauptprogram

