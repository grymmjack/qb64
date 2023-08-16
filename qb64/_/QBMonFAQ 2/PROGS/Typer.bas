'****************************************************
' TYPER.BAS - QBasic-Programm zum Anzeigen von Text
' =========   mit Schreibmaschineneffekt
'
' Uebergabeparameter der SUB Textprint:
' - Text$  = Auszugebener Text
' - X%, Y% = Position
' - Speed  = Geschwindigkeit in ms (1000ms = 1s)
'
' (c) Jan Tuttas ( Jan-Tuttas*web.de ), 5.7.02
'****************************************************
DECLARE SUB Textprint (Text$, X%, Y%, Speed!)
CLS
INPUT "Gib Text ein"; Text$
CALL Textprint(Text$, 3, 12, 150)
SLEEP

 

'
SUB Textprint (Text$, X%, Y%, Speed)
LOCATE X%, Y%
FOR i% = 1 TO LEN(Text$)
  z$ = MID$(Text$, i%, 1)
  PRINT z$;
  t = TIMER
  IF z$ <> " " THEN SOUND 100, .5 'kein Sound bei Leerzeichen
  WHILE TIMER < t + Speed / 1000: WEND
  IF INKEY$ = CHR$(27) THEN EXIT SUB
NEXT i%
END SUB

