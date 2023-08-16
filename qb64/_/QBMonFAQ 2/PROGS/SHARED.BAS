'***************************************************************
' SHARED.BAS = Variable in Hauptprogramm u.SUB gemeinsam nutzen
' =========
' Dieses Programm demonstriert die SHARED-Funktion, die es
' ermoeglicht, dieselbe Variable sowohl im Hauptprogramm als
' auch in einer SUB/FUNCTION
' gemeinsam zu benutzen
'
' (c) Breeze und Thomas Antoni, 23.7.2003
'***************************************************************
'
DECLARE SUB Test ()
'
DIM Variable AS INTEGER
CALL Test
PRINT Variable

SUB Test
  SHARED Variable AS INTEGER
  Variable = 10
END SUB

