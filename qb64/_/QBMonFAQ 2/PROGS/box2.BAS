'****************************************************************************
' BOX2.BAS = Anzeige eines Kastens mit vielen Gestaltungsmoeglichkeiten
' ========
'
' (c) Thomas Antoni, 29.7.05
'       Unter Verwendung der Routine "BOX" aus der Unterprogrammsammlung
'       QSUBFUN.BAS von Matthew R. Usner
'****************************************************************************
DECLARE SUB Box (Row%, Column%, BoxWidth%, Height%, BoxColor%, BoxCharacter%, BorderType%, BorderColor%)
CLS
FOR i% = 0 TO 2 'Alle 3 BorderTypes (Randlinienarten)  demonstrieren
  CALL Box(i% * 7 + 4, 5, 70, 5, 4, 219, i%, 1)
NEXT i%

'
SUB Box (Row%, Column%, BoxWidth%, Height%, BoxColor%, BoxCharacter%, BorderType%, BorderColor%)
'*******************************************************************************
'*  BOX
'* =====
'* Displays a box of definable attributes on the text-mode screen
'* Parameters (Anzeige eines Kastens mit vielen Gestaltungsmoeglichkeiten
'* auf dem Textbildschirm SCREEN 1):
'* - Row%          = Row of the upper left corner (Spalte oben links)
'* - Column%       = Column of the upper left corner (Zeile oben links)
'* - BoxWidth%     = Width of the Box (Kastenbreite)
'* - Height%       = Height of the box (Kastenhoehe)
'* - BoxColor%     = Filling color of the box (Füllfarbe des Kasteninneren)
'* - BoxCharacter% = Filling character of the box (Fuellzeichen, z.B.
'*                   CHR$(219)) = ausgefuelltes Kastenzeichen)
'* - BorderType%: 0= No border (keine Kastenumrandung)
'*                1= single-line border (Einfachlinie als Kastenumrandung)
'*                2= double-line border (Doppellinie als Kastenumrandung)
'* - BorderColor%  = Color of the border line (Farbe der Kastenumrandung)
'*******************************************************************************
StartRow% = Row%
SELECT CASE BorderType%
'
'--------no border
   CASE 0
      UpperLeft$ = CHR$(BoxCharacter%)
      UpperRight$ = CHR$(BoxCharacter%)
      LowerLeft$ = CHR$(BoxCharacter%)
      LowerRight$ = CHR$(BoxCharacter%)
      Vertical$ = CHR$(BoxCharacter%)
      Horizontal$ = CHR$(BoxCharacter%)
'-------- single border
'
   CASE 1
      UpperLeft$ = CHR$(218)
      UpperRight$ = CHR$(191)
      LowerLeft$ = CHR$(192)
      LowerRight$ = CHR$(217)
      Vertical$ = CHR$(179)
      Horizontal$ = CHR$(196)
'
'--------- double border
   CASE 2
      UpperLeft$ = CHR$(201)
      UpperRight$ = CHR$(187)
      LowerLeft$ = CHR$(200)
      LowerRight$ = CHR$(188)
      Vertical$ = CHR$(186)
      Horizontal$ = CHR$(205)
END SELECT
'
InnerWidth% = BoxWidth% - 2
InnerHeight% = Height% - 2
InnerFilling$ = STRING$(InnerWidth%, CHR$(BoxCharacter%))
BoxTopBottom$ = STRING$(InnerWidth%, Horizontal$)
'
COLOR BorderColor%, BoxColor%
LOCATE StartRow%, Column%
PRINT UpperLeft$ + BoxTopBottom$ + UpperRight$;
StartRow% = StartRow% + 1
'
FOR FillLoop% = 1 TO InnerHeight%
    LOCATE StartRow%, Column%
    PRINT Vertical$ + InnerFilling$ + Vertical$;
    StartRow% = StartRow% + 1
NEXT FillLoop%
'
LOCATE StartRow%, Column%
PRINT LowerLeft$ + BoxTopBottom$ + LowerRight$;
END SUB

