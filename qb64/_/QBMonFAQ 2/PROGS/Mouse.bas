'*************************************************************
' MOUSE.BAS - Mausprogramm fuer den Grafikmodus
' =========
' Die Mausroutinen funtionieren in den Grafikmodi SCREENS
' 7, 8, 9, 11, 12 und 13 unter QBasic 1.1 und QuickBASIC
' 4.5 & 7.1. Da der Befehl CALL ABSOLUTE verwendet wird,
' muss QuickBASIC mit dem Parameter "/L" aufgerufen werden,
' also z.B. ueber QB /L mouse.bas. Bei QBasic ist dies nicht
' erforderlich
'
' Die Routinen wurden getestet unter unter Windows 95, 98
' und NT4.
'
' Du kannst Dein Anwenderprogramm zwischen die Befehls-
' zeilen  WHILE INKEY$ CHR$(27)
'         Mouse x, y, t
' und     WEND
' einfuegen, also statt der beiden LOCATE .. PRINT..-Befehle
'
' In den Variablen x und y findest Du die pixelgenaue
' Position des Mauszeigers pixelgenau und in "t" die
' gedrueckte Maustaste.
' Die beiden Zeilen
'          LOCATE 1: PRINT "Position der Maus:"; x; y
'          LOCATE 2: PRINT "Taste:"; t
' kannst Du in der Beta-Version Deines Anwenderprogramms
' noch drin lassen, um das "Debugging" zu erleichtern.
' Danach kannst Du sie unbesorgt loeschen.
'
'      von Paul S. Mueller
'         Email: Mueller-Staufenberg*t-online.de
'         Webseite: www.psm-home.2xs.de
'************************************************************
'
'Maustasten-Status in der Variablen t:
'linke             = 1 ; linke + mittlere  = 5
'rechte            = 2 ; rechte + mittlere = 6
'linke + rechte    = 3 ; alle              = 7
'mittlere          = 4
'
DEFINT A-Z
DECLARE SUB Mouse (x, y, t)
DECLARE SUB MousePointer (SW)
DIM SHARED a(9)
DEF SEG = VARSEG(a(0))
FOR i = 0 TO 17
  READ r
  POKE VARPTR(a(0)) + i, r
NEXT i
DATA &HB8,&H00,&H00 : DATA &H55 : DATA &H8B,&HEC
DATA &HCD,&H33      : DATA &H92 : DATA &H8B,&H5E,&H06
DATA &H89,&H07      : DATA &H5D : DATA &HCA,&H02,&H00
'
SCREEN 12
MousePointer 0
MousePointer 1 'aktiviert den Mauszeiger
MousePointer 3
WHILE INKEY$ <> CHR$(27) 'beenden mit ESC
  Mouse x, y, t
  LOCATE 1: PRINT "Position der Maus:"; x; y
  LOCATE 2: PRINT "Taste:"; t
WEND
MousePointer 2 'deaktiviert die Maus
DEF SEG
END

'
SUB Mouse (dx, cx, bx)
  POKE VARPTR(a(4)), &H92
  CALL absolute(cx, VARPTR(a(0)))
  POKE VARPTR(a(4)), &H91
  CALL absolute(dx, VARPTR(a(0)))
  POKE VARPTR(a(4)), &H93
  CALL absolute(bx, VARPTR(a(0)))
END SUB

'
SUB MousePointer (SW)
 POKE VARPTR(a(0)) + 1, SW
 CALL absolute(c, VARPTR(a(0)))
END SUB

