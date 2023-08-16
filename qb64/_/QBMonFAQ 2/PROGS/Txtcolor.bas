'*****************************************************
' TXTCOLOR.BAS - Textanzeige mit farblich
' ============    unterschiedlichen Buchstaben
'
' - MIN ist die Minimalfarbe.
' - MAX ist die Maximalfarbe.
' - Farb ist die aktuelle Farbe
'
' Farb wird pro Buchstabe solange um "1" erhöht, bis
' MAX erreicht ist. Dann wird Farb zurück auf MIN
' zurueckgesetzt.
'
' Beispiel
' --------
' - Minimalfarbe soll 10 sein
' - Maximalfarbe soll 15 sein
' - Text soll "Hallo" sein.
'  ==> Dann tippst du im Hauptmodul:
'        CALL TXTCOLOR ("Hallo", 10, 15)
'
'(c) Mecki ( armark*t-online.de ), 10.12.02
'=====================================================
DECLARE SUB TXTCOLOR (T$, min!, max!)
'
CLS
CALL TXTCOLOR("Herzliche Gruesse von Mecki", 10, 15)
SLEEP

'
SUB TXTCOLOR (T$, min, max)
Farb = min
FOR A = 1 TO LEN(T$)
  COLOR Farb
  PRINT MID$(T$, A, 1);
  Farb = Farb + 1
  IF Farb = max THEN Farb = min
NEXT A
END SUB

