'*************************************************************************
' MENUPULL.BAS = Pulldown menu in QBasic
' ============   Komfortables Pulldown-Menue mit Tastenbedienung
'
' Deutsche Beschreibung
' ----------------------
' Dieses Q(uick)Basic-Programm erzeugt ein grafisch sehr ansprechendes
' PulldownMenue, das leicht an eigene Beduerfnisse angepasst werden
' kann. Die Navigation erfolgt ueber die Cursortatsen. Eine Maus wird
' nicht unterstÅtzt.
'
' English Description
' ----------------------
' Here's a neat-o-roonie pulldown menu routine that I'm sure SOMEBODY
' will find good... nothing too spectacular, but useful anyways.
' This code is entirely PD but if you use it please put my name
' in your program somewhere however you don't have to if you
' don't want to
'
' (c) by Calvin French, July 16, 1993
'**************************************************************************
'
DEFINT A-Z
'------ USED BY SUPERMENU
DECLARE SUB PullDownMenu (y1, TopX1(), BoxX1(), BoxX2(), LastOpt(), MenuDat$(), Fore, Back, SelectFore, SelectBack, hilightfore, hilightback, KeyFore, ReturnX, ReturnY)
DECLARE SUB DrawShadow (x1, y1, x2, y2)
'----------------------------
DECLARE SUB DrawScreen ()             '<-- these ARE NOT used by SuperMenu
DECLARE SUB DrawBox (x1, y1, x2, y2)  '<---'
'
CONST true = -1, false = 0
'
'To save space, I'll illustrate how the menu is set up, and then
'just read the rest of the menu data from DATA statments, ok?
'
REDIM MenuDat$(5, 7)
'
' First element (8): This is the total number of headers that the
'                    menu has
' Second element (7): This is the highest number of options, including
'                    separator lines, that your menu has
'
MenuDat$(1, 0) = " File "
'
' The 0th second element of each array is the header.
'
MenuDat$(1, 1) = " ^New Program"
'
' The carat (^) is used to illustrate a hotkey.
' NOTE: YOU MUST SPECIFY ONE HOTKEY PER MENU OPTION!
'
MenuDat$(1, 2) = " ^Open Program"
MenuDat$(1, 3) = " Save ^As"
MenuDat$(1, 4) = "^:"
'
' The "^:" means put a line separator in there.
'
MenuDat$(1, 5) = " ^Print"
MenuDat$(1, 6) = "^:"
MenuDat$(1, 7) = " E^xit"
TopX1(1) = 3
'
' This is the X location where the header (e.g., " File ") is to appear
'
'
BoxX1(1) = 2
'
' This is the X location where the left hand side of the box is to be
'
BoxX2(1) = 20
'
' This is the X location where the right hand side of the box is to be
'
LastOpt(1) = 7
'
' This is the number of options in the particular menu
'
'
'Now, to save space, I'll just read the rest of them...
FOR n = 2 TO 5
  READ LastOpt(n)
  READ TopX1(n)
  READ BoxX1(n)
  READ BoxX2(n)
  FOR x = 0 TO LastOpt(n)
    READ MenuDat$(n, x)
  NEXT x
NEXT n
'--------------------------------
'Effiecient way of doing toggles:
DIM ToggleChar$(-1 TO 0)      'true false
ToggleChar$(-1) = CHR$(254)
ToggleChar$(0) = " "
'
Toggle1 = false       'off
'
Fore = 0              'color for menu
Back = 7
SelectFore = 15       'color for topic bar. QB uses 7, 0 but i like 15, 1
SelectBack = 1
hilightfore = 7       'color for menu bar inside menu
hilightback = 0
KeyFore = 15          'hilight color for hotkeys
y1 = 1                'the Y loc you want the menu to appear on
COLOR 15, 1
PRINT STRING$(2000, 176);
'
DrawScreen
'
DO
  MenuDat$(4, 4) = ToggleChar$(Toggle1) + "^Toggle 1"
  PullDownMenu 1, TopX1(), BoxX1(), BoxX2(), LastOpt(), MenuDat$(), Fore, Back, SelectFore, SelectBack, hilightfore, hilightback, KeyFore, ReturnX, ReturnY
  'ReturnX is the returned X value
  'ReturnY is the returned Y value
  '
  'If you set it up to reroute ReturnX/ReturnY, you will be able to keep
  'the menu bar on the option the user last selected... nice...
  IF ReturnX = 4 AND ReturnY = 4 THEN Toggle1 = NOT Toggle1
