'***************************************************
' FUNCQ.BAS - Funktion zur Quadratbildung
' =========
' (c) Thomas Antoni, 30.10.2003
'***************************************************
DECLARE FUNCTION Quadrat% (i%) 'FUNCTION deklarieren
'
CLS
FOR i% = 1 TO 20
  PRINT Quadrat%(i%)   'FUNCTION aufrufen
NEXT
SLEEP
END
'
FUNCTION Quadrat% (i%) 'FUNCTION definieren
  Quadrat% = i% ^ 2 'Wertzuweisung an die Funktion
                    'Ruecksprung zum Hauptprogramm
END FUNCTION 'und i% uebergeben