LOOP UNTIL ReturnX = 1 AND ReturnY = 7
'
COLOR 7, 0
CLS
PRINT "Calvin French, 1993"
PRINT "Seeya!"
END
'
'
'Menu data. I did it like this to save space. You don't have to do it like
' this (read it into the array)
PulldownMenuData:
DATA 3,9,8,32," Edit "," Cu^t         Shift+DEL"," ^Copy         Ctrl+INS"," ^Paste       Shift+INS"
DATA 3,15,14,39," View "," ^SUBs...            F2"," O^utput Screen      F4"," Included ^Lines"
DATA 4,21,20,48," Search "," ^Find..."," ^Change...","^:","^Toggle 1"
DATA 4,72,51,78," Help "," ^Index"," ^Contents"," ^Topic:                F1"," ^Help on Help    Shift+F1"

'
'
SUB DrawBox (x1, y1, x2, y2)
LOCATE y1, x1
PRINT CHR$(218); STRING$(x2 - x1 - 2, 196); CHR$(191);
'
FOR n = y1 + 1 TO y2 - 1
  LOCATE n, x1
  PRINT CHR$(179); SPACE$(x2 - x1 - 2); CHR$(179);
NEXT n
'
LOCATE y2, x1
PRINT CHR$(192); STRING$(x2 - x1 - 2, 196); CHR$(217);
DrawShadow x1, y1, x2, y2
END SUB

'
'
SUB DrawScreen
COLOR 15, 0
DrawBox 9, 6, 70, 19
COLOR 15, 0
LOCATE 7, 10
PRINT " C-SMENU1.1, By Calvin French, May (sometime) 1993         "
COLOR 14
LOCATE 8, 10
PRINT "-----------------------------------------------------------"
COLOR 13
LOCATE 9, 10
PRINT " This is a small and power packed versitile pulldown menu  "
LOCATE 10, 10
PRINT " routine I put together awhile ago. I've added shadows in  "
LOCATE 11, 10
PRINT " This version, 1.1. 1.0 diddn't have shadows. Okay if you  "
LOCATE 12, 10
PRINT " want to use these routines, you may, but please put my    "
LOCATE 13, 10
PRINT " name on it below your copyright or something. It's a very "
LOCATE 14, 10
PRINT " fast routine, and lacks only the ALT+Letter routine to    "
LOCATE 15, 10
PRINT " access the menus, which is your job. It is all-QB, so you "
LOCATE 16, 10
PRINT " who don't like to use add-on libs should like this one!   "
COLOR 14
LOCATE 17, 10
PRINT " Have fun,                                                 "
COLOR 15
LOCATE 18, 10
PRINT " - Calvin -                                                "
END SUB

'
'
SUB DrawShadow (x1, y1, x2, y2)
DEF SEG = &HB800
YMem = y2 * 160
XMem = (x2 * 2) + 1
COLOR 8, 0
'
FOR n = x1 + 2 TO x2 + 1
  MemLoc = YMem + n * 2 - 1
  POKE MemLoc, 8
NEXT n
'
FOR n = y1 + 1 TO y2 + 1
  MemLoc = ((n - 1) * 160) + XMem - 2
  POKE MemLoc, 8
  POKE MemLoc + 2, 8
NEXT n
'
DEF SEG
END SUB

'
'
SUB PullDownMenu (y1, TopX1(), BoxX1(), BoxX2(), LastOpt(), MenuDat$(), Fore, Back, SelectFore, SelectBack, hilightfore, hilightback, KeyFore, ReturnX, ReturnY)
DIM CurrY(UBOUND(MenuDat$, 1))
OldX = 1
CurrX = 1
PulledDown = false
DIM HotKey(UBOUND(MenuDat$, 1), UBOUND(MenuDat$, 2))
DIM leftside$(UBOUND(MenuDat$, 1), UBOUND(MenuDat$, 2))
DIM rightside$(UBOUND(MenuDat$, 1), UBOUND(MenuDat$, 2))
'
COLOR Fore, Back
LOCATE y1, 1
PRINT SPACE$(80);
GOSUB PrintTopBar
GOSUB SaveScreen2
'
FOR x = 1 TO UBOUND(MenuDat$, 1)
  FOR y = 1 TO LastOpt(x)
    HotKeyLoc = INSTR(MenuDat$(x, y), "^")
    leftside$(x, y) = MID$(MenuDat$(x, y), 1, HotKeyLoc - 1)
    HotKey(x, y) = ASC(MID$(MenuDat$(x, y), HotKeyLoc + 1))
    rightside$(x, y) = MID$(MenuDat$(x, y), HotKeyLoc + 2)
  NEXT y
NEXT x
'
IF ReturnX > 0 OR ReturnY > 0 THEN
  FOR n = 1 TO UBOUND(MenuDat$, 1)
    CurrY(n) = 1
  NEXT n
  CurrX = ReturnX
  CurrY(CurrX) = ReturnY
  PulledDown = true
  GOSUB PrintCurrentMenu
END IF
'
GOSUB PrintCurrentTop
'
DO
  GOSUB PrintMenu
  '
  DO
    key$ = INKEY$
  LOOP UNTIL LEN(key$)
  '
  KeyCode = ASC(RIGHT$(key$, 1))
  '
  SELECT CASE KeyCode
    CASE 75               'left
      CurrX = CurrX - 1
      IF CurrX < 1 THEN CurrX = UBOUND(MenuDat$, 1)
    CASE 77               'right
      CurrX = CurrX + 1
      IF CurrX > UBOUND(MenuDat$, 1) THEN CurrX = 1
    CASE 72               'up
      IF PulledDown = true THEN
        CurrY(CurrX) = CurrY(CurrX) - 1
        IF MenuDat$(CurrX, CurrY(CurrX)) = "^:" THEN CurrY(CurrX) = CurrY(CurrX) - 1
        IF CurrY(CurrX) < 1 THEN CurrY(CurrX) = LastOpt(CurrX)
        GOSUB PrintCurrentMenu
      END IF
    CASE 80               'down
      IF PulledDown = false THEN
        FOR n = 1 TO UBOUND(MenuDat$, 1)
          CurrY(n) = 1
        NEXT n
        PulledDown = true
      ELSE
        CurrY(CurrX) = CurrY(CurrX) + 1
        IF CurrY(CurrX) > LastOpt(CurrX) THEN CurrY(CurrX) = 1
        IF MenuDat$(CurrX, CurrY(CurrX)) = "^:" THEN CurrY(CurrX) = CurrY(CurrX) + 1
        IF CurrY(CurrX) > LastOpt(CurrX) THEN CurrY(CurrX) = 1
      END IF
      GOSUB PrintCurrentMenu
    CASE 13
      IF PulledDown = true THEN
        GOSUB RestoreScreen2
        ReturnX = CurrX
        ReturnY = CurrY(CurrX)
        EXIT SUB
      ELSE
        PulledDown = true
        FOR n = 1 TO UBOUND(MenuDat$, 1)
          CurrY(n) = 1
        NEXT n
        GOSUB PrintCurrentMenu
      END IF
    CASE ELSE
      KeyCode = KeyCode OR 32
      Search = HotKey(CurrX, CurrY(CurrX)) OR 32
      found = false
      '
      FOR n = CurrY(CurrX) + 1 TO LastOpt(CurrX)
        Search = HotKey(CurrX, n) OR 32
        IF Search = KeyCode THEN
          CurrY(CurrX) = n
          found = true

          EXIT FOR
        END IF
      NEXT
      '
      FOR n = 1 TO CurrY(CurrX)
        Search = HotKey(CurrX, n) OR 32
        IF Search = KeyCode THEN
          IF found = false THEN
            CurrY(CurrX) = n
            found = true
          END IF
          EXIT FOR
        END IF
      NEXT n
      '
      IF found = true THEN
        GOSUB PrintCurrentMenu
        ReturnX = CurrX
        ReturnY = CurrY(CurrX)
        GOSUB RestoreScreen2
        EXIT SUB
      END IF
      '
  END SELECT
  '
LOOP
'
EXIT SUB
'
PrintTopBar:
FOR n = 1 TO UBOUND(MenuDat$, 1)
  LOCATE y1, TopX1(n)
  PRINT MenuDat$(n, 0);
NEXT n
RETURN
'
PrintCurrentTop:
LOCATE y1, TopX1(CurrX)
COLOR SelectFore, SelectBack
PRINT MenuDat$(CurrX, 0);
RETURN
'
SaveScreen2:
PCOPY 0, 2    'PCOPY is very fast, and well suited for this task
RETURN
'
RestoreScreen2:
PCOPY 2, 0    'PCOPY is very fast, and well suited for this task
RETURN
'
PrintMenu:
IF CurrX <> OldX THEN
  GOSUB RestoreScreen2
  GOSUB PrintCurrentTop
  IF PulledDown = true THEN
    GOSUB PrintCurrentMenu
  END IF
END IF
'
OldX = CurrX
'
RETURN
'
PrintCurrentMenu:
'
COLOR Fore, Back
LOCATE y1 + 1, BoxX1(CurrX)
'
PRINT CHR$(218); STRING$(BoxX2(CurrX) - BoxX1(CurrX) - 1, CHR$(196)); CHR$(191)
'
FOR n = 1 TO LastOpt(CurrX)
  LOCATE y1 + n + 1, BoxX1(CurrX)
  PRINT CHR$(179);
  IF MenuDat$(CurrX, n) <> "^:" THEN
    IF n <> CurrY(CurrX) THEN
      COLOR Fore, Back
      PRINT leftside$(CurrX, n);
      COLOR KeyFore, Back
      PRINT CHR$(HotKey(CurrX, n));
      COLOR Fore, Back
      PRINT rightside$(CurrX, n);
      PRINT SPACE$(BoxX2(CurrX) - BoxX1(CurrX) - LEN(MenuDat$(CurrX, n)));
    ELSE
      COLOR hilightfore, hilightback
      PRINT leftside$(CurrX, n);
      COLOR KeyFore, hilightback
      PRINT CHR$(HotKey(CurrX, n));
      COLOR hilightfore, hilightback
      PRINT rightside$(CurrX, n);
      PRINT SPACE$(BoxX2(CurrX) - BoxX1(CurrX) - LEN(MenuDat$(CurrX, n)));
    END IF
    COLOR Fore, Back
    PRINT CHR$(179);
  ELSE
    COLOR Fore, Back
    LOCATE y1 + n + 1, BoxX1(CurrX)
    PRINT CHR$(195); STRING$(BoxX2(CurrX) - BoxX1(CurrX) - 1, CHR$(196)); CHR$(180);
  END IF
NEXT n
'
LOCATE y1 + LastOpt(CurrX) + 2, BoxX1(CurrX)
PRINT CHR$(192); STRING$(BoxX2(CurrX) - BoxX1(CurrX) - 1, CHR$(196)); CHR$(217)
DrawShadow BoxX1(CurrX), y1 + 1, BoxX2(CurrX) + 1, LastOpt(CurrX) + 3
RETURN
END SUB

